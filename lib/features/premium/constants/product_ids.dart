/// Product IDs and billing constants for The Accountant premium subscriptions.
///
/// IDs are unified across Android and iOS so the backend's ProductTierMapping
/// only needs to know one string per product. Google Play limits product IDs
/// to 40 characters — keep new IDs within that budget.
class TheAccountantProducts {
  static const String packageName = 'com.pranta.theaccountant';
  static const String iosBundleId = 'com.pranta.theAccountant';

  // Canonical product IDs (same on Play Store and App Store)
  static const String premiumMonthly = 'accountant_premium_monthly';
  static const String premiumYearly = 'accountant_premium_yearly';
  static const String premiumLifetime = 'accountant_premium_lifetime';

  // Pricing (USD - fallback values when store prices unavailable)
  static const double monthlyPrice = 2.99;
  static const double yearlyPrice = 19.99;
  static const double lifetimePrice = 49.99;

  // Platform-aware getters retained for API compatibility with existing callers
  static String get monthly => premiumMonthly;
  static String get yearly => premiumYearly;
  static String get lifetime => premiumLifetime;

  static Set<String> get allProductIds => {
    premiumMonthly,
    premiumYearly,
    premiumLifetime,
  };

  // Google Play test product IDs
  static const String testPurchased = 'android.test.purchased';
  static const String testCanceled = 'android.test.canceled';
  static const String testRefunded = 'android.test.refunded';
  static const String testUnavailable = 'android.test.item_unavailable';

  /// Whether a product is a recurring subscription (vs one-time purchase)
  static bool isSubscription(String productId) {
    final lower = productId.toLowerCase();
    return lower.contains('monthly') || lower.contains('yearly');
  }

  /// Whether a product is a lifetime one-time purchase
  static bool isLifetime(String productId) {
    return productId.toLowerCase().contains('lifetime');
  }

  /// Get the tier display name from a product ID
  static String getTierDisplayName(String productId) {
    final lower = productId.toLowerCase();
    if (lower.contains('monthly')) return 'Premium Monthly';
    if (lower.contains('yearly')) return 'Premium Yearly';
    if (lower.contains('lifetime')) return 'Premium Lifetime';
    return 'Free';
  }

  /// Get savings text for a product
  static String? getSavingsText(String productId) {
    final lower = productId.toLowerCase();
    if (lower.contains('yearly')) return 'Save ~44%';
    if (lower.contains('lifetime')) return 'Best Value';
    return null;
  }
}
