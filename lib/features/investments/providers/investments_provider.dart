import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

final investmentServiceProvider = Provider<InvestmentService>(
  (ref) => InvestmentService(ref.watch(databaseProvider)),
);

/// Every holding with what it is worth, oldest first.
///
/// Re-read when transactions or accounts change: a trade, a new price and a
/// SIP buy all move the holding's account, wherever they were made.
final investmentsProvider = FutureProvider.autoDispose<List<InvestmentHolding>>(
  (ref) async {
    ref.watch(transactionProvider.select((s) => s.transactions));
    ref.watch(walletProvider.select((s) => s.wallets));
    return ref.watch(investmentServiceProvider).holdings();
  },
);

/// One holding, or null once it is gone.
final investmentHoldingProvider = FutureProvider.autoDispose
    .family<InvestmentHolding?, String>((ref, id) async {
      final all = await ref.watch(investmentsProvider.future);
      return all.where((h) => h.investment.id == id).firstOrNull;
    });

/// One holding's buys, sells and price updates, newest first.
final investmentTradesProvider = FutureProvider.autoDispose
    .family<List<InvestmentTrade>, String>((ref, id) async {
      final holding = await ref.watch(investmentHoldingProvider(id).future);
      if (holding == null) return const [];
      return ref.watch(investmentServiceProvider).tradesOf(holding.investment);
    });
