import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/api_service.dart';

/// State for notification preferences synced with the backend.
class NotificationPreferencesState {
  final bool isLoading;
  final String? errorMessage;
  final bool dailyReminderEnabled;
  final TimeOfDay dailyReminderTime;
  final String dailyReminderTimezone;
  final bool budgetAlertsEnabled;
  final double budgetWarningThreshold;
  final bool largeTransactionAlertsEnabled;
  final double largeTransactionThreshold;
  final bool recurringTransactionRemindersEnabled;
  final int recurringReminderDaysBefore;
  final bool subscriptionExpiryAlertsEnabled;
  final bool promotionalNotificationsEnabled;

  const NotificationPreferencesState({
    this.isLoading = false,
    this.errorMessage,
    this.dailyReminderEnabled = true,
    this.dailyReminderTime = const TimeOfDay(hour: 19, minute: 0),
    this.dailyReminderTimezone = 'UTC',
    this.budgetAlertsEnabled = true,
    this.budgetWarningThreshold = 80.0,
    this.largeTransactionAlertsEnabled = false,
    this.largeTransactionThreshold = 500.0,
    this.recurringTransactionRemindersEnabled = false,
    this.recurringReminderDaysBefore = 1,
    this.subscriptionExpiryAlertsEnabled = true,
    this.promotionalNotificationsEnabled = true,
  });

  NotificationPreferencesState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? dailyReminderEnabled,
    TimeOfDay? dailyReminderTime,
    String? dailyReminderTimezone,
    bool? budgetAlertsEnabled,
    double? budgetWarningThreshold,
    bool? largeTransactionAlertsEnabled,
    double? largeTransactionThreshold,
    bool? recurringTransactionRemindersEnabled,
    int? recurringReminderDaysBefore,
    bool? subscriptionExpiryAlertsEnabled,
    bool? promotionalNotificationsEnabled,
  }) {
    return NotificationPreferencesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      dailyReminderTimezone: dailyReminderTimezone ?? this.dailyReminderTimezone,
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
      budgetWarningThreshold: budgetWarningThreshold ?? this.budgetWarningThreshold,
      largeTransactionAlertsEnabled:
          largeTransactionAlertsEnabled ?? this.largeTransactionAlertsEnabled,
      largeTransactionThreshold:
          largeTransactionThreshold ?? this.largeTransactionThreshold,
      recurringTransactionRemindersEnabled:
          recurringTransactionRemindersEnabled ??
              this.recurringTransactionRemindersEnabled,
      recurringReminderDaysBefore:
          recurringReminderDaysBefore ?? this.recurringReminderDaysBefore,
      subscriptionExpiryAlertsEnabled:
          subscriptionExpiryAlertsEnabled ?? this.subscriptionExpiryAlertsEnabled,
      promotionalNotificationsEnabled:
          promotionalNotificationsEnabled ?? this.promotionalNotificationsEnabled,
    );
  }
}

/// Notifier for managing notification preferences with backend sync.
class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferencesState> {
  final ApiService _apiService;
  final Logger _logger = Logger();

  NotificationPreferencesNotifier(this._apiService)
      : super(const NotificationPreferencesState());

  /// Load preferences from the backend.
  Future<void> loadPreferences() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.get('/notifications/preferences');
      final data = response.data;

      // Parse the time from the backend format (HH:MM:SS)
      TimeOfDay reminderTime = const TimeOfDay(hour: 19, minute: 0);
      if (data['daily_reminder_time'] != null) {
        final timeStr = data['daily_reminder_time'] as String;
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          reminderTime = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 19,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }

      state = state.copyWith(
        isLoading: false,
        dailyReminderEnabled: data['daily_reminder_enabled'] ?? true,
        dailyReminderTime: reminderTime,
        dailyReminderTimezone: data['daily_reminder_timezone'] ?? 'UTC',
        budgetAlertsEnabled: data['budget_alerts_enabled'] ?? true,
        budgetWarningThreshold:
            (data['budget_warning_threshold'] as num?)?.toDouble() ?? 80.0,
        largeTransactionAlertsEnabled:
            data['large_transaction_alerts_enabled'] ?? false,
        largeTransactionThreshold:
            (data['large_transaction_threshold'] as num?)?.toDouble() ?? 500.0,
        recurringTransactionRemindersEnabled:
            data['recurring_transaction_reminders_enabled'] ?? false,
        recurringReminderDaysBefore:
            data['recurring_reminder_days_before'] ?? 1,
        subscriptionExpiryAlertsEnabled:
            data['subscription_expiry_alerts_enabled'] ?? true,
        promotionalNotificationsEnabled:
            data['promotional_notifications_enabled'] ?? true,
      );

      _logger.i('Notification preferences loaded successfully');
    } catch (e) {
      _logger.e('Failed to load notification preferences: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load preferences',
      );
    }
  }

  /// Update a specific preference on the backend.
  Future<void> _updatePreference(Map<String, dynamic> updates) async {
    try {
      await _apiService.put('/notifications/preferences', data: updates);
      _logger.i('Preference updated successfully');
    } catch (e) {
      _logger.e('Failed to update preference: $e');
      state = state.copyWith(errorMessage: 'Failed to save preference');
      // Reload to get the actual state
      await loadPreferences();
    }
  }

  /// Toggle daily reminder.
  Future<void> setDailyReminderEnabled(bool enabled) async {
    state = state.copyWith(dailyReminderEnabled: enabled);
    await _updatePreference({'daily_reminder_enabled': enabled});
  }

  /// Set daily reminder time.
  Future<void> setDailyReminderTime(TimeOfDay time) async {
    state = state.copyWith(dailyReminderTime: time);
    // Format as HH:MM:SS for the backend
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
    await _updatePreference({'daily_reminder_time': timeStr});
  }

  /// Set daily reminder timezone.
  Future<void> setDailyReminderTimezone(String timezone) async {
    state = state.copyWith(dailyReminderTimezone: timezone);
    await _updatePreference({'daily_reminder_timezone': timezone});
  }

  /// Toggle budget alerts.
  Future<void> setBudgetAlertsEnabled(bool enabled) async {
    state = state.copyWith(budgetAlertsEnabled: enabled);
    await _updatePreference({'budget_alerts_enabled': enabled});
  }

  /// Set budget warning threshold.
  Future<void> setBudgetWarningThreshold(double threshold) async {
    state = state.copyWith(budgetWarningThreshold: threshold);
    await _updatePreference({'budget_warning_threshold': threshold});
  }

  /// Toggle large transaction alerts.
  Future<void> setLargeTransactionAlertsEnabled(bool enabled) async {
    state = state.copyWith(largeTransactionAlertsEnabled: enabled);
    await _updatePreference({'large_transaction_alerts_enabled': enabled});
  }

  /// Set large transaction threshold.
  Future<void> setLargeTransactionThreshold(double threshold) async {
    state = state.copyWith(largeTransactionThreshold: threshold);
    await _updatePreference({'large_transaction_threshold': threshold});
  }

  /// Toggle recurring transaction reminders.
  Future<void> setRecurringRemindersEnabled(bool enabled) async {
    state = state.copyWith(recurringTransactionRemindersEnabled: enabled);
    await _updatePreference(
      {'recurring_transaction_reminders_enabled': enabled},
    );
  }

  /// Set days before recurring reminder.
  Future<void> setRecurringReminderDaysBefore(int days) async {
    state = state.copyWith(recurringReminderDaysBefore: days);
    await _updatePreference({'recurring_reminder_days_before': days});
  }

  /// Toggle subscription expiry alerts.
  Future<void> setSubscriptionExpiryAlertsEnabled(bool enabled) async {
    state = state.copyWith(subscriptionExpiryAlertsEnabled: enabled);
    await _updatePreference({'subscription_expiry_alerts_enabled': enabled});
  }

  /// Toggle promotional notifications.
  Future<void> setPromotionalNotificationsEnabled(bool enabled) async {
    state = state.copyWith(promotionalNotificationsEnabled: enabled);
    await _updatePreference({'promotional_notifications_enabled': enabled});
  }
}

/// Provider for the API service.
final _apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider for notification preferences.
final notificationPreferencesProvider = StateNotifierProvider<
    NotificationPreferencesNotifier, NotificationPreferencesState>((ref) {
  final apiService = ref.watch(_apiServiceProvider);
  return NotificationPreferencesNotifier(apiService);
});
