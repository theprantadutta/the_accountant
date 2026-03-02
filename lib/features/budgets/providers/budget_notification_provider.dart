import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/features/settings/providers/notification_preferences_provider.dart';

class BudgetNotificationState {
  final bool isLoading;
  final String? errorMessage;

  BudgetNotificationState({
    required this.isLoading,
    this.errorMessage,
  });

  BudgetNotificationState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return BudgetNotificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BudgetNotificationNotifier
    extends StateNotifier<BudgetNotificationState> {
  final Ref _ref;
  Timer? _timer;

  BudgetNotificationNotifier(this._ref)
    : super(BudgetNotificationState(isLoading: false)) {
    // Check budgets every hour
    _timer = Timer.periodic(const Duration(hours: 1), (_) {
      _checkBudgets();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkBudgets() async {
    final prefs = _ref.read(notificationPreferencesProvider);
    if (!prefs.budgetAlertsEnabled) return;
    final threshold = prefs.budgetWarningThreshold;

    try {
      final budgetState = _ref.read(budgetProvider);
      final transactionState = _ref.read(transactionProvider);

      for (final budget in budgetState.budgets) {
        // Calculate spent amount for this budget's category and date range
        final spent = transactionState.transactions
            .where(
              (transaction) =>
                  transaction.categoryId == budget.categoryId &&
                  transaction.type == 'expense' &&
                  transaction.date.isAfter(budget.startDate) &&
                  transaction.date.isBefore(budget.endDate),
            )
            // Fix: Convert num to double explicitly
            .fold<double>(
              0.0,
              (sum, transaction) => sum + transaction.amount.toDouble(),
            );

        final percentage = budget.limit > 0
            ? (spent / budget.limit) * 100.0
            : 0.0;

        // Send notification if budget is over threshold
        if (percentage >= threshold) {
          await NotificationService().showBudgetWarningNotification(
            budget.name,
            percentage,
            budgetId: budget.id,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to check budgets');
    }
  }

  Future<void> checkBudgetsNow() async {
    state = state.copyWith(isLoading: true);
    await _checkBudgets();
    state = state.copyWith(isLoading: false);
  }
}

final budgetNotificationProvider =
    StateNotifierProvider<BudgetNotificationNotifier, BudgetNotificationState>((
      ref,
    ) {
      return BudgetNotificationNotifier(ref);
    });
