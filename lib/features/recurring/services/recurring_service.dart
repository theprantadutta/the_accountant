import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for managing recurring transactions
/// Handles processing due transactions, calculating next occurrences,
/// and creating transaction instances
class RecurringService {
  final AppDatabase _database;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  RecurringService({required AppDatabase database}) : _database = database;

  /// Guards against concurrent processing within the same isolate (e.g. the periodic
  /// foreground trigger firing while a resume-triggered run is still in flight). Static so
  /// it holds across separate RecurringService instances. Cross-isolate concurrency (a
  /// background worker isolate) is additionally bounded by the day-level dedup below.
  static bool _isProcessing = false;

  /// Process all due recurring transactions
  /// Creates transaction instances and updates next occurrence dates
  Future<int> processRecurringTransactions() async {
    if (_isProcessing) {
      _logger.d('Recurring processing already in progress; skipping concurrent run');
      return 0;
    }
    _isProcessing = true;
    try {
      return await _processRecurringTransactions();
    } finally {
      _isProcessing = false;
    }
  }

  Future<int> _processRecurringTransactions() async {
    final now = DateTime.now();
    int processedCount = 0;

    // Get all active configs that are due
    final dueConfigs = await _database.getDueRecurringConfigs();
    _logger.d('Found ${dueConfigs.length} due recurring configs');

    for (final config in dueConfigs) {
      try {
        // Pre-load existing instance dates to avoid O(n²) queries in the loop
        final existingInstances = await _database.getRecurringInstances(config.id);
        final existingDates = existingInstances
            .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
            .toSet();

        // Keep creating instances until we're caught up
        DateTime nextOccurrence = config.nextOccurrence;

        while (nextOccurrence.isBefore(now) ||
            nextOccurrence.isAtSameMomentAs(now)) {
          // Get the base transaction
          final baseTransaction = await _database.findTransactionById(
            config.baseTransactionId,
          );
          if (baseTransaction == null) {
            _logger.w('Base transaction not found for config ${config.id}');
            break;
          }

          // Create a new transaction instance
          await _createTransactionInstance(
            baseTransaction,
            config,
            nextOccurrence,
            existingDates,
          );
          processedCount++;

          // Calculate next occurrence
          nextOccurrence = calculateNextOccurrence(
            nextOccurrence,
            config.reoccurrence,
            config.periodLength,
          );

          // Check if we've passed the end date
          if (config.endDate != null &&
              nextOccurrence.isAfter(config.endDate!)) {
            // Deactivate the recurring config
            await _database.updateNextOccurrence(
              config.id,
              nextOccurrence,
              false,
            );
            _logger.i('Recurring config ${config.id} ended');
            break;
          }

          // Update the config with new next occurrence
          await _database.updateNextOccurrence(config.id, nextOccurrence, true);
        }
      } catch (e, stack) {
        _logger.e(
          'Error processing recurring config ${config.id}: $e',
          error: e,
          stackTrace: stack,
        );
      }
    }

    _logger.i('Processed $processedCount recurring transactions');
    return processedCount;
  }

  /// Create a transaction instance from a recurring config.
  /// Skips creation if a matching instance already exists (deduplication).
  /// [existingDates] is a pre-loaded set of day-level dates for this config,
  /// updated in-place as new instances are created to avoid re-querying.
  Future<void> _createTransactionInstance(
    Transaction baseTransaction,
    RecurringConfig config,
    DateTime date,
    Set<DateTime> existingDates,
  ) async {
    // Deduplication: check against the pre-loaded set of existing dates
    final dateOnly = DateTime(date.year, date.month, date.day);
    final alreadyExists = existingDates.contains(dateOnly);
    if (alreadyExists) {
      _logger.d(
        'Skipping duplicate recurring instance for config ${config.id} on $dateOnly',
      );
      return;
    }

    final newId = _uuid.v4();

    final companion = TransactionsCompanion(
      id: Value(newId),
      amount: Value(baseTransaction.amount),
      title: Value(baseTransaction.title),
      notes: Value(baseTransaction.notes),
      date: Value(date),
      isIncome: Value(baseTransaction.isIncome),
      type: Value(baseTransaction.isIncome ? 'income' : 'expense'),
      transactionType: const Value('recurring_instance'),
      categoryId: Value(baseTransaction.categoryId),
      walletId: Value(baseTransaction.walletId),
      paymentMethodId: Value(baseTransaction.paymentMethodId),
      recurringConfigId: Value(config.id),
      specialType: Value(baseTransaction.specialType),
      isPaid: const Value(true),
      budgetId: Value(baseTransaction.budgetId),
      objectiveId: Value(baseTransaction.objectiveId),
      syncStatus: const Value(SyncStatus.pendingCreate),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.addTransaction(companion);

    // Track the new date to prevent duplicates within the same processing run
    existingDates.add(dateOnly);

    // Update wallet balance via service (consistent with all other paths)
    final balanceService = WalletBalanceService(_database);
    await balanceService.updateBalanceAfterTransaction(
      walletId: baseTransaction.walletId,
      amount: baseTransaction.amount,
      isIncome: baseTransaction.isIncome,
    );

    _logger.d('Created recurring transaction instance: $newId');
  }

  /// Calculate the next occurrence date based on recurrence pattern
  DateTime calculateNextOccurrence(
    DateTime current,
    String reoccurrence,
    int periodLength,
  ) {
    switch (reoccurrence.toLowerCase()) {
      case 'daily':
        return current.add(Duration(days: periodLength));

      case 'weekly':
        return current.add(Duration(days: 7 * periodLength));

      case 'monthly':
        return _addMonths(current, periodLength);

      case 'yearly':
        return DateTime(
          current.year + periodLength,
          current.month,
          current.day,
          current.hour,
          current.minute,
          current.second,
        );

      default:
        // Default to monthly if unknown
        return _addMonths(current, periodLength);
    }
  }

  /// Add months to a date, handling edge cases like end of month
  DateTime _addMonths(DateTime date, int months) {
    int year = date.year;
    int month = date.month + months;

    // Handle year overflow
    while (month > 12) {
      month -= 12;
      year++;
    }

    // Handle end of month edge case (e.g., Jan 31 + 1 month = Feb 28)
    int day = date.day;
    int daysInMonth = DateTime(year, month + 1, 0).day;
    if (day > daysInMonth) {
      day = daysInMonth;
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }

  /// Create a new recurring configuration
  Future<String> createRecurringConfig({
    required String baseTransactionId,
    required String reoccurrence,
    int periodLength = 1,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    final id = _uuid.v4();

    // Calculate initial next occurrence
    final nextOccurrence = calculateNextOccurrence(
      startDate,
      reoccurrence,
      periodLength,
    );

    final companion = RecurringConfigsCompanion(
      id: Value(id),
      baseTransactionId: Value(baseTransactionId),
      periodLength: Value(periodLength),
      reoccurrence: Value(reoccurrence),
      startDate: Value(startDate),
      endDate: Value(endDate),
      nextOccurrence: Value(nextOccurrence),
      isActive: const Value(true),
      syncStatus: const Value(SyncStatus.pendingCreate),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.addRecurringConfig(companion);

    // Mark the base transaction as recurring
    await (_database.update(
      _database.transactions,
    )..where((t) => t.id.equals(baseTransactionId))).write(
      const TransactionsCompanion(
        isRecurring: Value(true),
        transactionType: Value('regular'),
      ),
    );

    _logger.i('Created recurring config: $id');
    return id;
  }

  /// Stop a recurring configuration
  Future<void> stopRecurring(String configId) async {
    await (_database.update(
      _database.recurringConfigs,
    )..where((r) => r.id.equals(configId))).write(
      RecurringConfigsCompanion(
        isActive: const Value(false),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );

    _logger.i('Stopped recurring config: $configId');
  }

  /// Get all recurring configs with their base transaction info
  Future<List<RecurringConfigWithTransaction>>
  getAllRecurringWithTransactions() async {
    final configs = await _database.getAllRecurringConfigs();
    final result = <RecurringConfigWithTransaction>[];

    for (final config in configs) {
      final baseTransaction = await _database.findTransactionById(
        config.baseTransactionId,
      );
      if (baseTransaction != null) {
        result.add(
          RecurringConfigWithTransaction(
            config: config,
            baseTransaction: baseTransaction,
          ),
        );
      }
    }

    return result;
  }

  /// Get active recurring configs
  Future<List<RecurringConfigWithTransaction>>
  getActiveRecurringWithTransactions() async {
    final configs = await _database.getActiveRecurringConfigs();
    final result = <RecurringConfigWithTransaction>[];

    for (final config in configs) {
      final baseTransaction = await _database.findTransactionById(
        config.baseTransactionId,
      );
      if (baseTransaction != null) {
        result.add(
          RecurringConfigWithTransaction(
            config: config,
            baseTransaction: baseTransaction,
          ),
        );
      }
    }

    return result;
  }

  /// Get all transaction instances for a recurring config
  Future<List<Transaction>> getRecurringInstances(String configId) async {
    return await _database.getRecurringInstances(configId);
  }

  /// Update a recurring configuration
  Future<void> updateRecurringConfig({
    required String configId,
    String? reoccurrence,
    int? periodLength,
    DateTime? endDate,
    bool? isActive,
  }) async {
    final updates = RecurringConfigsCompanion(
      reoccurrence: reoccurrence != null
          ? Value(reoccurrence)
          : const Value.absent(),
      periodLength: periodLength != null
          ? Value(periodLength)
          : const Value.absent(),
      endDate: endDate != null ? Value(endDate) : const Value.absent(),
      isActive: isActive != null ? Value(isActive) : const Value.absent(),
      syncStatus: const Value(SyncStatus.pendingUpdate),
      updatedAt: Value(DateTime.now()),
    );

    await (_database.update(
      _database.recurringConfigs,
    )..where((r) => r.id.equals(configId))).write(updates);

    _logger.i('Updated recurring config: $configId');
  }

  /// Delete a recurring configuration
  Future<void> deleteRecurringConfig(String configId) async {
    // First unmark the base transaction
    final config = await _database.findRecurringConfigById(configId);
    if (config != null) {
      await (_database.update(_database.transactions)
            ..where((t) => t.id.equals(config.baseTransactionId)))
          .write(const TransactionsCompanion(isRecurring: Value(false)));
    }

    // Delete the config
    await _database.deleteRecurringConfig(configId);
    _logger.i('Deleted recurring config: $configId');
  }

  /// Get recurring frequency display text
  String getFrequencyDisplayText(String reoccurrence, int periodLength) {
    if (periodLength == 1) {
      switch (reoccurrence.toLowerCase()) {
        case 'daily':
          return 'Daily';
        case 'weekly':
          return 'Weekly';
        case 'monthly':
          return 'Monthly';
        case 'yearly':
          return 'Yearly';
        default:
          return reoccurrence;
      }
    }

    switch (reoccurrence.toLowerCase()) {
      case 'daily':
        return 'Every $periodLength days';
      case 'weekly':
        return 'Every $periodLength weeks';
      case 'monthly':
        return 'Every $periodLength months';
      case 'yearly':
        return 'Every $periodLength years';
      default:
        return 'Every $periodLength $reoccurrence';
    }
  }
}

/// Helper class combining recurring config with its base transaction
class RecurringConfigWithTransaction {
  final RecurringConfig config;
  final Transaction baseTransaction;

  RecurringConfigWithTransaction({
    required this.config,
    required this.baseTransaction,
  });

  String get displayTitle => baseTransaction.title.isNotEmpty
      ? baseTransaction.title
      : 'Recurring Transaction';

  int get amount => baseTransaction.amount; // integer minor units / cents
  bool get isIncome => baseTransaction.isIncome;
  bool get isActive => config.isActive;
  DateTime get nextOccurrence => config.nextOccurrence;
  String get frequency => config.reoccurrence;
  int get periodLength => config.periodLength;
}
