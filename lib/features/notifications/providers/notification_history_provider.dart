import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';
import 'package:the_accountant/features/notifications/services/local_notification_log.dart';

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

/// The inbox: what the server sent, and what this phone showed by itself.
///
/// It listed only the server's history, which was empty because the server
/// never had a device to send to, and it could not read that history even
/// once there was some (see [NotificationItem.fromJson]). Budget alerts shown
/// on the phone never appeared at all. Now both sources are merged, newest
/// first, and the phone's own are always there, online or not.
class NotificationHistoryNotifier
    extends StateNotifier<NotificationHistoryState> {
  final ApiService _apiService;
  final Logger _logger = Logger();
  static const int _pageSize = 20;

  NotificationHistoryNotifier(this._apiService)
    : super(const NotificationHistoryState()) {
    NotificationService().arrivals.addListener(_onArrival);
  }

  @override
  void dispose() {
    NotificationService().arrivals.removeListener(_onArrival);
    super.dispose();
  }

  /// Something arrived while the app is open: the badge, and the list if it
  /// has been looked at, catch up.
  void _onArrival() {
    if (state.notifications.isEmpty) {
      loadUnreadCount();
    } else {
      refresh();
    }
  }

  Future<List<NotificationItem>> _serverPage(int page) async {
    final response = await _apiService.get(
      '/notifications/history',
      queryParameters: {'page': page, 'pageSize': _pageSize},
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return [
      for (final json in data)
        NotificationItem.fromJson(json as Map<String, dynamic>),
    ];
  }

  static List<NotificationItem> _merge(
    List<NotificationItem> a,
    List<NotificationItem> b,
  ) => [...a, ...b]..sort((x, y) => y.createdAt.compareTo(x.createdAt));

  /// Load the initial page of notifications.
  Future<void> loadNotifications() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    final local = await LocalNotificationLog.read();

    try {
      final server = await _serverPage(1);
      state = state.copyWith(
        isLoading: false,
        notifications: _merge(server, local),
        currentPage: 1,
        hasMore: server.length >= _pageSize,
      );
      _logger.i('Loaded ${server.length} + ${local.length} notifications');
    } catch (e) {
      _logger.e('Failed to load notifications: $e');
      // Offline still shows what this phone has.
      state = state.copyWith(
        isLoading: false,
        notifications: local,
        hasMore: false,
        errorMessage: local.isEmpty ? 'Failed to load notifications' : null,
      );
    }
  }

  /// Load more notifications (pagination).
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final more = await _serverPage(nextPage);
      state = state.copyWith(
        isLoadingMore: false,
        notifications: _merge(state.notifications, more),
        currentPage: nextPage,
        hasMore: more.length >= _pageSize,
      );
    } catch (e) {
      _logger.e('Failed to load more notifications: $e');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Load the unread count, server and local together.
  Future<void> loadUnreadCount() async {
    final local = (await LocalNotificationLog.read())
        .where((n) => !n.isRead)
        .length;
    var server = 0;
    try {
      final response = await _apiService.get('/notifications/unread-count');
      server = response.data as int;
    } catch (e) {
      _logger.e('Failed to load unread count: $e');
    }
    state = state.copyWith(unreadCount: server + local);
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    final item = state.notifications
        .where((n) => n.id == notificationId)
        .firstOrNull;
    if (item == null || item.isRead) return;
    try {
      if (item.isLocal) {
        await LocalNotificationLog.markRead(notificationId);
      } else {
        await _apiService.post('/notifications/$notificationId/read');
      }
      state = state.copyWith(
        notifications: [
          for (final n in state.notifications)
            n.id == notificationId
                ? n.copyWith(
                    status: NotificationStatus.read,
                    readAt: DateTime.now(),
                  )
                : n,
        ],
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
    } catch (e) {
      _logger.e('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    await LocalNotificationLog.markAllRead();
    try {
      await _apiService.post('/notifications/mark-all-read');
    } catch (e) {
      _logger.e('Failed to mark all as read: $e');
    }
    state = state.copyWith(
      notifications: [
        for (final n in state.notifications)
          n.isRead
              ? n
              : n.copyWith(
                  status: NotificationStatus.read,
                  readAt: DateTime.now(),
                ),
      ],
      unreadCount: 0,
    );
  }

  /// Ask the server to send this phone a notification, to prove the path.
  /// Returns whether it was delivered to Firebase, and why not when it was not.
  Future<({bool delivered, String? error})> sendTest() async {
    // Make sure this phone is registered first; that was the missing step.
    await NotificationService().registerNow();
    final response = await _apiService.post('/notifications/test');
    final data = response.data as Map<String, dynamic>;
    await refresh();
    return (
      delivered: data['delivered'] == true,
      error: data['error'] as String?,
    );
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
