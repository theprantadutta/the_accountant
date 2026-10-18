import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/coach_tool_runner.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';

/// The money coach's tools, run against a real database.
///
/// The coach only knows what these answer, so they have to be right: a search
/// that misses a transaction or a total that counts a transfer is a wrong
/// answer said with confidence. And a write must do nothing until the user
/// confirms it, then do exactly what the card showed.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late CoachToolRunner runner;
  late String bkash;
  late String food;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    bkash = await seedWallet(db, name: 'Bkash', openingBalance: 500000);
    await seedWallet(db, name: 'Brac Bank', openingBalance: 100000);
    food = await seedCategory(db, name: 'Food');
    await seedCategory(db, name: 'Transport');
    await seedCategory(db, name: 'Salary', isIncome: true);

    await seedTransaction(
      db,
      walletId: bkash,
      categoryId: food,
      amount: 25000,
      title: 'Lunch at office',
      date: DateTime(2026, 10, 6, 13),
    );
    await seedTransaction(
      db,
      walletId: bkash,
      categoryId: food,
      amount: 18000,
      title: 'Lunch with team',
      date: DateTime(2026, 10, 14, 13),
    );
    await seedTransaction(
      db,
      walletId: bkash,
      categoryId: food,
      amount: 90000,
      title: 'Dinner',
      date: DateTime(2026, 10, 15, 20),
    );
    // A transfer is not spending, whatever it is called.
    await seedTransaction(
      db,
      walletId: bkash,
      amount: 70000,
      title: 'Lunch money to Brac',
      transactionType: 'transfer',
      date: DateTime(2026, 10, 10),
    );

    await container.read(categoryProvider.notifier).loadCategories();
    await container.read(walletProvider.notifier).loadWallets();
    runner = CoachToolRunner(container.read);
  });

  tearDown(() async {
    // A write reloads reports and budgets in the background, as it does in
    // the app; let that finish before the providers go away.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    container.dispose();
    await db.close();
  });

  Future<Map<String, dynamic>> read(
    String name,
    Map<String, dynamic> args,
  ) async =>
      jsonDecode(await runner.read(CoachToolCall('c1', name, args)))
          as Map<String, dynamic>;

  test('search finds by words and totals only real spending', () async {
    final result = await read('search_transactions', {
      'query': 'lunch',
      'from': '2026-10-01',
      'to': '2026-10-31',
    });

    expect(result['matched'], 3);
    expect(result['total_spent'], 430.0);
    final kinds = [
      for (final t in result['transactions'] as List) (t as Map)['kind'],
    ];
    expect(kinds, containsAll(['expense', 'transfer']));
  });

  test('search narrows by date, amount and kind', () async {
    final result = await read('search_transactions', {
      'kind': 'expense',
      'min_amount': 200,
      'to': '2026-10-14',
    });

    final titles = [
      for (final t in result['transactions'] as List) (t as Map)['title'],
    ];
    expect(titles, ['Lunch at office']);
  });

  test('summarize groups real spending by category', () async {
    final result = await read('summarize', {
      'from': '2026-10-01',
      'to': '2026-10-31',
      'by': 'category',
    });

    expect(result['total_spent'], 1330.0);
    final food = (result['groups'] as List).first as Map;
    expect(food['name'], 'Food');
    expect(food['count'], 3);
  });

  test('an unknown name says what the real ones are', () async {
    final result = await read('search_transactions', {'account': 'Nagad'});

    expect(result['status'], 'error');
    expect(result['error'], contains('Bkash'));
  });

  test('adding waits for the user, then adds exactly what was shown', () async {
    final plan = await runner.plan(
      const CoachToolCall('c2', 'add_transaction', {
        'amount': 120,
        'kind': 'expense',
        'title': 'Rickshaw',
        'category': 'transport',
        'account': 'bkash',
        'date': '2026-10-12',
      }),
    );

    expect(plan.error, isNull);
    expect(plan.preview!.amount, 12000);
    expect(plan.preview!.category, 'Transport');
    expect(plan.preview!.account, 'Bkash');
    // Planned, not done.
    expect(
      (await db.getAllTransactions()).where((t) => t.title == 'Rickshaw'),
      isEmpty,
    );

    final result = jsonDecode(await plan.execute!()) as Map;
    expect(result['status'], 'done');
    final added = (await db.getAllTransactions()).singleWhere(
      (t) => t.title == 'Rickshaw',
    );
    expect(added.amount, 12000);
    expect(added.walletId, bkash);
    expect(added.date, DateTime(2026, 10, 12, 12));
  });

  test(
    'changing a transaction shows each change and only makes those',
    () async {
      final dinner = (await db.getAllTransactions()).singleWhere(
        (t) => t.title == 'Dinner',
      );

      final plan = await runner.plan(
        CoachToolCall('c3', 'update_transaction', {
          'id': dinner.id,
          'amount': 950,
        }),
      );

      expect(plan.preview!.changes.keys, ['amount']);
      await plan.execute!();
      final after = (await db.findTransactionById(dinner.id))!;
      expect(after.amount, 95000);
      expect(after.title, 'Dinner');
      expect(after.categoryId, food);
    },
  );

  test('deleting moves it to Recently deleted', () async {
    final dinner = (await db.getAllTransactions()).singleWhere(
      (t) => t.title == 'Dinner',
    );

    final plan = await runner.plan(
      CoachToolCall('c4', 'delete_transaction', {'id': dinner.id}),
    );
    await plan.execute!();

    expect((await db.findTransactionById(dinner.id))!.deletedAt, isNotNull);
  });

  test(
    'transfers and made-up ids are refused before anything is shown',
    () async {
      final transfer = (await db.getAllTransactions()).singleWhere(
        (t) => t.transactionType == 'transfer',
      );

      final onTransfer = await runner.plan(
        CoachToolCall('c5', 'delete_transaction', {'id': transfer.id}),
      );
      final madeUp = await runner.plan(
        const CoachToolCall('c6', 'update_transaction', {
          'id': 'not-a-real-id',
          'amount': 1,
        }),
      );

      expect(onTransfer.preview, isNull);
      expect(onTransfer.error, contains('transfer'));
      expect(madeUp.preview, isNull);
      expect(madeUp.error, contains('No transaction'));
    },
  );
}
