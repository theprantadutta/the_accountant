import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart' show TransactionSpecialType;

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

  /// Mark a credit/debt as collected/paid
  Future<void> markAsSettled(String transactionId) async {
    try {
      await _db.markTransactionAsPaid(transactionId);
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as settled: ${e.toString()}',
      );
    }
  }

  /// Mark as pending again
  Future<void> markAsPending(String transactionId) async {
    try {
      await _db.markTransactionAsUnpaid(transactionId);
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as pending: ${e.toString()}',
      );
    }
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
