import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for managing recurring transactions
/// Handles processing due transactions, calculating next occurrences,
/// and creating transaction instances
class RecurringService {
  final AppDatabase _database;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  RecurringService({required this._database});

  /// Guards against concurrent processing within the same isolate (e.g. the periodic
  /// foreground trigger firing while a resume-triggered run is still in flight). Static so
  /// it holds across separate RecurringService instances. Cross-isolate concurrency (a
  /// background worker isolate) is additionally bounded by the day-level dedup below.
  static bool _isProcessing = false;

  /// Process all due recurring transactions
  /// Creates transaction instances and updates next occurrence dates
  Future<int> processRecurringTransactions() async {
    if (_isProcessing) {
      _logger.d(
        'Recurring processing already in progress; skipping concurrent run',
      );
      return 0;
    }
    _isProcessing = true;
    try {
      return await _processRecurringTransactions();
    } finally {
      _isProcessing = false;
    }
  }

  /// Deterministic idempotency key for one occurrence.
  ///
  /// Derived purely from the config id and the *scheduled* UTC instant, so two
  /// devices that independently process the same due date produce byte-identical
  /// keys. A unique index on the column then collapses them locally and the
  /// backend's matching constraint rejects the duplicate on push, which is what
  /// makes offline generation on several devices safe.
  static String occurrenceKeyFor(
    String recurringConfigId,
    DateTime scheduledOccurrence,
  ) {
    final utc = scheduledOccurrence.toUtc();
    final day =
        '${utc.year.toString().padLeft(4, '0')}-'
        '${utc.month.toString().padLeft(2, '0')}-'
        '${utc.day.toString().padLeft(2, '0')}';
    return '$recurringConfigId@$day';
  }

  Future<int> _processRecurringTransactions() async {
    final now = DateTime.now();
    int processedCount = 0;

    // Get all active configs that are due
    final dueConfigs = await _database.getDueRecurringConfigs();
    _logger.d('Found ${dueConfigs.length} due recurring configs');

    for (final config in dueConfigs) {
      try {
        // Pre-load existing occurrence keys to avoid O(n²) queries in the loop.
        final existingInstances = await _database.getRecurringInstances(
          config.id,
        );
        final existingKeys = existingInstances
            .map((t) => t.occurrenceKey ?? occurrenceKeyFor(config.id, t.date))
            .toSet();

        // Keep creating instances until we're caught up
        DateTime nextOccurrence = config.nextOccurrence;

        while (nextOccurrence.isBefore(now) ||
            nextOccurrence.isAtSameMomentAs(now)) {
          final baseTransaction = await _database.findTransactionById(
            config.baseTransactionId,
          );
          if (baseTransaction == null) {
            _logger.w('Base transaction not found for config ${config.id}');
            break;
          }

          final scheduled = nextOccurrence;
          final following = calculateNextOccurrence(
            scheduled,
            config.reoccurrence,
            config.periodLength,
          );
          final endsHere =
              config.endDate != null && following.isAfter(config.endDate!);

          // Generating the instance, applying its balance effect, and advancing
          // the config cursor happen in ONE database transaction. Previously
          // these were three separate writes: an interruption between them
          // could leave a generated row whose balance was never applied, and
          // the day-level dedup would then refuse to ever repair it.
          final created = await _database.transaction(() async {
            final inserted = await _createTransactionInstance(
              baseTransaction,
              config,
              scheduled,
              existingKeys,
            );
            await _database.updateNextOccurrence(
              config.id,
              following,
              !endsHere,
            );
            return inserted;
          });

          if (created) processedCount++;
          nextOccurrence = following;

          if (endsHere) {
            _logger.i('Recurring config ${config.id} ended');
            break;
          }
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
  ///
  /// Returns whether a row was actually inserted; an occurrence that already
  /// exists (generated earlier, or pulled from another device) is skipped.
  /// [existingKeys] is a pre-loaded set of occurrence keys for this config,
  /// updated in place as new instances are created to avoid re-querying.
  Future<bool> _createTransactionInstance(
    Transaction baseTransaction,
    RecurringConfig config,
    DateTime date,
    Set<String> existingKeys,
  ) async {
    final occurrenceKey = occurrenceKeyFor(config.id, date);
    if (existingKeys.contains(occurrenceKey)) {
      _logger.d('Skipping duplicate recurring instance $occurrenceKey');
      return false;
    }

    final newId = _uuid.v4();
    final now = DateTime.now();

    final companion = TransactionsCompanion(
      id: Value(newId),
      amount: Value(baseTransaction.amount),
      title: Value(baseTransaction.title),
      notes: Value(baseTransaction.notes),
      date: Value(date),
      isIncome: Value(baseTransaction.isIncome),
      type: Value(baseTransaction.isIncome ? 'income' : 'expense'),
      transactionType: Value(TransactionPolicy.recurringInstanceType),
      categoryId: Value(baseTransaction.categoryId),
      walletId: Value(baseTransaction.walletId),
      paymentMethodId: Value(baseTransaction.paymentMethodId),
      recurringConfigId: Value(config.id),
      occurrenceKey: Value(occurrenceKey),
      specialType: Value(baseTransaction.specialType),
      isPaid: const Value(true),
      budgetId: Value(baseTransaction.budgetId),
      objectiveId: Value(baseTransaction.objectiveId),
      syncStatus: const Value(SyncStatus.pendingCreate),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    // insertOrIgnore + the unique index on occurrenceKey make this idempotent
    // even if two isolates race past the in-memory check.
    final rows = await _database
        .into(_database.transactions)
        .insert(companion, mode: InsertMode.insertOrIgnore);
    if (rows == 0) {
      _logger.d('Occurrence $occurrenceKey already present; nothing inserted');
      existingKeys.add(occurrenceKey);
      return false;
    }

    existingKeys.add(occurrenceKey);

    // Recompute the wallet from its transactions rather than nudging a delta,
    // so the balance is correct even if a previous run was interrupted.
    await WalletBalanceService(
      _database,
    ).updateWalletBalance(baseTransaction.walletId);

    _logger.d('Created recurring transaction instance: $newId');
    return true;
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

  /// Find the recurring config whose base transaction is [baseTransactionId].
  /// Base transactions link via recurring_configs.baseTransactionId (they do NOT
  /// carry a recurringConfigId), so this is the only way to reach a base
  /// transaction's config for editing.
  Future<RecurringConfig?> getRecurringConfigByBaseTransactionId(
    String baseTransactionId,
  ) async {
    final configs = await _database.getAllRecurringConfigs();
    for (final config in configs) {
      if (config.baseTransactionId == baseTransactionId) return config;
    }
    return null;
  }

  /// Sentinel meaning "leave the end date exactly as it is".
  ///
  /// A plain nullable parameter cannot distinguish "don't touch it" from "clear
  /// it", so clearing an end date silently did nothing. Callers now pass a date
  /// to set one, `null` to clear it, and omit the argument to keep it.
  static const Object keepEndDate = Object();

  /// Update a recurring configuration.
  ///
  /// [endDate] is tri-state: omit to keep, pass a [DateTime] to set, pass null
  /// to clear (i.e. "repeat forever").
  Future<void> updateRecurringConfig({
    required String configId,
    String? reoccurrence,
    int? periodLength,
    Object? endDate = keepEndDate,
    bool? isActive,
  }) async {
    // If the cadence changed, recompute nextOccurrence from the config's start date
    // so the processor generates the next instance on the new schedule.
    var nextOccurrence = const Value<DateTime>.absent();
    if (reoccurrence != null || periodLength != null) {
      final config = await _database.findRecurringConfigById(configId);
      if (config != null) {
        nextOccurrence = Value(
          calculateNextOccurrence(
            config.startDate,
            reoccurrence ?? config.reoccurrence,
            periodLength ?? config.periodLength,
          ),
        );
      }
    }

    final updates = RecurringConfigsCompanion(
      reoccurrence: reoccurrence != null
          ? Value(reoccurrence)
          : const Value.absent(),
      periodLength: periodLength != null
          ? Value(periodLength)
          : const Value.absent(),
      endDate: identical(endDate, keepEndDate)
          ? const Value.absent()
          : Value(endDate as DateTime?),
      isActive: isActive != null ? Value(isActive) : const Value.absent(),
      nextOccurrence: nextOccurrence,
      syncStatus: const Value(SyncStatus.pendingUpdate),
      updatedAt: Value(DateTime.now()),
    );

    await (_database.update(
      _database.recurringConfigs,
    )..where((r) => r.id.equals(configId))).write(updates);

    _logger.i('Updated recurring config: $configId');
  }

  /// Cancel a recurring configuration.
  ///
  /// This is a SYNCABLE cancellation, not a local hard delete. The row stays in
  /// the database, deactivated and flagged `pendingDelete`, so the next push
  /// tells the server about it (the backend represents deletion as
  /// `IsActive = false`). A hard delete produced no pending operation at all, so
  /// cancelling a subscription on one device left it running everywhere else and
  /// it could reappear on the next pull.
  ///
  /// The tombstone is retained until the server acknowledges it; the sync layer
  /// then clears the pending flag (see `SyncService._hardDeleteLocal`).
  Future<void> deleteRecurringConfig(String configId) async {
    await _database.transaction(() async {
      final config = await _database.findRecurringConfigById(configId);
      if (config == null) return;

      await (_database.update(_database.transactions)
            ..where((t) => t.id.equals(config.baseTransactionId)))
          .write(const TransactionsCompanion(isRecurring: Value(false)));

      await (_database.update(
        _database.recurringConfigs,
      )..where((r) => r.id.equals(configId))).write(
        RecurringConfigsCompanion(
          isActive: const Value(false),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
    _logger.i('Cancelled recurring config (tombstoned for sync): $configId');
  }

  /// Permanently remove a cancelled config's row.
  ///
  /// Only safe once the cancellation has been acknowledged by the server —
  /// otherwise the tombstone is lost and other devices keep generating.
  Future<void> purgeAcknowledgedCancellation(String configId) async {
    final config = await _database.findRecurringConfigById(configId);
    if (config == null) return;
    if (config.syncStatus != SyncStatus.synced || config.isActive) return;
    await _database.deleteRecurringConfig(configId);
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
