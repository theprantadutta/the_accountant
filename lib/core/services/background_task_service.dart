import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/services/background_notification_helper.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/core/services/notified_once.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/features/notifications/services/local_notification_log.dart';
import 'package:the_accountant/core/services/notification_service.dart'
    show NotificationChannels;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/backup/services/drive_backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';
import 'package:the_accountant/features/backup/services/google_drive_authorization.dart';
import 'package:the_accountant/features/forecast/services/shortfall_alerts.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart'
    show NotificationType;
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';
import 'package:the_accountant/features/zakat/services/zakat_reminder.dart';

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
      final awaitingBefore =
          (await db.getPaymentsAwaitingConfirmation()).length;
      final processedCount = await recurringService
          .processRecurringTransactions();

      // EMI installments, DPS deposits, profits and maturities due by now,
      // so a plan keeps step on a day the app is not opened.
      final planEvents = await PlanService(db).collectDue();
      if (planEvents > 0) {
        // Bookkeeping the app did by itself: noted in the inbox, not pinged.
        // A notification for every entry it wrote was noise.
        await LocalNotificationLog.record(
          type: NotificationType.custom,
          title: 'EMI and savings updated',
          body: planEvents == 1
              ? '1 plan entry recorded on its day.'
              : '$planEvents plan entries recorded on their day.',
        );
      }
      // With everything due now recorded, look a week ahead for a day the
      // scheduled payments would take spendable money below zero.
      try {
        await ShortfallAlerts.check(
          db: db,
          prefs: prefs,
          show: ({required id, required title, required body}) =>
              notifier.showNotification(
                id: id,
                title: title,
                body: body,
                channelId: NotificationChannels.general.id,
                channelName: NotificationChannels.general.name,
                channelDesc: NotificationChannels.general.description ?? '',
                data: const {'action': 'open_forecast'},
                type: NotificationType.custom,
              ),
        );
      } catch (e) {
        debugPrint('BackgroundTaskService: shortfall check failed: $e');
      }

      // The zakat date, a few days ahead and on the day. Shown once each,
      // whether this check or the app being opened gets there first.
      final zakat = await ZakatReminders.take(prefs: prefs);
      if (zakat != null) {
        await notifier.showNotification(
          id: ZakatReminders.notificationId,
          title: zakat.title,
          body: zakat.body,
          channelId: NotificationChannels.general.id,
          channelName: NotificationChannels.general.name,
          channelDesc: NotificationChannels.general.description ?? '',
          data: ZakatReminder.payload,
          type: NotificationType.custom,
        );
      }
      final awaiting = await db.getPaymentsAwaitingConfirmation();
      // A schedule that asks first writes its payment as pending. That is a
      // question for the user, not a report, so it is told apart from the
      // payments recorded by themselves.
      final newlyAwaiting = awaiting.length - awaitingBefore;
      final recorded = processedCount - newlyAwaiting;

      if (recorded > 0) {
        // Like the plan entries above: in the inbox, without a ping.
        await LocalNotificationLog.record(
          type: NotificationType.custom,
          title: 'Recurring transactions recorded',
          body: recorded == 1
              ? '1 recurring transaction recorded.'
              : '$recorded recurring transactions recorded.',
        );
      }

      if (newlyAwaiting > 0) {
        final names = awaiting
            .map((t) => t.title)
            .where((title) => title.isNotEmpty)
            .take(3)
            .join(', ');
        await notifier.showNotification(
          id: BackgroundTaskConstants.recurringNotificationIdBase + 1,
          title:
              '${awaiting.length} payment${awaiting.length == 1 ? '' : 's'} to confirm',
          body: names.isEmpty
              ? 'Confirm what was charged, or skip it, in Upcoming.'
              : '$names — confirm what was charged, or skip it, in Upcoming.',
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

      // Amounts in the account's own currency and number style, and dates in
      // the user's format, like everywhere else in the app.
      final settings = await db.getSettings();
      final currencyOf = {
        for (final w in await db.getAllWallets()) w.id: w.currency,
      };
      String money(int cents, String walletId) => cents.formatCurrency(
        currencyOf[walletId] ?? settings?.currency ?? 'USD',
        numberFormat: settings?.numberFormat ?? 'comma_dot',
      );
      String date(DateTime d) =>
          AppDateFormatter.formatDate(d, settings?.dateFormat ?? 'd MMM yyyy');

      // Each reminder below is posted once: this runs every hour, and with no
      // memory of what it had said, something due tomorrow was announced
      // about twenty times and an overdue loan every hour.

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
        final due = _dueKey(t.id, t.originalDueDate ?? t.date);
        if (!await NotifiedOnce.claim(due, prefs: prefs)) continue;
        final title = t.title.isNotEmpty ? t.title : 'Upcoming Transaction';
        await notifier.showNotificationWithActions(
          id:
              BackgroundTaskConstants.upcomingNotificationIdBase +
              (t.id.hashCode % 500),
          title: 'Upcoming: $title',
          body:
              '${t.isIncome ? "Income" : "Expense"} of '
              '${money(t.amount, t.walletId)} is due soon.',
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
        // Still owed is worth repeating, but once a day, not every hour.
        if (!await NotifiedOnce.claim(
          'overdue:${t.id}',
          every: const Duration(days: 1),
          prefs: prefs,
        )) {
          continue;
        }
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
              '${money(TransactionPolicy.outstandingAmount(t), t.walletId)} '
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
        if (!await NotifiedOnce.claim(
          'recurring:${config.id}:${NotifiedOnce.day(config.nextOccurrence)}',
          prefs: prefs,
        )) {
          continue;
        }
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
              '${money(baseTx.amount, baseTx.walletId)} due on '
              '${date(config.nextOccurrence)}.',
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

      // The hourly check reminds about the same item; whichever gets there
      // first says it.
      if (!await NotifiedOnce.claim(_dueKey(transactionId, dueDate))) {
        return true;
      }
      final settings = await db.getSettings();
      final wallet = (await db.getAllWallets())
          .where((w) => w.id == tx.walletId)
          .firstOrNull;
      final shown = tx.amount.formatCurrency(
        wallet?.currency ?? settings?.currency ?? 'USD',
        numberFormat: settings?.numberFormat ?? 'comma_dot',
      );

      await notifier.showNotificationWithActions(
        id:
            BackgroundTaskConstants.dueDateNotificationIdBase +
            (transactionId.hashCode % 500),
        title: notifTitle,
        body: '$shown is due soon. Tap to review.',
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

    // A stored balance is a cache over the account's transactions, and a wrong
    // one is the single number in this app nobody thinks to double-check. It is
    // corrected here rather than merely reported: leaving someone looking at a
    // figure known to be wrong, on the grounds that it was logged, helps nobody.
    try {
      final balances = WalletBalanceService(db);
      final drift = await balances.findBalanceDrift();
      if (drift.isNotEmpty) {
        debugPrint(
          'BackgroundTaskService: ${drift.length} account balance(s) had '
          'drifted from their transactions and were recalculated: $drift',
        );
        await balances.recalculateAllWalletBalancesLocal();
      }
    } catch (e) {
      debugPrint('BackgroundTaskService: balance check failed: $e');
    }

    // Recently Deleted keeps a row for thirty days. Nothing was removing them
    // once that passed, now that an accepted delete no longer takes the local
    // tombstone with it.
    try {
      final purged = await db.purgeExpiredTombstones();
      if (purged > 0) {
        debugPrint(
          'BackgroundTaskService: removed $purged tombstone(s) past the '
          'thirty-day window',
        );
      }
    } catch (e) {
      debugPrint('BackgroundTaskService: tombstone sweep failed: $e');
    }

    // A backup the user asked to happen every week only happens if something
    // asks. This never prompts — a lapsed Drive permission records why it
    // skipped and waits to be pressed by hand — so it is safe to run on the way
    // in, before anything is on screen.
    try {
      final drive = DriveBackupService(
        database: db,
        client: DriveBackupClient(
          authorization: const GoogleDriveAuthorization(),
        ),
      );
      if (await drive.runAutomaticIfDue(describeDevice: _deviceLabel)) {
        debugPrint('BackgroundTaskService: scheduled Drive backup uploaded');
      }
    } catch (e) {
      debugPrint('BackgroundTaskService: scheduled backup failed: $e');
    }
  }

  /// How a backup names the machine it came from. Best effort — a device that
  /// will not identify itself is worth a backup with a blank label far more
  /// than it is worth a skipped one.
  static Future<String> _deviceLabel() async {
    try {
      final info = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await info.androidInfo;
        return '${android.manufacturer} ${android.model}'.trim();
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return (await info.iosInfo).name;
      }
      if (defaultTargetPlatform == TargetPlatform.windows) {
        return (await info.windowsInfo).computerName;
      }
    } catch (_) {
      // Not worth failing a backup over.
    }
    return '';
  }

  /// One reminder per item and due date, shared by the hourly check and the
  /// one-off reminder job.
  static String _dueKey(String transactionId, DateTime dueDate) =>
      'due:$transactionId:${NotifiedOnce.day(dueDate)}';
}
