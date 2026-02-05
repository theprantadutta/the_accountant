import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// State for upcoming and overdue transactions
class UpcomingState {
  final List<Transaction> upcomingTransactions;
  final List<Transaction> overdueTransactions;
  final bool isLoading;
  final String? error;

  const UpcomingState({
    this.upcomingTransactions = const [],
    this.overdueTransactions = const [],
    this.isLoading = false,
    this.error,
  });

  UpcomingState copyWith({
    List<Transaction>? upcomingTransactions,
    List<Transaction>? overdueTransactions,
    bool? isLoading,
    String? error,
  }) {
    return UpcomingState(
      upcomingTransactions: upcomingTransactions ?? this.upcomingTransactions,
      overdueTransactions: overdueTransactions ?? this.overdueTransactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get total upcoming amount
  double get totalUpcoming =>
      upcomingTransactions.fold(0.0, (sum, t) => sum + t.amount);

  /// Get total overdue amount
  double get totalOverdue =>
      overdueTransactions.fold(0.0, (sum, t) => sum + t.amount);

  /// Check if there are any pending items
  bool get hasPendingItems =>
      upcomingTransactions.isNotEmpty || overdueTransactions.isNotEmpty;
}

class UpcomingNotifier extends StateNotifier<UpcomingState> {
  final AppDatabase _db;

  UpcomingNotifier(this._db) : super(const UpcomingState()) {
    loadData();
  }

  /// Load upcoming and overdue transactions
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final upcoming = await _db.getUpcomingTransactions();
      final overdue = await _db.getOverdueTransactions();

      state = state.copyWith(
        upcomingTransactions: upcoming,
        overdueTransactions: overdue,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data: ${e.toString()}',
      );
    }
  }

  /// Mark a transaction as paid
  Future<void> markAsPaid(String transactionId) async {
    try {
      await _db.markTransactionAsPaid(transactionId);
      await loadData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: 'Failed to mark as paid: ${e.toString()}');
    }
  }

  /// Mark a transaction as unpaid
  Future<void> markAsUnpaid(String transactionId) async {
    try {
      await _db.markTransactionAsUnpaid(transactionId);
      await loadData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as unpaid: ${e.toString()}',
      );
    }
  }

  /// Skip a transaction (set skipPaid = true)
  Future<void> skipTransaction(String transactionId) async {
    try {
      await _db.customStatement(
        'UPDATE transactions SET skip_paid = 1, updated_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), transactionId],
      );
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to skip transaction: ${e.toString()}',
      );
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }
}

/// Provider for upcoming/overdue transactions
final upcomingProvider = StateNotifierProvider<UpcomingNotifier, UpcomingState>(
  (ref) {
    final db = ref.watch(databaseProvider);
    return UpcomingNotifier(db);
  },
);
