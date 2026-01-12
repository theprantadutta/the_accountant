import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/fcm_registration_service.dart';
import 'package:the_accountant/core/services/daily_reminder_scheduler.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FcmRegistrationService _fcmRegistrationService =
      FcmRegistrationService();
  final DailyReminderScheduler _dailyReminderScheduler =
      DailyReminderScheduler();
  final Logger _logger = Logger();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Flag to track if the user is authenticated (set by AuthProvider).
  bool _isAuthenticated = false;

  /// Set the authentication state.
  void setAuthenticated(bool authenticated) {
    _isAuthenticated = authenticated;
    if (authenticated) {
      // Register FCM token when user becomes authenticated
      _registerFcmToken();
    }
  }

  Future<void> initialize() async {
    // Request permission for notifications
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _logger.i('FCM permission status: ${settings.authorizationStatus}');

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Set up token refresh listener
    _fcmRegistrationService.setupTokenRefreshListener();

    // Handle notification tap when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check for initial message (app opened from notification)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Initialize daily reminder scheduler (timezone + restore scheduled reminders)
    await _dailyReminderScheduler.initialize();
  }

  /// Register FCM token with the backend (called when user is authenticated).
  Future<void> _registerFcmToken() async {
    if (_isAuthenticated) {
      await _fcmRegistrationService.registerToken();
    }
  }

  /// Unregister the device when user logs out.
  Future<void> unregisterDevice() async {
    await _fcmRegistrationService.unregisterDevice();
  }

  /// Handle notification tap from local notification.
  void _onNotificationTapped(NotificationResponse response) {
    _logger.i('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Handle notification tap from FCM.
  void _handleNotificationTap(RemoteMessage message) {
    _logger.i('Notification opened: ${message.data}');
    // Handle navigation based on data payload
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

  Future<void> _showLocalNotification(
    String title,
    String body, {
    int? id,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'budget_channel',
          'Budget Notifications',
          channelDescription: 'Notifications for budget alerts and reminders',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _localNotificationsPlugin.show(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showBudgetWarningNotification(
    String budgetName,
    double percentage,
  ) async {
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

  Future<void> showSubscriptionAlertNotification(
    String subscriptionName,
  ) async {
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

  /// Schedule a daily reminder notification at the specified time.
  /// Uses DailyReminderScheduler for proper timezone-aware scheduling.
  Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    String timezone = 'UTC',
  }) async {
    await _dailyReminderScheduler.scheduleDailyReminder(
      time: time,
      timezone: timezone,
    );
  }

  /// Cancel the scheduled daily reminder.
  Future<void> cancelDailyReminder() async {
    await _dailyReminderScheduler.cancelDailyReminder();
  }

  /// Update daily reminder settings.
  Future<void> updateDailyReminder({
    required bool enabled,
    required TimeOfDay time,
    required String timezone,
  }) async {
    await _dailyReminderScheduler.updateReminder(
      enabled: enabled,
      time: time,
      timezone: timezone,
    );
  }

  /// Check if daily reminder is scheduled.
  Future<bool> isDailyReminderScheduled() async {
    return await _dailyReminderScheduler.isReminderScheduled();
  }

  // Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }
}
