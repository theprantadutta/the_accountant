import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase, TransactionsCompanion, SyncStatus;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/core/services/reminder_scheduler_service.dart';
import 'package:the_accountant/features/ai/services/category_assignment_service.dart';
import 'package:the_accountant/features/settings/providers/notification_preferences_provider.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/reports/providers/reports_provider.dart';
import 'package:uuid/uuid.dart';

/// Sentinel for tri-state optional args in [TransactionNotifier.updateTransaction]:
/// pass a value to SET, pass null to CLEAR, or omit to KEEP the existing value.
const Object _unchanged = Object();

/// ViewModel class for displaying transactions in UI
/// Uses isIncome boolean instead of deprecated type string
class TransactionViewModel {
  final String id;
  final int amount; // integer minor units / cents
  final bool isIncome;
  final String title;
  final String category;
  final String categoryId;
  final String walletId;
  final DateTime date;
  final String notes;
  final String? paymentMethodId;

  TransactionViewModel({
    required this.id,
    required this.amount,
    required this.isIncome,
    required this.title,
    required this.category,
    required this.categoryId,
    required this.walletId,
    required this.date,
    required this.notes,
    this.paymentMethodId,
  });

  /// Helper to get display type string for UI
  String get displayType => isIncome ? 'income' : 'expense';
}

/// @deprecated - Use TransactionViewModel instead
/// Kept for backward compatibility with existing code
class Transaction {
  final String id;
  final int amount; // integer minor units / cents
  final String type;
  final String category;
  final String categoryId;
  final String walletId;
  final DateTime date;
  final String title;
  final String notes;
  final String paymentMethod;
  final bool isRecurring;
  final String? recurrencePattern;

  /// How the row came to exist: a plain entry, one leg of a transfer, or a
  /// generated recurrence occurrence.
  ///
  /// [type] only ever says "income" or "expense", because it is derived from
  /// the direction the money moved. That is not enough to tell a purchase from
  /// the outgoing half of a transfer between your own wallets, and screens that
  /// could not tell were counting internal movements as spending. Carry the
  /// real kind so callers can ask [TransactionPolicy] instead of guessing.
  final String transactionType;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.categoryId,
    required this.walletId,
    required this.date,
    required this.title,
    required this.notes,
    required this.paymentMethod,
    this.isRecurring = false,
    this.recurrencePattern,
    this.transactionType = 'regular',
  });

  /// Whether this row is one leg of a wallet-to-wallet transfer.
  bool get isTransferLeg => transactionType == TransactionPolicy.transferType;

  /// Convert to new TransactionViewModel
  TransactionViewModel toViewModel() => TransactionViewModel(
    id: id,
    amount: amount,
    isIncome: type == 'income',
    title: title,
    category: category,
    categoryId: categoryId,
    walletId: walletId,
    date: date,
    notes: notes,
    paymentMethodId: null,
  );
}

class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? errorMessage;

  TransactionState({
    required this.transactions,
    required this.isLoading,
    this.errorMessage,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final AppDatabase _db;
  final WalletBalanceService _walletBalanceService;
  final Ref _ref;
  final CategoryAssignmentService _categoryAssignmentService;

  TransactionNotifier(this._db, this._ref, SettingsState settings)
    : _walletBalanceService = WalletBalanceService(_db),
      _categoryAssignmentService = CategoryAssignmentService(),
      super(TransactionState(transactions: [], isLoading: false)) {
    loadTransactions();
  }

  Future<void> loadTransactions({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);
    try {
      // Use JOIN query to get transactions with category names
      final dbResults = await _db.getAllTransactionsWithCategoryName();
      final transactions = dbResults.map((result) {
        final t = result['transaction'] as db.Transaction;
        final categoryName = result['categoryName'] as String;
        return Transaction(
          id: t.id,
          amount: t.amount,
          // Use isIncome to determine type (new approach)
          type: t.isIncome ? 'income' : 'expense',
          category: categoryName, // Now resolved from JOIN query
          categoryId: t.categoryId ?? '',
          walletId: t.walletId,
          date: t.date,
          title: t.title,
          notes: t.notes ?? '',
          paymentMethod: t.paymentMethodId ?? '',
          isRecurring: false, // Deprecated - use RecurringConfigs
          recurrencePattern: null, // Deprecated - use RecurringConfigs
          transactionType: t.transactionType,
        );
      }).toList();

      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      if (mounted) {
        if (!silent) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load transactions: $e',
          );
        }
      }
    }
  }

  /// Add a new transaction
  /// [isIncome] - true for income, false for expense
  /// [type] - @deprecated, use isIncome instead. Kept for backward compatibility.
  Future<void> addTransaction({
    required int amount, // integer minor units / cents
    String? type, // @deprecated - use isIncome instead
    bool? isIncome, // New: use this instead of type
    required String category,
    required String categoryId,
    required String walletId,
    required DateTime date,
    required String notes,
    String? title,
    String? paymentMethodId,
    String? paymentMethod, // @deprecated - use paymentMethodId
    bool isRecurring = false, // @deprecated - use RecurringConfigs
    String? recurrencePattern, // @deprecated - use RecurringConfigs
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Determine isIncome: prefer explicit isIncome, fallback to type parsing
      final bool transactionIsIncome = isIncome ?? (type == 'income');

      // Use AI to automatically assign category if none is provided or if it's the default "Other"
      String finalCategoryId = categoryId;

      // Only use AI assignment if we have notes and the category is "Other" or empty
      if (notes.isNotEmpty && (category.isEmpty || category == 'Other')) {
        final suggestedCategory = _categoryAssignmentService.assignCategory(
          notes,
        );
        if (suggestedCategory != 'Other') {
          finalCategoryId = suggestedCategory; // Using name as ID for demo
        }
      }

      final now = DateTime.now();
      final newTransaction = TransactionsCompanion(
        id: Value(const Uuid().v4()),
        amount: Value(amount),
        isIncome: Value(transactionIsIncome), // Use isIncome field
        title: Value(title ?? ''),
        categoryId: Value(finalCategoryId),
        walletId: Value(walletId),
        date: Value(date),
        notes: Value(notes),
        paymentMethodId: Value(paymentMethodId ?? paymentMethod),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _db.addTransaction(newTransaction);

      // Keep the wallet balance in step with the insert. This path used to skip
      // the balance entirely — unlike [addTransactionFull] — so anything routed
      // through it left the wallet under- or over-stated until the next full
      // recalculation.
      await _walletBalanceService.updateWalletBalance(walletId);
      await _ref.read(walletProvider.notifier).loadWallets();

      // Reload transactions to get the new one
      await loadTransactions();

      // Refresh dashboard and reports data for real-time updates
      _ref.read(financialDataProvider.notifier).refreshData();
      _ref.read(reportsProvider.notifier).loadReportsData();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add transaction',
      );
    }
  }

  /// Add a new transaction with full Cashew-style options.
  /// This method supports all new fields including special types,
  /// budget/objective assignment, and proper date+time handling.
  Future<String?> addTransactionFull({
    required int amount, // integer minor units / cents
    required bool isIncome,
    required String categoryId,
    required String walletId,
    required DateTime dateTime, // Includes both date AND time
    String? title,
    String? notes,
    String? paymentMethodId,
    TransactionSpecialType specialType = TransactionSpecialType.none,
    bool isPaid = true,
    DateTime? originalDueDate,
    String? budgetId,
    String? objectiveId,
    String? recurringConfigId,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      // Determine paid status based on special type
      final effectiveIsPaid =
          specialType == TransactionSpecialType.none ||
              specialType == TransactionSpecialType.repetitive ||
              specialType == TransactionSpecialType.subscription
          ? true // Regular, repetitive, and subscription are always paid
          : isPaid; // Others (upcoming, credit, debt) can be unpaid

      final newTransaction = TransactionsCompanion(
        id: Value(id),
        amount: Value(amount),
        isIncome: Value(isIncome),
        title: Value(title ?? ''),
        notes: Value(notes),
        date: Value(dateTime), // Preserves full date+time
        categoryId: Value(categoryId),
        walletId: Value(walletId),
        paymentMethodId: Value(paymentMethodId),
        transactionType: Value('regular'),
        specialType: Value(specialType),
        isPaid: Value(effectiveIsPaid),
        originalDueDate: Value(originalDueDate),
        budgetId: Value(budgetId),
        objectiveId: Value(objectiveId),
        recurringConfigId: Value(recurringConfigId),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _db.addTransaction(newTransaction);

      // Credit/debt always affect balance (money has already moved)
      // Upcoming only affects balance when paid
      final shouldUpdateBalance =
          specialType == TransactionSpecialType.credit ||
          specialType == TransactionSpecialType.debt ||
          effectiveIsPaid;

      if (shouldUpdateBalance) {
        await _walletBalanceService.updateBalanceAfterTransaction(
          walletId: walletId,
          amount: amount,
          isIncome: isIncome,
        );

        // Refresh wallet provider to reflect new balance (await to ensure state is updated)
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      // Reload transactions to get the new one
      await loadTransactions();

      AnalyticsService().logTransactionCreate();

      // Refresh dashboard and reports data for real-time updates
      _ref.read(financialDataProvider.notifier).refreshData();
      _ref.read(reportsProvider.notifier).loadReportsData();

      // Schedule a due-date reminder for applicable special types.
      // Subscription and repetitive types are excluded — their recurring config
      // handles future notifications via the periodic background task.
      if (specialType == TransactionSpecialType.upcoming ||
          specialType == TransactionSpecialType.credit ||
          specialType == TransactionSpecialType.debt) {
        final reminderType = switch (specialType) {
          TransactionSpecialType.credit => 'credit',
          TransactionSpecialType.debt => 'debt',
          _ => 'upcoming',
        };
        try {
          await ReminderSchedulerService().scheduleReminder(
            transactionId: id,
            title: title ?? '',
            amount:
                amount / 100.0, // reminder service works in major-unit dollars
            type: reminderType,
            dueDate: originalDueDate ?? dateTime,
          );
        } catch (_) {
          // Non-critical — don't fail the transaction
        }
      }

      // Check for large transaction alert
      try {
        final notifPrefs = _ref.read(notificationPreferencesProvider);
        // Threshold is a user preference expressed in major-unit dollars.
        if (notifPrefs.largeTransactionAlertsEnabled &&
            amount / 100.0 >= notifPrefs.largeTransactionThreshold) {
          await NotificationService().showLargeTransactionNotification(
            amount / 100.0,
            title ?? '',
            isIncome,
          );
        }
      } catch (_) {
        // Non-critical — don't fail the transaction
      }

      return id; // Return the new transaction ID
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add transaction: $e',
      );
      return null;
    }
  }

  /// Update an existing transaction
  /// [isIncome] - true for income, false for expense
  /// [type] - @deprecated, use isIncome instead. Kept for backward compatibility.
  Future<void> updateTransaction({
    required String id,
    int? amount, // integer minor units / cents
    String? type, // @deprecated - use isIncome instead
    bool? isIncome, // New: use this instead of type
    String? title,
    String? categoryId,
    String? walletId,
    DateTime? date,
    String? notes,
    Object? paymentMethodId =
        _unchanged, // set (String) / clear (null) / keep (omit)
    String? paymentMethod, // @deprecated - use paymentMethodId
    TransactionSpecialType? specialType, // null = keep existing
    bool? isPaid, // null = keep existing
    DateTime? originalDueDate, // null = keep existing
    Object? budgetId = _unchanged, // set / clear / keep
    Object? objectiveId = _unchanged, // set / clear / keep
    bool? isRecurring, // @deprecated
    String? recurrencePattern, // @deprecated
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findTransactionById(id);
      if (existing == null) {
        throw Exception('Transaction not found');
      }

      // Transfers must go through the paired update so both legs stay
      // reciprocal, equal, and opposite. Editing one row here would desync the
      // pair; delegate instead of silently corrupting it.
      if (TransactionPolicy.isTransfer(existing)) {
        await updateTransfer(
          id: id,
          amount: amount,
          title: title,
          walletId: walletId,
          date: date,
          notes: notes,
        );
        return;
      }

      // Determine isIncome: prefer explicit isIncome, then type, then existing
      bool? transactionIsIncome;
      if (isIncome != null) {
        transactionIsIncome = isIncome;
      } else if (type != null) {
        transactionIsIncome = type == 'income';
      }

      // Resolve the editable special/assignment fields. The sentinel default lets a
      // caller SET (value), CLEAR (null), or KEEP (omit) each nullable assignment
      // field; specialType/isPaid/originalDueDate use null to mean "keep".
      final newSpecialType =
          specialType ?? existing.specialType ?? TransactionSpecialType.none;
      // Regular/subscription/repetitive are always paid; only upcoming/credit/debt
      // can be unpaid (mirrors addTransactionFull).
      final effectiveIsPaid =
          newSpecialType == TransactionSpecialType.none ||
              newSpecialType == TransactionSpecialType.repetitive ||
              newSpecialType == TransactionSpecialType.subscription
          ? true
          : (isPaid ?? existing.isPaid);
      final newOriginalDueDate = originalDueDate ?? existing.originalDueDate;
      final resolvedBudgetId = identical(budgetId, _unchanged)
          ? existing.budgetId
          : budgetId as String?;
      final resolvedObjectiveId = identical(objectiveId, _unchanged)
          ? existing.objectiveId
          : objectiveId as String?;
      final resolvedPaymentMethodId = identical(paymentMethodId, _unchanged)
          ? (paymentMethod ?? existing.paymentMethodId)
          : paymentMethodId as String?;

      // Preserve remaining fields from the existing transaction (replace() needs all
      // columns); only the fields above are editable here.
      final updatedTransaction = TransactionsCompanion(
        id: Value(id),
        amount: Value(amount ?? existing.amount),
        isIncome: Value(transactionIsIncome ?? existing.isIncome),
        title: Value(title ?? existing.title),
        categoryId: Value(categoryId ?? existing.categoryId),
        walletId: Value(walletId ?? existing.walletId),
        date: Value(date ?? existing.date),
        notes: Value(notes ?? existing.notes),
        paymentMethodId: Value(resolvedPaymentMethodId),
        transactionType: Value(existing.transactionType),
        specialType: Value(newSpecialType),
        isPaid: Value(effectiveIsPaid),
        originalDueDate: Value(newOriginalDueDate),
        skipPaid: Value(existing.skipPaid),
        budgetId: Value(resolvedBudgetId),
        objectiveId: Value(resolvedObjectiveId),
        recurringConfigId: Value(existing.recurringConfigId),
        pairedTransactionId: Value(existing.pairedTransactionId),
        receiptImageUrl: Value(existing.receiptImageUrl),
        serverId: Value(existing.serverId),
        syncStatus: Value(SyncStatus.pendingUpdate),
        deletedAt: Value(existing.deletedAt),
        createdAt: Value(existing.createdAt),
        updatedAt: Value(DateTime.now()),
      );

      await _db.updateTransaction(updatedTransaction);

      // Recompute the affected wallet balance(s) from scratch. This is idempotent and
      // stays correct no matter which flags changed (amount, wallet, isIncome, paid
      // status, or special type) — unlike an incremental reverse/apply, which silently
      // breaks the moment isPaid/specialType change on edit.
      final oldWalletId = existing.walletId;
      final newWalletId = walletId ?? existing.walletId;
      await _walletBalanceService.updateWalletBalance(oldWalletId);
      if (newWalletId != oldWalletId) {
        await _walletBalanceService.updateWalletBalance(newWalletId);
      }

      // Refresh wallet provider to reflect new balance
      await _ref.read(walletProvider.notifier).loadWallets();

      // Reschedule (or cancel) the due-date reminder based on the new state. Always
      // cancel first so a change to a non-reminder type (e.g. -> none) clears it.
      try {
        await ReminderSchedulerService().cancelReminder(id);
        if (newSpecialType == TransactionSpecialType.upcoming ||
            newSpecialType == TransactionSpecialType.credit ||
            newSpecialType == TransactionSpecialType.debt) {
          final reminderType = switch (newSpecialType) {
            TransactionSpecialType.credit => 'credit',
            TransactionSpecialType.debt => 'debt',
            _ => 'upcoming',
          };
          await ReminderSchedulerService().scheduleReminder(
            transactionId: id,
            title: title ?? existing.title,
            amount: (amount ?? existing.amount) / 100.0,
            type: reminderType,
            dueDate: newOriginalDueDate ?? (date ?? existing.date),
          );
        }
      } catch (_) {
        // Non-critical — don't fail the update
      }

      // Reload transactions to get the updated one
      await loadTransactions();

      AnalyticsService().logTransactionUpdate();

      // Refresh dashboard and reports data for real-time updates
      _ref.read(financialDataProvider.notifier).refreshData();
      _ref.read(reportsProvider.notifier).loadReportsData();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update transaction',
      );
    }
  }

  /// Update a transfer through the paired operation.
  ///
  /// [walletId] refers to the wallet of the leg identified by [id]; it is mapped
  /// onto the source or destination side depending on which leg that is, so a
  /// caller holding a single row (a list item, the editor) never has to know
  /// about the pair's internal structure. [sourceWalletId] /
  /// [destinationWalletId] let a transfer-aware caller set both sides directly.
  Future<void> updateTransfer({
    required String id,
    int? amount,
    String? title,
    String? walletId,
    DateTime? date,
    String? notes,
    String? sourceWalletId,
    String? destinationWalletId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final existing = await _db.findTransactionById(id);
      if (existing == null) {
        throw Exception('Transaction not found');
      }
      if (!TransactionPolicy.isTransfer(existing)) {
        throw Exception('Transaction $id is not a transfer');
      }

      // `walletId` describes THIS leg: an incoming leg is the destination, an
      // outgoing leg is the source.
      final resolvedSource =
          sourceWalletId ?? (existing.isIncome ? null : walletId);
      final resolvedDestination =
          destinationWalletId ?? (existing.isIncome ? walletId : null);

      await TransferService(_db).updateTransfer(
        transactionId: id,
        amount: amount,
        date: date,
        notes: notes,
        title: title,
        sourceWalletId: resolvedSource,
        destinationWalletId: resolvedDestination,
      );

      await _ref.read(walletProvider.notifier).loadWallets();
      await loadTransactions();
      AnalyticsService().logTransactionUpdate();
      _ref.read(financialDataProvider.notifier).refreshData();
      _ref.read(reportsProvider.notifier).loadReportsData();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update transfer: $e',
      );
    }
  }

  Future<void> deleteTransaction(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      // Cancel any scheduled reminder for this transaction
      try {
        await ReminderSchedulerService().cancelReminder(id);
      } catch (_) {}

      final transaction = await _db.findTransactionById(id);

      // A transfer is one domain object stored as two rows. Deleting a single
      // row here would leave an orphan leg and a wrong balance on the partner's
      // wallet, so every generic delete route delegates to the paired
      // operation, which tombstones both legs and recomputes both wallets in
      // one database transaction.
      if (transaction != null && TransactionPolicy.isTransfer(transaction)) {
        await TransferService(_db).deleteTransfer(id);
        await _ref.read(walletProvider.notifier).loadWallets();
        AnalyticsService().logTransactionDelete();
        await loadTransactions();
        _ref.read(financialDataProvider.notifier).refreshData();
        _ref.read(reportsProvider.notifier).loadReportsData();
        return;
      }

      // Soft-delete (sets deletedAt + pendingDelete) so the deletion is pushed to the
      // server on the next sync. A hard delete would never propagate and the row could
      // resurrect on a full pull.
      await _db.softDeleteTransaction(id);

      // Recompute the wallet from its surviving transactions rather than
      // reversing a hand-rolled delta. The old code only reversed when
      // `isPaid` was true, which silently skipped credit/debt rows that are
      // realized while unpaid — deleting one of those left the wallet balance
      // permanently wrong. Recomputation uses the same TransactionPolicy
      // predicate that creation used, so create and delete can never disagree.
      if (transaction != null) {
        await _walletBalanceService.updateWalletBalance(transaction.walletId);
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      AnalyticsService().logTransactionDelete();

      // Reload transactions to reflect the deletion
      await loadTransactions();

      // Refresh dashboard and reports data for real-time updates
      _ref.read(financialDataProvider.notifier).refreshData();
      _ref.read(reportsProvider.notifier).loadReportsData();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete transaction',
      );
    }
  }

  /// Get the database transaction by ID (for editing)
  Future<db.Transaction?> getDatabaseTransactionById(String id) async {
    return _db.getTransactionById(id);
  }

  List<Transaction> getTransactionsByType(String type) {
    return state.transactions.where((t) => t.type == type).toList();
  }

  List<Transaction> getTransactionsByCategory(String categoryId) {
    return state.transactions.where((t) => t.categoryId == categoryId).toList();
  }

  List<Transaction> getTransactionsByWallet(String walletId) {
    return state.transactions.where((t) => t.walletId == walletId).toList();
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return state.transactions
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  int getTotalAmountByType(String type) {
    return state.transactions
        .where((t) => t.type == type)
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  int getWalletBalance(String walletId) {
    return state.transactions.where((t) => t.walletId == walletId).fold<int>(
      0,
      (sum, t) {
        if (t.type == 'income') {
          return sum + t.amount;
        } else {
          return sum - t.amount;
        }
      },
    );
  }

  Map<String, int> getAllWalletBalances() {
    final Map<String, int> balances = {};

    for (var transaction in state.transactions) {
      if (!balances.containsKey(transaction.walletId)) {
        balances[transaction.walletId] = 0;
      }

      if (transaction.type == 'income') {
        balances[transaction.walletId] =
            balances[transaction.walletId]! + transaction.amount;
      } else {
        balances[transaction.walletId] =
            balances[transaction.walletId]! - transaction.amount;
      }
    }

    return balances;
  }

  // Export transactions to CSV format
  Future<String> exportToCSV() async {
    final StringBuffer csv = StringBuffer();

    // Add CSV header
    csv.write(
      'ID,Amount,Type,Category,CategoryID,WalletID,Date,Notes,PaymentMethod,IsRecurring,RecurrencePattern,CreatedAt,UpdatedAt\n',
    );

    // Add transaction data
    for (final transaction in state.transactions) {
      csv.write(
        [
          transaction.id,
          (transaction.amount / 100.0).toStringAsFixed(2),
          transaction.type,
          transaction.category,
          transaction.categoryId,
          transaction.walletId,
          transaction.date.toIso8601String(),
          '"${transaction.notes.replaceAll('"', '""')}"', // Escape quotes in notes
          transaction.paymentMethod,
          transaction.isRecurring.toString(),
          transaction.recurrencePattern ?? '',
          '', // CreatedAt not available in Transaction model
          '', // UpdatedAt not available in Transaction model
        ].join(','),
      );
      csv.write('\n');
    }

    return csv.toString();
  }

  // Export filtered transactions to CSV
  Future<String> exportFilteredToCSV({
    String? type,
    String? categoryId,
    String? walletId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<Transaction> filteredTransactions = state.transactions;

    // Apply filters
    if (type != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.type == type)
          .toList();
    }

    if (categoryId != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.categoryId == categoryId)
          .toList();
    }

    if (walletId != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.walletId == walletId)
          .toList();
    }

    if (startDate != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.date.isAfter(startDate))
          .toList();
    }

    if (endDate != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.date.isBefore(endDate))
          .toList();
    }

    final StringBuffer csv = StringBuffer();

    // Add CSV header
    csv.write(
      'ID,Amount,Type,Category,CategoryID,WalletID,Date,Notes,PaymentMethod,IsRecurring,RecurrencePattern\n',
    );

    // Add filtered transaction data
    for (final transaction in filteredTransactions) {
      csv.write(
        [
          transaction.id,
          (transaction.amount / 100.0).toStringAsFixed(2),
          transaction.type,
          transaction.category,
          transaction.categoryId,
          transaction.walletId,
          transaction.date.toIso8601String(),
          '"${transaction.notes.replaceAll('"', '""')}"', // Escape quotes in notes
          transaction.paymentMethod,
          transaction.isRecurring.toString(),
          transaction.recurrencePattern ?? '',
        ].join(','),
      );
      csv.write('\n');
    }

    return csv.toString();
  }

  // Generate PDF report of transactions
  Future<Uint8List> generatePDFReport({
    String? type,
    String? categoryId,
    String? walletId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pdf = pw.Document();

    // Filter transactions
    List<Transaction> filteredTransactions = state.transactions;

    // Apply filters
    if (type != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.type == type)
          .toList();
    }

    if (categoryId != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.categoryId == categoryId)
          .toList();
    }

    if (walletId != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.walletId == walletId)
          .toList();
    }

    if (startDate != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.date.isAfter(startDate))
          .toList();
    }

    if (endDate != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.date.isBefore(endDate))
          .toList();
    }

    // Calculate totals (integer minor units / cents)
    int totalIncome = 0;
    int totalExpense = 0;

    for (final transaction in filteredTransactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    final netBalance = totalIncome - totalExpense;

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Financial Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Report Generated: ${DateTime.now()}'),
                  if (startDate != null || endDate != null)
                    pw.Text(
                      'Period: ${startDate?.toString().split(' ').first ?? 'Start'} - ${endDate?.toString().split(' ').first ?? 'End'}',
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        'Total Income',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '\$${(totalIncome / 100.0).toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          color: PdfColors.green,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        'Total Expense',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '\$${(totalExpense / 100.0).toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 18, color: PdfColors.red),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        'Net Balance',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '\$${(netBalance / 100.0).toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          color: netBalance >= 0
                              ? PdfColors.green
                              : PdfColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Transactions',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Type', 'Category', 'Amount', 'Notes'],
                data: filteredTransactions.map((transaction) {
                  return [
                    transaction.date.toString().split(' ').first,
                    transaction.type,
                    transaction.category,
                    '\$${(transaction.amount / 100.0).toStringAsFixed(2)}',
                    transaction.notes,
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: pw.TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
      final db = ref.watch(databaseProvider);
      final settings = ref.watch(settingsProvider);
      return TransactionNotifier(db, ref, settings);
    });
