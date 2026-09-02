import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// What schema 18 does with the two columns it removes.
///
/// A budget carried its limit twice and its category twice. The create form
/// wrote only the older of each, and put the category's display *name* where an
/// id belonged, so the budget matched nothing and read zero. Both columns are
/// dropped here, so whatever they held has to be folded into the real ones
/// first or the user's budgets quietly change meaning.
///
/// The case worth being careful about is a name that resolves to nothing. The
/// budget was already reading zero, but leaving it with no scope makes it count
/// every category, which looks like spending appearing from nowhere. That is
/// recorded rather than done silently.
void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('budget_fold');
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  /// A store shaped like schema 17: legacy columns present, new ones absent.
  Future<File> legacyStore(Future<void> Function(AppDatabase db) seed) async {
    final file = File('${tempDir.path}/legacy.sqlite');
    final db = AppDatabase(NativeDatabase(file));
    await db.customSelect('SELECT 1').get();
    await db.customStatement('ALTER TABLE budgets ADD COLUMN category_id TEXT');
    await db.customStatement('ALTER TABLE budgets ADD COLUMN "limit" REAL');
    await db.customStatement('ALTER TABLE budgets DROP COLUMN period_length');
    await db.customStatement('ALTER TABLE budgets DROP COLUMN rollover');
    await seed(db);
    await db.customStatement('PRAGMA user_version = 17');
    await db.close();
    return file;
  }

  Future<void> insertCategory(
    AppDatabase db,
    String id,
    String name,
  ) => db.customStatement(
    'INSERT INTO categories (id, name, icon_name, color, is_income, '
    'order_index, is_default, sync_status, created_at, updated_at) '
    "VALUES (?, ?, 'x', '#fff', 0, 1, 0, 0, 1, 1)",
    [id, name],
  );

  Future<void> insertBudget(
    AppDatabase db, {
    required String id,
    int amount = 0,
    double? limit,
    String? categoryId,
    String categoryIds = '[]',
  }) => db.customStatement(
    'INSERT INTO budgets (id, name, amount, period, start_date, wallet_ids, '
    'category_ids, category_id, "limit", sync_status, created_at, updated_at) '
    "VALUES (?, 'B', ?, 'monthly', 1, '[]', ?, ?, ?, 0, 1, 1)",
    [id, amount, categoryIds, categoryId, limit],
  );

  test('a limit kept only in dollars becomes the amount in cents', () async {
    final file = await legacyStore((db) async {
      await insertBudget(db, id: 'b1', limit: 250.5);
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    final budget = await upgraded.findBudgetById('b1');
    expect(
      budget!.amount,
      25050,
      reason:
          'the form only ever wrote the dollars column, so this is where every '
          'budget a user actually created keeps its limit',
    );
  });

  test('an amount already set is not overwritten by the old column', () async {
    final file = await legacyStore((db) async {
      await insertBudget(db, id: 'b1', amount: 90000, limit: 12.0);
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    expect((await upgraded.findBudgetById('b1'))!.amount, 90000);
  });

  test('a category held by name is resolved to its id', () async {
    final file = await legacyStore((db) async {
      await insertCategory(db, 'cat-food', 'Food & Dining');
      // Exactly what the old form wrote: the display name, in the id column.
      await insertBudget(db, id: 'b1', limit: 100, categoryId: 'Food & Dining');
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    final budget = await upgraded.findBudgetById('b1');
    expect(
      AppDatabase.decodeIdList(budget!.categoryIds),
      ['cat-food'],
      reason:
          'the budget was watching Food all along; it just said so in a way '
          'nothing could match',
    );
  });

  test('a category held by id is carried across unchanged', () async {
    final file = await legacyStore((db) async {
      await insertCategory(db, 'cat-food', 'Food');
      await insertBudget(db, id: 'b1', limit: 100, categoryId: 'cat-food');
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    expect(
      AppDatabase.decodeIdList(
        (await upgraded.findBudgetById('b1'))!.categoryIds,
      ),
      ['cat-food'],
    );
  });

  test('a name matching nothing is recorded, not dropped in silence', () async {
    final file = await legacyStore((db) async {
      await insertBudget(db, id: 'b1', limit: 100, categoryId: 'Gone');
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    final budget = await upgraded.findBudgetById('b1');
    expect(AppDatabase.decodeIdList(budget!.categoryIds), isEmpty);

    final blocked = await upgraded.blockedIdRepairs();
    final entry = blocked.where((r) => r.oldId == 'Gone').toList();
    expect(
      entry,
      hasLength(1),
      reason:
          'losing the scope makes the budget count every category, which the '
          'user will see as spending appearing from nowhere',
    );
    expect(entry.single.entityTable, 'budgets');
    expect(entry.single.detail, contains('counts every category'));
  });

  test('an existing scope is added to, not replaced', () async {
    final file = await legacyStore((db) async {
      await insertCategory(db, 'cat-a', 'A');
      await insertCategory(db, 'cat-b', 'B');
      await insertBudget(
        db,
        id: 'b1',
        limit: 100,
        categoryId: 'cat-b',
        categoryIds: '["cat-a"]',
      );
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    expect(
      AppDatabase.decodeIdList(
        (await upgraded.findBudgetById('b1'))!.categoryIds,
      ),
      ['cat-a', 'cat-b'],
    );
  });

  test('the legacy columns are gone afterwards', () async {
    final file = await legacyStore((db) async {
      await insertBudget(db, id: 'b1', limit: 100);
    });

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    final columns = await upgraded
        .customSelect('PRAGMA table_info(budgets)')
        .get();
    final names = columns.map((r) => r.read<String>('name')).toSet();

    expect(names, isNot(contains('limit')));
    expect(names, isNot(contains('category_id')));
    expect(names, contains('period_length'));
    expect(names, contains('rollover'));
  });
}
