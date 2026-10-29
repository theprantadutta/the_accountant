import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// Shows a notification; the caller decides how, since the app and the
/// background worker each have their own way of posting one.
typedef ShowShortfall =
    Future<void> Function({
      required int id,
      required String title,
      required String body,
    });

/// Warns once when the scheduled payments of the coming week would take
/// spendable money below zero.
///
/// Once per shortfall date: the check runs on every start, every return to
/// the app and every background run, and the same warning each time would
/// soon be ignored. A different date is a different situation and is told
/// about again.
///
/// Except when the money is short already. The forecast puts anything overdue
/// on today, so the shortfall's date was today on every day it lasted, and
/// each morning brought a "new" date and the same warning again. That is told
/// once, as being short now, until the accounts recover.
class ShortfallAlerts {
  ShortfallAlerts(this._prefs);

  final SharedPreferences _prefs;

  /// The shortfall dates already told about, as yyyy-MM-dd, and [_nowKey]
  /// while the money is short today.
  static const storageKey = 'forecast_shortfall_notified';

  static const _nowKey = 'now';

  /// How close a shortfall has to be to be worth a notification.
  static const noticeDays = 7;

  /// The shortfall in [forecast] to tell the user about now, or null when
  /// there is none within [noticeDays] or it has been told about already.
  /// A shortfall returned here is recorded as told.
  Future<ForecastDay?> claim(CashFlowForecast forecast) async {
    // The background task may have just told it; each side caches its own.
    await _prefs.reload();
    final told = _prefs.getStringList(storageKey) ?? const [];
    final shortfall = forecast.shortfall;
    final shortNow = shortfall != null && isToday(forecast, shortfall);
    // Dates that have passed can never come up again, and being short now is
    // forgotten once it is over, so it is told about if it comes back.
    final kept = [
      for (final d in told)
        if (d == _nowKey
            ? shortNow
            : !(DateTime.tryParse(d)?.isBefore(forecast.start) ?? true))
          d,
    ];
    final key = shortfall == null
        ? null
        : shortNow
        ? _nowKey
        : _key(shortfall.date);
    // Warned of while it was coming: its day arriving is not news, and the
    // days after it, still short, are not either.
    final warnedAhead = shortNow && kept.contains(_key(forecast.start));
    if (warnedAhead && !kept.contains(_nowKey)) kept.add(_nowKey);
    final fresh =
        key != null &&
        forecast.shortfallWithin(noticeDays) &&
        !kept.contains(key);
    if (fresh) kept.add(key);
    if (fresh || kept.length != told.length) {
      await _prefs.setStringList(storageKey, kept);
    }
    return fresh ? shortfall : null;
  }

  /// Work out the forecast and warn if a new shortfall is coming within the
  /// week. Returns whether a notification was shown.
  static Future<bool> check({
    required AppDatabase db,
    required SharedPreferences prefs,
    required ShowShortfall show,
    DateTime? now,
  }) async {
    final forecast = await CashFlowForecastService(
      db,
    ).forecast(days: noticeDays, now: now);
    final shortfall = await ShortfallAlerts(prefs).claim(forecast);
    if (shortfall == null) return false;

    final l10n = localizationsFor(prefs);
    await initializeDateFormatting(l10n.localeName);
    final settings = await db.getSettings();
    final amount = forecast.shortfallAmount.formatCurrency(
      forecast.currency,
      numberFormat: settings?.numberFormat ?? 'comma_dot',
    );
    final day = DateFormat('d MMM', l10n.localeName).format(shortfall.date);
    final shortNow = isToday(forecast, shortfall);
    await show(
      id: notificationIdFor(shortfall.date),
      title: shortNow
          ? l10n.forecastNotifNowTitle
          : l10n.forecastNotifTitle(day),
      body: shortNow
          ? l10n.forecastNotifNowBody(amount)
          : l10n.forecastNotifBody(amount),
    );
    return true;
  }

  /// One id per date, so a second warning for the same day replaces the
  /// first rather than stacking up beside it.
  static int notificationIdFor(DateTime day) =>
      9000 + (day.month * 31 + day.day) % 400;

  /// The app's language without a widget tree: the one chosen in settings,
  /// or the phone's.
  static L10n localizationsFor(SharedPreferences prefs) {
    final chosen = prefs.getString(LocaleNotifier.storageKey);
    final locale = chosen != null && AppLanguages.names.containsKey(chosen)
        ? Locale(chosen)
        : AppLanguages.resolve(
            PlatformDispatcher.instance.locales,
            L10n.supportedLocales,
          );
    return lookupL10n(locale);
  }

  /// Whether [day] is the forecast's first day: the money is short already.
  static bool isToday(CashFlowForecast forecast, ForecastDay day) =>
      _key(day.date) == _key(forecast.start);

  static String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
