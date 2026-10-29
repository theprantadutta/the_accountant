import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    show categoryProvider;

import '../helpers/test_database.dart';

/// No category is deleted while it holds transactions, the app's own never
/// are, and a built-in the user deleted is not brought back by seeding.
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureDefaultCategories(DefaultCategoryCatalog.all);
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    await container.read(categoryProvider.notifier).loadCategories();
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<Category> builtIn(String key) async =>
      (await db.findCategoryByDefaultKey(key))!;

  Future<bool> live(String id) async =>
      (await db.getAllCategories()).any((c) => c.id == id);

  String someBuiltInKey() => DefaultCategoryCatalog.all
      .firstWhere((s) => !SystemCategoryKeys.all.contains(s.key))
      .key;

  test(
    'an empty built-in can be deleted, and seeding leaves it gone',
    () async {
      final key = someBuiltInKey();
      final food = await builtIn(key);

      await container.read(categoryProvider.notifier).deleteCategory(food.id);
      expect(await live(food.id), isFalse);

      await db.ensureDefaultCategories(DefaultCategoryCatalog.all);
      expect(await db.findCategoryByDefaultKey(key), isNull);
    },
  );

  test('one holding transactions is kept until they are dealt with', () async {
    final food = await builtIn(someBuiltInKey());
    final wallet = await seedWallet(db, name: 'Cash');
    await seedTransaction(
      db,
      walletId: wallet,
      categoryId: food.id,
      amount: 5000,
      title: 'Tea',
    );

    await container.read(categoryProvider.notifier).deleteCategory(food.id);

    expect(await live(food.id), isTrue);
    expect(
      container.read(categoryProvider).errorMessage,
      contains('move or delete them first'),
    );
  });

  test("the app's own are never deleted, and always come back", () async {
    final transfer = await builtIn(SystemCategoryKeys.transfer);

    await container.read(categoryProvider.notifier).deleteCategory(transfer.id);
    expect(await live(transfer.id), isTrue);
  });
}
