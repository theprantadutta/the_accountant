import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Records which executor ran each statement, so a test can tell a statement
/// that ran inside a database transaction from one that committed on its own.
class _StatementLog extends QueryInterceptor {
  final List<({String sql, bool inTransaction})> statements = [];

  @override
  Future<void> runCustom(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    statements.add((
      sql: statement,
      inTransaction: executor is TransactionExecutor,
    ));
    return super.runCustom(executor, statement, args);
  }
}

/// The sync's own cost: what it writes, what it re-reads, and what it
/// recomputes. Every one of these tests also checks that the data is right —
/// a faster sync that drops an edit is not faster, it is broken.
void main() {
  late FakeSyncServer server;
  late AppDatabase deviceA;
  late AppDatabase deviceB;
  late SyncService syncA;
  late SyncService syncB;

  const user = 'user-a';

  SyncService serviceFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: user),
  );

  Future<Transaction> transaction(AppDatabase db, String id) async =>
      (await db.findTransactionById(id))!;

  /// Edit a transaction the way the app does: the change, a fresh timestamp
  /// for last-write-wins, and a pending flag.
  Future<void> edit(
    AppDatabase db,
    String id,
    TransactionsCompanion Function(TransactionsCompanion row) change,
  ) async {
    final row = (await transaction(db, id)).toCompanion(true);
    await db.updateTransaction(
      change(row).copyWith(
        updatedAt: Value(DateTime.now().add(const Duration(minutes: 1))),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
  }

  setUp(() async {
    server = FakeSyncServer();
    deviceA = openTestDatabase();
    deviceB = openTestDatabase();
    syncA = serviceFor(deviceA);
    syncB = serviceFor(deviceB);
    await deviceA.claimLocalStore(userId: user);
    await deviceB.claimLocalStore(userId: user);
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  group('acknowledging a push', () {
    test('clears every pending flag inside one database transaction', () async {
      final log = _StatementLog();
      final db = AppDatabase(NativeDatabase.memory().interceptWith(log));
      addTearDown(db.close);
      await db.claimLocalStore(userId: user);
      final sync = serviceFor(db);

      final walletId = await seedWallet(db);
      final ids = [
        for (var i = 0; i < 25; i++)
          await seedTransaction(db, walletId: walletId, title: 'Row $i'),
      ];
      log.statements.clear();

      final result = await sync.syncAll();
      expect(result.success, isTrue, reason: result.userMessage);

      final acknowledgements = log.statements
          .where(
            (s) => s.sql.contains('SET sync_status = ${SyncStatus.synced}'),
          )
          .toList();
      // One per pushed row: the wallet and every transaction.
      expect(acknowledgements, hasLength(ids.length + 1));
      expect(
        acknowledgements.every((s) => s.inTransaction),
        isTrue,
        reason:
            'each acknowledgement committing on its own is the cost this '
            'removes',
      );

      for (final id in ids) {
        expect((await transaction(db, id)).syncStatus, SyncStatus.synced);
      }
      expect(server.countIn(user, 'transactions'), ids.length);
    });
  });

  group('the pull that follows a push', () {
    test('does not rewrite the rows this device just sent', () async {
      final walletId = await seedWallet(deviceA, openingBalance: 10000);
      // The account's first sync seeds the built-in categories and the next
      // uploads them; the steady state starts after that.
      await syncA.syncAll();
      await syncA.syncAll();

      final txnId = await seedTransaction(
        deviceA,
        walletId: walletId,
        amount: 2500,
        title: 'Lunch',
      );

      // This sync pushes the row, and its pull hands it straight back.
      final second = await syncA.syncAll();
      expect(second.success, isTrue, reason: second.userMessage);
      expect(second.pushedCount, 1);
      expect(server.pullCount, 3);
      expect(
        second.pulledCount,
        0,
        reason: 'the echo of a push is not something pulled',
      );
      expect(
        second.changedTables,
        isEmpty,
        reason: 'nothing changed, so nothing needs reloading',
      );

      final row = await transaction(deviceA, txnId);
      expect(row.title, 'Lunch');
      expect(row.amount, 2500);
      expect(row.syncStatus, SyncStatus.synced);
      expect(row.deletedAt, isNull);
      expect(await deviceA.pendingRowFingerprints(), isEmpty);
    });

    test('still applies a row another device changed', () async {
      final walletId = await seedWallet(deviceA, openingBalance: 10000);
      final txnId = await seedTransaction(
        deviceA,
        walletId: walletId,
        amount: 2500,
        title: 'Lunch',
      );
      await syncA.syncAll();
      await syncB.syncAll();

      // Device B edits the same row and uploads it.
      await edit(
        deviceB,
        txnId,
        (row) => row.copyWith(
          title: const Value('Team lunch'),
          amount: const Value(4000),
        ),
      );
      final pushedByB = await syncB.syncAll();
      expect(pushedByB.success, isTrue, reason: pushedByB.userMessage);
      expect(pushedByB.pushedCount, greaterThanOrEqualTo(1));

      final pulledByA = await syncA.syncAll();

      expect(pulledByA.success, isTrue, reason: pulledByA.userMessage);
      expect(pulledByA.pulledCount, greaterThanOrEqualTo(1));
      expect(pulledByA.changedTables, contains('transactions'));
      final row = await transaction(deviceA, txnId);
      expect(row.title, 'Team lunch');
      expect(row.amount, 4000);
      expect(
        await WalletBalanceService(deviceA).calculateWalletBalance(walletId),
        6000,
      );
      expect((await deviceA.findWalletById(walletId))!.balance, 6000);
    });

    test('a deletion made elsewhere still lands; its echo does not', () async {
      final walletId = await seedWallet(deviceA);
      final txnId = await seedTransaction(deviceA, walletId: walletId);
      await syncA.syncAll();
      await syncB.syncAll();

      await deviceB.softDeleteTransaction(txnId);
      await syncB.syncAll();
      final deletedOnB = (await transaction(deviceB, txnId)).deletedAt;
      expect(deletedOnB, isNotNull);

      // B's own echo: already a tombstone there, so nothing is rewritten and
      // the time it was deleted — which Recently Deleted counts from — stays.
      final echo = await syncB.syncAll();
      expect(echo.pulledCount, 0);
      expect((await transaction(deviceB, txnId)).deletedAt, deletedOnB);

      // A had it live, so the deletion is real news there.
      final onA = await syncA.syncAll();
      expect(onA.changedTables, contains('transactions'));
      expect((await transaction(deviceA, txnId)).deletedAt, isNotNull);
    });

    test('keeps the timestamp a later push is judged by', () async {
      // Applying a pulled row has always stamped it with the time it arrived,
      // and the next push of that row carries that time into the server's
      // last-write-wins check. Skipping the rewrite must not take that away.
      final walletId = await seedWallet(deviceA);
      final txnId = await seedTransaction(deviceA, walletId: walletId);
      await (deviceA.update(deviceA.transactions)
            ..where((t) => t.id.equals(txnId)))
          .write(TransactionsCompanion(updatedAt: Value(DateTime(2020))));

      await syncA.syncAll();

      final stamped = (await transaction(deviceA, txnId)).updatedAt;
      expect(stamped.isAfter(DateTime(2021)), isTrue);
    });
  });

  group('balances after a pull', () {
    test('are recomputed only for wallets something landed in', () async {
      final touched = await seedWallet(
        deviceA,
        name: 'Checking',
        openingBalance: 10000,
      );
      final untouched = await seedWallet(
        deviceA,
        name: 'Savings',
        openingBalance: 50000,
      );
      final txnId = await seedTransaction(
        deviceA,
        walletId: touched,
        amount: 1000,
      );
      await seedTransaction(deviceA, walletId: untouched, amount: 2000);
      await syncA.syncAll();
      await syncB.syncAll();

      // A sentinel no recomputation could produce. If the pull recomputed
      // every wallet, this would be overwritten with the real figure.
      const sentinel = -123456;
      await deviceA.setWalletBalanceLocal(untouched, sentinel);

      await edit(
        deviceB,
        txnId,
        (row) => row.copyWith(amount: const Value(3000)),
      );
      await syncB.syncAll();

      final result = await syncA.syncAll();

      expect(result.success, isTrue, reason: result.userMessage);
      expect((await deviceA.findWalletById(touched))!.balance, 7000);
      expect(
        (await deviceA.findWalletById(untouched))!.balance,
        sentinel,
        reason: 'a wallet nothing was pulled into is left alone',
      );
    });

    test('follow a transaction that moved between wallets', () async {
      final from = await seedWallet(deviceA, openingBalance: 10000);
      final to = await seedWallet(deviceA, openingBalance: 10000);
      final txnId = await seedTransaction(
        deviceA,
        walletId: from,
        amount: 1000,
      );
      await syncA.syncAll();
      await syncB.syncAll();

      await edit(deviceB, txnId, (row) => row.copyWith(walletId: Value(to)));
      await syncB.syncAll();
      await syncA.syncAll();

      expect((await deviceA.findWalletById(from))!.balance, 10000);
      expect((await deviceA.findWalletById(to))!.balance, 9000);
    });
  });
}
