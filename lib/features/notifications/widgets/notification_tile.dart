import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    final typeColor = notification.type.color;
    final typeIcon = notification.type.icon;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: isRead
              ? Colors.transparent
              : AppColors.primaryAccent.withValues(alpha: 0.05),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isRead
                ? AppColors.glassBorder.withValues(alpha: 0.3)
                : AppColors.primaryAccent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(typeIcon, color: typeColor, size: AppSpacing.iconSm),
            ),
            AppSpacing.gapHMd,
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            color: isRead
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(left: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  AppSpacing.gapXs,
                  Text(
                    notification.body,
                    style: AppTypography.bodySmall.copyWith(
                      color: isRead
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapSm,
                  Text(
                    _formatTimeAgo(notification.createdAt),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// Empty state widget when there are no notifications.
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 40,
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapXl,
            Text(
              'No notifications yet',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              'When you receive notifications, they will appear here.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header for date grouping.
class NotificationDateHeader extends StatelessWidget {
  final String title;

  const NotificationDateHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
