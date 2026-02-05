import 'package:the_accountant/data/models/premium_features.dart';

/// Exception thrown when a free tier limit is reached
class PremiumLimitException implements Exception {
  final String entityType;
  final int currentCount;
  final int limit;
  final String message;

  PremiumLimitException({
    required this.entityType,
    required this.currentCount,
    required this.limit,
    String? message,
  }) : message =
           message ??
           'You\'ve reached the free tier limit of $limit ${entityType}s. '
               'Upgrade to Premium for unlimited ${entityType}s.';

  @override
  String toString() => message;

  /// Get the appropriate limit for an entity type
  static int getLimitForEntity(String entityType) {
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
        return 999; // No limit
    }
  }

  /// Get a user-friendly entity name
  static String getEntityDisplayName(String entityType) {
    switch (entityType) {
      case 'wallet':
        return 'wallets';
      case 'category':
        return 'custom categories';
      case 'budget':
        return 'active budgets';
      case 'objective':
        return 'active objectives';
      case 'payment_method':
        return 'payment methods';
      default:
        return entityType;
    }
  }
}
