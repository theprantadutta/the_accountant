import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

class Budget {
  final String id;
  final String name;
  final String categoryId;
  final double limit;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Budget({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.limit,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });
}

class BudgetState {
  final List<Budget> budgets;
  final bool isLoading;
  final String? errorMessage;

  BudgetState({
    required this.budgets,
    required this.isLoading,
    this.errorMessage,
  });

  BudgetState copyWith({
    List<Budget>? budgets,
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
  final Ref _ref;

  BudgetNotifier(this._db, this._ref)
    : super(BudgetState(budgets: [], isLoading: false)) {
    loadBudgets();
  }

  Future<void> loadBudgets({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);
    try {
      final dbBudgets = await _db.getAllBudgets();
      final budgets = dbBudgets
          .where(
            (b) => b.endDate != null,
          ) // Filter out budgets without end date
          .map(
            (b) => Budget(
              id: b.id,
              name: b.name,
              categoryId: b.categoryId ?? '',
              // Legacy view model keeps `limit` as major-unit dollars. The money column
              // `amount` is now integer cents, so convert it when falling back.
              limit: b.limit ?? (b.amount / 100.0), // Use amount (cents) if limit is null
              period: b.period,
              startDate: b.startDate,
              endDate: b.endDate!, // Safe because we filtered above
              createdAt: b.createdAt,
            ),
          )
          .toList();

      state = state.copyWith(budgets: budgets, isLoading: false);
    } catch (e) {
      if (!silent) {
        state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load budgets',
      );
      }
    }
  }

  Future<void> addBudget({
    required String name,
    required String categoryId,
    required double limit,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Check premium limit for active budgets
      final premiumState = _ref.read(premiumProvider);
      if (!premiumState.isPremium) {
        final activeBudgets = getActiveBudgets();
        if (activeBudgets.length >= FreeTierLimits.maxActiveBudgets) {
          throw PremiumLimitException(
            entityType: 'budget',
            currentCount: activeBudgets.length,
            limit: FreeTierLimits.maxActiveBudgets,
          );
        }
      }

      final now = DateTime.now();
      final newBudget = BudgetsCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        categoryId: Value(categoryId),
        limit: Value(limit),
        period: Value(period),
        startDate: Value(startDate),
        endDate: Value(endDate),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _db.addBudget(newBudget);
      AnalyticsService().logBudgetCreate();

      // Reload budgets to get the new one
      await loadBudgets();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is PremiumLimitException
            ? e.message
            : 'Failed to add budget',
      );
      rethrow; // Rethrow to let UI handle PremiumLimitException
    }
  }

  Future<void> updateBudget({
    required String id,
    String? name,
    String? categoryId,
    double? limit,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findBudgetById(id);
      if (existing == null) {
        throw Exception('Budget not found');
      }

      final updatedBudget = BudgetsCompanion(
        id: Value(id),
        name: Value(name ?? existing.name),
        categoryId: Value(categoryId ?? existing.categoryId),
        limit: Value(limit ?? existing.limit),
        period: Value(period ?? existing.period),
        startDate: Value(startDate ?? existing.startDate),
        endDate: Value(endDate ?? existing.endDate),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        createdAt: Value(existing.createdAt),
        updatedAt: Value(DateTime.now()),
      );

      await _db.updateBudget(updatedBudget);

      // Reload budgets to get the updated one
      await loadBudgets();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update budget',
      );
    }
  }

  Future<void> deleteBudget(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      await _db.deleteBudget(id);
      AnalyticsService().logBudgetDelete();

      // Reload budgets to reflect the deletion
      await loadBudgets();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete budget',
      );
    }
  }

  Budget? getBudgetById(String id) {
    try {
      return state.budgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Budget> getActiveBudgets() {
    final now = DateTime.now();
    return state.budgets
        .where(
          (budget) =>
              budget.startDate.isBefore(now) && budget.endDate.isAfter(now),
        )
        .toList();
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return BudgetNotifier(db, ref);
});
