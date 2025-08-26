import 'package:equatable/equatable.dart';

class SupportTicket extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final bool isPremiumUser;
  final int priority; // 1 = highest, 3 = normal, 5 = low
  final String? response;

  const SupportTicket({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    required this.isPremiumUser,
    required this.priority,
    this.response,
  });

  SupportTicket copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    bool? isPremiumUser,
    int? priority,
    String? response,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
      priority: priority ?? this.priority,
      response: response ?? this.response,
    );
  }

  static const List<String> categories = [
    'Technical Issue',
    'Feature Request',
    'Billing Question',
    'Account Issue',
    'Other',
  ];

  static const List<String> statuses = [
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        category,
        createdAt,
        updatedAt,
        status,
        isPremiumUser,
        priority,
        response,
      ];
}