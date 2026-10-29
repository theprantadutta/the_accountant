import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/investments/providers/investments_provider.dart';
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/providers/plans_provider.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/recurring/providers/recurring_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// DEBUG ONLY: fills a test phone with realistic Bangladeshi data, so screens
/// that start out empty (plans, investments, goals, subscriptions, budgets,
/// lend & borrow, card bills, subcategories, upcoming) have something to show.
///
/// Everything is made through the same notifiers and services the forms use,
/// so balances, plan links, recurring schedules and sync status come out the
/// way they would had someone typed it all in. Nothing here is reachable from
/// a release build: the only entry point sits behind `kDebugMode`.

/// Reads a provider. Both `WidgetRef.read` and `ProviderContainer.read` fit.
typedef SampleDataReader = T Function<T>(ProviderListenable<T> provider);

/// What one run made.
class SampleDataResult {
  const SampleDataResult({required this.alreadyAdded, required this.created});

  /// True when the sample data was already there and nothing was added.
  final bool alreadyAdded;

  /// How many of each kind of thing were created, in the order they were made.
  final Map<String, int> created;

  int get total => created.values.fold(0, (s, n) => s + n);

  /// One line for a snackbar.
  String get summary {
    if (alreadyAdded) return 'Sample data is already added.';
    final parts = [
      for (final e in created.entries)
        if (e.value > 0) '${e.value} ${e.key}',
    ];
    return 'Added ${parts.join(', ')}.';
  }
}

/// Seed the sample data, then reload every screen's data.
///
/// Takes the app's container, not the calling screen's `WidgetRef`: adding the
/// first account rebuilds the More screen, which disposed that ref and stopped
/// a run after one account, silently, as the screen was no longer there to show
/// the error.
Future<SampleDataResult> addSampleData(ProviderContainer container) async {
  final result = await SampleDataSeeder(container.read).run();
  if (!result.alreadyAdded) {
    reloadAllDataWith(container.invalidate);
    container.invalidate(plansProvider);
    container.invalidate(investmentsProvider);
    container.invalidate(objectivesProvider);
    container.invalidate(goalsProvider);
    container.invalidate(allRecurringConfigsProvider);
    container.invalidate(activeRecurringConfigsProvider);
    container.invalidate(recurringProvider);
  }
  return result;
}

class SampleDataSeeder {
  SampleDataSeeder(this._read);

  final SampleDataReader _read;

  /// Set once a run has finished. The database check below is what actually
  /// prevents duplicates; this only records that seeding happened here.
  static const prefsFlag = 'sample_data_added_v1';

  /// The account every sample is paid from. It is made first, so on its own
  /// it only means a run started: one that failed part way leaves it behind.
  static const markerAccount = 'DBBL Savings';

  /// Made near the end of a run, so its presence means the data is in.
  static const markerPlan = 'Walton fridge EMI';

  static const _note = 'Sample data';
  static const _currency = 'BDT';

  final Map<String, int> _created = {
    'accounts': 0,
    'subcategories': 0,
    'transactions': 0,
    'subscriptions & recurring': 0,
    'upcoming payments': 0,
    'loans (lend & borrow)': 0,
    'investments': 0,
    'plans': 0,
    'goals': 0,
    'budgets': 0,
    'category limits': 0,
  };

  AppDatabase get _db => _read(databaseProvider);
  TransactionNotifier get _txns => _read(transactionProvider.notifier);

  void _count(String key, [int n = 1]) => _created[key] = _created[key]! + n;

  /// Taka to minor units.
  static int tk(num taka) => (taka * 100).round();

  /// Only a finished run counts. Checking for [markerAccount] here meant a
  /// run that failed after making it could never be retried.
  Future<bool> alreadySeeded() async {
    final plans = await _read(planServiceProvider).allPlans();
    return plans.any((p) => p.name == markerPlan);
  }

  Future<SampleDataResult> run() async {
    if (await alreadySeeded()) {
      return SampleDataResult(alreadyAdded: true, created: _created);
    }

    final now = DateTime.now();
    DateTime daysAgo(int d, [int hour = 13]) =>
        DateTime(now.year, now.month, now.day - d, hour);
    DateTime daysAhead(int d, [int hour = 10]) =>
        DateTime(now.year, now.month, now.day + d, hour);
    DateTime monthsAgo(int m, int day, [int hour = 10]) =>
        DateTime(now.year, now.month - m, day, hour);

    // ---------------------------------------------------------- accounts
    final bank = await _addWallet(
      name: markerAccount,
      type: WalletType.bankAccount,
      opening: tk(6_50_000),
      icon: 'account_balance',
      color: '#F97316',
    );
    final savings = await _addWallet(
      name: 'Prime Bank Savings',
      type: WalletType.bankAccount,
      opening: tk(40_000),
      icon: 'account_balance',
      color: '#0EA5E9',
    );
    final bkash = await _addWallet(
      name: 'bKash (sample)',
      type: WalletType.cash,
      opening: tk(8_500),
      icon: 'wallet',
      color: '#E2136E',
    );
    final card = await _addWallet(
      name: 'EBL Visa Platinum',
      type: WalletType.creditCard,
      opening: 0,
      icon: 'credit_card',
      color: '#8B5CF6',
      creditLimit: tk(2_00_000),
      statementDay: 20,
      dueDay: 5,
    );

    // ------------------------------------------------------- categories
    Future<String> builtIn(String key) => _db.requireSystemCategoryId(key);
    final food = await builtIn('food_dining');
    final transport = await builtIn('transportation');
    final groceries = await builtIn('groceries');
    final shopping = await builtIn('shopping');
    final bills = await builtIn('bills_utilities');
    final education = await builtIn('education');
    final rent = await builtIn('rent');
    final subscriptions = await builtIn('subscriptions');
    final salary = await builtIn('salary');
    final bonus = await builtIn('bonus');
    final healthcare = await builtIn('healthcare');
    final lent = await builtIn(BuiltInCategoryKeys.moneyLent);
    final borrowed = await builtIn(BuiltInCategoryKeys.moneyBorrowed);

    // One level of subcategories: the app keeps categories to a parent and
    // its children (see AddCategoryForm), so there is no third level to fill.
    final eatingOut = await _subcategory(
      'Eating out',
      parent: food,
      icon: 'restaurant',
      color: '#FF8E72',
    );
    final coffee = await _subcategory(
      'Coffee & snacks',
      parent: food,
      icon: 'local_cafe',
      color: '#FFA94D',
    );
    final rideShare = await _subcategory(
      'Ride share',
      parent: transport,
      icon: 'local_taxi',
      color: '#38D9A9',
    );
    final cng = await _subcategory(
      'CNG & rickshaw',
      parent: transport,
      icon: 'directions_car',
      color: '#4ECDC4',
    );

    // ----------------------------------------------- everyday spending
    final everyday = <(String, int, String, String, DateTime)>[
      ('Kacchi Bhai, Dhanmondi', 1250, eatingOut, bkash, daysAgo(2, 21)),
      ('Sultan\'s Dine', 1800, eatingOut, card, daysAgo(9, 20)),
      ('North End Coffee', 450, coffee, bkash, daysAgo(1, 16)),
      ('Crimson Cup', 380, coffee, bkash, daysAgo(6, 17)),
      ('Pathao ride to office', 280, rideShare, bkash, daysAgo(1, 9)),
      ('Uber to Gulshan', 420, rideShare, card, daysAgo(4, 19)),
      ('CNG to Motijheel', 250, cng, bkash, daysAgo(3, 10)),
      ('Rickshaw', 60, cng, bkash, daysAgo(0, 8)),
      ('Shwapno groceries', 4320, groceries, card, daysAgo(5, 18)),
      ('Meena Bazar', 2890, groceries, card, daysAgo(12, 18)),
      ('Daraz order', 3450, shopping, card, daysAgo(8, 22)),
      ('Aarong Panjabi', 5200, shopping, card, daysAgo(16, 17)),
      ('Lazz Pharma', 1180, healthcare, bkash, daysAgo(7, 12)),
    ];
    for (final (title, amount, category, wallet, date) in everyday) {
      await _expense(title, tk(amount), category, wallet, date);
    }
    // A card bill paid from the bank, so the card shows a payment too.
    await _read(transferServiceProvider).createTransfer(
      sourceWalletId: bank,
      destinationWalletId: card,
      amount: tk(15_000),
      date: daysAgo(20, 11),
      title: 'EBL card bill payment',
      notes: _note,
    );
    _count('transactions', 2);

    // ------------------------------------- subscriptions & recurring
    final recurring = _read(recurringServiceProvider);
    Future<void> repeat(
      String title,
      int amount,
      String category,
      String wallet,
      DateTime start, {
      required TransactionSpecialType type,
      bool isIncome = false,
    }) async {
      final id = await _add(
        title: title,
        amount: amount,
        isIncome: isIncome,
        categoryId: category,
        walletId: wallet,
        date: start,
        specialType: type,
      );
      await recurring.createRecurringConfig(
        baseTransactionId: id,
        reoccurrence: 'monthly',
        startDate: start,
      );
      _count('subscriptions & recurring');
    }

    const sub = TransactionSpecialType.subscription;
    const rep = TransactionSpecialType.repetitive;
    await repeat(
      'Salary',
      tk(1_20_000),
      salary,
      bank,
      monthsAgo(3, 25, 9),
      type: rep,
      isIncome: true,
    );
    await repeat(
      'House rent',
      tk(25_000),
      rent,
      bank,
      monthsAgo(3, 1),
      type: rep,
    );
    await repeat(
      'Netflix',
      tk(1_200),
      subscriptions,
      card,
      monthsAgo(3, 12),
      type: sub,
    );
    await repeat(
      'Grameenphone postpaid',
      tk(999),
      bills,
      bkash,
      monthsAgo(2, 7),
      type: sub,
    );
    await repeat(
      'Link3 internet',
      tk(1_500),
      bills,
      bank,
      monthsAgo(2, 3),
      type: sub,
    );
    await repeat(
      'YouTube Premium',
      tk(239),
      subscriptions,
      card,
      monthsAgo(1, 18),
      type: sub,
    );
    await recurring.processRecurringTransactions();

    // ------------------------------------------------ upcoming payments
    final upcoming = <(String, int, String, String, DateTime)>[
      ('DESCO electricity bill', 2350, bills, bkash, daysAhead(5)),
      ('Titas gas bill', 1080, bills, bkash, daysAhead(9)),
      ('School fees - Ayaan', 6500, education, bank, daysAhead(14)),
      ('Car tax token renewal', 9800, transport, bank, daysAhead(25)),
    ];
    for (final (title, amount, category, wallet, date) in upcoming) {
      await _add(
        title: title,
        amount: tk(amount),
        isIncome: false,
        categoryId: category,
        walletId: wallet,
        date: date,
        specialType: TransactionSpecialType.upcoming,
        isPaid: false,
        originalDueDate: date,
      );
      _count('upcoming payments');
    }

    // ---------------------------------------------------- lend & borrow
    // Lending is money out, borrowing money in, as the add form records them.
    final toRafiq = await _add(
      title: 'Lent to Rafiq (cousin)',
      amount: tk(25_000),
      isIncome: false,
      categoryId: lent,
      walletId: bank,
      date: daysAgo(45, 18),
      specialType: TransactionSpecialType.credit,
      originalDueDate: daysAhead(30),
    );
    await _add(
      title: 'Lent to Tanvir',
      amount: tk(8_000),
      isIncome: false,
      categoryId: lent,
      walletId: bkash,
      date: daysAgo(12, 20),
      specialType: TransactionSpecialType.credit,
    );
    await _add(
      title: 'Borrowed from Shamim bhai',
      amount: tk(15_000),
      isIncome: true,
      categoryId: borrowed,
      walletId: bank,
      date: daysAgo(21, 15),
      specialType: TransactionSpecialType.debt,
      originalDueDate: daysAhead(20),
    );
    _count('loans (lend & borrow)', 3);
    // Rafiq has paid part of it back.
    await _read(creditDebtProvider.notifier).recordPayment(
      transactionId: toRafiq,
      paymentAmount: tk(10_000),
      paidOn: daysAgo(10, 19),
    );

    // ------------------------------------------------------ investments
    final investments = _read(investmentServiceProvider);
    Future<String> holding({
      required String name,
      required InvestmentKind kind,
      String? symbol,
      required int buyPrice,
      required double units,
      required int priceNow,
      required DateTime bought,
    }) async {
      // Names are unique, so one already tracked under this name (by hand, or
      // by a run that stopped part way) is used as it is.
      final tracked = (await investments.all())
          .where((i) => i.name.toLowerCase() == name.toLowerCase())
          .firstOrNull;
      if (tracked != null) return tracked.id;
      final id = await investments.create(
        InvestmentDraft(
          name: name,
          kind: kind,
          symbol: symbol,
          currency: _currency,
          notes: _note,
        ),
      );
      await investments.buy(
        id,
        fromWalletId: bank,
        amount: (buyPrice * units).round(),
        units: units,
        date: bought,
      );
      await investments.updatePrice(id, priceNow);
      _count('investments');
      return id;
    }

    final ucbFund = await holding(
      name: 'UCB Income Plus Fund',
      kind: InvestmentKind.fund,
      buyPrice: tk(10.85),
      units: 4600,
      priceNow: tk(11.20),
      bought: daysAgo(70),
    );
    await holding(
      name: 'Square Pharmaceuticals',
      kind: InvestmentKind.stock,
      symbol: 'SQURPHARMA',
      buyPrice: tk(215.40),
      units: 100,
      priceNow: tk(228.10),
      bought: daysAgo(50),
    );
    await holding(
      name: 'BRAC Bank shares',
      kind: InvestmentKind.stock,
      symbol: 'BRACBANK',
      buyPrice: tk(48.30),
      units: 500,
      priceNow: tk(45.90),
      bought: daysAgo(35),
    );

    // ------------------------------------------------------------ plans
    final plans = _read(planServiceProvider);
    Future<void> plan(PlanDraft d) async {
      await plans.create(d);
      _count('plans');
    }

    await plan(
      PlanDraft(
        kind: PlanKind.loan,
        name: 'Brac Bank personal loan',
        walletId: bank,
        startDate: monthsAgo(6, 15),
        principal: tk(5_00_000),
        installmentAmount: PlanMath.installmentFor(
          principal: tk(5_00_000),
          annualRate: 9,
          count: 36,
          frequency: PlanFrequency.monthly,
        ),
        installmentCount: 36,
        interestRate: 9,
        provider: 'BRAC Bank',
        reference: 'PL-2026-04417',
        notes: _note,
      ),
    );
    await plan(
      PlanDraft(
        kind: PlanKind.emi,
        name: markerPlan,
        walletId: card,
        startDate: monthsAgo(4, 10),
        principal: tk(84_990),
        installmentAmount: PlanMath.installmentFor(
          principal: tk(84_990),
          annualRate: null,
          count: 12,
          frequency: PlanFrequency.monthly,
        ),
        installmentCount: 12,
        categoryId: shopping,
        provider: 'Walton',
        notes: _note,
      ),
    );
    await plan(
      PlanDraft(
        kind: PlanKind.dps,
        name: 'Brac Bank DPS',
        walletId: bank,
        startDate: monthsAgo(8, 5),
        installmentAmount: tk(5_000),
        installmentCount: 60,
        interestRate: 7.5,
        maturityAmount: PlanMath.dpsMaturity(
          installment: tk(5_000),
          annualRate: 7.5,
          count: 60,
          frequency: PlanFrequency.monthly,
        ),
        taxRate: 10,
        provider: 'BRAC Bank',
        notes: _note,
      ),
    );
    await plan(
      PlanDraft(
        kind: PlanKind.fdr,
        name: 'City Bank FDR',
        walletId: bank,
        startDate: monthsAgo(3, 2),
        principal: tk(2_00_000),
        installmentCount: 12,
        interestRate: 8.5,
        maturityAmount: PlanMath.fdrMaturity(
          principal: tk(2_00_000),
          annualRate: 8.5,
          months: 12,
        ),
        taxRate: 10,
        provider: 'City Bank',
        reference: 'FDR-118342',
        notes: _note,
      ),
    );
    await plan(
      PlanDraft(
        kind: PlanKind.bond,
        name: 'Sanchayapatra',
        walletId: bank,
        startDate: monthsAgo(7, 1),
        principal: tk(3_00_000),
        installmentCount: 3,
        frequency: PlanFrequency.yearly,
        interestRate: 11.04,
        payout: PlanPayout.quarterly,
        maturityAmount: tk(3_00_000),
        taxRate: 10,
        provider: '3-month profit based Sanchayapatra',
        notes: _note,
      ),
    );
    await plan(
      PlanDraft(
        kind: PlanKind.insurance,
        name: 'MetLife life policy',
        walletId: bank,
        startDate: monthsAgo(5, 20),
        installmentAmount: tk(3_000),
        installmentCount: 120,
        maturityAmount: tk(4_50_000),
        provider: 'MetLife Bangladesh',
        reference: 'POL-77120394',
        notes: _note,
      ),
    );
    await plan(
      PlanDraft(
        kind: PlanKind.sip,
        name: 'UCB Income Plus SIP',
        walletId: bank,
        startDate: monthsAgo(3, 8),
        installmentAmount: tk(3_000),
        installmentCount: 36,
        investmentId: ucbFund,
        provider: 'UCB Asset Management',
        notes: _note,
      ),
    );
    // Whatever already fell due is recorded now, as the plan form does.
    await plans.collectDue();

    // ------------------------------------------------------------ goals
    final objectives = _read(objectivesServiceProvider);
    final transfers = _read(transferServiceProvider);
    Future<void> goal(
      String name, {
      required int target,
      DateTime? end,
      required String icon,
      required String color,
      bool pinned = false,
      List<(int, DateTime)> deposits = const [],
    }) async {
      final id = await objectives.createObjective(
        name: name,
        targetAmount: target,
        type: 'goal',
        startDate: monthsAgo(4, 1),
        endDate: end,
        iconName: icon,
        color: color,
        isPinned: pinned,
      );
      // Saving toward a goal is moving money into savings; the incoming leg
      // is what the goal counts.
      for (final (amount, date) in deposits) {
        final (_, inId) = await transfers.createTransfer(
          sourceWalletId: bank,
          destinationWalletId: savings,
          amount: amount,
          date: date,
          title: 'Saved for $name',
          notes: _note,
        );
        await objectives.linkTransaction(id, inId);
        _count('transactions', 2);
      }
      _count('goals');
    }

    await goal(
      'Hajj fund',
      target: tk(8_00_000),
      end: DateTime(now.year + 3, 6, 1),
      icon: 'flight',
      color: '#10B981',
      pinned: true,
      deposits: [(tk(30_000), daysAgo(80)), (tk(30_000), daysAgo(50))],
    );
    await goal(
      'Cox\'s Bazar trip',
      target: tk(60_000),
      end: daysAhead(120),
      icon: 'flight',
      color: '#0EA5E9',
      deposits: [(tk(12_000), daysAgo(40)), (tk(8_000), daysAgo(15))],
    );
    await goal(
      'Emergency fund',
      target: tk(3_00_000),
      icon: 'medical_services',
      color: '#F59E0B',
      deposits: [(tk(50_000), daysAgo(60))],
    );
    // A bonus put straight toward the laptop.
    final laptopId = await objectives.createObjective(
      name: 'New laptop',
      targetAmount: tk(1_40_000),
      type: 'goal',
      startDate: monthsAgo(2, 1),
      endDate: daysAhead(90),
      iconName: 'work',
      color: '#6366F1',
    );
    _count('goals');
    await _add(
      title: 'Durga Puja bonus (for laptop)',
      amount: tk(45_000),
      isIncome: true,
      categoryId: bonus,
      walletId: bank,
      date: daysAgo(18, 11),
      objectiveId: laptopId,
    );

    // ---------------------------------------------------------- budgets
    final budgets = _read(budgetProvider.notifier);
    final monthStart = DateTime(now.year, now.month, 1);
    final monthly = await budgets.addBudget(
      name: 'Monthly spending',
      amount: tk(80_000),
      period: BudgetPeriod.monthly,
      startDate: monthStart,
      currency: _currency,
      isPinned: true,
    );
    await budgets.addBudget(
      name: 'Groceries',
      amount: tk(18_000),
      period: BudgetPeriod.monthly,
      startDate: monthStart,
      currency: _currency,
      categoryIds: [groceries],
    );
    await budgets.addBudget(
      name: 'Eating out',
      amount: tk(3_000),
      period: BudgetPeriod.weekly,
      startDate: DateTime(now.year, now.month, now.day - (now.weekday - 1)),
      currency: _currency,
      categoryIds: [eatingOut, coffee],
    );
    _count('budgets', 3);
    for (final (category, amount) in [
      (food, tk(15_000)),
      (transport, tk(6_000)),
      (shopping, tk(10_000)),
    ]) {
      await _db.setCategoryLimit(
        budgetId: monthly,
        categoryId: category,
        amount: amount,
      );
      _count('category limits');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(prefsFlag, true);
    } catch (_) {
      // Only a record that it ran; the database check is what counts.
    }

    await _read(walletProvider.notifier).loadWallets();
    await _txns.loadTransactions(silent: true);
    return SampleDataResult(alreadyAdded: false, created: _created);
  }

  // --------------------------------------------------------------- helpers

  /// Add an account through the accounts notifier and return its id.
  Future<String> _addWallet({
    required String name,
    required WalletType type,
    required int opening,
    required String icon,
    required String color,
    int? creditLimit,
    int? statementDay,
    int? dueDay,
  }) async {
    // A failed earlier run may have made it already; carry on with that one.
    final existing = (await _db.getAllWallets())
        .where((w) => w.name == name && w.currency == _currency)
        .firstOrNull;
    if (existing != null) return existing.id;
    final before = {for (final w in await _db.getAllWallets()) w.id};
    await _read(walletProvider.notifier).addWallet(
      name: name,
      currency: _currency,
      balance: opening,
      iconName: icon,
      color: color,
      walletType: type,
      creditLimit: creditLimit,
      billingCycleDay: statementDay,
      paymentDueDay: dueDay,
    );
    final added = (await _db.getAllWallets()).firstWhere(
      (w) => !before.contains(w.id) && w.name == name,
    );
    _count('accounts');
    return added.id;
  }

  /// A child of [parent] called [name], made unless it is already there.
  Future<String> _subcategory(
    String name, {
    required String parent,
    required String icon,
    required String color,
  }) async {
    Category? existing() => _read(categoryProvider).categories
        .where((c) => c.mainCategoryId == parent && c.name == name)
        .firstOrNull;
    final notifier = _read(categoryProvider.notifier);
    await notifier.loadCategories(silent: true);
    final found = existing();
    if (found != null) return found.id;
    await notifier.addCategory(
      name: name,
      colorCode: color,
      isIncome: false,
      iconName: icon,
      mainCategoryId: parent,
    );
    _count('subcategories');
    return existing()!.id;
  }

  Future<void> _expense(
    String title,
    int amount,
    String categoryId,
    String walletId,
    DateTime date,
  ) async {
    await _add(
      title: title,
      amount: amount,
      isIncome: false,
      categoryId: categoryId,
      walletId: walletId,
      date: date,
    );
    _count('transactions');
  }

  /// Add a transaction the way the add form does.
  Future<String> _add({
    required String title,
    required int amount,
    required bool isIncome,
    required String categoryId,
    required String walletId,
    required DateTime date,
    TransactionSpecialType specialType = TransactionSpecialType.none,
    bool isPaid = true,
    DateTime? originalDueDate,
    String? objectiveId,
  }) async {
    final id = await _txns.addTransactionFull(
      amount: amount,
      isIncome: isIncome,
      categoryId: categoryId,
      walletId: walletId,
      dateTime: date,
      title: title,
      notes: _note,
      specialType: specialType,
      isPaid: isPaid,
      originalDueDate: originalDueDate,
      objectiveId: objectiveId,
    );
    if (id == null) {
      throw StateError(
        'Could not add "$title": ${_read(transactionProvider).errorMessage}',
      );
    }
    return id;
  }
}
