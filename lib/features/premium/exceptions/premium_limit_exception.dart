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
