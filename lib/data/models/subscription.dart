import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String categoryId;
  final DateTime startDate;
  final DateTime? endDate;
  final String recurrence; // 'monthly', 'yearly', etc.
  final int recurrenceDay; // Day of month or year for recurrence
  final bool isActive;
  final String? notes;

  const Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.categoryId,
    required this.startDate,
    this.endDate,
    required this.recurrence,
    required this.recurrenceDay,
    required this.isActive,
    this.notes,
  });

  Subscription copyWith({
    String? id,
    String? name,
    double? amount,
    String? currency,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    String? recurrence,
    int? recurrenceDay,
    bool? isActive,
    String? notes,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrence: recurrence ?? this.recurrence,
      recurrenceDay: recurrenceDay ?? this.recurrenceDay,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    amount,
    currency,
    categoryId,
    startDate,
    endDate,
    recurrence,
    recurrenceDay,
    isActive,
    notes,
  ];
}
