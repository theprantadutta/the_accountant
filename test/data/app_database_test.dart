import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  group('local store ownership', () {
    test('a fresh store has no owner and can be claimed', () async {
      expect(await db.getLocalStoreOwnerUserId(), isNull);

      await db.claimLocalStore(userId: 'user-a', email: 'a@example.com');

      expect(await db.getLocalStoreOwnerUserId(), 'user-a');
      expect(await db.isLocalStoreUsableBy('user-a'), isTrue);
    });

    test('a claimed store rejects a different owner', () async {
      await db.claimLocalStore(userId: 'user-a');

      expect(await db.isLocalStoreUsableBy('user-b'), isFalse);
      expect(
        () => db.claimLocalStore(userId: 'user-b'),
        throwsA(isA<StateError>()),
      );
    });

    test('re-claiming by the same owner is a no-op', () async {
      await db.claimLocalStore(userId: 'user-a');
      await db.claimLocalStore(userId: 'user-a');
      expect(await db.getLocalStoreOwnerUserId(), 'user-a');
    });

    test('releasing wipes the data and detaches the owner', () async {
      await db.claimLocalStore(userId: 'user-a');
      final walletId = await seedWallet(db);
      await seedTransaction(db, walletId: walletId);

      await db.releaseLocalStore();

      expect(await db.getLocalStoreOwnerUserId(), isNull);
      expect(await db.getAllTransactions(), isEmpty);
      expect(await db.getAllWallets(), isEmpty);
      expect(await db.isLocalStoreUsableBy('user-b'), isTrue);
    });
  });

  group('system categories', () {
    test(
      'are created with a random GUID id, a slug, and pending upload',
      () async {
        await db.ensureSystemCategoriesExist();

        final transfer = await db.findCategoryByDefaultKey(
          SystemCategories.transferKey,
        );
        expect(transfer, isNotNull);
        // Must be a real UUID: the backend models CategoryId as a Guid, so the
        // old 'transfer-category-0' sentinel could never be deserialized.
        expect(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
          ).hasMatch(transfer!.id),
          isTrue,
          reason: 'system category id must be a valid GUID',
        );
        // And NOT a globally fixed id: the backend's category primary key is
        // global, so a shared id collides across users — and that collision
        // surfaces at flush time, aborting the whole push batch.
        expect(
          transfer.id,
          isNot(SystemCategories.legacyFixedTransferCategoryId),
        );
        expect(transfer.isDefault, isTrue);
        // Must be uploadable, or the server rejects every transfer using it.
        expect(transfer.syncStatus, SyncStatus.pendingCreate);
      },
    );

    test(
      'two independent stores get DIFFERENT ids for the same slug',
      () async {
        final other = openTestDatabase();
        addTearDown(other.close);

        await db.ensureSystemCategoriesExist();
        await other.ensureSystemCategoriesExist();

        final a = await db.findCategoryByDefaultKey(
          SystemCategories.transferKey,
        );
        final b = await other.findCategoryByDefaultKey(
          SystemCategories.transferKey,
        );

        expect(
          a!.id,
          isNot(b!.id),
          reason: 'a shared category id would collide on the backend',
        );
        expect(a.defaultKey, b.defaultKey);
      },
    );

    test('are idempotent across repeated initialization', () async {
      await db.ensureSystemCategoriesExist();
      await db.ensureSystemCategoriesExist();

      final all = await db.getAllCategories();
      expect(
        all.where((c) => c.defaultKey == SystemCategories.transferKey).length,
        1,
      );
    });

    test('resolve by slug, creating the category on demand', () async {
      final id = await db.requireSystemCategoryId(SystemCategories.transferKey);
      expect(id, isNotEmpty);
      // Resolving again returns the SAME row rather than making another.
      expect(
        await db.requireSystemCategoryId(SystemCategories.transferKey),
        id,
      );
      expect(await db.getAllCategories(), hasLength(1));
    });

    test('an unknown slug is a programming error, not a silent no-op', () {
      expect(
        () => db.requireSystemCategoryId('not_a_real_slug'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('sync-aware skip', () {
    test('marks the row pending so the skip propagates', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(
        db,
        walletId: walletId,
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
        syncStatus: SyncStatus.synced,
      );

      await db.skipTransaction(id);

      final row = await db.findTransactionById(id);
      expect(row!.skipPaid, isTrue);
      expect(
        row.syncStatus,
        SyncStatus.pendingUpdate,
        reason: 'the row was already synced, so an edit is an update',
      );
    });
  });

  group('objective progress', () {
    test('is derived from the synchronized transaction column', () async {
      final walletId = await seedWallet(db);
      await seedTransaction(db, walletId: walletId, amount: 2500);
      final linkedId = await seedTransaction(
        db,
        walletId: walletId,
        amount: 4000,
      );
      await seedTransaction(db, walletId: walletId, amount: 1000);

      await db.linkTransactionToObjective('goal-1', linkedId);

      expect(await db.getObjectiveProgress('goal-1'), 4000);
      final linked = await db.getTransactionsForObjective('goal-1');
      expect(linked.map((t) => t.id), [linkedId]);

      final row = await db.findTransactionById(linkedId);
      expect(
        row!.syncStatus,
        SyncStatus.pendingCreate,
        reason:
            'this transaction has never been uploaded, so it must stay a '
            'create — an update for a row the server has never seen is refused '
            'for ever',
      );
    });

    test('unlinking removes the contribution', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(db, walletId: walletId, amount: 4000);
      await db.linkTransactionToObjective('goal-1', id);
      await db.unlinkTransactionFromObjective('goal-1', id);

      expect(await db.getObjectiveProgress('goal-1'), 0);
    });

    test('a soft-deleted transaction stops contributing', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(db, walletId: walletId, amount: 4000);
      await db.linkTransactionToObjective('goal-1', id);
      await db.softDeleteTransaction(id);

      expect(await db.getObjectiveProgress('goal-1'), 0);
    });
  });

  group('wallet balance', () {
    test('is opening balance plus every realized effect', () async {
      final walletId = await seedWallet(db, openingBalance: 10000);
      await seedTransaction(db, walletId: walletId, amount: 2500); // expense
      await seedTransaction(
        db,
        walletId: walletId,
        amount: 4000,
        isIncome: true,
      );
      // Unpaid upcoming: not realized, must NOT move the balance.
      await seedTransaction(
        db,
        walletId: walletId,
        amount: 9999,
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
      );
      // Lend: realized even though nothing has been repaid.
      await seedTransaction(
        db,
        walletId: walletId,
        amount: 1000,
        specialType: TransactionSpecialType.credit,
        isPaid: false,
      );

      final balance = await WalletBalanceService(
        db,
      ).calculateWalletBalance(walletId);
      expect(balance, 10000 - 2500 + 4000 - 1000);
    });
  });
}
