import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// Represents a notification item from the backend.
class NotificationItem {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final String? data;
  final NotificationStatus status;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.status,
    this.sentAt,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => status == NotificationStatus.read;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: NotificationType.fromString(json['type'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as String?,
      status: NotificationStatus.fromString(json['status'] as String),
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  NotificationItem copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    String? data,
    NotificationStatus? status,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Notification types matching the backend enum.
enum NotificationType {
  dailyReminder,
  budgetWarning,
  budgetExceeded,
  largeTransaction,
  recurringReminder,
  subscriptionExpiringSoon,
  subscriptionExpired,
  promotional,
  custom;

  static NotificationType fromString(String value) {
    switch (value) {
      case 'DailyReminder':
        return NotificationType.dailyReminder;
      case 'BudgetWarning':
        return NotificationType.budgetWarning;
      case 'BudgetExceeded':
        return NotificationType.budgetExceeded;
      case 'LargeTransaction':
        return NotificationType.largeTransaction;
      case 'RecurringReminder':
        return NotificationType.recurringReminder;
      case 'SubscriptionExpiringSoon':
        return NotificationType.subscriptionExpiringSoon;
      case 'SubscriptionExpired':
        return NotificationType.subscriptionExpired;
      case 'Promotional':
        return NotificationType.promotional;
      case 'Custom':
      default:
        return NotificationType.custom;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.dailyReminder:
        return Icons.schedule;
      case NotificationType.budgetWarning:
        return Icons.warning_amber;
      case NotificationType.budgetExceeded:
        return Icons.error;
      case NotificationType.largeTransaction:
        return Icons.attach_money;
      case NotificationType.recurringReminder:
        return Icons.repeat;
      case NotificationType.subscriptionExpiringSoon:
        return Icons.star_outline;
      case NotificationType.subscriptionExpired:
        return Icons.star_border;
      case NotificationType.promotional:
        return Icons.campaign;
      case NotificationType.custom:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.dailyReminder:
        return AppColors.info;
      case NotificationType.budgetWarning:
        return AppColors.warning;
      case NotificationType.budgetExceeded:
        return AppColors.error;
      case NotificationType.largeTransaction:
        return AppColors.warning;
      case NotificationType.recurringReminder:
        return AppColors.info;
      case NotificationType.subscriptionExpiringSoon:
        return AppColors.warning;
      case NotificationType.subscriptionExpired:
        return AppColors.error;
      case NotificationType.promotional:
        return AppColors.primaryAccent;
      case NotificationType.custom:
        return AppColors.textSecondary;
    }
  }
}

/// Notification status matching the backend enum.
enum NotificationStatus {
  pending,
  sent,
  delivered,
  read,
  failed;

  static NotificationStatus fromString(String value) {
    switch (value) {
      case 'Pending':
        return NotificationStatus.pending;
      case 'Sent':
        return NotificationStatus.sent;
      case 'Delivered':
        return NotificationStatus.delivered;
      case 'Read':
        return NotificationStatus.read;
      case 'Failed':
        return NotificationStatus.failed;
      default:
        return NotificationStatus.pending;
    }
  }
}
