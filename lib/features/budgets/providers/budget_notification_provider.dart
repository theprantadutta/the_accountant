import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/core/services/notification_service.dart';

class BudgetNotificationState {
  final bool isEnabled;
  final double
  warningThreshold; // Percentage at which to send warning (e.g., 80%)
  final bool isLoading;
  final String? errorMessage;

  BudgetNotificationState({
    required this.isEnabled,
    required this.warningThreshold,
    required this.isLoading,
    this.errorMessage,
  });

  BudgetNotificationState copyWith({
    bool? isEnabled,
    double? warningThreshold,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BudgetNotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BudgetNotificationNotifier
    extends StateNotifier<BudgetNotificationState> {
  final Ref _ref;

  BudgetNotificationNotifier(this._ref)
    : super(
        BudgetNotificationState(
          isEnabled: true,
          warningThreshold: 80.0,
          isLoading: false,
        ),
      ) {
    // Check budgets periodically
    _checkBudgetsPeriodically();
  }

  void _checkBudgetsPeriodically() {
    // Check budgets every hour
    Future.delayed(const Duration(hours: 1), () {
      _checkBudgets();
      _checkBudgetsPeriodically(); // Recursive call
    });
  }

  Future<void> _checkBudgets() async {
    if (!state.isEnabled) return;

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
        if (percentage >= state.warningThreshold) {
          await NotificationService().showBudgetWarningNotification(
            budget.name,
            percentage,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to check budgets');
    }
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }

  void setWarningThreshold(double threshold) {
    state = state.copyWith(warningThreshold: threshold);
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
