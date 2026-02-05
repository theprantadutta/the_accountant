import 'package:equatable/equatable.dart';

/// Subscription tier enum matching backend SubscriptionTier
enum SubscriptionTier {
  free,
  premiumMonthly,
  premiumYearly,
  premiumLifetime;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premiumMonthly:
        return 'Premium Monthly';
      case SubscriptionTier.premiumYearly:
        return 'Premium Yearly';
      case SubscriptionTier.premiumLifetime:
        return 'Premium Lifetime';
    }
  }

  bool get isPremium => this != SubscriptionTier.free;

  bool get isLifetime => this == SubscriptionTier.premiumLifetime;

  /// Parse from backend string
  static SubscriptionTier fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'premiummonthly':
      case 'premium_monthly':
        return SubscriptionTier.premiumMonthly;
      case 'premiumyearly':
      case 'premium_yearly':
        return SubscriptionTier.premiumYearly;
      case 'premiumlifetime':
      case 'premium_lifetime':
        return SubscriptionTier.premiumLifetime;
      default:
        return SubscriptionTier.free;
    }
  }
}

/// Feature identifiers for premium gating
class PremiumFeatureIds {
  // Core premium features
  static const String cloudSync = 'cloud_sync';
  static const String googleDriveBackup = 'google_drive_backup';

  // AI features
  static const String aiAssistant = 'ai_assistant';
  static const String receiptOcr = 'receipt_ocr';
  static const String aiInsights = 'ai_insights';
  static const String smartCategorization = 'smart_categorization';

  // Reports & Export
  static const String advancedReports = 'advanced_reports';
  static const String dataExport = 'data_export';

  // Customization
  static const String premiumThemes = 'premium_themes';

  // Unlimited entities
  static const String unlimitedWallets = 'unlimited_wallets';
  static const String unlimitedCategories = 'unlimited_categories';
  static const String unlimitedBudgets = 'unlimited_budgets';
  static const String unlimitedObjectives = 'unlimited_objectives';
  static const String unlimitedPaymentMethods = 'unlimited_payment_methods';

  // Support
  static const String prioritySupport = 'priority_support';

  /// All premium feature IDs
  static const List<String> all = [
    cloudSync,
    googleDriveBackup,
    aiAssistant,
    receiptOcr,
    aiInsights,
    smartCategorization,
    advancedReports,
    dataExport,
    premiumThemes,
    unlimitedWallets,
    unlimitedCategories,
    unlimitedBudgets,
    unlimitedObjectives,
    unlimitedPaymentMethods,
    prioritySupport,
  ];
}

/// Free tier limits
class FreeTierLimits {
  static const int maxWallets = 3;
  static const int maxCustomCategories = 10;
  static const int maxActiveBudgets = 3;
  static const int maxActiveObjectives = 2;
  static const int maxPaymentMethods = 5;
}

class PremiumFeatures extends Equatable {
  final bool isUnlocked;
  final SubscriptionTier tier;
  final List<String> features;
  final DateTime? purchaseDate;
  final DateTime? expiresAt;
  final String? purchaseId;

  const PremiumFeatures({
    required this.isUnlocked,
    this.tier = SubscriptionTier.free,
    required this.features,
    this.purchaseDate,
    this.expiresAt,
    this.purchaseId,
  });

  /// Check if premium is active (not expired)
  bool get isPremiumActive {
    if (!isUnlocked) return false;
    if (tier == SubscriptionTier.premiumLifetime) return true;
    if (expiresAt == null) return isUnlocked;
    return expiresAt!.isAfter(DateTime.now());
  }

  /// Check if subscription is expiring soon (within 7 days)
  bool get isExpiringSoon {
    if (!isPremiumActive) return false;
    if (tier == SubscriptionTier.premiumLifetime) return false;
    if (expiresAt == null) return false;
    return expiresAt!.difference(DateTime.now()).inDays <= 7;
  }

  /// Days remaining in subscription
  int? get daysRemaining {
    if (!isPremiumActive) return null;
    if (tier == SubscriptionTier.premiumLifetime) return null;
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now()).inDays;
  }

  /// Check if a specific feature is available
  bool hasFeature(String featureId) {
    if (!isPremiumActive) return false;
    return features.contains(featureId);
  }

  PremiumFeatures copyWith({
    bool? isUnlocked,
    SubscriptionTier? tier,
    List<String>? features,
    DateTime? purchaseDate,
    DateTime? expiresAt,
    String? purchaseId,
  }) {
    return PremiumFeatures(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      tier: tier ?? this.tier,
      features: features ?? this.features,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiresAt: expiresAt ?? this.expiresAt,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }

  /// Display-friendly feature list for UI
  static const List<String> allFeatureDisplayNames = [
    'Cloud Sync',
    'Google Drive Backup',
    'AI Assistant',
    'Receipt OCR',
    'AI Insights',
    'Smart Categorization',
    'Advanced Reports',
    'Data Export',
    'Premium Themes',
    'Unlimited Wallets',
    'Unlimited Categories',
    'Unlimited Budgets',
    'Unlimited Objectives',
    'Priority Support',
  ];

  /// Legacy features list for backward compatibility
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
    tier,
    features,
    purchaseDate,
    expiresAt,
    purchaseId,
  ];
}
