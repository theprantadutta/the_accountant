import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/coach_tool_runner.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';

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

  group('credit card bills', () {
    late String card;

    setUp(() async {
      card = await seedWallet(db, name: 'SCB Credit', openingBalance: 0);
      await (db.update(db.wallets)..where((w) => w.id.equals(card))).write(
        const WalletsCompanion(
          walletType: Value(WalletType.creditCard),
          billingCycleDay: Value(13),
          paymentDueDay: Value(28),
        ),
      );
      // Long enough ago to be on the last statement, whatever today is.
      await seedTransaction(
        db,
        walletId: card,
        categoryId: food,
        amount: 1500000,
        title: 'Laptop',
        date: DateTime.now().subtract(const Duration(days: 40)),
      );
      await container.read(walletProvider.notifier).loadWallets();
    });

    test('says what the bill is and what is left', () async {
      final result = await read('card_bills', {});
      final bill = (result['cards'] as List).single as Map;
      expect(bill['name'], 'SCB Credit');
      expect(bill['statement_day'], 13);
      expect(bill['due_day'], 28);
      expect(bill['statement_amount'], 15000.0);
      expect(bill['left_to_pay'], 15000.0);
    });

    test('a part payment counts, and the rest stays due', () async {
      final plan = await runner.plan(
        CoachToolCall('c2', 'pay_card_bill', {
          'amount': 5000,
          'from_account': 'Bkash',
        }),
      );
      expect(plan.error, isNull);
      expect(plan.preview!.kind, CoachActionKind.payCard);
      expect(plan.preview!.amount, 500000);
      expect(
        plan.preview!.lines,
        containsAll([('from', 'Bkash'), ('to', 'SCB Credit')]),
      );

      // Nothing has happened until it is confirmed.
      var bill =
          ((await read('card_bills', {}))['cards'] as List).single as Map;
      expect(bill['left_to_pay'], 15000.0);

      final done = jsonDecode(await plan.execute!()) as Map;
      expect(done['status'], 'done');
      expect(done['left_to_pay'], 10000.0);

      bill = ((await read('card_bills', {}))['cards'] as List).single as Map;
      expect(bill['paid_since_statement'], 5000.0);
      expect(bill['left_to_pay'], 10000.0);

      // Without an amount it pays what is left.
      final rest = await runner.plan(
        CoachToolCall('c3', 'pay_card_bill', {'from_account': 'Bkash'}),
      );
      expect(rest.preview!.amount, 1000000);
      await rest.execute!();
      bill = ((await read('card_bills', {}))['cards'] as List).single as Map;
      expect(bill['left_to_pay'], 0.0);
      expect(bill['status'], 'paid');
    });

    test('sets the dates, and refuses days that do not exist', () async {
      final plan = await runner.plan(
        CoachToolCall('c4', 'set_card_schedule', {
          'due_day': 5,
          'remind_days_before': 5,
        }),
      );
      expect(plan.preview!.kind, CoachActionKind.cardSettings);
      expect(plan.preview!.changes.keys, containsAll(['due_day', 'remind']));
      await plan.execute!();
      final row = (await db.findWalletById(card))!;
      expect(row.paymentDueDay, 5);
      expect(row.dueReminderDays, 5);
      expect(row.billingCycleDay, 13);

      final bad = await runner.plan(
        CoachToolCall('c5', 'set_card_schedule', {'statement_day': 40}),
      );
      expect(bad.error, contains('1 to 31'));
    });
  });

  group('EMI, loans, DPS and FDR', () {
    Future<CoachPlan> plan(String name, Map<String, dynamic> args) =>
        runner.plan(CoachToolCall('p1', name, args));

    test(
      'starts an EMI worked out from the price, then pays and closes it',
      () async {
        final created = await plan('create_plan', {
          'kind': 'emi',
          'name': 'Phone',
          'account': 'Bkash',
          'amount': 60000,
          'installments': 12,
          'start_date': '2099-01-10',
        });
        expect(created.error, isNull);
        expect(created.preview!.kind, CoachActionKind.createPlan);
        expect(created.preview!.amount, 500000); // 60,000 / 12, no rate
        final done = jsonDecode(await created.execute!()) as Map;
        expect(done['status'], 'done');

        final listed = (await read('list_plans', {}))['plans'] as List;
        final phone = listed.single as Map;
        expect(phone['kind'], 'emi');
        expect(phone['installments'], 12);
        expect(phone['installments_done'], 0);
        expect(phone['remaining'], 60000.0);

        // Not until it is confirmed.
        final pay = await plan('pay_plan', {'plan': 'Phone'});
        expect(pay.preview!.amount, 500000);
        expect(
          ((await read('list_plans', {}))['plans'] as List)
              .single['installments_done'],
          0,
        );
        await pay.execute!();
        final after =
            ((await read('list_plans', {}))['plans'] as List).single as Map;
        expect(after['installments_done'], 1);
        expect(after['remaining'], 55000.0);

        final close = await plan('close_plan', {'plan': 'Phone'});
        expect(close.preview!.amount, 5500000);
        await close.execute!();
        final closed =
            ((await read('list_plans', {}))['plans'] as List).single as Map;
        expect(closed['status'], 'closed');
      },
    );

    test(
      'a DPS gets its maturity from the rate, and a second of the same name is refused',
      () async {
        final dps = await plan('create_plan', {
          'kind': 'dps',
          'name': 'Brac DPS',
          'account': 'Brac Bank',
          'installment_amount': 1000,
          'installments': 12,
          'rate': 6,
          'start_date': '2099-01-10',
        });
        expect(dps.error, isNull);
        await dps.execute!();
        final row =
            ((await read('list_plans', {'kind': 'dps'}))['plans'] as List)
                    .single
                as Map;
        expect(row['maturity_amount'], greaterThan(12000));

        final again = await plan('create_plan', {
          'kind': 'dps',
          'name': 'brac dps',
          'installment_amount': 1000,
          'installments': 12,
        });
        expect(again.error, contains('already running'));
      },
    );

    test('an FDR needs its amount', () async {
      final bad = await plan('create_plan', {
        'kind': 'fdr',
        'name': 'FDR',
        'installments': 12,
      });
      expect(bad.error, contains('amount'));
    });

    test(
      'starts a quarterly insurance policy with its insurer and payout',
      () async {
        final created = await plan('create_plan', {
          'kind': 'insurance',
          'name': 'Life policy',
          'account': 'Brac Bank',
          'installment_amount': 2500,
          'installments': 40,
          'frequency': 'quarterly',
          'amount': 1000000,
          'maturity_amount': 120000,
          'provider': 'MetLife',
          'reference': 'POL-1',
          'start_date': '2099-01-15',
        });
        expect(created.error, isNull);
        final lines = Map.fromEntries(
          created.preview!.lines.map((l) => MapEntry(l.$1, l.$2)),
        );
        expect(lines['premiums'], contains('quarterly'));
        expect(
          lines.keys,
          containsAll(['sum_assured', 'payout_at_end', 'provider']),
        );
        await created.execute!();

        final row =
            ((await read('list_plans', {'kind': 'insurance'}))['plans'] as List)
                    .single
                as Map;
        expect(row['provider'], 'MetLife');
        expect(row['reference'], 'POL-1');
        expect(row['frequency'], 'monthly');
        expect(row['interval'], 3);
        expect(row['payout_at_end'], 120000.0);
        expect(row['next']['date'], '2099-01-15');

        // Surrendered for what the insurer pays back.
        final close = await plan('close_plan', {
          'plan': 'Life policy',
          'amount': 5000,
        });
        expect(close.preview!.isIncome, isTrue);
        expect(close.preview!.amount, 500000);
        await close.execute!();
        expect(
          ((await read('list_plans', {}))['plans'] as List).single['status'],
          'closed',
        );
      },
    );

    test(
      'a sanchayapatra is a bond paying quarterly profit after tax',
      () async {
        final created = await plan('create_plan', {
          'kind': 'sanchayapatra',
          'name': '5-year Sanchayapatra',
          'account': 'Brac Bank',
          'amount': 500000,
          'installments': 5,
          'frequency': 'yearly',
          'rate': 11.28,
          'payout': 'quarterly',
          'tax_rate': 10,
          'start_date': '2099-01-10',
        });
        expect(created.error, isNull);
        expect(created.preview!.amount, 50000000);
        final done = jsonDecode(await created.execute!()) as Map;
        expect(done['deposited_now'], 500000.0);

        final row =
            ((await read('list_plans', {'kind': 'bond'}))['plans'] as List)
                    .single
                as Map;
        expect(row['kind'], 'bond');
        expect(row['payout'], 'quarterly');
        expect(row['tax_rate'], 10.0);
        // 5,00,000 × 11.28% / 4, less 10%.
        expect(row['next']['type'], 'profit');
        expect(row['next']['amount'], 12690.0);
        expect(row['maturity_amount'], 500000.0);
      },
    );
  });
  group('funds, shares and SIPs', () {
    Future<CoachPlan> plan(String name, Map<String, dynamic> args) =>
        runner.plan(CoachToolCall('i1', name, args));
    Future<Map> holding() async =>
        ((await read('list_investments', {}))['investments'] as List).single
            as Map;

    test(
      'adds a fund with its first buy, revalues it, sells and pays out',
      () async {
        final created = await plan('create_investment', {
          'name': 'Growth Fund',
          'kind': 'fund',
          'symbol': 'gf1',
          'account': 'Bkash',
          'amount': 2000,
          'units': 1000,
        });
        expect(created.error, isNull);
        expect(created.preview!.kind, CoachActionKind.createInvestment);
        expect(created.preview!.amount, 200000);
        expect(await read('list_investments', {}), {
          'investments': [],
        }, reason: 'nothing until confirmed');
        final done = jsonDecode(await created.execute!()) as Map;
        expect(done['status'], 'done');

        var h = await holding();
        expect(h['units'], 1000.0);
        expect(h['price'], 2.0);
        expect(h['value'], 2000.0);
        expect(h['symbol'], 'GF1');

        final again = await plan('create_investment', {'name': 'growth fund'});
        expect(again.error, contains('already tracked'));

        final price = await plan('update_investment_price', {
          'investment': 'GF1',
          'price': 2.5,
        });
        expect(price.preview!.changes.keys, containsAll(['price', 'value']));
        await price.execute!();
        h = await holding();
        expect(h['value'], 2500.0);
        expect(h['gain'], 500.0);
        expect(h['gain_percent'], 25.0);

        final tooMany = await plan('trade_investment', {
          'investment': 'Growth Fund',
          'action': 'sell',
          'amount': 100,
          'units': 5000,
        });
        expect(tooMany.error, contains('Only'));

        final sell = await plan('trade_investment', {
          'investment': 'Growth Fund',
          'action': 'sell',
          'amount': 1200,
          'units': 400,
          'account': 'Bkash',
        });
        expect(sell.preview!.isIncome, isTrue);
        await sell.execute!();
        h = await holding();
        expect(h['units'], 600.0);
        expect(h['value'], 1800.0, reason: '600 at 3.00, the sale price');
        expect(h['taken_out'], 1200.0);

        final dividend = await plan('trade_investment', {
          'investment': 'Growth Fund',
          'action': 'dividend',
          'amount': 50,
        });
        final paid = jsonDecode(await dividend.execute!()) as Map;
        expect(paid['status'], 'done');
      },
    );

    test('a SIP buys into a fund the coach names', () async {
      final created = await plan('create_investment', {
        'name': 'Index Fund',
        'kind': 'fund',
      });
      await created.execute!();
      await (await plan('update_investment_price', {
        'investment': 'Index Fund',
        'price': 10,
      })).execute!();

      final sip = await plan('create_plan', {
        'kind': 'sip',
        'name': 'Index SIP',
        'account': 'Bkash',
        'investment': 'Index Fund',
        'installment_amount': 500,
        'installments': 12,
      });
      expect(sip.error, isNull);
      final lines = Map.fromEntries(
        sip.preview!.lines.map((l) => MapEntry(l.$1, l.$2)),
      );
      expect(lines['buys'], 'Index Fund');
      await sip.execute!();

      // The first one is due today, so it has already bought.
      final h = await holding();
      expect(h['units'], 50.0);
      expect(h['put_in'], 500.0);

      final missing = await plan('create_plan', {
        'kind': 'sip',
        'name': 'Other SIP',
        'investment': 'Nothing',
        'installment_amount': 500,
        'installments': 12,
      });
      expect(missing.error, contains('No investment'));
    });
  });
  group('zakat', () {
    Future<CoachPlan> plan(String name, Map<String, dynamic> args) =>
        runner.plan(CoachToolCall('z1', name, args));

    // 0.05 a gram of silver: a nisab of 30.62 on 6,000.00 in the accounts.
    Future<void> priced() => ZakatSettingsStore.save(
      ZakatSettings(silverPricePerGram: 5, zakatDate: DateTime(2026, 3, 1)),
    );

    test('reads every line, the nisab and what is due', () async {
      await priced();
      final z = await read('zakat', {});
      expect(z['basis'], 'silver');
      expect(z['nisab'], 30.62);
      expect(z['wealth'], 6000.0);
      expect(z['meets_nisab'], isTrue);
      expect(z['zakat_due'], 150.0);
      expect(z['left_to_pay'], 150.0);
      expect(z['year_started'], '2026-03-01');
      expect(z['next_zakat_date'], isNotNull);
      final names = [for (final l in z['lines'] as List) (l as Map)['name']];
      expect(names, containsAll(['Bkash', 'Brac Bank']));
      expect(z['assumptions'], isNotEmpty);
    });

    test('says when the nisab cannot be checked yet', () async {
      final z = await read('zakat', {});
      expect(z['nisab'], isNull);
      expect(z['meets_nisab'], isNull);
      expect(z['zakat_due'], 0.0);
      expect(
        (z['assumptions'] as List).join(' '),
        allOf(contains('No price per gram'), contains('No zakat date')),
      );
    });

    test('pays what is left only once confirmed', () async {
      await priced();
      // The seeded rows were written straight in, without moving the stored
      // balances that a payment recalculates; settle them first.
      await WalletBalanceService(db).recalculateAllWalletBalancesLocal();
      final before = await read('zakat', {});
      final due = before['zakat_due'] as double;
      final balance = (await db.findWalletById(bkash))!.balance / 100;
      final pay = await plan('pay_zakat', {'amount': 50});
      expect(pay.error, isNull);
      expect(pay.preview!.kind, CoachActionKind.payZakat);
      expect(pay.preview!.amount, 5000);
      expect(pay.preview!.account, isNull);
      final lines = Map.fromEntries(
        pay.preview!.lines.map((l) => MapEntry(l.$1, l.$2)),
      );
      expect(lines['account'], 'Bkash');
      expect(lines['left_after'], isNotNull);
      expect(
        (await read('zakat', {}))['paid_this_year'],
        0.0,
        reason: 'nothing until confirmed',
      );

      final done = jsonDecode(await pay.execute!()) as Map;
      expect(done['status'], 'done');
      expect(done['paid_this_year'], 50.0);
      expect(done['left_to_pay'], closeTo(due - 50, 0.001));
      expect(done['account_balance_now'], closeTo(balance - 50, 0.001));
      expect(
        (await read('zakat', {}))['zakat_due'],
        due,
        reason: 'paying does not shrink what was due',
      );

      final rest = await plan('pay_zakat', {'account': 'Brac Bank'});
      expect(
        rest.preview!.amount,
        ((due - 50) * 100).round(),
        reason: 'defaults to what is left',
      );
      await rest.execute!();
      expect((await read('zakat', {}))['left_to_pay'], 0.0);

      final again = await plan('pay_zakat', {});
      expect(again.error, contains('already paid'));
    });

    test('nothing due without an amount is refused', () async {
      final none = await plan('pay_zakat', {});
      expect(none.error, contains('No zakat is due'));
    });
  });
}
