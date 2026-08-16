import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/services/background_notification_helper.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

/// Core background processing service.
/// All methods are static and self-contained — they construct their own
/// database, notification helper, and SharedPreferences instances since
/// WorkManager callbacks run in an isolated Dart isolate.
class BackgroundTaskService {
  /// Open the SAME per-account database the foreground app is using.
  ///
  /// WorkManager callbacks run in their own isolate with no Riverpod state, so
  /// the active store file is read back from SharedPreferences. Using the
  /// default file here would make background processing write recurrence
  /// instances and reminders into the wrong account's database.
  static Future<AppDatabase> _openActiveStore() async {
    final prefs = await SharedPreferences.getInstance();
    return constructDbForFile(LocalStoreManager(prefs).activeStoreFile);
  }

  BackgroundTaskService._();

  /// Called from WorkManager periodic task and iOS background task.
  /// Processes recurring transactions and sends reminder notifications.
  static Future<bool> executePeriodicProcessing() async {
    AppDatabase? db;
    try {
      // 1. Init timezone
      tz.initializeTimeZones();
      try {
        final tzInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }

      // 2. Construct DB
      db = await _openActiveStore();

      // 3. Init notifications
      final notifier = BackgroundNotificationHelper();
      await notifier.initialize();

      // 4. Read preferences
      final prefs = await SharedPreferences.getInstance();
      final remindersEnabled =
          prefs.getBool(BackgroundTaskConstants.keyRecurringRemindersEnabled) ??
          false;
      final offsetMinutes =
          prefs.getInt(BackgroundTaskConstants.keyReminderOffset) ??
          BackgroundTaskConstants.defaultOffset;

      // 5. Process recurring transactions
      final recurringService = RecurringService(database: db);
      final processedCount = await recurringService
          .processRecurringTransactions();

      if (processedCount > 0) {
        await notifier.showNotification(
          id: BackgroundTaskConstants.recurringNotificationIdBase,
          title: 'Recurring Transactions Processed',
          body:
              '$processedCount recurring transaction${processedCount == 1 ? '' : 's'} created.',
          channelId: BackgroundTaskConstants.recurringChannelId,
          channelName: BackgroundTaskConstants.recurringChannelName,
          channelDesc: BackgroundTaskConstants.recurringChannelDesc,
        );
      }

      if (!remindersEnabled) {
        // Save last-run timestamp and exit early
        await prefs.setString(
          BackgroundTaskConstants.keyLastPeriodicRun,
          DateTime.now().toIso8601String(),
        );
        return true;
      }

      // 6. Check upcoming transactions due within offset window
      final now = DateTime.now();
      final windowEnd = now.add(Duration(minutes: offsetMinutes));
      final upcoming = await db.getUpcomingTransactions();
      final dueUpcoming = upcoming
          .where((t) => t.date.isBefore(windowEnd))
          .take(5)
          .toList();

      for (var i = 0; i < dueUpcoming.length; i++) {
        final t = dueUpcoming[i];
        final title = t.title.isNotEmpty ? t.title : 'Upcoming Transaction';
        await notifier.showNotificationWithActions(
          id:
              BackgroundTaskConstants.upcomingNotificationIdBase +
              (t.id.hashCode % 500),
          title: 'Upcoming: $title',
          body:
              '${t.isIncome ? "Income" : "Expense"} of ${(t.amount / 100).toStringAsFixed(2)} is due soon.',
          channelId: BackgroundTaskConstants.upcomingChannelId,
          channelName: BackgroundTaskConstants.upcomingChannelName,
          channelDesc: BackgroundTaskConstants.upcomingChannelDesc,
          transactionId: t.id,
          transactionTitle: t.title,
          amount: t.amount / 100.0,
          type: 'upcoming',
          dueDate: t.originalDueDate ?? t.date,
        );
      }

      // 7. Check overdue credit/debt
      final credits = await db.getCreditTransactions();
      final debts = await db.getDebtTransactions();
      // Overdue means "still owed and past due". Gating on `isPaid` suppressed
      // every reminder, because a loan is isPaid=true from the moment its cash
      // moved; settlement is tracked by paidAmount.
      final overdueLoans = [
        ...credits,
        ...debts,
      ].where((t) => TransactionPolicy.isOverdue(t, now: now)).take(3).toList();

      for (final t in overdueLoans) {
        final isCredit = t.specialType == TransactionSpecialType.credit;
        final loanType = isCredit ? 'credit' : 'debt';
        final title = t.title.isNotEmpty
            ? t.title
            : (isCredit ? 'Credit' : 'Debt');
        await notifier.showNotificationWithActions(
          id:
              BackgroundTaskConstants.loanNotificationIdBase +
              (t.id.hashCode % 500),
          title: 'Overdue ${isCredit ? "Credit" : "Debt"}: $title',
          body:
              '${(TransactionPolicy.outstandingAmount(t) / 100).toStringAsFixed(2)} '
              'is still outstanding. Tap to review.',
          channelId: BackgroundTaskConstants.loanChannelId,
          channelName: BackgroundTaskConstants.loanChannelName,
          channelDesc: BackgroundTaskConstants.loanChannelDesc,
          transactionId: t.id,
          transactionTitle: t.title,
          amount: t.amount / 100.0,
          type: loanType,
          dueDate: t.originalDueDate ?? t.date,
        );
      }

      // 8. Check active recurring configs with nextOccurrence within window
      final activeConfigs = await db.getActiveRecurringConfigs();
      final dueConfigs = activeConfigs
          .where(
            (c) =>
                c.nextOccurrence.isAfter(now) &&
                c.nextOccurrence.isBefore(windowEnd),
          )
          .take(5)
          .toList();

      for (final config in dueConfigs) {
        final baseTx = await db.findTransactionById(config.baseTransactionId);
        if (baseTx == null) continue;
        final title = baseTx.title.isNotEmpty
            ? baseTx.title
            : 'Recurring Transaction';
        await notifier.showNotification(
          id:
              BackgroundTaskConstants.recurringNotificationIdBase +
              100 +
              (config.id.hashCode % 400),
          title: 'Upcoming Recurring: $title',
          body:
              // Amounts are stored in integer minor units. Formatting the raw
              // value showed 12345 cents as "12345.00" instead of "123.45".
              '${(baseTx.amount / 100).toStringAsFixed(2)} due on '
              '${_formatDate(config.nextOccurrence)}.',
          channelId: BackgroundTaskConstants.recurringChannelId,
          channelName: BackgroundTaskConstants.recurringChannelName,
          channelDesc: BackgroundTaskConstants.recurringChannelDesc,
        );
      }

      // 9. Flag that background work produced local changes needing upload.
      //
      // A WorkManager isolate has no Riverpod container, no premium state, and
      // on iOS no dependable network window, so it deliberately does NOT try to
      // sync itself — a half-authenticated push from a background isolate is
      // worse than a slightly delayed one. Instead it records that there is
      // something to send; the foreground app drains it on the next resume,
      // connectivity-restored, or periodic trigger. See IMPLEMENTATION_NOTES.md
      // for the platform limitations behind this choice.
      if (processedCount > 0) {
        await prefs.setBool(
          BackgroundTaskConstants.keyPendingBackgroundSync,
          true,
        );
      }

      // 10. Save last-run timestamp
      await prefs.setString(
        BackgroundTaskConstants.keyLastPeriodicRun,
        DateTime.now().toIso8601String(),
      );

      return true;
    } catch (e) {
      debugPrint('BackgroundTaskService: periodic processing failed: $e');
      return false;
    } finally {
      // 10. Close DB
      await db?.close();
    }
  }

  /// Called from WorkManager one-off task for a specific transaction reminder.
  static Future<bool> executeDueDateReminder(
    Map<String, dynamic>? inputData,
  ) async {
    if (inputData == null) return true;

    AppDatabase? db;
    try {
      final transactionId =
          inputData[BackgroundTaskConstants.inputTransactionId] as String?;
      final title =
          inputData[BackgroundTaskConstants.inputTitle] as String? ?? '';
      final amount =
          (inputData[BackgroundTaskConstants.inputAmount] as num?)
              ?.toDouble() ??
          0.0;
      final type =
          inputData[BackgroundTaskConstants.inputType] as String? ?? 'upcoming';

      if (transactionId == null) return true;

      // Construct DB and verify transaction still exists
      db = await _openActiveStore();
      final tx = await db.findTransactionById(transactionId);
      if (tx == null || tx.skipPaid) {
        return true; // Deleted or skipped — nothing to do
      }
      // Credit/debt reminders stop when the loan is SETTLED (repaid in full),
      // which is a paidAmount question — not when `isPaid` flips, since that is
      // true from the moment the principal moved. Upcoming items still use
      // isPaid, which for them genuinely means "already happened".
      if (TransactionPolicy.isCreditOrDebt(tx)) {
        if (TransactionPolicy.isSettled(tx)) return true;
      } else {
        final isRecurringType =
            tx.specialType == TransactionSpecialType.repetitive ||
            tx.specialType == TransactionSpecialType.subscription;
        if (!isRecurringType && tx.isPaid) {
          return true; // Already paid — nothing to do
        }
      }

      // Init notifications
      final notifier = BackgroundNotificationHelper();
      await notifier.initialize();

      // Determine channel based on type
      String channelId;
      String channelName;
      String channelDesc;
      String notifTitle;

      switch (type) {
        case 'credit':
          channelId = BackgroundTaskConstants.loanChannelId;
          channelName = BackgroundTaskConstants.loanChannelName;
          channelDesc = BackgroundTaskConstants.loanChannelDesc;
          notifTitle = 'Credit Due: ${title.isNotEmpty ? title : "Credit"}';
        case 'debt':
          channelId = BackgroundTaskConstants.loanChannelId;
          channelName = BackgroundTaskConstants.loanChannelName;
          channelDesc = BackgroundTaskConstants.loanChannelDesc;
          notifTitle = 'Debt Due: ${title.isNotEmpty ? title : "Debt"}';
        case 'subscription':
          channelId = BackgroundTaskConstants.recurringChannelId;
          channelName = BackgroundTaskConstants.recurringChannelName;
          channelDesc = BackgroundTaskConstants.recurringChannelDesc;
          notifTitle =
              'Subscription Due: ${title.isNotEmpty ? title : "Subscription"}';
        case 'repetitive':
          channelId = BackgroundTaskConstants.upcomingChannelId;
          channelName = BackgroundTaskConstants.upcomingChannelName;
          channelDesc = BackgroundTaskConstants.upcomingChannelDesc;
          notifTitle =
              'Bill Due: ${title.isNotEmpty ? title : "Repetitive Bill"}';
        default: // 'upcoming'
          channelId = BackgroundTaskConstants.upcomingChannelId;
          channelName = BackgroundTaskConstants.upcomingChannelName;
          channelDesc = BackgroundTaskConstants.upcomingChannelDesc;
          notifTitle = 'Due Soon: ${title.isNotEmpty ? title : "Transaction"}';
      }

      final dueDateStr =
          inputData[BackgroundTaskConstants.inputDueDate] as String?;
      final dueDate = dueDateStr != null
          ? DateTime.tryParse(dueDateStr) ?? DateTime.now()
          : DateTime.now();

      await notifier.showNotificationWithActions(
        id:
            BackgroundTaskConstants.dueDateNotificationIdBase +
            (transactionId.hashCode % 500),
        title: notifTitle,
        body: '${amount.toStringAsFixed(2)} is due soon. Tap to review.',
        channelId: channelId,
        channelName: channelName,
        channelDesc: channelDesc,
        transactionId: transactionId,
        transactionTitle: title,
        amount: amount,
        type: type,
        dueDate: dueDate,
      );

      return true;
    } catch (e) {
      debugPrint('BackgroundTaskService: due date reminder failed: $e');
      return false;
    } finally {
      await db?.close();
    }
  }

  /// Called from main() with the existing DB instance to catch up on
  /// any recurring transactions that were missed while the app was closed.
  static Future<void> runStartupProcessing(AppDatabase db) async {
    try {
      final recurringService = RecurringService(database: db);
      final count = await recurringService.processRecurringTransactions();
      if (count > 0) {
        debugPrint(
          'BackgroundTaskService: startup catch-up processed $count recurring transactions',
        );
      }
    } catch (e) {
      debugPrint('BackgroundTaskService: startup processing failed: $e');
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
