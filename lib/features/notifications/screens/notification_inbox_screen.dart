import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';
import 'package:the_accountant/features/notifications/providers/notification_history_provider.dart';
import 'package:the_accountant/features/notifications/widgets/notification_tile.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class NotificationInboxScreen extends ConsumerStatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  ConsumerState<NotificationInboxScreen> createState() =>
      _NotificationInboxScreenState();
}

class _NotificationInboxScreenState
    extends ConsumerState<NotificationInboxScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationHistoryProvider.notifier).refresh();
    });

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationHistoryProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(notificationHistoryProvider.notifier).markAllAsRead();
              },
              child: Text(
                'Mark all read',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
          AppSpacing.gapHSm,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(notificationHistoryProvider.notifier).refresh(),
        color: AppColors.primaryAccent,
        backgroundColor: AppColors.primarySurface,
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(NotificationHistoryState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ShimmerCard(height: 72),
          SizedBox(height: 12),
          ShimmerCard(height: 72),
          SizedBox(height: 12),
          ShimmerCard(height: 72),
          SizedBox(height: 12),
          ShimmerCard(height: 72),
          SizedBox(height: 12),
          ShimmerCard(height: 72),
        ],
      );
    }

    if (state.errorMessage != null && state.notifications.isEmpty) {
      return _buildErrorState(state.errorMessage!);
    }

    if (state.notifications.isEmpty) {
      return const NotificationEmptyState();
    }

    return _buildNotificationList(state);
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapLg,
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapLg,
            TextButton(
              onPressed: () =>
                  ref.read(notificationHistoryProvider.notifier).refresh(),
              child: Text(
                'Try again',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(NotificationHistoryState state) {
    final groupedNotifications = _groupNotificationsByDate(state.notifications);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: AppSpacing.xxl),
      itemCount: groupedNotifications.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groupedNotifications.length) {
          return Padding(
            padding: AppSpacing.paddingLg,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = groupedNotifications[index];

        if (item is String) {
          // Date header
          return NotificationDateHeader(title: item);
        } else if (item is NotificationItem) {
          // Notification tile
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: NotificationTile(
              notification: item,
              onTap: () => _onNotificationTap(item),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<dynamic> _groupNotificationsByDate(
    List<NotificationItem> notifications,
  ) {
    final List<dynamic> grouped = [];
    String? lastDateGroup;

    for (final notification in notifications) {
      final dateGroup = _getDateGroup(notification.createdAt);

      if (dateGroup != lastDateGroup) {
        grouped.add(dateGroup);
        lastDateGroup = dateGroup;
      }

      grouped.add(notification);
    }

    return grouped;
  }

  String _getDateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return 'This Week';
    } else if (now.difference(date).inDays < 30) {
      return 'This Month';
    } else {
      return 'Earlier';
    }
  }

  void _onNotificationTap(NotificationItem notification) {
    HapticFeedback.lightImpact();

    // Mark as read if not already
    if (!notification.isRead) {
      ref
          .read(notificationHistoryProvider.notifier)
          .markAsRead(notification.id);
    }

    // Show notification detail in a bottom sheet
    _showNotificationDetail(notification);
  }

  void _showNotificationDetail(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
            ),
            AppSpacing.gapXl,
            // Icon and title
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notification.type.color.withValues(alpha: 0.15),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    notification.type.icon,
                    color: notification.type.color,
                    size: AppSpacing.iconMd,
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    notification.title,
                    style: AppTypography.titleMedium,
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            // Body
            Text(
              notification.body,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapLg,
            // Time
            Text(
              _formatDateTime(notification.createdAt),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    String dateStr;
    if (notificationDate == today) {
      dateStr = 'Today';
    } else if (notificationDate == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$dateStr at $hour12:$minute $period';
  }
}
