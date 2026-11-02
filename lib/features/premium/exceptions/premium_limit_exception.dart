import 'package:the_accountant/l10n/app_l10n.dart';
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
           message ?? appL10n.premiumFreeLimitMessage(limit, '${entityType}s');
  // Nothing raises this any more — see `FreeTierLimits`. Kept because it is
  // the shape a future limit would be reported in, and deleting it would take
  // the upgrade dialog with it.

  @override
  String toString() => message;

  /// Get the appropriate limit for an entity type.
  ///
  /// Nothing is capped any more — see [FreeTierLimits] — so this answers "no
  /// limit" for everything. Kept because the exception type is still the shape
  /// a future limit would be reported in.
  static int getLimitForEntity(String entityType) => noLimit;

  /// The answer when there is no cap.
  static const int noLimit = 999;

  /// Get a user-friendly entity name
  static String getEntityDisplayName(String entityType) {
    switch (entityType) {
      case 'wallet':
        return appL10n.premiumLimitWallets;
      case 'category':
        return appL10n.premiumLimitCategories;
      case 'budget':
        return appL10n.premiumLimitBudgets;
      case 'objective':
        return appL10n.premiumLimitObjectives;
      case 'payment_method':
        return appL10n.premiumLimitPaymentMethods;
      default:
        return entityType;
    }
  }
}
