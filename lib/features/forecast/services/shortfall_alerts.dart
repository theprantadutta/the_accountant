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
class ShortfallAlerts {
  ShortfallAlerts(this._prefs);

  final SharedPreferences _prefs;

  /// The shortfall dates already told about, as yyyy-MM-dd.
  static const storageKey = 'forecast_shortfall_notified';

  /// How close a shortfall has to be to be worth a notification.
  static const noticeDays = 7;

  /// The shortfall in [forecast] to tell the user about now, or null when
  /// there is none within [noticeDays] or it has been told about already.
  /// A shortfall returned here is recorded as told.
  Future<ForecastDay?> claim(CashFlowForecast forecast) async {
    final told = _prefs.getStringList(storageKey) ?? const [];
    // Dates that have passed can never come up again.
    final kept = [
      for (final d in told)
        if (!(DateTime.tryParse(d)?.isBefore(forecast.start) ?? true)) d,
    ];
    final shortfall = forecast.shortfall;
    final key = shortfall == null ? null : _key(shortfall.date);
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
    await show(
      id: notificationIdFor(shortfall.date),
      title: l10n.forecastNotifTitle(day),
      body: l10n.forecastNotifBody(amount),
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

  static String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
