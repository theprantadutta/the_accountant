import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// The pull cursor only ever moves forward, so what it does when a record
/// cannot be applied decides whether data is recoverable or gone.
///
/// Two opposite failures are pinned here. A budget with no wallet or category
/// scope used to wedge sync outright: the server omits null values rather than
/// sending them, the client wrote that absent key into a NOT NULL column, the
/// write threw, and because a failed apply holds the cursor back, every later
/// sync replayed the same doomed batch. Conversely, a table this build has
/// never heard of used to be dropped on the floor while the cursor advanced
/// past it, so those rows were never offered again and simply went missing.
void main() {
  late FakeSyncServer server;
  late AppDatabase deviceA;
  late AppDatabase deviceB;

  const user = 'user-a';

  SyncService serviceFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: user),
  );

  setUp(() async {
    server = FakeSyncServer();
    deviceA = openTestDatabase();
    deviceB = openTestDatabase();
    await deviceA.claimLocalStore(userId: user);
    await deviceB.claimLocalStore(userId: user);
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  group('a budget with no scope', () {
    test('applies when the server omits the scope keys entirely', () async {
      final budgetId = await seedBudget(
        deviceA,
        name: 'Everything',
        amount: 120000,
      );
      final uploaded = await serviceFor(deviceA).syncAll();
      expect(
        uploaded.success,
        isTrue,
        reason: 'the upload itself must succeed',
      );

      // Reproduce the real API's serializer, which drops null-valued keys
      // instead of writing them, so an unscoped budget arrives without them.
      server.rewritePulledPayload = (table, data) {
        if (table != 'budgets') return data;
        return Map<String, dynamic>.from(data)
          ..remove('WalletIds')
          ..remove('CategoryIds');
      };

      final downloaded = await serviceFor(deviceB).syncAll();

      expect(
        downloaded.applyFailures,
        isEmpty,
        reason: 'an absent scope means unscoped, not a broken record',
      );
      expect(
        downloaded.canAdvanceCursor,
        isTrue,
        reason:
            'the cursor must move on, or every later sync replays this batch',
      );

      final landed = await (deviceB.select(
        deviceB.budgets,
      )..where((b) => b.id.equals(budgetId))).getSingleOrNull();

      expect(landed, isNotNull, reason: 'the budget should have arrived');
      expect(landed!.walletIds, '[]');
      expect(landed.categoryIds, '[]');
      expect(await deviceB.getLastSyncTimestamp(), isNotNull);
    });
  });

  group('a table this build does not know', () {
    test('holds the cursor back instead of dropping the rows', () async {
      // A newer server sending a table added after this release shipped.
      server.extraPulledChanges['contacts'] = [
        SyncChange(
          tableName: 'contacts',
          entityId: 'c-1',
          operation: 'create',
          data: const {'Name': 'Someone'},
        ),
      ];

      final result = await serviceFor(deviceA).syncAll();

      expect(
        result.applyFailures.map((f) => f.tableName),
        contains('contacts'),
        reason: 'an unknown table must be reported, not silently skipped',
      );
      expect(
        result.canAdvanceCursor,
        isFalse,
        reason: 'advancing past rows this build cannot store would lose them',
      );
      expect(
        await deviceA.getLastSyncTimestamp(),
        isNull,
        reason: 'the cursor must stay put so the rows are offered again',
      );
    });
  });
}
