import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/notification_service.dart';

class NotificationState {
  final bool isInitialized;
  final bool areNotificationsEnabled;
  final String? fcmToken;
  final bool isLoading;
  final String? errorMessage;

  NotificationState({
    this.isInitialized = false,
    this.areNotificationsEnabled = false,
    this.fcmToken,
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    bool? isInitialized,
    bool? areNotificationsEnabled,
    String? fcmToken,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationState(
      isInitialized: isInitialized ?? this.isInitialized,
      areNotificationsEnabled: areNotificationsEnabled ?? this.areNotificationsEnabled,
      fcmToken: fcmToken ?? this.fcmToken,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationService _notificationService;

  NotificationNotifier(this._notificationService) : super(NotificationState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _notificationService.initialize();
      
      // Get FCM token
      final token = await _notificationService.getToken();
      
      state = state.copyWith(
        isInitialized: true,
        areNotificationsEnabled: true,
        fcmToken: token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> requestPermissions() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _notificationService.initialize();
      
      // Get FCM token
      final token = await _notificationService.getToken();
      
      state = state.copyWith(
        areNotificationsEnabled: true,
        fcmToken: token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void subscribeToTopic(String topic) {
    try {
      _notificationService.subscribeToTopic(topic);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void unsubscribeFromTopic(String topic) {
    try {
      _notificationService.unsubscribeFromTopic(topic);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> showBudgetWarning(String budgetName, double percentage) async {
    try {
      await _notificationService.showBudgetWarningNotification(budgetName, percentage);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> showDailyReminder() async {
    try {
      await _notificationService.showDailyReminderNotification();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> showSubscriptionAlert(String subscriptionName) async {
    try {
      await _notificationService.showSubscriptionAlertNotification(subscriptionName);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(notificationService);
});