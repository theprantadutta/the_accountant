import 'package:the_accountant/core/domain/amount_converter.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/budgets/domain/budget_window.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

/// One category's cap inside a budget, and what has gone against it.
class CategoryLimitProgress {
  final String limitId;
  final String categoryId;

  /// The cap for this window in cents, already resolved from a percentage.
  final int limit;

  /// Spent against this category in this window, in cents.
  final int spent;

  /// Whether the user expressed this as a share of the budget.
  final bool isPercent;

  const CategoryLimitProgress({
    required this.limitId,
    required this.categoryId,
    required this.limit,
    required this.spent,
    required this.isPercent,
  });

  double get fraction => limit <= 0 ? 0 : spent / limit;
  int get remaining => limit - spent;
  bool get isOver => spent > limit;
}

/// Where a budget is heading if the rest of the period looks like the part of
/// it that has already happened.
///
/// Cashew cannot produce this: it only creates a recurring transaction when the
/// previous one is paid, so it does not know what is still coming. Here the
/// recurring engine has already materialised the period's instances, and
/// upcoming transactions carry a date, so both are knowable.
class BudgetForecast {
  /// Projected total for the whole window, in cents.
  final int projected;

  /// The limit it is being measured against, in cents.
  final int limit;

  /// Of [projected], what is already committed by dated transactions that have
  /// not happened yet rather than extrapolated from the run rate.
  final int scheduled;

  const BudgetForecast({
    required this.projected,
    required this.limit,
    required this.scheduled,
  });

  bool get willExceed => projected > limit;

  /// How far over, in cents. Zero when it is not heading over.
  int get overBy => willExceed ? projected - limit : 0;
}

/// What a budget has consumed over one window.
class BudgetProgress {
  final BudgetView budget;
  final BudgetWindow window;

  /// Spent, or earned for an income budget, in cents. Never negative.
  final int spent;

  /// The limit for this window in cents, including anything rolled over.
  final int limit;

  /// Unspent amount carried in from earlier windows, in cents.
  final int carriedIn;

  /// The currency [spent] and [limit] are expressed in.
  final String currency;

  /// How many transactions were left out because no rate was known for the
  /// account they sit in.
  ///
  /// A budget that quietly drops half its spending reads as a budget being kept
  /// to, which is the most misleading thing it could do.
  final int excluded;

  const BudgetProgress({
    required this.budget,
    required this.window,
    required this.spent,
    required this.limit,
    this.carriedIn = 0,
    this.currency = 'USD',
    this.excluded = 0,
  });

  /// Share of the limit used, from 0 upward. Can exceed 1.
  double get fraction => limit <= 0 ? 0 : spent / limit;

  int get remaining => limit - spent;

  bool get isOver => spent > limit;

  /// How far through the window we are, for the pace marker.
  double paceAt(DateTime moment) => window.elapsedFraction(moment);

  /// Whether spending is running ahead of the clock.
  bool isAheadOfPace(DateTime moment) =>
      limit > 0 && fraction > window.elapsedFraction(moment);

  /// What can still be spent per day for the rest of the window, in cents.
  ///
  /// Null once the window has closed, or when already over.
  int? dailyAllowanceFrom(DateTime moment) {
    if (remaining <= 0) return null;
    final left = window.end.difference(moment).inDays;
    if (left <= 0) return null;
    return remaining ~/ left;
  }
}

/// The one place a budget's consumption is calculated.
///
/// There used to be four, and they disagreed. Two of them filtered on a
/// deprecated `type` column that nothing has written since transactions gained
/// a direction flag, so every row read as `'regular'`, nothing matched, and the
/// budget list and the alert checker both reported zero spent no matter what
/// the user did. A third summed cents against a limit held in dollars. Only the
/// dashboard's went through the shared eligibility policy.
/// A budget's spending is summed across whatever accounts it covers, and those
/// accounts need not agree on a currency. Every total here used to add raw minor
/// units and label the result in the default currency, so a taka expense counted
/// the same as a dollar one. Amounts are converted first, and a row whose
/// account has no known rate is excluded and counted rather than added as though
/// it were the same money.
class BudgetEngine {
  final AppDatabase _db;

  const BudgetEngine(this._db);

  /// The currency [budget] is counted in: its own, recorded when it was made.
  ///
  /// A budget's amount is a bare number of minor units with nothing beside it
  /// saying what kind of money it counts. This used to answer with the display
  /// currency at the moment of reading, which meant the answer moved: opening a
  /// euro account and making it the default turned a $100 budget into a €100
  /// budget, with the figure on screen never changing. A number that changes
  /// meaning without changing is the worst way for this to be wrong, because
  /// there is nothing for the user to notice.
  ///
  /// The fallback is the old behaviour, and applies to exactly two cases: a
  /// budget written before budgets carried a currency — the upgrade stamps
  /// those with what they were already being read as, so this is only reached
  /// if there were no accounts at the time — and one pulled from a server that
  /// predates the field.
  Future<String> currencyFor(BudgetView budget) async =>
      budget.currency ?? await _db.displayCurrency();

  Future<AmountConverter> _converterFor(BudgetView budget) async =>
      AmountConverter.forDatabase(_db, target: await currencyFor(budget));

  /// Progress for [budget] over the window containing [moment].
  ///
  /// [offset] steps to an earlier or later window, which is how the detail
  /// screen walks through past periods.
  Future<BudgetProgress> progressFor(
    BudgetView budget, {
    DateTime? moment,
    int offset = 0,
  }) async {
    final now = moment ?? DateTime.now();
    final window = BudgetWindows.relative(
      start: budget.startDate,
      period: budget.period,
      periodLength: budget.periodLength,
      moment: now,
      offset: offset,
      explicitEnd: budget.endDate,
    );

    final converter = await _converterFor(budget);
    final spent = await _spentIn(budget, window, converter);
    final carriedIn = budget.rollover
        ? await _carriedInto(budget, window, now, converter)
        : 0;

    return BudgetProgress(
      budget: budget,
      window: window,
      spent: spent.total,
      limit: budget.amount + carriedIn,
      carriedIn: carriedIn,
      currency: converter.target,
      excluded: spent.excluded,
    );
  }

  /// Progress for several budgets at once.
  Future<List<BudgetProgress>> progressForAll(
    Iterable<BudgetView> budgets, {
    DateTime? moment,
  }) async {
    final now = moment ?? DateTime.now();
    final out = <BudgetProgress>[];
    for (final b in budgets) {
      out.add(await progressFor(b, moment: now));
    }
    return out;
  }

  /// Consumption per category over [window], largest first.
  ///
  /// Keyed by the transaction's own category, so a subcategory is its own line
  /// even though the budget counts it toward the parent. "Where did it go" and
  /// "have I overspent on food" are different questions.
  Future<Map<String, int>> byCategory(
    BudgetView budget,
    BudgetWindow window,
  ) async {
    final scope = await _scopeFor(budget);
    final converter = await _converterFor(budget);
    final rows = await _db.getTransactionsByDateRange(window.start, window.end);

    final totals = <String, int>{};
    for (final t in rows) {
      if (!_counts(t, budget, scope, window)) continue;
      final amount = converter.convert(t.amount, t.walletId);
      if (amount == null) continue;
      final key = t.categoryId ?? '';
      totals[key] = (totals[key] ?? 0) + amount;
    }

    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final e in sorted) e.key: e.value};
  }

  /// Running total per day across [window], for the line graph.
  Future<List<int>> dailyTotals(
    BudgetView budget,
    BudgetWindow window, {
    bool cumulative = false,
  }) async {
    final scope = await _scopeFor(budget);
    final converter = await _converterFor(budget);
    final rows = await _db.getTransactionsByDateRange(window.start, window.end);

    final days = window.end.difference(window.start).inDays.clamp(1, 3660);
    final perDay = List<int>.filled(days, 0);

    for (final t in rows) {
      if (!_counts(t, budget, scope, window)) continue;
      final index = t.date.difference(window.start).inDays;
      if (index < 0 || index >= days) continue;
      final amount = converter.convert(t.amount, t.walletId);
      if (amount == null) continue;
      perDay[index] += amount;
    }

    if (!cumulative) return perDay;

    var running = 0;
    return [for (final value in perDay) running += value];
  }

  /// Each category cap inside [budget], with what has gone against it.
  ///
  /// A percentage cap is resolved against the window's limit, so it moves with
  /// the budget instead of going stale when the amount changes.
  Future<List<CategoryLimitProgress>> categoryLimits(
    BudgetView budget,
    BudgetProgress progress,
  ) async {
    final limits = await _db.getCategoryLimitsForBudget(budget.id);
    if (limits.isEmpty) return const [];

    final converter = await _converterFor(budget);
    final rows = await _db.getTransactionsByDateRange(
      progress.window.start,
      progress.window.end,
    );

    final out = <CategoryLimitProgress>[];
    for (final limit in limits) {
      // The capped category and anything filed inside it, for the same reason
      // the budget itself counts subcategories toward their parent.
      final family = await _db.categoryFamilyIds(limit.categoryId);

      var spent = 0;
      for (final t in rows) {
        if (!_counts(t, budget, family, progress.window)) continue;
        final amount = converter.convert(t.amount, t.walletId);
        if (amount == null) continue;
        spent += amount;
      }

      out.add(
        CategoryLimitProgress(
          limitId: limit.id,
          categoryId: limit.categoryId,
          // Hundredths of a percent, so 2550 is 25.5% of the window's limit.
          limit: limit.isPercent
              ? (progress.limit * limit.amount) ~/ 10000
              : limit.amount,
          spent: spent,
          isPercent: limit.isPercent,
        ),
      );
    }

    out.sort((a, b) => b.fraction.compareTo(a.fraction));
    return out;
  }

  /// Where [progress] is heading by the end of its window.
  ///
  /// Two things are added to what has already gone out: transactions that are
  /// dated inside the rest of the window but have not happened yet, which are
  /// known exactly, and a straight-line projection of the run rate for whatever
  /// is left after those. Returns null once the window has closed, when there
  /// is nothing left to forecast.
  Future<BudgetForecast?> forecast(
    BudgetView budget,
    BudgetProgress progress, {
    DateTime? moment,
  }) async {
    final now = moment ?? DateTime.now();
    if (!progress.window.contains(now)) return null;

    final scope = await _scopeFor(budget);
    final converter = await _converterFor(budget);
    final rows = await _db.getTransactionsByDateRange(now, progress.window.end);

    // Already dated, not yet counted: an upcoming bill inside this window is
    // not a guess, it is a commitment the app already knows about.
    var scheduled = 0;
    for (final t in rows) {
      if (!progress.window.contains(t.date)) continue;
      if (!t.date.isAfter(now)) continue;
      if (!TransactionPolicy.isForecast(t)) continue;
      if (budget.walletIds.isNotEmpty &&
          !budget.walletIds.contains(t.walletId)) {
        continue;
      }
      if (t.isIncome != budget.isIncome) continue;
      if (scope.isNotEmpty &&
          (t.categoryId == null || !scope.contains(t.categoryId))) {
        continue;
      }
      final amount = converter.convert(t.amount, t.walletId);
      if (amount == null) continue;
      scheduled += amount;
    }

    final elapsed = progress.window.elapsedFraction(now);
    // Below a day or so of data the run rate says more about one purchase than
    // about the month, so only the committed part is projected.
    final extrapolated = elapsed < _minElapsedToProject
        ? 0
        : ((progress.spent / elapsed) - progress.spent).round();

    return BudgetForecast(
      projected:
          progress.spent + scheduled + (extrapolated < 0 ? 0 : extrapolated),
      limit: progress.limit,
      scheduled: scheduled,
    );
  }

  Future<_Spent> _spentIn(
    BudgetView budget,
    BudgetWindow window,
    AmountConverter converter,
  ) async {
    final scope = await _scopeFor(budget);
    final rows = await _db.getTransactionsByDateRange(window.start, window.end);

    var total = 0;
    var excluded = 0;
    for (final t in rows) {
      if (!_counts(t, budget, scope, window)) continue;
      final amount = converter.convert(t.amount, t.walletId);
      if (amount == null) {
        excluded++;
        continue;
      }
      total += amount;
    }
    return _Spent(total, excluded);
  }

  /// What earlier windows left unspent, when the budget rolls over.
  ///
  /// Only looks back at windows that have actually closed, and never lets the
  /// carry go negative: an overspent month reduces the next month's headroom to
  /// its own limit, it does not create a debt that compounds.
  ///
  /// Every closed window is walked, however many there are. This used to stop
  /// after twenty-four, which was reasoned about as cost and not as correctness:
  /// a daily budget began quietly losing earned headroom after twenty-four days,
  /// and the user saw a smaller allowance with nothing to explain it. The cost
  /// was one spend query per window; the rows are fetched once from the budget's
  /// start and bucketed by window index instead, which is a single query however
  /// long the budget has been running. There is nothing left for a limit to
  /// protect.
  Future<int> _carriedInto(
    BudgetView budget,
    BudgetWindow window,
    DateTime now,
    AmountConverter converter,
  ) async {
    final windows = BudgetWindows.indexOf(
      start: budget.startDate,
      period: budget.period,
      periodLength: budget.periodLength,
      moment: window.start,
    );
    if (windows <= 0) return 0;

    // Every boundary up front, from the anchor, so a row can be placed by
    // searching rather than by asking the database once per window.
    final boundaries = [
      for (var i = 0; i <= windows; i++)
        BudgetWindows.startOfIndex(
          budget.startDate,
          budget.period,
          budget.periodLength,
          i,
        ),
    ];

    final scope = await _scopeFor(budget);
    final rows = await _db.getTransactionsByDateRange(
      boundaries.first,
      boundaries.last,
    );

    final spentPerWindow = List<int>.filled(windows, 0);
    for (final t in rows) {
      final index = _windowIndexOf(boundaries, t.date);
      if (index == null) continue;
      if (!_counts(
        t,
        budget,
        scope,
        BudgetWindow(boundaries[index], boundaries[index + 1]),
      )) {
        continue;
      }
      final amount = converter.convert(t.amount, t.walletId);
      if (amount == null) continue;
      spentPerWindow[index] += amount;
    }

    var carried = 0;
    for (var i = 0; i < windows; i++) {
      // A window still open has not left anything over yet.
      if (!boundaries[i + 1].isBefore(now)) break;
      // That window's allowance was its own limit plus whatever reached it.
      final leftOver = budget.amount + carried - spentPerWindow[i];
      // An overspend costs the carry but does not become a debt that compounds:
      // the next window still gets its own full limit.
      carried = leftOver < 0 ? 0 : leftOver;
    }
    return carried;
  }

  /// Which of [boundaries] the [moment] falls in, or null when it falls outside.
  ///
  /// Binary search, because a daily budget running for years has as many
  /// boundaries as it has days and a scan per transaction would put the cost
  /// straight back where removing the lookback limit took it from.
  static int? _windowIndexOf(List<DateTime> boundaries, DateTime moment) {
    if (moment.isBefore(boundaries.first)) return null;
    if (!moment.isBefore(boundaries.last)) return null;

    var low = 0;
    var high = boundaries.length - 2;
    while (low <= high) {
      final mid = (low + high) ~/ 2;
      if (moment.isBefore(boundaries[mid])) {
        high = mid - 1;
      } else if (!moment.isBefore(boundaries[mid + 1])) {
        low = mid + 1;
      } else {
        return mid;
      }
    }
    return null;
  }

  /// The category ids this budget counts, with subcategories folded in.
  ///
  /// Empty means every category. A budget names an area of spending rather than
  /// a label: someone with a Food budget who files lunches under Sandwich, a
  /// category they put inside Food, has not stopped spending on food.
  Future<Set<String>> _scopeFor(BudgetView budget) async {
    if (budget.categoryIds.isEmpty) return const {};
    final all = <String>{};
    for (final id in budget.categoryIds) {
      all.addAll(await _db.categoryFamilyIds(id));
    }
    return all;
  }

  bool _counts(
    Transaction t,
    BudgetView budget,
    Set<String> categoryScope,
    BudgetWindow window,
  ) {
    if (!window.contains(t.date)) return false;
    if (budget.walletIds.isNotEmpty && !budget.walletIds.contains(t.walletId)) {
      return false;
    }
    return TransactionPolicy.countsTowardBudget(
      t,
      budgetIsIncome: budget.isIncome,
      budgetCategoryIds: categoryScope,
    );
  }

  /// How much of a window must have passed before a run rate is projected.
  ///
  /// Early on, one large purchase extrapolates to an absurd total and the
  /// warning would be noise on the first of every month.
  static const double _minElapsedToProject = 0.15;
}

/// A window's consumption, and what could not be counted into it.
class _Spent {
  final int total;
  final int excluded;

  const _Spent(this.total, this.excluded);
}
