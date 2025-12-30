import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/legacy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/ai/services/category_assignment_service.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
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
        title: '',
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
  final CategoryAssignmentService _categoryAssignmentService; // Add this field

  TransactionNotifier(this._db, SettingsState settings)
    : _categoryAssignmentService =
          CategoryAssignmentService(), // Initialize the service
      super(TransactionState(transactions: [], isLoading: false)) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    state = state.copyWith(isLoading: true);
    try {
      final dbTransactions = await _db.getAllTransactions();
      final transactions = dbTransactions
          .map(
            (t) => Transaction(
              id: t.id,
              amount: t.amount,
              // Use isIncome to determine type (new approach)
              type: t.isIncome ? 'income' : 'expense',
              category: 'Unknown', // Will be resolved by category lookup
              categoryId: t.categoryId ?? '',
              walletId: t.walletId,
              date: t.date,
              notes: t.notes ?? '',
              paymentMethod: t.paymentMethodId ?? '',
              isRecurring: false, // Deprecated - use RecurringConfigs
              recurrencePattern: null, // Deprecated - use RecurringConfigs
            ),
          )
          .toList();

      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load transactions',
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
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add transaction',
      );
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

      final updatedTransaction = TransactionsCompanion(
        id: Value(id),
        amount: Value(amount ?? existing.amount),
        isIncome: Value(transactionIsIncome ?? existing.isIncome),
        title: Value(title ?? existing.title),
        categoryId: Value(categoryId ?? existing.categoryId),
        walletId: Value(walletId ?? existing.walletId),
        date: Value(date ?? existing.date),
        notes: Value(notes ?? existing.notes),
        paymentMethodId: Value(paymentMethodId ?? paymentMethod ?? existing.paymentMethodId),
        createdAt: Value(existing.createdAt),
        updatedAt: Value(DateTime.now()),
      );

      await _db.updateTransaction(updatedTransaction);

      // Reload transactions to get the updated one
      await _loadTransactions();
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
      await _db.deleteTransaction(id);

      // Reload transactions to reflect the deletion
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete transaction',
      );
    }
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
      return TransactionNotifier(db, settings);
    });
