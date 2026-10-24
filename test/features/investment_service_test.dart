import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Funds, shares and SIPs: units bought and sold, valued at the latest price.
///
/// The holding's account has to read units × price after every trade and
/// every new price, the gain has to be what it is worth and what came back
/// against what went in, and a SIP must never buy the same month twice.
void main() {
  late AppDatabase db;
  late InvestmentService investments;
  late String bank;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    investments = InvestmentService(db);
    bank = await seedWallet(db, name: 'Bank', openingBalance: 100000000);
  });

  tearDown(() => db.close());

  Future<int> balanceOf(String id) async =>
      (await db.findWalletById(id))!.balance;

  Future<Investment> fund({int price = 0}) async {
    final id = await investments.create(
      InvestmentDraft(
        name: 'Growth Fund',
        kind: InvestmentKind.fund,
        currency: 'USD',
        symbol: ' gf1 ',
        price: price,
      ),
    );
    return (await investments.find(id))!;
  }

  test('a holding gets an investment account of its own', () async {
    final f = await fund();
    final wallet = (await db.findWalletById(f.walletId))!;
    expect(wallet.walletType, WalletType.investment);
    expect(wallet.walletType.isManaged, isTrue);
    expect(f.symbol, 'GF1');
    await expectLater(
      investments.create(
        const InvestmentDraft(
          name: 'growth fund',
          kind: InvestmentKind.fund,
          currency: 'USD',
        ),
      ),
      throwsArgumentError,
      reason: 'the same name twice',
    );
  });

  test('buying moves money in at the price paid, with the fee spent', () async {
    final f = await fund();
    // 1,000 units for 10,000.00, plus a 50.00 commission.
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
      fee: 5000,
    );

    final h = (await investments.holdingOf((await investments.find(f.id))!))!;
    expect(h.units, 1000);
    expect(h.value, 1000000);
    expect(h.putIn, 1000000);
    expect(h.gain, 0);
    expect(h.investment.price, 1000, reason: '10.00 a unit');
    expect(await balanceOf(bank), 100000000 - 1000000 - 5000);

    // The purchase is a transfer, not spending; only the fee is spent.
    final spent = (await db.getAllTransactions()).where(
      TransactionPolicy.countsAsExpense,
    );
    expect(spent.single.amount, 5000);
  });

  test('a new price revalues the holding and shows the gain', () async {
    final f = await fund();
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
    );
    await investments.updatePrice(f.id, 1250);

    final h = (await investments.holdingOf((await investments.find(f.id))!))!;
    expect(h.value, 1250000);
    expect(h.gain, 250000);
    expect(h.gainPercent, closeTo(25, 1e-9));

    // The rise is a correction on the holding, never income.
    final trades = await investments.tradesOf(h.investment);
    final rise = trades.singleWhere((t) => t.isRevaluation);
    expect(rise.isIn, isTrue);
    expect(rise.row.amount, 250000);
    final earned = (await db.getAllTransactions()).where(
      TransactionPolicy.countsAsIncome,
    );
    expect(earned, isEmpty);
  });

  test('a second buy at a new price values everything at it', () async {
    final f = await fund();
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
    );
    // 500 more at 12.00.
    await investments.buy(f.id, fromWalletId: bank, amount: 600000, units: 500);

    final h = (await investments.holdingOf((await investments.find(f.id))!))!;
    expect(h.units, 1500);
    expect(h.value, 1800000);
    expect(h.putIn, 1600000);
    expect(h.gain, 200000);
  });

  test('selling takes out what the sale brought, and keeps the rest', () async {
    final f = await fund();
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
    );
    // 400 units sold at 15.00.
    await investments.sell(f.id, toWalletId: bank, amount: 600000, units: 400);

    final h = (await investments.holdingOf((await investments.find(f.id))!))!;
    expect(h.units, 600);
    expect(h.value, 900000, reason: '600 units at 15.00');
    expect(h.takenOut, 600000);
    expect(h.gain, 500000, reason: '900,000 + 600,000 - 1,000,000');
    expect(await balanceOf(bank), 100000000 - 1000000 + 600000);

    await expectLater(
      investments.sell(f.id, toWalletId: bank, amount: 100, units: 601),
      throwsArgumentError,
      reason: 'more than is held',
    );
  });

  test('selling everything empties it, and only then can it go', () async {
    final f = await fund();
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
    );
    await expectLater(investments.delete(f.id), throwsArgumentError);

    await investments.sell(f.id, toWalletId: bank, amount: 950000, units: 1000);
    final h = (await investments.holdingOf((await investments.find(f.id))!))!;
    expect(h.units, 0);
    expect(h.value, 0);
    expect(h.gain, -50000);

    await investments.delete(f.id);
    expect((await investments.find(f.id))!.deletedAt, isNotNull);
    expect((await db.findWalletById(f.walletId))!.isArchived, isTrue);
  });

  test('a dividend is income in the account it was paid into', () async {
    final f = await fund();
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
    );
    await investments.dividend(f.id, toWalletId: bank, amount: 25000);

    final income = (await db.getAllTransactions())
        .where(TransactionPolicy.countsAsIncome)
        .single;
    expect(income.amount, 25000);
    expect(income.title, 'Growth Fund: dividend');
    expect(income.walletId, bank);
    await expectLater(
      investments.dividend(f.id, toWalletId: f.walletId, amount: 1),
      throwsArgumentError,
    );
  });

  test('units from a statement can correct a buy', () async {
    final f = await fund(price: 1000);
    await investments.buy(f.id, fromWalletId: bank, amount: 1000000);
    // Bought without knowing the units: valued at nothing until told.
    var trade = (await investments.tradesOf(
      f,
    )).firstWhere((t) => !t.isRevaluation);
    await investments.correctUnits(trade.row.id, 980.5);

    final h = (await investments.holdingOf((await investments.find(f.id))!))!;
    expect(h.units, 980.5);
    expect(h.value, 980500);
  });

  group('a SIP', () {
    late PlanService plans;
    setUp(() => plans = PlanService(db));

    test('buys at the latest price each month, once', () async {
      final f = await fund(price: 1000);
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.sip,
          name: 'Fund SIP',
          walletId: bank,
          investmentId: f.id,
          startDate: DateTime.now().subtract(const Duration(days: 65)),
          installmentAmount: 500000,
          installmentCount: 12,
        ),
      );
      final plan = (await plans.findPlan(id))!;
      expect(plan.holdingWalletId, f.walletId);

      expect(await plans.collectDue(), 3);
      expect(await plans.collectDue(), 0, reason: 'never twice');

      final h = (await investments.holdingOf((await investments.find(f.id))!))!;
      expect(h.units, 1500);
      expect(h.putIn, 1500000);
      expect(h.value, 1500000);
      expect(await balanceOf(bank), 100000000 - 1500000);

      final rows = await plans.transactionsOf(id);
      expect(rows, hasLength(6), reason: 'both legs of three buys');
      expect(rows.where(TransactionPolicy.countsAsExpense), isEmpty);

      // Stopping it, or deleting it, leaves what it bought.
      await plans.closeEarly(id);
      await plans.delete(id);
      final after = (await db.findWalletById(f.walletId))!;
      expect(after.isArchived, isFalse);
      expect(after.balance, 1500000);
    });

    test('needs a holding to buy into', () async {
      await expectLater(
        plans.create(
          PlanDraft(
            kind: PlanKind.sip,
            name: 'X',
            walletId: bank,
            startDate: DateTime.now(),
            installmentAmount: 1000,
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  test('a holding, its trades and its units reach the server', () async {
    final server = FakeSyncServer();
    await db.claimLocalStore(userId: 'u');
    final sync = SyncService(
      database: db,
      transport: FakeSyncTransport(server: server, userId: 'u'),
    );
    final f = await fund();
    await investments.buy(
      f.id,
      fromWalletId: bank,
      amount: 1000000,
      units: 1000,
    );

    final result = await sync.syncAll();
    expect(result.success, isTrue, reason: result.userMessage);

    final onServer = server
        .recordsIn('u', 'investments')
        .singleWhere((r) => (r['Id'] ?? r['id']) == f.id);
    expect(onServer['Name'], 'Growth Fund');
    expect(onServer['Kind'], InvestmentKind.fund.index);
    expect(onServer['WalletId'], f.walletId);
    expect(onServer['Price'], 1000);
    expect(onServer['Symbol'], 'GF1');
    final legIn = server
        .recordsIn('u', 'transactions')
        .singleWhere((r) => r['WalletId'] == f.walletId && r['Units'] != null);
    expect(legIn['Units'], 1000);
  });
}
