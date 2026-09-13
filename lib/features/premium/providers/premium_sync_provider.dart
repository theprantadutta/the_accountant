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
      // Hands the store the account tag and reconciles what it already owns,
      // then re-asks the backend. A returning subscriber signing in on a new
      // device gets their plan back from this path alone.
      ref.read(iapNotifierProvider.notifier).onSignedIn(next.userId);
    }
  });

  // Reconcile the persisted premium cache against the backend's CONFIRMED
  // answer. We key off `backendConfirmed` (not a witnessed premium->free
  // transition) so an account that was downgraded/expired/refunded server-side
  // is corrected on the next cold start too — the old transition-only logic
  // never fired in that case (IAPState went free->free, no transition) and left
  // stale premium showing forever.
  ref.listen<IAPState>(iapNotifierProvider, (previous, next) {
    // Ignore loading states and anything not backed by a real backend answer
    // (startup defaults, failed requests). A failed sync must never downgrade a
    // cached-premium user.
    if (next.isLoading) return;

    final premiumNotifier = ref.read(premiumProvider.notifier);
    final cached = ref.read(premiumProvider);

    // A purchase the store completed and our backend could not verify. The
    // money has moved and the transaction is acknowledged, so it is honoured
    // here rather than waiting for a server that may be hours from agreeing.
    // Verification keeps retrying on every resume; when it lands, this becomes
    // an ordinary confirmed grant, and if the receipt is ever rejected the flag
    // clears and the next answer downgrades as usual.
    if (next.provisionalPremium && next.isPremium) {
      final tier = _mapProductIdToTier(next.currentTier);
      if (!cached.isPremium || cached.tier != tier) {
        premiumNotifier.updateSubscription(
          tier: tier,
          expiresAt: next.expiresAt,
          purchaseId: next.currentTier,
        );
      }
      return;
    }

    if (!next.backendConfirmed) return;

    if (!next.isPremium) {
      // Backend confirms free — reconcile the cache down (only if it currently
      // claims premium, to avoid redundant writes).
      if (cached.isPremium) {
        premiumNotifier.lockPremiumFeatures();
      }
      return;
    }

    // Backend confirms premium — sync tier/expiry, but only when something
    // actually differs so we don't rewrite SharedPreferences on every refresh.
    final tier = _mapProductIdToTier(next.currentTier);
    if (!cached.isPremium || cached.tier != tier) {
      premiumNotifier.updateSubscription(
        tier: tier,
        expiresAt: next.expiresAt,
        purchaseId: next.currentTier,
      );
    }
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
