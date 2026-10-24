import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// What the nisab is measured against.
///
/// Silver is the default: its nisab is far lower, so it brings more people
/// over the line, which is the cautious reading most scholars give for
/// someone whose wealth is mostly cash.
enum NisabBasis { gold, silver }

/// The nisab weights, in grams: 7.5 tola of gold and 52.5 tola of silver.
extension NisabBasisWeight on NisabBasis {
  double get grams => switch (this) {
    NisabBasis.gold => 87.48,
    NisabBasis.silver => 612.36,
  };
}

/// An amount the user adds by hand: stock held for trade, cash at home that
/// no account tracks, or a bill due now that the app does not know about.
class ZakatManualItem {
  const ZakatManualItem({
    required this.id,
    required this.label,
    required this.amount,
    this.deduct = false,
  });

  final String id;
  final String label;

  /// In minor units of the user's own currency.
  final int amount;

  /// Owed rather than owned, so it comes off the wealth.
  final bool deduct;

  Map<String, Object?> toJson() => {
    'id': id,
    'label': label,
    'amount': amount,
    'deduct': deduct,
  };

  static ZakatManualItem? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final label = json['label'];
    final amount = json['amount'];
    if (id is! String || label is! String || amount is! int) return null;
    return ZakatManualItem(
      id: id,
      label: label,
      amount: amount,
      deduct: json['deduct'] == true,
    );
  }
}

/// Everything the zakat calculator remembers between visits.
class ZakatSettings {
  const ZakatSettings({
    this.basis = NisabBasis.silver,
    this.goldPricePerGram = 0,
    this.silverPricePerGram = 0,
    this.switches = const {},
    this.manual = const [],
    this.zakatDate,
    this.remind = true,
  });

  final NisabBasis basis;

  /// Prices the user entered, in minor units of their own currency. Both are
  /// kept so switching the basis back and forth does not lose either.
  final int goldPricePerGram;
  final int silverPricePerGram;

  /// Lines the user switched away from their default, by line key.
  final Map<String, bool> switches;

  final List<ZakatManualItem> manual;

  /// A day the user's zakat year completes on. Any of them will do: the
  /// others follow every lunar year from it.
  final DateTime? zakatDate;

  /// Whether to remind a few days before the zakat date and on it.
  final bool remind;

  int get pricePerGram =>
      basis == NisabBasis.gold ? goldPricePerGram : silverPricePerGram;

  /// The nisab in minor units, or null until a price is known.
  int? get nisab =>
      pricePerGram <= 0 ? null : (pricePerGram * basis.grams).round();

  ZakatSettings copyWith({
    NisabBasis? basis,
    int? goldPricePerGram,
    int? silverPricePerGram,
    Map<String, bool>? switches,
    List<ZakatManualItem>? manual,
    DateTime? zakatDate,
    bool clearZakatDate = false,
    bool? remind,
  }) => ZakatSettings(
    basis: basis ?? this.basis,
    goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
    silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
    switches: switches ?? this.switches,
    manual: manual ?? this.manual,
    zakatDate: clearZakatDate ? null : (zakatDate ?? this.zakatDate),
    remind: remind ?? this.remind,
  );

  /// The price per gram for the current basis set to [price].
  ZakatSettings withPrice(int price) => basis == NisabBasis.gold
      ? copyWith(goldPricePerGram: price)
      : copyWith(silverPricePerGram: price);

  /// [key] switched [on]. A switch back to its default is forgotten rather
  /// than stored, so a later change of default reaches it.
  ZakatSettings withSwitch(
    String key, {
    required bool on,
    required bool byDefault,
  }) {
    final next = Map<String, bool>.of(switches);
    if (on == byDefault) {
      next.remove(key);
    } else {
      next[key] = on;
    }
    return copyWith(switches: next);
  }

  Map<String, Object?> toJson() => {
    'basis': basis.name,
    'goldPricePerGram': goldPricePerGram,
    'silverPricePerGram': silverPricePerGram,
    'switches': switches,
    'manual': [for (final m in manual) m.toJson()],
    if (zakatDate != null) 'zakatDate': ZakatCalendar.dayKey(zakatDate!),
    'remind': remind,
  };

  /// Read back what [toJson] wrote. Anything unreadable falls back to its
  /// default rather than losing the rest.
  factory ZakatSettings.fromJson(Map<String, Object?> json) {
    final switches = <String, bool>{};
    final rawSwitches = json['switches'];
    if (rawSwitches is Map) {
      rawSwitches.forEach((k, v) {
        if (k is String && v is bool) switches[k] = v;
      });
    }
    final rawManual = json['manual'];
    final date = json['zakatDate'];
    return ZakatSettings(
      basis: json['basis'] == NisabBasis.gold.name
          ? NisabBasis.gold
          : NisabBasis.silver,
      goldPricePerGram: _int(json['goldPricePerGram']),
      silverPricePerGram: _int(json['silverPricePerGram']),
      switches: switches,
      manual: rawManual is List
          ? [for (final m in rawManual) ?ZakatManualItem.fromJson(m)]
          : const [],
      zakatDate: date is String ? DateTime.tryParse(date) : null,
      remind: json['remind'] != false,
    );
  }

  static int _int(Object? v) => v is int && v > 0 ? v : 0;
}

/// Where the zakat settings are kept: on this device, with the app's other
/// small preferences.
///
/// Static and Riverpod-free, so the background reminder check and the coach
/// read exactly what the screen wrote.
class ZakatSettingsStore {
  const ZakatSettingsStore._();

  static const String prefKey = 'zakat_settings';

  static Future<ZakatSettings> load([SharedPreferences? prefs]) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    final raw = p.getString(prefKey);
    if (raw == null) return const ZakatSettings();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, Object?>) {
        return ZakatSettings.fromJson(decoded);
      }
    } catch (_) {
      // A value that cannot be read is no reason to stop the calculator
      // working; it starts again from the defaults.
    }
    return const ZakatSettings();
  }

  static Future<void> save(
    ZakatSettings settings, [
    SharedPreferences? prefs,
  ]) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    await p.setString(prefKey, jsonEncode(settings.toJson()));
  }
}

/// The zakat year: it completes every lunar year after the day the user set.
class ZakatCalendar {
  const ZakatCalendar._();

  /// A lunar year, to the nearest day.
  static const int lunarYearDays = 354;

  /// The zakat dates either side of [today]: the last one on or before it,
  /// and the next one after it.
  ///
  /// [anchor] can be any zakat date, past or future. Days are counted on the
  /// calendar rather than in hours, so a clock change cannot move one.
  static (DateTime last, DateTime next) around(
    DateTime anchor,
    DateTime today,
  ) {
    final a = DateTime.utc(anchor.year, anchor.month, anchor.day);
    final t = DateTime.utc(today.year, today.month, today.day);
    final years = (t.difference(a).inDays / lunarYearDays).floor();
    final last = _addDays(anchor, years * lunarYearDays);
    return (last, _addDays(last, lunarYearDays));
  }

  /// When the current zakat year began, for counting what has been paid
  /// toward it. Without a zakat date, the last lunar year up to [today].
  static DateTime yearStart(DateTime? anchor, DateTime today) => anchor == null
      ? _addDays(today, -lunarYearDays)
      : around(anchor, today).$1;

  /// The next zakat date after [today], or null when none is set.
  static DateTime? nextDate(DateTime? anchor, DateTime today) =>
      anchor == null ? null : around(anchor, today).$2;

  static DateTime _addDays(DateTime d, int days) {
    final u = DateTime.utc(d.year, d.month, d.day + days);
    return DateTime(u.year, u.month, u.day);
  }

  static String dayKey(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
