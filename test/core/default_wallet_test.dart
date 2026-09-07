import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_wallet.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/services/wallet_maintenance_service.dart';

import '../helpers/test_database.dart';

/// Which account is the default, and therefore what a figure means.
///
/// There were two answers to this. The entry form resolved the saved preference
/// and accepted it even after the account had been archived; the budget engine
/// read the database and skipped archived accounts. Merging archives the source
/// without touching the preference — so after merging the default account into
/// one held in another currency, the form asked for an amount in dollars and
/// the engine read the stored number as euros. The number never changed on
/// screen.
void main() {
  late AppDatabase db;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
  });

  tearDown(() => db.close());

  group('the shared rule', () {
    test('an archived account is never the default', () async {
      final dollars = await seedWallet(db, name: 'Old', currency: 'USD');
      await seedWallet(db, name: 'New', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1, is_archived = 1 WHERE id = ?',
        [dollars],
      );

      expect(
        resolveDisplayCurrency(await db.getAllWallets()),
        'EUR',
        reason: 'the user has put that account away; reading their money in a '
            'currency they have retired is not what a default is for',
      );
    });

    test('the flagged account wins over the first one', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      final flagged = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1 WHERE id = ?',
        [flagged],
      );

      expect(resolveDisplayCurrency(await db.getAllWallets()), 'EUR');
    });

    test('with nothing flagged it takes the first usable account', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      await seedWallet(db, name: 'Bank', currency: 'EUR');

      expect(resolveDisplayCurrency(await db.getAllWallets()), 'USD');
    });

    test('with nothing to choose from it says dollars', () {
      expect(resolveDisplayCurrency(const []), 'USD');
    });

    test('everything archived still names a currency', () async {
      final only = await seedWallet(db, name: 'Old', currency: 'BDT');
      await db.customStatement(
        'UPDATE wallets SET is_archived = 1 WHERE id = ?',
        [only],
      );

      expect(resolveDisplayCurrency(await db.getAllWallets()), 'BDT');
    });
  });

  /// The saved choice lives where only the UI can see it, so it is written onto
  /// the row before anything counts money. Sharing a resolver was not enough:
  /// the two sides could not be given the same inputs, and with no account
  /// flagged the form followed the preference while the engine took the first
  /// account.
  group('reconciling the saved choice', () {
    test('the preference becomes the flag', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      final preferred = await seedWallet(db, name: 'Bank', currency: 'EUR');

      await db.reconcileDefaultWallet(preferred);

      expect(resolveDisplayCurrency(await db.getAllWallets()), 'EUR');
    });

    test('it takes the flag off whatever held it', () async {
      final old = await seedWallet(db, name: 'Cash', currency: 'USD');
      final preferred = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1 WHERE id = ?',
        [old],
      );

      await db.reconcileDefaultWallet(preferred);

      final wallets = await db.getAllWallets();
      expect(wallets.where((w) => w.isDefault).map((w) => w.id), [preferred]);
    });

    test('the change is queued for the other devices', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      final preferred = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement('UPDATE wallets SET sync_status = 0');

      await db.reconcileDefaultWallet(preferred);

      final row = (await db.findWalletById(preferred))!;
      expect(
        row.syncStatus,
        isNot(SyncStatus.synced),
        reason: 'which account is the default is a choice, not a detail of '
            'this device',
      );
    });

    test('an archived preference is ignored', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      final preferred = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_archived = 1 WHERE id = ?',
        [preferred],
      );

      await db.reconcileDefaultWallet(preferred);

      expect(resolveDisplayCurrency(await db.getAllWallets()), 'USD');
    });

    test('no preference changes nothing', () async {
      final only = await seedWallet(db, name: 'Cash', currency: 'USD');
      await db.customStatement('UPDATE wallets SET sync_status = 0');

      await db.reconcileDefaultWallet(null);

      expect((await db.findWalletById(only))!.syncStatus, SyncStatus.synced);
    });
  });

  test('the form and the engine agree with nothing flagged', () async {
    await seedWallet(db, name: 'First', currency: 'USD');
    final preferred = await seedWallet(db, name: 'Second', currency: 'EUR');

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        defaultWalletIdProvider.overrideWithValue(preferred),
      ],
    );
    addTearDown(container.dispose);
    await container.read(walletProvider.notifier).loadWallets();

    final budgetId = await seedBudget(db, amount: 10000);
    final view = BudgetView.fromRow((await db.findBudgetById(budgetId))!);

    expect(
      await BudgetEngine(db).currencyFor(view),
      container.read(defaultCurrencyProvider),
      reason: 'sharing a function does not make two answers agree when the two '
          'callers cannot be given the same inputs',
    );
  });

  test('the form and the engine agree after the default is merged away', () async {
    final dollars = await seedWallet(db, name: 'Old', currency: 'USD');
    final euros = await seedWallet(db, name: 'New', currency: 'EUR');
    await db.setCustomRate('USD', 'EUR', 0.8);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        defaultWalletIdProvider.overrideWithValue(dollars),
      ],
    );
    addTearDown(container.dispose);
    await container.read(walletProvider.notifier).loadWallets();

    await WalletMaintenanceService(
      db,
    ).mergeInto(sourceId: dollars, destinationId: euros);
    await container.read(walletProvider.notifier).loadWallets();

    final budgetId = await seedBudget(db, amount: 10000);
    final view = BudgetView.fromRow((await db.findBudgetById(budgetId))!);

    expect(
      await BudgetEngine(db).currencyFor(view),
      container.read(defaultCurrencyProvider),
      reason: 'the form labels the amount with one and the engine reads it as '
          'the other, so a hundred dollars became a hundred euros with nothing '
          'on screen changing',
    );
  });
}
