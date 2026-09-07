import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Changing a row while its own push is in the air.
///
/// The window is small and entirely ordinary: a push takes a moment, the user
/// carries on tapping. Two things conspired to lose whatever they did in it.
///
/// The push guard compared the row's `updatedAt` against the value collected a
/// moment earlier, and Drift stores that at one-second resolution — so a change
/// made during a push almost always compared equal, and the guard cleared the
/// pending flag straight over it. Then the pull, which ran next in the same
/// sync, wrote the server's copy over the local row regardless of what the
/// device still had to say.
///
/// Between them, deleting a transaction while its create was uploading left the
/// row live in the cloud and live on the device, with nothing anywhere to say
/// it had ever been deleted.
class _PausingTransport extends FakeSyncTransport {
  _PausingTransport({required super.server, required super.userId});

  /// Runs inside the push, standing in for the user acting while it is in
  /// flight. Cleared after firing, so only the first push is interrupted.
  Future<void> Function()? duringPush;

  final pushed = <SyncChange>[];

  @override
  Future<SyncPushResponse> push(List<SyncChange> changes) async {
    pushed.addAll(changes);
    final act = duringPush;
    duringPush = null;
    if (act != null) await act();
    return super.push(changes);
  }
}

void main() {
  late FakeSyncServer server;
  late AppDatabase db;
  late _PausingTransport transport;
  late SyncService sync;
  late String wallet;
  const userId = 'in-flight-user';

  setUp(() async {
    server = FakeSyncServer();
    db = openTestDatabase();
    await db.claimLocalStore(userId: userId);
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db, name: 'Everyday');

    transport = _PausingTransport(server: server, userId: userId);
    sync = SyncService(database: db, transport: transport);
    await sync.syncAll();
  });

  tearDown(() => db.close());

  test('a deletion made during the create still reaches the cloud', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 2500);

    transport.duringPush = () => db.softDeleteTransaction(id);
    await sync.syncAll();
    await sync.syncAll();

    expect(
      server.isTombstoned(userId, 'transactions', id),
      isTrue,
      reason: 'the create landed, so the row exists up there and only this '
          'device knows it should not',
    );
    expect((await db.findTransactionById(id))!.deletedAt, isNotNull);
  });

  test('the row is not marked synced while it still has something to say', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 2500);

    transport.duringPush = () => db.softDeleteTransaction(id);
    await sync.syncAll();

    expect(
      (await db.findTransactionById(id))!.syncStatus,
      SyncStatus.pendingDelete,
      reason: 'the push that just finished carried the create, not the '
          'deletion that arrived while it was in flight',
    );
  });

  test('the pull does not undo it on the way back', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 2500);

    transport.duringPush = () => db.softDeleteTransaction(id);
    await sync.syncAll();

    expect(
      (await db.findTransactionById(id))!.deletedAt,
      isNotNull,
      reason: 'the same sync pulls the row back down, live, because the create '
          'had just been accepted — and writing that over the tombstone threw '
          'away a decision the server had not been told about yet',
    );
  });

  test('an edit made during the push is not lost either', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 2500);
    await sync.syncAll();

    transport.duringPush = () async {
      await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(
          amount: const Value(9900),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );
    };
    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        amount: const Value(4000),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await sync.syncAll();
    await sync.syncAll();

    expect((await db.findTransactionById(id))!.amount, 9900);
    expect(
      server.recordData(userId, 'transactions', id)?['Amount'],
      9900,
      reason: 'the later figure is the one the user meant, and it has to be '
          'the one that reaches the server',
    );
  });

  test('an ordinary uninterrupted push still clears the flag', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 2500);

    await sync.syncAll();

    expect(
      (await db.findTransactionById(id))!.syncStatus,
      SyncStatus.synced,
      reason: 'a guard that never lets go would re-push everything for ever',
    );
  });
}
