import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// The counter that says whether a row still holds the version we last pushed.
///
/// Maintained by triggers rather than by the call sites, because the write path
/// nobody remembers to update is exactly the one that then loses an edit.
void main() {
  late AppDatabase db;
  late String wallet;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db, name: 'Everyday');
  });

  tearDown(() => db.close());

  test('a new row starts with a version', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 1000);

    expect(await db.rowRevision('transactions', id), isNotNull);
  });

  test('every write moves it on', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 1000);
    final first = (await db.rowRevision('transactions', id))!;

    await db.softDeleteTransaction(id);
    final second = (await db.rowRevision('transactions', id))!;

    await db.restoreTransaction(id);
    final third = (await db.rowRevision('transactions', id))!;

    expect(second, greaterThan(first));
    expect(third, greaterThan(second));
  });

  test('a write through raw SQL counts too', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 1000);
    final before = (await db.rowRevision('transactions', id))!;

    await db.customStatement('UPDATE transactions SET amount = 5 WHERE id = ?', [
      id,
    ]);

    expect(
      await db.rowRevision('transactions', id),
      greaterThan(before),
      reason: 'the point of a trigger is that it does not depend on the writer '
          'remembering',
    );
  });

  test('every synced table is counted', () async {
    for (final table in AppDatabase.syncedTableNames) {
      final triggers = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'trigger' "
            "AND name LIKE 'trg_${table}_row_version_%'",
          )
          .get();

      expect(
        triggers.length,
        2,
        reason: '$table needs one for inserts and one for updates, or a row '
            'in it can be edited mid-push without anything noticing',
      );
    }
  });

  group('clearing a pending flag', () {
    test('takes effect while the row is unchanged', () async {
      final id = await seedTransaction(db, walletId: wallet, amount: 1000);
      final revision = (await db.rowRevision('transactions', id))!;

      await db.markSyncedIfUnchanged(
        table: 'transactions',
        id: id,
        revision: revision,
      );

      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.synced,
      );
    });

    test('does nothing once the row has moved on', () async {
      final id = await seedTransaction(db, walletId: wallet, amount: 1000);
      final revision = (await db.rowRevision('transactions', id))!;

      // The edit that arrives while the push is in flight.
      await db.customStatement(
        'UPDATE transactions SET amount = 9900 WHERE id = ?',
        [id],
      );

      await db.markSyncedIfUnchanged(
        table: 'transactions',
        id: id,
        revision: revision,
      );

      expect(
        (await db.findTransactionById(id))!.syncStatus,
        isNot(SyncStatus.synced),
        reason: 'marking it synced would say the server has the 9900 it has '
            'never been shown, and the next pull would erase it',
      );
    });

    test('an unknown table is refused rather than interpolated', () async {
      await db.markSyncedIfUnchanged(
        table: 'transactions; DROP TABLE wallets',
        id: 'x',
        revision: 1,
      );

      expect(await db.getAllWallets(), isNotEmpty);
    });
  });
}
