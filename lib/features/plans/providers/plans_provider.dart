import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

final planServiceProvider = Provider<PlanService>(
  (ref) => PlanService(ref.watch(databaseProvider)),
);

/// Every plan with where it stands, oldest first.
///
/// Re-read when transactions or accounts change, so an installment recorded
/// anywhere (the collector, the coach, sync) shows straight away.
final plansProvider = FutureProvider.autoDispose<List<PlanProgress>>((
  ref,
) async {
  ref.watch(transactionProvider.select((s) => s.transactions));
  ref.watch(walletProvider.select((s) => s.wallets));
  final service = ref.watch(planServiceProvider);
  return [
    for (final plan in await service.allPlans()) await service.progressOf(plan),
  ];
});

/// One plan, or null once it is gone.
final planProgressProvider = FutureProvider.autoDispose
    .family<PlanProgress?, String>((ref, id) async {
      final all = await ref.watch(plansProvider.future);
      return all.where((p) => p.plan.id == id).firstOrNull;
    });
