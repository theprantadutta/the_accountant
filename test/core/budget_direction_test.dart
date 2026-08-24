import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/test_database.dart';

/// A budget tracks either spending or earnings. Dropping that direction on the
/// way to the shared policy made every income budget evaluate as an expense
/// budget, so the reports tab disagreed with the dashboard and the financial
/// calculation service about the same budget.
void main() {
  group('policy honours budget direction', () {
    final expense = buildTransaction(
      id: 'e',
      amount: 1000,
      isIncome: false,
      categoryId: 'food',
    );
    final income = buildTransaction(
      id: 'i',
      amount: 5000,
      isIncome: true,
      categoryId: 'salary',
    );

    test('an expense budget counts expenses only', () {
      expect(TransactionPolicy.countsTowardBudget(expense), isTrue);
      expect(TransactionPolicy.countsTowardBudget(income), isFalse);
    });

    test('an income budget counts income only', () {
      expect(
        TransactionPolicy.countsTowardBudget(income, budgetIsIncome: true),
        isTrue,
      );
      expect(
        TransactionPolicy.countsTowardBudget(expense, budgetIsIncome: true),
        isFalse,
      );
    });

    test('a category-specific budget still respects direction', () {
      expect(
        TransactionPolicy.countsTowardBudget(
          income,
          budgetIsIncome: true,
          budgetCategoryIds: const {'salary'},
        ),
        isTrue,
      );
      expect(
        TransactionPolicy.countsTowardBudget(
          income,
          budgetIsIncome: true,
          budgetCategoryIds: const {'bonus'},
        ),
        isFalse,
      );
    });

    test('an all-category budget accepts any category', () {
      // Null and empty both mean "not narrowed to anything".
      for (final budgetCategoryIds in [null, const <String>{}]) {
        expect(
          TransactionPolicy.countsTowardBudget(
            expense,
            budgetCategoryIds: budgetCategoryIds,
          ),
          isTrue,
        );
      }
    });

    test('transfers never consume a budget of either direction', () {
      final outgoing = buildTransaction(
        id: 'out',
        amount: 900,
        isIncome: false,
        transactionType: 'transfer',
        categoryId: 'food',
      );
      final incoming = buildTransaction(
        id: 'in',
        amount: 900,
        isIncome: true,
        transactionType: 'transfer',
        categoryId: 'salary',
      );
      expect(TransactionPolicy.countsTowardBudget(outgoing), isFalse);
      expect(
        TransactionPolicy.countsTowardBudget(incoming, budgetIsIncome: true),
        isFalse,
      );
    });

    test('an unpaid upcoming item consumes no budget yet', () {
      final pending = buildTransaction(
        amount: 400,
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
        categoryId: 'food',
      );
      expect(TransactionPolicy.countsTowardBudget(pending), isFalse);
    });

    test('a credit repayment counts on the side its cash moved', () {
      // Recording a repayment on a lend brings money in, so it belongs to an
      // income budget and not to an expense one.
      final repayment = buildTransaction(
        amount: 2000,
        isIncome: true,
        categoryId: 'loan_income',
      );
      expect(
        TransactionPolicy.countsTowardBudget(repayment, budgetIsIncome: true),
        isTrue,
      );
      expect(TransactionPolicy.countsTowardBudget(repayment), isFalse);

      // The lend itself is money going out.
      final lend = buildTransaction(
        amount: 20000,
        isIncome: false,
        specialType: TransactionSpecialType.credit,
        categoryId: 'loan_expense',
      );
      expect(TransactionPolicy.countsTowardBudget(lend), isTrue);
    });
  });

  group('the calculation service agrees with the policy', () {
    late AppDatabase db;
    late FinancialCalculationService service;
    late String walletId;

    setUp(() async {
      db = openTestDatabase();
      service = FinancialCalculationService(db);
      walletId = await seedWallet(db, openingBalance: 100000);
    });
    tearDown(() => db.close());

    Future<String> seedBudget({
      required String name,
      required bool isIncome,
      String? categoryId,
      int amount = 100000,
    }) async {
      final id = 'budget-$name';
      final now = DateTime.now();
      await db.addBudget(
        BudgetsCompanion(
          id: Value(id),
          name: Value(name),
          amount: Value(amount),
          period: const Value('monthly'),
          startDate: Value(now.subtract(const Duration(days: 30))),
          endDate: Value(now.add(const Duration(days: 30))),
          categoryId: Value(categoryId),
          isIncome: Value(isIncome),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      return id;
    }

    test('an income budget measures earnings, not spending', () async {
      final salary = await seedCategory(db, name: 'Salary', isIncome: true);
      final food = await seedCategory(db, name: 'Food');
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: salary,
        amount: 500000,
        isIncome: true,
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 3000,
      );

      final budgetId = await seedBudget(
        name: 'earnings',
        isIncome: true,
        categoryId: salary,
        amount: 400000,
      );

      final details = await service.getBudgetProgressDetails();
      final item = details.firstWhere((d) => d.budgetId == budgetId);

      expect(
        item.spent,
        500000,
        reason: 'an income budget must total the income, not the expenses',
      );
      expect(item.limit, 400000);
    });

    test('an expense budget ignores income entirely', () async {
      final food = await seedCategory(db, name: 'Food');
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 3000,
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 90000,
        isIncome: true,
      );

      final budgetId = await seedBudget(
        name: 'groceries',
        isIncome: false,
        categoryId: food,
      );

      final details = await service.getBudgetProgressDetails();
      final item = details.firstWhere((d) => d.budgetId == budgetId);
      expect(item.spent, 3000);
    });

    test('an all-category budget totals every eligible row', () async {
      final food = await seedCategory(db, name: 'Food');
      final travel = await seedCategory(db, name: 'Travel');
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 3000,
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: travel,
        amount: 4500,
      );

      final budgetId = await seedBudget(name: 'everything', isIncome: false);

      final details = await service.getBudgetProgressDetails();
      final item = details.firstWhere((d) => d.budgetId == budgetId);
      expect(item.spent, 7500);
    });

    test('a transfer never consumes a budget', () async {
      final other = await seedWallet(db, name: 'Savings');
      final transferCategory = await db.requireSystemCategoryId(
        SystemCategories.transferKey,
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: transferCategory,
        amount: 9000,
        transactionType: 'transfer',
      );
      await seedTransaction(
        db,
        walletId: other,
        categoryId: transferCategory,
        amount: 9000,
        isIncome: true,
        transactionType: 'transfer',
      );

      final budgetId = await seedBudget(name: 'all', isIncome: false);

      final details = await service.getBudgetProgressDetails();
      final item = details.firstWhere((d) => d.budgetId == budgetId);
      expect(item.spent, 0);
    });

    test('an unpaid upcoming item is not yet spent', () async {
      final food = await seedCategory(db, name: 'Food');
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 5000,
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
      );

      final budgetId = await seedBudget(name: 'forecast', isIncome: false);

      final details = await service.getBudgetProgressDetails();
      final item = details.firstWhere((d) => d.budgetId == budgetId);
      expect(item.spent, 0);
    });
  });
}
