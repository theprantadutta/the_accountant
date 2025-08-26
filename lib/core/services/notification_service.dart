import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification when app is in foreground
    await _showLocalNotification(
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
    );
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle background messages
    // This method must be static
  }

  Future<void> _showLocalNotification(String title, String body, {int? id}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'budget_channel',
      'Budget Notifications',
      channelDescription: 'Notifications for budget alerts and reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _localNotificationsPlugin.show(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showBudgetWarningNotification(
      String budgetName, double percentage) async {
    final title = 'Budget Alert: $budgetName';
    final body =
        'You have used ${percentage.toStringAsFixed(0)}% of your $budgetName budget.';

    await _showLocalNotification(title, body, id: budgetName.hashCode);
  }

  Future<void> showDailyReminderNotification() async {
    const title = 'Daily Reminder';
    const body = 'Don\'t forget to track your expenses today!';

    await _showLocalNotification(title, body, id: 'daily_reminder'.hashCode);
  }

  Future<void> showSubscriptionAlertNotification(String subscriptionName) async {
    final title = 'Subscription Alert';
    final body = 'Your $subscriptionName subscription is due soon.';

    await _showLocalNotification(title, body, id: subscriptionName.hashCode);
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Schedule a daily reminder notification
  Future<void> scheduleDailyReminder({TimeOfDay? time}) async {
    // For simplicity, we'll just show a notification immediately
    // In a real implementation, you would use a package like flutter_local_notifications
    // to schedule recurring notifications
    await showDailyReminderNotification();
  }

  // Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }
}