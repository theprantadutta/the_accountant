/// Constants for background task processing via WorkManager.
class BackgroundTaskConstants {
  BackgroundTaskConstants._();

  // === Task Names ===
  static const String periodicTaskName = 'periodic_background_processing';
  static const String periodicTaskUniqueName =
      'com.pranta.the_accountant.periodic_processing';
  static const String dueDateReminderTaskName = 'due_date_reminder';

  // === Notification Channel IDs ===
  static const String recurringChannelId = 'recurring_processing_channel';
  static const String recurringChannelName = 'Recurring Transactions';
  static const String recurringChannelDesc =
      'Notifications for auto-created recurring transactions';

  static const String upcomingChannelId = 'upcoming_reminder_channel';
  static const String upcomingChannelName = 'Upcoming Reminders';
  static const String upcomingChannelDesc =
      'Reminders for upcoming transactions';

  static const String loanChannelId = 'loan_reminder_channel';
  static const String loanChannelName = 'Loan Reminders';
  static const String loanChannelDesc =
      'Reminders for overdue credits and debts';

  static const String dueDateChannelId = 'due_date_reminder_channel';
  static const String dueDateChannelName = 'Due Date Reminders';
  static const String dueDateChannelDesc =
      'One-off reminders for specific transaction due dates';

  // === Notification ID Ranges ===
  // Existing: budget=2000, daily=1001, subscription=5000, test=9999
  static const int recurringNotificationIdBase = 3000;
  static const int upcomingNotificationIdBase = 4000;
  static const int loanNotificationIdBase = 6000;
  static const int dueDateNotificationIdBase = 7000;

  // === SharedPreferences Keys ===
  static const String keyReminderOffset =
      'background_reminder_offset_minutes';
  static const String keyLastPeriodicRun =
      'background_last_periodic_run';
  static const String keyRecurringRemindersEnabled =
      'notification_prefs_recurring_reminders_enabled';

  // === Reminder Offset Options (in minutes) ===
  static const int offset1Hour = 60;
  static const int offset1Day = 1440;
  static const int offset3Days = 4320;
  static const int offset1Week = 10080;
  static const int defaultOffset = offset1Day;

  static const List<int> offsetOptions = [
    offset1Hour,
    offset1Day,
    offset3Days,
    offset1Week,
  ];

  /// Human-readable label for an offset in minutes.
  static String offsetLabel(int minutes) {
    switch (minutes) {
      case offset1Hour:
        return '1 hour before';
      case offset1Day:
        return '1 day before';
      case offset3Days:
        return '3 days before';
      case offset1Week:
        return '1 week before';
      default:
        return '$minutes minutes before';
    }
  }

  // === Notification Action IDs ===
  static const String actionSnooze1Day = 'snooze_1_day';
  static const String actionSnooze1Week = 'snooze_1_week';
  static const String actionSnooze1Month = 'snooze_1_month';
  static const String actionSkip = 'skip_occurrence';

  // === InputData Keys for One-Off Reminders ===
  static const String inputTransactionId = 'transactionId';
  static const String inputTitle = 'title';
  static const String inputAmount = 'amount';
  static const String inputType = 'type'; // 'upcoming', 'credit', 'debt', 'subscription', 'repetitive'
  static const String inputDueDate = 'dueDate';
}
