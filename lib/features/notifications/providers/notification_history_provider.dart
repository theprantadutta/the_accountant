import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';

/// State for notification history.
class NotificationHistoryState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<NotificationItem> notifications;
  final int unreadCount;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const NotificationHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  NotificationHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<NotificationItem>? notifications,
    int? unreadCount,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return NotificationHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Notifier for managing notification history.
class NotificationHistoryNotifier
    extends StateNotifier<NotificationHistoryState> {
  final ApiService _apiService;
  final Logger _logger = Logger();
  static const int _pageSize = 20;

  NotificationHistoryNotifier(this._apiService)
    : super(const NotificationHistoryState());

  /// Load the initial page of notifications.
  Future<void> loadNotifications() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.get(
        '/notifications/history',
        queryParameters: {'page': 1, 'pageSize': _pageSize},
      );

      final List<dynamic> data = response.data as List<dynamic>;
      final notifications = data
          .map(
            (json) => NotificationItem.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        currentPage: 1,
        hasMore: notifications.length >= _pageSize,
      );

      _logger.i('Loaded ${notifications.length} notifications');
    } catch (e) {
      _logger.e('Failed to load notifications: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load notifications',
      );
    }
  }

  /// Load more notifications (pagination).
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _apiService.get(
        '/notifications/history',
        queryParameters: {'page': nextPage, 'pageSize': _pageSize},
      );

      final List<dynamic> data = response.data as List<dynamic>;
      final newNotifications = data
          .map(
            (json) => NotificationItem.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      state = state.copyWith(
        isLoadingMore: false,
        notifications: [...state.notifications, ...newNotifications],
        currentPage: nextPage,
        hasMore: newNotifications.length >= _pageSize,
      );

      _logger.i('Loaded ${newNotifications.length} more notifications');
    } catch (e) {
      _logger.e('Failed to load more notifications: $e');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Load the unread count.
  Future<void> loadUnreadCount() async {
    try {
      final response = await _apiService.get('/notifications/unread-count');
      final count = response.data as int;

      state = state.copyWith(unreadCount: count);
      _logger.i('Unread count: $count');
    } catch (e) {
      _logger.e('Failed to load unread count: $e');
    }
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiService.post('/notifications/$notificationId/read');

      // Update the local state
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == notificationId && !n.isRead) {
          return n.copyWith(
            status: NotificationStatus.read,
            readAt: DateTime.now(),
          );
        }
        return n;
      }).toList();

      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );

      _logger.i('Marked notification $notificationId as read');
    } catch (e) {
      _logger.e('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    try {
      await _apiService.post('/notifications/mark-all-read');

      // Update the local state
      final updatedNotifications = state.notifications.map((n) {
        if (!n.isRead) {
          return n.copyWith(
            status: NotificationStatus.read,
            readAt: DateTime.now(),
          );
        }
        return n;
      }).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );

      _logger.i('Marked all notifications as read');
    } catch (e) {
      _logger.e('Failed to mark all as read: $e');
    }
  }

  /// Refresh notifications (pull-to-refresh).
  Future<void> refresh() async {
    state = state.copyWith(currentPage: 1, hasMore: true);
    await Future.wait([loadNotifications(), loadUnreadCount()]);
  }
}

/// Provider for the API service.
final _apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider for notification history.
final notificationHistoryProvider =
    StateNotifierProvider<
      NotificationHistoryNotifier,
      NotificationHistoryState
    >((ref) {
      final apiService = ref.watch(_apiServiceProvider);
      return NotificationHistoryNotifier(apiService);
    });

/// Provider that just returns the unread count for use in the app bar badge.
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationHistoryProvider).unreadCount;
});
