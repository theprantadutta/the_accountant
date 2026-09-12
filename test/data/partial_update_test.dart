import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/test_database.dart';

/// What `updateX(XCompanion)` does to the columns the caller left out.
///
/// These used to call drift's `replace`, which writes the whole row: an absent
/// column is not skipped, it is written back to the column's declared default.
/// Every caller in the app builds a partial companion, so `replace` reset
/// whatever that caller had not thought to carry forward — and, for a column
/// that is required and has no default, threw instead, into a catch block that
/// put the error in a field nothing reads.
///
/// The assertions below are deliberately about columns the update does *not*
/// mention. That is the whole bug: what it says it changes was never the
/// problem.
void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() async => db.close());

  group('wallets', () {
    test('archiving an account actually archives it', () async {
      final id = await seedWallet(db, name: 'Everyday');

      // Exactly what `WalletNotifier.setArchived` sends: the flag and nothing
      // else. `replace` rejected this outright — "name: This value was
      // required, but isn't present" — so closing an account did nothing.
      final wrote = await db.updateWallet(
        WalletsCompanion(
          id: Value(id),
          isArchived: const Value(true),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );

      expect(wrote, isTrue);
      final wallet = (await db.getAllWallets()).single;
      expect(wallet.isArchived, isTrue);
      expect(wallet.name, 'Everyday', reason: 'the name is not the edit');
    });

    test('renaming an account keeps everything it did not mention', () async {
      final id = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
      await db.customStatement(
        'UPDATE wallets SET order_index = 7, exclude_from_total = 1, '
        'is_archived = 1 WHERE id = ?',
        [id],
      );

      // The fields the edit sheet collects. Note what is missing: the opening
      // balance, the position in the list, and the two flags.
      await db.updateWallet(
        WalletsCompanion(
          id: Value(id),
          name: const Value('Renamed'),
          currency: const Value('USD'),
          balance: const Value(500),
          iconName: const Value('wallet'),
          color: const Value('#ffffff'),
          isDefault: const Value(false),
          useDecimals: const Value(true),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final wallet = (await db.getAllWallets()).single;
      expect(wallet.name, 'Renamed');
      expect(
        wallet.openingBalance,
        100000,
        reason: 'zeroing this re-prices every balance recalculation',
      );
      expect(wallet.orderIndex, 7);
      expect(wallet.excludeFromTotal, isTrue);
      expect(wallet.isArchived, isTrue);
    });
  });

  group('transactions', () {
    test('editing a debt keeps how much of it has been settled', () async {
      final walletId = await seedWallet(db);
      final categoryId = await seedCategory(db);
      final id = await seedTransaction(
        db,
        walletId: walletId,
        categoryId: categoryId,
        title: 'Loan to Rafi',
        amount: 50000,
        specialType: TransactionSpecialType.debt,
        paidAmount: 20000,
      );

      // `TransactionNotifier.updateTransaction` carries a long list of columns
      // forward by hand — and `paidAmount` is not on it, because the list was
      // written to satisfy `replace` rather than derived from the table.
      await db.updateTransaction(
        TransactionsCompanion(
          id: Value(id),
          title: const Value('Loan to Rafi (May)'),
          amount: const Value(50000),
          specialType: const Value(TransactionSpecialType.debt),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final tx = (await db.getAllTransactions()).single;
      expect(tx.title, 'Loan to Rafi (May)');
      expect(
        tx.paidAmount,
        20000,
        reason: 'the settled part of a debt is not something a rename clears',
      );
    });
  });

  group('categories', () {
    test('renaming a category keeps its place and its colour', () async {
      final id = await seedCategory(db, name: 'Groceries');
      await db.customStatement(
        "UPDATE categories SET order_index = 4, color = '#123456' WHERE id = ?",
        [id],
      );

      await db.updateCategory(
        CategoriesCompanion(
          id: Value(id),
          name: const Value('Food'),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final category = (await db.getAllCategories()).firstWhere(
        (c) => c.id == id,
      );
      expect(category.name, 'Food');
      expect(category.orderIndex, 4);
      expect(category.color, '#123456');
    });
  });

  test('updating a row that is not there reports that it was not', () async {
    final wrote = await db.updateWallet(
      const WalletsCompanion(id: Value('no-such-wallet'), name: Value('Ghost')),
    );
    expect(wrote, isFalse);
  });
}
