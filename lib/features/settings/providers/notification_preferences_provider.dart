import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/notification_service.dart';

/// Local storage keys for notification preferences
class _PrefsKeys {
  static const String prefix = 'notification_prefs_';
  static const String dailyReminderEnabled = '${prefix}daily_reminder_enabled';
  static const String dailyReminderTime = '${prefix}daily_reminder_time';
  static const String dailyReminderTimezone =
      '${prefix}daily_reminder_timezone';
  static const String budgetAlertsEnabled = '${prefix}budget_alerts_enabled';
  static const String budgetWarningThreshold =
      '${prefix}budget_warning_threshold';
  static const String largeTransactionAlertsEnabled =
      '${prefix}large_transaction_alerts_enabled';
  static const String largeTransactionThreshold =
      '${prefix}large_transaction_threshold';
  static const String recurringRemindersEnabled =
      '${prefix}recurring_reminders_enabled';
  static const String recurringReminderDaysBefore =
      '${prefix}recurring_reminder_days_before';
  static const String subscriptionExpiryAlertsEnabled =
      '${prefix}subscription_expiry_alerts_enabled';
  static const String promotionalNotificationsEnabled =
      '${prefix}promotional_notifications_enabled';
  static const String lastSyncedAt = '${prefix}last_synced_at';
  static const String allPrefsJson = '${prefix}all_prefs_json';
}

/// State for notification preferences (offline-first with backend sync).
class NotificationPreferencesState {
  final bool isLoading;
  final bool isSyncing;
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
    this.isSyncing = false,
    this.errorMessage,
    this.dailyReminderEnabled = true,
    this.dailyReminderTime = const TimeOfDay(hour: 19, minute: 0),
    this.dailyReminderTimezone =
        'Asia/Dhaka', // Default to local, will be updated
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
    bool? isSyncing,
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
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      dailyReminderTimezone:
          dailyReminderTimezone ?? this.dailyReminderTimezone,
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
      budgetWarningThreshold:
          budgetWarningThreshold ?? this.budgetWarningThreshold,
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
          subscriptionExpiryAlertsEnabled ??
          this.subscriptionExpiryAlertsEnabled,
      promotionalNotificationsEnabled:
          promotionalNotificationsEnabled ??
          this.promotionalNotificationsEnabled,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'daily_reminder_enabled': dailyReminderEnabled,
    'daily_reminder_time':
        '${dailyReminderTime.hour.toString().padLeft(2, '0')}:${dailyReminderTime.minute.toString().padLeft(2, '0')}',
    'daily_reminder_timezone': dailyReminderTimezone,
    'budget_alerts_enabled': budgetAlertsEnabled,
    'budget_warning_threshold': budgetWarningThreshold,
    'large_transaction_alerts_enabled': largeTransactionAlertsEnabled,
    'large_transaction_threshold': largeTransactionThreshold,
    'recurring_transaction_reminders_enabled':
        recurringTransactionRemindersEnabled,
    'recurring_reminder_days_before': recurringReminderDaysBefore,
    'subscription_expiry_alerts_enabled': subscriptionExpiryAlertsEnabled,
    'promotional_notifications_enabled': promotionalNotificationsEnabled,
  };
}

/// Notifier for managing notification preferences (offline-first with backend sync).
class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferencesState> {
  final ApiService _apiService;
  final NotificationService _notificationService = NotificationService();
  final Logger _logger = Logger();
  String _deviceTimezone = 'UTC';

  NotificationPreferencesNotifier(this._apiService)
    : super(const NotificationPreferencesState()) {
    _initializeTimezone();
  }

  /// Initialize device timezone
  Future<void> _initializeTimezone() async {
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      _deviceTimezone = tzInfo.identifier;
      _logger.d('Device timezone: $_deviceTimezone');
    } catch (e) {
      _logger.e('Failed to get device timezone: $e');
      _deviceTimezone = 'UTC';
    }
  }

  /// Get device timezone
  String get deviceTimezone => _deviceTimezone;

  /// Load preferences - first from local storage, then sync with backend
  Future<void> loadPreferences() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Ensure timezone is initialized
    await _initializeTimezone();

    // 1. Load from local storage first (instant)
    await _loadFromLocalStorage();

    state = state.copyWith(isLoading: false);

    // 2. Sync with backend in background (if online)
    _syncWithBackendInBackground();
  }

  /// Load preferences from SharedPreferences
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to load from JSON first (complete state)
      final jsonStr = prefs.getString(_PrefsKeys.allPrefsJson);
      if (jsonStr != null) {
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        _applyPreferencesFromJson(data, useDeviceTimezone: true);
        _logger.d('Loaded preferences from local storage');
        return;
      }

      // Fall back to individual keys (legacy or first run)
      final dailyEnabled = prefs.getBool(_PrefsKeys.dailyReminderEnabled);
      if (dailyEnabled != null) {
        final timeStr = prefs.getString(_PrefsKeys.dailyReminderTime);
        TimeOfDay time = const TimeOfDay(hour: 19, minute: 0);
        if (timeStr != null) {
          final parts = timeStr.split(':');
          if (parts.length >= 2) {
            time = TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 19,
              minute: int.tryParse(parts[1]) ?? 0,
            );
          }
        }

        state = state.copyWith(
          dailyReminderEnabled: dailyEnabled,
          dailyReminderTime: time,
          dailyReminderTimezone: _deviceTimezone, // Always use device timezone
          budgetAlertsEnabled:
              prefs.getBool(_PrefsKeys.budgetAlertsEnabled) ?? true,
          budgetWarningThreshold:
              prefs.getDouble(_PrefsKeys.budgetWarningThreshold) ?? 80.0,
          largeTransactionAlertsEnabled:
              prefs.getBool(_PrefsKeys.largeTransactionAlertsEnabled) ?? false,
          largeTransactionThreshold:
              prefs.getDouble(_PrefsKeys.largeTransactionThreshold) ?? 500.0,
          recurringTransactionRemindersEnabled:
              prefs.getBool(_PrefsKeys.recurringRemindersEnabled) ?? false,
          recurringReminderDaysBefore:
              prefs.getInt(_PrefsKeys.recurringReminderDaysBefore) ?? 1,
          subscriptionExpiryAlertsEnabled:
              prefs.getBool(_PrefsKeys.subscriptionExpiryAlertsEnabled) ?? true,
          promotionalNotificationsEnabled:
              prefs.getBool(_PrefsKeys.promotionalNotificationsEnabled) ?? true,
        );
        _logger.d('Loaded preferences from individual keys');
      } else {
        // First run - use defaults with device timezone
        state = state.copyWith(dailyReminderTimezone: _deviceTimezone);
        _logger.d(
          'Using default preferences with device timezone: $_deviceTimezone',
        );
      }

      // Sync local scheduled notification
      await _syncLocalDailyReminder();
    } catch (e) {
      _logger.e('Failed to load from local storage: $e');
    }
  }

  /// Save all preferences to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save as JSON (complete state)
      await prefs.setString(
        _PrefsKeys.allPrefsJson,
        jsonEncode(state.toJson()),
      );

      // Also save individual keys for backward compatibility
      await prefs.setBool(
        _PrefsKeys.dailyReminderEnabled,
        state.dailyReminderEnabled,
      );
      await prefs.setString(
        _PrefsKeys.dailyReminderTime,
        '${state.dailyReminderTime.hour.toString().padLeft(2, '0')}:${state.dailyReminderTime.minute.toString().padLeft(2, '0')}',
      );
      await prefs.setString(
        _PrefsKeys.dailyReminderTimezone,
        state.dailyReminderTimezone,
      );
      await prefs.setBool(
        _PrefsKeys.budgetAlertsEnabled,
        state.budgetAlertsEnabled,
      );
      await prefs.setDouble(
        _PrefsKeys.budgetWarningThreshold,
        state.budgetWarningThreshold,
      );
      await prefs.setBool(
        _PrefsKeys.largeTransactionAlertsEnabled,
        state.largeTransactionAlertsEnabled,
      );
      await prefs.setDouble(
        _PrefsKeys.largeTransactionThreshold,
        state.largeTransactionThreshold,
      );
      await prefs.setBool(
        _PrefsKeys.recurringRemindersEnabled,
        state.recurringTransactionRemindersEnabled,
      );
      await prefs.setInt(
        _PrefsKeys.recurringReminderDaysBefore,
        state.recurringReminderDaysBefore,
      );
      await prefs.setBool(
        _PrefsKeys.subscriptionExpiryAlertsEnabled,
        state.subscriptionExpiryAlertsEnabled,
      );
      await prefs.setBool(
        _PrefsKeys.promotionalNotificationsEnabled,
        state.promotionalNotificationsEnabled,
      );

      _logger.d('Saved preferences to local storage');
    } catch (e) {
      _logger.e('Failed to save to local storage: $e');
    }
  }

  /// Apply preferences from JSON data
  void _applyPreferencesFromJson(
    Map<String, dynamic> data, {
    bool useDeviceTimezone = false,
  }) {
    TimeOfDay reminderTime = const TimeOfDay(hour: 19, minute: 0);
    final timeStr = data['daily_reminder_time'] as String?;
    if (timeStr != null) {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        reminderTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 19,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }

    state = state.copyWith(
      dailyReminderEnabled: data['daily_reminder_enabled'] ?? true,
      dailyReminderTime: reminderTime,
      // Always use device timezone for scheduling, ignore backend timezone
      dailyReminderTimezone: useDeviceTimezone
          ? _deviceTimezone
          : (data['daily_reminder_timezone'] ?? _deviceTimezone),
      budgetAlertsEnabled: data['budget_alerts_enabled'] ?? true,
      budgetWarningThreshold:
          (data['budget_warning_threshold'] as num?)?.toDouble() ?? 80.0,
      largeTransactionAlertsEnabled:
          data['large_transaction_alerts_enabled'] ?? false,
      largeTransactionThreshold:
          (data['large_transaction_threshold'] as num?)?.toDouble() ?? 500.0,
      recurringTransactionRemindersEnabled:
          data['recurring_transaction_reminders_enabled'] ?? false,
      recurringReminderDaysBefore: data['recurring_reminder_days_before'] ?? 1,
      subscriptionExpiryAlertsEnabled:
          data['subscription_expiry_alerts_enabled'] ?? true,
      promotionalNotificationsEnabled:
          data['promotional_notifications_enabled'] ?? true,
    );
  }

  /// Sync with backend in background (fire and forget)
  Future<void> _syncWithBackendInBackground() async {
    state = state.copyWith(isSyncing: true);

    try {
      final response = await _apiService.get('/notifications/preferences');
      final data = response.data as Map<String, dynamic>;

      // Apply backend data but keep device timezone
      _applyPreferencesFromJson(data, useDeviceTimezone: true);

      // Save merged data to local storage
      await _saveToLocalStorage();

      // Sync local scheduled notification
      await _syncLocalDailyReminder();

      _logger.i('Synced preferences with backend');
    } catch (e) {
      _logger.w('Failed to sync with backend (offline?): $e');
      // Don't show error - we have local data
    } finally {
      state = state.copyWith(isSyncing: false);
    }
  }

  /// Sync the local scheduled notification with current state.
  Future<void> _syncLocalDailyReminder() async {
    try {
      // Always use device timezone for scheduling
      await _notificationService.updateDailyReminder(
        enabled: state.dailyReminderEnabled,
        time: state.dailyReminderTime,
        timezone: _deviceTimezone, // Force device timezone
      );
      _logger.i('Local daily reminder synced (timezone: $_deviceTimezone)');
    } catch (e) {
      _logger.e('Failed to sync local daily reminder: $e');
    }
  }

  /// Update a preference locally and sync to backend
  Future<void> _updatePreference(Map<String, dynamic> updates) async {
    // Save to local storage immediately
    await _saveToLocalStorage();

    // Sync to backend in background (don't wait)
    _syncPreferenceToBackend(updates);
  }

  /// Sync preference to backend (fire and forget)
  Future<void> _syncPreferenceToBackend(Map<String, dynamic> updates) async {
    try {
      await _apiService.put('/notifications/preferences', data: updates);
      _logger.i('Preference synced to backend');
    } catch (e) {
      _logger.w('Failed to sync preference to backend: $e');
      // Don't show error - local storage has the data
    }
  }

  /// Toggle daily reminder.
  Future<void> setDailyReminderEnabled(bool enabled) async {
    state = state.copyWith(dailyReminderEnabled: enabled);
    await _updatePreference({'daily_reminder_enabled': enabled});
    await _syncLocalDailyReminder();
  }

  /// Set daily reminder time.
  Future<void> setDailyReminderTime(TimeOfDay time) async {
    state = state.copyWith(dailyReminderTime: time);
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
    await _updatePreference({
      'daily_reminder_time': timeStr,
      'daily_reminder_timezone':
          _deviceTimezone, // Send device timezone to backend
    });
    await _syncLocalDailyReminder();
  }

  /// Set daily reminder timezone (uses device timezone).
  Future<void> setDailyReminderTimezone(String timezone) async {
    // Always use device timezone, ignore the parameter
    state = state.copyWith(dailyReminderTimezone: _deviceTimezone);
    await _updatePreference({'daily_reminder_timezone': _deviceTimezone});
    await _syncLocalDailyReminder();
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
    await _updatePreference({
      'recurring_transaction_reminders_enabled': enabled,
    });
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

  /// Force sync with backend
  Future<void> forceSyncWithBackend() async {
    await _syncWithBackendInBackground();
  }
}

/// Provider for the API service.
final _apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider for notification preferences.
final notificationPreferencesProvider =
    StateNotifierProvider<
      NotificationPreferencesNotifier,
      NotificationPreferencesState
    >((ref) {
      final apiService = ref.watch(_apiServiceProvider);
      return NotificationPreferencesNotifier(apiService);
    });
