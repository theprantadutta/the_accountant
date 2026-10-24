import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';
import 'package:the_accountant/features/zakat/services/zakat_service.dart';

final zakatServiceProvider = Provider<ZakatService>(
  (ref) => ZakatService(
    ref.watch(databaseProvider),
    ref.watch(currencyServiceProvider),
  ),
);

/// The calculator's settings, read from the device and saved on every change.
class ZakatSettingsNotifier extends AsyncNotifier<ZakatSettings> {
  @override
  Future<ZakatSettings> build() => ZakatSettingsStore.load();

  Future<void> change(ZakatSettings Function(ZakatSettings) edit) async {
    final current = state.value ?? await future;
    final next = edit(current);
    state = AsyncData(next);
    await ZakatSettingsStore.save(next);
  }
}

final zakatSettingsProvider =
    AsyncNotifierProvider<ZakatSettingsNotifier, ZakatSettings>(
      ZakatSettingsNotifier.new,
    );

/// The calculation as it stands.
///
/// Re-read when transactions or accounts change: a payment, a loan repaid
/// and a new price on a holding all move it, wherever they were made.
final zakatReportProvider = FutureProvider.autoDispose<ZakatReport>((
  ref,
) async {
  ref.watch(transactionProvider.select((s) => s.transactions));
  ref.watch(walletProvider.select((s) => s.wallets));
  final settings = await ref.watch(zakatSettingsProvider.future);
  return ref
      .watch(zakatServiceProvider)
      .compute(settings, currency: ref.watch(defaultCurrencyProvider));
});
