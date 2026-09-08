import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:uuid/uuid.dart';

/// One budget, as the UI needs it.
///
/// Money is integer minor units (cents) here, matching the column and the rest
/// of the app. It used to be major-unit dollars on this class alone, which is
/// how the alert checker ended up dividing cents by dollars and reporting
/// spending at a hundred times its real share of the limit.
class BudgetView {
  final String id;
  final String name;

  /// The limit, in cents.
  final int amount;

  /// The currency [amount] is stated in, or null on a budget written before
  /// budgets carried one. See `BudgetEngine.currencyFor` for the fallback.
  final String? currency;

  /// Category ids this budget is scoped to. Empty means every category.
  final List<String> categoryIds;

  /// Wallet ids this budget is scoped to. Empty means every wallet.
  final List<String> walletIds;

  final BudgetPeriod period;

  /// How many [period] units one window spans. Always at least 1.
  final int periodLength;

  final DateTime startDate;

  /// When the budget stops repeating. Null means it does not.
  final DateTime? endDate;

  /// Whether this budget tracks earnings rather than spending.
  ///
  /// Every consumer needs it to ask the shared policy the right question;
  /// without it the reports tab treated income budgets as expense budgets.
  final bool isIncome;

  final bool isPinned;
  final bool isArchived;
  final bool rollover;
  final DateTime createdAt;

  const BudgetView({
    required this.id,
    required this.name,
    required this.amount,
    required this.period,
    required this.startDate,
    required this.createdAt,
    this.categoryIds = const [],
    this.walletIds = const [],
    this.periodLength = 1,
    this.endDate,
    this.isIncome = false,
    this.isPinned = false,
    this.isArchived = false,
    this.rollover = false,
    this.currency,
  });

  factory BudgetView.fromRow(Budget row) => BudgetView(
    id: row.id,
    name: row.name,
    amount: row.amount,
    categoryIds: AppDatabase.decodeIdList(row.categoryIds),
    walletIds: AppDatabase.decodeIdList(row.walletIds),
    period: parsePeriod(row.period),
    periodLength: row.periodLength < 1 ? 1 : row.periodLength,
    startDate: row.startDate,
    endDate: row.endDate,
    isIncome: row.isIncome,
    isPinned: row.isPinned,
    isArchived: row.isArchived,
    rollover: row.rollover,
    createdAt: row.createdAt,
    currency: row.currency,
  );

  /// The stored period name as an enum, defaulting to monthly for anything
  /// unrecognised so one bad row cannot take the screen down.
  static BudgetPeriod parsePeriod(String raw) {
    final wanted = raw.toLowerCase();
    for (final value in BudgetPeriod.values) {
      if (value.name == wanted) return value;
    }
    return BudgetPeriod.monthly;
  }
}

class BudgetState {
  final List<BudgetView> budgets;
  final bool isLoading;
  final String? errorMessage;

  const BudgetState({
    required this.budgets,
    required this.isLoading,
    this.errorMessage,
  });

  BudgetState copyWith({
    List<BudgetView>? budgets,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  final AppDatabase _db;

  BudgetNotifier(this._db)
    : super(const BudgetState(budgets: [], isLoading: false)) {
    loadBudgets();
  }

  /// Every live budget, archived ones included.
  ///
  /// Rows with no end date are kept. They used to be dropped here, which meant
  /// a repeating budget — the ordinary kind, which has no finish — was invisible
  /// on this screen while the dashboard, reading straight from the database,
  /// showed it. The two surfaces disagreed about which budgets existed.
  Future<void> loadBudgets({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);
    try {
      final rows = await _db.getAllBudgets();
      state = state.copyWith(
        budgets: rows.map(BudgetView.fromRow).toList(),
        isLoading: false,
      );
    } catch (e) {
      if (!silent) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load budgets',
        );
      }
    }
  }

  /// Create a budget. Returns its id.
  ///
  /// [amount] is in cents. Creating one used to throw outright: the insert
  /// never wrote `amount`, which the column requires, so nothing reached the
  /// database and the screen reported a generic failure.
  /// Create a budget.
  ///
  /// [currency] is what the amount was entered in, and it is recorded rather
  /// than inferred later: a bare count of minor units means nothing on its own,
  /// and answering "which money?" at read time meant the answer moved when the
  /// user's default account did. Defaults to the display currency, which is
  /// what the form labels the field with.
  Future<String> addBudget({
    required String name,
    required int amount,
    required BudgetPeriod period,
    required DateTime startDate,
    String? currency,
    int periodLength = 1,
    DateTime? endDate,
    List<String> categoryIds = const [],
    List<String> walletIds = const [],
    bool isIncome = false,
    bool isPinned = false,
    bool rollover = false,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // No limit on budgets. Somebody who wants a fourth has already made the
      // app part of how they manage their money, and that is the worst moment
      // to interrupt them for it. See `FreeTierLimits`.

      final id = const Uuid().v4();
      final now = DateTime.now();
      // Resolved here rather than trusted from the caller alone, so a budget
      // created by any path still records what its figure means.
      final statedIn = currency ?? await _db.displayCurrency();
      await _db.addBudget(
        BudgetsCompanion.insert(
          id: id,
          name: name,
          amount: amount,
          currency: Value(statedIn),
          startDate: startDate,
          period: Value(period.name),
          periodLength: Value(periodLength < 1 ? 1 : periodLength),
          endDate: Value(endDate),
          categoryIds: Value(jsonEncode(categoryIds)),
          walletIds: Value(jsonEncode(walletIds)),
          isIncome: Value(isIncome),
          isPinned: Value(isPinned),
          rollover: Value(rollover),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      AnalyticsService().logBudgetCreate();
      await loadBudgets();
      return id;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is PremiumLimitException
            ? e.message
            : 'Failed to add budget',
      );
      rethrow;
    }
  }

  /// Sentinel meaning "leave the end date alone", so null can mean "clear it".
  static const Object keepEndDate = Object();

  /// Change a budget. Anything left out keeps its current value.
  ///
  /// Writes only the fields it was given rather than replacing the row, which
  /// the old version did — and because it built a partial companion, that reset
  /// every column it did not mention, wiping the amount and the scope on every
  /// edit.
  Future<void> updateBudget({
    required String id,
    String? name,
    int? amount,
    BudgetPeriod? period,
    int? periodLength,
    DateTime? startDate,
    Object? endDate = keepEndDate,
    List<String>? categoryIds,
    List<String>? walletIds,
    bool? isIncome,
    bool? isPinned,
    bool? isArchived,
    bool? rollover,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findBudgetById(id);
      if (existing == null) throw Exception('Budget not found');

      await _db.writeBudget(
        id,
        BudgetsCompanion(
          name: name == null ? const Value.absent() : Value(name),
          amount: amount == null ? const Value.absent() : Value(amount),
          period: period == null ? const Value.absent() : Value(period.name),
          periodLength: periodLength == null
              ? const Value.absent()
              : Value(periodLength < 1 ? 1 : periodLength),
          startDate: startDate == null
              ? const Value.absent()
              : Value(startDate),
          endDate: identical(endDate, keepEndDate)
              ? const Value.absent()
              : Value(endDate as DateTime?),
          categoryIds: categoryIds == null
              ? const Value.absent()
              : Value(jsonEncode(categoryIds)),
          walletIds: walletIds == null
              ? const Value.absent()
              : Value(jsonEncode(walletIds)),
          isIncome: isIncome == null ? const Value.absent() : Value(isIncome),
          isPinned: isPinned == null ? const Value.absent() : Value(isPinned),
          isArchived: isArchived == null
              ? const Value.absent()
              : Value(isArchived),
          rollover: rollover == null ? const Value.absent() : Value(rollover),
        ),
      );

      await loadBudgets();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update budget',
      );
      rethrow;
    }
  }

  Future<void> deleteBudget(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _db.softDeleteBudget(id);
      AnalyticsService().logBudgetDelete();
      await loadBudgets();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete budget',
      );
      rethrow;
    }
  }

  Future<void> setArchived(String id, bool archived) =>
      updateBudget(id: id, isArchived: archived);

  Future<void> setPinned(String id, bool pinned) =>
      updateBudget(id: id, isPinned: pinned);

  BudgetView? getBudgetById(String id) {
    for (final b in state.budgets) {
      if (b.id == id) return b;
    }
    return null;
  }

  /// Budgets that are running right now: started, not finished, not archived.
  List<BudgetView> activeBudgets() {
    final now = DateTime.now();
    return state.budgets
        .where(
          (b) =>
              !b.isArchived &&
              !b.startDate.isAfter(now) &&
              (b.endDate == null || b.endDate!.isAfter(now)),
        )
        .toList();
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return BudgetNotifier(db);
});
