import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    as ui;
import 'package:the_accountant/features/wallets/services/wallet_maintenance_service.dart';

import '../helpers/test_database.dart';

/// Correcting the record of your money is not earning or spending it.
///
/// A balance correction moves an account to what the bank says, and it has to
/// move the balance to do that. But it is not a purchase and not a salary:
/// counted as either, a month spent reconciling accounts read as overspending
/// and a large opening correction showed up as income nobody earned.
///
/// The category is what makes a row a correction. The kind is derived from it
/// by a trigger, so every route a row can take into or out of that category —
/// the correction sheet, an edit, a pull, a restore — leaves it classified.
void main() {
  late AppDatabase db;
  late String wallet;
  late String correctionCategory;
  late String food;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    correctionCategory = await db.requireSystemCategoryId(
      SystemCategoryKeys.balanceCorrection,
    );
    food = await seedCategory(db, name: 'Food');
  });

  tearDown(() => db.close());

  Future<Transaction> row(String id) async =>
      (await db.findTransactionById(id))!;

  test(
    'a correction moves the balance but is neither income nor spending',
    () async {
      final id = await WalletMaintenanceService(
        db,
      ).correctBalance(walletId: wallet, actualBalance: 70000);

      final correction = await row(id!);
      expect(TransactionPolicy.isAdjustment(correction), isTrue);
      expect(TransactionPolicy.walletBalanceEffect(correction), -30000);
      expect(TransactionPolicy.countsInAnalytics(correction), isFalse);
      expect(TransactionPolicy.totalExpense([correction]), 0);
      expect((await db.findWalletById(wallet))!.balance, 70000);
    },
  );

  test('filing a row under the correction category makes it one, and '
      'filing it elsewhere undoes that', () async {
    final id = await seedTransaction(db, walletId: wallet, categoryId: food);
    expect(TransactionPolicy.isAdjustment(await row(id)), isFalse);

    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(categoryId: Value(correctionCategory)),
    );
    expect(TransactionPolicy.isAdjustment(await row(id)), isTrue);

    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(categoryId: Value(food)),
    );
    expect(TransactionPolicy.kindOf(await row(id)).storageValue, 'regular');
  });

  test('a pulled row that never said what it was is classified without '
      'being marked as an edit', () async {
    // An older build writes corrections as plain regular rows.
    final id = await seedTransaction(
      db,
      walletId: wallet,
      categoryId: correctionCategory,
      syncStatus: SyncStatus.synced,
    );

    final pulled = await row(id);
    expect(TransactionPolicy.isAdjustment(pulled), isTrue);
    expect(pulled.syncStatus, SyncStatus.synced);
  });

  test('a transfer leg keeps its kind wherever it is filed', () async {
    final id = await seedTransaction(
      db,
      walletId: wallet,
      categoryId: correctionCategory,
      transactionType: TransactionPolicy.transferType,
    );
    expect(TransactionPolicy.isTransfer(await row(id)), isTrue);
  });

  test('the transaction list leaves corrections out of its totals', () async {
    await WalletMaintenanceService(
      db,
    ).correctBalance(walletId: wallet, actualBalance: 150000);
    await seedTransaction(db, walletId: wallet, categoryId: food, amount: 500);

    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    await container.read(ui.transactionProvider.notifier).loadTransactions();
    final rows = container.read(ui.transactionProvider).transactions;

    expect(rows, hasLength(2));
    expect(rows.where((t) => t.countsInAnalytics).map((t) => t.amount), [500]);
  });

  test(
    'rows written before the trigger existed are classified on open',
    () async {
      final dir = await Directory.systemTemp.createTemp('adjustment_kind');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/store.sqlite');

      var store = AppDatabase(NativeDatabase(file));
      await store.ensureSystemCategoriesExist();
      final category = await store.requireSystemCategoryId(
        SystemCategoryKeys.balanceCorrection,
      );
      final account = await seedWallet(store);
      // Recreate the state of a store from before this release.
      await store.customStatement(
        'DROP TRIGGER trg_transactions_adjustment_kind_insert',
      );
      final id = await seedTransaction(
        store,
        walletId: account,
        categoryId: category,
      );
      expect((await store.findTransactionById(id))!.transactionType, 'regular');
      await store.close();

      store = AppDatabase(NativeDatabase(file));
      addTearDown(store.close);
      final upgraded = (await store.findTransactionById(id))!;
      expect(TransactionPolicy.isAdjustment(upgraded), isTrue);
    },
  );
}
