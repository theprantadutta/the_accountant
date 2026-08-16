import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Two independent local databases talking to one in-memory server — the shape
/// the audit's acceptance matrix calls for. Each test asserts on the rows, the
/// balances, the pending sync states, the server contents, and the cursor.
void main() {
  late FakeSyncServer server;
  late AppDatabase deviceA;
  late AppDatabase deviceB;
  late SyncService syncA;
  late SyncService syncB;

  const userA = 'user-a';
  const userB = 'user-b';

  SyncService serviceFor(AppDatabase db, String userId) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: userId),
  );

  setUp(() async {
    server = FakeSyncServer();
    deviceA = openTestDatabase();
    deviceB = openTestDatabase();
    // Prove the two stores really are separate databases before asserting that
    // anything travelled between them.
    await assertStoresAreIndependent(deviceA, deviceB);
    syncA = serviceFor(deviceA, userA);
    syncB = serviceFor(deviceB, userA); // same account, second device
    await deviceA.claimLocalStore(userId: userA);
    await deviceB.claimLocalStore(userId: userA);
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  group('default-category income/expense reaches a clean second device', () {
    test('categories upload first and both transactions arrive', () async {
      await deviceA.ensureSystemCategoriesExist();
      final walletId = await seedWallet(
        deviceA,
        name: 'Everyday',
        openingBalance: 20000,
      );
      // A default category, exactly as CategoryInitializationService creates it.
      final categoryId = await seedCategory(deviceA, name: 'Food & Dining');
      await seedTransaction(
        deviceA,
        walletId: walletId,
        categoryId: categoryId,
        amount: 2500,
        title: 'Lunch',
      );
      await seedTransaction(
        deviceA,
        walletId: walletId,
        categoryId: categoryId,
        amount: 9000,
        isIncome: true,
        title: 'Payday',
      );

      final pushResult = await syncA.syncAll();

      expect(
        pushResult.success,
        isTrue,
        reason: pushResult.userMessage ?? 'sync should be clean',
      );
      expect(
        pushResult.conflicts,
        isEmpty,
        reason:
            'the server rejects transactions whose category it has never seen; '
            'default categories must be pushed as pending records',
      );
      expect(server.countIn(userA, 'categories'), greaterThanOrEqualTo(1));
      expect(server.countIn(userA, 'transactions'), 2);

      // Clean device pulls everything.
      final pullResult = await syncB.syncAll();

      expect(pullResult.success, isTrue, reason: pullResult.userMessage);
      expect(pullResult.applyFailures, isEmpty);

      final transactions = await deviceB.getAllTransactions();
      expect(transactions, hasLength(2));
      expect(transactions.map((t) => t.title).toSet(), {'Lunch', 'Payday'});
      // The parents landed too, so nothing is an orphan.
      expect(await deviceB.findWalletById(walletId), isNotNull);
      expect(await deviceB.findCategoryById(categoryId), isNotNull);

      // Balance is derived locally, and matches device A.
      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(walletId),
        await WalletBalanceService(deviceA).calculateWalletBalance(walletId),
      );
    });

    test(
      'applies parents before children even when children sort first',
      () async {
        final walletId = await seedWallet(deviceA);
        final categoryId = await seedCategory(deviceA);
        await seedTransaction(
          deviceA,
          walletId: walletId,
          categoryId: categoryId,
        );
        await syncA.syncAll();

        final result = await syncB.syncAll();

        expect(result.success, isTrue);
        // If ordering were wrong the transaction would have been rejected for a
        // missing parent and reported as an apply failure.
        expect(result.applyFailures, isEmpty);
        expect(await deviceB.getAllTransactions(), hasLength(1));
      },
    );
  });

  group('transfers survive the round trip as an atomic pair', () {
    test('both legs reach device B and analytics stay clean', () async {
      await deviceA.ensureSystemCategoriesExist();
      final source = await seedWallet(
        deviceA,
        name: 'Checking',
        openingBalance: 50000,
      );
      final dest = await seedWallet(
        deviceA,
        name: 'Savings',
        openingBalance: 0,
      );
      await TransferService(deviceA).createTransfer(
        sourceWalletId: source,
        destinationWalletId: dest,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );

      final push = await syncA.syncAll();
      expect(
        push.conflicts,
        isEmpty,
        reason: 'a GUID transfer category must be accepted',
      );

      await syncB.syncAll();

      final legs = await TransferService(deviceB).getTransferTransactions();
      expect(legs, hasLength(2));
      expect(await TransferService(deviceB).validateAllTransfers(), isEmpty);

      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(source),
        42500,
      );
      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(dest),
        7500,
      );

      final all = await deviceB.getAllTransactions();
      expect(TransactionPolicy.totalIncome(all), 0);
      expect(TransactionPolicy.totalExpense(all), 0);
    });

    test('deleting on A removes both legs on B', () async {
      await deviceA.ensureSystemCategoriesExist();
      final source = await seedWallet(deviceA, openingBalance: 50000);
      final dest = await seedWallet(deviceA, openingBalance: 0);
      final (expenseId, _) = await TransferService(deviceA).createTransfer(
        sourceWalletId: source,
        destinationWalletId: dest,
        amount: 7500,
        date: DateTime(2026, 3, 1),
      );
      await syncA.syncAll();
      await syncB.syncAll();
      expect(
        await TransferService(deviceB).getTransferTransactions(),
        hasLength(2),
      );

      await TransferService(deviceA).deleteTransfer(expenseId);
      await syncA.syncAll();
      await syncB.syncAll();

      expect(await TransferService(deviceB).getTransferTransactions(), isEmpty);
      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(source),
        50000,
      );
      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(dest),
        0,
      );
    });
  });

  group('account isolation', () {
    test(
      'a different user cannot see or upload the first account\'s data',
      () async {
        final walletId = await seedWallet(deviceA, name: 'Private');
        await seedTransaction(deviceA, walletId: walletId, amount: 12345);
        await syncA.syncAll();
        expect(server.countIn(userA, 'transactions'), 1);

        // User B signs in on a fresh store of their own.
        final storeB = openTestDatabase();
        addTearDown(storeB.close);
        await storeB.claimLocalStore(userId: userB);
        final syncAsB = serviceFor(storeB, userB);

        final result = await syncAsB.syncAll();

        expect(result.success, isTrue);
        expect(
          await storeB.getAllTransactions(),
          isEmpty,
          reason: "user B must not receive user A's records",
        );
        expect(server.countIn(userB, 'transactions'), 0);
      },
    );

    test('a store owned by someone else refuses to push', () async {
      final walletId = await seedWallet(deviceA);
      await seedTransaction(deviceA, walletId: walletId, amount: 999);

      // Device A's store belongs to user A, but user B is signed in.
      final wrongUserSync = serviceFor(deviceA, userB);
      final result = await wrongUserSync.syncAll();

      expect(result.success, isFalse);
      expect(result.error, contains('different account'));
      expect(
        server.countIn(userB, 'transactions'),
        0,
        reason: "user A's pending rows must never upload under user B",
      );
      // The pending rows are untouched, still waiting for their real owner.
      final pending = await deviceA.getPendingSyncTransactions();
      expect(pending, hasLength(1));
    });

    test(
      'an unclaimed store is adopted by the first account that syncs',
      () async {
        final fresh = openTestDatabase();
        addTearDown(fresh.close);
        expect(await fresh.getLocalStoreOwnerUserId(), isNull);

        await serviceFor(fresh, userB).syncAll();

        expect(await fresh.getLocalStoreOwnerUserId(), userB);
      },
    );
  });

  group('failure handling', () {
    test(
      'an invalid remote record fails the sync and holds the cursor',
      () async {
        final walletId = await seedWallet(deviceA);
        final categoryId = await seedCategory(deviceA);
        await seedTransaction(
          deviceA,
          walletId: walletId,
          categoryId: categoryId,
          amount: 4200,
          title: 'Good record',
        );
        await syncA.syncAll();

        // The server hands device B a transaction whose wallet does not exist.
        server.corruptTransaction = (data) => {
          ...data,
          'WalletId': 'wallet-that-does-not-exist',
        };

        final first = await syncB.syncAll();

        expect(
          first.success,
          isFalse,
          reason: 'a dropped record must never look like a clean sync',
        );
        expect(first.isPartial, isTrue);
        expect(first.canAdvanceCursor, isFalse);
        expect(first.applyFailures, hasLength(1));
        expect(first.applyFailures.single.isMissingParent, isTrue);
        expect(first.applyFailures.single.reason, contains('wallet'));
        expect(first.userMessage, contains('retried'));
        expect(await deviceB.getAllTransactions(), isEmpty);

        // The cursor did NOT advance, so the record is offered again — and once
        // the data is valid it applies.
        server.corruptTransaction = null;
        final second = await syncB.syncAll();

        expect(second.success, isTrue);
        expect(second.applyFailures, isEmpty);
        final recovered = await deviceB.getAllTransactions();
        expect(recovered, hasLength(1));
        expect(recovered.single.title, 'Good record');
      },
    );

    test('push is chunked below the server batch limit', () async {
      final walletId = await seedWallet(deviceA);
      final categoryId = await seedCategory(deviceA);
      for (var i = 0; i < 1200; i++) {
        await seedTransaction(
          deviceA,
          walletId: walletId,
          categoryId: categoryId,
          amount: 100 + i,
          title: 'bulk-$i',
        );
      }

      final result = await syncA.syncAll();

      expect(result.success, isTrue, reason: result.userMessage);
      expect(server.receivedBatchSizes, isNotEmpty);
      expect(
        server.receivedBatchSizes.every(
          (size) => size <= FakeSyncServer.maxChangesPerRequest,
        ),
        isTrue,
        reason: 'the server rejects a batch over its limit outright',
      );
      expect(
        server.receivedBatchSizes.length,
        greaterThan(1),
        reason: '1200+ changes must be split across requests',
      );
      expect(server.countIn(userA, 'transactions'), 1200);

      // Only acknowledged records were marked synced.
      expect(await deviceA.getPendingSyncTransactions(), isEmpty);
    });
  });

  group('cloud restore', () {
    test('is all-or-nothing and leaves local data intact on failure', () async {
      final walletId = await seedWallet(deviceA, openingBalance: 1000);
      final categoryId = await seedCategory(deviceA);
      await seedTransaction(
        deviceA,
        walletId: walletId,
        categoryId: categoryId,
        title: 'Cloud copy',
      );
      await syncA.syncAll();

      // Device B has its own local work that must survive a failed restore.
      final localWallet = await seedWallet(deviceB, name: 'Local only');
      await seedTransaction(
        deviceB,
        walletId: localWallet,
        title: 'Local only',
      );

      server.corruptTransaction = (data) => {...data, 'WalletId': 'nope'};

      final failed = await syncB.restoreFromCloud();

      expect(failed.success, isFalse);
      expect(failed.isPartial, isTrue);
      final survivors = await deviceB.getAllTransactions();
      expect(
        survivors.map((t) => t.title),
        contains('Local only'),
        reason: 'a failed restore must not destroy the local database',
      );
    });

    test('a clean restore replaces local data with the cloud copy', () async {
      final walletId = await seedWallet(deviceA, openingBalance: 1000);
      final categoryId = await seedCategory(deviceA);
      await seedTransaction(
        deviceA,
        walletId: walletId,
        categoryId: categoryId,
        title: 'Cloud copy',
        amount: 3300,
      );
      await syncA.syncAll();

      final stale = await seedWallet(deviceB, name: 'Stale');
      await seedTransaction(deviceB, walletId: stale, title: 'Stale');

      final restored = await syncB.restoreFromCloud();

      expect(restored.success, isTrue, reason: restored.userMessage);
      final transactions = await deviceB.getAllTransactions();
      expect(transactions.map((t) => t.title), ['Cloud copy']);
      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(walletId),
        1000 - 3300,
      );
    });
  });

  group('upcoming skip propagates', () {
    test('device B receives the skipped state', () async {
      final walletId = await seedWallet(deviceA);
      final id = await seedTransaction(
        deviceA,
        walletId: walletId,
        isPaid: false,
        date: DateTime.now().add(const Duration(days: 5)),
      );
      await syncA.syncAll();
      await syncB.syncAll();

      await deviceA.skipTransaction(id);
      await syncA.syncAll();
      await syncB.syncAll();

      final onB = await deviceB.findTransactionById(id);
      expect(onB!.skipPaid, isTrue);
    });
  });

  group('two offline devices at a recurrence boundary', () {
    test('converge on exactly one occurrence', () async {
      const walletId = 'wallet-shared';
      const categoryId = 'category-shared';
      const occurrenceKey = 'cfg-shared@2026-05-01';

      // Both devices already hold the same parents (they synced before going
      // offline), which is what makes the boundary case reachable at all.
      for (final db in [deviceA, deviceB]) {
        await seedWallet(db, id: walletId, openingBalance: 100000);
        await seedCategory(db, id: categoryId);
      }

      // Offline, each device generates the SAME scheduled occurrence with its
      // own locally-created row id.
      await seedTransaction(
        deviceA,
        id: 'a-copy',
        walletId: walletId,
        categoryId: categoryId,
        amount: 1500,
        occurrenceKey: occurrenceKey,
        title: 'Subscription',
      );
      await seedTransaction(
        deviceB,
        id: 'b-copy',
        walletId: walletId,
        categoryId: categoryId,
        amount: 1500,
        occurrenceKey: occurrenceKey,
        title: 'Subscription',
      );

      // A reconnects first and its copy wins.
      final resultA = await syncA.syncAll();
      expect(resultA.success, isTrue, reason: resultA.userMessage);

      // B reconnects: its push is recognised as the same occurrence, and the
      // pull replaces its local row with the winning copy.
      final resultB = await syncB.syncAll();

      expect(resultB.success, isTrue, reason: resultB.userMessage);
      expect(
        server.countIn(userA, 'transactions'),
        1,
        reason: 'one scheduled occurrence must produce exactly one server row',
      );

      final onB = await deviceB.getAllTransactions();
      final occurrences = onB
          .where((t) => t.occurrenceKey == occurrenceKey)
          .toList();
      expect(
        occurrences,
        hasLength(1),
        reason: 'the local duplicate must be replaced by the server copy',
      );
      expect(occurrences.single.id, 'a-copy');

      // And the balance reflects one charge, not two.
      expect(
        await WalletBalanceService(deviceB).calculateWalletBalance(walletId),
        100000 - 1500,
      );
    });
  });
}
