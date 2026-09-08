import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// What a budget's amount means, and that it goes on meaning it.
///
/// An amount is a bare count of minor units; nothing else on the row says what
/// kind of money it counts. That was answered with whatever the user's default
/// account happened to be at the moment of reading — so opening a euro account
/// and making it the default turned a $100 budget into a €100 budget, with the
/// figure on screen never changing. A number that changes meaning without
/// changing is the worst way for this to be wrong: there is nothing to notice.
void main() {
  late AppDatabase db;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
  });

  tearDown(() => db.close());

  Future<BudgetView> viewOf(String id) async =>
      BudgetView.fromRow((await db.findBudgetById(id))!);

  group('a budget keeps the currency it was made in', () {
    test('changing the default account does not restate it', () async {
      final dollars = await seedWallet(db, name: 'Checking', currency: 'USD');
      await db.setDefaultWallet(dollars);

      final id = await seedBudget(db, amount: 10000, currency: 'USD');
      expect(await BudgetEngine(db).currencyFor(await viewOf(id)), 'USD');

      // The user opens a euro account and makes it the default.
      final euros = await seedWallet(db, name: 'Holiday', currency: 'EUR');
      await db.setDefaultWallet(euros);

      expect(
        await BudgetEngine(db).currencyFor(await viewOf(id)),
        'USD',
        reason: 'the figure was typed under a dollar sign and has not been '
            'touched since; nothing about opening another account changes what '
            'it says',
      );
    });

    test('archiving the account it was made against does not either', () async {
      final dollars = await seedWallet(db, name: 'Checking', currency: 'USD');
      await db.setDefaultWallet(dollars);
      final id = await seedBudget(db, amount: 10000, currency: 'USD');

      await seedWallet(db, name: 'Holiday', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_archived = 1 WHERE id = ?',
        [dollars],
      );

      expect(await BudgetEngine(db).currencyFor(await viewOf(id)), 'USD');
    });

    test('a budget with no stated currency falls back, as it always did', () async {
      final euros = await seedWallet(db, name: 'Holiday', currency: 'EUR');
      await db.setDefaultWallet(euros);
      final id = await seedBudget(db, amount: 10000);
      await db.customStatement('UPDATE budgets SET currency = NULL');

      expect(
        await BudgetEngine(db).currencyFor(await viewOf(id)),
        'EUR',
        reason: 'a row from before the field, or from a server that predates '
            'it, has to read as something',
      );
    });

    test('spending is converted into the budget currency, not the display one',
        () async {
      final dollars = await seedWallet(db, name: 'Checking', currency: 'USD');
      await db.setDefaultWallet(dollars);
      final food = await seedCategory(db, name: 'Food');
      final id = await seedBudget(
        db,
        amount: 100000,
        currency: 'USD',
        categoryIds: [food],
        startDate: DateTime(2026),
      );
      await seedTransaction(
        db,
        walletId: dollars,
        categoryId: food,
        amount: 25000,
        date: DateTime(2026, 1, 10),
      );

      // The default moves to euros; the budget's own currency should not.
      final euros = await seedWallet(db, name: 'Holiday', currency: 'EUR');
      await db.setDefaultWallet(euros);
      await db.setCustomRate('USD', 'EUR', 0.8);

      final progress = await BudgetEngine(
        db,
      ).progressFor(await viewOf(id), moment: DateTime(2026, 1, 15));

      expect(progress.currency, 'USD');
      expect(
        progress.spent,
        25000,
        reason: 'dollars against a dollar budget need no conversion at all',
      );
    });
  });

  test('a new budget records what the form labelled the field with', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final euros = await seedWallet(db, name: 'Holiday', currency: 'EUR');
    await db.setDefaultWallet(euros);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    final id = await container
        .read(budgetProvider.notifier)
        .addBudget(
          name: 'Food',
          amount: 10000,
          period: BudgetPeriod.monthly,
          startDate: DateTime(2026),
        );

    expect((await db.findBudgetById(id))!.currency, 'EUR');
  });

  group('the upgrade', () {
    test('stamps existing budgets with what they were already read as', () async {
      final dir = await Directory.systemTemp.createTemp('accountant-v24-');
      final file = File('${dir.path}/legacy.sqlite');

      final legacy = AppDatabase(NativeDatabase(file));
      final dollars = await seedWallet(legacy, name: 'Checking', currency: 'USD');
      await legacy.setDefaultWallet(dollars);
      final id = await seedBudget(legacy, amount: 10000);
      // Exactly the schema-24 shape: the column exists in this build, so it is
      // emptied and the version wound back.
      await legacy.customStatement('UPDATE budgets SET currency = NULL');
      await legacy.customStatement('PRAGMA user_version = 24');
      await legacy.close();

      final upgraded = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await upgraded.close();
        if (await file.exists()) await file.delete();
        await dir.delete();
      });

      expect(
        (await upgraded.findBudgetById(id))!.currency,
        'USD',
        reason: 'writing down what it was already being read as changes '
            'nothing today and stops it drifting tomorrow',
      );

      // And it holds when the default moves afterwards.
      final euros = await seedWallet(upgraded, name: 'Holiday', currency: 'EUR');
      await upgraded.setDefaultWallet(euros);
      final view = BudgetView.fromRow((await upgraded.findBudgetById(id))!);
      expect(await BudgetEngine(upgraded).currencyFor(view), 'USD');
    });

    test('leaves it unstated when there are no accounts to read', () async {
      final dir = await Directory.systemTemp.createTemp('accountant-v24-bare-');
      final file = File('${dir.path}/legacy.sqlite');

      final legacy = AppDatabase(NativeDatabase(file));
      final id = await seedBudget(legacy, amount: 10000);
      await legacy.customStatement('UPDATE budgets SET currency = NULL');
      await legacy.customStatement('PRAGMA user_version = 24');
      await legacy.close();

      final upgraded = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await upgraded.close();
        if (await file.exists()) await file.delete();
        await dir.delete();
      });

      expect(
        (await upgraded.findBudgetById(id))!.currency,
        isNull,
        reason: 'inventing one would be worse than falling back at read time',
      );
    });
  });

  test('the currency travels to the other device', () async {
    const userId = 'budget-currency-user';
    final server = FakeSyncServer();

    await db.claimLocalStore(userId: userId);
    final dollars = await seedWallet(db, name: 'Checking', currency: 'USD');
    await db.setDefaultWallet(dollars);
    final id = await seedBudget(db, amount: 10000, currency: 'USD');

    await SyncService(
      database: db,
      transport: FakeSyncTransport(server: server, userId: userId),
    ).syncAll();

    // A second device whose own default is euros.
    final other = openTestDatabase();
    addTearDown(other.close);
    await other.claimLocalStore(userId: userId);
    await SyncService(
      database: other,
      transport: FakeSyncTransport(server: server, userId: userId),
    ).syncAll();

    final pulled = (await other.findBudgetById(id))!;
    expect(pulled.currency, 'USD');
    expect(
      await BudgetEngine(other).currencyFor(BudgetView.fromRow(pulled)),
      'USD',
      reason: 'without it the other device reads the figure in whatever its '
          'own default account happens to be',
    );
  });
}
