import 'package:flutter/material.dart';
import 'package:the_accountant/core/providers/notification_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionService {
  final Ref _ref;

  SubscriptionService(this._ref);

  /// Check for upcoming subscriptions and send alerts
  Future<void> checkUpcomingSubscriptions() async {
    try {
      final subscriptionState = _ref.read(subscriptionProvider);
      final upcomingSubscriptions = subscriptionState.subscriptions.where((
        subscription,
      ) {
        // Check if subscription is active
        if (!subscription.isActive) return false;

        // Check if subscription has ended
        final now = DateTime.now();
        if (subscription.endDate != null &&
            subscription.endDate!.isBefore(now)) {
          return false;
        }

        // For monthly subscriptions, check if the due date is within the next 3 days
        if (subscription.recurrence == 'monthly') {
          final today = DateTime(now.year, now.month, now.day);
          final dueDate = DateTime(
            now.year,
            now.month,
            subscription.recurrenceDay,
          );

          // If the due date has passed this month, check next month
          if (dueDate.isBefore(today)) {
            dueDate.add(Duration(days: 30)); // Approximate next month
          }

          final difference = dueDate.difference(today).inDays;
          return difference >= 0 && difference <= 3;
        }

        return false;
      }).toList();

      // Send alerts for upcoming subscriptions
      for (final subscription in upcomingSubscriptions) {
        await _ref
            .read(notificationProvider.notifier)
            .showSubscriptionAlert(subscription.name);
      }
    } catch (e) {
      debugPrint('Failed to check upcoming subscriptions: $e');
    }
  }

  /// Schedule periodic checks for upcoming subscriptions
  void schedulePeriodicChecks() {
    // Check every hour
    Future.delayed(const Duration(hours: 1), () async {
      await checkUpcomingSubscriptions();
      schedulePeriodicChecks(); // Recursive call
    });
  }
}
