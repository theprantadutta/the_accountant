import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

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

  /// Get total upcoming amount (major-unit dollars; amounts are integer cents)
  double get totalUpcoming =>
      upcomingTransactions.fold(0.0, (sum, t) => sum + t.amount / 100.0);

  /// Get total overdue amount (major-unit dollars; amounts are integer cents)
  double get totalOverdue =>
      overdueTransactions.fold(0.0, (sum, t) => sum + t.amount / 100.0);

  /// Check if there are any pending items
  bool get hasPendingItems =>
      upcomingTransactions.isNotEmpty || overdueTransactions.isNotEmpty;
}

class UpcomingNotifier extends StateNotifier<UpcomingState> {
  final AppDatabase _db;
  final WalletBalanceService _walletBalanceService;
  final Ref _ref;

  UpcomingNotifier(this._db, this._ref)
    : _walletBalanceService = WalletBalanceService(_db),
      super(const UpcomingState()) {
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

      // Update wallet balance — the transaction is now paid so it should
      // affect the wallet balance
      final transaction = await _db.findTransactionById(transactionId);
      if (transaction != null) {
        await _walletBalanceService.updateBalanceAfterTransaction(
          walletId: transaction.walletId,
          amount: transaction.amount,
          isIncome: transaction.isIncome,
        );
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      await loadData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: 'Failed to mark as paid: ${e.toString()}');
    }
  }

  /// Mark a transaction as unpaid
  Future<void> markAsUnpaid(String transactionId) async {
    try {
      // Read the transaction before marking unpaid to get its current state
      final transaction = await _db.findTransactionById(transactionId);

      await _db.markTransactionAsUnpaid(transactionId);

      // Reverse the wallet balance effect — the transaction is no longer paid
      // so its effect on the wallet should be removed
      if (transaction != null && transaction.isPaid) {
        await _walletBalanceService.updateBalanceAfterTransaction(
          walletId: transaction.walletId,
          amount: transaction.amount,
          isIncome: transaction.isIncome,
          isDelete: true,
        );
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      await loadData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as unpaid: ${e.toString()}',
      );
    }
  }

  /// Skip a transaction (set skipPaid = true).
  ///
  /// Routed through the sync-aware repository method so the skip is flagged
  /// pending and propagates; the previous raw SQL update left `syncStatus`
  /// untouched, so another device kept showing the dismissed reminder.
  Future<void> skipTransaction(String transactionId) async {
    try {
      await _db.skipTransaction(transactionId);
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
    return UpcomingNotifier(db, ref);
  },
);
