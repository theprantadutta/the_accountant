import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/test_database.dart';

/// The shared eligibility policy is the single definition every financial
/// calculation now reads, so it is worth pinning precisely: each of these cases
/// corresponds to a screen that used to disagree with the others.
void main() {
  group('cash realization (wallet balance effect)', () {
    test('a paid expense reduces the wallet', () {
      final t = buildTransaction(amount: 2500, isIncome: false);
      expect(TransactionPolicy.affectsWalletBalance(t), isTrue);
      expect(TransactionPolicy.walletBalanceEffect(t), -2500);
    });

    test('a paid income increases the wallet', () {
      final t = buildTransaction(amount: 2500, isIncome: true);
      expect(TransactionPolicy.walletBalanceEffect(t), 2500);
    });

    test('an unpaid upcoming item has no balance effect', () {
      final t = buildTransaction(
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
      );
      expect(TransactionPolicy.affectsWalletBalance(t), isFalse);
      expect(TransactionPolicy.walletBalanceEffect(t), 0);
    });

    test('a lend is realized even while unpaid — the cash already moved', () {
      final t = buildTransaction(
        amount: 5000,
        isIncome: false,
        specialType: TransactionSpecialType.credit,
        isPaid: false,
      );
      expect(TransactionPolicy.affectsWalletBalance(t), isTrue);
      expect(TransactionPolicy.walletBalanceEffect(t), -5000);
    });

    test('a soft-deleted row has no effect', () {
      final t = buildTransaction(deletedAt: DateTime(2026, 2, 1));
      expect(TransactionPolicy.affectsWalletBalance(t), isFalse);
    });
  });

  group('debt settlement is independent of cash realization', () {
    test('a brand new loan is realized but NOT settled', () {
      final loan = buildTransaction(
        amount: 10000,
        specialType: TransactionSpecialType.credit,
        isPaid: true, // cash moved
        paidAmount: 0, // nothing repaid
      );
      expect(TransactionPolicy.affectsWalletBalance(loan), isTrue);
      expect(TransactionPolicy.isSettled(loan), isFalse);
      expect(TransactionPolicy.outstandingAmount(loan), 10000);
    });

    test('a partial repayment leaves it outstanding', () {
      final loan = buildTransaction(
        amount: 10000,
        specialType: TransactionSpecialType.credit,
        paidAmount: 4000,
      );
      expect(TransactionPolicy.isSettled(loan), isFalse);
      expect(TransactionPolicy.isOutstanding(loan), isTrue);
      expect(TransactionPolicy.hasPartialPayment(loan), isTrue);
      expect(TransactionPolicy.outstandingAmount(loan), 6000);
      expect(TransactionPolicy.settlementProgress(loan), closeTo(0.4, 1e-9));
    });

    test('paying the full amount settles it', () {
      final loan = buildTransaction(
        amount: 10000,
        specialType: TransactionSpecialType.credit,
        paidAmount: 10000,
      );
      expect(TransactionPolicy.isSettled(loan), isTrue);
      expect(TransactionPolicy.outstandingAmount(loan), 0);
      expect(TransactionPolicy.hasPartialPayment(loan), isFalse);
    });

    test('an overpayment cannot produce a negative outstanding amount', () {
      final loan = buildTransaction(
        amount: 10000,
        specialType: TransactionSpecialType.debt,
        paidAmount: 12000,
      );
      expect(TransactionPolicy.isSettled(loan), isTrue);
      expect(TransactionPolicy.outstandingAmount(loan), 0);
    });

    test('a zero-amount loan is settled rather than stuck forever', () {
      final loan = buildTransaction(
        amount: 0,
        specialType: TransactionSpecialType.debt,
      );
      expect(TransactionPolicy.isSettled(loan), isTrue);
    });

    test('overdue means unsettled AND past due', () {
      final now = DateTime(2026, 6, 1);
      final overdue = buildTransaction(
        amount: 5000,
        specialType: TransactionSpecialType.debt,
        date: DateTime(2026, 5, 1),
      );
      expect(TransactionPolicy.isOverdue(overdue, now: now), isTrue);

      final settled = buildTransaction(
        amount: 5000,
        paidAmount: 5000,
        specialType: TransactionSpecialType.debt,
        date: DateTime(2026, 5, 1),
      );
      expect(TransactionPolicy.isOverdue(settled, now: now), isFalse);

      final future = buildTransaction(
        amount: 5000,
        specialType: TransactionSpecialType.debt,
        date: DateTime(2026, 7, 1),
      );
      expect(TransactionPolicy.isOverdue(future, now: now), isFalse);
    });

    test('originalDueDate wins over date when deciding overdue', () {
      final t = buildTransaction(
        amount: 5000,
        specialType: TransactionSpecialType.credit,
        date: DateTime(2026, 12, 1),
        originalDueDate: DateTime(2026, 1, 1),
      );
      expect(TransactionPolicy.isOverdue(t, now: DateTime(2026, 6, 1)), isTrue);
    });
  });

  group('transfers are excluded from every analytic', () {
    final outgoing = buildTransaction(
      id: 'out',
      amount: 7500,
      isIncome: false,
      transactionType: 'transfer',
      walletId: 'w1',
      categoryId: 'transfer-cat',
    );
    final incoming = buildTransaction(
      id: 'in',
      amount: 7500,
      isIncome: true,
      transactionType: 'transfer',
      walletId: 'w2',
      categoryId: 'transfer-cat',
    );

    test('each leg still moves its own wallet', () {
      expect(TransactionPolicy.walletBalanceEffect(outgoing), -7500);
      expect(TransactionPolicy.walletBalanceEffect(incoming), 7500);
    });

    test('neither leg counts as income or expense', () {
      expect(TransactionPolicy.countsAsIncome(incoming), isFalse);
      expect(TransactionPolicy.countsAsExpense(outgoing), isFalse);
    });

    test('a transfer does not inflate gross totals', () {
      final expense = buildTransaction(id: 'e', amount: 1000, isIncome: false);
      final income = buildTransaction(id: 'i', amount: 3000, isIncome: true);
      final rows = [outgoing, incoming, expense, income];

      expect(TransactionPolicy.totalIncome(rows), 3000);
      expect(TransactionPolicy.totalExpense(rows), 1000);
    });

    test('a transfer contributes nothing to category spending', () {
      final spending = TransactionPolicy.spendingByCategory([
        outgoing,
        incoming,
        buildTransaction(id: 'e', amount: 1200, categoryId: 'food'),
      ]);
      expect(spending, {'food': 1200});
    });

    test('a transfer never consumes a budget', () {
      expect(TransactionPolicy.countsTowardBudget(outgoing), isFalse);
      expect(
        TransactionPolicy.countsTowardBudget(
          outgoing,
          budgetCategoryIds: const {'transfer-cat'},
        ),
        isFalse,
      );
    });
  });

  group('analytics eligibility', () {
    test('unpaid upcoming rows stay out of realized totals', () {
      final pending = buildTransaction(
        amount: 999,
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
      );
      expect(TransactionPolicy.countsAsExpense(pending), isFalse);
      expect(TransactionPolicy.totalExpense([pending]), 0);
    });

    test('unpaid upcoming rows ARE forecast items', () {
      final pending = buildTransaction(
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
        date: DateTime(2026, 9, 1),
      );
      expect(TransactionPolicy.isForecast(pending), isTrue);
      expect(
        TransactionPolicy.isFutureForecast(pending, now: DateTime(2026, 8, 1)),
        isTrue,
      );
      expect(
        TransactionPolicy.isOverdueForecast(
          pending,
          now: DateTime(2026, 10, 1),
        ),
        isTrue,
      );
    });

    test('a skipped occurrence is not a forecast item', () {
      final skipped = buildTransaction(
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
        skipPaid: true,
      );
      expect(TransactionPolicy.isForecast(skipped), isFalse);
    });

    test('budget eligibility respects direction and category', () {
      final groceries = buildTransaction(amount: 500, categoryId: 'food');
      expect(
        TransactionPolicy.countsTowardBudget(
          groceries,
          budgetCategoryIds: const {'food'},
        ),
        isTrue,
      );
      expect(
        TransactionPolicy.countsTowardBudget(
          groceries,
          budgetCategoryIds: const {'travel'},
        ),
        isFalse,
      );
      expect(
        TransactionPolicy.countsTowardBudget(groceries, budgetIsIncome: true),
        isFalse,
      );
    });

    test('rows with no category group under the uncategorized key', () {
      final spending = TransactionPolicy.spendingByCategory([
        buildTransaction(amount: 700),
      ]);
      expect(spending, {TransactionPolicy.uncategorizedKey: 700});
    });
  });

  test('total outstanding sums only what is still owed', () {
    final rows = [
      buildTransaction(
        id: 'a',
        amount: 10000,
        specialType: TransactionSpecialType.credit,
        paidAmount: 2500,
      ),
      buildTransaction(
        id: 'b',
        amount: 4000,
        specialType: TransactionSpecialType.credit,
        paidAmount: 4000,
      ),
    ];
    expect(TransactionPolicy.totalOutstanding(rows), 7500);
  });
}
