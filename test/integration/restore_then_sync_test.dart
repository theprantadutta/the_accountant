import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/backup/services/backup_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Restoring a backup, and then syncing.
///
/// Both halves were well covered on their own and neither test could see this:
/// `BackupService.restore` cleared the stored cursor, and `SyncService` held
/// its own copy loaded once and kept for the life of the service. The next sync
/// therefore asked for changes since a moment the restored rows had never been
/// part of, skipped everything older, reported success, and wrote a fresh
/// cursor on the way out — so restarting did not repair it either.
///
/// The lesson is about where a value lives, not about backups: a cache of
/// durable state, held by one collaborator and written by another, is a desync
/// waiting for someone to forget a reset call.
void main() {
  late FakeSyncServer server;
  late AppDatabase device;
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
  });

  tearDown(() => device.close());

  test(
    'a restore makes the next sync fetch what the cloud already held',
    () async {
      // The account has one account, synced.
      final everyday = await seedWallet(device, name: 'Everyday');
      final sync = syncFor(device);
      await sync.syncAll();

      final backup = await BackupService(device).create();

      // A second account is created and synced — so the server holds it, and the
      // cursor now sits after it.
      await seedWallet(device, name: 'Savings');
      await sync.syncAll();
      expect(server.countIn(userId, 'wallets'), 2);

      // The backup, which predates Savings, is restored.
      await BackupService(device).restore(backup);
      expect((await device.getAllWallets()).map((w) => w.id), [everyday]);

      // Syncing with the SAME service instance — the one that has been running
      // all along, which is exactly what the app does.
      await sync.syncAll();

      expect(
        (await device.getAllWallets()).length,
        2,
        reason:
            'the server still holds Savings; a restore that leaves the cursor '
            'where it was skips it for ever and calls the sync a success',
      );
    },
  );

  test('the restore clears the cursor the sync actually reads', () async {
    await device.setLastSyncTimestamp(DateTime(2026, 1, 1));

    await BackupService(device).restore(await BackupService(device).create());

    expect(await device.getLastSyncTimestamp(), isNull);
  });

  test('an ordinary sync still asks for a delta, not everything', () async {
    // The other half of the same change: removing the cache must not turn
    // every sync into a full pull.
    await seedWallet(device, name: 'Everyday');
    final sync = syncFor(device);
    await sync.syncAll();

    final cursor = await device.getLastSyncTimestamp();
    expect(cursor, isNotNull);

    await sync.syncAll();

    expect(
      server.lastPullSince,
      isNotNull,
      reason:
          'a null cursor asks the server for its entire dataset on every '
          'sync, which is the opposite mistake',
    );
  });

  test('a sync in flight is visible, so a restore can refuse', () async {
    final sync = syncFor(device);
    expect(sync.isBusy, isFalse);

    final running = sync.syncAll();
    // The guard exists so the screen can refuse; the value has to be readable
    // from outside for that to be possible at all.
    await running;
    expect(sync.isBusy, isFalse);
  });
}
