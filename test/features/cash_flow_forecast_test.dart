import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/app_destination.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/features/forecast/services/shortfall_alerts.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

import '../helpers/test_database.dart';

/// The cash-flow forecast, against a real database.
///
/// It answers "will I run short", so each thing it counts has to be counted
/// exactly once, on the right day, against the right money: a card bill
/// counted with the card's spending, or an installment already paid, would
/// warn about a shortfall that is not coming.
void main() {
  late AppDatabase db;
  late CashFlowForecastService service;
  late String bank;

  // A fixed day, so every date below is exact.
  final now = DateTime(2030, 3, 1, 9);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = CashFlowForecastService(db);
    bank = await seedWallet(db, name: 'Bank', openingBalance: 50000);
  });

  tearDown(() => db.close());

  Future<CashFlowForecast> forecast([int days = 30]) =>
      service.forecast(days: days, now: now);

  Future<String> unpaid(
    String walletId,
    int amount,
    DateTime date, {
    bool isIncome = false,
    String title = 'Bill',
  }) => seedTransaction(
    db,
    walletId: walletId,
    amount: amount,
    date: date,
    isIncome: isIncome,
    title: title,
    isPaid: false,
    specialType: TransactionSpecialType.upcoming,
  );

  Future<void> setWallet(String id, WalletsCompanion changes) =>
      (db.update(db.wallets)..where((w) => w.id.equals(id))).write(changes);

  group('starting point', () {
    test('counts cash and bank accounts, nothing else', () async {
      await seedWallet(db, name: 'Cash', openingBalance: 20000);
      final card = await seedWallet(db, name: 'Card', openingBalance: -9000);
      await setWallet(
        card,
        const WalletsCompanion(walletType: Value(WalletType.creditCard)),
      );
      final deposit = await seedWallet(db, name: 'DPS', openingBalance: 70000);
      await setWallet(
        deposit,
        const WalletsCompanion(walletType: Value(WalletType.deposit)),
      );
      final closed = await seedWallet(db, name: 'Old', openingBalance: 1000);
      await setWallet(closed, const WalletsCompanion(isArchived: Value(true)));
      final hidden = await seedWallet(db, name: 'Not mine', openingBalance: 3);
      await setWallet(
        hidden,
        const WalletsCompanion(excludeFromTotal: Value(true)),
      );

      final f = await forecast();

      expect(f.startingBalance, 70000);
      expect(f.start, DateTime(2030, 3, 1));
      expect(f.daily, hasLength(31));
      expect(f.end, DateTime(2030, 3, 31));
      expect(f.events, isEmpty);
      expect(f.hasShortfall, isFalse);
    });

    test('an account with no exchange rate is left out, and said so', () async {
      await seedWallet(
        db,
        name: 'Euro',
        openingBalance: 10000,
        currency: 'EUR',
      );

      final f = await forecast();

      expect(f.startingBalance, 50000);
      expect(f.unconverted, 1);
    });
  });

  group('upcoming payments', () {
    test('land on their day, in either direction', () async {
      await unpaid(bank, 12000, DateTime(2030, 3, 10, 14), title: 'Rent');
      await unpaid(
        bank,
        30000,
        DateTime(2030, 3, 20),
        isIncome: true,
        title: 'Invoice',
      );
      // Beyond 30 days.
      await unpaid(bank, 5000, DateTime(2030, 4, 2));

      final f = await forecast();

      expect(f.events.map((e) => e.title), ['Rent', 'Invoice']);
      expect(f.events.first.date, DateTime(2030, 3, 10));
      expect(f.events.first.source, ForecastSource.upcoming);
      expect(f.moneyOut, 12000);
      expect(f.moneyIn, 30000);
      expect(f.daily[9].balance, 38000);
      expect(f.endingBalance, 68000);
      expect((await forecast(60)).moneyOut, 17000);
    });

    test('skipped, paid and card payments do not count', () async {
      await seedTransaction(
        db,
        walletId: bank,
        amount: 1000,
        date: DateTime(2030, 3, 5),
        title: 'Already paid',
      );
      final skipped = await unpaid(bank, 2000, DateTime(2030, 3, 6));
      await (db.update(db.transactions)..where((t) => t.id.equals(skipped)))
          .write(const TransactionsCompanion(skipPaid: Value(true)));
      final card = await seedWallet(db, name: 'Card');
      await setWallet(
        card,
        const WalletsCompanion(walletType: Value(WalletType.creditCard)),
      );
      await unpaid(card, 4000, DateTime(2030, 3, 7));

      expect((await forecast()).events, isEmpty);
    });

    test('one already past its date is due now', () async {
      await unpaid(bank, 7000, DateTime(2030, 2, 20), title: 'Late');

      final e = (await forecast()).events.single;

      expect(e.date, DateTime(2030, 3, 1));
      expect(e.overdue, isTrue);
    });
  });

  group('shortfall', () {
    test('found on the first day below zero, with what tips it over', () async {
      await unpaid(bank, 30000, DateTime(2030, 3, 10), title: 'Rent');
      await unpaid(bank, 40000, DateTime(2030, 3, 12), title: 'School fees');
      await unpaid(
        bank,
        100000,
        DateTime(2030, 3, 20),
        isIncome: true,
        title: 'Salary',
      );

      final f = await forecast();

      expect(f.hasShortfall, isTrue);
      expect(f.shortfall!.date, DateTime(2030, 3, 12));
      expect(f.shortfallAmount, 20000);
      expect(f.shortfallEvents.map((e) => e.title), ['School fees']);
      expect(f.lowest.balance, -20000);
      expect(f.lowest.date, DateTime(2030, 3, 12));
      expect(f.endingBalance, 80000);
      expect(f.shortfallWithin(14), isTrue);
      expect(f.shortfallWithin(7), isFalse);
    });

    test('none when what is scheduled is covered', () async {
      await unpaid(bank, 30000, DateTime(2030, 3, 10));
      await unpaid(bank, 20000, DateTime(2030, 3, 12));

      final f = await forecast();

      expect(f.hasShortfall, isFalse);
      expect(f.shortfallAmount, 0);
      expect(f.shortfallEvents, isEmpty);
      expect(f.lowest.balance, 0);
      expect(f.lowest.date, DateTime(2030, 3, 12));
    });

    test('today, when the accounts are already overdrawn', () async {
      await setWallet(bank, const WalletsCompanion(balance: Value(-500)));

      final f = await forecast();

      expect(f.shortfall!.date, DateTime(2030, 3, 1));
      expect(f.shortfallAmount, 500);
      expect(f.shortfallEvents, isEmpty);
    });
  });

  group('plans', () {
    Future<String> emi({bool autoCollect = true}) => PlanService(db).create(
      PlanDraft(
        kind: PlanKind.emi,
        name: 'Phone',
        walletId: bank,
        startDate: DateTime(2030, 1, 15),
        installmentAmount: 10000,
        installmentCount: 6,
        autoCollect: autoCollect,
      ),
    );

    test('counts the next installment, not the ones recorded', () async {
      await emi();
      await PlanService(db).collectDue(now: now);
      // What was collected has already left the account.
      await WalletBalanceService(db).updateWalletBalance(bank);

      final f = await forecast();

      final e = f.events.single;
      expect(e.title, 'Phone');
      expect(e.date, DateTime(2030, 3, 15));
      expect(e.amount, 10000);
      expect(e.isIncome, isFalse);
      expect(e.kind, ForecastEventKind.installment);
      expect(f.startingBalance, 30000);
    });

    test('installments missed by hand are due now', () async {
      await emi(autoCollect: false);

      final f = await forecast();

      expect(f.events.where((e) => e.overdue), hasLength(2));
      expect(
        f.events.where((e) => e.date == DateTime(2030, 3, 15)),
        hasLength(1),
      );
      expect(f.daily.first.balance, 30000);
    });

    test('an FDR pays its profit and its money back in', () async {
      await seedWallet(db, name: 'Savings', openingBalance: 200000);
      final savings = (await db.getAllWallets())
          .firstWhere((w) => w.name == 'Savings')
          .id;
      await PlanService(db).create(
        PlanDraft(
          kind: PlanKind.fdr,
          name: 'FDR',
          walletId: savings,
          startDate: DateTime(2030, 2, 20),
          principal: 100000,
          installmentCount: 3,
          interestRate: 12,
          payout: PlanPayout.monthly,
        ),
      );

      final month = await forecast();
      expect(month.events.single.kind, ForecastEventKind.profit);
      expect(month.events.single.amount, 1000);
      expect(month.events.single.date, DateTime(2030, 3, 20));

      final quarter = await forecast(90);
      expect(quarter.events.map((e) => (e.kind, e.amount)), [
        (ForecastEventKind.profit, 1000),
        (ForecastEventKind.profit, 1000),
        (ForecastEventKind.profit, 1000),
        (ForecastEventKind.maturity, 100000),
      ]);
      expect(quarter.events.every((e) => e.isIncome), isTrue);
    });

    test('a plan paid from a card is left to the card bill', () async {
      final card = await seedWallet(db, name: 'Card');
      await setWallet(
        card,
        const WalletsCompanion(walletType: Value(WalletType.creditCard)),
      );
      await PlanService(db).create(
        PlanDraft(
          kind: PlanKind.emi,
          name: 'TV',
          walletId: card,
          startDate: DateTime(2030, 3, 10),
          installmentAmount: 5000,
          installmentCount: 3,
        ),
      );

      expect((await forecast()).events, isEmpty);
    });
  });

  group('card bills', () {
    late String card;

    setUp(() async {
      card = await seedWallet(db, name: 'Visa');
      await setWallet(
        card,
        const WalletsCompanion(
          walletType: Value(WalletType.creditCard),
          billingCycleDay: Value(25),
          paymentDueDay: Value(15),
        ),
      );
      // On the bill that closed on 25 February.
      await seedTransaction(
        db,
        walletId: card,
        amount: 25000,
        date: DateTime(2030, 2, 10),
        title: 'Flight',
      );
      // Since then, on the next one.
      await seedTransaction(
        db,
        walletId: card,
        amount: 8000,
        date: DateTime(2030, 2, 27),
        title: 'Dinner',
      );
      // Part of the closed bill paid already.
      await seedTransaction(
        db,
        walletId: card,
        amount: 5000,
        isIncome: true,
        transactionType: 'transfer',
        date: DateTime(2030, 2, 28),
        title: 'Card payment',
      );
      await WalletBalanceService(db).updateWalletBalance(card);
    });

    test('counted once, on its due date, less what was paid', () async {
      final f = await forecast();

      final e = f.events.single;
      expect(e.source, ForecastSource.cardBill);
      expect(e.kind, ForecastEventKind.cardBill);
      expect(e.title, 'Visa');
      expect(e.date, DateTime(2030, 3, 15));
      expect(e.amount, 20000);
      // The card's own balance is not spendable money.
      expect(f.startingBalance, 50000);
      expect(f.daily[14].balance, 30000);
    });

    test(
      'the bill building up now falls due after the next statement',
      () async {
        final f = await forecast(60);

        expect(f.events.map((e) => (e.kind, e.date, e.amount)), [
          (ForecastEventKind.cardBill, DateTime(2030, 3, 15), 20000),
          (ForecastEventKind.cardBillNext, DateTime(2030, 4, 15), 8000),
        ]);
        expect(f.moneyOut, 28000);
      },
    );

    test('a card with no dates has no bill to count', () async {
      await setWallet(card, const WalletsCompanion(paymentDueDay: Value(null)));

      expect((await forecast(60)).events, isEmpty);
    });
  });

  group('subscriptions and repeating transactions', () {
    Future<void> schedule({
      required int amount,
      required bool isIncome,
      required String every,
      required DateTime start,
      String title = 'Schedule',
      TransactionSpecialType specialType = TransactionSpecialType.none,
      DateTime? endDate,
      String? walletId,
    }) async {
      final base = await seedTransaction(
        db,
        walletId: walletId ?? bank,
        amount: amount,
        isIncome: isIncome,
        date: start,
        title: title,
        specialType: specialType,
      );
      await RecurringService(database: db).createRecurringConfig(
        baseTransactionId: base,
        reoccurrence: every,
        startDate: start,
        endDate: endDate,
      );
    }

    test('recurring income comes in on every date', () async {
      await schedule(
        amount: 80000,
        isIncome: true,
        every: 'monthly',
        start: DateTime(2030, 2, 25),
        title: 'Salary',
      );

      final f = await forecast(60);

      expect(f.events.map((e) => (e.date, e.amount, e.isIncome, e.kind)), [
        (DateTime(2030, 3, 25), 80000, true, ForecastEventKind.recurringIncome),
        (DateTime(2030, 4, 25), 80000, true, ForecastEventKind.recurringIncome),
      ]);
    });

    test('a weekly subscription counts each week, until it ends', () async {
      await schedule(
        amount: 500,
        isIncome: false,
        every: 'weekly',
        start: DateTime(2030, 2, 26),
        title: 'Music',
        specialType: TransactionSpecialType.subscription,
        endDate: DateTime(2030, 3, 20),
      );

      final f = await forecast();

      expect(f.events.map((e) => e.date), [
        DateTime(2030, 3, 5),
        DateTime(2030, 3, 12),
        DateTime(2030, 3, 19),
      ]);
      expect(f.events.first.kind, ForecastEventKind.subscription);
      expect(f.moneyOut, 1500);
    });

    test('a stopped schedule counts nothing', () async {
      await schedule(
        amount: 500,
        isIncome: false,
        every: 'weekly',
        start: DateTime(2030, 2, 26),
      );
      final config = (await db.getActiveRecurringConfigs()).single;
      await RecurringService(database: db).stopRecurring(config.id);

      expect((await forecast()).events, isEmpty);
    });

    test('one charged to a card is left to the card bill', () async {
      final card = await seedWallet(db, name: 'Card');
      await setWallet(
        card,
        const WalletsCompanion(walletType: Value(WalletType.creditCard)),
      );
      await schedule(
        amount: 1200,
        isIncome: false,
        every: 'monthly',
        start: DateTime(2030, 2, 5),
        walletId: card,
      );

      expect((await forecast()).events, isEmpty);
    });
  });

  group('lend and borrow', () {
    Future<void> loan({
      required bool lent,
      required int amount,
      int paid = 0,
      DateTime? due,
    }) async {
      final id = await seedTransaction(
        db,
        walletId: bank,
        amount: amount,
        isIncome: !lent,
        paidAmount: paid,
        title: lent ? 'Lent to Rafi' : 'Borrowed from Mitu',
        specialType: lent
            ? TransactionSpecialType.credit
            : TransactionSpecialType.debt,
        date: DateTime(2030, 1, 1),
      );
      await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(originalDueDate: Value(due)),
      );
    }

    test('what is still owed falls due; lent money is only expected', () async {
      await loan(
        lent: false,
        amount: 20000,
        paid: 5000,
        due: DateTime(2030, 3, 20),
      );
      await loan(lent: true, amount: 10000, due: DateTime(2030, 3, 18));

      final f = await forecast();

      expect(f.events.map((e) => (e.title, e.amount, e.isIncome, e.expected)), [
        ('Lent to Rafi', 10000, true, true),
        ('Borrowed from Mitu', 15000, false, false),
      ]);
      expect(f.events.first.kind, ForecastEventKind.lent);
      expect(f.events.last.source, ForecastSource.loan);
    });

    test('settled, undated and late lent money is not counted on', () async {
      await loan(
        lent: false,
        amount: 20000,
        paid: 20000,
        due: DateTime(2030, 3, 9),
      );
      await loan(lent: false, amount: 20000);
      await loan(lent: true, amount: 10000, due: DateTime(2030, 2, 1));

      expect((await forecast()).events, isEmpty);
    });

    test('a late debt is due now', () async {
      await loan(lent: false, amount: 9000, due: DateTime(2030, 2, 1));

      final e = (await forecast()).events.single;
      expect(e.date, DateTime(2030, 3, 1));
      expect(e.overdue, isTrue);
    });
  });

  group('shortfall notification', () {
    late SharedPreferences prefs;
    final shown = <({int id, String title, String body})>[];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      shown.clear();
    });

    Future<bool> check([DateTime? at]) => ShortfallAlerts.check(
      db: db,
      prefs: prefs,
      now: at ?? now,
      show: ({required id, required title, required body}) async =>
          shown.add((id: id, title: title, body: body)),
    );

    test('raised once per shortfall date', () async {
      await unpaid(bank, 80000, DateTime(2030, 3, 4), title: 'Rent');

      expect(await check(), isTrue);
      expect(await check(), isFalse);
      expect(await check(DateTime(2030, 3, 2, 18)), isFalse);

      expect(shown, hasLength(1));
      expect(shown.single.title, 'You may run short on 4 Mar');
      expect(shown.single.body, contains('300.00'));
      expect(prefs.getStringList(ShortfallAlerts.storageKey), ['2030-03-04']);
    });

    test(
      'a new date is told about again, and passed dates forgotten',
      () async {
        await unpaid(bank, 80000, DateTime(2030, 3, 4));
        await check();
        // Paid off another way; then a later bill runs short.
        await (db.delete(db.transactions)).go();
        await unpaid(bank, 90000, DateTime(2030, 3, 9));

        expect(await check(DateTime(2030, 3, 5, 9)), isTrue);
        expect(shown, hasLength(2));
        expect(prefs.getStringList(ShortfallAlerts.storageKey), ['2030-03-09']);
        expect(
          shown.last.id,
          isNot(ShortfallAlerts.notificationIdFor(DateTime(2030, 3, 4))),
        );
      },
    );

    test('not raised for a shortfall more than a week away', () async {
      await unpaid(bank, 80000, DateTime(2030, 3, 12));

      expect(await check(), isFalse);
      expect(shown, isEmpty);
    });

    test('in Bangla when the app is', () async {
      SharedPreferences.setMockInitialValues({'selected_locale': 'bn'});
      prefs = await SharedPreferences.getInstance();
      await unpaid(bank, 80000, DateTime(2030, 3, 4));

      await check();

      expect(shown.single.title, contains('কম পড়তে পারে'));
    });

    test('tapping it opens the forecast', () {
      expect(
        NotificationService.linkFor({'action': 'open_forecast'}),
        const DeepLink(AppDestination.forecast),
      );
    });
  });
}
