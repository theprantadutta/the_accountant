import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/services/notification_action_handler.dart';

/// Lightweight notification helper for background isolates.
/// Does NOT use Firebase, singletons, or any Riverpod state.
/// Only initializes flutter_local_notifications standalone.
class BackgroundNotificationHelper {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the plugin for background use.
  /// Does NOT request permissions (already granted from foreground).
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationAction,
    );
  }

  /// Show a notification with the given parameters.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String channelDesc,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  /// Show a notification with Snooze and Skip action buttons.
  /// The payload encodes transaction data as JSON so the background handler
  /// can reschedule or skip the occurrence.
  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String channelDesc,
    required String transactionId,
    required String transactionTitle,
    required double amount,
    required String type,
    required DateTime dueDate,
  }) async {
    final payload = jsonEncode({
      'transactionId': transactionId,
      'title': transactionTitle,
      'amount': amount,
      'type': type,
      'dueDate': dueDate.toIso8601String(),
    });

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          BackgroundTaskConstants.actionSnooze1Day,
          'Snooze 1d',
          showsUserInterface: false,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          BackgroundTaskConstants.actionSnooze1Week,
          'Snooze 1w',
          showsUserInterface: false,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          BackgroundTaskConstants.actionSkip,
          'Skip',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
