import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/data/models/premium_features.dart';

class PremiumService {
  final Ref _ref;

  PremiumService(this._ref);

  /// Check if premium features are unlocked (active subscription)
  bool isPremiumUnlocked() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.isPremium;
  }

  /// Get current subscription tier
  SubscriptionTier getSubscriptionTier() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.tier;
  }

  /// Check if a specific feature is unlocked by ID
  bool isFeatureUnlocked(String featureId) {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.isPremium &&
        premiumState.features.features.contains(featureId);
  }

  /// Check if user can add more of an entity type
  bool canAddMore(String entityType, int currentCount) {
    return _ref.read(premiumProvider.notifier).canAddMore(
          entityType: entityType,
          currentCount: currentCount,
        );
  }

  /// Get remaining count for an entity type
  int getRemainingCount(String entityType, int currentCount) {
    return _ref.read(premiumProvider.notifier).getRemainingCount(
          entityType: entityType,
          currentCount: currentCount,
        );
  }

  /// Get list of unlocked features
  List<String> getUnlockedFeatures() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.isPremium ? premiumState.features.features : [];
  }

  /// Get all available premium feature IDs
  List<String> getAllPremiumFeatureIds() {
    return PremiumFeatureIds.all;
  }

  /// Get all premium feature display names for UI
  List<String> getAllPremiumFeatureDisplayNames() {
    return PremiumFeatures.allFeatureDisplayNames;
  }

  /// Legacy: Get all available premium features (for backward compatibility)
  List<String> getAllPremiumFeatures() {
    return PremiumFeatures.allFeatures;
  }

  /// Check if subscription is expiring soon
  bool isExpiringSoon() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.isExpiringSoon;
  }

  /// Get days remaining in subscription
  int? getDaysRemaining() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.daysRemaining;
  }
}
