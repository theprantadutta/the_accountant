import 'dart:io';

/// Product IDs and billing constants for The Accountant premium subscriptions
class TheAccountantProducts {
  static const String packageName = 'com.pranta.the_accountant';
  static const String iosBundleId = 'com.pranta.theAccountant';

  // Google Play Product IDs (Android)
  static const String premiumMonthlyAndroid =
      'com.pranta.the_accountant.premium.monthly';
  static const String premiumYearlyAndroid =
      'com.pranta.the_accountant.premium.yearly';
  static const String premiumLifetimeAndroid =
      'com.pranta.the_accountant.premium.lifetime';

  // iOS App Store Product IDs
  static const String premiumMonthlyIos = 'premium_monthly';
  static const String premiumYearlyIos = 'premium_yearly';
  static const String premiumLifetimeIos = 'premium_lifetime';

  // Pricing (USD - fallback values when store prices unavailable)
  static const double monthlyPrice = 2.99;
  static const double yearlyPrice = 19.99;
  static const double lifetimePrice = 49.99;

  // Platform-aware product IDs
  static String get monthly =>
      Platform.isIOS ? premiumMonthlyIos : premiumMonthlyAndroid;
  static String get yearly =>
      Platform.isIOS ? premiumYearlyIos : premiumYearlyAndroid;
  static String get lifetime =>
      Platform.isIOS ? premiumLifetimeIos : premiumLifetimeAndroid;

  static Set<String> get allProductIds => {monthly, yearly, lifetime};

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
