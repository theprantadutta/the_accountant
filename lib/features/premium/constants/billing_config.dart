/// Billing configuration constants for The Accountant
class BillingConfig {
  /// Whether test mode is enabled (uses test product IDs)
  static const bool isTestMode = bool.fromEnvironment(
    'BILLING_TEST_MODE',
    defaultValue: false,
  );

  /// Package name for the app (matches Android applicationId and Google Play
  /// registration — distinct from the Android namespace which uses an underscore).
  static const String packageName = 'com.pranta.theaccountant';

  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration purchaseTimeout = Duration(minutes: 5);

  // Server verification
  static const bool enableServerVerification = true;
  static const Duration verificationTimeout = Duration(seconds: 30);

  // Grace period (must match backend Subscription:GracePeriodDays)
  static const Duration subscriptionGracePeriod = Duration(days: 3);

  // Subscription refresh throttle (for lifecycle mixin)
  static const Duration refreshInterval = Duration(minutes: 5);

  // Free tier limits (must match backend and PremiumFeatures)
  static const Map<String, int> freeTierLimits = {
    'wallets': 3,
    'categories': 10,
    'budgets': 3,
    'objectives': 2,
    'payment_methods': 5,
  };
}
