import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// EMIs, loans, DPS and FDR: money on a schedule for a fixed term.
///
/// The figures have to be the bank's, the balances have to stay right while
/// money sits in a deposit, and nothing may ever be paid twice: the collector
/// runs on every launch and in the background, possibly on two phones.
void main() {
  group('the arithmetic', () {
    test('a level installment repays the principal with interest', () {
      // 100,000 at 12% a year over 12 months is 8,884.88 a month.
      final emi = PlanMath.installmentFor(
        principal: 10000000,
        annualRate: 12,
        count: 12,
        frequency: PlanFrequency.monthly,
      );
      expect(emi, 888488);
    });

    test('without a rate the principal is split evenly', () {
      expect(
        PlanMath.installmentFor(
          principal: 6000000,
          annualRate: null,
          count: 12,
          frequency: PlanFrequency.monthly,
        ),
        500000,
      );
    });

    test('a loan splits into parts that add up to what was borrowed', () {
      final parts = PlanMath.amortize(
        principal: 10000000,
        annualRate: 12,
        installment: 888488,
        count: 12,
        frequency: PlanFrequency.monthly,
      );
      expect(parts.first.interest, 100000); // 1% of 100,000
      expect(parts.fold(0, (s, p) => s + p.principal), 10000000);
      expect(parts.last.interest, lessThan(parts.first.interest));
    });

    test('a DPS grows with its rate', () {
      // 1,000 a month for a year at 0% is 12,000; at 6% it is more.
      expect(
        PlanMath.dpsMaturity(
          installment: 100000,
          annualRate: 0,
          count: 12,
          frequency: PlanFrequency.monthly,
        ),
        1200000,
      );
      final grown = PlanMath.dpsMaturity(
        installment: 100000,
        annualRate: 6,
        count: 12,
        frequency: PlanFrequency.monthly,
      );
      expect(grown, inInclusiveRange(1239000, 1240000));
    });

    test('an FDR earns simple interest within a year', () {
      expect(
        PlanMath.fdrMaturity(principal: 10000000, annualRate: 9, months: 6),
        10450000,
      );
      expect(
        PlanMath.fdrMonthlyProfit(principal: 10000000, annualRate: 9),
        75000,
      );
    });

    test(
      'a monthly date past the end of a short month lands on its last day',
      () {
        final start = DateTime(2026, 1, 31);
        expect(
          PlanDates.shift(start, PlanFrequency.monthly, 1),
          DateTime(2026, 2, 28),
        );
        expect(
          PlanDates.shift(start, PlanFrequency.monthly, 2),
          DateTime(2026, 3, 31),
        );
        expect(
          PlanDates.shift(start, PlanFrequency.weekly, 2),
          DateTime(2026, 2, 14),
        );
      },
    );
  });

  group('plans against the database', () {
    late AppDatabase db;
    late PlanService plans;
    late String cash;
    late String bank;

    setUp(() async {
      db = openTestDatabase();
      await db.ensureSystemCategoriesExist();
      plans = PlanService(db);
      cash = await seedWallet(db, name: 'Cash', openingBalance: 10000000);
      bank = await seedWallet(db, name: 'Bank', openingBalance: 50000000);
    });

    tearDown(() => db.close());

    Future<int> balanceOf(String id) async =>
        (await db.findWalletById(id))!.balance;

    test('an EMI on cash collects what is due, once', () async {
      final start = DateTime.now().subtract(const Duration(days: 65));
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.emi,
          name: 'Phone',
          walletId: cash,
          startDate: start,
          principal: 6000000,
          installmentAmount: 550000,
          installmentCount: 12,
        ),
      );

      // About 65 days in: three installments are due (day 0, ~30, ~60).
      final first = await plans.collectDue();
      expect(first, 3);
      expect(await plans.collectDue(), 0, reason: 'never twice');

      final progress = await plans.progressOf((await plans.findPlan(id))!);
      expect(progress.installmentsDone, 3);
      expect(progress.paidSoFar, 1650000);
      expect(progress.totalPayable, 6600000);
      expect(progress.remaining, 6600000 - 1650000);
      expect(await balanceOf(cash), 10000000 - 1650000);

      final rows = await plans.transactionsOf(id);
      expect(rows, hasLength(3));
      expect(rows.every(TransactionPolicy.countsAsExpense), isTrue);
    });

    test('a deleted installment is not written again', () async {
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.emi,
          name: 'TV',
          walletId: cash,
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          installmentAmount: 100000,
          installmentCount: 3,
        ),
      );
      await plans.collectDue();
      final row = (await plans.transactionsOf(id)).single;
      await db.softDeleteTransaction(row.id);

      expect(await plans.collectDue(), 0);
      expect(await plans.transactionsOf(id), isEmpty);
    });

    test('paying early and paying off end an EMI', () async {
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.emi,
          name: 'Laptop',
          walletId: cash,
          startDate: DateTime.now().add(const Duration(days: 10)),
          installmentAmount: 200000,
          installmentCount: 5,
          autoCollect: false,
        ),
      );
      final paid = await plans.payNext(id);
      expect(paid!.number, 1);
      await plans.closeEarly(id);

      final plan = (await plans.findPlan(id))!;
      expect(plan.status, PlanStatus.closed);
      expect(await balanceOf(cash), 10000000 - 1000000);
    });

    test('a DPS moves money aside, and matures with its profit', () async {
      final start = DateTime.now().subtract(const Duration(days: 400));
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.dps,
          name: 'DPS',
          walletId: bank,
          startDate: start,
          installmentAmount: 500000,
          installmentCount: 12,
          maturityAmount: 6200000,
        ),
      );
      final plan = (await plans.findPlan(id))!;
      final holding = (await db.findWalletById(plan.holdingWalletId!))!;
      expect(holding.walletType, WalletType.deposit);
      expect(holding.currency, 'USD');

      await plans.collectDue();

      // Twelve deposits, then the maturity: 6,000,000 back plus 200,000 profit.
      expect(await balanceOf(plan.holdingWalletId!), 0);
      expect(await balanceOf(bank), 50000000 + 200000);
      expect((await plans.findPlan(id))!.status, PlanStatus.completed);

      // The deposits were transfers: not spending.
      final rows = await plans.transactionsOf(id);
      final spent = rows.where(TransactionPolicy.countsAsExpense);
      expect(spent, isEmpty);
      final profit = rows.where(TransactionPolicy.countsAsIncome).single;
      expect(profit.amount, 200000);
    });

    test('a DPS in progress holds what has been deposited', () async {
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.dps,
          name: 'Kids DPS',
          walletId: bank,
          startDate: DateTime.now().subtract(const Duration(days: 40)),
          installmentAmount: 300000,
          installmentCount: 60,
        ),
      );
      await plans.collectDue();
      final plan = (await plans.findPlan(id))!;
      expect(await balanceOf(plan.holdingWalletId!), 600000);
      expect(await balanceOf(bank), 50000000 - 600000);

      // Encashed early: the money comes back, the plan ends.
      await plans.closeEarly(id);
      expect(await balanceOf(plan.holdingWalletId!), 0);
      expect(await balanceOf(bank), 50000000);
      expect((await plans.findPlan(id))!.status, PlanStatus.closed);
    });

    test(
      'an FDR paying monthly profit returns its principal at the end',
      () async {
        final id = await plans.create(
          PlanDraft(
            kind: PlanKind.fdr,
            name: 'FDR',
            walletId: bank,
            startDate: DateTime.now().subtract(const Duration(days: 100)),
            principal: 10000000,
            installmentCount: 3,
            interestRate: 9,
            payout: PlanPayout.monthly,
          ),
        );
        final plan = (await plans.findPlan(id))!;
        // The sum moved into the deposit when it was opened.
        expect(await balanceOf(plan.holdingWalletId!), 10000000);
        expect(await balanceOf(bank), 40000000);

        await plans.collectDue();

        // Three profits of 750 each, and the 100,000 back.
        expect(await balanceOf(plan.holdingWalletId!), 0);
        expect(await balanceOf(bank), 50000000 + 3 * 75000);
        expect((await plans.findPlan(id))!.status, PlanStatus.completed);
      },
    );

    test(
      'a loan is borrowed, counted down, and its interest is spending',
      () async {
        final installment = PlanMath.installmentFor(
          principal: 1200000,
          annualRate: 12,
          count: 12,
          frequency: PlanFrequency.monthly,
        );
        final id = await plans.create(
          PlanDraft(
            kind: PlanKind.loan,
            name: 'Bike loan',
            walletId: cash,
            startDate: DateTime.now().subtract(const Duration(days: 1)),
            principal: 1200000,
            installmentAmount: installment,
            installmentCount: 12,
            interestRate: 12,
          ),
        );
        expect(await balanceOf(cash), 10000000 + 1200000);

        await plans.collectDue();

        final rows = await plans.transactionsOf(id);
        final debt = rows.singleWhere((t) => t.planInstallment == 0);
        expect(TransactionPolicy.isCreditOrDebt(debt), isTrue);
        // First installment: 12,000 owed at 1% a month is 120 interest.
        expect(debt.paidAmount, installment - 12000);
        final interest = rows.singleWhere(
          (t) => t.occurrenceKey?.endsWith(':interest') ?? false,
        );
        expect(interest.amount, 12000);
        expect(TransactionPolicy.countsAsExpense(interest), isTrue);

        await plans.closeEarly(id);
        final settled = (await db.findTransactionById(debt.id))!;
        expect(TransactionPolicy.isSettled(settled), isTrue);
      },
    );

    test('a deposit holding money cannot be deleted', () async {
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.fdr,
          name: 'FDR',
          walletId: bank,
          startDate: DateTime.now(),
          principal: 1000000,
          installmentCount: 12,
        ),
      );
      await expectLater(plans.delete(id), throwsArgumentError);
      await plans.closeEarly(id);
      await plans.delete(id);
      expect((await plans.findPlan(id))!.deletedAt, isNotNull);
    });

    test('a plan and what it recorded reach the server', () async {
      final server = FakeSyncServer();
      await db.claimLocalStore(userId: 'u');
      final sync = SyncService(
        database: db,
        transport: FakeSyncTransport(server: server, userId: 'u'),
      );
      final id = await plans.create(
        PlanDraft(
          kind: PlanKind.dps,
          name: 'DPS',
          walletId: bank,
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          installmentAmount: 300000,
          installmentCount: 24,
        ),
      );
      await plans.collectDue();

      final result = await sync.syncAll();
      expect(result.success, isTrue, reason: result.userMessage);

      final onServer = server
          .recordsIn('u', 'plans')
          .singleWhere((r) => r['Id'] == id || r['id'] == id);
      expect(onServer['Kind'], PlanKind.dps.index);
      expect(onServer['InstallmentAmount'], 300000);
      final legs = server
          .recordsIn('u', 'transactions')
          .where((r) => r['PlanId'] == id)
          .toList();
      expect(legs, hasLength(2), reason: 'both legs of the first deposit');
      expect(legs.every((r) => r['PlanInstallment'] == 1), isTrue);
      // The deposit account went too.
      final plan = (await plans.findPlan(id))!;
      expect(
        server.recordsIn('u', 'wallets').any(
          (w) => (w['Id'] ?? w['id']) == plan.holdingWalletId,
        ),
        isTrue,
      );
    });
    test('nonsense is refused', () async {
      await expectLater(
        plans.create(
          PlanDraft(
            kind: PlanKind.emi,
            name: 'X',
            walletId: cash,
            startDate: DateTime.now(),
            installmentAmount: 0,
          ),
        ),
        throwsArgumentError,
      );
      await expectLater(
        plans.create(
          PlanDraft(
            kind: PlanKind.fdr,
            name: 'X',
            walletId: bank,
            startDate: DateTime.now(),
            principal: 100,
            frequency: PlanFrequency.weekly,
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
