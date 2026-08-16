import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/services/category_initialization_service.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// The production bootstrap path, end to end.
///
/// The previous two-device suite seeded categories by hand, so it never
/// exercised what actually happens on a real second device: the app initializes
/// its own defaults with fresh random ids, syncs (push first, pull second), and
/// therefore uploaded a complete duplicate set before ever seeing the account's
/// existing categories. These tests drive the real
/// [CategoryInitializationService] so that flow is covered.
void main() {
  late FakeSyncServer server;
  late AppDatabase deviceA;
  late AppDatabase deviceB;
  const userA = 'user-a';

  SyncService serviceFor(AppDatabase db, String userId) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: userId),
  );

  setUp(() async {
    server = FakeSyncServer();
    deviceA = openTestDatabase();
    deviceB = openTestDatabase();
    await assertStoresAreIndependent(deviceA, deviceB);
    await deviceA.claimLocalStore(userId: userA);
    await deviceB.claimLocalStore(userId: userA);
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  Future<Set<String>> slugsOn(AppDatabase db) async =>
      (await db.getAllCategories())
          .where((c) => c.defaultKey != null)
          .map((c) => c.defaultKey!)
          .toSet();

  Future<int> categoryCountOn(AppDatabase db) async =>
      (await db.getAllCategories()).length;

  test('a fresh install seeds exactly one category per built-in', () async {
    await CategoryInitializationService(deviceA).initializeDefaultCategories();

    final categories = await deviceA.getAllCategories();
    expect(categories, hasLength(DefaultCategoryCatalog.all.length));
    expect(await slugsOn(deviceA), DefaultCategoryCatalog.byKey.keys.toSet());
    expect(categories.every((c) => c.isDefault), isTrue);
  });

  test('seeding twice adds nothing', () async {
    await CategoryInitializationService(deviceA).initializeDefaultCategories();
    final created = await CategoryInitializationService(
      deviceA,
    ).initializeDefaultCategories();

    expect(created, isEmpty);
    expect(await categoryCountOn(deviceA), DefaultCategoryCatalog.all.length);
  });

  test(
    'a second device that seeds before syncing does NOT duplicate the account',
    () async {
      // Device A: the account's first device.
      await CategoryInitializationService(
        deviceA,
      ).initializeDefaultCategories();
      final firstSync = await serviceFor(deviceA, userA).syncAll();
      expect(firstSync.success, isTrue, reason: firstSync.userMessage);
      expect(
        server.countIn(userA, 'categories'),
        DefaultCategoryCatalog.all.length,
      );

      // Device B: fresh install, seeds its own defaults with its own random ids
      // BEFORE it has ever talked to the server — exactly what the app does.
      await CategoryInitializationService(
        deviceB,
      ).initializeDefaultCategories();
      final deviceBOwnIds = (await deviceB.getAllCategories())
          .map((c) => c.id)
          .toSet();

      // Sync pushes before it pulls, which is precisely the window the bug lived
      // in.
      await serviceFor(deviceB, userA).syncAll();

      // The account still has ONE category per built-in.
      expect(
        server.countIn(userA, 'categories'),
        DefaultCategoryCatalog.all.length,
        reason: 'device B must not upload a second set of defaults',
      );

      // And device B holds one row per built-in too, having merged its own
      // provisional copies into the account's canonical ones.
      expect(
        await categoryCountOn(deviceB),
        DefaultCategoryCatalog.all.length,
        reason: 'device B must not keep its own duplicate copies',
      );
      expect(await slugsOn(deviceB), await slugsOn(deviceA));

      // Both devices agree on the ids, which is what makes a transaction
      // created on one readable on the other.
      final idsA = {
        for (final c in await deviceA.getAllCategories()) c.defaultKey: c.id,
      };
      final idsB = {
        for (final c in await deviceB.getAllCategories()) c.defaultKey: c.id,
      };
      expect(idsB, idsA);

      // Device B's own provisional ids are gone.
      expect(
        (await deviceB.getAllCategories()).map((c) => c.id).toSet()
          ..removeAll(idsA.values),
        isEmpty,
      );
      expect(deviceBOwnIds.intersection(idsA.values.toSet()), isEmpty);
    },
  );

  test('a third device does not add yet another set', () async {
    await CategoryInitializationService(deviceA).initializeDefaultCategories();
    await serviceFor(deviceA, userA).syncAll();

    await CategoryInitializationService(deviceB).initializeDefaultCategories();
    await serviceFor(deviceB, userA).syncAll();

    final deviceC = openTestDatabase();
    addTearDown(deviceC.close);
    await deviceC.claimLocalStore(userId: userA);
    await CategoryInitializationService(deviceC).initializeDefaultCategories();
    await serviceFor(deviceC, userA).syncAll();

    expect(
      server.countIn(userA, 'categories'),
      DefaultCategoryCatalog.all.length,
    );
    expect(await categoryCountOn(deviceC), DefaultCategoryCatalog.all.length);
  });

  test(
    'transactions written against a provisional category are re-pointed, not lost',
    () async {
      await CategoryInitializationService(
        deviceA,
      ).initializeDefaultCategories();
      await serviceFor(deviceA, userA).syncAll();

      // Device B is offline: it seeds its own defaults and the user records a
      // transaction against one of them.
      await CategoryInitializationService(
        deviceB,
      ).initializeDefaultCategories();
      final provisional = await deviceB.findCategoryByDefaultKey('groceries');
      final walletId = await seedWallet(deviceB, name: 'Wallet B');
      final txnId = await seedTransaction(
        deviceB,
        walletId: walletId,
        categoryId: provisional!.id,
        amount: 4200,
        title: 'Offline shop',
      );

      // Device B comes online.
      await serviceFor(deviceB, userA).syncAll();

      // The transaction survived and now points at the account's canonical
      // category, not at a row that only ever existed on this device.
      final canonical = await deviceA.findCategoryByDefaultKey('groceries');
      final txn = await deviceB.findTransactionById(txnId);
      expect(txn, isNotNull);
      expect(txn!.categoryId, canonical!.id);

      // A further sync gets it to the server under the canonical category.
      final second = await serviceFor(deviceB, userA).syncAll();
      expect(second.success, isTrue, reason: second.userMessage);
      expect(server.countIn(userA, 'transactions'), 1);
      expect(
        server.recordsIn(userA, 'transactions').single['CategoryId'],
        canonical.id,
      );
    },
  );

  test(
    'a brand-new device offline: everything it records reaches the cloud',
    () async {
      // The exact production sequence: install, seed defaults locally, record
      // real financial data offline, then sync for the first time. Every record
      // must arrive — the failure mode this covers is silent, because the rows
      // look perfectly fine on the device while never leaving it.
      await CategoryInitializationService(
        deviceA,
      ).initializeDefaultCategories();
      await serviceFor(deviceA, userA).syncAll();

      // Device B: fresh install, offline.
      await CategoryInitializationService(
        deviceB,
      ).initializeDefaultCategories();
      final walletId = await seedWallet(
        deviceB,
        name: 'Everyday',
        openingBalance: 50000,
      );
      final groceries = await deviceB.findCategoryByDefaultKey('groceries');
      final salary = await deviceB.findCategoryByDefaultKey('salary');
      final expenseId = await seedTransaction(
        deviceB,
        walletId: walletId,
        categoryId: groceries!.id,
        amount: 3300,
        title: 'Offline shop',
      );
      final incomeId = await seedTransaction(
        deviceB,
        walletId: walletId,
        categoryId: salary!.id,
        amount: 250000,
        isIncome: true,
        title: 'Offline payday',
      );

      // Reconnect. Sync until it settles (the first pass re-points records onto
      // the account's canonical categories; the second uploads them).
      for (var i = 0; i < 3; i++) {
        await serviceFor(deviceB, userA).syncAll();
      }

      // Nothing is left stranded on the device.
      expect(
        await deviceB.getPendingSyncTransactions(),
        isEmpty,
        reason:
            'a record downgraded from create to update can never be uploaded, '
            'and would sit here for ever',
      );

      // And the cloud actually has it.
      expect(server.countIn(userA, 'transactions'), 2);
      final titles = server
          .recordsIn(userA, 'transactions')
          .map((r) => r['Title'])
          .toSet();
      expect(titles, {'Offline shop', 'Offline payday'});

      // The wallet made it too — it is rewritten on every transaction, which is
      // what used to strand it.
      expect(server.countIn(userA, 'wallets'), 1);

      // A third, clean device sees the whole picture.
      final deviceC = openTestDatabase();
      addTearDown(deviceC.close);
      await deviceC.claimLocalStore(userId: userA);
      await serviceFor(deviceC, userA).syncAll();

      final onC = await deviceC.getAllTransactions();
      expect(onC.map((t) => t.id).toSet(), {expenseId, incomeId});
      expect(
        await deviceC.getAllCategories(),
        hasLength(DefaultCategoryCatalog.all.length),
      );
    },
  );

  test('default protection survives a cloud restore', () async {
    await CategoryInitializationService(deviceA).initializeDefaultCategories();
    await serviceFor(deviceA, userA).syncAll();

    final restored = await serviceFor(deviceB, userA).restoreFromCloud();
    expect(restored.success, isTrue, reason: restored.userMessage);

    final categories = await deviceB.getAllCategories();
    expect(categories, hasLength(DefaultCategoryCatalog.all.length));
    expect(
      categories.every((c) => c.isDefault),
      isTrue,
      reason:
          'a restore that drops isDefault leaves the app letting the user '
          'delete categories it depends on',
    );
    expect(
      categories.every((c) => c.defaultKey != null),
      isTrue,
      reason: 'without the slug the next device cannot recognise these',
    );
  });

  test('an existing account with duplicated defaults is repaired', () async {
    // Simulate the damage the old code did: two full sets locally.
    await CategoryInitializationService(deviceA).initializeDefaultCategories();
    final walletId = await seedWallet(deviceA);
    final duplicate = await seedCategory(
      deviceA,
      name: 'Groceries',
      isDefault: true,
      // The unique index blocks a second live row with the same slug, so the
      // duplicate is seeded slug-less first, exactly as a pre-migration row
      // would be, and the migration assigns identity.
      syncStatus: SyncStatus.synced,
    );
    final strandedTxn = await seedTransaction(
      deviceA,
      walletId: walletId,
      categoryId: duplicate,
      amount: 1500,
    );

    await deviceA.applyV13DataMigrations();

    // Only one live row claims the slug, AND the duplicate is merged away
    // rather than left as a second slug-less "Groceries" on the user's screen.
    final groceries = (await deviceA.getAllCategories())
        .where((c) => c.defaultKey == 'groceries')
        .toList();
    expect(groceries, hasLength(1));
    expect(
      (await deviceA.getAllCategories()).where((c) => c.name == 'Groceries'),
      hasLength(1),
      reason: 'the duplicate must be removed, not merely denied the slug',
    );

    // ...and the duplicate's transaction was re-filed, not orphaned or deleted.
    final txn = await deviceA.findTransactionById(strandedTxn);
    expect(txn, isNotNull);
    expect(txn!.amount, 1500);
    final stillLive = await deviceA.findCategoryById(txn.categoryId!);
    expect(stillLive, isNotNull);
    expect(stillLive!.deletedAt, isNull);
  });

  test('a user-created category is never merged into a built-in', () async {
    await CategoryInitializationService(deviceA).initializeDefaultCategories();
    // Same NAME as a built-in, but user-created (no slug).
    final custom = await seedCategory(deviceA, name: 'Groceries');

    await deviceA.applyV13DataMigrations();
    await deviceA.mergeDuplicateDefaultCategories();

    final row = await deviceA.findCategoryById(custom);
    expect(
      row,
      isNotNull,
      reason: 'matching a built-in by name is not proof of equivalence',
    );
    expect(row!.deletedAt, isNull);
    expect(row.defaultKey, isNull);
  });
}
