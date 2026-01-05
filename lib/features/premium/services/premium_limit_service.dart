import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// Service to check premium limits for various entity types
class PremiumLimitService {
  final Ref _ref;

  PremiumLimitService(this._ref);

  /// Check if the user can add more of an entity type
  /// Returns true if they can, false if they've reached the limit
  bool canAddMore(String entityType, int currentCount) {
    final premiumState = _ref.read(premiumProvider);
    if (premiumState.isPremium) return true;

    final limit = _getLimitForEntity(entityType);
    return currentCount < limit;
  }

  /// Check and throw if limit is reached
  /// Throws PremiumLimitException if limit is reached
  void checkLimit(String entityType, int currentCount) {
    if (!canAddMore(entityType, currentCount)) {
      final limit = _getLimitForEntity(entityType);
      throw PremiumLimitException(
        entityType: entityType,
        currentCount: currentCount,
        limit: limit,
      );
    }
  }

  /// Get remaining count for an entity type
  /// Returns -1 for unlimited (premium users)
  int getRemainingCount(String entityType, int currentCount) {
    final premiumState = _ref.read(premiumProvider);
    if (premiumState.isPremium) return -1;

    final limit = _getLimitForEntity(entityType);
    return (limit - currentCount).clamp(0, limit);
  }

  /// Check if user is at the limit (used for UI warnings)
  bool isAtLimit(String entityType, int currentCount) {
    final premiumState = _ref.read(premiumProvider);
    if (premiumState.isPremium) return false;

    final limit = _getLimitForEntity(entityType);
    return currentCount >= limit;
  }

  /// Check if user is approaching limit (80% or more)
  bool isApproachingLimit(String entityType, int currentCount) {
    final premiumState = _ref.read(premiumProvider);
    if (premiumState.isPremium) return false;

    final limit = _getLimitForEntity(entityType);
    return currentCount >= (limit * 0.8).floor();
  }

  int _getLimitForEntity(String entityType) {
    switch (entityType) {
      case 'wallet':
        return FreeTierLimits.maxWallets;
      case 'category':
        return FreeTierLimits.maxCustomCategories;
      case 'budget':
        return FreeTierLimits.maxActiveBudgets;
      case 'objective':
        return FreeTierLimits.maxActiveObjectives;
      case 'payment_method':
        return FreeTierLimits.maxPaymentMethods;
      default:
        return 999;
    }
  }
}

/// Provider for PremiumLimitService
final premiumLimitServiceProvider = Provider<PremiumLimitService>((ref) {
  return PremiumLimitService(ref);
});
