import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for managing wallet balance calculations and updates.
/// Ensures wallet balances stay in sync with transactions.
class WalletBalanceService {
  final AppDatabase _db;

  WalletBalanceService(this._db);

  /// Calculate the balance for a specific wallet from its transactions.
  /// Income transactions add to balance, expense transactions subtract.
  Future<double> calculateWalletBalance(String walletId) async {
    final transactions = await _db.getTransactionsByWallet(walletId);

    double balance = 0.0;
    for (final transaction in transactions) {
      if (transaction.isIncome) {
        balance += transaction.amount.abs();
      } else {
        balance -= transaction.amount.abs();
      }
    }

    return balance;
  }

  /// Update the stored balance for a wallet based on its transactions.
  /// Call this after any transaction operation (add, update, delete).
  Future<void> updateWalletBalance(String walletId) async {
    final calculatedBalance = await calculateWalletBalance(walletId);
    await _db.updateWalletBalance(walletId, calculatedBalance);
  }

  /// Update balance for a wallet after adding a transaction.
  /// More efficient than full recalculation for single transaction changes.
  Future<void> updateBalanceAfterTransaction({
    required String walletId,
    required double amount,
    required bool isIncome,
    bool isDelete = false,
  }) async {
    final wallet = await _db.findWalletById(walletId);
    if (wallet == null) {
      throw Exception('Wallet not found: $walletId');
    }

    double currentBalance = wallet.balance;
    double change = amount.abs();

    if (isDelete) {
      // Reverse the transaction effect
      if (isIncome) {
        currentBalance -= change;
      } else {
        currentBalance += change;
      }
    } else {
      // Apply the transaction effect
      if (isIncome) {
        currentBalance += change;
      } else {
        currentBalance -= change;
      }
    }

    await _db.updateWalletBalance(walletId, currentBalance);
  }

  /// Recalculate and update balances for all wallets.
  /// Use this for data integrity checks or after bulk imports.
  Future<void> recalculateAllWalletBalances() async {
    final wallets = await _db.getAllWallets();

    for (final wallet in wallets) {
      await updateWalletBalance(wallet.id);
    }
  }

  /// Get all wallets with their calculated balances.
  /// Returns a map of walletId to balance.
  Future<Map<String, double>> getAllWalletBalances() async {
    final wallets = await _db.getAllWallets();
    final Map<String, double> balances = {};

    for (final wallet in wallets) {
      balances[wallet.id] = wallet.balance;
    }

    return balances;
  }

  /// Verify that stored balance matches calculated balance.
  /// Returns true if they match, false if there's a discrepancy.
  Future<bool> verifyWalletBalance(String walletId) async {
    final wallet = await _db.findWalletById(walletId);
    if (wallet == null) return false;

    final calculatedBalance = await calculateWalletBalance(walletId);
    const tolerance = 0.01; // Allow small floating point differences

    return (wallet.balance - calculatedBalance).abs() < tolerance;
  }

  /// Fix any balance discrepancies by recalculating from transactions.
  Future<int> fixAllBalanceDiscrepancies() async {
    final wallets = await _db.getAllWallets();
    int fixedCount = 0;

    for (final wallet in wallets) {
      final isValid = await verifyWalletBalance(wallet.id);
      if (!isValid) {
        await updateWalletBalance(wallet.id);
        fixedCount++;
      }
    }

    return fixedCount;
  }
}
