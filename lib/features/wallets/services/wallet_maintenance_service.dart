import 'package:drift/drift.dart' show Value;
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

/// The two things people need to do to an account that are not editing it.
///
/// Both existed in Cashew and in neither place here: a balance that has drifted
/// from the bank's could only be fixed by hunting the missing transaction, and
/// an account created by mistake could only be deleted, taking its history with
/// it.
class WalletMaintenanceService {
  final AppDatabase _db;
  final WalletBalanceService _balances;
  final CurrencyService _currency;

  WalletMaintenanceService(this._db)
    : _balances = WalletBalanceService(_db),
      _currency = CurrencyService(_db);

  /// Make [walletId] read [actualBalance] by recording the difference.
  ///
  /// The gap is written as an ordinary transaction against the built-in balance
  /// correction category rather than by overwriting the stored balance. A
  /// balance here is the sum of what happened; setting it directly would make
  /// the account disagree with its own transactions, and the next full
  /// recalculation would silently undo the fix. Recorded as a row, the
  /// correction survives, and the user can see that a correction is what it was.
  ///
  /// Returns the id of the adjusting transaction, or null when nothing needed
  /// adjusting.
  Future<String?> correctBalance({
    required String walletId,
    required int actualBalance,
    DateTime? date,
  }) async {
    final wallet = await _db.findWalletById(walletId);
    if (wallet == null) {
      throw ArgumentError('No such account: $walletId');
    }

    final difference = actualBalance - wallet.balance;
    if (difference == 0) return null;

    final categoryId = await _db.requireSystemCategoryId(
      SystemCategories.balanceCorrectionKey,
    );

    final id = const Uuid().v4();
    final now = DateTime.now();

    await _db.addTransaction(
      TransactionsCompanion.insert(
        id: id,
        amount: difference.abs(),
        title: const Value('Balance correction'),
        notes: Value('Adjusted ${wallet.name} to match its real balance.'),
        date: date ?? now,
        // A shortfall is money that left without being recorded, and a surplus
        // is money that arrived the same way.
        isIncome: Value(difference > 0),
        categoryId: Value(categoryId),
        walletId: walletId,
        isPaid: const Value(true),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    await _balances.updateWalletBalance(walletId);
    return id;
  }

  /// Move everything from [sourceId] into [destinationId], then close the source.
  ///
  /// Amounts are converted when the two accounts are held in different
  /// currencies, because the figures mean different things once they land
  /// somewhere else. The source is archived rather than deleted: deleting it
  /// would take the rows that have just been moved, and archiving leaves a
  /// visible trace of what happened.
  ///
  /// Transfers are moved as pairs, not as rows. Moving each row on its own
  /// broke them two ways. A transfer *between* the two accounts being merged
  /// ended with both of its legs on one wallet — money leaving an account and
  /// arriving in the same account, which is not a transfer and which the server
  /// refuses; the wallet edits synced and the transaction edits did not, so the
  /// two copies disagreed from then on. And converting one leg of a
  /// cross-currency transfer rewrote its amount while leaving the partner's
  /// `counterAmount` and the shared `fxRate` describing the old figure, so the
  /// pair no longer agreed on how much had crossed.
  ///
  /// Recurring configurations need no repointing: they name a base transaction
  /// rather than a wallet, and that transaction moves with everything else.
  Future<WalletMergeResult> mergeInto({
    required String sourceId,
    required String destinationId,
  }) async {
    if (sourceId == destinationId) {
      throw ArgumentError('An account cannot be merged into itself.');
    }

    final source = await _db.findWalletById(sourceId);
    final destination = await _db.findWalletById(destinationId);
    if (source == null || destination == null) {
      throw ArgumentError('Both accounts must exist to merge them.');
    }

    final rows = (await _db.getAllTransactions())
        .where((t) => t.walletId == sourceId)
        .toList();

    // Worked out once, outside the write, so every row moves at the same rate
    // and the merged total is the one the user was shown.
    double rate = 1;
    if (source.currency != destination.currency) {
      rate = await _currency.convert(1, source.currency, destination.currency);
      if (rate <= 0) {
        throw ArgumentError(
          'No rate is known between ${source.currency} and '
          '${destination.currency}, so these accounts cannot be merged yet.',
        );
      }
    }

    var moved = 0;
    var transfersRemoved = 0;
    final touchedWallets = <String>{sourceId, destinationId};

    await _db.transaction(() async {
      // Legs of transfers that collapse, so the move below skips rows it is
      // about to delete.
      final collapsing = <String>{};

      for (final row in rows) {
        final partnerId = row.pairedTransactionId;
        if (partnerId == null || collapsing.contains(row.id)) continue;

        final partner = await _db.findTransactionById(partnerId);
        if (partner == null || partner.walletId != destinationId) continue;

        // Both ends land in one account. The two legs cancel each other out
        // within it, so removing the pair moves no balance — and a transfer
        // from an account to itself has nothing left to mean.
        collapsing
          ..add(row.id)
          ..add(partnerId);
        transfersRemoved++;

        for (final legId in [row.id, partnerId]) {
          final fee = await _db.findFeeForTransfer(legId);
          if (fee != null) {
            touchedWallets.add(fee.walletId);
            await _db.softDeleteTransaction(fee.id);
          }
          await _db.softDeleteTransaction(legId);
        }
      }

      for (final row in rows) {
        if (collapsing.contains(row.id)) continue;

        await (_db.update(
          _db.transactions,
        )..where((t) => t.id.equals(row.id))).write(
          TransactionsCompanion(
            walletId: Value(destinationId),
            amount: Value(rate == 1 ? row.amount : (row.amount * rate).round()),
            updatedAt: Value(DateTime.now()),
          ),
        );
        await _db.customStatement(
          'UPDATE transactions SET sync_status = ${SyncStatus.markEditedSql} '
          'WHERE id = ?',
          [row.id],
        );
        moved++;

        if (rate != 1 && row.pairedTransactionId != null) {
          await _realignTransferPair(row.id, row.pairedTransactionId!);
        }
      }

      // The source keeps whatever it opened with, converted, so the destination
      // ends up holding what the two held between them.
      final carriedOpening = rate == 1
          ? source.openingBalance
          : (source.openingBalance * rate).round();

      await (_db.update(
        _db.wallets,
      )..where((w) => w.id.equals(destinationId))).write(
        WalletsCompanion(
          openingBalance: Value(destination.openingBalance + carriedOpening),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await (_db.update(
        _db.wallets,
      )..where((w) => w.id.equals(sourceId))).write(
        WalletsCompanion(
          isArchived: const Value(true),
          openingBalance: const Value(0),
          isDefault: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _db.customStatement(
        'UPDATE wallets SET sync_status = ${SyncStatus.markEditedSql} '
        'WHERE id IN (?, ?)',
        [sourceId, destinationId],
      );
    });

    for (final walletId in touchedWallets) {
      await _balances.updateWalletBalance(walletId);
    }
    return WalletMergeResult(moved: moved, transfersRemoved: transfersRemoved);
  }

  /// Make a moved transfer leg and its partner agree again.
  ///
  /// Called after the leg's amount has been converted into the destination's
  /// currency. The two legs of a transfer are one movement described twice, so
  /// changing what one of them says obliges the other to say the same thing.
  Future<void> _realignTransferPair(String legId, String partnerId) async {
    final leg = await _db.findTransactionById(legId);
    final partner = await _db.findTransactionById(partnerId);
    if (leg == null || partner == null) return;

    final legWallet = await _db.findWalletById(leg.walletId);
    final partnerWallet = await _db.findWalletById(partner.walletId);
    if (legWallet == null || partnerWallet == null) return;

    if (legWallet.currency == partnerWallet.currency) {
      // The move landed the leg in the partner's own currency, so the transfer
      // is no longer a crossing and carries one figure again. The partner's is
      // the one to keep: it is what that account actually saw, and rewriting it
      // instead would restate the history of a wallet this merge never touched.
      await _rewrite(
        legId,
        TransactionsCompanion(
          amount: Value(partner.amount),
          fxRate: const Value(null),
          counterAmount: const Value(null),
        ),
      );
      await _rewrite(
        partnerId,
        const TransactionsCompanion(
          fxRate: Value(null),
          counterAmount: Value(null),
        ),
      );
      return;
    }

    // Still a crossing, at the rate the two amounts now imply. Derived from the
    // pair rather than looked up, so the stored rate always explains the two
    // figures beside it exactly — the rule `TransferService` follows too.
    final sent = leg.isIncome ? partner.amount : leg.amount;
    final received = leg.isIncome ? leg.amount : partner.amount;
    final fxRate = sent == 0 ? null : received / sent;

    await _rewrite(
      legId,
      TransactionsCompanion(
        fxRate: Value(fxRate),
        counterAmount: Value(partner.amount),
      ),
    );
    await _rewrite(
      partnerId,
      TransactionsCompanion(
        fxRate: Value(fxRate),
        counterAmount: Value(leg.amount),
      ),
    );
  }

  Future<void> _rewrite(String id, TransactionsCompanion changes) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      changes.copyWith(updatedAt: Value(DateTime.now())),
    );
    await _db.customStatement(
      'UPDATE transactions SET sync_status = ${SyncStatus.markEditedSql} '
      'WHERE id = ?',
      [id],
    );
  }
}

/// What a merge did, beyond closing one account.
class WalletMergeResult {
  /// How many transactions were re-filed against the destination.
  final int moved;

  /// How many transfers between the two accounts were removed.
  ///
  /// Reported rather than done quietly: those rows leave the ledger, and
  /// someone who is not told will read that as the merge having lost them.
  final int transfersRemoved;

  const WalletMergeResult({
    required this.moved,
    required this.transfersRemoved,
  });
}
