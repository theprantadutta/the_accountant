import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for scheduling daily expense reminder notifications locally.
/// Uses flutter_local_notifications with zonedSchedule for precise timing.
class DailyReminderScheduler {
  static final DailyReminderScheduler _instance =
      DailyReminderScheduler._internal();
  factory DailyReminderScheduler() => _instance;
  DailyReminderScheduler._internal();

  static const int _dailyReminderId = 1001;
  static const String _channelId = 'daily_reminder_channel';
  static const String _channelName = 'Daily Reminders';
  static const String _channelDescription =
      'Daily expense reminder notifications';

  // Local storage keys
  static const String _keyEnabled = 'daily_reminder_enabled';
  static const String _keyTime = 'daily_reminder_time';
  static const String _keyTimezone = 'daily_reminder_timezone';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Explicitly request exact-alarm permission on Android 12+ (this opens the
  /// system settings screen). Only call from a deliberate, user-initiated flow
  /// after priming — never during a background sync. Returns true if granted.
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Check if exact alarms are permitted
      final canSchedule =
          await androidPlugin.canScheduleExactNotifications() ?? false;
      if (!canSchedule) {
        debugPrint('DailyReminderScheduler: Requesting exact alarm permission');
        // Request permission - this opens system settings on Android 12+
        final granted =
            await androidPlugin.requestExactAlarmsPermission() ?? false;
        debugPrint(
          'DailyReminderScheduler: Exact alarm permission granted: $granted',
        );
        return granted;
      }
      return true;
    }
    return true;
  }

  /// Explicitly request notification permission (Android 13+ POST_NOTIFICATIONS
  /// and iOS). Call from a user-initiated flow after priming. Returns true if
  /// granted (or not required on this OS version).
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final android = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? true;
    } else if (Platform.isIOS) {
      final ios = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
    }
    return true;
  }

  /// Initialize the scheduler and timezone database
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone database
    tz.initializeTimeZones();

    // Get device timezone and set as local
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      debugPrint(
        'DailyReminderScheduler: Device timezone: ${timezoneInfo.identifier}',
      );
    } catch (e) {
      debugPrint('DailyReminderScheduler: Failed to get device timezone: $e');
      // Fallback to UTC if device timezone can't be determined
      tz.setLocalLocation(tz.UTC);
    }

    _isInitialized = true;
    debugPrint('DailyReminderScheduler: Initialized');

    // Restore scheduled reminder from local storage
    await _restoreScheduledReminder();
  }

  /// Restore previously scheduled reminder on app start
  Future<void> _restoreScheduledReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_keyEnabled) ?? false;

    if (enabled) {
      final timeStr = prefs.getString(_keyTime);
      final timezone = prefs.getString(_keyTimezone) ?? 'UTC';

      if (timeStr != null) {
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final time = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
          await scheduleDailyReminder(time: time, timezone: timezone);
          debugPrint(
            'DailyReminderScheduler: Restored reminder at $timeStr ($timezone)',
          );
        }
      }
    }
  }

  /// Schedule a daily reminder at the specified time
  Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    required String timezone,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Only schedule when exact-alarm permission is already granted. Requesting
    // it is a deliberate, user-initiated action (requestExactAlarmPermission),
    // so a background sync / screen open never pops the system settings.
    final canSchedule = await hasExactAlarmPermission();
    if (!canSchedule) {
      debugPrint(
        'DailyReminderScheduler: exact alarm permission missing — skipping schedule',
      );
      return;
    }

    // Cancel any existing reminder first
    await cancelDailyReminder();

    // Get the timezone location
    tz.Location location;
    try {
      location = tz.getLocation(timezone);
    } catch (e) {
      debugPrint(
        'DailyReminderScheduler: Invalid timezone $timezone, using device local',
      );
      location = tz.local;
    }

    // Calculate the next scheduled time
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Notification details - fullScreenIntent ensures heads-up display even in foreground
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      enableLights: true,
      enableVibration: true,
      fullScreenIntent:
          true, // Shows as heads-up even when app is in foreground
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Payload for handling notification tap
    final payload = jsonEncode({
      'action': 'open_add_transaction',
      'notificationType': 'DailyReminder',
    });

    // Schedule the notification with daily recurrence
    try {
      await _notificationsPlugin.zonedSchedule(
        id: _dailyReminderId,
        title: 'Daily Expense Reminder',
        body:
            "Don't forget to log your expenses today! Keep track of your spending.",
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Daily at same time
        payload: payload,
      );
    } catch (e) {
      debugPrint('DailyReminderScheduler: Failed to schedule notification: $e');
      rethrow;
    }

    // Verify the notification was scheduled
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    final isScheduled = pending.any((n) => n.id == _dailyReminderId);
    debugPrint(
      'DailyReminderScheduler: Notification scheduled successfully: $isScheduled',
    );

    if (!isScheduled) {
      debugPrint(
        'DailyReminderScheduler: WARNING - Notification not found in pending list!',
      );
    }

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, true);
    await prefs.setString(
      _keyTime,
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
    );
    await prefs.setString(_keyTimezone, timezone);

    debugPrint(
      'DailyReminderScheduler: Scheduled daily reminder at ${time.hour}:${time.minute} ($timezone)',
    );
    debugPrint('DailyReminderScheduler: Next notification: $scheduledDate');
  }

  /// Cancel the daily reminder
  Future<void> cancelDailyReminder() async {
    await _notificationsPlugin.cancel(id: _dailyReminderId);

    // Update local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, false);

    debugPrint('DailyReminderScheduler: Cancelled daily reminder');
  }

  /// Check if a daily reminder is currently scheduled
  Future<bool> isReminderScheduled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnabled) ?? false;
  }

  /// Get the currently scheduled reminder time
  Future<TimeOfDay?> getScheduledTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(_keyTime);

    if (timeStr != null) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
    return null;
  }

  /// Get the currently scheduled timezone
  Future<String> getScheduledTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTimezone) ?? 'UTC';
  }

  /// Update reminder settings (convenience method)
  Future<void> updateReminder({
    required bool enabled,
    required TimeOfDay time,
    required String timezone,
  }) async {
    if (enabled) {
      await scheduleDailyReminder(time: time, timezone: timezone);
    } else {
      await cancelDailyReminder();
    }
  }

  /// Get list of pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    debugPrint(
      'DailyReminderScheduler: ${pending.length} pending notifications',
    );
    for (final notification in pending) {
      debugPrint('  - ID: ${notification.id}, Title: ${notification.title}');
    }
    return pending;
  }

  /// Check if daily reminder is in pending notifications
  Future<bool> isDailyReminderPending() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    final hasDailyReminder = pending.any((n) => n.id == _dailyReminderId);
    debugPrint(
      'DailyReminderScheduler: Daily reminder pending: $hasDailyReminder',
    );
    return hasDailyReminder;
  }

  /// Show an immediate test notification to verify notifications work
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      enableLights: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: 9999, // Test notification ID
      title: 'Test Notification',
      body: 'If you see this, notifications are working!',
      notificationDetails: notificationDetails,
    );

    debugPrint('DailyReminderScheduler: Test notification sent');
  }

  /// Check exact alarm permission status
  Future<bool> hasExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      return await androidPlugin.canScheduleExactNotifications() ?? false;
    }
    return true;
  }
}
