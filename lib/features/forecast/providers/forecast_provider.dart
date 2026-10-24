import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

final cashFlowForecastServiceProvider = Provider<CashFlowForecastService>(
  (ref) => CashFlowForecastService(ref.watch(databaseProvider)),
);

/// The forecast over the next number of days given.
///
/// Re-read when transactions or accounts change: paying a bill, recording an
/// installment or editing a schedule all move what is coming.
final cashFlowForecastProvider = FutureProvider.autoDispose
    .family<CashFlowForecast, int>((ref, days) async {
      ref.watch(transactionProvider.select((s) => s.transactions));
      ref.watch(walletProvider.select((s) => s.wallets));
      return ref.watch(cashFlowForecastServiceProvider).forecast(days: days);
    });

/// How close a shortfall has to be to show on the home screen.
const homeShortfallDays = 14;

/// The forecast to warn about on the home screen: one with a shortfall in the
/// next [homeShortfallDays] days that has not been dismissed. Null otherwise,
/// including while it is worked out, so the home screen never waits on it.
final homeShortfallProvider = Provider.autoDispose<CashFlowForecast?>((ref) {
  final forecast = ref
      .watch(cashFlowForecastProvider(CashFlowForecastService.ranges.first))
      .value;
  final shortfall = forecast?.shortfall;
  if (forecast == null ||
      shortfall == null ||
      !forecast.shortfallWithin(homeShortfallDays)) {
    return null;
  }
  final dismissed = ref.watch(dismissedShortfallProvider);
  return dismissed == ShortfallDismissal.keyFor(shortfall.date)
      ? null
      : forecast;
});

/// The shortfall date the home warning was dismissed for.
///
/// Dismissing is for that date only: if the shortfall moves, or a new one
/// appears, it is a different warning and shows again.
class ShortfallDismissal extends StateNotifier<String?> {
  ShortfallDismissal() : super(null) {
    _load();
  }

  static const String prefKey = 'forecast_shortfall_dismissed';

  static String keyFor(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getString(prefKey);
    } catch (_) {
      // Not remembering a dismissal only means the warning shows again.
    }
  }

  Future<void> dismiss(DateTime shortfallDate) async {
    state = keyFor(shortfallDate);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefKey, state!);
    } catch (_) {
      // As above.
    }
  }
}

final dismissedShortfallProvider =
    StateNotifierProvider<ShortfallDismissal, String?>(
      (ref) => ShortfallDismissal(),
    );
