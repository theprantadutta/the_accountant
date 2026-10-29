import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/settings/providers/notification_preferences_provider.dart';

/// Service for checking subscription expiry and showing local notifications.
/// Runs on app open/resume to warn users about expiring subscriptions.
class SubscriptionExpiryChecker {
  final WidgetRef? _ref;

  SubscriptionExpiryChecker([this._ref]);

  /// Check subscription expiry on app open.
  /// Shows a notification if subscription is expiring within 7 days.
  Future<void> checkOnAppOpen(WidgetRef ref) async {
    try {
      final premiumState = ref.read(premiumProvider);

      // Only check if user has premium
      if (!premiumState.isPremium) return;

      // The user can turn these off; the check used to ignore that.
      final notifications = ref.read(notificationPreferencesProvider.notifier);
      await notifications.ensureLoaded();
      if (!ref
          .read(notificationPreferencesProvider)
          .subscriptionExpiryAlertsEnabled) {
        return;
      }

      // Check if subscription is expiring soon (within 7 days)
      if (premiumState.isExpiringSoon) {
        final daysRemaining = premiumState.daysRemaining ?? 0;

        if (daysRemaining > 0 && daysRemaining <= 7) {
          // Once per stage; the notification service remembers.
          await NotificationService().showSubscriptionAlertNotification(
            daysRemaining,
          );

          debugPrint(
            'SubscriptionExpiryChecker: Subscription expiring in $daysRemaining days',
          );
        }
      }
    } catch (e) {
      debugPrint('SubscriptionExpiryChecker: Error checking expiry: $e');
    }
  }

  /// Check subscription expiry using stored ref (for use without WidgetRef)
  Future<void> check() async {
    final ref = _ref;
    if (ref != null) {
      await checkOnAppOpen(ref);
    }
  }
}

/// Provider for the subscription expiry checker
final subscriptionExpiryCheckerProvider = Provider<SubscriptionExpiryChecker>((
  ref,
) {
  return SubscriptionExpiryChecker();
});
