import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

/// Aggregated subscription data for the dashboard
class SubscriptionDashboardState {
  final List<SubscriptionItem> subscriptions;
  final bool isLoading;
  final String? error;

  const SubscriptionDashboardState({
    this.subscriptions = const [],
    this.isLoading = false,
    this.error,
  });

  SubscriptionDashboardState copyWith({
    List<SubscriptionItem>? subscriptions,
    bool? isLoading,
    String? error,
  }) {
    return SubscriptionDashboardState(
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Active subscriptions
  List<SubscriptionItem> get activeSubscriptions =>
      subscriptions.where((s) => s.isActive).toList();

  /// Paused subscriptions
  List<SubscriptionItem> get pausedSubscriptions =>
      subscriptions.where((s) => !s.isActive).toList();

  /// Total monthly cost (normalizes all subscriptions to monthly)
  double get totalMonthlyCost {
    return activeSubscriptions.fold(0.0, (sum, s) => sum + s.monthlyCost);
  }

  /// Total yearly cost
  double get totalYearlyCost => totalMonthlyCost * 12;

  /// Active subscription count
  int get activeCount => activeSubscriptions.length;
}

/// Represents a single subscription with normalized cost data
class SubscriptionItem {
  final RecurringConfig config;
  final Transaction baseTransaction;

  SubscriptionItem({required this.config, required this.baseTransaction});

  String get id => config.id;
  TransactionSpecialType get specialType =>
      baseTransaction.specialType ?? TransactionSpecialType.subscription;
  String get name => baseTransaction.title.isNotEmpty
      ? baseTransaction.title
      : (specialType == TransactionSpecialType.repetitive
            ? 'Recurring Bill'
            : 'Subscription');
  int get amount => baseTransaction.amount; // integer minor units / cents
  bool get isActive => config.isActive;
  bool get isIncome => baseTransaction.isIncome;
  String get frequency => config.reoccurrence;
  int get periodLength => config.periodLength;
  DateTime get nextPayment => config.nextOccurrence;
  String get walletId => baseTransaction.walletId;
  String? get categoryId => baseTransaction.categoryId;

  /// Monthly cost normalized from the subscription's frequency
  double get monthlyCost {
    if (isIncome) return 0.0; // Don't count income subscriptions
    switch (frequency.toLowerCase()) {
      case 'daily':
        return amount * 30 / periodLength;
      case 'weekly':
        return amount * 4.33 / periodLength;
      case 'monthly':
        return amount / periodLength;
      case 'yearly':
        return amount / (12 * periodLength);
      default:
        return amount.toDouble();
    }
  }

  /// Human-readable frequency text
  String get frequencyText {
    if (periodLength == 1) {
      switch (frequency.toLowerCase()) {
        case 'daily':
          return 'Daily';
        case 'weekly':
          return 'Weekly';
        case 'monthly':
          return 'Monthly';
        case 'yearly':
          return 'Yearly';
        default:
          return frequency;
      }
    }
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 'Every $periodLength days';
      case 'weekly':
        return 'Every $periodLength weeks';
      case 'monthly':
        return 'Every $periodLength months';
      case 'yearly':
        return 'Every $periodLength years';
      default:
        return 'Every $periodLength $frequency';
    }
  }

  /// Formatted amount with frequency suffix
  String get amountDisplay {
    final suffix = periodLength == 1
        ? _shortFrequency(frequency)
        : '/$periodLength${_shortFrequency(frequency)}';
    return '\$${(amount / 100).toStringAsFixed(2)}$suffix';
  }

  static String _shortFrequency(String freq) {
    switch (freq.toLowerCase()) {
      case 'daily':
        return '/day';
      case 'weekly':
        return '/week';
      case 'monthly':
        return '/mo';
      case 'yearly':
        return '/yr';
      default:
        return '';
    }
  }
}

class SubscriptionDashboardNotifier
    extends StateNotifier<SubscriptionDashboardState> {
  final RecurringService _recurringService;

  SubscriptionDashboardNotifier(AppDatabase db)
    : _recurringService = RecurringService(database: db),
      super(const SubscriptionDashboardState()) {
    loadSubscriptions();
  }

  /// Load all subscription recurring configs
  Future<void> loadSubscriptions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get all recurring configs with their base transactions
      final allConfigs = await _recurringService
          .getAllRecurringWithTransactions();

      // Filter to subscription and repetitive type transactions
      final subscriptionConfigs = allConfigs.where((item) {
        return item.baseTransaction.specialType ==
                TransactionSpecialType.subscription ||
            item.baseTransaction.specialType ==
                TransactionSpecialType.repetitive;
      }).toList();

      final items = subscriptionConfigs
          .map(
            (item) => SubscriptionItem(
              config: item.config,
              baseTransaction: item.baseTransaction,
            ),
          )
          .toList();

      // Sort: active first, then by next payment date
      items.sort((a, b) {
        if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
        return a.nextPayment.compareTo(b.nextPayment);
      });

      state = state.copyWith(subscriptions: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load subscriptions: ${e.toString()}',
      );
    }
  }

  /// Pause a subscription (set isActive = false)
  Future<void> pauseSubscription(String configId) async {
    try {
      await _recurringService.updateRecurringConfig(
        configId: configId,
        isActive: false,
      );
      await loadSubscriptions();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to pause subscription: ${e.toString()}',
      );
    }
  }

  /// Resume a subscription (set isActive = true)
  Future<void> resumeSubscription(String configId) async {
    try {
      await _recurringService.updateRecurringConfig(
        configId: configId,
        isActive: true,
      );
      await loadSubscriptions();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to resume subscription: ${e.toString()}',
      );
    }
  }

  /// Update subscription recurring config properties
  Future<void> updateSubscriptionConfig({
    required String configId,
    String? reoccurrence,
    int? periodLength,
    DateTime? endDate,
  }) async {
    try {
      await _recurringService.updateRecurringConfig(
        configId: configId,
        reoccurrence: reoccurrence,
        periodLength: periodLength,
        endDate: endDate,
      );
      await loadSubscriptions();
    } catch (e) {
      state = state.copyWith(error: 'Failed to update subscription: $e');
    }
  }

  /// Cancel (delete) a subscription
  Future<void> cancelSubscription(String configId) async {
    try {
      await _recurringService.deleteRecurringConfig(configId);
      await loadSubscriptions();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to cancel subscription: ${e.toString()}',
      );
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadSubscriptions();
  }
}

/// Provider for subscription dashboard
final subscriptionDashboardProvider =
    StateNotifierProvider<
      SubscriptionDashboardNotifier,
      SubscriptionDashboardState
    >((ref) {
      final db = ref.watch(databaseProvider);
      return SubscriptionDashboardNotifier(db);
    });
