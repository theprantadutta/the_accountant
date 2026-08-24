import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Provider for TransferService
final transferServiceProvider = Provider<TransferService>((ref) {
  final db = ref.watch(databaseProvider);
  return TransferService(db);
});

/// State for transfer operations
class TransferState {
  final bool isLoading;
  final String? errorMessage;
  final List<Transaction> transfers;
  final Transaction? lastCreatedTransfer;

  const TransferState({
    this.isLoading = false,
    this.errorMessage,
    this.transfers = const [],
    this.lastCreatedTransfer,
  });

  TransferState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Transaction>? transfers,
    Transaction? lastCreatedTransfer,
  }) {
    return TransferState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      transfers: transfers ?? this.transfers,
      lastCreatedTransfer: lastCreatedTransfer ?? this.lastCreatedTransfer,
    );
  }
}

/// Notifier for managing transfer operations
class TransferNotifier extends StateNotifier<TransferState> {
  final TransferService _transferService;
  final Ref _ref;

  TransferNotifier(this._transferService, this._ref)
    : super(const TransferState()) {
    loadTransfers();
  }

  /// Load all transfer transactions
  Future<void> loadTransfers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final transfers = await _transferService.getTransferTransactions();
      state = state.copyWith(isLoading: false, transfers: transfers);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load transfers: $e',
      );
    }
  }

  /// Create a new transfer between wallets
  Future<bool> createTransfer({
    required String sourceWalletId,
    required String destinationWalletId,
    required int amount, // integer minor units / cents
    required DateTime date,
    String? notes,
    String? title,
    int feeAmount = 0,
    String? feeWalletId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Create the paired transactions. Both rows AND both wallet balances are
      // written inside a single database transaction by the service, so there
      // is no window where one leg exists without the other and no separate
      // balance update here that could double-count.
      await _transferService.createTransfer(
        sourceWalletId: sourceWalletId,
        destinationWalletId: destinationWalletId,
        amount: amount,
        date: date,
        notes: notes,
        title: title,
        feeAmount: feeAmount,
        feeWalletId: feeWalletId,
      );

      // Refresh wallet provider (await to ensure state is updated)
      await _ref.read(walletProvider.notifier).loadWallets();

      // Reload transfers
      await loadTransfers();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create transfer: $e',
      );
      return false;
    }
  }

  /// Update an existing transfer
  Future<bool> updateTransfer({
    required String transactionId,
    int? amount, // integer minor units / cents
    DateTime? date,
    String? notes,
    String? title,
    String? sourceWalletId,
    String? destinationWalletId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _transferService.updateTransfer(
        transactionId: transactionId,
        amount: amount,
        date: date,
        notes: notes,
        title: title,
        sourceWalletId: sourceWalletId,
        destinationWalletId: destinationWalletId,
      );

      // Balances for every wallet the edit touched were recomputed inside the
      // service's database transaction.

      // Refresh wallet provider (await to ensure state is updated)
      await _ref.read(walletProvider.notifier).loadWallets();

      // Reload transfers
      await loadTransfers();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update transfer: $e',
      );
      return false;
    }
  }

  /// Delete a transfer
  Future<bool> deleteTransfer(String transactionId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _transferService.deleteTransfer(transactionId);

      // Both legs were tombstoned and both wallets recomputed inside the
      // service's database transaction.

      // Refresh wallet provider (await to ensure state is updated)
      await _ref.read(walletProvider.notifier).loadWallets();

      // Reload transfers
      await loadTransfers();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete transfer: $e',
      );
      return false;
    }
  }

  /// Check if a transaction is a transfer
  Future<bool> isTransfer(String transactionId) async {
    return _transferService.isTransfer(transactionId);
  }

  /// Report any transfer pair that violates the paired-object invariants.
  Future<List<TransferIntegrityIssue>> validateIntegrity() =>
      _transferService.validateAllTransfers();

  /// Clear any error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for transfer state and operations
final transferProvider = StateNotifierProvider<TransferNotifier, TransferState>(
  (ref) {
    final transferService = ref.watch(transferServiceProvider);
    return TransferNotifier(transferService, ref);
  },
);
