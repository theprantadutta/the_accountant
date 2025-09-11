import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/daily_reminder_service.dart';
import 'package:the_accountant/core/providers/notification_provider.dart';

class DailyReminderState {
  final bool isEnabled;
  final TimeOfDay reminderTime;
  final bool isLoading;
  final String? errorMessage;

  DailyReminderState({
    this.isEnabled = false,
    required this.reminderTime,
    this.isLoading = false,
    this.errorMessage,
  });

  DailyReminderState copyWith({
    bool? isEnabled,
    TimeOfDay? reminderTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DailyReminderState(
      isEnabled: isEnabled ?? this.isEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class DailyReminderNotifier extends StateNotifier<DailyReminderState> {
  final DailyReminderService _dailyReminderService;

  DailyReminderNotifier(this._dailyReminderService)
    : super(
        DailyReminderState(
          reminderTime: const TimeOfDay(hour: 19, minute: 0), // Default to 7 PM
        ),
      );

  /// Enable daily reminders
  Future<void> enableReminders() async {
    state = state.copyWith(isLoading: true);

    try {
      await _dailyReminderService.scheduleDailyReminder(
        time: state.reminderTime,
      );
      state = state.copyWith(isEnabled: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Disable daily reminders
  Future<void> disableReminders() async {
    state = state.copyWith(isLoading: true);

    try {
      await _dailyReminderService.cancelDailyReminders();
      state = state.copyWith(isEnabled: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Set reminder time
  Future<void> setReminderTime(TimeOfDay time) async {
    state = state.copyWith(reminderTime: time, isLoading: true);

    try {
      if (state.isEnabled) {
        await _dailyReminderService.scheduleDailyReminder(time: time);
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Show reminder now (for testing)
  Future<void> showReminderNow() async {
    state = state.copyWith(isLoading: true);

    try {
      await _dailyReminderService.checkAndShowReminder();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final dailyReminderServiceProvider = Provider<DailyReminderService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return DailyReminderService(notificationService);
});

final dailyReminderProvider =
    StateNotifierProvider<DailyReminderNotifier, DailyReminderState>((ref) {
      final dailyReminderService = ref.watch(dailyReminderServiceProvider);
      return DailyReminderNotifier(dailyReminderService);
    });
