import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

/// Lets a competing write land between the seed's snapshot and its statement.
class _RacingDatabase extends AppDatabase {
  _RacingDatabase() : super(NativeDatabase.memory());

  Future<void> Function()? afterWalletSnapshot;

  @override
  Future<List<Wallet>> getAllWallets() async {
    final rows = await super.getAllWallets();
    final act = afterWalletSnapshot;
    afterWalletSnapshot = null;
    if (act != null) await act();
    return rows;
  }
}

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

    test('a deleted account is never the default either', () async {
      final deleted = await seedWallet(db, name: 'Gone', currency: 'USD');
      await seedWallet(db, name: 'Kept', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1 WHERE id = ?',
        [deleted],
      );
      await db.softDeleteWallet(deleted);

      expect(
        resolveDisplayCurrency(await db.select(db.wallets).get()),
        'EUR',
        reason: 'a deleted account keeps its row and its flag so the deletion '
            'can be pushed; that is not the same as it still being the default',
      );
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

    test('it leaves an established choice alone', () async {
      final established = await seedWallet(db, name: 'Cash', currency: 'USD');
      final stalePreference = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1 WHERE id = ?',
        [established],
      );

      await db.reconcileDefaultWallet(stalePreference);

      final wallets = await db.getAllWallets();
      expect(
        wallets.where((w) => w.isDefault).map((w) => w.id),
        [established],
        reason: 'this is a migration, not an opinion. Reasserting the '
            'preference on every read made it outrank the database — undoing '
            'a choice made in account management, and undoing another '
            "device's choice arriving through a pull",
      );
    });

    test('choosing a default does move the flag', () async {
      final old = await seedWallet(db, name: 'Cash', currency: 'USD');
      final chosen = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement(
        'UPDATE wallets SET is_default = 1 WHERE id = ?',
        [old],
      );

      await db.setDefaultWallet(chosen);

      final wallets = await db.getAllWallets();
      expect(wallets.where((w) => w.isDefault).map((w) => w.id), [chosen]);
    });

    test('the change is queued for the other devices', () async {
      await seedWallet(db, name: 'Cash', currency: 'USD');
      final preferred = await seedWallet(db, name: 'Bank', currency: 'EUR');
      await db.customStatement('UPDATE wallets SET is_default = 0');
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

    test('it does not overrule a choice made after its own read', () async {
      // The seed read an unflagged snapshot, decided in Dart that nothing held
      // the flag, and only then wrote — so a choice established in between was
      // cleared and the older preference installed over it. A transaction round
      // the writes does not protect the reasoning that led to them.
      final raced = _RacingDatabase();
      addTearDown(raced.close);
      final preference = await seedWallet(raced, name: 'Old preference');
      final newer = await seedWallet(raced, name: 'Newer selection');

      raced.afterWalletSnapshot = () => raced.setDefaultWallet(newer);
      await raced.reconcileDefaultWallet(preference);

      expect((await raced.findWalletById(newer))!.isDefault, isTrue);
      expect((await raced.findWalletById(preference))!.isDefault, isFalse);
    });

    test('it seeds again once nothing live holds the flag', () async {
      final archived = await seedWallet(db, name: 'Archived', currency: 'USD');
      final fallback = await seedWallet(db, name: 'Fallback', currency: 'EUR');
      await db.setDefaultWallet(archived);
      await db.customStatement(
        'UPDATE wallets SET is_archived = 1 WHERE id = ?',
        [archived],
      );

      await db.reconcileDefaultWallet(fallback);

      expect(
        (await db.findWalletById(fallback))!.isDefault,
        isTrue,
        reason: 'a still-live earlier choice is a better answer than whichever '
            'account happens to be first',
      );
      expect((await db.findWalletById(archived))!.isDefault, isFalse);
    });

    /// Deleting the default account leaves the row and its flag in place, so
    /// the deletion can be pushed. The seed's SQL checked only `is_archived`,
    /// so that tombstone went on counting as a live default and blocked the
    /// saved fallback — an ordinary deletion, not a race.
    test('a deleted default does not block the fallback', () async {
      final deleted = await seedWallet(db, name: 'Gone', currency: 'GBP');
      await seedWallet(db, name: 'First remaining', currency: 'USD');
      final fallback = await seedWallet(db, name: 'Saved', currency: 'EUR');
      await db.setDefaultWallet(deleted);
      await db.softDeleteWallet(deleted);

      await db.reconcileDefaultWallet(fallback);

      expect((await db.findWalletById(fallback))!.isDefault, isTrue);
      expect(
        await db.displayCurrency(),
        'EUR',
        reason: 'without it the resolver falls through to whichever account '
            'happens to be first, which is not the saved choice',
      );
    });

    test('a target deleted after the snapshot is not flagged', () async {
      final raced = _RacingDatabase();
      addTearDown(raced.close);
      await seedWallet(raced, name: 'Remaining', currency: 'USD');
      final preference = await seedWallet(raced, name: 'Doomed', currency: 'EUR');

      raced.afterWalletSnapshot = () => raced.softDeleteWallet(preference);
      await raced.reconcileDefaultWallet(preference);

      final row = (await raced.findWalletById(preference))!;
      expect(
        row.isDefault,
        isFalse,
        reason: 'eligibility has to be settled by the statement that writes, '
            'not by the read that preceded it',
      );
      expect(row.deletedAt, isNotNull);
      expect(row.syncStatus, SyncStatus.pendingDelete);
    });

    test('no preference changes nothing', () async {
      final only = await seedWallet(db, name: 'Cash', currency: 'USD');
      await db.customStatement('UPDATE wallets SET sync_status = 0');

      await db.reconcileDefaultWallet(null);

      expect((await db.findWalletById(only))!.syncStatus, SyncStatus.synced);
    });
  });

  /// Choosing a default, from either of the two screens that offer it.
  ///
  /// They wrote different things for a while: the accounts screen set the flag,
  /// and the settings path saved a preference and then called the seeding
  /// operation — which by then refused to touch an account that already held
  /// the flag. So the setter saved the new choice and changed nothing, and
  /// every provider reported a default the database disagreed with.
  group('choosing a default', () {
    test('the preference notifier changes the database too', () async {
      final old = await seedWallet(db, name: 'Current', currency: 'USD');
      final chosen = await seedWallet(db, name: 'Chosen', currency: 'EUR');
      await db.setDefaultWallet(old);

      SharedPreferences.setMockInitialValues({'default_wallet_id': old});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(defaultWalletProvider.notifier)
          .setDefaultWallet(chosen);

      expect(container.read(defaultWalletIdProvider), chosen);
      expect(prefs.getString('default_wallet_id'), chosen);
      expect((await db.findWalletById(chosen))!.isDefault, isTrue);
      expect((await db.findWalletById(old))!.isDefault, isFalse);
      expect(
        resolveDisplayCurrency(await db.getAllWallets()),
        'EUR',
        reason: 'the choice has to reach what counts the money, not only what '
            'displays it',
      );
    });

    test('the accounts screen path leaves the same state behind', () async {
      final old = await seedWallet(db, name: 'Current', currency: 'USD');
      final chosen = await seedWallet(db, name: 'Chosen', currency: 'EUR');
      await db.setDefaultWallet(old);

      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(walletProvider.notifier);
      await notifier.loadWallets();

      // Exactly what wallet management calls.
      await notifier.updateWallet(id: chosen, isDefault: true);
      await notifier.loadWallets();

      expect((await db.findWalletById(chosen))!.isDefault, isTrue);
      expect((await db.findWalletById(old))!.isDefault, isFalse);
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
