import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

// Legacy SharedPreferences keys — retained only to migrate any existing plaintext
// entitlement into secure storage (see _migrateLegacyPlaintextEntitlement), then wiped.
const String _legacyPremiumTierKey = 'premium_tier';
const String _legacyPremiumExpiresAtKey = 'premium_expires_at';
const String _legacyPremiumPurchaseIdKey = 'premium_purchase_id';

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
    unawaited(_loadPersistedPremiumStatus());
  }

  /// Load the cached premium status from secure storage (migrating any legacy plaintext
  /// copy out of SharedPreferences first). Async — until it completes the state stays free,
  /// which is a safe fail-closed default; the backend refresh is the source of truth.
  Future<void> _loadPersistedPremiumStatus() async {
    try {
      await _migrateLegacyPlaintextEntitlement();

      final stored = await SecureTokenStorage.getPremiumEntitlement();
      final tierStr = stored.tier;
      if (tierStr == null) return;

      final tier = SubscriptionTier.fromString(tierStr);
      if (tier == SubscriptionTier.free) return;

      DateTime? expiresAt;
      if (stored.expiresAtIso != null) {
        expiresAt = DateTime.tryParse(stored.expiresAtIso!);
        // Don't restore if expired (unless lifetime)
        if (expiresAt != null &&
            expiresAt.isBefore(DateTime.now()) &&
            tier != SubscriptionTier.premiumLifetime) {
          await SecureTokenStorage.clearPremiumEntitlement();
          return;
        }
      }

      state = state.copyWith(
        features: state.features.copyWith(
          isUnlocked: true,
          tier: tier,
          features: PremiumFeatureIds.all,
          expiresAt: expiresAt,
          purchaseId: stored.purchaseId,
        ),
      );

      _ref.read(themeProvider.notifier).unlockPremiumThemes();
    } catch (_) {
      // Secure storage may be unavailable - ignore and stay free until backend refresh.
    }
  }

  /// One-time migration: move any entitlement stored in plaintext SharedPreferences into
  /// secure storage, then remove the plaintext copy so it no longer lingers unencrypted.
  Future<void> _migrateLegacyPlaintextEntitlement() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      final legacyTier = prefs.getString(_legacyPremiumTierKey);
      if (legacyTier == null) return;

      final existing = await SecureTokenStorage.getPremiumEntitlement();
      if (existing.tier == null) {
        await SecureTokenStorage.storePremiumEntitlement(
          tier: legacyTier,
          expiresAtIso: prefs.getString(_legacyPremiumExpiresAtKey),
          purchaseId: prefs.getString(_legacyPremiumPurchaseIdKey),
        );
      }
      await prefs.remove(_legacyPremiumTierKey);
      await prefs.remove(_legacyPremiumExpiresAtKey);
      await prefs.remove(_legacyPremiumPurchaseIdKey);
    } catch (_) {
      // best effort
    }
  }

  /// Persist premium status to secure storage (fire-and-forget).
  void _persistPremiumStatus({
    required SubscriptionTier tier,
    DateTime? expiresAt,
    String? purchaseId,
  }) {
    unawaited(
      SecureTokenStorage.storePremiumEntitlement(
        tier: tier.name,
        expiresAtIso: expiresAt?.toIso8601String(),
        purchaseId: purchaseId,
      ),
    );
  }

  /// Clear persisted premium status from secure storage (fire-and-forget).
  void _clearPersistedPremiumStatus() {
    unawaited(SecureTokenStorage.clearPremiumEntitlement());
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

  /// Whether the user may add another of something.
  ///
  /// Always yes. Nothing is capped by tier any more — see [FreeTierLimits] for
  /// what is charged for instead. Kept so the call sites read as a question
  /// being asked rather than one nobody thought to ask.
  bool canAddMore({required String entityType, required int currentCount}) =>
      true;

  /// How many more of something the user may add. -1 means no limit.
  int getRemainingCount({
    required String entityType,
    required int currentCount,
  }) => -1;
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumState>((
  ref,
) {
  return PremiumNotifier(ref);
});
