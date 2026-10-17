import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as ui;

import '../helpers/test_database.dart';

/// A category can be put away without losing what it holds.
///
/// Deleting one leaves its transactions with nothing to say what they were,
/// and a built-in cannot be deleted at all, so a category someone had stopped
/// using sat in every picker for ever. Archived, it leaves the pickers and the
/// title rules, and stays wherever history is shown.
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<ui.CategoryState> loaded() async {
    await container.read(ui.categoryProvider.notifier).loadCategories();
    return container.read(ui.categoryProvider);
  }

  test('an archived category and everything inside it leave the pickers, '
      'and stay in the full list', () async {
    final family = await seedCategory(db, name: 'Family');
    final aunt = await seedCategory(db, name: 'Aunt', mainCategoryId: family);
    final food = await seedCategory(db, name: 'Food');

    await container
        .read(ui.categoryProvider.notifier)
        .setArchived(family, true);
    final state = await loaded();

    expect(state.selectable.map((c) => c.id), contains(food));
    expect(state.selectable.map((c) => c.id), isNot(contains(family)));
    expect(state.selectable.map((c) => c.id), isNot(contains(aunt)));
    expect(state.categories.map((c) => c.id), containsAll([family, aunt]));

    await container
        .read(ui.categoryProvider.notifier)
        .setArchived(family, false);
    expect((await loaded()).selectable.map((c) => c.id), contains(aunt));
  });

  test('archiving is a change other devices hear about', () async {
    final id = await seedCategory(
      db,
      name: 'Mela',
      syncStatus: SyncStatus.synced,
    );
    await db.setCategoryArchived(id, true);
    final row = (await db.findCategoryById(id))!;
    expect(row.isArchived, isTrue);
    expect(row.syncStatus, SyncStatus.pendingUpdate);
  });

  test('the app\'s own bookkeeping categories cannot be archived', () async {
    final transfer = await db.requireSystemCategoryId(
      SystemCategoryKeys.transfer,
    );
    await db.setCategoryArchived(transfer, true);
    expect((await db.findCategoryById(transfer))!.isArchived, isFalse);
  });

  test('a title rule filing into an archived category is set aside for a '
      'broader one', () async {
    final groceries = await seedCategory(db, name: 'Groceries');
    final oldShop = await seedCategory(db, name: 'Old shop');
    final now = DateTime.now();
    for (final (id, title, category) in [
      ('broad', 'mart', groceries),
      ('narrow', 'corner mart', oldShop),
    ]) {
      await db.addAssociatedTitle(
        AssociatedTitlesCompanion(
          id: Value(id),
          title: Value(title),
          categoryId: Value(category),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    }
    expect(await db.categoryForTitle('Corner Mart Dhanmondi'), oldShop);

    await db.setCategoryArchived(oldShop, true);

    expect(await db.categoryForTitle('Corner Mart Dhanmondi'), groceries);
  });
}
