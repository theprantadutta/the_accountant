import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';

/// What someone fills in to start a plan.
class PlanDraft {
  const PlanDraft({
    required this.kind,
    required this.name,
    required this.walletId,
    required this.startDate,
    this.principal = 0,
    this.installmentAmount = 0,
    this.installmentCount = 1,
    this.frequency = PlanFrequency.monthly,
    this.interval = 1,
    this.interestRate,
    this.maturityAmount,
    this.payout = PlanPayout.atMaturity,
    this.autoCollect = true,
    this.reminderDaysBefore = 3,
    this.categoryId,
    this.notes,
    this.loanReceived = true,
    this.provider,
    this.reference,
    this.taxRate,
    this.investmentId,
  });

  final PlanKind kind;
  final String name;
  final String walletId;
  final DateTime startDate;
  final int principal;
  final int installmentAmount;
  final int installmentCount;
  final PlanFrequency frequency;
  final int interval;
  final double? interestRate;
  final int? maturityAmount;
  final PlanPayout payout;
  final bool autoCollect;
  final int reminderDaysBefore;
  final String? categoryId;
  final String? notes;

  /// For a loan: whether the money arrived in [walletId] and should be
  /// recorded as received. Off for a loan that was paid straight to a seller.
  final bool loanReceived;

  /// The bank, insurer or issuer, and the policy or certificate number.
  final String? provider;
  final String? reference;

  /// Percent of profit taken as tax at source.
  final double? taxRate;

  /// For a SIP: the fund or share each installment buys.
  final String? investmentId;
}

/// Where a plan stands: what has been recorded and what comes next.
class PlanProgress {
  const PlanProgress({
    required this.plan,
    required this.events,
    required this.recorded,
  });

  final Plan plan;
  final List<PlanEvent> events;

  /// Event numbers already recorded (or deliberately removed by the user).
  final Set<int> recorded;

  List<PlanEvent> get installments =>
      events.where((e) => e.type == PlanEventType.installment).toList();

  int get installmentsDone =>
      installments.where((e) => recorded.contains(e.number)).length;

  /// Minor units paid or deposited so far by installments.
  int get paidSoFar => installments
      .where((e) => recorded.contains(e.number))
      .fold(0, (s, e) => s + e.amount);

  /// Minor units still to pay or deposit by installments.
  int get remaining => installments
      .where((e) => !recorded.contains(e.number))
      .fold(0, (s, e) => s + e.amount);

  /// What the installments add up to in all.
  int get totalPayable => installments.fold(0, (s, e) => s + e.amount);

  /// The next event not yet recorded, or null when the plan is done.
  PlanEvent? get next =>
      events.where((e) => !recorded.contains(e.number)).firstOrNull;

  /// Events that are due and not recorded.
  ///
  /// By the day, not the hour: a plan's dates carry a time of day (10 AM,
  /// so they never slip across midnight between time zones), and comparing
  /// that exactly left a plan started this morning showing today's
  /// installment as not yet due until ten o'clock.
  List<PlanEvent> overdue(DateTime now) {
    final endOfToday = DateTime(now.year, now.month, now.day + 1);
    return events
        .where(
          (e) => !recorded.contains(e.number) && e.date.isBefore(endOfToday),
        )
        .toList();
  }

  bool get isFinished => events.every((e) => recorded.contains(e.number));
}

/// EMIs, loans, DPS and FDR, against the database.
///
/// No Riverpod in here, so the background worker can collect what is due with
/// the app closed, the same way the recurring schedules are processed.
///
/// Everything a plan records carries an occurrence key, `plan:{id}:{n}`, which
/// is unique on this phone and on the server. Collecting twice, or on two
/// phones at once, can therefore never pay an installment twice, and an
/// installment the user deleted stays deleted rather than being written again.
class PlanService {
  PlanService(this._db)
    : _balances = WalletBalanceService(_db),
      _transfers = TransferService(_db),
      _investments = InvestmentService(_db);

  final AppDatabase _db;
  final WalletBalanceService _balances;
  final TransferService _transfers;
  final InvestmentService _investments;
  static const _uuid = Uuid();

  // ------------------------------------------------------------ reading

  Future<List<Plan>> allPlans() =>
      (_db.select(_db.plans)
            ..where((p) => p.deletedAt.isNull())
            ..orderBy([(p) => OrderingTerm.asc(p.createdAt)]))
          .get();

  Future<Plan?> findPlan(String id) =>
      (_db.select(_db.plans)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Transaction>> transactionsOf(String planId) =>
      (_db.select(_db.transactions)
            ..where((t) => t.planId.equals(planId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<PlanProgress> progressOf(Plan plan) async {
    final rows = await (_db.select(
      _db.transactions,
    )..where((t) => t.planId.equals(plan.id))).get();
    return PlanProgress(
      plan: plan,
      events: planEvents(plan),
      recorded: {
        for (final t in rows)
          if (t.planInstallment != null && t.planInstallment! > 0)
            t.planInstallment!,
      },
    );
  }

  // ----------------------------------------------------------- creating

  /// Start a plan. Returns its id.
  ///
  /// A DPS or FDR gets a deposit account of its own, in the same currency as
  /// the account it is paid from. An FDR's sum moves into it straight away,
  /// and a loan's money received is recorded as borrowed, so Lend & borrow
  /// shows what is owed on it.
  Future<String> create(PlanDraft d) async {
    _validate(d);
    final wallet = await _db.findWalletById(d.walletId);
    if (wallet == null || wallet.deletedAt != null) {
      throw ArgumentError('That account no longer exists.');
    }
    if (wallet.walletType.isManaged) {
      throw ArgumentError(
        'A plan is paid from an ordinary account, not from a deposit.',
      );
    }

    // A SIP buys into a holding that already has its own account.
    String? investmentWallet;
    if (d.kind == PlanKind.sip) {
      final investment = d.investmentId == null
          ? null
          : await _investments.find(d.investmentId!);
      if (investment == null || investment.deletedAt != null) {
        throw ArgumentError('Choose the fund or share the SIP buys.');
      }
      if (investment.walletId == d.walletId) {
        throw ArgumentError('Pay for the SIP from another account.');
      }
      investmentWallet = investment.walletId;
    }

    final id = _uuid.v4();
    final now = DateTime.now();
    final categoryId =
        d.categoryId ??
        switch (d.kind) {
          PlanKind.emi || PlanKind.loan => await _db.requireSystemCategoryId(
            BuiltInCategoryKeys.loanPayment,
          ),
          PlanKind.insurance => await _db.requireSystemCategoryId(
            BuiltInCategoryKeys.insurance,
          ),
          _ => null,
        };

    final installment = d.kind.isFixedDeposit ? 0 : d.installmentAmount;
    final principal = switch (d.kind) {
      PlanKind.dps => d.installmentAmount * d.installmentCount,
      _ => d.principal,
    };

    await _db.transaction(() async {
      String? holdingId = investmentWallet;
      if (d.kind.holdsMoney) {
        holdingId = _uuid.v4();
        await _db.addWallet(
          WalletsCompanion(
            id: Value(holdingId),
            name: Value(d.name),
            currency: Value(wallet.currency),
            iconName: const Value('savings'),
            color: Value(switch (d.kind) {
              PlanKind.dps => '#0EA5E9',
              PlanKind.bond => '#0D9488',
              _ => '#10B981',
            }),
            walletType: const Value(WalletType.deposit),
            useDecimals: Value(wallet.useDecimals),
            balance: const Value(0),
            openingBalance: const Value(0),
            orderIndex: const Value(9999),
            syncStatus: const Value(SyncStatus.pendingCreate),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }

      await _db
          .into(_db.plans)
          .insert(
            PlansCompanion(
              id: Value(id),
              kind: Value(d.kind),
              name: Value(d.name.trim()),
              walletId: Value(d.walletId),
              holdingWalletId: Value(holdingId),
              categoryId: Value(categoryId),
              principal: Value(principal),
              installmentAmount: Value(installment),
              installmentCount: Value(d.installmentCount),
              frequency: Value(d.frequency),
              interval: Value(d.interval),
              startDate: Value(d.startDate),
              interestRate: Value(d.interestRate),
              maturityAmount: Value(d.maturityAmount),
              payout: Value(d.payout),
              autoCollect: Value(d.autoCollect),
              reminderDaysBefore: Value(d.reminderDaysBefore),
              notes: Value(d.notes),
              provider: Value(_blankToNull(d.provider)),
              reference: Value(_blankToNull(d.reference)),
              taxRate: Value(d.taxRate),
              syncStatus: const Value(SyncStatus.pendingCreate),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    });

    final plan = (await findPlan(id))!;
    if (plan.kind.isFixedDeposit) {
      await _transferFor(
        plan,
        number: 0,
        from: plan.walletId,
        to: plan.holdingWalletId!,
        amount: plan.principal,
        date: _notAfterNow(plan.startDate),
        title: '${plan.name}: deposit',
      );
    }
    if (plan.kind == PlanKind.loan && d.loanReceived) {
      await _loanReceived(plan);
    }
    return id;
  }

  void _validate(PlanDraft d) {
    if (d.name.trim().isEmpty) throw ArgumentError('Give the plan a name.');
    if (d.installmentCount < 1 || d.installmentCount > 1200) {
      throw ArgumentError('The number of installments must be 1 to 1200.');
    }
    if (d.interval < 1) throw ArgumentError('The interval must be at least 1.');
    if (d.interestRate != null &&
        (d.interestRate! < 0 || d.interestRate! > 100)) {
      throw ArgumentError('The rate must be between 0 and 100 percent.');
    }
    if (d.taxRate != null && (d.taxRate! < 0 || d.taxRate! > 100)) {
      throw ArgumentError('The tax must be between 0 and 100 percent.');
    }
    // The server keeps 100 characters of each.
    if ((d.provider?.trim().length ?? 0) > 100 ||
        (d.reference?.trim().length ?? 0) > 100) {
      throw ArgumentError('Keep the company and number under 100 characters.');
    }
    switch (d.kind) {
      case PlanKind.emi:
      case PlanKind.loan:
      case PlanKind.dps:
      case PlanKind.insurance:
      case PlanKind.sip:
        if (d.installmentAmount <= 0) {
          throw ArgumentError(
            d.kind == PlanKind.insurance
                ? 'Enter the premium.'
                : 'Enter the amount of each installment.',
          );
        }
      case PlanKind.fdr:
      case PlanKind.bond:
        if (d.principal <= 0) {
          throw ArgumentError('Enter the amount deposited.');
        }
        if (d.frequency == PlanFrequency.weekly) {
          throw ArgumentError('It runs for months or years.');
        }
    }
    if ((d.kind == PlanKind.emi || d.kind == PlanKind.loan) &&
        d.principal < 0) {
      throw ArgumentError('The amount cannot be negative.');
    }
  }

  // ---------------------------------------------------------- recording

  /// Record everything due by [now] on every plan that collects by itself.
  /// Returns how many events were recorded.
  Future<int> collectDue({DateTime? now}) async {
    final at = now ?? DateTime.now();
    var count = 0;
    for (final plan in await allPlans()) {
      if (plan.status != PlanStatus.active || !plan.autoCollect) continue;
      final progress = await progressOf(plan);
      for (final event in progress.overdue(at)) {
        await _record(plan, event, on: event.date);
        count++;
      }
      await _completeIfFinished(plan);
    }
    return count;
  }

  /// Record the next event of [planId] now: pay the next installment early,
  /// or take a maturity that has come.
  Future<PlanEvent?> payNext(String planId, {DateTime? on}) async {
    final plan = await _activePlan(planId);
    final next = (await progressOf(plan)).next;
    if (next == null) return null;
    if (next.type == PlanEventType.maturity &&
        next.date.isAfter(DateTime.now())) {
      throw ArgumentError(
        '${plan.name} matures on ${_day(next.date)}. To take the money out '
        'before then, close it early.',
      );
    }
    await _record(plan, next, on: on ?? DateTime.now());
    await _completeIfFinished(plan);
    return next;
  }

  /// End [planId] before its term.
  ///
  /// An EMI or loan is paid off: everything left on an EMI, or what is still
  /// owed of a loan's principal, in one payment ([amount] if the lender quoted
  /// a different settlement figure). A DPS or FDR is encashed: what is in its
  /// deposit account comes back, plus [amount] as profit if the bank paid any.
  Future<void> closeEarly(String planId, {int? amount, DateTime? on}) async {
    final plan = await _activePlan(planId);
    final progress = await progressOf(plan);
    final date = on ?? DateTime.now();
    final number = _closingNumber(progress);

    switch (plan.kind) {
      case PlanKind.emi:
        final due = amount ?? progress.remaining;
        if (due > 0) {
          await _expense(
            plan,
            number: number,
            amount: due,
            date: date,
            title: '${plan.name}: paid off',
          );
        }
      case PlanKind.loan:
        final debt = await _loanRow(plan);
        final owed = debt == null
            ? progress.events
                  .where((e) => !progress.recorded.contains(e.number))
                  .fold(0, (s, e) => s + e.principalPart)
            : TransactionPolicy.outstandingAmount(debt);
        final due = amount ?? owed;
        if (due > 0) {
          await _repayLoan(
            plan,
            number: number,
            principal: math.min(due, owed),
            interest: math.max(0, due - owed),
            date: date,
            title: '${plan.name}: paid off',
          );
        }
      case PlanKind.sip:
        // Stopped: what it bought stays in the holding.
        break;
      case PlanKind.insurance:
        // Surrendered: whatever the insurer pays back is income.
        if ((amount ?? 0) > 0) {
          await _income(
            plan,
            number: number,
            amount: amount!,
            date: date,
            title: '${plan.name}: surrender value',
          );
        }
      case PlanKind.dps:
      case PlanKind.fdr:
      case PlanKind.bond:
        final holding = await _db.findWalletById(plan.holdingWalletId!);
        final saved = holding?.balance ?? 0;
        if (saved > 0) {
          await _transferFor(
            plan,
            number: number,
            from: plan.holdingWalletId!,
            to: plan.walletId,
            amount: saved,
            date: date,
            title: '${plan.name}: encashed',
          );
        }
        if ((amount ?? 0) > 0) {
          await _income(
            plan,
            number: number,
            suffix: ':profit',
            amount: amount!,
            date: date,
            title: '${plan.name}: profit',
          );
        }
    }
    await _setStatus(plan, PlanStatus.closed, closedAt: date);
  }

  /// Change what can change about a running plan.
  Future<void> update(
    String planId, {
    String? name,
    bool? autoCollect,
    int? reminderDaysBefore,
    int? maturityAmount,
    String? notes,
  }) async {
    final plan = await findPlan(planId);
    if (plan == null || plan.deletedAt != null) {
      throw ArgumentError('That plan no longer exists.');
    }
    if (reminderDaysBefore != null &&
        (reminderDaysBefore < 0 || reminderDaysBefore > 30)) {
      throw ArgumentError('Reminders can be 0 (off) to 30 days before.');
    }
    await (_db.update(_db.plans)..where((p) => p.id.equals(planId))).write(
      PlansCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        autoCollect: autoCollect == null
            ? const Value.absent()
            : Value(autoCollect),
        reminderDaysBefore: reminderDaysBefore == null
            ? const Value.absent()
            : Value(reminderDaysBefore),
        maturityAmount: maturityAmount == null
            ? const Value.absent()
            : Value(maturityAmount),
        notes: notes == null ? const Value.absent() : Value(notes),
        syncStatus: Value(_edited(plan.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Remove [planId]. What it recorded stays, as ordinary history.
  ///
  /// Refused for a DPS or FDR that still holds money: deleting it would make
  /// that money vanish from the total. Close it first, which moves the money
  /// back.
  Future<void> delete(String planId) async {
    final plan = await findPlan(planId);
    if (plan == null || plan.deletedAt != null) return;
    // A SIP's holding belongs to its investment, which outlives it.
    final ownsHolding = plan.holdingWalletId != null && plan.kind.holdsMoney;
    if (ownsHolding) {
      final holding = await _db.findWalletById(plan.holdingWalletId!);
      if (holding != null &&
          holding.deletedAt == null &&
          holding.balance != 0) {
        throw ArgumentError(
          '${plan.name} still holds money. Close it first, which moves the '
          'money back to ${(await _db.findWalletById(plan.walletId))?.name ?? 'its account'}.',
        );
      }
    }
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(_db.plans)..where((p) => p.id.equals(planId))).write(
        PlansCompanion(
          deletedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(now),
        ),
      );
      if (ownsHolding) {
        await (_db.update(
          _db.wallets,
        )..where((w) => w.id.equals(plan.holdingWalletId!))).write(
          WalletsCompanion(
            isArchived: const Value(true),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }

  // ------------------------------------------------------------ internals

  Future<Plan> _activePlan(String planId) async {
    final plan = await findPlan(planId);
    if (plan == null || plan.deletedAt != null) {
      throw ArgumentError('That plan no longer exists.');
    }
    if (plan.status != PlanStatus.active) {
      throw ArgumentError('${plan.name} has already ended.');
    }
    return plan;
  }

  /// The event number a closing payment is recorded under: past every
  /// scheduled one, so it can never collide with an installment.
  int _closingNumber(PlanProgress p) =>
      p.events.fold(0, (m, e) => math.max(m, e.number)) + 1;

  Future<void> _record(Plan plan, PlanEvent e, {required DateTime on}) async {
    final date = _notAfterNow(on);
    final count = plan.installmentCount;
    switch (plan.kind) {
      case PlanKind.emi:
        await _expense(
          plan,
          number: e.number,
          amount: e.amount,
          date: date,
          title: '${plan.name}: installment ${e.number} of $count',
        );
      case PlanKind.loan:
        await _repayLoan(
          plan,
          number: e.number,
          principal: e.principalPart,
          interest: e.interestPart,
          date: date,
          title: '${plan.name}: installment ${e.number} of $count',
        );
      case PlanKind.dps:
        if (e.type == PlanEventType.installment) {
          await _transferFor(
            plan,
            number: e.number,
            from: plan.walletId,
            to: plan.holdingWalletId!,
            amount: e.amount,
            date: date,
            title: '${plan.name}: deposit ${e.number} of $count',
          );
        } else {
          await _mature(plan, e, date);
        }
      case PlanKind.sip:
        await _buyFor(plan, e, date);
      case PlanKind.insurance:
        if (e.type == PlanEventType.installment) {
          await _expense(
            plan,
            number: e.number,
            amount: e.amount,
            date: date,
            title: '${plan.name}: premium ${e.number} of $count',
          );
        } else {
          await _income(
            plan,
            number: e.number,
            amount: e.amount,
            date: date,
            title: '${plan.name}: policy paid out',
          );
        }
      case PlanKind.fdr:
      case PlanKind.bond:
        if (e.type == PlanEventType.profit) {
          await _income(
            plan,
            number: e.number,
            amount: e.amount,
            date: date,
            title: '${plan.name}: profit',
          );
        } else {
          await _mature(plan, e, date);
        }
    }
  }

  /// A DPS or FDR paid back: what it holds comes home, and the profit is
  /// income. What it holds, rather than what it should hold, so a missed
  /// deposit cannot conjure money that was never put in.
  Future<void> _mature(Plan plan, PlanEvent e, DateTime date) async {
    final holding = await _db.findWalletById(plan.holdingWalletId!);
    final saved = holding?.balance ?? e.principalPart;
    if (saved > 0) {
      await _transferFor(
        plan,
        number: e.number,
        from: plan.holdingWalletId!,
        to: plan.walletId,
        amount: saved,
        date: date,
        title: '${plan.name}: matured',
      );
    }
    if (e.interestPart > 0) {
      await _income(
        plan,
        number: e.number,
        suffix: ':profit',
        amount: e.interestPart,
        date: date,
        title: '${plan.name}: profit at maturity',
      );
    }
  }

  /// A SIP installment: the sum buys units at the holding's latest price.
  /// The units are an estimate until the fund's statement gives the real
  /// figure, which can be corrected on the investment.
  Future<void> _buyFor(Plan plan, PlanEvent e, DateTime date) async {
    final investment = await _investments.byWallet(plan.holdingWalletId!);
    if (investment == null) return;
    await _investments.buy(
      investment.id,
      fromWalletId: plan.walletId,
      amount: e.amount,
      units: investment.price > 0 ? e.amount / investment.price : null,
      date: date,
      title: '${plan.name}: SIP ${e.number} of ${plan.installmentCount}',
      key: _key(plan, e.number),
      planId: plan.id,
      planInstallment: e.number,
    );
  }

  Future<void> _completeIfFinished(Plan plan) async {
    final fresh = await findPlan(plan.id);
    if (fresh == null || fresh.status != PlanStatus.active) return;
    if ((await progressOf(fresh)).isFinished) {
      await _setStatus(fresh, PlanStatus.completed, closedAt: DateTime.now());
    }
  }

  Future<void> _setStatus(
    Plan plan,
    PlanStatus status, {
    DateTime? closedAt,
  }) async {
    await (_db.update(_db.plans)..where((p) => p.id.equals(plan.id))).write(
      PlansCompanion(
        status: Value(status),
        closedAt: Value(closedAt),
        syncStatus: Value(_edited(plan.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> _keyTaken(String key) async =>
      await (_db.select(
        _db.transactions,
      )..where((t) => t.occurrenceKey.equals(key))).getSingleOrNull() !=
      null;

  String _key(Plan plan, int number, [String suffix = '']) =>
      'plan:${plan.id}:$number$suffix';

  Future<void> _expense(
    Plan plan, {
    required int number,
    required int amount,
    required DateTime date,
    required String title,
    String suffix = '',
    String? categoryId,
    String? settles,
  }) async {
    final key = _key(plan, number, suffix);
    if (amount <= 0 || await _keyTaken(key)) return;
    final now = DateTime.now();
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(_uuid.v4()),
        amount: Value(amount),
        isIncome: const Value(false),
        title: Value(title),
        date: Value(date),
        walletId: Value(plan.walletId),
        categoryId: Value(categoryId ?? plan.categoryId),
        transactionType: Value(TransactionPolicy.regularType),
        settlesTransactionId: Value(settles),
        isPaid: const Value(true),
        planId: Value(plan.id),
        planInstallment: Value(number),
        occurrenceKey: Value(key),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await _balances.updateWalletBalance(plan.walletId);
  }

  Future<void> _income(
    Plan plan, {
    required int number,
    required int amount,
    required DateTime date,
    required String title,
    String suffix = '',
  }) async {
    final key = _key(plan, number, suffix);
    if (amount <= 0 || await _keyTaken(key)) return;
    final now = DateTime.now();
    final category = await _db.requireSystemCategoryId(
      BuiltInCategoryKeys.investment,
    );
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(_uuid.v4()),
        amount: Value(amount),
        isIncome: const Value(true),
        title: Value(title),
        date: Value(date),
        walletId: Value(plan.walletId),
        categoryId: Value(category),
        transactionType: Value(TransactionPolicy.regularType),
        isPaid: const Value(true),
        planId: Value(plan.id),
        planInstallment: Value(number),
        occurrenceKey: Value(key),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await _balances.updateWalletBalance(plan.walletId);
  }

  Future<void> _transferFor(
    Plan plan, {
    required int number,
    required String from,
    required String to,
    required int amount,
    required DateTime date,
    required String title,
  }) async {
    final key = _key(plan, number);
    if (amount <= 0 || await _keyTaken(key)) return;
    final (outId, inId) = await _transfers.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: amount,
      date: date,
      title: title,
    );
    for (final (id, k) in [(outId, key), (inId, '$key:in')]) {
      await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(
          planId: Value(plan.id),
          planInstallment: Value(number),
          occurrenceKey: Value(k),
        ),
      );
    }
  }

  /// The loan's money received, recorded as borrowed.
  Future<void> _loanReceived(Plan plan) async {
    final key = _key(plan, 0);
    if (plan.principal <= 0 || await _keyTaken(key)) return;
    final now = DateTime.now();
    final category = await _db.requireSystemCategoryId(
      BuiltInCategoryKeys.loanReceived,
    );
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(_uuid.v4()),
        amount: Value(plan.principal),
        isIncome: const Value(true),
        title: Value('${plan.name}: loan received'),
        date: Value(_notAfterNow(now)),
        walletId: Value(plan.walletId),
        categoryId: Value(category),
        transactionType: Value(TransactionPolicy.regularType),
        specialType: const Value(TransactionSpecialType.debt),
        isPaid: const Value(true),
        originalDueDate: Value(PlanDates.endOf(plan)),
        planId: Value(plan.id),
        planInstallment: const Value(0),
        occurrenceKey: Value(key),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await _balances.updateWalletBalance(plan.walletId);
  }

  Future<Transaction?> _loanRow(Plan plan) =>
      (_db.select(_db.transactions)..where(
            (t) => t.occurrenceKey.equals(_key(plan, 0)) & t.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  /// A loan installment: the principal part repays the borrowed amount, so
  /// Lend & borrow counts it down; the interest part is spending.
  Future<void> _repayLoan(
    Plan plan, {
    required int number,
    required int principal,
    required int interest,
    required DateTime date,
    required String title,
  }) async {
    final debt = await _loanRow(plan);
    if (debt == null) {
      // Not recorded as borrowed here, so there is nothing to count down.
      await _expense(
        plan,
        number: number,
        amount: principal + interest,
        date: date,
        title: title,
      );
      return;
    }
    final key = _key(plan, number);
    if (await _keyTaken(key)) return;
    final applied = math.min(
      principal,
      TransactionPolicy.outstandingAmount(debt),
    );
    await _db.transaction(() async {
      if (applied > 0) {
        await _expense(
          plan,
          number: number,
          amount: applied,
          date: date,
          title: title,
          settles: debt.id,
        );
        await (_db.update(
          _db.transactions,
        )..where((t) => t.id.equals(debt.id))).write(
          TransactionsCompanion(
            paidAmount: Value(debt.paidAmount + applied),
            syncStatus: Value(_edited(debt.syncStatus)),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      final extra = interest + (principal - applied);
      if (extra > 0) {
        await _expense(
          plan,
          number: number,
          suffix: applied > 0 ? ':interest' : '',
          amount: extra,
          date: date,
          title: '$title (interest)',
          categoryId: await _db.requireSystemCategoryId(
            BuiltInCategoryKeys.feesCharges,
          ),
        );
      }
    });
  }

  static String? _blankToNull(String? s) =>
      s == null || s.trim().isEmpty ? null : s.trim();

  static int _edited(int status) =>
      status == SyncStatus.pendingCreate ? status : SyncStatus.pendingUpdate;

  static DateTime _notAfterNow(DateTime d) {
    final now = DateTime.now();
    return d.isAfter(now) ? now : d;
  }

  static String _day(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
