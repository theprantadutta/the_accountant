import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart' show TransactionSpecialType;
import 'package:uuid/uuid.dart';

/// State for credit and debt transactions
class CreditDebtState {
  final List<Transaction> creditTransactions;
  final List<Transaction> debtTransactions;
  final bool isLoading;
  final String? error;

  const CreditDebtState({
    this.creditTransactions = const [],
    this.debtTransactions = const [],
    this.isLoading = false,
    this.error,
  });

  CreditDebtState copyWith({
    List<Transaction>? creditTransactions,
    List<Transaction>? debtTransactions,
    bool? isLoading,
    String? error,
  }) {
    return CreditDebtState(
      creditTransactions: creditTransactions ?? this.creditTransactions,
      debtTransactions: debtTransactions ?? this.debtTransactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get total credit (money lent out - they owe you)
  double get totalCredit =>
      creditTransactions.fold(0.0, (sum, t) => sum + t.amount);

  /// Get unpaid credit
  double get unpaidCredit => creditTransactions
      .where((t) => !t.isPaid)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// Get total debt (money borrowed - you owe them)
  double get totalDebt =>
      debtTransactions.fold(0.0, (sum, t) => sum + t.amount);

  /// Get unpaid debt
  double get unpaidDebt => debtTransactions
      .where((t) => !t.isPaid)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// Net balance (positive = others owe you more, negative = you owe more)
  double get netBalance => totalCredit - totalDebt;

  /// Get all transactions sorted by date
  List<Transaction> get allTransactions {
    final all = [...creditTransactions, ...debtTransactions];
    all.sort((a, b) => b.date.compareTo(a.date));
    return all;
  }

  /// Get unpaid transactions
  List<Transaction> get unpaidTransactions =>
      allTransactions.where((t) => !t.isPaid).toList();

  /// Get overdue unpaid transactions (past original due date)
  List<Transaction> get overdueTransactions =>
      unpaidTransactions.where((t) {
        final dueDate = t.originalDueDate ?? t.date;
        return dueDate.isBefore(DateTime.now());
      }).toList();

  /// Count of overdue transactions
  int get overdueCount => overdueTransactions.length;
}

class CreditDebtNotifier extends StateNotifier<CreditDebtState> {
  final AppDatabase _db;

  CreditDebtNotifier(this._db) : super(const CreditDebtState()) {
    loadData();
  }

  /// Load credit and debt transactions
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final credit = await _db.getCreditTransactions();
      final debt = await _db.getDebtTransactions();

      state = state.copyWith(
        creditTransactions: credit,
        debtTransactions: debt,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data: ${e.toString()}',
      );
    }
  }

  /// Mark a credit/debt as fully settled
  Future<void> markAsSettled(String transactionId) async {
    try {
      final transaction = await _db.findTransactionById(transactionId);
      if (transaction == null) return;

      // Set paidAmount to full amount when marking as settled
      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(TransactionsCompanion(
        isPaid: const Value(true),
        paidAmount: Value(transaction.amount),
        originalDueDate:
            Value(transaction.originalDueDate ?? transaction.date),
        date: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ));
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as settled: ${e.toString()}',
      );
    }
  }

  /// Record a partial payment on a credit/debt transaction.
  /// Creates a new regular transaction for the payment and updates paidAmount.
  Future<void> recordPayment({
    required String transactionId,
    required double paymentAmount,
  }) async {
    try {
      final transaction = await _db.findTransactionById(transactionId);
      if (transaction == null) return;

      final isCredit =
          transaction.specialType == TransactionSpecialType.credit;
      final newPaidAmount = transaction.paidAmount + paymentAmount;
      final isFullyPaid = newPaidAmount >= transaction.amount;

      // Create a separate regular transaction for the payment
      final now = DateTime.now();
      final paymentTransaction = TransactionsCompanion(
        id: Value(const Uuid().v4()),
        amount: Value(paymentAmount),
        title: Value(
            '${isCredit ? "Received" : "Paid"}: ${transaction.title}'),
        notes: Value(
            'Partial payment for ${isCredit ? "credit" : "debt"}: ${transaction.title}'),
        date: Value(now),
        // Credit repayment = income (you receive money back)
        // Debt repayment = expense (you pay money out)
        isIncome: Value(isCredit),
        walletId: Value(transaction.walletId),
        categoryId: Value(transaction.categoryId),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      await _db.addTransaction(paymentTransaction);

      // Update the original loan transaction's paidAmount
      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(TransactionsCompanion(
        paidAmount: Value(newPaidAmount),
        isPaid: Value(isFullyPaid),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(now),
      ));

      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to record payment: ${e.toString()}',
      );
    }
  }

  /// Mark as pending again
  Future<void> markAsPending(String transactionId) async {
    try {
      await _db.markTransactionAsUnpaid(transactionId);
      // Also reset paidAmount
      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(TransactionsCompanion(
        paidAmount: const Value(0.0),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ));
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as pending: ${e.toString()}',
      );
    }
  }

  /// Check if a transaction is overdue
  bool isOverdue(Transaction transaction) {
    if (transaction.isPaid) return false;
    final dueDate = transaction.originalDueDate ?? transaction.date;
    return dueDate.isBefore(DateTime.now());
  }

  /// Check if transaction is credit type
  bool isCredit(Transaction transaction) {
    return transaction.specialType == TransactionSpecialType.credit;
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }
}

/// Provider for credit/debt transactions
final creditDebtProvider =
    StateNotifierProvider<CreditDebtNotifier, CreditDebtState>((ref) {
  final db = ref.watch(databaseProvider);
  return CreditDebtNotifier(db);
});
