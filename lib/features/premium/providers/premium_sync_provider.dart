import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/constants/product_ids.dart';
import 'package:the_accountant/features/premium/providers/iap_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// Bridges the IAP layer (`iapNotifierProvider`) to the feature-gating layer
/// (`premiumProvider`). Watch this provider once at app root to activate.
///
/// Without this bridge, a successful purchase updates `IAPState` but
/// `PremiumGate` / `isFeatureUnlocked` keep returning free-tier results.
final premiumIapSyncProvider = Provider<void>((ref) {
  ref.listen<IAPState>(iapNotifierProvider, (previous, next) {
    final tierChanged = previous?.currentTier != next.currentTier;
    final expiryChanged = previous?.expiresAt != next.expiresAt;
    final premiumChanged = previous?.isPremium != next.isPremium;

    if (!tierChanged && !expiryChanged && !premiumChanged) return;

    final premiumNotifier = ref.read(premiumProvider.notifier);

    if (!next.isPremium) {
      premiumNotifier.lockPremiumFeatures();
      return;
    }

    premiumNotifier.updateSubscription(
      tier: _mapProductIdToTier(next.currentTier),
      expiresAt: next.expiresAt,
      purchaseId: next.currentTier,
    );
  }, fireImmediately: true);
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
