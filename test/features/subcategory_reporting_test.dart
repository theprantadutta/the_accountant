import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// How a subcategory is counted.
///
/// Two different questions get two different answers, on purpose. "Where did
/// the money go" wants the exact label, so Sandwich is its own line and is
/// never folded into Food. "Have I overspent on food" wants the area, so a Food
/// budget counts what was filed under Sandwich — otherwise setting a budget and
/// then using a subcategory leaves the budget reading zero while the money goes
/// out, and a limit that silently never triggers is worse than no limit.
void main() {
  late AppDatabase db;
  late String wallet;
  late String food;
  late String sandwich;
  late String transport;

  setUp(() async {
    db = openTestDatabase();
    wallet = await seedWallet(db, name: 'Everyday', openingBalance: 500000);
    food = await seedCategory(db, name: 'Food & Dining');
    transport = await seedCategory(db, name: 'Transportation');
    sandwich = await seedCategory(db, name: 'Sandwich');
    await db.customStatement(
      'UPDATE categories SET main_category_id = ? WHERE id = ?',
      [food, sandwich],
    );
  });

  tearDown(() async => db.close());

  group('the family of a category', () {
    test('a parent includes what is filed inside it', () async {
      expect(await db.categoryFamilyIds(food), {food, sandwich});
    });

    test('a category with nothing inside is just itself', () async {
      expect(await db.categoryFamilyIds(transport), {transport});
    });

    test('a subcategory does not drag in its parent or its siblings', () async {
      // Budgeting Sandwich specifically means Sandwich, not all of Food.
      final burger = await seedCategory(db, name: 'Burger');
      await db.customStatement(
        'UPDATE categories SET main_category_id = ? WHERE id = ?',
        [food, burger],
      );

      expect(await db.categoryFamilyIds(sandwich), {sandwich});
    });

    test('a deleted subcategory is not part of the family', () async {
      await db.customStatement(
        'UPDATE categories SET deleted_at = 1 WHERE id = ?',
        [sandwich],
      );

      expect(await db.categoryFamilyIds(food), {food});
    });
  });

  group('what a budget counts', () {
    Future<Transaction> spend(String categoryId, int amount) async {
      final id = await seedTransaction(
        db,
        walletId: wallet,
        categoryId: categoryId,
        amount: amount,
        isIncome: false,
      );
      return (await db.getAllTransactions()).firstWhere((t) => t.id == id);
    }

    test('a budget on the parent counts spending on the child', () async {
      final lunch = await spend(sandwich, 1200);
      final family = await db.categoryFamilyIds(food);

      expect(
        TransactionPolicy.countsTowardBudget(
          lunch,
          budgetCategoryIds: family,
        ),
        isTrue,
        reason: 'a Food budget is about food, not about the word',
      );
    });

    test('a budget on the parent still counts spending on the parent', () async {
      final dinner = await spend(food, 3400);
      final family = await db.categoryFamilyIds(food);

      expect(
        TransactionPolicy.countsTowardBudget(dinner, budgetCategoryIds: family),
        isTrue,
      );
    });

    test('a budget on the parent ignores unrelated categories', () async {
      final bus = await spend(transport, 290);
      final family = await db.categoryFamilyIds(food);

      expect(
        TransactionPolicy.countsTowardBudget(bus, budgetCategoryIds: family),
        isFalse,
      );
    });

    test('a budget on the child ignores the parent', () async {
      // The narrower budget stays narrow: someone limiting Sandwich has not
      // said anything about the rest of what they eat.
      final dinner = await spend(food, 3400);
      final family = await db.categoryFamilyIds(sandwich);

      expect(
        TransactionPolicy.countsTowardBudget(dinner, budgetCategoryIds: family),
        isFalse,
      );
    });

    test('a budget naming no category counts everything on its side', () async {
      final lunch = await spend(sandwich, 1200);

      expect(
        TransactionPolicy.countsTowardBudget(lunch, budgetCategoryIds: const {}),
        isTrue,
      );
      expect(
        TransactionPolicy.countsTowardBudget(lunch, budgetCategoryIds: null),
        isTrue,
      );
    });

    test('direction still decides, family or not', () async {
      final lunch = await spend(sandwich, 1200);
      final family = await db.categoryFamilyIds(food);

      expect(
        TransactionPolicy.countsTowardBudget(
          lunch,
          budgetIsIncome: true,
          budgetCategoryIds: family,
        ),
        isFalse,
        reason: 'an income budget tracks earnings, whatever the category',
      );
    });
  });
}
