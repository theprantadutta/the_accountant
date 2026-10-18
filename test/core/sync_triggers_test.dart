import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/connectivity_provider.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// A transport whose server can be made to fail, or to be unreachable.
class _FlakyTransport extends FakeSyncTransport {
  bool serverFails = false;
  bool unreachable = false;

  _FlakyTransport({required super.server, required super.userId});

  void _check() {
    if (unreachable) {
      throw const ApiException('Cannot connect to server.');
    }
    if (serverFails) {
      throw const ApiException('Request failed (HTTP 500).', statusCode: 500);
    }
  }

  @override
  Future<SyncPushResponse> push(List<SyncChange> changes) async {
    _check();
    return super.push(changes);
  }

  @override
  Future<SyncPullResponse> pull(DateTime? since) async {
    _check();
    return super.pull(since);
  }
}

void main() {
  group('SyncFailureStreak', () {
    SyncResult failed() => SyncResult.failure('Request failed (HTTP 500).');

    test('reports the first failure of a run and none of the retries', () {
      final streak = SyncFailureStreak();

      expect(streak.record(failed()), isTrue);
      expect(streak.record(failed()), isFalse);
      expect(streak.record(failed()), isFalse);
    });

    test('a success ends the run, so the next failure is news again', () {
      final streak = SyncFailureStreak();

      expect(streak.record(failed()), isTrue);
      expect(streak.record(SyncResult.success()), isFalse);
      expect(streak.record(failed()), isTrue);
    });

    test('never reports a sync that did not run', () {
      final streak = SyncFailureStreak();

      for (final reason in SyncNotRunReason.values) {
        expect(
          streak.record(SyncResult.notRun(reason, 'not run')),
          isFalse,
          reason: '$reason is not a failure',
        );
      }
      // Nor does one start a run: a real failure after it is still reported.
      expect(streak.record(failed()), isTrue);
    });

    test('a sync that did not run does not end a run either', () {
      final streak = SyncFailureStreak();

      expect(streak.record(failed()), isTrue);
      expect(
        streak.record(SyncResult.notRun(SyncNotRunReason.offline, 'offline')),
        isFalse,
      );
      expect(streak.record(failed()), isFalse);
    });

    test('records that failed to apply count as a failure', () {
      final streak = SyncFailureStreak();
      final partial = SyncResult.partial(
        applyFailures: const [
          SyncApplyFailure(
            tableName: 'transactions',
            entityId: 't1',
            reason: 'wallet w1 is not available locally',
          ),
        ],
      );

      expect(streak.record(partial), isTrue);
    });
  });

  group('automatic sync', () {
    late AppDatabase db;
    late FakeSyncServer server;
    late _FlakyTransport transport;
    late ProviderContainer container;

    ProviderContainer containerFor({required bool canSync}) =>
        ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            syncServiceProvider.overrideWithValue(
              SyncService(database: db, transport: transport),
            ),
            cloudSyncAllowedProvider.overrideWithValue(canSync),
            isOnlineProvider.overrideWithValue(true),
          ],
        );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = openTestDatabase();
      await db.claimLocalStore(userId: 'user-a');
      // An account that has synced before, so a successful sync here changes
      // nothing locally and has no screens to reload.
      await db.setLastSyncTimestamp(DateTime.utc(2025));
      server = FakeSyncServer();
      transport = _FlakyTransport(server: server, userId: 'user-a');
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    int notices() => container.read(syncFailureNoticeProvider);

    test('says nothing when it works', () async {
      container = containerFor(canSync: true);
      await seedWallet(db);

      await container
          .read(syncNotifierProvider.notifier)
          .triggerAutoSync(force: true);

      expect(server.countIn('user-a', 'wallets'), 1);
      expect(notices(), 0);
    });

    test('mentions a failure once, however often it is retried', () async {
      container = containerFor(canSync: true);
      final sync = container.read(syncNotifierProvider.notifier);
      transport.serverFails = true;

      await sync.triggerAutoSync(force: true);
      await sync.triggerAutoSync(force: true);
      await sync.triggerAutoSync(force: true);
      expect(notices(), 1);

      // Recovery ends the run; the next failure is a new one.
      transport.serverFails = false;
      await sync.triggerAutoSync(force: true);
      expect(notices(), 1);
      transport.serverFails = true;
      await sync.triggerAutoSync(force: true);
      expect(notices(), 2);
    });

    test('says nothing while offline', () async {
      container = containerFor(canSync: true);
      final sync = container.read(syncNotifierProvider.notifier);

      transport.online = false;
      await sync.triggerAutoSync(force: true);
      // Connectivity claims a network, but the server cannot be reached.
      transport.online = true;
      transport.unreachable = true;
      await sync.triggerAutoSync(force: true);

      expect(notices(), 0);
    });

    test('never runs for an account that does not sync', () async {
      container = containerFor(canSync: false);
      await seedWallet(db);
      transport.serverFails = true;

      await container
          .read(syncNotifierProvider.notifier)
          .triggerAutoSync(force: true);

      expect(server.countIn('user-a', 'wallets'), 0);
      expect(server.pullCount, 0);
      expect(notices(), 0);
    });
  });

  group('sync after a local edit', () {
    late AppDatabase db;
    late FakeSyncServer server;
    late ProviderContainer container;
    const delay = Duration(milliseconds: 60);

    Future<void> settle() => Future<void>.delayed(delay * 6);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      db = openTestDatabase();
      await db.claimLocalStore(userId: 'user-a');
      await db.setLastSyncTimestamp(DateTime.utc(2025));
      server = FakeSyncServer();
      container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          syncServiceProvider.overrideWithValue(
            SyncService(
              database: db,
              transport: FakeSyncTransport(server: server, userId: 'user-a'),
            ),
          ),
          cloudSyncAllowedProvider.overrideWithValue(true),
          isOnlineProvider.overrideWithValue(true),
          writeSyncDelayProvider.overrideWithValue(delay),
        ],
      );
      // Built, so it is listening for writes.
      container.read(syncNotifierProvider);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('uploads a burst of edits once, shortly after the last', () async {
      final walletId = await seedWallet(db);
      for (var i = 0; i < 3; i++) {
        await seedTransaction(db, walletId: walletId, title: 'Edit $i');
      }
      expect(server.receivedBatchSizes, isEmpty, reason: 'not straight away');

      await settle();

      expect(server.receivedBatchSizes, [4]);
      expect(server.countIn('user-a', 'transactions'), 3);
    });

    test('does not set itself off again with its own writes', () async {
      await seedWallet(db);
      await settle();
      expect(server.receivedBatchSizes, hasLength(1));

      await settle();
      await settle();

      expect(server.receivedBatchSizes, hasLength(1));
      expect(server.pullCount, 1);
    });
  });

  group('periodic sync', () {
    test('comes back after the app returns from the background', () async {
      SharedPreferences.setMockInitialValues({});
      final db = openTestDatabase();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          syncServiceProvider.overrideWithValue(
            SyncService(
              database: db,
              transport: FakeSyncTransport(
                server: FakeSyncServer(),
                userId: 'user-a',
                online: false,
              ),
            ),
          ),
          // Only the timer is under test; the catch-up sync resuming also
          // starts would outlive the database this test closes.
          cloudSyncAllowedProvider.overrideWithValue(false),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await db.close();
      });
      final sync = container.read(syncNotifierProvider.notifier);

      sync.startPeriodicSync();
      expect(sync.isPeriodicSyncRunning, isTrue);

      sync.onAppPaused();
      expect(sync.isPeriodicSyncRunning, isFalse);

      sync.onAppResumed();
      expect(sync.isPeriodicSyncRunning, isTrue);

      // Signing out is the one thing that stops it for good.
      sync.stopPeriodicSync();
      sync.onAppResumed();
      expect(sync.isPeriodicSyncRunning, isFalse);
    });
  });
}
