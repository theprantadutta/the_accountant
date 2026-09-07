import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Who wins when a pulled row meets a local row that is still pending.
///
/// There are two reasons a row can be pending when the server's copy comes
/// back, and they want opposite answers:
///
/// * the server has just **rejected** what this device sent. Its copy is the
///   winner. Skip it and the same losing version is pushed and rejected on
///   every sync for ever — a conflict that never settles.
/// * the row was **changed while the push was in flight**, so what it holds now
///   has never been offered to the server. Overwrite it and unjudged work is
///   gone.
///
/// Guarding on "is it pending" gets one of them wrong whichever way it is
/// written, and both mistakes have been shipped here: first overwriting
/// everything, then protecting everything. The local row version tells them
/// apart — if the row still holds the version that was submitted, the server's
/// answer is about exactly this content.
class _HookedDatabase extends AppDatabase {
  _HookedDatabase() : super(NativeDatabase.memory());

  /// Runs immediately before the statement that clears a pending flag, which is
  /// the last instant an edit can land and still be at risk.
  Future<void> Function()? beforeAcknowledgement;

  @override
  Future<void> customStatement(String statement, [List<Object?>? args]) async {
    if (statement.startsWith('UPDATE transactions SET sync_status = 0 ')) {
      final act = beforeAcknowledgement;
      beforeAcknowledgement = null;
      if (act != null) await act();
    }
    await super.customStatement(statement, args);
  }
}

class _PausingTransport extends FakeSyncTransport {
  _PausingTransport({required super.server, required super.userId});

  Future<void> Function()? duringPush;

  @override
  Future<SyncPushResponse> push(List<SyncChange> changes) async {
    final act = duringPush;
    duringPush = null;
    if (act != null) await act();
    return super.push(changes);
  }
}

void main() {
  late _HookedDatabase db;
  late FakeSyncServer server;
  late _PausingTransport transport;
  late SyncService sync;
  late String wallet;
  const userId = 'pull-conflict-user';

  setUp(() async {
    db = _HookedDatabase();
    server = FakeSyncServer();
    transport = _PausingTransport(server: server, userId: userId);
    sync = SyncService(database: db, transport: transport);
    await db.claimLocalStore(userId: userId);
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db, name: 'Everyday');
    await sync.syncAll();
  });

  tearDown(() => db.close());

  Future<void> editAmount(String id, int amount, DateTime at) =>
      (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(
          amount: Value(amount),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(at),
        ),
      );

  group('a version the server has already judged', () {
    test('a losing edit converges on the server copy', () async {
      final id = await seedTransaction(db, walletId: wallet, amount: 1000);
      await sync.syncAll();

      // This device edits with an old timestamp; another device has since made
      // a newer edit that the server holds.
      await editAmount(id, 2000, DateTime.utc(2025));
      server.push(userId, [
        SyncChange(
          tableName: 'transactions',
          entityId: id,
          operation: 'update',
          data: {
            ...server.recordData(userId, 'transactions', id)!,
            'Amount': 9000,
            'UpdatedAt': DateTime.utc(2030).toIso8601String(),
          },
        ),
      ]);

      await sync.syncAll();
      await sync.syncAll();

      final row = (await db.findTransactionById(id))!;
      expect(
        row.amount,
        9000,
        reason: 'last-write-wins decided against this device, and a decision '
            'the device refuses to accept is not a decision',
      );
      expect(
        row.syncStatus,
        SyncStatus.synced,
        reason: 'a row left pending re-pushes the same losing version on every '
            'sync, for ever',
      );
    });
  });

  group('a version the server has never seen', () {
    test('a restore made during the delete upload survives', () async {
      final id = await seedTransaction(db, walletId: wallet, amount: 1000);
      await sync.syncAll();
      await db.softDeleteTransaction(id);

      transport.duringPush = () => db.restoreTransaction(id);
      await sync.syncAll();
      await sync.syncAll();

      expect(
        (await db.findTransactionById(id))!.deletedAt,
        isNull,
        reason: 'the tombstone coming back is the server answering the delete '
            'this device sent, not an opinion about the restore that followed',
      );
      expect(server.isTombstoned(userId, 'transactions', id), isFalse);
    });

    test('a wallet renamed during the push keeps the later name', () async {
      await (db.update(db.wallets)..where((w) => w.id.equals(wallet))).write(
        WalletsCompanion(
          name: const Value('First edit'),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );

      transport.duringPush = () async {
        await (db.update(db.wallets)..where((w) => w.id.equals(wallet))).write(
          WalletsCompanion(
            name: const Value('Second edit'),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );
      };

      await sync.syncAll();
      await sync.syncAll();

      expect(
        (await db.findWalletById(wallet))!.name,
        'Second edit',
        reason: 'the protection was written for transactions only, so every '
            'other kind of row was still overwritten by its own returning copy',
      );
      expect(server.recordData(userId, 'wallets', wallet)!['Name'], 'Second edit');
    });

    test('an edit landing just before the acknowledgement is kept', () async {
      final id = await seedTransaction(db, walletId: wallet, amount: 1000);
      await sync.syncAll();
      await editAmount(id, 4000, DateTime.now());

      // The last unprotected instant: after the push, as the flag is cleared.
      db.beforeAcknowledgement = () => editAmount(id, 9900, DateTime.now());
      await sync.syncAll();
      await sync.syncAll();

      expect(
        (await db.findTransactionById(id))!.amount,
        9900,
        reason: 'comparing content and then writing unconditionally still left '
            'a gap; the compare and the write are one statement now',
      );
      expect(
        server.recordData(userId, 'transactions', id)!['Amount'],
        9900,
      );
    });
  });

  /// The whole lifecycle, end to end: what was collected, what the server
  /// decided, what got acknowledged, what was held back, and what happens on
  /// the retry. Each step was correct on its own at some point while the
  /// others were not.
  test('a conflict settles after the edit that caused it loses', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 1000);
    await sync.syncAll();

    // A newer edit exists on the server.
    server.push(userId, [
      SyncChange(
        tableName: 'transactions',
        entityId: id,
        operation: 'update',
        data: {
          ...server.recordData(userId, 'transactions', id)!,
          'Amount': 9000,
          'UpdatedAt': DateTime.utc(2030).toIso8601String(),
        },
      ),
    ]);

    // This device edits with an older stamp, then edits again mid-push.
    await editAmount(id, 4000, DateTime.utc(2025));
    transport.duringPush = () => editAmount(id, 9900, DateTime.utc(2025, 2));
    await sync.syncAll();

    expect(
      (await db.findTransactionById(id))!.amount,
      9900,
      reason: 'the second edit was never offered to the server, so nothing has '
          'judged it yet',
    );

    await sync.syncAll();
    await sync.syncAll();

    final row = (await db.findTransactionById(id))!;
    expect(
      row.amount,
      9000,
      reason: 'once the held-back edit has been pushed and lost, the server '
          'copy is the answer — and it is only reachable because the cursor '
          'did not move past it while the edit was being protected',
    );
    expect(row.syncStatus, SyncStatus.synced);
  });

  test('an ordinary sync still settles', () async {
    final id = await seedTransaction(db, walletId: wallet, amount: 1000);

    await sync.syncAll();

    expect(
      (await db.findTransactionById(id))!.syncStatus,
      SyncStatus.synced,
      reason: 'a guard that never lets go would re-push everything for ever',
    );
  });
}
