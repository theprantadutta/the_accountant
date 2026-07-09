import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

/// Service for managing wallet balance calculations and updates.
/// Ensures wallet balances stay in sync with transactions.
class WalletBalanceService {
  final AppDatabase _db;

  WalletBalanceService(this._db);

  /// Calculate the balance for a specific wallet from its transactions.
  /// Starts from the wallet's opening balance, then income transactions add and
  /// expense transactions subtract. All values are integer minor units (cents).
  Future<int> calculateWalletBalance(String walletId) async {
    final wallet = await _db.findWalletById(walletId);
    final transactions = await _db.getTransactionsByWallet(walletId);

    int balance = wallet?.openingBalance ?? 0;
    for (final transaction in transactions) {
      // Count a transaction toward the balance only if it is paid, or it is a credit/debt
      // entry (which always affects the balance regardless of paid status). This mirrors the
      // schemaVersion-11 migration backfill EXACTLY — `is_paid OR special_type IN (credit,
      // debt)` — so a recompute can never diverge from the migrated opening/stored balance.
      final countsTowardBalance =
          transaction.isPaid ||
          transaction.specialType == TransactionSpecialType.credit ||
          transaction.specialType == TransactionSpecialType.debt;
      if (!countsTowardBalance) {
        continue;
      }

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
    required int amount,
    required bool isIncome,
    bool isDelete = false,
  }) async {
    final wallet = await _db.findWalletById(walletId);
    if (wallet == null) {
      throw Exception('Wallet not found: $walletId');
    }

    int currentBalance = wallet.balance;
    int change = amount.abs();

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

  /// Recompute every wallet's balance from its transactions and persist it
  /// WITHOUT marking the wallets for sync. Call this after a pull so the
  /// displayed balance is derived locally and correct across devices, regardless
  /// of the last-write-wins `balance` scalar pulled from the server (which can be
  /// stale when two devices edit the same wallet). Because it doesn't set a
  /// pending flag, it never re-pushes and can't cause a balance ping-pong.
  Future<void> recalculateAllWalletBalancesLocal() async {
    final wallets = await _db.getAllWallets();

    for (final wallet in wallets) {
      final calculatedBalance = await calculateWalletBalance(wallet.id);
      await _db.setWalletBalanceLocal(wallet.id, calculatedBalance);
    }
  }

  /// Get all wallets with their calculated balances.
  /// Returns a map of walletId to balance.
  Future<Map<String, int>> getAllWalletBalances() async {
    final wallets = await _db.getAllWallets();
    final Map<String, int> balances = {};

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

    // Exact integer equality — money is stored in integer minor units (cents).
    return wallet.balance == calculatedBalance;
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
