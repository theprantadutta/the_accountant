import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/domain/budget_window.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

import '../helpers/test_database.dart';

/// What a budget has consumed, and over which days.
///
/// Both halves were broken. Three of the four places that worked out a budget's
/// spend filtered on a deprecated `type` column that nothing writes, so they
/// always read zero however much the user recorded; one of those then divided
/// cents by a limit held in dollars. And the window was taken as the budget's
/// whole lifetime rather than its current period, so a monthly budget kept
/// counting January's spending in February and never came back down.
void main() {
  late AppDatabase db;
  late String walletId;
  late String food;
  late String snacks;
  late String salary;

  setUp(() async {
    db = openTestDatabase();
    walletId = await seedWallet(db, name: 'Everyday', openingBalance: 500000);
    food = await seedCategory(db, name: 'Food');
    snacks = await seedCategory(db, name: 'Snacks', mainCategoryId: food);
    salary = await seedCategory(db, name: 'Salary', isIncome: true);
  });

  tearDown(() => db.close());

  Future<BudgetView> budget({
    int amount = 100000,
    BudgetPeriod period = BudgetPeriod.monthly,
    int periodLength = 1,
    List<String> categoryIds = const [],
    List<String> walletIds = const [],
    bool isIncome = false,
    bool rollover = false,
    DateTime? startDate,
  }) async {
    final id = await seedBudget(
      db,
      amount: amount,
      period: period.name,
      periodLength: periodLength,
      categoryIds: categoryIds,
      walletIds: walletIds,
      isIncome: isIncome,
      rollover: rollover,
      startDate: startDate ?? DateTime(2026, 1, 1),
    );
    return BudgetView.fromRow((await db.findBudgetById(id))!);
  }

  group('what counts toward a budget', () {
    test('an ordinary expense in the window counts', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 25000,
        date: DateTime(2026, 1, 10),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 1, 15),
      );

      expect(
        progress.spent,
        25000,
        reason: 'this is the case every broken implementation reported as zero',
      );
      expect(progress.remaining, 75000);
      expect(progress.isOver, isFalse);
    });

    test('a subcategory counts toward its parent', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: snacks,
        amount: 4000,
        date: DateTime(2026, 1, 5),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 1, 15),
      );

      expect(
        progress.spent,
        4000,
        reason:
            'a Food budget is about food; filing lunch under Snacks, which '
            'sits inside Food, is not a way to stop spending on food',
      );
    });

    test('spending outside the window does not count', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 90000,
        date: DateTime(2026, 1, 20),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 2, 10),
      );

      expect(
        progress.spent,
        0,
        reason: 'February must not be charged for January',
      );
      expect(progress.window.start, DateTime(2026, 2, 1));
    });

    test('income does not count toward a spending budget', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: salary,
        amount: 300000,
        isIncome: true,
        date: DateTime(2026, 1, 8),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(),
        moment: DateTime(2026, 1, 15),
      );

      expect(progress.spent, 0);
    });

    test('an earnings budget measures income instead', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: salary,
        amount: 300000,
        isIncome: true,
        date: DateTime(2026, 1, 8),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(isIncome: true, categoryIds: [salary]),
        moment: DateTime(2026, 1, 15),
      );

      expect(progress.spent, 300000);
    });

    test('an unpaid upcoming transaction does not count yet', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 50000,
        date: DateTime(2026, 1, 12),
        isPaid: false,
        specialType: TransactionSpecialType.upcoming,
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 1, 15),
      );

      expect(
        progress.spent,
        0,
        reason: 'money that has not moved has not been spent',
      );
    });

    test('a wallet the budget does not name is ignored', () async {
      final other = await seedWallet(db, name: 'Savings');
      await seedTransaction(
        db,
        walletId: other,
        categoryId: food,
        amount: 20000,
        date: DateTime(2026, 1, 9),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food], walletIds: [walletId]),
        moment: DateTime(2026, 1, 15),
      );

      expect(progress.spent, 0);
    });
  });

  group('the window a budget is measured over', () {
    test('a monthly budget runs from its own start day', () {
      final window = BudgetWindows.containing(
        start: DateTime(2026, 1, 12),
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: DateTime(2026, 2, 3),
      );

      expect(
        window.start,
        DateTime(2026, 1, 12),
        reason:
            'someone paid on the 12th budgets from the 12th; snapping to the '
            'first of the month charges half of one month against the other',
      );
      expect(window.end, DateTime(2026, 2, 12));
    });

    test('an interval makes a fortnightly budget out of a weekly one', () {
      final window = BudgetWindows.containing(
        start: DateTime(2026, 1, 1),
        period: BudgetPeriod.weekly,
        periodLength: 2,
        moment: DateTime(2026, 1, 20),
      );

      expect(window.start, DateTime(2026, 1, 15));
      expect(window.end, DateTime(2026, 1, 29));
    });

    test('a budget starting on the 31st lands on the last day of short months', () {
      final window = BudgetWindows.containing(
        start: DateTime(2026, 1, 31),
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: DateTime(2026, 2, 10),
      );

      expect(
        window.start,
        DateTime(2026, 1, 31),
        reason: 'still inside the first window',
      );
      expect(
        window.end,
        DateTime(2026, 2, 28),
        reason:
            'naive date arithmetic turns 31 January into 3 March and skips '
            'February altogether',
      );
    });

    test('a one-off budget is a single fixed span', () {
      final window = BudgetWindows.containing(
        start: DateTime(2026, 1, 1),
        period: BudgetPeriod.custom,
        periodLength: 1,
        moment: DateTime(2027, 6, 1),
        explicitEnd: DateTime(2026, 3, 1),
      );

      expect(window.start, DateTime(2026, 1, 1));
      expect(window.end, DateTime(2026, 3, 1));
    });

    test('stepping back reaches an earlier period', () {
      final window = BudgetWindows.relative(
        start: DateTime(2026, 1, 1),
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: DateTime(2026, 4, 10),
        offset: -2,
      );

      expect(window.start, DateTime(2026, 2, 1));
      expect(window.end, DateTime(2026, 3, 1));
    });

    test('stepping back never goes behind the budget itself', () {
      final window = BudgetWindows.relative(
        start: DateTime(2026, 1, 1),
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: DateTime(2026, 1, 10),
        offset: -6,
      );

      expect(window.start, DateTime(2026, 1, 1));
    });
  });

  group('carrying an unspent balance forward', () {
    test('what January left over raises February', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 40000,
        date: DateTime(2026, 1, 10),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food], rollover: true),
        moment: DateTime(2026, 2, 10),
      );

      expect(progress.carriedIn, 60000, reason: '100000 limit less 40000 spent');
      expect(progress.limit, 160000);
    });

    test('going over costs the carry but does not become a debt', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 150000,
        date: DateTime(2026, 1, 10),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food], rollover: true),
        moment: DateTime(2026, 2, 10),
      );

      expect(progress.carriedIn, 0);
      expect(
        progress.limit,
        100000,
        reason: 'February still gets its own full limit',
      );
    });

    test('without rollover each period starts fresh', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 40000,
        date: DateTime(2026, 1, 10),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 2, 10),
      );

      expect(progress.carriedIn, 0);
      expect(progress.limit, 100000);
    });
  });

  group('pacing', () {
    test('half the limit two thirds through the month is not flagged', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 50000,
        date: DateTime(2026, 1, 5),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 1, 21),
      );

      expect(progress.isAheadOfPace(DateTime(2026, 1, 21)), isFalse);
    });

    test('half the limit on the third day is not', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 50000,
        date: DateTime(2026, 1, 2),
      );

      final progress = await BudgetEngine(db).progressFor(
        await budget(categoryIds: [food]),
        moment: DateTime(2026, 1, 3),
      );

      expect(
        progress.isAheadOfPace(DateTime(2026, 1, 3)),
        isTrue,
        reason: 'a bar without a pace marker cannot say this',
      );
    });
  });
}
