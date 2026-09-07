import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// A database created fresh must enforce exactly what an upgraded one does.
///
/// This is the gap the audit found: the partial unique index on category caps
/// was installed only by the schema-19 migration, so two installs of the same
/// build ran with different constraints. The fresh one accepted a duplicate and
/// then broke the caps screen the first time it read the pair back.
///
/// A partial index cannot be declared as a Drift `@TableIndex`, so it is absent
/// from `allSchemaEntities` and `onCreate` cannot build it. Anything in that
/// position has to be installed from `beforeOpen`, and this is what says so.
void main() {
  late AppDatabase db;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    // Force the open so `beforeOpen` has run.
    await db.customSelect('SELECT 1').get();
  });

  tearDown(() => db.close());

  Future<Set<String>> indexNames() async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
        .get();
    return {for (final row in rows) row.read<String>('name')};
  }

  test('a fresh database has the cap uniqueness index', () async {
    expect(await indexNames(), contains('idx_category_budget_limits_pair'));
  });

  test('a fresh database refuses a second live cap for one pair', () async {
    final budget = await seedBudget(db, name: 'Food');
    final category = await seedCategory(db, name: 'Groceries');

    await db.setCategoryLimit(
      budgetId: budget,
      categoryId: category,
      amount: 5000,
    );

    // The insert the index exists to stop. Going around setCategoryLimit is
    // the point: the guarantee has to live in the schema, not in one caller.
    await expectLater(
      db.customStatement(
        'INSERT INTO category_budget_limits '
        '(id, budget_id, category_id, amount, is_percent, sync_status, '
        'created_at, updated_at) '
        "VALUES ('second', ?, ?, 9999, 0, 1, 1, 1)",
        [budget, category],
      ),
      throwsA(anything),
    );
  });

  test('a deleted cap does not block setting a new one', () async {
    // Why the index is partial rather than a table constraint.
    final budget = await seedBudget(db, name: 'Food');
    final category = await seedCategory(db, name: 'Groceries');

    await db.setCategoryLimit(
      budgetId: budget,
      categoryId: category,
      amount: 5000,
    );
    await db.customStatement(
      'UPDATE category_budget_limits SET deleted_at = 1',
    );

    await db.setCategoryLimit(
      budgetId: budget,
      categoryId: category,
      amount: 7000,
    );

    final live = await db.getCategoryLimitsForBudget(budget);
    expect(live, hasLength(1));
    expect(live.single.amount, 7000);
  });

  test('setting a cap twice edits the row rather than adding one', () async {
    final budget = await seedBudget(db, name: 'Food');
    final category = await seedCategory(db, name: 'Groceries');

    await db.setCategoryLimit(
      budgetId: budget,
      categoryId: category,
      amount: 5000,
    );
    await db.setCategoryLimit(
      budgetId: budget,
      categoryId: category,
      amount: 6000,
    );

    final live = await db.getCategoryLimitsForBudget(budget);
    expect(live, hasLength(1));
    expect(live.single.amount, 6000);
  });

  test('duplicates already in a store are cleaned up on open', () async {
    // What a store created between the index shipping in the migration and it
    // being installed on create actually looks like.
    final budget = await seedBudget(db, name: 'Food');
    final category = await seedCategory(db, name: 'Groceries');

    await db.customStatement('DROP INDEX idx_category_budget_limits_pair');
    for (final (id, amount, updated) in [
      ('older', 5000, 100),
      ('newer', 8000, 200),
    ]) {
      await db.customStatement(
        'INSERT INTO category_budget_limits '
        '(id, budget_id, category_id, amount, is_percent, sync_status, '
        'created_at, updated_at) VALUES (?, ?, ?, ?, 0, 0, 1, ?)',
        [id, budget, category, amount, updated],
      );
    }
    expect(await db.getCategoryLimitsForBudget(budget), hasLength(2));

    // Reopening the same file is what runs beforeOpen again; in this test the
    // installer is invoked directly, which is the same call it makes.
    await db.installPartialIndexesForTest();

    final live = await db.getCategoryLimitsForBudget(budget);
    expect(
      live,
      hasLength(1),
      reason:
          'leaving them would make the index fail to build on every open, for '
          'ever, which is worse than the duplicates',
    );
    expect(live.single.id, 'newer', reason: 'the most recently touched wins');
    expect(await indexNames(), contains('idx_category_budget_limits_pair'));
  });

  test('a cleaned-up duplicate is tombstoned, not dropped', () async {
    final budget = await seedBudget(db, name: 'Food');
    final category = await seedCategory(db, name: 'Groceries');

    await db.customStatement('DROP INDEX idx_category_budget_limits_pair');
    for (final (id, updated, status) in [
      ('older', 100, SyncStatus.synced),
      ('newer', 200, SyncStatus.synced),
    ]) {
      await db.customStatement(
        'INSERT INTO category_budget_limits '
        '(id, budget_id, category_id, amount, is_percent, sync_status, '
        'created_at, updated_at) VALUES (?, ?, ?, 5000, 0, ?, 1, ?)',
        [id, budget, category, status, updated],
      );
    }

    await db.installPartialIndexesForTest();

    final loser = await (db.select(
      db.categoryBudgetLimits,
    )..where((l) => l.id.equals('older'))).getSingle();
    expect(loser.deletedAt, isNotNull);
    expect(
      loser.syncStatus,
      SyncStatus.pendingDelete,
      reason:
          'a row the server already holds has to be told it is gone, or the '
          'duplicate comes straight back on the next pull',
    );
  });

  /// What the repair leaves for the sync to say.
  ///
  /// The cleanup tombstoned duplicate caps but kept an unsynced loser's status
  /// as a pending create — and a create payload has nowhere to say "and it is
  /// deleted", so the very next sync asked the server to create the cap the
  /// repair had just discarded.
  group('after the duplicates are collapsed', () {
    test('a never-uploaded loser is dropped, not left queued', () async {
      final db = openTestDatabase();
      addTearDown(db.close);
      final budget = await seedBudget(db);
      final category = await seedCategory(db);
      await db.customStatement('DROP INDEX idx_category_budget_limits_pair');

      for (final (id, amount, updated) in [
        ('older', 5000, 100),
        ('newer', 8000, 200),
      ]) {
        await db.customStatement(
          'INSERT INTO category_budget_limits (id, budget_id, category_id, '
          'amount, is_percent, sync_status, created_at, updated_at) '
          'VALUES (?, ?, ?, ?, 0, ?, 1, ?)',
          [id, budget, category, amount, SyncStatus.pendingCreate, updated],
        );
      }

      await db.installPartialIndexesForTest();

      expect((await db.getCategoryLimitsForBudget(budget)).single.amount, 8000);
      final all = await db.select(db.categoryBudgetLimits).get();
      expect(
        all.map((l) => l.id),
        ['newer'],
        reason: 'the server was never told about the loser, so there is '
            'nothing to tell it — and a tombstone still carrying a pending '
            'create is a request to create it',
      );
    });

    test('a loser the server holds is tombstoned for pushing', () async {
      final db = openTestDatabase();
      addTearDown(db.close);
      final budget = await seedBudget(db);
      final category = await seedCategory(db);
      await db.customStatement('DROP INDEX idx_category_budget_limits_pair');

      for (final (id, amount, updated) in [
        ('older', 5000, 100),
        ('newer', 8000, 200),
      ]) {
        await db.customStatement(
          'INSERT INTO category_budget_limits (id, budget_id, category_id, '
          'amount, is_percent, sync_status, created_at, updated_at) '
          'VALUES (?, ?, ?, ?, 0, ?, 1, ?)',
          [id, budget, category, amount, SyncStatus.synced, updated],
        );
      }

      await db.installPartialIndexesForTest();

      final loser = (await db.select(db.categoryBudgetLimits).get())
          .firstWhere((l) => l.id == 'older');
      expect(loser.deletedAt, isNotNull);
      expect(loser.syncStatus, SyncStatus.pendingDelete);
      expect(
        loser.updatedAt.millisecondsSinceEpoch ~/ 1000,
        100,
        reason: 'housekeeping does not get to outrank a real edit; the '
            'timestamp is what decides which of two devices\' caps wins',
      );
    });
  });
}
