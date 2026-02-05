import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';

const String _premiumTierKey = 'premium_tier';
const String _premiumExpiresAtKey = 'premium_expires_at';
const String _premiumPurchaseIdKey = 'premium_purchase_id';

class PremiumState {
  final PremiumFeatures features;
  final bool isLoading;
  final String? errorMessage;

  PremiumState({
    required this.features,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Quick check if user has active premium
  bool get isPremium => features.isPremiumActive;

  /// Current subscription tier
  SubscriptionTier get tier => features.tier;

  /// Check if subscription is expiring soon
  bool get isExpiringSoon => features.isExpiringSoon;

  /// Days remaining in subscription (null for lifetime or free)
  int? get daysRemaining => features.daysRemaining;

  PremiumState copyWith({
    PremiumFeatures? features,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PremiumState(
      features: features ?? this.features,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PremiumNotifier extends StateNotifier<PremiumState> {
  final Ref _ref;

  PremiumNotifier(this._ref)
    : super(
        PremiumState(
          features: const PremiumFeatures(
            isUnlocked: false,
            tier: SubscriptionTier.free,
            features: [],
          ),
        ),
      ) {
    _loadPersistedPremiumStatus();
  }

  /// Load persisted premium status from SharedPreferences
  void _loadPersistedPremiumStatus() {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      final tierStr = prefs.getString(_premiumTierKey);
      if (tierStr == null) return;

      final tier = SubscriptionTier.fromString(tierStr);
      if (tier == SubscriptionTier.free) return;

      final expiresAtStr = prefs.getString(_premiumExpiresAtKey);
      final purchaseId = prefs.getString(_premiumPurchaseIdKey);

      DateTime? expiresAt;
      if (expiresAtStr != null) {
        expiresAt = DateTime.tryParse(expiresAtStr);
        // Don't restore if expired (unless lifetime)
        if (expiresAt != null &&
            expiresAt.isBefore(DateTime.now()) &&
            tier != SubscriptionTier.premiumLifetime) {
          _clearPersistedPremiumStatus();
          return;
        }
      }

      state = state.copyWith(
        features: state.features.copyWith(
          isUnlocked: true,
          tier: tier,
          features: PremiumFeatureIds.all,
          expiresAt: expiresAt,
          purchaseId: purchaseId,
        ),
      );

      // Defer theme update to avoid modifying another provider during initialization
      Future.microtask(() {
        _ref.read(themeProvider.notifier).unlockPremiumThemes();
      });
    } catch (_) {
      // SharedPreferences may not be initialized yet - ignore
    }
  }

  /// Persist premium status to SharedPreferences
  void _persistPremiumStatus({
    required SubscriptionTier tier,
    DateTime? expiresAt,
    String? purchaseId,
  }) {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      prefs.setString(_premiumTierKey, tier.name);
      if (expiresAt != null) {
        prefs.setString(_premiumExpiresAtKey, expiresAt.toIso8601String());
      } else {
        prefs.remove(_premiumExpiresAtKey);
      }
      if (purchaseId != null) {
        prefs.setString(_premiumPurchaseIdKey, purchaseId);
      } else {
        prefs.remove(_premiumPurchaseIdKey);
      }
    } catch (_) {
      // Ignore persistence errors
    }
  }

  /// Clear persisted premium status
  void _clearPersistedPremiumStatus() {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      prefs.remove(_premiumTierKey);
      prefs.remove(_premiumExpiresAtKey);
      prefs.remove(_premiumPurchaseIdKey);
    } catch (_) {
      // Ignore persistence errors
    }
  }

  /// Update subscription status from backend or IAP
  void updateSubscription({
    required SubscriptionTier tier,
    DateTime? expiresAt,
    String? purchaseId,
  }) {
    final isPremium = tier != SubscriptionTier.free;

    state = state.copyWith(
      features: state.features.copyWith(
        isUnlocked: isPremium,
        tier: tier,
        features: isPremium ? PremiumFeatureIds.all : const [],
        purchaseDate: isPremium ? DateTime.now() : null,
        expiresAt: expiresAt,
        purchaseId: purchaseId,
      ),
    );

    // Persist to SharedPreferences
    if (isPremium) {
      _persistPremiumStatus(
        tier: tier,
        expiresAt: expiresAt,
        purchaseId: purchaseId,
      );
    } else {
      _clearPersistedPremiumStatus();
    }

    // Update theme access
    if (isPremium) {
      _ref.read(themeProvider.notifier).unlockPremiumThemes();
    } else {
      _ref.read(themeProvider.notifier).lockPremiumThemes();
    }
  }

  /// Legacy method - unlock all premium features (for backward compatibility)
  void unlockPremiumFeatures() {
    updateSubscription(
      tier: SubscriptionTier.premiumLifetime,
      purchaseId: 'legacy_unlock',
    );
  }

  /// Lock premium features (e.g., subscription expired)
  void lockPremiumFeatures() {
    state = state.copyWith(
      features: state.features.copyWith(
        isUnlocked: false,
        tier: SubscriptionTier.free,
        features: const [],
        purchaseDate: null,
        expiresAt: null,
        purchaseId: null,
      ),
    );

    _clearPersistedPremiumStatus();

    // Lock premium themes
    _ref.read(themeProvider.notifier).lockPremiumThemes();
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Set error message
  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  /// Check if a specific feature is unlocked
  bool isFeatureUnlocked(String featureId) {
    return state.features.isPremiumActive &&
        state.features.features.contains(featureId);
  }

  /// Check if user can add more of an entity (respects free tier limits)
  bool canAddMore({required String entityType, required int currentCount}) {
    if (state.isPremium) return true;

    switch (entityType) {
      case 'wallet':
        return currentCount < FreeTierLimits.maxWallets;
      case 'category':
        return currentCount < FreeTierLimits.maxCustomCategories;
      case 'budget':
        return currentCount < FreeTierLimits.maxActiveBudgets;
      case 'objective':
        return currentCount < FreeTierLimits.maxActiveObjectives;
      case 'payment_method':
        return currentCount < FreeTierLimits.maxPaymentMethods;
      default:
        return true;
    }
  }

  /// Get remaining count for an entity type
  int getRemainingCount({
    required String entityType,
    required int currentCount,
  }) {
    if (state.isPremium) return -1; // -1 means unlimited

    int limit;
    switch (entityType) {
      case 'wallet':
        limit = FreeTierLimits.maxWallets;
        break;
      case 'category':
        limit = FreeTierLimits.maxCustomCategories;
        break;
      case 'budget':
        limit = FreeTierLimits.maxActiveBudgets;
        break;
      case 'objective':
        limit = FreeTierLimits.maxActiveObjectives;
        break;
      case 'payment_method':
        limit = FreeTierLimits.maxPaymentMethods;
        break;
      default:
        return -1;
    }

    return limit - currentCount;
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumState>((
  ref,
) {
  return PremiumNotifier(ref);
});
