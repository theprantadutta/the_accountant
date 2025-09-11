import 'package:flutter/material.dart';
import 'package:the_accountant/core/services/notification_service.dart';

class DailyReminderService {
  final NotificationService _notificationService;

  DailyReminderService(this._notificationService);

  /// Schedule a daily reminder at a specific time
  Future<void> scheduleDailyReminder({TimeOfDay? time}) async {
    try {
      // For now, we'll just show a notification immediately
      // In a real implementation, you would use a package like flutter_local_notifications
      // to schedule recurring notifications
      await _notificationService.showDailyReminderNotification();
    } catch (e) {
      // Handle error
      debugPrint('Failed to schedule daily reminder: $e');
    }
  }

  /// Cancel all daily reminders
  Future<void> cancelDailyReminders() async {
    try {
      await _notificationService.cancelAllNotifications();
    } catch (e) {
      // Handle error
      debugPrint('Failed to cancel daily reminders: $e');
    }
  }

  /// Check if it's time to show a daily reminder
  Future<void> checkAndShowReminder() async {
    try {
      // Get current time
      final now = DateTime.now();

      // For demo purposes, show reminder if it's between 6 PM and 10 PM
      if (now.hour >= 18 && now.hour <= 22) {
        await _notificationService.showDailyReminderNotification();
      }
    } catch (e) {
      // Handle error
      debugPrint('Failed to check and show reminder: $e');
    }
  }
}
