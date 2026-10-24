import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';
import 'package:the_accountant/features/zakat/services/zakat_reminder.dart';
import 'package:the_accountant/features/zakat/services/zakat_service.dart';
import 'package:uuid/uuid.dart';

import '../helpers/test_database.dart';

/// Zakat on what the app knows: every line, the nisab, and what is left.
///
/// The figure is one people act on once a year, so it has to come from the
/// same balances every other screen shows, leave out what is not zakatable,
/// take off what is owed now, and not shrink each time something is paid.
void main() {
  late AppDatabase db;
  late ZakatService zakat;

  /// 150.00 a gram of silver: a nisab of 612.36 g × 150 = 91,854.00.
  const silver = ZakatSettings(silverPricePerGram: 15000);
  const silverNisab = 9185400;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    zakat = ZakatService(db);
  });

  tearDown(() => db.close());

  Future<String> wallet(
    String name,
    int balance, {
    WalletType type = WalletType.cash,
    String icon = 'wallet',
    String currency = 'BDT',
    bool archived = false,
    bool excluded = false,
  }) async {
    final id = await seedWallet(
      db,
      name: name,
      openingBalance: balance,
      currency: currency,
    );
    await (db.update(db.wallets)..where((w) => w.id.equals(id))).write(
      WalletsCompanion(
        walletType: Value(type),
        iconName: Value(icon),
        isArchived: Value(archived),
        excludeFromTotal: Value(excluded),
      ),
    );
    return id;
  }

  Future<ZakatReport> compute(ZakatSettings s, {DateTime? now}) =>
      zakat.compute(s, currency: 'BDT', now: now);

  group('the nisab', () {
    test('above it, zakat is 2.5% of the net wealth', () async {
      await wallet('Cash', 20000000);
      final r = await compute(silver);
      expect(r.nisab, silverNisab);
      expect(r.wealth, 20000000);
      expect(r.meetsNisab, isTrue);
      expect(r.due, 500000);
      expect(r.left, 500000);
      expect(r.shortfall, 0);
    });

    test('below it, nothing is due and the shortfall is shown', () async {
      await wallet('Cash', 5000000);
      final r = await compute(silver);
      expect(r.meetsNisab, isFalse);
      expect(r.due, 0);
      expect(r.rateOfNet, 125000, reason: 'still shown for reference');
      expect(r.shortfall, silverNisab - 5000000);
    });

    test('gold sets a higher bar than silver for the same wealth', () async {
      await wallet('Cash', 20000000);
      // 12,000.00 a gram: 87.48 g × 12,000 = 1,049,760.00.
      final gold = silver.copyWith(
        basis: NisabBasis.gold,
        goldPricePerGram: 1200000,
      );
      final r = await compute(gold);
      expect(r.nisab, 104976000);
      expect(r.meetsNisab, isFalse);
      expect(r.due, 0);
      expect(
        (await compute(gold.copyWith(basis: NisabBasis.silver))).due,
        500000,
        reason: 'switching back keeps the silver price',
      );
    });

    test(
      'without a price it cannot be known, and nothing is claimed',
      () async {
        await wallet('Cash', 20000000);
        final r = await compute(const ZakatSettings());
        expect(r.basis, NisabBasis.silver, reason: 'silver by default');
        expect(r.nisab, isNull);
        expect(r.meetsNisab, isNull);
        expect(r.due, 0);
      },
    );
  });

  group('what is counted', () {
    test('each kind of wealth is its own line, and debts come off', () async {
      final cash = await wallet('Cash', 10000000);
      await wallet('Bank', 5000000, type: WalletType.bankAccount);
      await wallet('Overdrawn', -300000, type: WalletType.bankAccount);
      await wallet('DPS', 2000000, type: WalletType.deposit);
      await wallet('Growth Fund', 1500000, type: WalletType.investment);
      await wallet('Necklace', 4000000, type: WalletType.asset, icon: 'gold');
      await wallet('Flat', 900000000, type: WalletType.asset, icon: 'home');
      await wallet('Card', -700000, type: WalletType.creditCard);
      await wallet('Card paid ahead', 50000, type: WalletType.creditCard);
      await wallet('Closed', 8000000, archived: true);
      await wallet('Joint pot', 8000000, excluded: true);
      await seedTransaction(
        db,
        walletId: cash,
        amount: 1000000,
        paidAmount: 400000,
        title: 'Rahim',
        specialType: TransactionSpecialType.credit,
      );
      await seedTransaction(
        db,
        walletId: cash,
        amount: 500000,
        isIncome: true,
        title: 'Karim',
        specialType: TransactionSpecialType.debt,
      );
      await seedTransaction(
        db,
        walletId: cash,
        amount: 200000,
        paidAmount: 200000,
        title: 'Settled',
        specialType: TransactionSpecialType.credit,
      );

      final r = await compute(silver);
      Map<String, int> amounts(ZakatGroup g) => {
        for (final l in r.of(g)) l.name: l.amount,
      };

      expect(amounts(ZakatGroup.cash), {'Cash': 10000000, 'Bank': 5000000});
      expect(amounts(ZakatGroup.deposits), {'DPS': 2000000});
      expect(amounts(ZakatGroup.investments), {'Growth Fund': 1500000});
      expect(amounts(ZakatGroup.metals), {'Necklace': 4000000});
      expect(amounts(ZakatGroup.lent), {'Rahim': 600000});
      expect(amounts(ZakatGroup.borrowed), {'Karim': 500000});
      expect(amounts(ZakatGroup.cards), {'Card': 700000});

      final flat = r.of(ZakatGroup.otherAssets).single;
      expect(flat.name, 'Flat');
      expect(flat.included, isFalse, reason: 'a home is not zakatable');

      expect(
        r.wealth,
        10000000 + 5000000 + 2000000 + 1500000 + 4000000 + 600000,
      );
      expect(r.deductions, 500000 + 700000);
      expect(r.net, r.wealth - r.deductions);
      expect(r.due, (r.net * 0.025).round());
    });

    test('no gold yet is simply no metals line', () async {
      await wallet('Cash', 20000000);
      final r = await compute(silver);
      expect(r.of(ZakatGroup.metals), isEmpty);
    });

    test('any line can be switched off, and an asset switched on', () async {
      final bank = await wallet('Bank', 20000000, type: WalletType.bankAccount);
      final shop = await wallet(
        'Shop stock',
        3000000,
        type: WalletType.asset,
        icon: 'store',
      );
      var settings = silver
          .withSwitch('w:$bank', on: false, byDefault: true)
          .withSwitch('w:$shop', on: true, byDefault: false);
      var r = await compute(settings);
      expect(r.wealth, 3000000);
      expect(r.meetsNisab, isFalse);

      // Back to its default, the switch is forgotten rather than stored.
      settings = settings.withSwitch('w:$bank', on: true, byDefault: true);
      expect(settings.switches.containsKey('w:$bank'), isFalse);
      r = await compute(settings);
      expect(r.wealth, 23000000);
    });

    test('amounts added by hand count, and can be debts', () async {
      await wallet('Cash', 2000000);
      final settings = silver.copyWith(
        manual: const [
          ZakatManualItem(id: 'a', label: 'Business stock', amount: 9000000),
          ZakatManualItem(id: 'b', label: 'Cash at home', amount: 1000000),
          ZakatManualItem(
            id: 'c',
            label: 'Supplier bill',
            amount: 2000000,
            deduct: true,
          ),
        ],
      );
      var r = await compute(settings);
      expect(r.of(ZakatGroup.manual).map((l) => l.name), [
        'Business stock',
        'Cash at home',
        'Supplier bill',
      ]);
      expect(r.wealth, 12000000);
      expect(r.deductions, 2000000);
      expect(r.due, 250000);

      r = await compute(settings.withSwitch('m:c', on: false, byDefault: true));
      expect(r.deductions, 0);
    });

    test('other currencies are converted into the user\'s own', () async {
      await wallet('Cash', 10000000);
      await wallet('Payoneer', 100000, currency: 'USD');
      await db.setCustomRate('USD', 'BDT', 120);
      final r = await ZakatService(
        db,
        CurrencyService(db),
      ).compute(silver, currency: 'BDT');
      final usd = r.of(ZakatGroup.cash).singleWhere((l) => l.currency == 'USD');
      expect(usd.original, 100000);
      expect(usd.amount, 12000000);
      expect(r.wealth, 22000000);
    });
  });

  group('paying', () {
    test('records an expense under Zakat and leaves less to pay', () async {
      final cash = await wallet('Cash', 20000000);
      final id = await zakat.pay(walletId: cash, amount: 200000);

      final row = (await db.findTransactionById(id))!;
      expect(row.isIncome, isFalse);
      expect(row.amount, 200000);
      expect(TransactionPolicy.countsAsExpense(row), isTrue);
      final category = (await db.findCategoryById(row.categoryId!))!;
      expect(category.defaultKey, BuiltInCategoryKeys.zakat);
      expect(category.name, 'Zakat');
      expect((await db.findWalletById(cash))!.balance, 19800000);

      final r = await compute(silver);
      expect(r.paid, 200000);
      expect(r.due, 500000, reason: 'paying does not shrink what was due');
      expect(r.left, 300000);
      expect(r.of(ZakatGroup.paid).single.amount, 200000);

      await zakat.pay(walletId: cash, amount: 300000);
      final settled = await compute(silver);
      expect(settled.left, 0);
      expect(settled.due, 500000);
    });

    test('a second payment files under the same category', () async {
      final cash = await wallet('Cash', 20000000);
      final a = await zakat.pay(walletId: cash, amount: 1000);
      final b = await zakat.pay(walletId: cash, amount: 1000);
      expect(
        (await db.findTransactionById(a))!.categoryId,
        (await db.findTransactionById(b))!.categoryId,
      );
    });

    test('only payments since the zakat date count toward it', () async {
      final cash = await wallet('Cash', 20000000);
      final settings = silver.copyWith(zakatDate: DateTime(2026, 3, 1));
      await zakat.pay(
        walletId: cash,
        amount: 100000,
        date: DateTime(2026, 2, 20),
      );
      await zakat.pay(
        walletId: cash,
        amount: 50000,
        date: DateTime(2026, 3, 1, 9),
      );
      final r = await compute(settings, now: DateTime(2026, 10, 24));
      expect(r.yearStart, DateTime(2026, 3, 1));
      expect(r.paid, 50000);
    });

    test('refuses nothing, and accounts that are not spent from', () async {
      final cash = await wallet('Cash', 20000000);
      final dps = await wallet('DPS', 100000, type: WalletType.deposit);
      expect(
        () => zakat.pay(walletId: cash, amount: 0),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => zakat.pay(walletId: dps, amount: 100),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => zakat.pay(walletId: const Uuid().v4(), amount: 100),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('the zakat year', () {
    test('comes round every 354 days from the date set', () {
      final (last, next) = ZakatCalendar.around(
        DateTime(2026, 3, 1),
        DateTime(2026, 10, 24),
      );
      expect(last, DateTime(2026, 3, 1));
      expect(next, DateTime(2027, 2, 18));
    });

    test('a date set in the future still knows the year before it', () {
      final (last, next) = ZakatCalendar.around(
        DateTime(2027, 5, 1),
        DateTime(2026, 10, 24),
      );
      expect(next, DateTime(2027, 5, 1));
      expect(last, DateTime(2026, 5, 12));
    });

    test('rolls over on the day itself, and across several years', () {
      final (last, next) = ZakatCalendar.around(
        DateTime(2026, 3, 1),
        DateTime(2027, 2, 18),
      );
      expect(last, DateTime(2027, 2, 18));
      expect(next, DateTime(2028, 2, 7));

      final (oldLast, oldNext) = ZakatCalendar.around(
        DateTime(2024, 1, 10),
        DateTime(2026, 10, 24),
      );
      expect(oldLast, DateTime(2025, 12, 18));
      expect(oldNext, DateTime(2026, 12, 7));
    });

    test('without a date, payments count over the last lunar year', () {
      expect(
        ZakatCalendar.yearStart(null, DateTime(2026, 10, 24)),
        DateTime(2025, 11, 4),
      );
      expect(ZakatCalendar.nextDate(null, DateTime(2026, 10, 24)), isNull);
    });

    test('the report says how long is left', () async {
      await wallet('Cash', 20000000);
      final r = await compute(
        silver.copyWith(zakatDate: DateTime(2026, 3, 1)),
        now: DateTime(2027, 2, 15),
      );
      expect(r.nextDate, DateTime(2027, 2, 18));
      expect(r.daysUntilDue(DateTime(2027, 2, 15)), 3);
    });
  });

  group('reminders', () {
    final settings = silver.copyWith(zakatDate: DateTime(2026, 3, 1));

    test('come a few days before and on the day, and not otherwise', () {
      expect(ZakatReminders.dueOn(settings, DateTime(2027, 2, 14)), isNull);
      final before = ZakatReminders.dueOn(settings, DateTime(2027, 2, 15))!;
      expect(before.daysLeft, 3);
      expect(before.isToday, isFalse);
      expect(before.title, 'Zakat due in 3 days');
      final day = ZakatReminders.dueOn(settings, DateTime(2027, 2, 18))!;
      expect(day.isToday, isTrue);
      expect(day.date, DateTime(2027, 2, 18));
      expect(ZakatReminder.payload, {'action': 'open_zakat'});
    });

    test('are off without a date, or when turned off', () {
      expect(ZakatReminders.dueOn(silver, DateTime(2027, 2, 18)), isNull);
      expect(
        ZakatReminders.dueOn(
          settings.copyWith(remind: false),
          DateTime(2027, 2, 18),
        ),
        isNull,
      );
    });

    test('each is shown once, whoever checks first', () async {
      final prefs = await SharedPreferences.getInstance();
      await ZakatSettingsStore.save(settings, prefs);
      final first = await ZakatReminders.take(
        prefs: prefs,
        now: DateTime(2027, 2, 16),
      );
      expect(first?.daysLeft, 2);
      expect(
        await ZakatReminders.take(prefs: prefs, now: DateTime(2027, 2, 17)),
        isNull,
        reason: 'the early one has been shown',
      );
      expect(
        (await ZakatReminders.take(
          prefs: prefs,
          now: DateTime(2027, 2, 18),
        ))?.isToday,
        isTrue,
      );
      expect(
        await ZakatReminders.take(prefs: prefs, now: DateTime(2027, 2, 18)),
        isNull,
      );
    });
  });

  test('settings survive being saved and read back', () async {
    final settings = ZakatSettings(
      basis: NisabBasis.gold,
      goldPricePerGram: 1200000,
      silverPricePerGram: 15000,
      switches: const {'w:x': false, 'w:y': true},
      manual: const [
        ZakatManualItem(id: 'a', label: 'Stock', amount: 500, deduct: true),
      ],
      zakatDate: DateTime(2026, 3, 1),
      remind: false,
    );
    await ZakatSettingsStore.save(settings);
    final back = await ZakatSettingsStore.load();
    expect(back.basis, NisabBasis.gold);
    expect(back.goldPricePerGram, 1200000);
    expect(back.silverPricePerGram, 15000);
    expect(back.switches, {'w:x': false, 'w:y': true});
    expect(back.manual.single.label, 'Stock');
    expect(back.manual.single.deduct, isTrue);
    expect(back.zakatDate, DateTime(2026, 3, 1));
    expect(back.remind, isFalse);

    final blank = await ZakatSettingsStore.load();
    expect(blank.pricePerGram, 1200000);
    SharedPreferences.setMockInitialValues({
      ZakatSettingsStore.prefKey: 'not json',
    });
    expect((await ZakatSettingsStore.load()).basis, NisabBasis.silver);
  });
}
