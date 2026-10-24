import 'dart:math' as math;

import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Where a card's statement and due dates fall.
///
/// The same rules the server uses to send its reminders
/// (`TheAccountant.Domain.Cards.CardCycle`), so the date on the screen is the
/// date in the notification. A day past the end of a month means its last
/// day: a statement on the 31st closes on 30 April and 28 February.
class CardCycle {
  const CardCycle._();

  static DateTime onDay(int year, int month, int day) {
    final last = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day.clamp(1, last));
  }

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// The most recent statement date strictly before [today]; today's
  /// statement has not closed yet, it closes at the end of the day.
  static DateTime lastStatementBefore(DateTime today, int statementDay) {
    final day = dateOnly(today);
    final thisMonth = onDay(day.year, day.month, statementDay);
    if (thisMonth.isBefore(day)) return thisMonth;
    return onDay(day.year, day.month - 1, statementDay);
  }

  /// The first [dueDay] after [statement].
  static DateTime dueDateAfter(DateTime statement, int dueDay) {
    final sameMonth = onDay(statement.year, statement.month, dueDay);
    if (sameMonth.isAfter(statement)) return sameMonth;
    return onDay(statement.year, statement.month + 1, dueDay);
  }

  /// The statement after [statement].
  static DateTime nextStatement(DateTime statement, int statementDay) =>
      onDay(statement.year, statement.month + 1, statementDay);
}

/// One credit card bill: what was owed when the statement closed, and how
/// much of it has been paid since.
class CardStatement {
  const CardStatement({
    required this.statementDate,
    required this.dueDate,
    required this.owed,
    required this.paid,
  });

  /// The day the statement closed.
  final DateTime statementDate;

  /// The day it must be paid by.
  final DateTime dueDate;

  /// What the card owed at the end of the statement day, in minor units.
  final int owed;

  /// Payments and refunds onto the card in the following cycle.
  final int paid;

  int get remaining => math.max(0, owed - paid);
  bool get isSettled => remaining == 0;
}

/// How a card's latest bill stands today.
enum CardBillStatus {
  /// No statement day or due day yet, so there is no bill to work out.
  notSetUp,

  /// The card owed nothing when the statement closed.
  nothingDue,

  /// Paid in full.
  paid,

  /// Something is still to pay, with time left.
  due,

  /// Within the reminder window, or due today.
  dueSoon,

  /// Past the due date with something still unpaid.
  overdue,
}

/// Everything the card bills screen shows about one card.
class CardBill {
  const CardBill({
    required this.card,
    required this.status,
    this.latest,
    this.history = const [],
    this.nextStatementDate,
    this.spentThisCycle = 0,
  });

  final Wallet card;
  final CardBillStatus status;

  /// The bill that closed most recently.
  final CardStatement? latest;

  /// Earlier bills, newest first, the latest not included.
  final List<CardStatement> history;

  /// When the bill being built up now closes.
  final DateTime? nextStatementDate;

  /// Charges on the card since the last statement closed, in minor units.
  final int spentThisCycle;

  int daysUntilDue(DateTime today) => latest == null
      ? 0
      : latest!.dueDate.difference(CardCycle.dateOnly(today)).inDays;

  /// Work out [card]'s bills from its own [transactions].
  ///
  /// The bill is the balance at the end of the statement day, negative
  /// meaning owed, as a bank would print it, so anything left from an earlier
  /// unpaid bill is part of it. What counts toward the balance is what counts
  /// on the account everywhere else ([TransactionPolicy.walletBalanceEffect]).
  static CardBill of(
    Wallet card,
    List<Transaction> transactions, {
    required DateTime today,
    int historyLength = 6,
  }) {
    final statementDay = card.billingCycleDay;
    final dueDay = card.paymentDueDay;
    if (statementDay == null || dueDay == null) {
      return CardBill(card: card, status: CardBillStatus.notSetUp);
    }

    final effects = [
      for (final t in transactions)
        if (t.walletId == card.id && TransactionPolicy.walletBalanceEffect(t) != 0)
          (date: CardCycle.dateOnly(t.date), effect: TransactionPolicy.walletBalanceEffect(t)),
    ];

    int balanceAtEndOf(DateTime day) =>
        card.openingBalance +
        effects
            .where((e) => !e.date.isAfter(day))
            .fold(0, (sum, e) => sum + e.effect);

    int paidBetween(DateTime after, DateTime? through) => effects
        .where(
          (e) =>
              e.effect > 0 &&
              e.date.isAfter(after) &&
              (through == null || !e.date.isAfter(through)),
        )
        .fold(0, (sum, e) => sum + e.effect);

    // Newest first: the one that closed last, then the months before it.
    final closes = <DateTime>[CardCycle.lastStatementBefore(today, statementDay)];
    for (var i = 1; i <= historyLength; i++) {
      final prev = closes.last;
      closes.add(CardCycle.onDay(prev.year, prev.month - 1, statementDay));
    }

    final statements = <CardStatement>[];
    for (var i = 0; i < closes.length; i++) {
      final close = closes[i];
      // A bill's payments are those made before the next statement closed;
      // for the latest one, everything since.
      final nextClose = i == 0 ? null : closes[i - 1];
      statements.add(
        CardStatement(
          statementDate: close,
          dueDate: CardCycle.dueDateAfter(close, dueDay),
          owed: math.max(0, -balanceAtEndOf(close)),
          paid: paidBetween(close, nextClose),
        ),
      );
    }

    final latest = statements.first;
    final day = CardCycle.dateOnly(today);
    final daysLeft = latest.dueDate.difference(day).inDays;
    final status = latest.owed == 0
        ? CardBillStatus.nothingDue
        : latest.isSettled
        ? CardBillStatus.paid
        : daysLeft < 0
        ? CardBillStatus.overdue
        : daysLeft <= math.max(card.dueReminderDays, 0)
        ? CardBillStatus.dueSoon
        : CardBillStatus.due;

    final spent = effects
        .where((e) => e.effect < 0 && e.date.isAfter(latest.statementDate))
        .fold(0, (sum, e) => sum - e.effect);

    return CardBill(
      card: card,
      status: status,
      latest: latest,
      history: [
        for (final s in statements.skip(1))
          if (s.owed > 0) s,
      ],
      nextStatementDate: CardCycle.nextStatement(latest.statementDate, statementDay),
      spentThisCycle: spent,
    );
  }
}
