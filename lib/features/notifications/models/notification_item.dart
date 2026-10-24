import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// One notification in the inbox: sent by the server, or shown by this phone.
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

  /// Shown by this phone rather than sent by the server, so read state lives
  /// here too. Budget alerts and the reminders worked out on the phone are
  /// these.
  final bool isLocal;

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
    this.isLocal = false,
  });

  bool get isRead => status == NotificationStatus.read;

  /// Reads the server's shape, which is snake_case with snake_case enum
  /// values ("daily_reminder"), and this phone's own, which is camelCase.
  ///
  /// It only ever read camelCase, so every row the server sent failed to
  /// parse and the inbox stayed empty even once there was something in it.
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    T? pick<T>(String camel, String snake) => (json[camel] ?? json[snake]) as T?;
    DateTime? date(String camel, String snake) {
      final raw = pick<String>(camel, snake);
      return raw == null ? null : DateTime.tryParse(raw)?.toLocal();
    }

    return NotificationItem(
      id: json['id'] as String,
      userId: pick<String>('userId', 'user_id') ?? '',
      type: NotificationType.fromString(json['type'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: json['data'] is String ? json['data'] as String : null,
      status: NotificationStatus.fromString(json['status'] as String? ?? ''),
      sentAt: date('sentAt', 'sent_at'),
      readAt: date('readAt', 'read_at'),
      createdAt: date('createdAt', 'created_at') ?? DateTime.now(),
      isLocal: json['isLocal'] == true,
    );
  }

  /// For keeping this phone's own notifications.
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type.name,
    'title': title,
    'body': body,
    if (data != null) 'data': data,
    'status': status.name,
    if (readAt != null) 'readAt': readAt!.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'isLocal': isLocal,
  };

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
      isLocal: isLocal,
    );
  }
}

/// "DailyReminder", "daily_reminder" and "dailyReminder" all as one key.
String _key(String value) => value.replaceAll('_', '').toLowerCase();

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
  cardStatementReady,
  cardPaymentDue,
  test,
  custom;

  static NotificationType fromString(String value) {
    final key = _key(value);
    return NotificationType.values.firstWhere(
      (t) => _key(t.name) == key,
      orElse: () => NotificationType.custom,
    );
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
      case NotificationType.cardStatementReady:
        return Icons.receipt_long;
      case NotificationType.cardPaymentDue:
        return Icons.credit_card;
      case NotificationType.test:
        return Icons.check_circle_outline;
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
      case NotificationType.cardStatementReady:
        return AppColors.info;
      case NotificationType.cardPaymentDue:
        return AppColors.warning;
      case NotificationType.test:
        return AppColors.success;
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
    final key = _key(value);
    return NotificationStatus.values.firstWhere(
      (s) => s.name == key,
      orElse: () => NotificationStatus.pending,
    );
  }
}
