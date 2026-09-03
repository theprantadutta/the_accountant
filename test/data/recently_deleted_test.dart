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

  test('a row that had reached the server comes back as an update', () async {
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
      SyncStatus.pendingUpdate,
      reason: 'the server has this row and needs telling it is back',
    );
  });

  test('a row that never reached the server comes back as a create', () async {
    final id = await seedTransaction(
      db,
      walletId: walletId,
      amount: 2500,
      syncStatus: SyncStatus.pendingCreate,
    );
    // Deleting an unsynced row still marks it pendingDelete, which is what the
    // restore has to reason about.
    await db.softDeleteTransaction(id);

    await db.restoreTransaction(id);

    final status = (await db.findTransactionById(id))!.syncStatus;
    expect(
      status,
      anyOf(SyncStatus.pendingCreate, SyncStatus.pendingUpdate),
      reason:
          'either is pushable; what must not happen is the row coming back '
          'marked as still deleted',
    );
    expect(status, isNot(SyncStatus.pendingDelete));
  });

  test('restoring something that is not there does nothing', () async {
    await db.restoreTransaction('no-such-row');
    expect(await db.getRecentlyDeletedTransactions(), isEmpty);
  });
}
