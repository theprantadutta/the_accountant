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
        'UPDATE wallets SET is_archived = 1 WHERE id = ?',
        [dollars],
      );

      final wallets = await db.getAllWallets();

      expect(
        resolveDisplayCurrency(wallets, preferredId: dollars),
        'EUR',
        reason: 'the user has put that account away; reading their money in a '
            'currency they have retired is not what a default is for',
      );
    });

    test('the database flag outranks the saved preference', () async {
      final preferred = await seedWallet(db, name: 'Cash', currency: 'USD');
      final flagged = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1 WHERE id = ?',
        [flagged],
      );

      final wallets = await db.getAllWallets();

      expect(
        resolveDisplayCurrency(wallets, preferredId: preferred),
        'EUR',
        reason: 'the flag is the only part of this a report can see, so it has '
            'to be the part that decides',
      );
    });

    test('the preference is used when no account carries the flag', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      final preferred = await seedWallet(db, name: 'Bank', currency: 'EUR');

      final wallets = await db.getAllWallets();

      expect(resolveDisplayCurrency(wallets, preferredId: preferred), 'EUR');
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
