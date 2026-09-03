import 'package:drift/drift.dart' show Value;
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

      final progress = await BudgetEngine(
        db,
      ).progressFor(await budget(), moment: DateTime(2026, 1, 15));

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

    test(
      'a budget starting on the 31st lands on the last day of short months',
      () {
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
      },
    );

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

      expect(
        progress.carriedIn,
        60000,
        reason: '100000 limit less 40000 spent',
      );
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
    test(
      'half the limit two thirds through the month is not flagged',
      () async {
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
      },
    );

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

  group('caps on individual categories', () {
    test('an absolute cap counts only its own category', () async {
      final budgetView = await budget(categoryIds: [food], amount: 100000);
      await db.setCategoryLimit(
        budgetId: budgetView.id,
        categoryId: snacks,
        amount: 10000,
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: snacks,
        amount: 12000,
        date: DateTime(2026, 1, 6),
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 30000,
        date: DateTime(2026, 1, 7),
      );

      final engine = BudgetEngine(db);
      final progress = await engine.progressFor(
        budgetView,
        moment: DateTime(2026, 1, 15),
      );
      final limits = await engine.categoryLimits(budgetView, progress);

      expect(progress.spent, 42000, reason: 'the budget itself counts both');
      expect(limits, hasLength(1));
      expect(
        limits.single.spent,
        12000,
        reason:
            'the cap is about snacks; the rest of the food budget is not its '
            'business',
      );
      expect(
        limits.single.isOver,
        isTrue,
        reason:
            'a budget on track overall can still be mostly one thing, which is '
            'the whole point of a cap inside it',
      );
    });

    test(
      'a percentage cap follows the budget when the amount changes',
      () async {
        final budgetView = await budget(categoryIds: [food], amount: 100000);
        // 25.5%, stored as hundredths of a percent.
        await db.setCategoryLimit(
          budgetId: budgetView.id,
          categoryId: snacks,
          amount: 2550,
          isPercent: true,
        );

        final engine = BudgetEngine(db);
        final before = await engine.categoryLimits(
          budgetView,
          await engine.progressFor(budgetView, moment: DateTime(2026, 1, 15)),
        );
        expect(before.single.limit, 25500);

        await db.writeBudget(
          budgetView.id,
          const BudgetsCompanion(amount: Value(200000)),
        );
        final bigger = BudgetView.fromRow(
          (await db.findBudgetById(budgetView.id))!,
        );

        final after = await engine.categoryLimits(
          bigger,
          await engine.progressFor(bigger, moment: DateTime(2026, 1, 15)),
        );
        expect(
          after.single.limit,
          51000,
          reason:
              'a quarter of the budget means a quarter, whatever that becomes',
        );
      },
    );

    test('a cap on a parent counts what is filed inside it', () async {
      final budgetView = await budget(categoryIds: [food]);
      await db.setCategoryLimit(
        budgetId: budgetView.id,
        categoryId: food,
        amount: 50000,
      );
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: snacks,
        amount: 9000,
        date: DateTime(2026, 1, 6),
      );

      final engine = BudgetEngine(db);
      final limits = await engine.categoryLimits(
        budgetView,
        await engine.progressFor(budgetView, moment: DateTime(2026, 1, 15)),
      );

      expect(limits.single.spent, 9000);
    });

    test('setting a cap twice edits it rather than adding a second', () async {
      final budgetView = await budget(categoryIds: [food]);
      await db.setCategoryLimit(
        budgetId: budgetView.id,
        categoryId: food,
        amount: 10000,
      );
      await db.setCategoryLimit(
        budgetId: budgetView.id,
        categoryId: food,
        amount: 20000,
      );

      final limits = await db.getCategoryLimitsForBudget(budgetView.id);
      expect(limits, hasLength(1));
      expect(limits.single.amount, 20000);
    });

    test('deleting the budget takes its caps with it', () async {
      final budgetView = await budget(categoryIds: [food]);
      await db.setCategoryLimit(
        budgetId: budgetView.id,
        categoryId: food,
        amount: 10000,
      );

      await db.softDeleteBudget(budgetView.id);

      expect(
        await db.getCategoryLimitsForBudget(budgetView.id),
        isEmpty,
        reason:
            'a cap on a budget that is gone has nothing to cap, and the server '
            'rejects one naming a budget that is not live',
      );
    });
  });

  group('where the period is heading', () {
    test('a steady run rate projects past the limit', () async {
      // Nine days in, three fifths of the limit already gone.
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 60000,
        date: DateTime(2026, 1, 3),
      );

      final budgetView = await budget(categoryIds: [food], amount: 100000);
      final engine = BudgetEngine(db);
      final moment = DateTime(2026, 1, 10);
      final forecast = await engine.forecast(
        budgetView,
        await engine.progressFor(budgetView, moment: moment),
        moment: moment,
      );

      expect(forecast, isNotNull);
      expect(
        forecast!.willExceed,
        isTrue,
        reason: 'still inside the limit today, but not by the end of the month',
      );
      expect(forecast.overBy, greaterThan(0));
    });

    test('an upcoming bill counts as committed, not guessed', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 120000,
        date: DateTime(2026, 1, 25),
        isPaid: false,
        specialType: TransactionSpecialType.upcoming,
      );

      final budgetView = await budget(categoryIds: [food], amount: 100000);
      final engine = BudgetEngine(db);
      final moment = DateTime(2026, 1, 20);
      final forecast = await engine.forecast(
        budgetView,
        await engine.progressFor(budgetView, moment: moment),
        moment: moment,
      );

      expect(
        forecast!.scheduled,
        120000,
        reason:
            'a dated bill that has not happened yet is knowable; Cashew cannot '
            'see this because it only creates the next instance once the last '
            'one is paid',
      );
      expect(forecast.willExceed, isTrue);
    });

    test('one purchase on day one does not project a catastrophe', () async {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: food,
        amount: 20000,
        date: DateTime(2026, 1, 1),
      );

      final budgetView = await budget(categoryIds: [food], amount: 100000);
      final engine = BudgetEngine(db);
      final moment = DateTime(2026, 1, 1, 12);
      final forecast = await engine.forecast(
        budgetView,
        await engine.progressFor(budgetView, moment: moment),
        moment: moment,
      );

      expect(
        forecast!.willExceed,
        isFalse,
        reason:
            'extrapolating half a day of spending would warn on the first of '
            'every month, which is noise rather than information',
      );
    });

    test('there is nothing to forecast once the period has closed', () async {
      final budgetView = await budget(categoryIds: [food]);
      final engine = BudgetEngine(db);
      final progress = await engine.progressFor(
        budgetView,
        moment: DateTime(2026, 1, 15),
      );

      expect(
        await engine.forecast(
          budgetView,
          progress,
          moment: DateTime(2026, 3, 1),
        ),
        isNull,
      );
    });
  });
}
