import 'package:drift/drift.dart' show Value;
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

/// A violated invariant of a transfer pair, with enough context to act on it.
class TransferIntegrityIssue {
  /// Id of the leg the problem was detected on.
  final String transactionId;

  /// Machine-readable problem code (see [TransferIntegrity]).
  final String code;

  /// Human-readable explanation.
  final String message;

  const TransferIntegrityIssue({
    required this.transactionId,
    required this.code,
    required this.message,
  });

  @override
  String toString() => '[$code] $transactionId: $message';
}

/// Invariants every wallet-to-wallet transfer pair must satisfy.
///
/// A transfer is a single domain object stored as two rows. Nothing else in the
/// schema enforces that; before this existed, a generic single-row edit or
/// delete could leave one leg behind — an orphan that silently skewed one
/// wallet's balance and showed up in history as a one-sided "transfer".
class TransferIntegrity {
  const TransferIntegrity._();

  static const String missingPartner = 'missing_partner';
  static const String notReciprocal = 'not_reciprocal';
  static const String amountMismatch = 'amount_mismatch';
  static const String sameDirection = 'same_direction';
  static const String sameWallet = 'same_wallet';
  static const String partnerDeleted = 'partner_deleted';
  static const String typeMismatch = 'type_mismatch';

  /// Validate one leg against its partner. [partner] is null when the partner
  /// row could not be found at all.
  static List<TransferIntegrityIssue> validatePair(
    Transaction leg,
    Transaction? partner,
  ) {
    final issues = <TransferIntegrityIssue>[];

    if (leg.pairedTransactionId == null) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: missingPartner,
          message: 'Transfer leg has no pairedTransactionId.',
        ),
      );
      return issues;
    }

    if (partner == null) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: missingPartner,
          message: 'Partner ${leg.pairedTransactionId} does not exist locally.',
        ),
      );
      return issues;
    }

    if (partner.pairedTransactionId != leg.id) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: notReciprocal,
          message:
              'Partner ${partner.id} points at ${partner.pairedTransactionId}, '
              'not back at ${leg.id}.',
        ),
      );
    }

    if (!TransactionPolicy.isTransfer(partner)) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: typeMismatch,
          message: 'Partner ${partner.id} is not marked as a transfer.',
        ),
      );
    }

    if (leg.amount != partner.amount) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: amountMismatch,
          message:
              'Amounts differ (${leg.amount} vs ${partner.amount}); a transfer '
              'must be net-zero across the pair.',
        ),
      );
    }

    if (leg.isIncome == partner.isIncome) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: sameDirection,
          message:
              'Both legs have isIncome=${leg.isIncome}; one must be the outgoing '
              'side and the other the incoming side.',
        ),
      );
    }

    if (leg.walletId == partner.walletId) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: sameWallet,
          message: 'Both legs target wallet ${leg.walletId}.',
        ),
      );
    }

    if ((leg.deletedAt == null) != (partner.deletedAt == null)) {
      issues.add(
        TransferIntegrityIssue(
          transactionId: leg.id,
          code: partnerDeleted,
          message:
              'Exactly one leg is deleted; a transfer must be present or absent '
              'as a whole.',
        ),
      );
    }

    return issues;
  }
}

/// Service for managing wallet-to-wallet transfers.
///
/// Transfers are implemented as paired transactions (like Cashew):
/// - one expense from the source wallet,
/// - one income to the destination wallet,
/// linked in both directions via `pairedTransactionId`.
///
/// Every mutation here runs inside a single Drift transaction that covers BOTH
/// rows and BOTH wallet balances. Previously each leg was written with its own
/// statement and the balances were adjusted separately by the caller, so an
/// interruption (or an exception on the second insert) could leave a half
/// transfer and a wallet balance that no longer matched its transactions.
class TransferService {
  final AppDatabase _db;
  final WalletBalanceService _balances;

  TransferService(this._db) : _balances = WalletBalanceService(_db);

  /// Create a transfer between two wallets.
  ///
  /// Returns `(expenseTransactionId, incomeTransactionId)`.
  Future<(String, String)> createTransfer({
    required String sourceWalletId,
    required String destinationWalletId,
    required int amount, // integer minor units / cents
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

    return _db.transaction(() async {
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

      // Resolved by slug, not by a hard-coded id: category ids are random per
      // install because the backend's category key is global.
      final transferCategoryId = await _db.requireSystemCategoryId(
        SystemCategories.transferKey,
      );

      // Leg 1: expense from source wallet.
      await _db.addTransaction(
        _legCompanion(
          id: expenseId,
          partnerId: incomeId,
          walletId: sourceWalletId,
          isIncome: false,
          amount: amount,
          title: transferTitle,
          notes: notes,
          date: date,
          now: now,
          categoryId: transferCategoryId,
        ),
      );

      // Leg 2: income to destination wallet.
      await _db.addTransaction(
        _legCompanion(
          id: incomeId,
          partnerId: expenseId,
          walletId: destinationWalletId,
          isIncome: true,
          amount: amount,
          title: transferTitle,
          notes: notes,
          date: date,
          now: now,
          categoryId: transferCategoryId,
        ),
      );

      await _recalculate({sourceWalletId, destinationWalletId});

      return (expenseId, incomeId);
    });
  }

  TransactionsCompanion _legCompanion({
    required String id,
    required String partnerId,
    required String walletId,
    required bool isIncome,
    required int amount,
    required String title,
    required String? notes,
    required DateTime date,
    required DateTime now,
    required String categoryId,
  }) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      isIncome: Value(isIncome),
      title: Value(title),
      notes: Value(notes),
      date: Value(date),
      // A real, synchronizable UUID category — the old `transfer-category-0`
      // sentinel is not a GUID and the backend rejected every transfer using it.
      categoryId: Value(categoryId),
      walletId: Value(walletId),
      transactionType: Value(TransactionPolicy.transferType),
      pairedTransactionId: Value(partnerId),
      isPaid: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pendingCreate),
    );
  }

  /// Update an existing transfer. Both legs change together, in one database
  /// transaction, and every wallet touched (old and new) is recalculated.
  ///
  /// Reciprocal ids, equal amounts, opposite directions, and the shared
  /// title/notes/date are preserved by construction.
  Future<void> updateTransfer({
    required String transactionId,
    int? amount, // integer minor units / cents
    DateTime? date,
    String? notes,
    String? title,
    String? sourceWalletId,
    String? destinationWalletId,
  }) async {
    if (amount != null && amount <= 0) {
      throw ArgumentError('Transfer amount must be positive');
    }

    await _db.transaction(() async {
      final transaction = await _db.findTransactionById(transactionId);
      if (transaction == null) {
        throw Exception('Transaction not found: $transactionId');
      }
      if (transaction.pairedTransactionId == null) {
        throw Exception(
          'Transaction is not a transfer (no paired transaction)',
        );
      }

      final pairedTransaction = await _db.findTransactionById(
        transaction.pairedTransactionId!,
      );
      if (pairedTransaction == null) {
        throw Exception(
          'Paired transaction ${transaction.pairedTransactionId} not found; '
          'refusing to edit half a transfer.',
        );
      }

      // Identify the two legs by direction, not by which one the user tapped.
      final (expenseTxn, incomeTxn) = transaction.isIncome
          ? (pairedTransaction, transaction)
          : (transaction, pairedTransaction);

      final newSourceWalletId = sourceWalletId ?? expenseTxn.walletId;
      final newDestinationWalletId = destinationWalletId ?? incomeTxn.walletId;
      if (newSourceWalletId == newDestinationWalletId) {
        throw ArgumentError('Source and destination wallets must be different');
      }

      final now = DateTime.now();
      final transferCategoryId = await _db.requireSystemCategoryId(
        SystemCategories.transferKey,
      );
      final newAmount = amount ?? expenseTxn.amount;
      final newDate = date ?? expenseTxn.date;
      final newTitle = title ?? expenseTxn.title;
      final newNotes = notes ?? expenseTxn.notes;

      await _writeLeg(
        existing: expenseTxn,
        partnerId: incomeTxn.id,
        walletId: newSourceWalletId,
        isIncome: false,
        amount: newAmount,
        title: newTitle,
        notes: newNotes,
        date: newDate,
        now: now,
        categoryId: transferCategoryId,
      );
      await _writeLeg(
        existing: incomeTxn,
        partnerId: expenseTxn.id,
        walletId: newDestinationWalletId,
        isIncome: true,
        amount: newAmount,
        title: newTitle,
        notes: newNotes,
        date: newDate,
        now: now,
        categoryId: transferCategoryId,
      );

      await _recalculate({
        expenseTxn.walletId,
        incomeTxn.walletId,
        newSourceWalletId,
        newDestinationWalletId,
      });
    });
  }

  Future<void> _writeLeg({
    required Transaction existing,
    required String partnerId,
    required String walletId,
    required bool isIncome,
    required int amount,
    required String title,
    required String? notes,
    required DateTime date,
    required DateTime now,
    required String categoryId,
  }) async {
    await (_db.update(
      _db.transactions,
    )..where((t) => t.id.equals(existing.id))).write(
      TransactionsCompanion(
        amount: Value(amount),
        isIncome: Value(isIncome),
        title: Value(title),
        notes: Value(notes),
        date: Value(date),
        categoryId: Value(categoryId),
        walletId: Value(walletId),
        transactionType: Value(TransactionPolicy.transferType),
        pairedTransactionId: Value(partnerId),
        isPaid: const Value(true),
        updatedAt: Value(now),
        // A row that was still pending-create must stay pending-create, or the
        // server would receive an update for a record it has never seen.
        syncStatus: Value(
          existing.syncStatus == SyncStatus.pendingCreate
              ? SyncStatus.pendingCreate
              : SyncStatus.pendingUpdate,
        ),
      ),
    );
  }

  /// Delete a transfer: tombstones BOTH legs and recalculates BOTH wallets, in
  /// one database transaction, so the pair can never be half-deleted and no
  /// wallet is left holding a one-sided balance effect.
  Future<void> deleteTransfer(String transactionId) async {
    await _db.transaction(() async {
      final transaction = await _db.findTransactionById(transactionId);
      if (transaction == null) {
        throw Exception('Transaction not found: $transactionId');
      }

      final affectedWallets = <String>{transaction.walletId};

      if (transaction.pairedTransactionId != null) {
        final partner = await _db.findTransactionById(
          transaction.pairedTransactionId!,
        );
        if (partner != null) {
          affectedWallets.add(partner.walletId);
          // Soft-delete so the deletion is pushed to the server; a hard delete
          // would never propagate and the row would resurrect on a full pull.
          await _db.softDeleteTransaction(partner.id);
        }
      }

      await _db.softDeleteTransaction(transactionId);
      await _recalculate(affectedWallets);
    });
  }

  /// Recompute and persist the balance of every wallet in [walletIds].
  ///
  /// Deriving the balance from the surviving transactions (rather than applying
  /// a delta) makes the operation idempotent and keeps it correct no matter what
  /// combination of amount, direction, and wallet changed.
  Future<void> _recalculate(Set<String> walletIds) async {
    for (final walletId in walletIds) {
      await _balances.updateWalletBalance(walletId);
    }
  }

  /// Get all transfer transactions (live rows only).
  Future<List<Transaction>> getTransferTransactions() async {
    final allTransactions = await _db.getAllTransactions();
    return allTransactions.where(TransactionPolicy.isTransfer).toList();
  }

  /// Get the paired transaction for a transfer.
  Future<Transaction?> getPairedTransaction(String transactionId) async {
    final transaction = await _db.findTransactionById(transactionId);
    if (transaction?.pairedTransactionId == null) return null;
    return _db.findTransactionById(transaction!.pairedTransactionId!);
  }

  /// Whether [transactionId] is one leg of a transfer.
  Future<bool> isTransfer(String transactionId) async {
    final transaction = await _db.findTransactionById(transactionId);
    return transaction != null && TransactionPolicy.isTransfer(transaction);
  }

  /// Validate every live transfer leg in the database.
  ///
  /// Used by the integrity check in settings and by tests; a healthy database
  /// returns an empty list.
  Future<List<TransferIntegrityIssue>> validateAllTransfers() async {
    final legs = await getTransferTransactions();
    final byId = {for (final t in legs) t.id: t};
    final issues = <TransferIntegrityIssue>[];
    for (final leg in legs) {
      final partnerId = leg.pairedTransactionId;
      final partner = partnerId == null
          ? null
          : byId[partnerId] ?? await _db.findTransactionById(partnerId);
      issues.addAll(TransferIntegrity.validatePair(leg, partner));
    }
    return issues;
  }

  /// Repair transfer pairs that arrived inconsistent from another device.
  ///
  /// Conflict rule: **delete wins**. If device A deletes a transfer while device
  /// B edits it, both devices converge on "deleted" — a surviving half-transfer
  /// would misreport one wallet's balance forever, whereas a lost edit only
  /// costs the user a re-entry.
  ///
  /// This deliberately acts ONLY on a leg whose partner is present and
  /// explicitly tombstoned. A partner that is simply *absent* is left alone: it
  /// may just not have been pulled yet (a partial sync, a mid-restore state),
  /// and tombstoning it would push a delete for a record the server still holds
  /// intact. Those cases surface through [validateAllTransfers] instead, where
  /// they are visible without being destructive.
  ///
  /// Returns the number of legs tombstoned.
  Future<int> reconcileTransferPairs() async {
    final legs = await getTransferTransactions();
    if (legs.isEmpty) return 0;

    var repaired = 0;
    final affectedWallets = <String>{};

    for (final leg in legs) {
      final partnerId = leg.pairedTransactionId;
      if (partnerId == null) continue;

      final partner = await _db.findTransactionById(partnerId);
      // Absent (not yet pulled) -> leave it; deleted -> follow the deletion.
      if (partner == null || partner.deletedAt == null) continue;

      await _db.softDeleteTransaction(leg.id);
      affectedWallets.add(leg.walletId);
      repaired++;
    }

    for (final walletId in affectedWallets) {
      await _balances.updateWalletBalance(walletId);
    }
    return repaired;
  }
}
