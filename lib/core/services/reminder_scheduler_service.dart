import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'package:the_accountant/core/constants/background_task_constants.dart';

/// Service to schedule and cancel one-off WorkManager tasks
/// for specific transaction due-date reminders.
class ReminderSchedulerService {
  /// Schedule a one-off reminder for a transaction.
  ///
  /// [type] should be one of: 'upcoming', 'credit', 'debt', 'subscription'.
  /// The reminder fires at `dueDate - offsetMinutes` from now.
  Future<void> scheduleReminder({
    required String transactionId,
    required String title,
    required double amount,
    required String type,
    required DateTime dueDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final offsetMinutes =
        prefs.getInt(BackgroundTaskConstants.keyReminderOffset) ??
            BackgroundTaskConstants.defaultOffset;

    final reminderTime =
        dueDate.subtract(Duration(minutes: offsetMinutes));
    final now = DateTime.now();

    Duration initialDelay;
    if (reminderTime.isAfter(now)) {
      initialDelay = reminderTime.difference(now);
    } else if (dueDate.isAfter(now)) {
      // Reminder time already passed but due date hasn't — fire in 1 minute
      initialDelay = const Duration(minutes: 1);
    } else {
      // Due date already passed — don't schedule
      return;
    }

    final uniqueName = _uniqueName(transactionId);

    await Workmanager().registerOneOffTask(
      uniqueName,
      BackgroundTaskConstants.dueDateReminderTaskName,
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.notRequired),
      inputData: {
        BackgroundTaskConstants.inputTransactionId: transactionId,
        BackgroundTaskConstants.inputTitle: title,
        BackgroundTaskConstants.inputAmount: amount,
        BackgroundTaskConstants.inputType: type,
        BackgroundTaskConstants.inputDueDate: dueDate.toIso8601String(),
      },
    );
  }

  /// Cancel a previously scheduled reminder for a transaction.
  Future<void> cancelReminder(String transactionId) async {
    await Workmanager().cancelByUniqueName(_uniqueName(transactionId));
  }

  String _uniqueName(String transactionId) =>
      'due_reminder_$transactionId';
}
