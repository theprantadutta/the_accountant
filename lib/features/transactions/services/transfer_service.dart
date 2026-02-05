import 'package:drift/drift.dart' show Value;
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

/// Service for managing wallet-to-wallet transfers.
/// Transfers are implemented as paired transactions (like Cashew):
/// - One expense from the source wallet
/// - One income to the destination wallet
/// Both transactions are linked via pairedTransactionId.
class TransferService {
  final AppDatabase _db;

  TransferService(this._db);

  /// Create a transfer between two wallets.
  /// Creates two paired transactions:
  /// - Expense from source wallet (amount is negative effect)
  /// - Income to destination wallet (amount is positive effect)
  ///
  /// Returns a tuple of (expenseTransactionId, incomeTransactionId)
  Future<(String, String)> createTransfer({
    required String sourceWalletId,
    required String destinationWalletId,
    required double amount,
    required DateTime date,
    String? notes,
    String? title,
  }) async {
    if (sourceWalletId == destinationWalletId) {
      throw ArgumentError('Source and destination wallets must be different');
    }

    if (amount <= 0) {
      throw ArgumentError('Transfer amount must be positive');
    }

    final uuid = const Uuid();
    final expenseId = uuid.v4();
    final incomeId = uuid.v4();
    final now = DateTime.now();

    // Get wallet names for default title
    final sourceWallet = await _db.findWalletById(sourceWalletId);
    final destWallet = await _db.findWalletById(destinationWalletId);

    if (sourceWallet == null) {
      throw Exception('Source wallet not found: $sourceWalletId');
    }
    if (destWallet == null) {
      throw Exception('Destination wallet not found: $destinationWalletId');
    }

    final transferTitle =
        title ?? 'Transfer: ${sourceWallet.name} → ${destWallet.name}';

    // Transaction 1: Expense from source wallet
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(expenseId),
        amount: Value(amount),
        isIncome: const Value(false), // Expense from source
        title: Value(transferTitle),
        notes: Value(notes),
        date: Value(date),
        categoryId: const Value(SystemCategories.transferCategoryId),
        walletId: Value(sourceWalletId),
        transactionType: const Value('transfer'),
        pairedTransactionId: Value(incomeId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    // Transaction 2: Income to destination wallet
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(incomeId),
        amount: Value(amount),
        isIncome: const Value(true), // Income to destination
        title: Value(transferTitle),
        notes: Value(notes),
        date: Value(date),
        categoryId: const Value(SystemCategories.transferCategoryId),
        walletId: Value(destinationWalletId),
        transactionType: const Value('transfer'),
        pairedTransactionId: Value(expenseId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    return (expenseId, incomeId);
  }

  /// Update an existing transfer.
  /// Updates both paired transactions atomically.
  Future<void> updateTransfer({
    required String transactionId,
    double? amount,
    DateTime? date,
    String? notes,
    String? title,
    String? sourceWalletId,
    String? destinationWalletId,
  }) async {
    final transaction = await _db.findTransactionById(transactionId);
    if (transaction == null) {
      throw Exception('Transaction not found: $transactionId');
    }

    if (transaction.pairedTransactionId == null) {
      throw Exception('Transaction is not a transfer (no paired transaction)');
    }

    final pairedTransaction = await _db.findTransactionById(
      transaction.pairedTransactionId!,
    );
    if (pairedTransaction == null) {
      throw Exception('Paired transaction not found');
    }

    // Determine which is expense and which is income
    final (expenseTxn, incomeTxn) = transaction.isIncome
        ? (pairedTransaction, transaction)
        : (transaction, pairedTransaction);

    final now = DateTime.now();

    // Build update data
    final expenseUpdate = TransactionsCompanion(
      id: Value(expenseTxn.id),
      amount: amount != null ? Value(amount) : Value(expenseTxn.amount),
      isIncome: const Value(false),
      title: title != null ? Value(title) : Value(expenseTxn.title),
      notes: notes != null ? Value(notes) : Value(expenseTxn.notes),
      date: date != null ? Value(date) : Value(expenseTxn.date),
      categoryId: Value(expenseTxn.categoryId),
      walletId: sourceWalletId != null
          ? Value(sourceWalletId)
          : Value(expenseTxn.walletId),
      transactionType: Value(expenseTxn.transactionType),
      pairedTransactionId: Value(incomeTxn.id),
      createdAt: Value(expenseTxn.createdAt),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pendingUpdate),
    );

    final incomeUpdate = TransactionsCompanion(
      id: Value(incomeTxn.id),
      amount: amount != null ? Value(amount) : Value(incomeTxn.amount),
      isIncome: const Value(true),
      title: title != null ? Value(title) : Value(incomeTxn.title),
      notes: notes != null ? Value(notes) : Value(incomeTxn.notes),
      date: date != null ? Value(date) : Value(incomeTxn.date),
      categoryId: Value(incomeTxn.categoryId),
      walletId: destinationWalletId != null
          ? Value(destinationWalletId)
          : Value(incomeTxn.walletId),
      transactionType: Value(incomeTxn.transactionType),
      pairedTransactionId: Value(expenseTxn.id),
      createdAt: Value(incomeTxn.createdAt),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pendingUpdate),
    );

    await _db.updateTransaction(expenseUpdate);
    await _db.updateTransaction(incomeUpdate);
  }

  /// Delete a transfer (deletes both paired transactions)
  Future<void> deleteTransfer(String transactionId) async {
    final transaction = await _db.findTransactionById(transactionId);
    if (transaction == null) {
      throw Exception('Transaction not found: $transactionId');
    }

    // Delete paired transaction if it exists
    if (transaction.pairedTransactionId != null) {
      await _db.deleteTransaction(transaction.pairedTransactionId!);
    }

    // Delete the main transaction
    await _db.deleteTransaction(transactionId);
  }

  /// Get all transfer transactions
  Future<List<Transaction>> getTransferTransactions() async {
    final allTransactions = await _db.getAllTransactions();
    return allTransactions
        .where((t) => t.transactionType == 'transfer')
        .toList();
  }

  /// Get the paired transaction for a transfer
  Future<Transaction?> getPairedTransaction(String transactionId) async {
    final transaction = await _db.findTransactionById(transactionId);
    if (transaction?.pairedTransactionId == null) return null;
    return _db.findTransactionById(transaction!.pairedTransactionId!);
  }

  /// Check if a transaction is a transfer
  Future<bool> isTransfer(String transactionId) async {
    final transaction = await _db.findTransactionById(transactionId);
    return transaction?.transactionType == 'transfer' &&
        transaction?.pairedTransactionId != null;
  }
}
