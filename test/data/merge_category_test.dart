import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Merging two categories that mean the same thing.
///
/// An import left a phone with two "Travel" categories, splitting the same
/// spending in half. Merging has to move everything filed under one onto the
/// other, take the first away, and get all of that to the server, or the other
/// devices keep the split.
void main() {
  late AppDatabase db;
  late String wallet;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db);
  });

  tearDown(() => db.close());

  test('moves every transaction and removes the source', () async {
    final imported = await seedCategory(
      db,
      name: 'Travel',
      syncStatus: SyncStatus.synced,
    );
    final builtIn = await seedCategory(
      db,
      name: 'Travel',
      isDefault: true,
      defaultKey: 'travel',
      syncStatus: SyncStatus.synced,
    );
    final a = await seedTransaction(
      db,
      walletId: wallet,
      categoryId: imported,
      syncStatus: SyncStatus.synced,
    );
    final b = await seedTransaction(
      db,
      walletId: wallet,
      categoryId: builtIn,
      syncStatus: SyncStatus.synced,
    );

    await db.mergeCategory(sourceId: imported, targetId: builtIn);

    for (final id in [a, b]) {
      expect((await db.findTransactionById(id))!.categoryId, builtIn);
    }
    // The moved row is queued for the server; the one already there is not.
    expect(
      (await db.findTransactionById(a))!.syncStatus,
      isNot(SyncStatus.synced),
    );
    expect((await db.findTransactionById(b))!.syncStatus, SyncStatus.synced);

    final source = await db.findCategoryById(imported);
    expect(source!.deletedAt, isNotNull);
    expect(source.syncStatus, SyncStatus.pendingDelete);
    expect(
      (await db.getAllCategories()).where((c) => c.name == 'Travel'),
      hasLength(1),
    );
  });

  test('a parent merged into its own subcategory lifts it out first', () async {
    final parent = await seedCategory(db, name: 'Transport');
    final child = await seedCategory(
      db,
      name: 'Rickshaw',
      mainCategoryId: parent,
    );

    await db.mergeCategory(sourceId: parent, targetId: child);

    final survivor = (await db.findCategoryById(child))!;
    expect(survivor.mainCategoryId, isNull);
    expect(survivor.deletedAt, isNull);
  });

  test('refuses merges that would change what the history means', () async {
    final food = await seedCategory(db, name: 'Food');
    final salary = await seedCategory(db, name: 'Salary', isIncome: true);
    final correction = await db.requireSystemCategoryId(
      SystemCategoryKeys.balanceCorrection,
    );

    await expectLater(
      db.mergeCategory(sourceId: food, targetId: salary),
      throwsArgumentError,
    );
    await expectLater(
      db.mergeCategory(sourceId: food, targetId: correction),
      throwsArgumentError,
    );
    await expectLater(
      db.mergeCategory(sourceId: food, targetId: food),
      throwsArgumentError,
    );
    expect((await db.findCategoryById(food))!.deletedAt, isNull);
  });

  test('the merge reaches the server', () async {
    final server = FakeSyncServer();
    await db.claimLocalStore(userId: 'u');
    final sync = SyncService(
      database: db,
      transport: FakeSyncTransport(server: server, userId: 'u'),
    );
    final imported = await seedCategory(db, name: 'Travel');
    final builtIn = await seedCategory(db, name: 'Travel (built-in)');
    final txn = await seedTransaction(
      db,
      walletId: wallet,
      categoryId: imported,
    );
    final first = await sync.syncAll();
    expect(first.success, isTrue, reason: first.userMessage);

    await db.mergeCategory(sourceId: imported, targetId: builtIn);
    final second = await sync.syncAll();

    expect(second.success, isTrue, reason: second.userMessage);
    final onServer = server
        .recordsIn('u', 'transactions')
        .singleWhere((r) => r['Id'] == txn || r['id'] == txn);
    expect(onServer['CategoryId'], builtIn);
    expect(
      server.recordsIn('u', 'categories').map((c) => c['Name']),
      isNot(contains('Travel')),
    );
  });
}
