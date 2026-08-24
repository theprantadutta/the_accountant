import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    as ui;
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';

import '../helpers/test_database.dart';

/// Moving your own money is not earning or spending it.
///
/// A transfer's two legs are an outgoing row and an incoming row, and anything
/// that reads only the direction the money moved sees a plain expense and a
/// plain income. The Income and Expenses screens read exactly that, so every
/// internal move inflated both headline totals by its full amount — transfer
/// $100 between two of your own wallets and the month claimed $100 more income
/// and $100 more spending than actually happened.
///
/// The fix is that the list the screens read now carries the real kind of each
/// row, so they can ask [TransactionPolicy] instead of guessing from direction.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late String from;
  late String to;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    from = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    to = await seedWallet(db, name: 'Bank', openingBalance: 0);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<List<ui.Transaction>> listed() async {
    await container.read(ui.transactionProvider.notifier).loadTransactions();
    return container.read(ui.transactionProvider).transactions;
  }

  test('a transfer leg is reported as a transfer, not as an expense', () async {
    await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
        );

    final rows = await listed();
    expect(rows, hasLength(2));
    expect(
      rows.every((t) => t.isTransferLeg),
      isTrue,
      reason: 'both legs must be identifiable as transfer legs',
    );
    // The direction field still says what it always said — which is exactly why
    // it was never enough on its own.
    expect(rows.map((t) => t.type).toSet(), {'income', 'expense'});
  });

  test('an ordinary purchase is not mistaken for a transfer', () async {
    final categoryId = await seedCategory(db, name: 'Groceries');
    await seedTransaction(
      db,
      walletId: from,
      categoryId: categoryId,
      amount: 4285,
      title: 'Tesco Metro',
    );

    final rows = await listed();
    expect(rows, hasLength(1));
    expect(rows.single.isTransferLeg, isFalse);
    expect(rows.single.transactionType, TransactionPolicy.regularType);
  });

  test('the fee charged for a transfer IS spending', () async {
    // The move itself costs you nothing; the charge for making it is gone for
    // good, so it has to keep counting towards expenses like any other charge.
    await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
          feeAmount: 250,
        );

    final rows = await listed();
    final fee = rows.singleWhere((t) => !t.isTransferLeg);
    expect(fee.amount, 250);
    expect(fee.type, 'expense');
  });

  test('what an expense screen totals excludes the transfer', () async {
    final categoryId = await seedCategory(db, name: 'Groceries');
    await seedTransaction(
      db,
      walletId: from,
      categoryId: categoryId,
      amount: 4285,
      date: DateTime(2026, 6, 3),
      title: 'Tesco Metro',
    );
    await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
          feeAmount: 250,
        );

    final rows = await listed();

    // The same predicate the Expenses screen applies.
    int totalOf(String direction) => rows
        .where((t) => t.type == direction && !t.isTransferLeg)
        .fold<int>(0, (sum, t) => sum + t.amount);

    expect(
      totalOf('expense'),
      4285 + 250,
      reason: 'the groceries and the charge — not the money moved',
    );
    expect(
      totalOf('income'),
      0,
      reason: 'receiving your own money is not income',
    );
  });
}
