import 'package:the_accountant/l10n/app_l10n.dart';

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
  static String get recurringChannelName => appL10n.notifChannelRecurring;
  static String get recurringChannelDesc => appL10n.notifChannelRecurringDesc;

  static const String upcomingChannelId = 'upcoming_reminder_channel';
  static String get upcomingChannelName => appL10n.notifChannelUpcoming;
  static String get upcomingChannelDesc => appL10n.notifChannelUpcomingDesc;

  static const String loanChannelId = 'loan_reminder_channel';
  static String get loanChannelName => appL10n.notifChannelLoan;
  static String get loanChannelDesc => appL10n.notifChannelLoanDesc;

  static const String dueDateChannelId = 'due_date_reminder_channel';
  static String get dueDateChannelName => appL10n.notifChannelDueDate;
  static String get dueDateChannelDesc => appL10n.notifChannelDueDateDesc;

  /// The same channel the server's card reminders used, so the user's choice
  /// of sound and importance for it carries over.
  static const String billsChannelId = 'bills';
  static String get billsChannelName => appL10n.cardBillsTitle;
  static String get billsChannelDesc => appL10n.notifChannelBillsDesc;

  // === Notification ID Ranges ===
  // Existing: budget=2000, daily=1001, subscription=5000, test=9999
  static const int recurringNotificationIdBase = 3000;
  static const int upcomingNotificationIdBase = 4000;
  static const int loanNotificationIdBase = 6000;
  static const int dueDateNotificationIdBase = 7000;
  static const int billsNotificationIdBase = 8000;

  // === SharedPreferences Keys ===
  static const String keyReminderOffset = 'background_reminder_offset_minutes';
  static const String keyLastPeriodicRun = 'background_last_periodic_run';

  /// Set by the WorkManager isolate when background processing created local
  /// rows (generated recurrence occurrences) that still need uploading.
  ///
  /// The isolate cannot reliably sync itself — it has no premium state and, on
  /// iOS, no guaranteed network window — so it leaves this flag and the
  /// foreground app drains it at the next opportunity.
  static const String keyPendingBackgroundSync = 'background_pending_sync';
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
        return appL10n.notifOffset1Hour;
      case offset1Day:
        return appL10n.notifOffset1Day;
      case offset3Days:
        return appL10n.notifOffset3Days;
      case offset1Week:
        return appL10n.notifOffset1Week;
      default:
        return appL10n.notifOffsetMinutes(minutes);
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
  static const String inputType =
      'type'; // 'upcoming', 'credit', 'debt', 'subscription', 'repetitive'
  static const String inputDueDate = 'dueDate';
}
