import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// A budget's scope is a pair of id lists in text columns, not foreign keys.
///
/// Nothing in the database stops a reference outliving the row it names, and
/// the failure is silent: the budget is still there, still valid, and counts
/// none of the transactions it is supposed to. These tests pin the two things
/// that keep the lists true — pruning on delete, and remapping on merge — and
/// that neither ever downgrades a record's sync state.
void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  List<String> categoriesOf(Budget b) => AppDatabase.decodeIdList(b.categoryIds);
  List<String> walletsOf(Budget b) => AppDatabase.decodeIdList(b.walletIds);

  test('deleting a wallet drops it from the budgets scoped to it', () async {
    final kept = await seedWallet(db, name: 'Cash');
    final doomed = await seedWallet(db, name: 'Old card');
    final budgetId = await seedBudget(db, walletIds: [kept, doomed]);

    await db.softDeleteWallet(doomed);

    final b = await db.findBudgetById(budgetId);
    expect(walletsOf(b!), [kept]);
    expect(
      b.syncStatus,
      SyncStatus.pendingCreate,
      reason: 'a never-uploaded budget must not be downgraded to an update',
    );
  });

  test('a budget scoped only to the deleted wallet widens rather than breaks', () async {
    // Scoping to no wallets means "all wallets". That is a visible widening the
    // user can see and correct — unlike a reference to a wallet that is gone,
    // which just matches nothing and says so nowhere.
    final walletId = await seedWallet(db, name: 'Only');
    final budgetId = await seedBudget(db, walletIds: [walletId]);

    await db.softDeleteWallet(walletId);

    expect(walletsOf((await db.findBudgetById(budgetId))!), isEmpty);
  });

  test('an already-synced budget becomes a pending update, not a create', () async {
    final walletId = await seedWallet(db, name: 'Cash');
    final budgetId = await seedBudget(
      db,
      walletIds: [walletId],
      syncStatus: SyncStatus.synced,
    );

    await db.softDeleteWallet(walletId);

    expect((await db.findBudgetById(budgetId))!.syncStatus, SyncStatus.pendingUpdate);
  });

  test('deleting a wallet leaves category scoping alone, and vice versa', () async {
    final walletId = await seedWallet(db, name: 'Cash');
    final categoryId = await seedCategory(db, name: 'Transport');
    final budgetId = await seedBudget(
      db,
      walletIds: [walletId],
      categoryIds: [categoryId],
    );

    await db.softDeleteWallet(walletId);
    var b = await db.findBudgetById(budgetId);
    expect(walletsOf(b!), isEmpty);
    expect(categoriesOf(b), [categoryId]);

    await db.softDeleteCategory(categoryId);
    b = await db.findBudgetById(budgetId);
    expect(categoriesOf(b!), isEmpty);
  });

  test('a budget that names neither is left completely untouched', () async {
    final walletId = await seedWallet(db, name: 'Cash');
    final other = await seedWallet(db, name: 'Other');
    final budgetId = await seedBudget(
      db,
      walletIds: [walletId],
      syncStatus: SyncStatus.synced,
    );

    await db.softDeleteWallet(other);

    final b = await db.findBudgetById(budgetId);
    expect(walletsOf(b!), [walletId]);
    expect(b.syncStatus, SyncStatus.synced);
  });

  test('an unreadable list is treated as scoping nothing, never thrown on', () async {
    // SQLite has no JSON column type, so a corrupt value can exist locally.
    // Refusing to read it would take down a merge or a delete; the app already
    // reads an empty list as "no scope", so that is what this becomes.
    final walletId = await seedWallet(db, name: 'Cash');
    final budgetId = await seedBudget(db, walletIds: [walletId]);
    await db.customStatement(
      "UPDATE budgets SET wallet_ids = 'not json' WHERE id = ?",
      [budgetId],
    );

    expect(walletsOf((await db.findBudgetById(budgetId))!), isEmpty);
    await db.softDeleteWallet(walletId); // must not throw
  });

  test('pruneDeadBudgetReferences clears both dimensions at once', () async {
    final liveWallet = await seedWallet(db, name: 'Cash');
    final liveCategory = await seedCategory(db, name: 'Transport');
    final budgetId = await seedBudget(
      db,
      walletIds: [liveWallet, 'wallet-vanished'],
      categoryIds: [liveCategory, 'category-vanished'],
      categoryId: 'category-vanished',
      syncStatus: SyncStatus.synced,
    );

    final changed = await db.pruneDeadBudgetReferences();

    expect(changed, 1);
    final b = await db.findBudgetById(budgetId);
    expect(walletsOf(b!), [liveWallet]);
    expect(categoriesOf(b), [liveCategory]);
    expect(b.categoryId, isNull);
    expect(b.syncStatus, SyncStatus.pendingUpdate);
  });

  test('pruneDeadBudgetReferences leaves a clean budget alone', () async {
    final walletId = await seedWallet(db, name: 'Cash');
    final budgetId = await seedBudget(
      db,
      walletIds: [walletId],
      syncStatus: SyncStatus.synced,
    );

    expect(await db.pruneDeadBudgetReferences(), 0);
    expect((await db.findBudgetById(budgetId))!.syncStatus, SyncStatus.synced);
  });

  test('merging categories rewrites both storage locations together', () async {
    final survivor = await seedCategory(db, name: 'Groceries');
    final loser = await seedCategory(db, name: 'Groceries (dup)');
    final budgetId = await seedBudget(
      db,
      categoryIds: [loser],
      categoryId: loser,
      syncStatus: SyncStatus.synced,
    );

    await db.repointBudgetsToCategory(
      fromCategoryId: loser,
      toCategoryId: survivor,
    );

    final b = await db.findBudgetById(budgetId);
    expect(categoriesOf(b!), [survivor]);
    expect(b.categoryId, survivor);
    expect(b.syncStatus, SyncStatus.pendingUpdate);
  });

  test('merging into a category the budget already names collapses the two', () async {
    final survivor = await seedCategory(db, name: 'Groceries');
    final loser = await seedCategory(db, name: 'Groceries (dup)');
    final budgetId = await seedBudget(db, categoryIds: [survivor, loser]);

    await db.repointBudgetsToCategory(
      fromCategoryId: loser,
      toCategoryId: survivor,
    );

    expect(
      categoriesOf((await db.findBudgetById(budgetId))!),
      [survivor],
      reason: 'the survivor must not appear twice',
    );
  });

  test('a deleted budget is not rewritten', () async {
    final walletId = await seedWallet(db, name: 'Cash');
    final budgetId = await seedBudget(db, walletIds: [walletId]);
    await db.customStatement(
      'UPDATE budgets SET deleted_at = 1 WHERE id = ?',
      [budgetId],
    );

    await db.softDeleteWallet(walletId);

    final raw = await db.findBudgetById(budgetId);
    expect(jsonDecode(raw!.walletIds), [walletId]);
  });
}
