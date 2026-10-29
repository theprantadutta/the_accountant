import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/dev/sample_data.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/services/investment_service.dart';

import '../helpers/test_database.dart';

/// The debug "Add sample data" action, run against a real in-memory store.
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
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

  Future<SampleDataResult> seed() => SampleDataSeeder(container.read).run();

  test('fills every empty screen, and a second run adds nothing', () async {
    final first = await seed();
    expect(first.alreadyAdded, isFalse);

    // Plans: one of every kind.
    final plans = await db.select(db.plans).get();
    expect(plans.map((p) => p.kind).toSet(), PlanKind.values.toSet());
    expect(plans.any((p) => p.name == SampleDataSeeder.markerPlan), isTrue);
    // Past installments were collected, so the plans show progress.
    final planRows = await (db.select(
      db.transactions,
    )..where((t) => t.planId.isNotNull())).get();
    expect(planRows, isNotEmpty);

    // Investments.
    final holdings = await InvestmentService(db).holdings();
    expect(holdings.length, 3);
    expect(holdings.every((h) => h.wallet.balance > 0), isTrue);

    // Goals, with money saved toward them.
    final goals = await db.getAllObjectives();
    expect(goals.length, 4);
    for (final g in goals) {
      expect(await db.getObjectiveProgress(g.id), greaterThan(0));
    }

    // Lend & borrow: lent and borrowed, one partly repaid, one due ahead.
    final all = await db.getAllTransactions();
    final loans = all
        .where(
          (t) =>
              t.planId == null &&
              (t.specialType == TransactionSpecialType.credit ||
                  t.specialType == TransactionSpecialType.debt),
        )
        .toList();
    expect(loans.length, 3);
    expect(
      loans.any((t) => t.paidAmount > 0 && !TransactionPolicy.isSettled(t)),
      isTrue,
    );
    expect(
      loans.any(
        (t) =>
            t.originalDueDate != null &&
            t.originalDueDate!.isAfter(DateTime.now()),
      ),
      isTrue,
    );

    // Subcategories under the built-in parents.
    final categories = await db.getAllCategories();
    final children = categories.where((c) => c.mainCategoryId != null);
    expect(
      children.map((c) => c.name),
      containsAll(['Eating out', 'Coffee & snacks', 'Ride share']),
    );

    // Subscriptions, upcoming payments, budgets with category caps.
    expect((await db.select(db.recurringConfigs).get()).length, 6);
    expect(
      all.where(
        (t) => t.specialType == TransactionSpecialType.upcoming && !t.isPaid,
      ),
      hasLength(4),
    );
    final budgets = await db.getAllBudgets();
    expect(budgets.length, 3);
    final monthly = budgets.firstWhere((b) => b.name == 'Monthly spending');
    expect(await db.getCategoryLimitsForBudget(monthly.id), hasLength(3));

    // A credit card with a due day and some spending on it.
    final wallets = await db.getAllWallets();
    final card = wallets.firstWhere(
      (w) => w.walletType == WalletType.creditCard,
    );
    expect(card.paymentDueDay, isNotNull);
    expect(card.balance, lessThan(0));

    // Stored balances agree with the transactions behind them.
    final balances = WalletBalanceService(db);
    for (final w in wallets) {
      expect(
        w.balance,
        await balances.calculateWalletBalance(w.id),
        reason: w.name,
      );
    }

    // Everything is waiting to be uploaded.
    expect(
      wallets.every((w) => w.syncStatus == SyncStatus.pendingCreate),
      isTrue,
    );

    // Running it again adds nothing.
    final counts = (
      (await db.select(db.plans).get()).length,
      (await db.getAllTransactions()).length,
      (await db.getAllWallets()).length,
      (await db.getAllCategories()).length,
      (await db.getAllObjectives()).length,
      (await db.getAllBudgets()).length,
    );
    final second = await seed();
    expect(second.alreadyAdded, isTrue);
    expect(second.total, 0);
    expect((
      (await db.select(db.plans).get()).length,
      (await db.getAllTransactions()).length,
      (await db.getAllWallets()).length,
      (await db.getAllCategories()).length,
      (await db.getAllObjectives()).length,
      (await db.getAllBudgets()).length,
    ), counts);
  });

  test('a run that stopped part way can be run again', () async {
    // What a run that stopped part way leaves: the marker account alone.
    final now = DateTime.now();
    await db.addWallet(
      WalletsCompanion(
        id: const Value('half-done'),
        name: const Value(SampleDataSeeder.markerAccount),
        currency: const Value('BDT'),
        balance: const Value(0),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    // And a holding already tracked under a name the sample data uses.
    await InvestmentService(db).create(
      const InvestmentDraft(
        name: 'UCB Income Plus Fund',
        kind: InvestmentKind.fund,
        currency: 'BDT',
      ),
    );

    final result = await seed();
    expect(result.alreadyAdded, isFalse);
    final plans = await db.select(db.plans).get();
    expect(plans.any((p) => p.name == SampleDataSeeder.markerPlan), isTrue);
    // The account it left is reused, not made twice.
    final wallets = await db.getAllWallets();
    expect(
      wallets.where((w) => w.name == SampleDataSeeder.markerAccount).length,
      1,
    );
  });
}
