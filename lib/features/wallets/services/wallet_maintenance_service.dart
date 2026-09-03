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
  /// Returns how many transactions moved.
  Future<int> mergeInto({
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

    await _db.transaction(() async {
      for (final row in rows) {
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

    await _balances.updateWalletBalance(sourceId);
    await _balances.updateWalletBalance(destinationId);
    return rows.length;
  }
}
