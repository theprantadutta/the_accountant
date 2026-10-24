import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/dashboard/providers/net_worth_preferences_provider.dart';
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/networth/services/net_worth_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

final assetServiceProvider = Provider<AssetService>(
  (ref) => AssetService(ref.watch(databaseProvider)),
);

final netWorthServiceProvider = Provider<NetWorthService>(
  (ref) => NetWorthService(
    ref.watch(databaseProvider),
    ref.watch(currencyServiceProvider),
  ),
);

/// Re-read when transactions or accounts change: a repayment moves what is
/// owed without anything else about the account changing.
void _watchRecords(Ref ref) {
  ref.watch(transactionProvider.select((s) => s.transactions));
  ref.watch(walletProvider.select((s) => s.wallets));
}

/// What the user is worth now, in their own currency. The home card and the
/// net worth screen both read this, so they cannot disagree.
final netWorthProvider = FutureProvider<NetWorthSummary>((ref) async {
  _watchRecords(ref);
  return ref
      .watch(netWorthServiceProvider)
      .summary(
        ref.watch(defaultCurrencyProvider),
        includeCreditCards: ref.watch(creditCardsInNetWorthProvider),
      );
});

/// Month-end net worth over the last [months] months, or all of it for null.
final netWorthHistoryProvider = FutureProvider.autoDispose
    .family<List<NetWorthPoint>, int?>((ref, months) async {
      _watchRecords(ref);
      return ref
          .watch(netWorthServiceProvider)
          .history(
            ref.watch(defaultCurrencyProvider),
            includeCreditCards: ref.watch(creditCardsInNetWorthProvider),
            months: months,
          );
    });

/// Every asset, still owned first.
final assetsProvider = FutureProvider.autoDispose<List<AssetHolding>>((
  ref,
) async {
  _watchRecords(ref);
  return ref.watch(assetServiceProvider).all();
});
