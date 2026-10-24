import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/app_destination.dart';
import 'package:the_accountant/core/services/fcm_registration_service.dart';
import 'package:the_accountant/core/services/daily_reminder_scheduler.dart';
import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/services/notification_action_handler.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';
import 'package:the_accountant/features/notifications/services/local_notification_log.dart';

/// The Android channels notifications are shown on.
///
/// Created up front, with names a person can recognise in the system
/// settings. The server names one of these in every push; it used to name
/// "default_channel", which the app never created, so Android put every push
/// in an unnamed fallback.
class NotificationChannels {
  NotificationChannels._();

  static const general = AndroidNotificationChannel(
    'general',
    'General',
    description: 'Account and app notifications',
    importance: Importance.high,
  );
  static const reminders = AndroidNotificationChannel(
    'reminders',
    'Daily reminders',
    description: 'A nudge to log the day\'s spending',
    importance: Importance.high,
  );
  static const bills = AndroidNotificationChannel(
    'bills',
    'Card bills',
    description: 'Credit card statements and due dates',
    importance: Importance.max,
  );
  static const budgets = AndroidNotificationChannel(
    'budget_channel',
    'Budget alerts',
    description: 'When a budget is nearly or fully spent',
    importance: Importance.high,
  );

  static const all = [general, reminders, bills, budgets];

  static AndroidNotificationChannel byId(String? id) =>
      all.firstWhere((c) => c.id == id, orElse: () => general);
}

class NotificationService {
  // Late, so that holding the service (the app does from its first frame, to
  // route notification taps) does not need Firebase until something is sent.
  late final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final FcmRegistrationService _fcmRegistrationService =
      FcmRegistrationService();
  final DailyReminderScheduler _dailyReminderScheduler =
      DailyReminderScheduler();
  final Logger _logger = Logger();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Flag to track if the user is authenticated (set by AuthProvider).
  bool _isAuthenticated = false;

  /// Where a tapped notification asks to go. Set by the app once the deep
  /// link service exists; a tap before that is held until it is.
  void Function(DeepLink link)? _onOpen;
  DeepLink? _heldOpen;

  set onOpen(void Function(DeepLink link)? handler) {
    _onOpen = handler;
    final held = _heldOpen;
    if (handler != null && held != null) {
      _heldOpen = null;
      handler(held);
    }
  }

  /// Bumped whenever a notification arrives while the app is open, so the
  /// inbox badge can catch up without waiting for the next launch.
  final ValueNotifier<int> arrivals = ValueNotifier(0);

  /// Set the authentication state.
  ///
  /// Signing in is what registers this phone for push. Nothing used to call
  /// this, so no phone was ever registered and the server had nowhere to
  /// send anything.
  void setAuthenticated(bool authenticated) {
    final wasAuthenticated = _isAuthenticated;
    _isAuthenticated = authenticated;
    if (authenticated) {
      _registerFcmToken();
    } else if (wasAuthenticated) {
      LocalNotificationLog.clear();
    }
  }

  Future<void> initialize() async {
    // IMPORTANT: Do NOT request notification permission here. Requesting on
    // launch fires the iOS system dialog with no context (an App Store
    // anti-pattern). Permission is requested explicitly via [requestPermission]
    // only after the user opts in through the in-app priming prompt.

    // Initialize local notifications. requestXxxPermission are all false so
    // plugin setup never triggers the system permission dialog either.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_notify');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationAction,
    );

    final android = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    for (final channel in NotificationChannels.all) {
      await android?.createNotificationChannel(channel);
    }

    // A local notification that launched the app from cold.
    final launch = await _localNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true &&
        launch?.notificationResponse != null) {
      _onNotificationTapped(launch!.notificationResponse!);
    }

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

    // Initialize daily reminder scheduler (timezone, and retiring the reminder
    // this phone used to schedule for itself)
    await _dailyReminderScheduler.initialize();
  }

  /// Explicitly request notification permission — this is what fires the OS
  /// system dialog. Call it ONLY after the user has opted in via the in-app
  /// priming prompt. Returns true if notifications are authorized.
  Future<bool> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _logger.i('FCM permission status: ${settings.authorizationStatus}');

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    // Now that we're authorized, make sure the FCM token is registered.
    if (granted) {
      await _registerFcmToken();
    }
    return granted;
  }

  /// Current notification authorization status. Does NOT prompt.
  Future<bool> hasPermission() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Register FCM token with the backend (called when user is authenticated).
  Future<bool> _registerFcmToken() async {
    if (!_isAuthenticated) return false;
    return _fcmRegistrationService.registerToken();
  }

  /// Register this phone again, for the settings screen's check.
  Future<bool> registerNow() => _registerFcmToken();

  /// Unregister the device when user logs out.
  Future<void> unregisterDevice() async {
    await _fcmRegistrationService.unregisterDevice();
  }

  /// Handle notification tap from local notification.
  /// Also handles snooze/skip action buttons when app is in foreground.
  void _onNotificationTapped(NotificationResponse response) {
    final actionId = response.actionId;
    if (actionId != null && actionId.isNotEmpty) {
      // Delegate action button presses to the shared handler
      if (actionId == BackgroundTaskConstants.actionSnooze1Day ||
          actionId == BackgroundTaskConstants.actionSnooze1Week ||
          actionId == BackgroundTaskConstants.actionSnooze1Month ||
          actionId == BackgroundTaskConstants.actionSkip) {
        onBackgroundNotificationAction(response);
        return;
      }
    }

    Map<String, dynamic> data = const {};
    try {
      final decoded = jsonDecode(response.payload ?? '');
      if (decoded is Map<String, dynamic>) data = decoded;
    } catch (_) {}
    _open(data);
  }

  /// Handle notification tap from FCM.
  void _handleNotificationTap(RemoteMessage message) => _open(message.data);

  /// Go where a notification's data says, by way of the deep link service, so
  /// it waits until the app is signed in and on screen.
  void _open(Map<String, dynamic> data) {
    final link = linkFor(data);
    final handler = _onOpen;
    if (handler == null) {
      _heldOpen = link;
    } else {
      handler(link);
    }
  }

  /// Where a notification with [data] takes you when tapped.
  @visibleForTesting
  static DeepLink linkFor(Map<String, dynamic> data) {
    final transactionId = data['transactionId'] as String?;
    return switch (data['action']) {
      'open_add_transaction' => const DeepLink(AppDestination.addExpense),
      'open_card_bills' => DeepLink(
        AppDestination.cardBills,
        entityId: data['walletId'] as String?,
      ),
      'open_plan' => DeepLink(
        AppDestination.plans,
        entityId: data['planId'] as String?,
      ),
      'open_budget' => const DeepLink(AppDestination.budgets),
      'open_transactions' => const DeepLink(AppDestination.transactions),
      'open_zakat' => const DeepLink(AppDestination.zakat),
      _ when transactionId != null => DeepLink(
        AppDestination.transactionDetail,
        entityId: transactionId,
      ),
      _ => const DeepLink(AppDestination.notifications),
    };
  }

  /// A push that arrived while the app is open.
  ///
  /// Android only draws a push itself when the app is in the background, so
  /// in the foreground it is shown here, on the channel the server named. It
  /// is already in the server's history, so it is not logged locally.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final channel = NotificationChannels.byId(
      message.data['channel'] as String?,
    );
    await _localNotificationsPlugin.show(
      id: message.messageId.hashCode,
      title: message.notification?.title ?? 'The Accountant',
      body: message.notification?.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: Priority.high,
          icon: '@drawable/ic_stat_notify',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
    arrivals.value++;
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint(
      'NotificationService: Background FCM - '
      'id: ${message.messageId}, data: ${message.data}',
    );
  }

  /// Show a notification worked out on this phone, and keep it for the inbox.
  Future<void> _showLocalNotification(
    String title,
    String body, {
    int? id,
    required NotificationType type,
    AndroidNotificationChannel channel = NotificationChannels.budgets,
    Map<String, dynamic>? data,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
        icon: '@drawable/ic_stat_notify',
      ),
    );

    await _localNotificationsPlugin.show(
      id: id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: data == null ? null : jsonEncode(data),
    );
    await LocalNotificationLog.record(type: type, title: title, body: body);
    arrivals.value++;
  }

  /// A reminder worked out on this phone, such as the zakat date's, shown on
  /// the general channel. A tap goes where [data] says.
  Future<void> showReminder({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) => _showLocalNotification(
    title,
    body,
    id: id,
    type: NotificationType.custom,
    channel: NotificationChannels.general,
    data: data,
  );

  // Local storage key prefix for budget notification tracking
  static const String _keyLastBudgetNotification = 'last_budget_notification_';

  /// Whether a budget notification should be shown, given a 24-hour cooldown.
  ///
  /// The cooldown is per budget AND per state. Crossing the limit is a
  /// different event from approaching it, so a warning at 80% this morning
  /// must not silence the message that the budget is now spent — which is the
  /// one the user actually needs.
  Future<bool> _shouldShowBudgetNotification(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final lastNotified = prefs.getString('$_keyLastBudgetNotification$key');
    if (lastNotified == null) return true;

    final lastDate = DateTime.parse(lastNotified);
    return DateTime.now().difference(lastDate).inHours >= 24;
  }

  /// Record that a budget notification was shown
  Future<void> _recordBudgetNotification(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_keyLastBudgetNotification$key',
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> showBudgetWarningNotification(
    String budgetName,
    double percentage, {
    String? budgetId,
  }) async {
    // Use budgetName as ID if no specific ID provided
    final id = budgetId ?? budgetName;
    final exceeded = percentage >= 100;
    final cooldownKey = exceeded ? '$id:over' : '$id:warn';

    final shouldShow = await _shouldShowBudgetNotification(cooldownKey);
    if (!shouldShow) {
      _logger.d('Budget notification for $budgetName skipped (cooldown)');
      return;
    }

    // Past the limit and merely close to it are different situations, and one
    // wording for both makes the serious case read like the routine one.
    final title = exceeded
        ? 'Over budget: $budgetName'
        : 'Budget alert: $budgetName';
    final body = exceeded
        ? 'You have spent ${percentage.toStringAsFixed(0)}% of your '
              '$budgetName budget for this period.'
        : 'You have used ${percentage.toStringAsFixed(0)}% of your '
              '$budgetName budget.';

    await _showLocalNotification(
      title,
      body,
      id: 2000 + (id.hashCode % 1000),
      type: exceeded
          ? NotificationType.budgetExceeded
          : NotificationType.budgetWarning,
      data: const {'action': 'open_budget'},
    );

    // Record that we showed this notification
    await _recordBudgetNotification(cooldownKey);
    _logger.i('Budget warning notification shown for $budgetName');
  }

  // Local storage key for subscription expiry notification tracking
  static const String _keyLastSubscriptionWarning =
      'last_subscription_expiry_warning';

  /// Check if subscription expiry notification should be shown (24-hour cooldown)
  Future<bool> _shouldShowSubscriptionNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final lastNotified = prefs.getString(_keyLastSubscriptionWarning);
    if (lastNotified == null) return true;

    final lastDate = DateTime.parse(lastNotified);
    return DateTime.now().difference(lastDate).inHours >= 24;
  }

  /// Record that a subscription notification was shown
  Future<void> _recordSubscriptionNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyLastSubscriptionWarning,
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> showSubscriptionAlertNotification(
    String subscriptionName,
  ) async {
    // Check if we should show this notification (24-hour cooldown)
    final shouldShow = await _shouldShowSubscriptionNotification();
    if (!shouldShow) {
      _logger.d('Subscription notification skipped (cooldown)');
      return;
    }

    final title = 'Subscription Alert';
    final body = 'Your $subscriptionName subscription is due soon.';

    await _showLocalNotification(
      title,
      body,
      id: 5000,
      type: NotificationType.subscriptionExpiringSoon,
      channel: NotificationChannels.general,
    );

    // Record that we showed this notification
    await _recordSubscriptionNotification();
    _logger.i('Subscription expiry notification shown for $subscriptionName');
  }

  Future<void> showLargeTransactionNotification(
    double amount,
    String title,
    bool isIncome,
  ) async {
    final alertTitle = isIncome ? 'Large Income Alert' : 'Large Expense Alert';
    final body = title.isNotEmpty
        ? '${isIncome ? "Income" : "Expense"} of ${amount.toStringAsFixed(2)} recorded: $title'
        : '${isIncome ? "Income" : "Expense"} of ${amount.toStringAsFixed(2)} recorded';

    await _showLocalNotification(
      alertTitle,
      body,
      id: 8000 + (title.hashCode % 500).abs(),
      type: NotificationType.largeTransaction,
      channel: NotificationChannels.general,
      data: const {'action': 'open_transactions'},
    );
    _logger.i('Large transaction notification shown: $alertTitle');
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

  /// Cancel the reminder this phone used to schedule for itself; the server
  /// sends it now.
  Future<void> cancelDailyReminder() async {
    await _dailyReminderScheduler.cancelDailyReminder();
  }

  // Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }
}
