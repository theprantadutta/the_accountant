import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/settings/providers/notification_preferences_provider.dart';

class BudgetNotificationState {
  final bool isLoading;
  final String? errorMessage;

  const BudgetNotificationState({required this.isLoading, this.errorMessage});

  BudgetNotificationState copyWith({bool? isLoading, String? errorMessage}) {
    return BudgetNotificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Watches running budgets and warns when one is close to, or past, its limit.
///
/// The comparison used to be wrong twice over. It summed transaction amounts,
/// which are integer cents, against a limit held in major-unit dollars, so any
/// figure it produced was a hundred times too large. And it filtered on a
/// deprecated `type` column that nothing writes, so the sum was always zero and
/// no alert could fire regardless. Both are gone: consumption now comes from
/// the one budget engine, in cents, through the shared eligibility policy.
class BudgetNotificationNotifier
    extends StateNotifier<BudgetNotificationState> {
  final Ref _ref;
  Timer? _timer;

  BudgetNotificationNotifier(this._ref)
    : super(const BudgetNotificationState(isLoading: false)) {
    // Once at startup, then hourly. Waiting a full hour meant a budget that was
    // already over when the app opened stayed quiet until then.
    scheduleMicrotask(_checkBudgets);
    _timer = Timer.periodic(const Duration(hours: 1), (_) => _checkBudgets());
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
      final engine = BudgetEngine(_ref.read(databaseProvider));
      final notifier = _ref.read(budgetProvider.notifier);
      // Read straight from the database rather than whatever the list screen
      // last loaded, so the check does not depend on a screen having been open.
      await notifier.loadBudgets(silent: true);

      for (final budget in notifier.activeBudgets()) {
        final progress = await engine.progressFor(budget);
        if (progress.limit <= 0) continue;

        final percentage = progress.fraction * 100;
        if (percentage < threshold) continue;

        await NotificationService().showBudgetWarningNotification(
          budget.name,
          percentage,
          budgetId: budget.id,
        );
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
