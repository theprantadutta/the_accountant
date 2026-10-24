import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Transaction;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/split/services/split_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    show transactionProvider;

final splitServiceProvider = Provider<SplitService>(
  (ref) => SplitService(ref.watch(databaseProvider)),
);

/// Everyone already in Lend & borrow, to offer when splitting a bill.
///
/// Re-read when transactions change, so someone added on one split is offered
/// on the next.
final splitPeopleProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  ref.watch(transactionProvider.select((s) => s.transactions));
  return ref.watch(splitServiceProvider).knownPeople();
});

/// The rows a split was written as, for showing them together.
final splitPartsProvider = FutureProvider.autoDispose
    .family<List<Transaction>, String>((ref, splitId) async {
      ref.watch(transactionProvider.select((s) => s.transactions));
      return ref.watch(splitServiceProvider).partsOf(splitId);
    });
