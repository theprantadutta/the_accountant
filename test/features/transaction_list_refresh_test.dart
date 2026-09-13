import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';

/// Recording one transaction should cost one row, not the whole table.
///
/// Every mutation used to call `loadTransactions()`, which re-runs a join over
/// every transaction the user has ever had and rebuilds each one as a Dart
/// object. The price of adding a transaction therefore grew with how many they
/// already owned — worst for exactly the people who use the app most.
///
/// The single-row path only earns its keep if it leaves the list in the state a
/// full reload would have, so that is what these compare against.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async => db.close());

  Future<ProviderContainer> loaded() async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await container.read(walletProvider.notifier).loadWallets();
    await container.read(categoryProvider.notifier).loadCategories();
    await container.read(transactionProvider.notifier).loadTransactions();
    return container;
  }

  /// Let the fan-out a mutation kicks off finish.
  ///
  /// Recording a transaction also refreshes the dashboard and reports, which
  /// pull in the budget provider. Those are still loading when the test ends,
  /// and tearing the container down underneath them throws.
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 100));

  /// The list as the provider holds it, and as a full reload would rebuild it.
  Future<({List<String> held, List<String> reloaded})> compare(
    ProviderContainer container,
  ) async {
    List<String> idsOf() => container
        .read(transactionProvider)
        .transactions
        .map((t) => t.id)
        .toList();

    final held = idsOf();
    await container.read(transactionProvider.notifier).loadTransactions();
    return (held: held, reloaded: idsOf());
  }

  test('adding one lands in the same place a reload would put it', () async {
    final walletId = await seedWallet(db);
    final categoryId = await seedCategory(db, name: 'Groceries');
    // Existing history, so ordering has something to get wrong.
    for (var day = 1; day <= 5; day++) {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: categoryId,
        date: DateTime(2026, 9, day),
        title: 'Day $day',
      );
    }

    final container = await loaded();
    final before = container.read(transactionProvider).transactions.length;

    // Dated in the middle of the run, which is where an append would be wrong.
    await container
        .read(transactionProvider.notifier)
        .addTransaction(
          amount: 1500,
          type: 'expense',
          category: 'Groceries',
          categoryId: categoryId,
          notes: '',
          walletId: walletId,
          date: DateTime(2026, 9, 3, 12),
          title: 'Inserted',
        );

    await settle();
    final result = await compare(container);
    expect(result.held.length, before + 1);
    expect(result.held, result.reloaded);
  });

  test('updating one keeps the list a reload would produce', () async {
    final walletId = await seedWallet(db);
    final categoryId = await seedCategory(db, name: 'Groceries');
    final target = await seedTransaction(
      db,
      walletId: walletId,
      categoryId: categoryId,
      date: DateTime(2026, 9, 3),
      title: 'Before',
    );
    for (final day in [1, 5]) {
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: categoryId,
        date: DateTime(2026, 9, day),
      );
    }

    final container = await loaded();

    // Moving the date is the case that has to re-order rather than replace.
    await container
        .read(transactionProvider.notifier)
        .updateTransaction(
          id: target,
          title: 'After',
          date: DateTime(2026, 9, 9),
        );

    await settle();
    final result = await compare(container);
    expect(result.held, result.reloaded);
    expect(result.held.first, target, reason: 'now the newest');
    expect(
      container
          .read(transactionProvider)
          .transactions
          .firstWhere((t) => t.id == target)
          .title,
      'After',
    );
  });

  test('deleting one leaves the list a reload would produce', () async {
    final walletId = await seedWallet(db);
    final categoryId = await seedCategory(db, name: 'Groceries');
    final doomed = await seedTransaction(
      db,
      walletId: walletId,
      categoryId: categoryId,
      title: 'Doomed',
    );
    await seedTransaction(db, walletId: walletId, categoryId: categoryId);

    final container = await loaded();

    await container
        .read(transactionProvider.notifier)
        .deleteTransaction(doomed);

    await settle();
    final result = await compare(container);
    expect(result.held, isNot(contains(doomed)));
    expect(result.held, result.reloaded);
  });

  test('the category name is resolved, not left blank', () async {
    // The single-row path has to do the same join the whole-table read does;
    // skipping it would show every freshly added transaction as Uncategorized
    // until the next reload.
    final walletId = await seedWallet(db);
    final categoryId = await seedCategory(db, name: 'Groceries');

    final container = await loaded();
    await container
        .read(transactionProvider.notifier)
        .addTransaction(
          amount: 1500,
          type: 'expense',
          category: 'Groceries',
          categoryId: categoryId,
          notes: '',
          walletId: walletId,
          date: DateTime(2026, 9, 3),
          title: 'Milk',
        );

    await settle();
    final added = container
        .read(transactionProvider)
        .transactions
        .firstWhere((t) => t.title == 'Milk');
    expect(added.category, 'Groceries');
  });
}
