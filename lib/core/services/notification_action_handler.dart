import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/services/reminder_scheduler_service.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// Top-level background handler for notification action buttons.
/// Runs in a background isolate — must be a top-level or static function.
@pragma('vm:entry-point')
void onBackgroundNotificationAction(NotificationResponse response) async {
  try {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    final data = jsonDecode(payload) as Map<String, dynamic>;
    final transactionId = data['transactionId'] as String?;
    final title = data['title'] as String? ?? '';
    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final type = data['type'] as String? ?? 'upcoming';

    if (transactionId == null) return;

    final actionId = response.actionId;
    if (actionId == null) return;

    switch (actionId) {
      case BackgroundTaskConstants.actionSnooze1Day:
        await _handleSnooze(
          transactionId: transactionId,
          title: title,
          amount: amount,
          type: type,
          snoozeDuration: const Duration(days: 1),
        );

      case BackgroundTaskConstants.actionSnooze1Week:
        await _handleSnooze(
          transactionId: transactionId,
          title: title,
          amount: amount,
          type: type,
          snoozeDuration: const Duration(days: 7),
        );

      case BackgroundTaskConstants.actionSnooze1Month:
        await _handleSnooze(
          transactionId: transactionId,
          title: title,
          amount: amount,
          type: type,
          snoozeDuration: const Duration(days: 30),
        );

      case BackgroundTaskConstants.actionSkip:
        await _handleSkip(transactionId);
    }
  } catch (e) {
    debugPrint('NotificationActionHandler: error processing action: $e');
  }
}

/// Reschedule the reminder with a snoozed due date.
Future<void> _handleSnooze({
  required String transactionId,
  required String title,
  required double amount,
  required String type,
  required Duration snoozeDuration,
}) async {
  final newDueDate = DateTime.now().add(snoozeDuration);
  await ReminderSchedulerService().scheduleReminder(
    transactionId: transactionId,
    title: title,
    amount: amount,
    type: type,
    dueDate: newDueDate,
  );
}

/// Mark the transaction as skipped and cancel its reminder.
Future<void> _handleSkip(String transactionId) async {
  // Same per-account store the app is using — see BackgroundTaskService.
  final prefs = await SharedPreferences.getInstance();
  final db = constructDbForFile(LocalStoreManager(prefs).activeStoreFile);
  try {
    await db.customStatement(
      'UPDATE transactions SET skip_paid = 1, updated_at = ? WHERE id = ?',
      [DateTime.now().toIso8601String(), transactionId],
    );
    await ReminderSchedulerService().cancelReminder(transactionId);
  } finally {
    await db.close();
  }
}
