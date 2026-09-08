import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';

import '../helpers/test_database.dart';

/// Categories are free, and there is no limit on them.
///
/// They used to stop at ten for anyone who had not paid. That was the wrong
/// thing to charge for: a category is how a person describes their own
/// spending, not a feature of the app. It also bit at the worst possible
/// moment — part-way through recording a transaction, which is exactly when
/// somebody reaches for a name that does not exist yet — and it degraded every
/// report they ran afterwards, because the spending still had to go somewhere.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late CategoryNotifier categories;

  setUp(() async {
    db = openTestDatabase();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    categories = container.read(categoryProvider.notifier);
    await categories.loadCategories();
  });

  tearDown(() {
    container.dispose();
    return db.close();
  });

  test('a free user can add far more than the old cap', () async {
    for (var i = 0; i < 25; i++) {
      await categories.addCategory(
        name: 'Category $i',
        colorCode: '#112233',
        isIncome: false,
      );
    }

    final custom = container
        .read(categoryProvider)
        .categories
        .where((c) => !c.isDefault);
    expect(
      custom.length,
      greaterThanOrEqualTo(25),
      reason: 'the eleventh thing somebody spends money on is not worth '
          'charging them to name',
    );
  });

  test('renaming and deleting are free too', () async {
    await categories.addCategory(
      name: 'Coffee',
      colorCode: '#112233',
      isIncome: false,
    );
    final created = container
        .read(categoryProvider)
        .categories
        .firstWhere((c) => c.name == 'Coffee');

    await categories.updateCategory(id: created.id, name: 'Coffee shops');
    expect(
      container.read(categoryProvider).categories.any(
        (c) => c.name == 'Coffee shops',
      ),
      isTrue,
    );

    await categories.deleteCategory(created.id);
    expect(
      container.read(categoryProvider).categories.any((c) => c.id == created.id),
      isFalse,
    );
  });

  test('nothing asks what a category limit is any more', () {
    // Every other capped entity still answers with its own number; a category
    // falls through to "no limit", which is what the default means here.
    expect(PremiumLimitException.getLimitForEntity('wallet'), 3);
    expect(
      PremiumLimitException.getLimitForEntity('category'),
      999,
      reason: 'the switch no longer has a case for it, and the default is the '
          'no-limit answer',
    );
  });
}
