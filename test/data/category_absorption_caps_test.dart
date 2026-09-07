import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// What happens to a budget's category caps when that category is absorbed.
///
/// Reconciliation moves transactions, subcategories, budget scopes and
/// associated titles onto the surviving category, then removes the loser. Caps
/// were not in that list, so every cap pointing at the absorbed category was
/// orphaned: pointing at an id that no longer exists, rejected by the server's
/// reference check on every push, and pending for ever after.
void main() {
  late AppDatabase db;
  late String budgetId;

  setUp(() async {
    db = openTestDatabase();
    budgetId = await seedBudget(db, amount: 100000);
  });

  tearDown(() => db.close());

  Future<List<CategoryBudgetLimit>> caps() =>
      db.getCategoryLimitsForBudget(budgetId);

  /// Two rows for one built-in slug, which is what reconciliation exists to
  /// collapse.
  Future<(String survivor, String loser)> duplicatePair() async {
    final survivor = await seedCategory(
      db,
      name: 'Food',
      syncStatus: SyncStatus.synced,
    );
    final loser = await seedCategory(
      db,
      name: 'Food (old)',
      syncStatus: SyncStatus.synced,
    );
    return (survivor, loser);
  }

  test('a cap on the absorbed category moves to the survivor', () async {
    final (survivor, loser) = await duplicatePair();
    await db.setCategoryLimit(
      budgetId: budgetId,
      categoryId: loser,
      amount: 40000,
    );

    await db.absorbDuplicateDefaultCategory(
      loserId: loser,
      survivorId: survivor,
    );

    final live = await caps();
    expect(live, hasLength(1));
    expect(
      live.single.categoryId,
      survivor,
      reason: 'a cap pointing at a category that no longer exists is rejected '
          'by the server on every push and stays pending for ever',
    );
    expect(live.single.amount, 40000);
  });

  test('the moved cap is marked for pushing', () async {
    final (survivor, loser) = await duplicatePair();
    await db.setCategoryLimit(
      budgetId: budgetId,
      categoryId: loser,
      amount: 40000,
    );
    await db.customStatement(
      'UPDATE category_budget_limits SET sync_status = ?',
      [SyncStatus.synced],
    );

    await db.absorbDuplicateDefaultCategory(
      loserId: loser,
      survivorId: survivor,
    );

    expect((await caps()).single.syncStatus, SyncStatus.pendingUpdate);
  });

  group('when both categories cap the same budget', () {
    test('only one cap survives', () async {
      final (survivor, loser) = await duplicatePair();
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: survivor,
        amount: 40000,
      );
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: loser,
        amount: 25000,
      );

      await db.absorbDuplicateDefaultCategory(
        loserId: loser,
        survivorId: survivor,
      );

      expect(
        await caps(),
        hasLength(1),
        reason: 'a budget holds one cap per category, at both ends',
      );
      expect((await caps()).single.categoryId, survivor);
    });

    test('the larger limit is kept', () async {
      final (survivor, loser) = await duplicatePair();
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: survivor,
        amount: 25000,
      );
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: loser,
        amount: 40000,
      );

      await db.absorbDuplicateDefaultCategory(
        loserId: loser,
        survivorId: survivor,
      );

      expect(
        (await caps()).single.amount,
        40000,
        reason: 'a merge is not the place to quietly tighten a cap the user '
            'set — a cap that shrinks on its own reads as the budget being '
            'broken rather than as the merge having done it',
      );
    });

    test('the survivor keeps its own limit when it is the larger', () async {
      final (survivor, loser) = await duplicatePair();
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: survivor,
        amount: 40000,
      );
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: loser,
        amount: 25000,
      );

      await db.absorbDuplicateDefaultCategory(
        loserId: loser,
        survivorId: survivor,
      );

      expect((await caps()).single.amount, 40000);
    });

    test('a never-uploaded loser is dropped, not tombstoned', () async {
      final (survivor, loser) = await duplicatePair();
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: survivor,
        amount: 40000,
      );
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: loser,
        amount: 25000,
      );

      await db.absorbDuplicateDefaultCategory(
        loserId: loser,
        survivorId: survivor,
      );

      final all = await db.select(db.categoryBudgetLimits).get();
      expect(
        all,
        hasLength(1),
        reason: 'the server never held this row, so a tombstone would push a '
            'delete for an id it has never seen',
      );
    });

    test('a loser the server holds is tombstoned so the delete travels',
        () async {
      final (survivor, loser) = await duplicatePair();
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: survivor,
        amount: 40000,
      );
      await db.setCategoryLimit(
        budgetId: budgetId,
        categoryId: loser,
        amount: 25000,
      );
      await db.customStatement(
        'UPDATE category_budget_limits SET sync_status = ?',
        [SyncStatus.synced],
      );

      await db.absorbDuplicateDefaultCategory(
        loserId: loser,
        survivorId: survivor,
      );

      final all = await db.select(db.categoryBudgetLimits).get();
      final retired = all.firstWhere((l) => l.deletedAt != null);
      expect(
        retired.syncStatus,
        SyncStatus.pendingDelete,
        reason: 'otherwise the cloud copy outlives the merge and comes back on '
            'the next full pull',
      );
    });
  });

  test('repointed associated titles are marked for pushing', () async {
    final (survivor, loser) = await duplicatePair();
    await db.into(db.associatedTitles).insert(
      AssociatedTitlesCompanion.insert(
        id: 'title-1',
        title: 'Tesco',
        categoryId: loser,
        syncStatus: const Value(SyncStatus.synced),
      ),
    );

    await db.absorbDuplicateDefaultCategory(
      loserId: loser,
      survivorId: survivor,
    );

    final row = await (db.select(
      db.associatedTitles,
    )..where((a) => a.id.equals('title-1'))).getSingle();
    expect(row.categoryId, survivor);
    expect(
      row.syncStatus,
      SyncStatus.pendingUpdate,
      reason: 'this table syncs now, and only rewriting the id locally left '
          'the server filing the title under a category that no longer exists',
    );
  });
}
