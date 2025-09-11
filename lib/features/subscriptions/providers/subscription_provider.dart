import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/models/subscription.dart';
import 'package:uuid/uuid.dart';

class SubscriptionState {
  final List<Subscription> subscriptions;
  final bool isLoading;
  final String? errorMessage;

  SubscriptionState({
    this.subscriptions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    List<Subscription>? subscriptions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SubscriptionState(
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(SubscriptionState());

  /// Add a new subscription
  Future<void> addSubscription({
    required String name,
    required double amount,
    required String currency,
    required String categoryId,
    required DateTime startDate,
    DateTime? endDate,
    required String recurrence,
    required int recurrenceDay,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final newSubscription = Subscription(
        id: const Uuid().v4(),
        name: name,
        amount: amount,
        currency: currency,
        categoryId: categoryId,
        startDate: startDate,
        endDate: endDate,
        recurrence: recurrence,
        recurrenceDay: recurrenceDay,
        isActive: true,
        notes: notes,
      );

      state = state.copyWith(
        subscriptions: [...state.subscriptions, newSubscription],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Update an existing subscription
  Future<void> updateSubscription(Subscription subscription) async {
    state = state.copyWith(isLoading: true);

    try {
      final updatedSubscriptions = state.subscriptions.map((s) {
        return s.id == subscription.id ? subscription : s;
      }).toList();

      state = state.copyWith(
        subscriptions: updatedSubscriptions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Delete a subscription
  Future<void> deleteSubscription(String subscriptionId) async {
    state = state.copyWith(isLoading: true);

    try {
      final updatedSubscriptions = state.subscriptions
          .where((subscription) => subscription.id != subscriptionId)
          .toList();

      state = state.copyWith(
        subscriptions: updatedSubscriptions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Toggle subscription active status
  Future<void> toggleSubscriptionActive(String subscriptionId) async {
    state = state.copyWith(isLoading: true);

    try {
      final updatedSubscriptions = state.subscriptions.map((subscription) {
        if (subscription.id == subscriptionId) {
          return subscription.copyWith(isActive: !subscription.isActive);
        }
        return subscription;
      }).toList();

      state = state.copyWith(
        subscriptions: updatedSubscriptions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Get upcoming subscriptions that need alerts
  List<Subscription> getUpcomingSubscriptions({int daysAhead = 3}) {
    final now = DateTime.now();
    final alertDate = now.add(Duration(days: daysAhead));

    return state.subscriptions.where((subscription) {
      // Check if subscription is active
      if (!subscription.isActive) return false;

      // Check if subscription has ended
      if (subscription.endDate != null && subscription.endDate!.isBefore(now)) {
        return false;
      }

      // Check if it's time for the next recurrence
      if (subscription.recurrence == 'monthly') {
        // For monthly subscriptions, check if the recurrence day is coming up
        return now.day <= subscription.recurrenceDay &&
            alertDate.day >= subscription.recurrenceDay;
      } else if (subscription.recurrence == 'yearly') {
        // For yearly subscriptions, check if the recurrence date is coming up
        final recurrenceDate = DateTime(
          now.year,
          subscription.recurrenceDay ~/ 100,
          subscription.recurrenceDay % 100,
        );
        return (recurrenceDate.isAfter(now) &&
                recurrenceDate.isBefore(alertDate)) ||
            (recurrenceDate.add(Duration(days: 1)).isAfter(now) &&
                recurrenceDate.add(Duration(days: 1)).isBefore(alertDate));
      }

      return false;
    }).toList();
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
      return SubscriptionNotifier();
    });
