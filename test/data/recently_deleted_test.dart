import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// Putting back something deleted by mistake.
///
/// The rows are already there: a delete is soft, and the server sweep only
/// removes them for good after thirty days. Nothing surfaced that, so a mis-tap
/// on a delete confirmation meant re-typing the entry from memory.
///
/// The part worth pinning is the sync status. A restored row that had never
/// reached the server must go back to being a create; pushing an update for a
/// row the server has no record of is rejected every single time.
void main() {
  late AppDatabase db;
  late String walletId;

  setUp(() async {
    db = openTestDatabase();
    walletId = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
  });

  tearDown(() => db.close());

  test('a deleted transaction shows up in the list', () async {
    final id = await seedTransaction(
      db,
      walletId: walletId,
      amount: 2500,
      title: 'Lunch',
    );
    await db.softDeleteTransaction(id);

    final deleted = await db.getRecentlyDeletedTransactions();

    expect(deleted, hasLength(1));
    expect(deleted.single.id, id);
    expect(deleted.single.title, 'Lunch');
  });

  test('a live transaction does not', () async {
    await seedTransaction(db, walletId: walletId, amount: 2500);

    expect(await db.getRecentlyDeletedTransactions(), isEmpty);
  });

  test('something deleted long ago has aged out of the list', () async {
    final id = await seedTransaction(db, walletId: walletId, amount: 2500);
    await db.softDeleteTransaction(id);
    // Older than the window the server keeps them for.
    await db.customStatement(
      'UPDATE transactions SET deleted_at = ? WHERE id = ?',
      [
        DateTime.now()
                .subtract(const Duration(days: 40))
                .millisecondsSinceEpoch ~/
            1000,
        id,
      ],
    );

    expect(await db.getRecentlyDeletedTransactions(), isEmpty);
  });

  test('restoring brings it back to the live list', () async {
    final id = await seedTransaction(db, walletId: walletId, amount: 2500);
    await db.softDeleteTransaction(id);

    await db.restoreTransaction(id);

    expect(await db.getRecentlyDeletedTransactions(), isEmpty);
    final row = await db.findTransactionById(id);
    expect(row!.deletedAt, isNull);
  });

  test('a row that had reached the server comes back as a create', () async {
    final id = await seedTransaction(
      db,
      walletId: walletId,
      amount: 2500,
      syncStatus: SyncStatus.synced,
    );
    await db.softDeleteTransaction(id);

    await db.restoreTransaction(id);

    expect(
      (await db.findTransactionById(id))!.syncStatus,
      SyncStatus.pendingCreate,
      reason:
          'a restore is pushed as a create whether or not the server already '
          'holds the row: a create is idempotent for a row it has and lifts '
          'the tombstone on one it deleted, while an update is answered "not '
          'found" for a row it never saw. One shape covers both, and the '
          'device cannot always tell which case it is in',
    );
  });

  test('a row that never reached the server comes back as a create', () async {
    final id = await seedTransaction(
      db,
      walletId: walletId,
      amount: 2500,
      syncStatus: SyncStatus.pendingCreate,
    );
    await db.softDeleteTransaction(id);

    await db.restoreTransaction(id);

    // This used to accept either create or update, which is what let the
    // defect through: an update for a row the server has never held is
    // answered "not found" for ever, and only one of the two is right.
    expect(
      (await db.findTransactionById(id))!.syncStatus,
      SyncStatus.pendingCreate,
      reason: 'the server has never heard of this row; it has to be told it '
          'exists before it can be told anything else',
    );
  });

  test('a row the server holds is still deleted out loud', () async {
    final id = await seedTransaction(
      db,
      walletId: walletId,
      amount: 2500,
      syncStatus: SyncStatus.synced,
    );

    await db.softDeleteTransaction(id);

    expect(
      (await db.findTransactionById(id))!.syncStatus,
      SyncStatus.pendingDelete,
      reason:
          'the cloud copy outlives the local one unless the deletion is '
          'actually pushed',
    );
  });

  test('restoring something that is not there does nothing', () async {
    await db.restoreTransaction('no-such-row');
    expect(await db.getRecentlyDeletedTransactions(), isEmpty);
  });

  /// What eventually clears the list.
  ///
  /// Tombstones used to be removed by sync — an accepted delete hard-deleted
  /// the local row — which emptied Recently Deleted on the next push rather
  /// than after the thirty days the screen promises. Age is the only thing
  /// that removes them now, so age has to actually remove them.
  group('the thirty-day sweep', () {
    /// Stands in for the push that the server accepted.
    Future<void> acknowledgeDeletion(String id) => db.customStatement(
      'UPDATE transactions SET sync_status = ? WHERE id = ?',
      [SyncStatus.synced, id],
    );

    Future<void> backdateDeletion(String id, Duration ago) => db.customStatement(
      'UPDATE transactions SET deleted_at = ? WHERE id = ?',
      [
        DateTime.now().subtract(ago).millisecondsSinceEpoch ~/ 1000,
        id,
      ],
    );

    test('leaves a tombstone still inside the window', () async {
      final id = await seedTransaction(
        db,
        walletId: walletId,
        amount: 2500,
        syncStatus: SyncStatus.synced,
      );
      await db.softDeleteTransaction(id);
      await acknowledgeDeletion(id);
      await backdateDeletion(id, const Duration(days: 29));

      expect(await db.purgeExpiredTombstones(), 0);
      expect(await db.findTransactionById(id), isNotNull);
    });

    test('removes one that has aged out', () async {
      final id = await seedTransaction(
        db,
        walletId: walletId,
        amount: 2500,
        syncStatus: SyncStatus.synced,
      );
      await db.softDeleteTransaction(id);
      await acknowledgeDeletion(id);
      await backdateDeletion(id, const Duration(days: 31));

      expect(await db.purgeExpiredTombstones(), 1);
      expect(await db.findTransactionById(id), isNull);
    });

    test('keeps an aged tombstone the server has not acknowledged', () async {
      final id = await seedTransaction(
        db,
        walletId: walletId,
        amount: 2500,
        syncStatus: SyncStatus.synced,
      );
      await db.softDeleteTransaction(id);
      await backdateDeletion(id, const Duration(days: 400));

      expect(
        await db.purgeExpiredTombstones(),
        0,
        reason:
            'dropping a delete that was never pushed leaves the cloud copy '
            'alive with nothing left to say it should not be',
      );
    });

    test('never touches a live row, however old', () async {
      final id = await seedTransaction(
        db,
        walletId: walletId,
        amount: 2500,
        date: DateTime(2019),
        syncStatus: SyncStatus.synced,
      );

      expect(await db.purgeExpiredTombstones(), 0);
      expect(await db.findTransactionById(id), isNotNull);
    });
  });
}
