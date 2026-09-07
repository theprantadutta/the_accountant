import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Putting back something deleted, and making it stay back.
///
/// Recently Deleted and sync were each covered on their own, and the seam
/// between them held two separate defects. A row created and deleted before it
/// ever reached the server came back asking the server to update something it
/// had never seen — answered "not found" every time, for ever. And a row the
/// server did hold came back locally while staying tombstoned in the cloud, so
/// the next pull deleted it again: the user watched it return and then vanish.
void main() {
  late FakeSyncServer server;
  late AppDatabase device;
  late String wallet;
  const userId = 'restore-user';

  SyncService syncFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: userId),
  );

  setUp(() async {
    server = FakeSyncServer();
    device = openTestDatabase();
    await device.claimLocalStore(userId: userId);
    await device.ensureSystemCategoriesExist();
    wallet = await seedWallet(device, name: 'Everyday');
  });

  tearDown(() => device.close());

  group('a row the server has never seen', () {
    test('comes back asking to be created, not updated', () async {
      final id = await seedTransaction(device, walletId: wallet, amount: 2500);
      await device.softDeleteTransaction(id);

      await device.restoreTransaction(id);

      expect(
        (await device.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingCreate,
        reason:
            'an update for a row the server has never held is answered "not '
            'found" on every retry, and the record never leaves the device',
      );
    });

    test('and actually reaches the cloud on the next sync', () async {
      final id = await seedTransaction(device, walletId: wallet, amount: 2500);
      await device.softDeleteTransaction(id);
      await device.restoreTransaction(id);

      await syncFor(device).syncAll();

      expect(server.holds(userId, 'transactions', id), isTrue);
      expect(server.isTombstoned(userId, 'transactions', id), isFalse);
    });
  });

  group('a row the server already holds', () {
    test('the deletion reaches the cloud first', () async {
      final id = await seedTransaction(device, walletId: wallet, amount: 2500);
      final sync = syncFor(device);
      await sync.syncAll();

      await device.softDeleteTransaction(id);
      await sync.syncAll();

      expect(server.isTombstoned(userId, 'transactions', id), isTrue);
    });

    test('restoring it lifts the tombstone in the cloud too', () async {
      final id = await seedTransaction(device, walletId: wallet, amount: 2500);
      final sync = syncFor(device);
      await sync.syncAll();
      await device.softDeleteTransaction(id);
      await sync.syncAll();

      await device.restoreTransaction(id);
      await sync.syncAll();

      expect(
        server.isTombstoned(userId, 'transactions', id),
        isFalse,
        reason:
            'a row left tombstoned in the cloud is deleted again by the very '
            'next pull, so the restore only appears to have worked',
      );
    });

    test('and it survives the pull that follows', () async {
      final id = await seedTransaction(device, walletId: wallet, amount: 2500);
      final sync = syncFor(device);
      await sync.syncAll();
      await device.softDeleteTransaction(id);
      await sync.syncAll();
      await device.restoreTransaction(id);
      await sync.syncAll();

      // The sync after the one that pushed the restore is where it used to
      // come undone.
      await sync.syncAll();

      final row = await device.findTransactionById(id);
      expect(row, isNotNull);
      expect(row!.deletedAt, isNull);
    });

    test('a second device sees it come back', () async {
      final id = await seedTransaction(device, walletId: wallet, amount: 2500);
      final sync = syncFor(device);
      await sync.syncAll();
      await device.softDeleteTransaction(id);
      await sync.syncAll();

      // A device that has never held the row is not sent a tombstone for it,
      // so it simply has nothing — which is the state that matters here.
      final other = openTestDatabase();
      addTearDown(other.close);
      await other.claimLocalStore(userId: userId);
      await syncFor(other).syncAll();
      expect(await other.findTransactionById(id), isNull);

      await device.restoreTransaction(id);
      await sync.syncAll();
      await syncFor(other).syncAll();

      final row = await other.findTransactionById(id);
      expect(row, isNotNull);
      expect(row!.deletedAt, isNull);
    });
  });

  test('a stale replay cannot undo a newer deletion', () async {
    // The rule that keeps resurrection honest. One device deletes; another,
    // offline with an older copy, pushes it as live. Last-write-wins, so the
    // deletion stands.
    final id = await seedTransaction(device, walletId: wallet, amount: 2500);
    final sync = syncFor(device);
    await sync.syncAll();
    await device.softDeleteTransaction(id);
    await sync.syncAll();

    server.push(userId, [
      SyncChange(
        tableName: 'transactions',
        entityId: id,
        operation: 'create',
        data: {
          'Id': id,
          'WalletId': wallet,
          'Amount': 2500,
          'Title': 'Stale',
          'Date': DateTime(2020).toIso8601String(),
          'IsIncome': false,
          'IsPaid': true,
          'UpdatedAt': DateTime(2020).toIso8601String(),
        },
      ),
    ]);

    expect(
      server.isTombstoned(userId, 'transactions', id),
      isTrue,
      reason:
          'a device replaying an old create must not undo a deletion another '
          'device made afterwards',
    );
  });
}
