import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/models/premium_features.dart';

PremiumFeatures _monthly(DateTime expiresAt) => PremiumFeatures(
  isUnlocked: true,
  tier: SubscriptionTier.premiumMonthly,
  features: const [],
  expiresAt: expiresAt,
);

void main() {
  test('a renewal the cache has not heard of yet keeps Premium offline', () {
    // The cached period ended yesterday; the store has likely renewed it.
    final cached = _monthly(DateTime.now().subtract(const Duration(days: 1)));
    expect(cached.isPremiumActive, isTrue);
  });

  test('Premium ends once the grace after the cached expiry has passed', () {
    final cached = _monthly(
      DateTime.now().subtract(
        PremiumFeatures.offlineGrace + const Duration(hours: 1),
      ),
    );
    expect(cached.isPremiumActive, isFalse);
  });

  test('lifetime never expires', () {
    const lifetime = PremiumFeatures(
      isUnlocked: true,
      tier: SubscriptionTier.premiumLifetime,
      features: [],
    );
    expect(lifetime.isPremiumActive, isTrue);
  });
}
