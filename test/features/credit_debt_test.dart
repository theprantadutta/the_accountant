import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';

import '../helpers/test_database.dart';

void main() {
  group('CreditDebtState exposure', () {
    CreditDebtState stateWith({
      required List<Transaction> credit,
      required List<Transaction> debt,
    }) => CreditDebtState(creditTransactions: credit, debtTransactions: debt);

    test('net outstanding is zero once everything is settled', () {
      final state = stateWith(
        credit: [
          buildTransaction(
            id: 'c1',
            amount: 10000,
            paidAmount: 10000,
            specialType: TransactionSpecialType.credit,
          ),
        ],
        debt: [
          buildTransaction(
            id: 'd1',
            amount: 4000,
            paidAmount: 4000,
            specialType: TransactionSpecialType.debt,
          ),
        ],
      );

      // The headline figure must reflect OPEN exposure. Lifetime totals used to
      // drive it, so the screen kept claiming someone owed money forever.
      expect(state.netBalance, 0);
      expect(state.unpaidCredit, 0);
      expect(state.unpaidDebt, 0);
      // The historical figure is still available, under its own name.
      expect(state.lifetimeNetBalance, 6000);
    });

    test('net outstanding uses remaining amounts, not principals', () {
      final state = stateWith(
        credit: [
          buildTransaction(
            id: 'c1',
            amount: 10000,
            paidAmount: 7500,
            specialType: TransactionSpecialType.credit,
          ),
        ],
        debt: [
          buildTransaction(
            id: 'd1',
            amount: 4000,
            paidAmount: 1000,
            specialType: TransactionSpecialType.debt,
          ),
        ],
      );

      expect(state.unpaidCredit, 2500);
      expect(state.unpaidDebt, 3000);
      expect(state.netBalance, -500);
    });

    test('a brand new loan is outstanding, not settled', () {
      final loan = buildTransaction(
        id: 'c1',
        amount: 10000,
        // isPaid is true from the moment the cash moved...
        isPaid: true,
        // ...but nothing has been repaid.
        paidAmount: 0,
        specialType: TransactionSpecialType.credit,
      );
      final state = stateWith(credit: [loan], debt: const []);

      expect(state.unpaidTransactions, hasLength(1));
      expect(state.settledTransactions, isEmpty);
      expect(state.netBalance, 10000);
    });

    test('overdue counts only what is still owed', () {
      final past = DateTime.now().subtract(const Duration(days: 10));
      final state = stateWith(
        credit: [
          buildTransaction(
            id: 'open',
            amount: 5000,
            date: past,
            specialType: TransactionSpecialType.credit,
          ),
          buildTransaction(
            id: 'settled',
            amount: 5000,
            paidAmount: 5000,
            date: past,
            specialType: TransactionSpecialType.credit,
          ),
        ],
        debt: const [],
      );

      expect(state.overdueCount, 1);
      expect(state.overdueTransactions.single.id, 'open');
    });
  });

  group('lend -> partial payment -> settle -> undo', () {
    late AppDatabase db;
    late ProviderContainer container;
    late String walletId;
    late String loanId;

    setUp(() async {
      db = openTestDatabase();
      container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      walletId = await seedWallet(db, openingBalance: 100000);
      loanId = await seedTransaction(
        db,
        walletId: walletId,
        amount: 20000,
        isIncome: false, // lending money out
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

    test('the principal leaves the wallet immediately', () async {
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000 - 20000,
      );
      final loan = await db.findTransactionById(loanId);
      expect(TransactionPolicy.isSettled(loan!), isFalse);
    });

    test('a partial repayment advances paidAmount and returns cash', () async {
      final n = await notifier();

      await n.recordPayment(transactionId: loanId, paymentAmount: 5000);

      final loan = await db.findTransactionById(loanId);
      expect(loan!.paidAmount, 5000);
      expect(TransactionPolicy.isSettled(loan), isFalse);
      expect(TransactionPolicy.outstandingAmount(loan), 15000);
      expect(
        loan.syncStatus,
        SyncStatus.pendingCreate,
        reason:
            'the loan has never been uploaded, so recording a repayment must '
            'leave it a create rather than an unsyncable update',
      );

      // The repayment is a real transaction, and the wallet reflects it.
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000 - 20000 + 5000,
      );

      // The outstanding total on screen follows.
      expect(n.state.unpaidCredit, 15000);
      expect(n.state.netBalance, 15000);
    });

    test('a repayment cannot exceed the principal', () async {
      final n = await notifier();

      await n.recordPayment(transactionId: loanId, paymentAmount: 999999);

      final loan = await db.findTransactionById(loanId);
      expect(loan!.paidAmount, 20000);
      expect(TransactionPolicy.outstandingAmount(loan), 0);
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000,
        reason: 'an overpayment must not manufacture money',
      );
    });

    test('a non-positive repayment is rejected', () async {
      final n = await notifier();

      await n.recordPayment(transactionId: loanId, paymentAmount: 0);

      expect((await db.findTransactionById(loanId))!.paidAmount, 0);
      expect(n.state.error, isNotNull);
    });

    test('settling clears the remainder and zeroes exposure', () async {
      final n = await notifier();
      await n.recordPayment(transactionId: loanId, paymentAmount: 5000);

      await n.markAsSettled(loanId);

      final loan = await db.findTransactionById(loanId);
      expect(loan!.paidAmount, 20000);
      expect(TransactionPolicy.isSettled(loan), isTrue);
      expect(n.state.unpaidCredit, 0);
      expect(n.state.netBalance, 0);
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000,
        reason: 'the full principal came back',
      );
    });

    test('undoing settlement restores the outstanding balance', () async {
      final n = await notifier();
      await n.markAsSettled(loanId);

      await n.markAsPending(loanId);

      final loan = await db.findTransactionById(loanId);
      expect(loan!.paidAmount, 0);
      expect(TransactionPolicy.isSettled(loan), isFalse);
      expect(n.state.unpaidCredit, 20000);
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000 - 20000,
        reason: 'the money is out on loan again',
      );
    });

    test('borrowing works in the opposite direction', () async {
      final debtId = await seedTransaction(
        db,
        walletId: walletId,
        amount: 8000,
        isIncome: true, // borrowing brings money in
        specialType: TransactionSpecialType.debt,
        title: 'Borrowed from Alex',
      );
      final n = await notifier();

      expect(n.state.unpaidDebt, 8000);
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000 - 20000 + 8000,
      );

      await n.recordPayment(transactionId: debtId, paymentAmount: 8000);

      expect(n.state.unpaidDebt, 0);
      expect(
        await WalletBalanceService(db).calculateWalletBalance(walletId),
        100000 - 20000,
        reason: 'repaying a debt takes the money back out',
      );
    });

    test('repayments never inflate reported income or expense', () async {
      final n = await notifier();
      await n.recordPayment(transactionId: loanId, paymentAmount: 5000);

      final all = await db.getAllTransactions();
      // The lend is an expense, the repayment is income — both real cash
      // movements, both reportable. What must NOT happen is the loan being
      // silently excluded or double counted.
      expect(TransactionPolicy.totalExpense(all), 20000);
      expect(TransactionPolicy.totalIncome(all), 5000);
    });
  });
}
