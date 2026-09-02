import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/budgets/domain/budget_window.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

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

  const BudgetProgress({
    required this.budget,
    required this.window,
    required this.spent,
    required this.limit,
    this.carriedIn = 0,
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
class BudgetEngine {
  final AppDatabase _db;

  const BudgetEngine(this._db);

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

    final spent = await _spentIn(budget, window);
    final carriedIn = budget.rollover
        ? await _carriedInto(budget, window, now)
        : 0;

    return BudgetProgress(
      budget: budget,
      window: window,
      spent: spent,
      limit: budget.amount + carriedIn,
      carriedIn: carriedIn,
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
    final rows = await _db.getTransactionsByDateRange(window.start, window.end);

    final totals = <String, int>{};
    for (final t in rows) {
      if (!_counts(t, budget, scope, window)) continue;
      final key = t.categoryId ?? '';
      totals[key] = (totals[key] ?? 0) + t.amount;
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
    final rows = await _db.getTransactionsByDateRange(window.start, window.end);

    final days = window.end.difference(window.start).inDays.clamp(1, 3660);
    final perDay = List<int>.filled(days, 0);

    for (final t in rows) {
      if (!_counts(t, budget, scope, window)) continue;
      final index = t.date.difference(window.start).inDays;
      if (index < 0 || index >= days) continue;
      perDay[index] += t.amount;
    }

    if (!cumulative) return perDay;

    var running = 0;
    return [
      for (final value in perDay) running += value,
    ];
  }

  Future<int> _spentIn(BudgetView budget, BudgetWindow window) async {
    final scope = await _scopeFor(budget);
    final rows = await _db.getTransactionsByDateRange(window.start, window.end);

    var total = 0;
    for (final t in rows) {
      if (_counts(t, budget, scope, window)) total += t.amount;
    }
    return total;
  }

  /// What earlier windows left unspent, when the budget rolls over.
  ///
  /// Only looks back at windows that have actually closed, and never lets the
  /// carry go negative: an overspent month reduces the next month's headroom to
  /// its own limit, it does not create a debt that compounds.
  Future<int> _carriedInto(
    BudgetView budget,
    BudgetWindow window,
    DateTime now,
  ) async {
    var carried = 0;
    final windows = BudgetWindows.indexOf(
      start: budget.startDate,
      period: budget.period,
      periodLength: budget.periodLength,
      moment: window.start,
    );

    // Bounded so a budget started years ago cannot make this unbounded work.
    final first = windows > _maxRolloverLookback
        ? windows - _maxRolloverLookback
        : 0;

    for (var i = first; i < windows; i++) {
      final past = BudgetWindows.relative(
        start: budget.startDate,
        period: budget.period,
        periodLength: budget.periodLength,
        moment: budget.startDate,
        offset: i,
        explicitEnd: budget.endDate,
      );
      if (!past.end.isBefore(now)) break;
      final spent = await _spentIn(budget, past);
      // That window's allowance was its own limit plus whatever reached it.
      final leftOver = budget.amount + carried - spent;
      // An overspend costs the carry but does not become a debt that compounds:
      // the next window still gets its own full limit.
      carried = leftOver < 0 ? 0 : leftOver;
    }
    return carried;
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

  static const int _maxRolloverLookback = 24;
}
