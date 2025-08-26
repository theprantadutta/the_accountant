import 'package:equatable/equatable.dart';

class PremiumFeatures extends Equatable {
  final bool isUnlocked;
  final List<String> features;
  final DateTime? purchaseDate;
  final String? purchaseId;

  const PremiumFeatures({
    required this.isUnlocked,
    required this.features,
    this.purchaseDate,
    this.purchaseId,
  });

  PremiumFeatures copyWith({
    bool? isUnlocked,
    List<String>? features,
    DateTime? purchaseDate,
    String? purchaseId,
  }) {
    return PremiumFeatures(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      features: features ?? this.features,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }

  static const List<String> allFeatures = [
    'Exclusive Themes',
    'Priority Support',
    'Advanced Analytics',
    'Custom Categories',
    'Data Export',
    'No Ads',
  ];

  @override
  List<Object?> get props => [
        isUnlocked,
        features,
        purchaseDate,
        purchaseId,
      ];
}