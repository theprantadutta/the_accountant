import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Two devices setting the same category cap.
///
/// A cap is one row per (budget, category), enforced by a unique index at both
/// ends. Its id is an implementation detail, so two devices that are offline
/// and both cap Food inside the same budget generate two different ids for what
/// is logically one row.
///
/// Creates are idempotent on id, so the second device's push reached the
/// database as a genuine insert and hit the constraint with no resolution path.
/// The change stayed pending and was retried on every sync, the cursor never
/// advanced, and one duplicated cap wedged the whole account's sync — every
/// other change on that device stopped moving too.
void main() {
  late FakeSyncServer server;
  late AppDatabase deviceA;
  late AppDatabase deviceB;
  const userId = 'cap-user';

  late String budgetId;
  late String categoryId;

  SyncService syncFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: userId),
  );

  /// The live cap rows a device holds for the budget.
  Future<List<CategoryBudgetLimit>> capsOn(AppDatabase db) =>
      db.getCategoryLimitsForBudget(budgetId);

  setUp(() async {
    server = FakeSyncServer();

    deviceA = openTestDatabase();
    await deviceA.claimLocalStore(userId: userId);
    await deviceA.ensureSystemCategoriesExist();
    await seedWallet(deviceA, name: 'Everyday');
    categoryId = await seedCategory(deviceA, name: 'Food');
    budgetId = await seedBudget(deviceA, amount: 100000);

    // B starts from the same shared state, which is what makes the two ids
    // collide rather than simply being two unrelated caps.
    await syncFor(deviceA).syncAll();
    deviceB = openTestDatabase();
    await deviceB.claimLocalStore(userId: userId);
    await syncFor(deviceB).syncAll();
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  test('both devices end up with one cap, not a wedged queue', () async {
    await deviceA.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 40000,
    );
    await deviceB.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 25000,
    );

    final localA = (await capsOn(deviceA)).single.id;
    final localB = (await capsOn(deviceB)).single.id;
    expect(
      localA,
      isNot(localB),
      reason: 'two offline devices cannot agree on a UUID, which is the whole '
          'problem',
    );

    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    expect(await capsOn(deviceA), hasLength(1));
    expect(
      await capsOn(deviceB),
      hasLength(1),
      reason: 'the losing row is dropped rather than kept alongside the '
          'winner, which the unique index would refuse anyway',
    );
    expect((await capsOn(deviceB)).single.id, localA);
  });

  test('the later edit wins, not whoever pushed first', () async {
    await deviceA.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 40000,
    );
    await syncFor(deviceA).syncAll();

    await deviceB.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 25000,
    );
    await syncFor(deviceB).syncAll();

    // A pulls what the server settled on.
    await syncFor(deviceA).syncAll();

    expect(
      (await capsOn(deviceA)).single.amount,
      25000,
      reason: 'converging on whoever happened to push first would discard a '
          'later decision the user actually made',
    );
  });

  test('the losing row leaves nothing pending behind it', () async {
    await deviceA.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 40000,
    );
    await deviceB.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 25000,
    );

    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    final cap = (await capsOn(deviceB)).single;
    expect(
      cap.syncStatus,
      SyncStatus.synced,
      reason: 'a row left pending is retried on every sync, and a create the '
          'server can never accept stops the cursor advancing at all',
    );
  });

  test('a second sync has nothing left to say', () async {
    await deviceA.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 40000,
    );
    await deviceB.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 25000,
    );
    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    final result = await syncFor(deviceB).syncAll();

    expect(
      result.pushedCount,
      0,
      reason: 'the same rejected create being pushed for ever is what wedged '
          'the account',
    );
  });

  test('an unrelated cap on another category is left alone', () async {
    final other = await seedCategory(deviceA, name: 'Travel');
    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    await deviceA.setCategoryLimit(
      budgetId: budgetId,
      categoryId: categoryId,
      amount: 40000,
    );
    await deviceB.setCategoryLimit(
      budgetId: budgetId,
      categoryId: other,
      amount: 25000,
    );

    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();
    await syncFor(deviceA).syncAll();

    expect(
      await capsOn(deviceA),
      hasLength(2),
      reason: 'different categories are different caps; only the same pair '
          'collides',
    );
  });
}
