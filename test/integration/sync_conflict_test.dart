import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionType;
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

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
    await assertStoresAreIndependent(deviceA, deviceB);
    await deviceA.claimLocalStore(userId: user);
    await deviceB.claimLocalStore(userId: user);
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  /// Tombstone a row locally WITHOUT flagging it for sync.
  ///
  /// Models "another device deleted this and we pulled the tombstone", which is
  /// the state that has to be distinguished from "we never had this row".
  Future<void> tombstoneCategoryLocally(AppDatabase db, String id) =>
      db.customStatement('UPDATE categories SET deleted_at = ? WHERE id = ?', [
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        id,
      ]);

  Future<void> tombstoneWalletLocally(AppDatabase db, String id) =>
      db.customStatement('UPDATE wallets SET deleted_at = ? WHERE id = ?', [
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        id,
      ]);

  group('soft-deleted parents are not valid references', () {
    test('the server refuses a transaction against a deleted wallet', () async {
      final walletId = await seedWallet(deviceA, name: 'Doomed');
      final categoryId = await seedCategory(deviceA);
      await serviceFor(deviceA).syncAll();

      // Device B has both parents, then device A deletes the wallet.
      await serviceFor(deviceB).syncAll();
      await deviceA.softDeleteWallet(walletId);
      await serviceFor(deviceA).syncAll();

      // Device B never saw the deletion and records a transaction against it.
      await seedTransaction(
        deviceB,
        walletId: walletId,
        categoryId: categoryId,
        amount: 999,
        title: 'Against a deleted wallet',
      );

      final result = await serviceFor(deviceB).syncAll();

      expect(
        result.conflicts.any(
          (c) => c.tableName == 'transactions' && c.reason.contains('deleted'),
        ),
        isTrue,
        reason:
            'a tombstoned parent must not satisfy a reference check; '
            'conflicts were ${result.conflicts.map((c) => c.reason).toList()}',
      );
      expect(
        server.countIn(user, 'transactions'),
        0,
        reason: 'the dangling record must never reach the cloud',
      );
    });

    test('a rejected transaction stays pending and is retried', () async {
      final walletId = await seedWallet(deviceA);
      final categoryId = await seedCategory(deviceA);
      await serviceFor(deviceA).syncAll();
      await serviceFor(deviceB).syncAll();

      await deviceA.softDeleteWallet(walletId);
      await serviceFor(deviceA).syncAll();

      final txnId = await seedTransaction(
        deviceB,
        walletId: walletId,
        categoryId: categoryId,
      );
      await serviceFor(deviceB).syncAll();

      final pending = await deviceB.getPendingSyncTransactions();
      expect(
        pending.map((t) => t.id),
        contains(txnId),
        reason:
            'a rejected record must stay pending, not be marked synced and lost',
      );
    });

    test(
      'a pulled transaction whose parent is locally deleted is not applied',
      () async {
        final walletId = await seedWallet(deviceA);
        final categoryId = await seedCategory(deviceA);
        await serviceFor(deviceA).syncAll();
        await serviceFor(deviceB).syncAll();

        // Device B holds a tombstone for the category (pulled from a third
        // device, say) while device A files a transaction under it.
        await tombstoneCategoryLocally(deviceB, categoryId);
        await seedTransaction(
          deviceA,
          walletId: walletId,
          categoryId: categoryId,
        );
        await serviceFor(deviceA).syncAll();

        final result = await serviceFor(deviceB).syncAll();

        expect(result.success, isFalse);
        expect(result.isPartial, isTrue);
        expect(
          result.applyFailures.single.reason,
          contains('deleted'),
          reason:
              'the local lookup must distinguish a tombstone from a live parent; '
              'got ${result.applyFailures.single.reason}',
        );
        expect(
          result.canAdvanceCursor,
          isFalse,
          reason: 'the record must be offered again rather than dropped',
        );
        expect(await deviceB.getAllTransactions(), isEmpty);
      },
    );

    test('a locally deleted wallet also blocks a pulled child', () async {
      final walletId = await seedWallet(deviceA);
      await serviceFor(deviceA).syncAll();
      await serviceFor(deviceB).syncAll();

      await tombstoneWalletLocally(deviceB, walletId);
      await seedTransaction(deviceA, walletId: walletId);
      await serviceFor(deviceA).syncAll();

      final result = await serviceFor(deviceB).syncAll();

      expect(result.applyFailures, hasLength(1));
      expect(result.applyFailures.single.reason, contains('deleted'));
      expect(result.applyFailures.single.isMissingParent, isTrue);
    });

    test('an unknown objective reference is rejected by the server', () async {
      final walletId = await seedWallet(deviceA);
      final categoryId = await seedCategory(deviceA);
      await serviceFor(deviceA).syncAll();
      await serviceFor(deviceB).syncAll();

      await seedTransaction(
        deviceB,
        walletId: walletId,
        categoryId: categoryId,
        objectiveId: 'objective-that-does-not-exist',
      );

      final result = await serviceFor(deviceB).syncAll();

      expect(
        result.conflicts.any(
          (c) => c.reason.toLowerCase().contains('objective'),
        ),
        isTrue,
        reason:
            'budget and objective references were previously unchecked; '
            'conflicts were ${result.conflicts.map((c) => c.reason).toList()}',
      );
      expect(server.countIn(user, 'transactions'), 0);
    });
  });

  group('recurring instance round trip', () {
    test(
      'keeps its type, config id, and occurrence key across devices',
      () async {
        final walletId = await seedWallet(deviceA, openingBalance: 100000);
        final categoryId = await seedCategory(deviceA);
        final baseId = await seedTransaction(
          deviceA,
          walletId: walletId,
          categoryId: categoryId,
          amount: 1500,
          title: 'Streaming',
        );
        const configId = 'cfg-round-trip';
        final scheduled = DateTime.utc(2026, 5, 1, 9);
        final occurrenceKey = RecurringService.occurrenceKeyFor(
          configId,
          scheduled,
        );

        // A generated occurrence, exactly as RecurringService writes one.
        final occurrenceId = await seedTransaction(
          deviceA,
          walletId: walletId,
          categoryId: categoryId,
          amount: 1500,
          title: 'Streaming',
          date: scheduled,
          transactionType: 'recurring_instance',
          occurrenceKey: occurrenceKey,
        );
        // The recurring config's base transaction must exist for the FK.
        expect(baseId, isNotEmpty);

        await serviceFor(deviceA).syncAll();

        // The wire payload must carry the recurring-instance type, not Regular.
        final onServer = server
            .recordsIn(user, 'transactions')
            .firstWhere((r) => r['OccurrenceKey'] == occurrenceKey);
        expect(
          onServer['Type'],
          TransactionType.recurringInstance.wireValue,
          reason: 'serializing as Regular loses the recurrence relationship',
        );
        expect(onServer['OccurrenceKey'], occurrenceKey);

        await serviceFor(deviceB).syncAll();

        final pulled = await deviceB.findTransactionById(occurrenceId);
        expect(pulled, isNotNull);
        expect(
          pulled!.transactionType,
          TransactionType.recurringInstance.storageValue,
          reason: 'the stored spelling must match the column convention',
        );
        expect(
          TransactionPolicy.isRecurringInstance(pulled),
          isTrue,
          reason:
              'the domain policy must still recognise it after a round trip',
        );
        expect(pulled.occurrenceKey, occurrenceKey);

        // And deduplication still works on the far side: the same occurrence
        // generated locally is recognised, not duplicated.
        await expectLater(
          seedTransaction(
            deviceB,
            walletId: walletId,
            occurrenceKey: occurrenceKey,
          ),
          throwsA(anything),
          reason: 'the unique occurrence key must survive the round trip',
        );
      },
    );

    test('a transfer leg keeps its type across devices', () async {
      final source = await seedWallet(deviceA, name: 'A', openingBalance: 5000);
      final dest = await seedWallet(deviceA, name: 'B');
      final categoryId = await seedCategory(deviceA);
      final outId = await seedTransaction(
        deviceA,
        walletId: source,
        categoryId: categoryId,
        amount: 1000,
        transactionType: 'transfer',
      );
      await seedTransaction(
        deviceA,
        walletId: dest,
        categoryId: categoryId,
        amount: 1000,
        isIncome: true,
        transactionType: 'transfer',
      );

      await serviceFor(deviceA).syncAll();
      await serviceFor(deviceB).syncAll();

      final pulled = await deviceB.findTransactionById(outId);
      expect(TransactionPolicy.isTransfer(pulled!), isTrue);
      expect(pulled.transactionType, TransactionType.transfer.storageValue);
    });
  });
}
