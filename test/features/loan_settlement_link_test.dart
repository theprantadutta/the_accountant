import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/backup/services/backup_service.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';

import '../helpers/test_database.dart';

/// A repayment knows which loan it repays.
///
/// Before the link, a repayment was an ordinary income or expense row whose
/// only connection to its loan was the wording of its title. That is why it
/// counted as earnings, why "mark as pending" could only pile a reversal on
/// top, why deleting a loan left its repayments moving the balance, and why
/// deleting a repayment left the loan reading as settled.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late String wallet;
  late String loan;

  setUp(() async {
    db = openTestDatabase();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    wallet = await seedWallet(db, openingBalance: 100000);
    loan = await seedTransaction(
      db,
      walletId: wallet,
      amount: 20000,
      specialType: TransactionSpecialType.credit,
      title: 'Lent to Sam',
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<CreditDebtNotifier> notifier() async {
    final n = container.read(creditDebtProvider.notifier);
    await n.loadData();
    return n;
  }

  Future<int> balance() =>
      WalletBalanceService(db).calculateWalletBalance(wallet);

  Future<List<Transaction>> live() async => (await db.getAllTransactions())
      .where((t) => t.deletedAt == null)
      .toList();

  test('marking a loan pending removes its repayments instead of piling a '
      'reversal on top', () async {
    final n = await notifier();
    await n.recordPayment(transactionId: loan, paymentAmount: 5000);
    await n.markAsSettled(loan);
    expect(await balance(), 100000);

    await n.markAsPending(loan);

    expect(await live(), hasLength(1), reason: 'only the loan is left');
    expect((await db.findTransactionById(loan))!.paidAmount, 0);
    expect(await balance(), 80000);
  });

  test('deleting a loan takes its repayments with it, and restoring it brings '
      'back exactly those', () async {
    final n = await notifier();
    await n.recordPayment(transactionId: loan, paymentAmount: 5000);
    final repayment = (await db.getSettlementsOf(loan)).single.id;

    await db.softDeleteTransaction(loan);
    expect(await live(), isEmpty);
    expect(await balance(), 100000, reason: 'as if the loan never happened');

    await db.restoreTransaction(loan);
    expect((await live()).map((t) => t.id), unorderedEquals([loan, repayment]));
    expect(await balance(), 85000);
    expect((await db.findTransactionById(loan))!.paidAmount, 5000);
  });

  test('deleting a repayment takes it off the loan, and restoring it puts it '
      'back', () async {
    final n = await notifier();
    await n.markAsSettled(loan);
    final repayment = (await db.getSettlementsOf(loan)).single.id;

    await db.softDeleteTransaction(repayment);
    final reopened = (await db.findTransactionById(loan))!;
    expect(reopened.paidAmount, 0);
    expect(TransactionPolicy.isSettled(reopened), isFalse);

    await db.restoreTransaction(repayment);
    expect((await db.findTransactionById(loan))!.paidAmount, 20000);
  });

  group('repayments recorded before the link', () {
    /// Exactly what the credit/debt screen used to write.
    Future<String> legacyRepayment({
      required String note,
      required bool isIncome,
      int amount = 5000,
      String? onWallet,
      DateTime? date,
    }) async {
      final id = await seedTransaction(
        db,
        walletId: onWallet ?? wallet,
        amount: amount,
        isIncome: isIncome,
        title: 'Received: Lent to Sam',
        date: date,
        syncStatus: SyncStatus.synced,
      );
      await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(notes: Value(note)),
      );
      return id;
    }

    test('are linked to their loan by the words they were given', () async {
      final partial = await legacyRepayment(
        note: 'Partial payment for credit: Lent to Sam',
        isIncome: true,
      );
      final settlement = await legacyRepayment(
        note: 'Settlement for credit: Lent to Sam',
        isIncome: true,
      );
      final reversal = await legacyRepayment(
        note: 'Reversal of repayments for: Lent to Sam',
        isIncome: false,
      );

      expect(await db.linkLegacySettlements(), 3);
      for (final id in [partial, settlement, reversal]) {
        final row = (await db.findTransactionById(id))!;
        expect(row.settlesTransactionId, loan);
        expect(TransactionPolicy.countsInAnalytics(row), isFalse);
        expect(row.syncStatus, SyncStatus.pendingUpdate);
      }
      expect(await db.linkLegacySettlements(), 0, reason: 'idempotent');
    });

    test('are left alone when nothing matches', () async {
      final otherWallet = await seedWallet(db, name: 'Bank');
      final elsewhere = await legacyRepayment(
        note: 'Settlement for credit: Lent to Sam',
        isIncome: true,
        onWallet: otherWallet,
      );
      final wrongWay = await legacyRepayment(
        note: 'Settlement for credit: Lent to Sam',
        isIncome: false,
      );
      final wrongKind = await legacyRepayment(
        note: 'Settlement for debt: Lent to Sam',
        isIncome: true,
      );

      expect(await db.linkLegacySettlements(), 0);
      for (final id in [elsewhere, wrongWay, wrongKind]) {
        expect(
          (await db.findTransactionById(id))!.settlesTransactionId,
          isNull,
        );
      }
    });

    test(
      'go to the loan made nearest before them when titles repeat',
      () async {
        final older = await seedTransaction(
          db,
          walletId: wallet,
          amount: 1000,
          specialType: TransactionSpecialType.credit,
          title: 'Lent to Sam',
          date: DateTime(2025, 1, 1),
        );
        await (db.update(db.transactions)..where((t) => t.id.equals(loan)))
            .write(TransactionsCompanion(date: Value(DateTime(2026, 3, 1))));

        final early = await legacyRepayment(
          note: 'Settlement for credit: Lent to Sam',
          isIncome: true,
          date: DateTime(2025, 6, 1),
        );
        final late = await legacyRepayment(
          note: 'Settlement for credit: Lent to Sam',
          isIncome: true,
          date: DateTime(2026, 6, 1),
        );

        await db.linkLegacySettlements();
        expect(
          (await db.findTransactionById(early))!.settlesTransactionId,
          older,
        );
        expect(
          (await db.findTransactionById(late))!.settlesTransactionId,
          loan,
        );
      },
    );

    test(
      'are linked when restored from a backup made before the link',
      () async {
        final repayment = await legacyRepayment(
          note: 'Settlement for credit: Lent to Sam',
          isIncome: true,
        );
        final service = BackupService(db);
        final document = await service.create();
        for (final row in document.tables['transactions']!) {
          row.remove('settles_transaction_id');
        }

        await service.restore(document);

        expect(
          (await db.findTransactionById(repayment))!.settlesTransactionId,
          loan,
        );
      },
    );
  });
}
