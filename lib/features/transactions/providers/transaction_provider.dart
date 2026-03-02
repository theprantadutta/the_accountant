import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:the_accountant/core/services/wallet_balance_service.dart';
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

/// ViewModel class for displaying transactions in UI
/// Uses isIncome boolean instead of deprecated type string
class TransactionViewModel {
  final String id;
  final double amount;
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
  final double amount;
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
  });

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
          title: t.title ?? '',
          notes: t.notes ?? '',
          paymentMethod: t.paymentMethodId ?? '',
          isRecurring: false, // Deprecated - use RecurringConfigs
          recurrencePattern: null, // Deprecated - use RecurringConfigs
        );
      }).toList();

      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      if (mounted) {
        if (!silent) state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load transactions: $e',
        );
      }
    }
  }

  /// Add a new transaction
  /// [isIncome] - true for income, false for expense
  /// [type] - @deprecated, use isIncome instead. Kept for backward compatibility.
  Future<void> addTransaction({
    required double amount,
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
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _db.addTransaction(newTransaction);

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
    required double amount,
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
            amount: amount,
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
        if (notifPrefs.largeTransactionAlertsEnabled &&
            amount >= notifPrefs.largeTransactionThreshold) {
          await NotificationService().showLargeTransactionNotification(
            amount, title ?? '', isIncome,
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
    double? amount,
    String? type, // @deprecated - use isIncome instead
    bool? isIncome, // New: use this instead of type
    String? title,
    String? categoryId,
    String? walletId,
    DateTime? date,
    String? notes,
    String? paymentMethodId,
    String? paymentMethod, // @deprecated - use paymentMethodId
    bool? isRecurring, // @deprecated
    String? recurrencePattern, // @deprecated
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findTransactionById(id);
      if (existing == null) {
        throw Exception('Transaction not found');
      }

      // Determine isIncome: prefer explicit isIncome, then type, then existing
      bool? transactionIsIncome;
      if (isIncome != null) {
        transactionIsIncome = isIncome;
      } else if (type != null) {
        transactionIsIncome = type == 'income';
      }

      // Preserve ALL fields from existing transaction to prevent data loss
      // when using replace() which requires all columns
      final updatedTransaction = TransactionsCompanion(
        id: Value(id),
        amount: Value(amount ?? existing.amount),
        isIncome: Value(transactionIsIncome ?? existing.isIncome),
        title: Value(title ?? existing.title),
        categoryId: Value(categoryId ?? existing.categoryId),
        walletId: Value(walletId ?? existing.walletId),
        date: Value(date ?? existing.date),
        notes: Value(notes ?? existing.notes),
        paymentMethodId: Value(
          paymentMethodId ?? paymentMethod ?? existing.paymentMethodId,
        ),
        // Preserve transaction metadata fields
        transactionType: Value(existing.transactionType),
        specialType: Value(existing.specialType),
        isPaid: Value(existing.isPaid),
        originalDueDate: Value(existing.originalDueDate),
        skipPaid: Value(existing.skipPaid),
        // Preserve assignment fields
        budgetId: Value(existing.budgetId),
        objectiveId: Value(existing.objectiveId),
        recurringConfigId: Value(existing.recurringConfigId),
        pairedTransactionId: Value(existing.pairedTransactionId),
        // Preserve other metadata
        receiptImageUrl: Value(existing.receiptImageUrl),
        serverId: Value(existing.serverId),
        syncStatus: Value(SyncStatus.pendingUpdate),
        deletedAt: Value(existing.deletedAt),
        // Timestamps
        createdAt: Value(existing.createdAt),
        updatedAt: Value(DateTime.now()),
      );

      await _db.updateTransaction(updatedTransaction);

      // Handle wallet balance updates using incremental approach
      // This preserves initial balances instead of recalculating from scratch
      final oldWalletId = existing.walletId;
      final newWalletId = walletId ?? existing.walletId;
      final oldAmount = existing.amount;
      final newAmount = amount ?? existing.amount;
      final oldIsIncome = existing.isIncome;
      final newIsIncome = transactionIsIncome ?? existing.isIncome;

      // Only process if the transaction was/is paid
      final wasPaid = existing.isPaid;

      if (wasPaid) {
        if (oldWalletId == newWalletId) {
          // Same wallet - only update if amount or type changed
          if (oldAmount != newAmount || oldIsIncome != newIsIncome) {
            // Reverse old effect
            await _walletBalanceService.updateBalanceAfterTransaction(
              walletId: oldWalletId,
              amount: oldAmount,
              isIncome: !oldIsIncome, // Reverse
            );
            // Apply new effect
            await _walletBalanceService.updateBalanceAfterTransaction(
              walletId: newWalletId,
              amount: newAmount,
              isIncome: newIsIncome,
            );
          }
        } else {
          // Wallet changed - reverse from old, apply to new
          // Reverse effect on old wallet
          await _walletBalanceService.updateBalanceAfterTransaction(
            walletId: oldWalletId,
            amount: oldAmount,
            isIncome: !oldIsIncome, // Reverse the effect
          );
          // Apply effect on new wallet
          await _walletBalanceService.updateBalanceAfterTransaction(
            walletId: newWalletId,
            amount: newAmount,
            isIncome: newIsIncome,
          );
        }
      }

      // Refresh wallet provider to reflect new balance
      await _ref.read(walletProvider.notifier).loadWallets();

      // Reload transactions to get the updated one
      await loadTransactions();

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

  Future<void> deleteTransaction(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      // Cancel any scheduled reminder for this transaction
      try {
        await ReminderSchedulerService().cancelReminder(id);
      } catch (_) {}

      // First get the transaction to reverse its effect on wallet
      final transaction = await _db.findTransactionById(id);
      if (transaction != null && transaction.isPaid) {
        // Reverse the wallet balance effect
        // If it was income, subtract from wallet; if expense, add back to wallet
        await _walletBalanceService.updateBalanceAfterTransaction(
          walletId: transaction.walletId,
          amount: transaction.amount,
          isIncome: !transaction.isIncome, // Reverse the effect
        );

        // Refresh wallet provider to reflect new balance (await to ensure state is updated)
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      await _db.deleteTransaction(id);

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

  double getTotalAmountByType(String type) {
    return state.transactions
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getWalletBalance(String walletId) {
    return state.transactions.where((t) => t.walletId == walletId).fold(0.0, (
      sum,
      t,
    ) {
      if (t.type == 'income') {
        return sum + t.amount;
      } else {
        return sum - t.amount;
      }
    });
  }

  Map<String, double> getAllWalletBalances() {
    final Map<String, double> balances = {};

    for (var transaction in state.transactions) {
      if (!balances.containsKey(transaction.walletId)) {
        balances[transaction.walletId] = 0.0;
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
          transaction.amount.toString(),
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
          transaction.amount.toString(),
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

    // Calculate totals
    double totalIncome = 0.0;
    double totalExpense = 0.0;

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
                        '\$${totalIncome.toStringAsFixed(2)}',
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
                        '\$${totalExpense.toStringAsFixed(2)}',
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
                        '\$${netBalance.toStringAsFixed(2)}',
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
                    '\$${transaction.amount.toStringAsFixed(2)}',
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
