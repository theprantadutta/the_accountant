import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/premium/constants/product_ids.dart';
import 'package:the_accountant/features/premium/providers/iap_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// Bridges the IAP layer (`iapNotifierProvider`) to the feature-gating layer
/// (`premiumProvider`). Watch this provider once at app root to activate.
///
/// Without this bridge, a successful purchase updates `IAPState` but
/// `PremiumGate` / `isFeatureUnlocked` keep returning free-tier results.
final premiumIapSyncProvider = Provider<void>((ref) {
  // When the user transitions from unauthenticated -> authenticated (login,
  // session restore on app launch), kick IAPNotifier to re-query the backend.
  // Without this, /iap/subscription-status was called before the auth token
  // existed and IAPState.isPremium stayed false even for returning subscribers
  // signing in on a fresh device.
  ref.listen<AuthState>(authProvider, (previous, next) {
    final justAuthenticated =
        next.isAuthenticated && previous?.isAuthenticated != true;
    if (justAuthenticated) {
      ref.read(iapNotifierProvider.notifier).refresh();
    }
  });

  // Only listen to real transitions. `fireImmediately: true` would trigger on
  // the initial IAPState (isPremium=false, before the backend has been
  // contacted) and wipe SharedPreferences-cached premium for returning users.
  ref.listen<IAPState>(iapNotifierProvider, (previous, next) {
    // Ignore intermediate "loading" states where we have no confirmed answer.
    if (next.isLoading) return;
    // Ignore the very first real emission — `previous` is null, which means
    // we've just woken up and have no basis to compare against yet.
    if (previous == null) return;

    final tierChanged = previous.currentTier != next.currentTier;
    final expiryChanged = previous.expiresAt != next.expiresAt;
    final premiumChanged = previous.isPremium != next.isPremium;
    if (!tierChanged && !expiryChanged && !premiumChanged) return;

    final premiumNotifier = ref.read(premiumProvider.notifier);

    if (!next.isPremium) {
      // Only downgrade if we were previously holding a premium state. Avoids
      // clearing persisted premium when IAP hasn't actually confirmed loss.
      if (previous.isPremium) {
        premiumNotifier.lockPremiumFeatures();
      }
      return;
    }

    premiumNotifier.updateSubscription(
      tier: _mapProductIdToTier(next.currentTier),
      expiresAt: next.expiresAt,
      purchaseId: next.currentTier,
    );
  });
});

SubscriptionTier _mapProductIdToTier(String? productId) {
  if (productId == null) return SubscriptionTier.free;
  if (TheAccountantProducts.isLifetime(productId)) {
    return SubscriptionTier.premiumLifetime;
  }
  final lower = productId.toLowerCase();
  if (lower.contains('yearly')) return SubscriptionTier.premiumYearly;
  if (lower.contains('monthly')) return SubscriptionTier.premiumMonthly;
  return SubscriptionTier.free;
}
