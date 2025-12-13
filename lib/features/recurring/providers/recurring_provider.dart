import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

part 'recurring_provider.g.dart';

/// Provider for the RecurringService instance
@riverpod
RecurringService recurringService(Ref ref) {
  final database = ref.watch(databaseProvider);
  return RecurringService(database: database);
}

/// Provider for all recurring configurations with their base transactions
@riverpod
Future<List<RecurringConfigWithTransaction>> allRecurringConfigs(Ref ref) async {
  final service = ref.watch(recurringServiceProvider);
  return await service.getAllRecurringWithTransactions();
}

/// Provider for active recurring configurations
@riverpod
Future<List<RecurringConfigWithTransaction>> activeRecurringConfigs(Ref ref) async {
  final service = ref.watch(recurringServiceProvider);
  return await service.getActiveRecurringWithTransactions();
}

/// Notifier for managing recurring transactions
@riverpod
class RecurringNotifier extends _$RecurringNotifier {
  @override
  Future<List<RecurringConfigWithTransaction>> build() async {
    final service = ref.watch(recurringServiceProvider);
    return await service.getActiveRecurringWithTransactions();
  }

  /// Process all due recurring transactions
  Future<int> processRecurring() async {
    final service = ref.read(recurringServiceProvider);
    final count = await service.processRecurringTransactions();

    // Refresh the list
    ref.invalidateSelf();

    return count;
  }

  /// Create a new recurring transaction
  Future<String> createRecurring({
    required String baseTransactionId,
    required String reoccurrence,
    int periodLength = 1,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    final service = ref.read(recurringServiceProvider);

    final id = await service.createRecurringConfig(
      baseTransactionId: baseTransactionId,
      reoccurrence: reoccurrence,
      periodLength: periodLength,
      startDate: startDate,
      endDate: endDate,
    );

    // Refresh the list
    ref.invalidateSelf();

    return id;
  }

  /// Stop a recurring transaction
  Future<void> stopRecurring(String configId) async {
    final service = ref.read(recurringServiceProvider);
    await service.stopRecurring(configId);

    // Refresh the list
    ref.invalidateSelf();
  }

  /// Update a recurring configuration
  Future<void> updateRecurring({
    required String configId,
    String? reoccurrence,
    int? periodLength,
    DateTime? endDate,
    bool? isActive,
  }) async {
    final service = ref.read(recurringServiceProvider);

    await service.updateRecurringConfig(
      configId: configId,
      reoccurrence: reoccurrence,
      periodLength: periodLength,
      endDate: endDate,
      isActive: isActive,
    );

    // Refresh the list
    ref.invalidateSelf();
  }

  /// Delete a recurring configuration
  Future<void> deleteRecurring(String configId) async {
    final service = ref.read(recurringServiceProvider);
    await service.deleteRecurringConfig(configId);

    // Refresh the list
    ref.invalidateSelf();
  }

  /// Get frequency display text
  String getFrequencyText(String reoccurrence, int periodLength) {
    final service = ref.read(recurringServiceProvider);
    return service.getFrequencyDisplayText(reoccurrence, periodLength);
  }
}

/// Provider for upcoming recurring transactions (next 30 days)
@riverpod
Future<List<UpcomingRecurring>> upcomingRecurringTransactions(Ref ref) async {
  final configs = await ref.watch(activeRecurringConfigsProvider.future);
  final upcoming = <UpcomingRecurring>[];
  final now = DateTime.now();
  final thirtyDaysFromNow = now.add(const Duration(days: 30));

  for (final config in configs) {
    if (config.nextOccurrence.isAfter(now) &&
        config.nextOccurrence.isBefore(thirtyDaysFromNow)) {
      upcoming.add(UpcomingRecurring(
        config: config,
        dueDate: config.nextOccurrence,
        daysUntilDue: config.nextOccurrence.difference(now).inDays,
      ));
    }
  }

  // Sort by due date
  upcoming.sort((a, b) => a.dueDate.compareTo(b.dueDate));

  return upcoming;
}

/// Model for upcoming recurring transaction display
class UpcomingRecurring {
  final RecurringConfigWithTransaction config;
  final DateTime dueDate;
  final int daysUntilDue;

  UpcomingRecurring({
    required this.config,
    required this.dueDate,
    required this.daysUntilDue,
  });

  String get dueDateDisplay {
    if (daysUntilDue == 0) return 'Today';
    if (daysUntilDue == 1) return 'Tomorrow';
    if (daysUntilDue < 7) return 'In $daysUntilDue days';
    if (daysUntilDue < 14) return 'Next week';
    return 'In ${(daysUntilDue / 7).ceil()} weeks';
  }
}
