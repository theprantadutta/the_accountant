import 'dart:math' as math;

import 'package:the_accountant/core/domain/amount_converter.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/cards/domain/card_statement.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

/// Where a forecast event comes from.
enum ForecastSource { plan, cardBill, recurring, upcoming, loan }

/// What a forecast event is, closely enough to name it on screen.
enum ForecastEventKind {
  /// An EMI or loan installment.
  installment,

  /// An insurance premium.
  premium,

  /// A DPS deposit.
  deposit,

  /// A SIP buying into a fund or share.
  sipBuy,

  /// An FDR's or bond's profit paid out.
  profit,

  /// A DPS, FDR, bond or policy paying back.
  maturity,

  /// A card bill that has closed and is still to pay.
  cardBill,

  /// What a card has charged since its last statement, due once that closes.
  cardBillNext,

  subscription,
  recurringBill,
  recurringIncome,

  /// Something entered ahead of time and not paid yet.
  upcoming,

  /// Money borrowed, to be paid back.
  borrowed,

  /// Money lent, expected back.
  lent,
}

/// One thing expected to move spendable money on a day.
class ForecastEvent {
  const ForecastEvent({
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.source,
    required this.kind,
    required this.title,
    this.expected = false,
    this.overdue = false,
    this.walletId,
    this.refId,
  });

  /// The day it falls on; an overdue item falls on the first day.
  final DateTime date;

  /// Minor units of the forecast's currency, always positive.
  final int amount;
  final bool isIncome;
  final ForecastSource source;
  final ForecastEventKind kind;

  /// The plan, card, schedule or transaction it comes from, by its own name.
  final String title;

  /// Money someone else owes, which may not come.
  final bool expected;

  /// Already past its date and still open, so it is due now.
  final bool overdue;

  /// The account it is paid from or into, or the card a bill is for.
  final String? walletId;

  /// What a tap opens: the plan for a plan's event, the transaction for an
  /// upcoming payment, a loan or a schedule (its first payment). A card bill
  /// opens its card, by [walletId].
  final String? refId;

  int get signed => isIncome ? amount : -amount;
}

/// Spendable money at the end of one day.
class ForecastDay {
  const ForecastDay(this.date, this.balance);

  final DateTime date;

  /// Minor units of the forecast's currency.
  final int balance;
}

/// Where spendable money is headed over the next [days].
class CashFlowForecast {
  const CashFlowForecast({
    required this.start,
    required this.days,
    required this.currency,
    required this.startingBalance,
    required this.events,
    required this.daily,
    this.unconverted = 0,
  });

  /// Today, at midnight.
  final DateTime start;
  final int days;

  /// What every amount here is in.
  final String currency;

  /// Cash and bank accounts now, in minor units.
  final int startingBalance;

  /// In date order.
  final List<ForecastEvent> events;

  /// One entry a day, from today to the last day.
  final List<ForecastDay> daily;

  /// Accounts and events left out for want of an exchange rate.
  final int unconverted;

  DateTime get end => daily.last.date;

  int get endingBalance => daily.last.balance;

  int get moneyIn =>
      events.where((e) => e.isIncome).fold(0, (s, e) => s + e.amount);

  int get moneyOut =>
      events.where((e) => !e.isIncome).fold(0, (s, e) => s + e.amount);

  /// The lowest the balance gets, the first day it does.
  ForecastDay get lowest =>
      daily.reduce((low, d) => d.balance < low.balance ? d : low);

  /// The first day the balance is below zero, or null when it never is.
  ForecastDay? get shortfall => daily.where((d) => d.balance < 0).firstOrNull;

  bool get hasShortfall => shortfall != null;

  /// How much would be missing on the [shortfall] day.
  int get shortfallAmount => math.max(0, -(shortfall?.balance ?? 0));

  /// Whether a shortfall comes within [days] days of today.
  bool shortfallWithin(int days) {
    final s = shortfall;
    return s != null && s.date.difference(start).inDays < days;
  }

  /// What goes out on the day the balance first drops below zero: the
  /// payments that tip it over.
  List<ForecastEvent> get shortfallEvents {
    final s = shortfall;
    if (s == null) return const [];
    return events
        .where((e) => !e.isIncome && _sameDay(e.date, s.date))
        .toList();
  }

  /// Events grouped by day, in date order.
  List<({DateTime date, List<ForecastEvent> events})> get byDay {
    final groups = <({DateTime date, List<ForecastEvent> events})>[];
    for (final e in events) {
      if (groups.isNotEmpty && _sameDay(groups.last.date, e.date)) {
        groups.last.events.add(e);
      } else {
        groups.add((date: e.date, events: [e]));
      }
    }
    return groups;
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Projects spendable money forward from what is already scheduled.
///
/// Spendable money is cash and bank accounts that count in the total: not
/// cards (a card's balance is a bill, counted on the day it is due), and not
/// the accounts a deposit, investment or asset keeps its value in, which
/// cannot be spent from. What moves it is what the app already knows is
/// coming: plan installments and payouts not yet recorded, card bills,
/// every occurrence of a subscription or repeating transaction, upcoming
/// payments, and loans with a due date. Everyday spending is not guessed at;
/// the forecast says what the commitments alone would do.
///
/// No Riverpod in here, so the background worker can check for a shortfall
/// with the app closed.
class CashFlowForecastService {
  CashFlowForecastService(this._db);

  final AppDatabase _db;

  /// The ranges offered on screen and to the coach.
  static const ranges = [30, 60, 90];

  /// Safety stop for a schedule that never reaches the window's end, such as
  /// a daily one whose next date was left years behind.
  static const _maxOccurrences = 5000;

  Future<CashFlowForecast> forecast({int days = 30, DateTime? now}) async {
    final at = now ?? DateTime.now();
    final today = DateTime(at.year, at.month, at.day);
    final lastDay = DateTime(today.year, today.month, today.day + days);
    final wallets = {for (final w in await _db.getAllWallets()) w.id: w};
    final converter = await AmountConverter.forDatabase(_db);
    var unconverted = 0;

    bool spendable(String? walletId) {
      final w = wallets[walletId];
      return w != null &&
          !w.walletType.isManaged &&
          FinancialCalculationService.countsInNetWorth(
            w,
            includeCreditCards: false,
          );
    }

    var starting = 0;
    for (final w in wallets.values) {
      if (!spendable(w.id)) continue;
      final value = converter.convert(w.balance, w.id);
      if (value == null) {
        unconverted++;
      } else {
        starting += value;
      }
    }

    final events = <ForecastEvent>[];

    /// Add one event if it lands in the window. Something already past its
    /// date and still open is due now, so it lands on today.
    void add({
      required DateTime date,
      required int amount,
      required String walletId,
      required bool isIncome,
      required ForecastSource source,
      required ForecastEventKind kind,
      required String title,
      bool expected = false,
      bool allowOverdue = true,
      String? refId,
    }) {
      if (amount <= 0) return;
      final day = DateTime(date.year, date.month, date.day);
      if (day.isAfter(lastDay)) return;
      final overdue = day.isBefore(today);
      if (overdue && !allowOverdue) return;
      final value = converter.convert(amount, walletId);
      if (value == null) {
        unconverted++;
        return;
      }
      events.add(
        ForecastEvent(
          date: overdue ? today : day,
          amount: value,
          isIncome: isIncome,
          source: source,
          kind: kind,
          title: title,
          expected: expected,
          overdue: overdue,
          walletId: walletId,
          refId: refId,
        ),
      );
    }

    await _plans(spendable, add);
    await _cardBills(wallets.values, today, add);
    await _recurring(spendable, today, lastDay, add);
    await _unpaid(spendable, add);
    await _loans(spendable, add, today);

    // Stable within a day: the order the sources were read in.
    final indexed = events.indexed.toList()
      ..sort((a, b) {
        final byDate = a.$2.date.compareTo(b.$2.date);
        return byDate != 0 ? byDate : a.$1.compareTo(b.$1);
      });
    final sorted = [for (final (_, e) in indexed) e];

    final daily = <ForecastDay>[];
    var balance = starting;
    var next = 0;
    for (var i = 0; i <= days; i++) {
      final day = DateTime(today.year, today.month, today.day + i);
      while (next < sorted.length && !sorted[next].date.isAfter(day)) {
        balance += sorted[next].signed;
        next++;
      }
      daily.add(ForecastDay(day, balance));
    }

    return CashFlowForecast(
      start: today,
      days: days,
      currency: converter.target,
      startingBalance: starting,
      events: sorted,
      daily: daily,
      unconverted: unconverted,
    );
  }

  // ------------------------------------------------------------ sources

  /// Every plan event not yet recorded. Installments, premiums, DPS deposits
  /// and SIP buys leave the plan's account; profits and maturities come back
  /// to it. A plan paid from a card is left to the card's bill.
  Future<void> _plans(bool Function(String?) spendable, _Add add) async {
    final service = PlanService(_db);
    for (final plan in await service.allPlans()) {
      if (plan.status != PlanStatus.active || !spendable(plan.walletId)) {
        continue;
      }
      final progress = await service.progressOf(plan);
      for (final e in progress.events) {
        if (progress.recorded.contains(e.number)) continue;
        final isIncome = e.type != PlanEventType.installment;
        add(
          date: e.date,
          amount: e.amount,
          walletId: plan.walletId,
          isIncome: isIncome,
          source: ForecastSource.plan,
          kind: switch (e.type) {
            PlanEventType.profit => ForecastEventKind.profit,
            PlanEventType.maturity => ForecastEventKind.maturity,
            PlanEventType.installment => switch (plan.kind) {
              PlanKind.insurance => ForecastEventKind.premium,
              PlanKind.dps => ForecastEventKind.deposit,
              PlanKind.sip => ForecastEventKind.sipBuy,
              _ => ForecastEventKind.installment,
            },
          },
          title: plan.name,
          refId: plan.id,
        );
      }
    }
  }

  /// Each card's bill on its due date, as money leaving the bank that pays
  /// it. Spending on a card never touches spendable money by itself, so the
  /// bill is the one place it is counted.
  ///
  /// Two bills can fall in the window: the one that has closed, less what
  /// has been paid onto it, and the one building up now, at what has been
  /// charged so far. Charges still to come on the card are not guessed at.
  Future<void> _cardBills(
    Iterable<Wallet> wallets,
    DateTime today,
    _Add add,
  ) async {
    for (final card in wallets) {
      if (card.walletType != WalletType.creditCard || card.isArchived) {
        continue;
      }
      final bill = CardBill.of(
        card,
        await _db.getTransactionsByWallet(card.id),
        today: today,
      );
      final latest = bill.latest;
      if (latest == null) continue;
      add(
        date: latest.dueDate,
        amount: latest.remaining,
        walletId: card.id,
        isIncome: false,
        source: ForecastSource.cardBill,
        kind: ForecastEventKind.cardBill,
        title: card.name,
      );
      // Everything owed now beyond the closed bill is the next one, as long
      // as the closed one is paid by its date.
      final owedNow = math.max(0, -card.balance);
      final building = math.max(0, owedNow - latest.remaining);
      final closes = bill.nextStatementDate;
      if (building > 0 && closes != null && card.paymentDueDay != null) {
        add(
          date: CardCycle.dueDateAfter(closes, card.paymentDueDay!),
          amount: building,
          walletId: card.id,
          isIncome: false,
          source: ForecastSource.cardBill,
          kind: ForecastEventKind.cardBillNext,
          title: card.name,
        );
      }
    }
  }

  /// Every occurrence of every running subscription and repeating
  /// transaction in the window.
  ///
  /// From the schedule's next date on: anything before it has been written
  /// as a transaction already, and is either in the balance or waiting as an
  /// unpaid payment. An occurrence from an earlier day the scheduler has not
  /// caught up on yet is left out; it is written the next time the app runs.
  Future<void> _recurring(
    bool Function(String?) spendable,
    DateTime today,
    DateTime lastDay,
    _Add add,
  ) async {
    final schedules = RecurringService(database: _db);
    for (final config in await _db.getActiveRecurringConfigs()) {
      final base = await _db.findTransactionById(config.baseTransactionId);
      if (base == null || base.deletedAt != null) continue;
      final walletId = config.walletId ?? base.walletId;
      if (!spendable(walletId)) continue;
      final kind = base.specialType == TransactionSpecialType.subscription
          ? ForecastEventKind.subscription
          : base.isIncome
          ? ForecastEventKind.recurringIncome
          : ForecastEventKind.recurringBill;

      var date = config.nextOccurrence;
      for (var n = 0; n < _maxOccurrences; n++) {
        if (DateTime(date.year, date.month, date.day).isAfter(lastDay)) break;
        if (config.endDate != null && date.isAfter(config.endDate!)) break;
        if (!date.isBefore(today)) {
          add(
            date: date,
            amount: config.amount ?? base.amount,
            walletId: walletId,
            isIncome: base.isIncome,
            source: ForecastSource.recurring,
            kind: kind,
            title: base.title,
            refId: base.id,
          );
        }
        date = schedules.calculateNextOccurrence(
          date,
          config.reoccurrence,
          config.periodLength,
        );
      }
    }
  }

  /// Payments entered ahead of time and not yet paid, and those a schedule
  /// is waiting to have confirmed. Each side of a transfer counts on its own
  /// account, so moving money between two spendable accounts nets to nothing.
  Future<void> _unpaid(bool Function(String?) spendable, _Add add) async {
    final rows =
        await (_db.select(_db.transactions)
              ..where((t) => t.isPaid.equals(false))
              ..where((t) => t.skipPaid.equals(false))
              ..where((t) => t.deletedAt.isNull()))
            .get();
    for (final t in rows) {
      if (TransactionPolicy.isCreditOrDebt(t) || !spendable(t.walletId)) {
        continue;
      }
      add(
        date: t.date,
        amount: t.amount.abs(),
        walletId: t.walletId,
        isIncome: t.isIncome,
        source: ForecastSource.upcoming,
        kind: ForecastEventKind.upcoming,
        title: t.title,
        refId: t.id,
      );
    }
  }

  /// Loans with a due date and something still owed. Money borrowed is paid
  /// back on its date, or now if that has passed. Money lent is only
  /// expected: someone else decides when it comes, so one due today or
  /// already late is not counted on at all. A shortfall warning that assumed
  /// a friend pays back the same day — which is when a split bill's shares
  /// fall due — would be telling the user they are fine when they are not.
  ///
  /// A loan a plan was made for is repaid by the plan's installments, which
  /// are counted with the plans.
  Future<void> _loans(
    bool Function(String?) spendable,
    _Add add,
    DateTime today,
  ) async {
    final rows = [
      ...await _db.getDebtTransactions(),
      ...await _db.getCreditTransactions(),
    ];
    for (final t in rows) {
      final due = t.originalDueDate;
      if (due == null ||
          t.planId != null ||
          !TransactionPolicy.isOutstanding(t) ||
          !spendable(t.walletId)) {
        continue;
      }
      final lent = TransactionPolicy.isCredit(t);
      if (lent && !DateTime(due.year, due.month, due.day).isAfter(today)) {
        continue;
      }
      add(
        date: due,
        amount: TransactionPolicy.outstandingAmount(t),
        walletId: t.walletId,
        isIncome: lent,
        source: ForecastSource.loan,
        kind: lent ? ForecastEventKind.lent : ForecastEventKind.borrowed,
        title: t.title,
        refId: t.id,
        expected: lent,
        allowOverdue: !lent,
      );
    }
  }
}

typedef _Add =
    void Function({
      required DateTime date,
      required int amount,
      required String walletId,
      required bool isIncome,
      required ForecastSource source,
      required ForecastEventKind kind,
      required String title,
      bool expected,
      bool allowOverdue,
      String? refId,
    });
