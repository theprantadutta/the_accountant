import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TransferService transfers;
  late WalletBalanceService balances;
  late String sourceId;
  late String destId;

  setUp(() async {
    db = openTestDatabase();
    transfers = TransferService(db);
    balances = WalletBalanceService(db);
    await db.ensureSystemCategoriesExist();
    sourceId = await seedWallet(db, name: 'Checking', openingBalance: 50000);
    destId = await seedWallet(db, name: 'Savings', openingBalance: 10000);
  });

  tearDown(() => db.close());

  group('create', () {
    test('writes two reciprocal legs and moves both balances', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );

      final expense = await db.findTransactionById(expenseId);
      final income = await db.findTransactionById(incomeId);

      expect(expense!.pairedTransactionId, incomeId);
      expect(income!.pairedTransactionId, expenseId);
      expect(expense.isIncome, isFalse);
      expect(income.isIncome, isTrue);
      expect(expense.amount, income.amount);
      expect(TransactionPolicy.isTransfer(expense), isTrue);
      expect(TransactionPolicy.isTransfer(income), isTrue);

      expect(await balances.calculateWalletBalance(sourceId), 50000 - 7500);
      expect(await balances.calculateWalletBalance(destId), 10000 + 7500);
    });

    test(
      'uses a synchronizable GUID category, not a sentinel string',
      () async {
        final (expenseId, _) = await transfers.createTransfer(
          sourceWalletId: sourceId,
          destinationWalletId: destId,
          amount: 100,
          date: DateTime(2026, 3, 1),
        );

        final expense = await db.findTransactionById(expenseId);
        final transferCategory = await db.findCategoryByDefaultKey(
          SystemCategories.transferKey,
        );
        expect(expense!.categoryId, transferCategory!.id);
        expect(
          expense.categoryId,
          isNot(SystemCategories.legacyTransferCategoryId),
        );
        // Not a globally fixed id either — that collides across users on the
        // backend, whose category primary key is global.
        expect(
          expense.categoryId,
          isNot(SystemCategories.legacyFixedTransferCategoryId),
        );

        // The referenced category must actually exist locally AND be queued for
        // upload, or the backend rejects the transaction.
        final category = await db.findCategoryById(expense.categoryId!);
        expect(category, isNotNull);
        expect(category!.syncStatus, SyncStatus.pendingCreate);
      },
    );

    test('rejects same-wallet and non-positive transfers', () async {
      expect(
        () => transfers.createTransfer(
          sourceWalletId: sourceId,
          destinationWalletId: sourceId,
          amount: 100,
          date: DateTime(2026, 3, 1),
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => transfers.createTransfer(
          sourceWalletId: sourceId,
          destinationWalletId: destId,
          amount: 0,
          date: DateTime(2026, 3, 1),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('leaves nothing behind when a wallet does not exist', () async {
      await expectLater(
        transfers.createTransfer(
          sourceWalletId: sourceId,
          destinationWalletId: 'does-not-exist',
          amount: 500,
          date: DateTime(2026, 3, 1),
        ),
        // An ArgumentError now, and thrown before any write: naming a wallet
        // that is not there is a bad argument, and the currency check has to
        // load both wallets anyway, so it is caught at the door rather than
        // part-way through.
        throwsArgumentError,
      );

      // The whole operation runs in one database transaction, so a failure
      // cannot leave a half transfer behind either way.
      expect(await transfers.getTransferTransactions(), isEmpty);
      expect(await balances.calculateWalletBalance(sourceId), 50000);
    });
  });

  group('update', () {
    test('changes BOTH legs and keeps the pair consistent', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );

      await transfers.updateTransfer(
        transactionId: incomeId, // edit from the incoming side
        amount: 2500,
        title: 'Moved less',
        notes: 'revised',
        date: DateTime(2026, 4, 2),
      );

      final expense = await db.findTransactionById(expenseId);
      final income = await db.findTransactionById(incomeId);

      expect(expense!.amount, 2500);
      expect(income!.amount, 2500);
      expect(expense.title, 'Moved less');
      expect(income.title, 'Moved less');
      expect(expense.notes, 'revised');
      expect(expense.date, DateTime(2026, 4, 2));
      expect(income.date, DateTime(2026, 4, 2));
      expect(expense.isIncome, isFalse);
      expect(income.isIncome, isTrue);
      expect(expense.pairedTransactionId, incomeId);
      expect(income.pairedTransactionId, expenseId);

      expect(await balances.calculateWalletBalance(sourceId), 50000 - 2500);
      expect(await balances.calculateWalletBalance(destId), 10000 + 2500);
      expect(await transfers.validateAllTransfers(), isEmpty);
    });

    test('re-pointing a leg recomputes the old and new wallets', () async {
      final thirdId = await seedWallet(db, name: 'Travel', openingBalance: 0);
      final (expenseId, _) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 5000,
        date: DateTime(2026, 3, 1),
      );

      await transfers.updateTransfer(
        transactionId: expenseId,
        destinationWalletId: thirdId,
      );

      expect(await balances.calculateWalletBalance(sourceId), 45000);
      expect(await balances.calculateWalletBalance(destId), 10000);
      expect(await balances.calculateWalletBalance(thirdId), 5000);
    });

    test('refuses to edit a transfer whose partner is gone', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 5000,
        date: DateTime(2026, 3, 1),
      );
      await db.deleteTransaction(incomeId);

      await expectLater(
        transfers.updateTransfer(transactionId: expenseId, amount: 1),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'a still-unpushed leg stays pending-create, not pending-update',
      () async {
        final (expenseId, _) = await transfers.createTransfer(
          sourceWalletId: sourceId,
          destinationWalletId: destId,
          amount: 5000,
          date: DateTime(2026, 3, 1),
        );

        await transfers.updateTransfer(transactionId: expenseId, amount: 6000);

        final expense = await db.findTransactionById(expenseId);
        expect(
          expense!.syncStatus,
          SyncStatus.pendingCreate,
          reason: 'the server has never seen this row; an update would 404',
        );
      },
    );
  });

  /// Undoing a delete, which used to undo less than the delete did.
  ///
  /// Clearing one tombstone put the row back on the screen without putting the
  /// money back in the wallet, and put back whichever leg of a transfer the
  /// user tapped without its partner.
  group('restore', () {
    test('puts the money back in the wallet', () async {
      final id = await seedTransaction(
        db,
        walletId: sourceId,
        amount: 7500,
        isIncome: false,
      );
      await balances.updateWalletBalance(sourceId);
      final before = (await db.findWalletById(sourceId))!.balance;

      await transfers.deleteTransfer(id);
      await transfers.restoreTransaction(id);

      expect(
        (await db.findWalletById(sourceId))!.balance,
        before,
        reason:
            'every screen reads the stored balance, so a restore that only '
            'clears the tombstone understates the wallet by the restored '
            'amount until something unrelated happens to recalculate it',
      );
    });

    test('brings back both legs of a transfer, not just the one tapped', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );
      await transfers.deleteTransfer(expenseId);

      // The user restores the incoming side; the outgoing side has to follow.
      await transfers.restoreTransaction(incomeId);

      expect((await db.findTransactionById(expenseId))!.deletedAt, isNull);
      expect((await db.findTransactionById(incomeId))!.deletedAt, isNull);

      final expense = await db.findTransactionById(expenseId);
      final income = await db.findTransactionById(incomeId);
      expect(
        TransferIntegrity.validatePair(expense!, income),
        isEmpty,
        reason:
            'one leg alone is money that left a wallet and arrived nowhere; '
            'the server rejects it, so it could not sync either',
      );

      expect(await balances.calculateWalletBalance(sourceId), 50000 - 7500);
      expect(await balances.calculateWalletBalance(destId), 10000 + 7500);
      expect((await db.findWalletById(sourceId))!.balance, 50000 - 7500);
      expect((await db.findWalletById(destId))!.balance, 10000 + 7500);
    });

    test('brings the fee back with the transfer that incurred it', () async {
      final (expenseId, _) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
        feeAmount: 250,
        feeWalletId: sourceId,
      );
      final fee = await db.findFeeForTransfer(expenseId);
      expect(fee, isNotNull);

      await transfers.deleteTransfer(expenseId);
      await transfers.restoreTransaction(expenseId);

      expect(
        (await db.findTransactionById(fee!.id))!.deletedAt,
        isNull,
        reason:
            'the charge and the transfer were one action; leaving the fee '
            'deleted loses money the user really paid',
      );
      expect(await balances.calculateWalletBalance(sourceId), 50000 - 7500 - 250);
    });

    test('restoring an ordinary transaction is a group of one', () async {
      final id = await seedTransaction(db, walletId: destId, amount: 1200);
      await transfers.deleteTransfer(id);

      await transfers.restoreTransaction(id);

      expect((await db.findTransactionById(id))!.deletedAt, isNull);
      expect(
        (await db.findWalletById(destId))!.balance,
        await balances.calculateWalletBalance(destId),
      );
    });

    test('restoring something already gone does nothing', () async {
      await transfers.restoreTransaction('no-such-row');
      expect(await db.getRecentlyDeletedTransactions(), isEmpty);
    });
  });

  group('delete', () {
    test('tombstones both legs and restores both balances', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );

      await transfers.deleteTransfer(expenseId);

      final expense = await db.findTransactionById(expenseId);
      final income = await db.findTransactionById(incomeId);
      expect(expense!.deletedAt, isNotNull);
      expect(income!.deletedAt, isNotNull);
      // Both deletions are queued whatever the legs' previous status was: a
      // create that has not been acknowledged is not a create the server never
      // received, and guessing otherwise loses the deletion exactly when the
      // two races.
      expect(expense.syncStatus, SyncStatus.pendingDelete);
      expect(income.syncStatus, SyncStatus.pendingDelete);

      expect(await balances.calculateWalletBalance(sourceId), 50000);
      expect(await balances.calculateWalletBalance(destId), 10000);
    });

    test(
      'deleting from the incoming side also removes the outgoing side',
      () async {
        final (expenseId, incomeId) = await transfers.createTransfer(
          sourceWalletId: sourceId,
          destinationWalletId: destId,
          amount: 7500,
          date: DateTime(2026, 3, 1),
        );

        await transfers.deleteTransfer(incomeId);

        expect((await db.findTransactionById(expenseId))!.deletedAt, isNotNull);
        expect(await transfers.getTransferTransactions(), isEmpty);
      },
    );
  });

  group('integrity', () {
    test('a healthy pair reports no issues', () async {
      await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 1000,
        date: DateTime(2026, 3, 1),
      );
      expect(await transfers.validateAllTransfers(), isEmpty);
    });

    test('detects an orphaned leg', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 1000,
        date: DateTime(2026, 3, 1),
      );
      await db.deleteTransaction(incomeId);

      final issues = await transfers.validateAllTransfers();
      expect(issues, hasLength(1));
      expect(issues.single.code, TransferIntegrity.missingPartner);
      expect(issues.single.transactionId, expenseId);
    });

    test('detects mismatched amounts and directions', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 1000,
        date: DateTime(2026, 3, 1),
      );
      // Simulate a single-row edit sneaking past the paired operation.
      await db.customStatement(
        'UPDATE transactions SET amount = 4242, is_income = 0 WHERE id = ?',
        [incomeId],
      );

      final issues = await transfers.validateAllTransfers();
      final codes = issues.map((i) => i.code).toSet();
      expect(codes, contains(TransferIntegrity.amountMismatch));
      expect(codes, contains(TransferIntegrity.sameDirection));
      expect(issues.map((i) => i.transactionId), contains(expenseId));
    });

    test('reconciliation leaves a merely-absent partner alone', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );
      // The partner row is not present — e.g. it has not been pulled yet.
      await db.deleteTransaction(incomeId);

      final repaired = await transfers.reconcileTransferPairs();

      expect(repaired, 0);
      expect(
        (await db.findTransactionById(expenseId))!.deletedAt,
        isNull,
        reason:
            'pushing a delete for a record the server may still hold intact '
            'would destroy data; the issue is reported instead',
      );
      expect(await transfers.validateAllTransfers(), hasLength(1));
    });

    test('reconciliation tombstones a half transfer, delete wins', () async {
      final (expenseId, incomeId) = await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );
      // Device B deleted the incoming leg while this device still has both.
      await db.softDeleteTransaction(incomeId);

      final repaired = await transfers.reconcileTransferPairs();

      expect(repaired, 1);
      expect((await db.findTransactionById(expenseId))!.deletedAt, isNotNull);
      expect(await balances.calculateWalletBalance(sourceId), 50000);
      expect(await transfers.validateAllTransfers(), isEmpty);
    });
  });

  test(
    'transfers never inflate income, expense, or category spending',
    () async {
      await transfers.createTransfer(
        sourceWalletId: sourceId,
        destinationWalletId: destId,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );
      final categoryId = await seedCategory(db, name: 'Food');
      await seedTransaction(
        db,
        walletId: sourceId,
        categoryId: categoryId,
        amount: 1200,
      );

      final all = await db.getAllTransactions();
      expect(TransactionPolicy.totalIncome(all), 0);
      expect(TransactionPolicy.totalExpense(all), 1200);
      expect(TransactionPolicy.spendingByCategory(all), {categoryId: 1200});
    },
  );
}
