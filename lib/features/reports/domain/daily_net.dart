import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// One day, and what it did to the user's money.
class DailyNet {
  const DailyNet({
    required this.day,
    required this.incomeCents,
    required this.expenseCents,
  });

  /// Midnight local time, so two transactions on the same afternoon land on
  /// the same square.
  final DateTime day;

  final int incomeCents;

  /// Always positive: a magnitude, like everything else stored here.
  final int expenseCents;

  /// Earned minus spent. Negative on an ordinary day.
  int get netCents => incomeCents - expenseCents;

  bool get isEmpty => incomeCents == 0 && expenseCents == 0;
}

/// A calendar's worth of daily nets, and the scale to draw them against.
///
/// The scale is part of the model rather than the widget because it is a
/// judgement, not a detail: see [_shade].
class DailyNetCalendar {
  const DailyNetCalendar({
    required this.from,
    required this.to,
    required this.days,
    required this.busiestSpend,
    required this.busiestEarn,
  });

  /// Inclusive, both at midnight.
  final DateTime from;
  final DateTime to;

  /// Every day in the range, including the ones nothing happened on. A gap in
  /// a calendar has to be drawn, not skipped.
  final List<DailyNet> days;

  /// The largest single-day spend and earn in the range, used to scale the
  /// shading. Zero when nothing was spent or earned.
  final int busiestSpend;
  final int busiestEarn;

  bool get isEmpty => days.every((d) => d.isEmpty);

  int get totalNetCents => days.fold(0, (sum, d) => sum + d.netCents);

  /// How strongly to shade a day, from 0 (nothing) to 1 (the busiest day in
  /// range), and which way.
  ///
  /// Scaled against the busiest day *in the range shown* rather than against
  /// some fixed figure, because a heatmap answers "which days were heavy for
  /// me" and a fixed scale answers that only for whoever it was chosen for.
  /// The trade-off is that shading is not comparable between two different
  /// ranges, which is why the legend names the amount rather than the colour.
  ({double weight, bool spent}) shade(DailyNet day) {
    if (day.netCents == 0) return (weight: 0, spent: false);
    final spent = day.netCents < 0;
    final busiest = spent ? busiestSpend : busiestEarn;
    if (busiest <= 0) return (weight: 0, spent: spent);
    // A floor, so a day with any activity at all is visibly not an empty one.
    final raw = day.netCents.abs() / busiest;
    return (weight: 0.2 + raw * 0.8, spent: spent);
  }

  /// Build a calendar from [transactions], over the inclusive range.
  ///
  /// Transfers are excluded, and unpaid rows with them, because this asks what
  /// was earned and spent — the same question budgets and the rest of the
  /// reports ask, answered by the same policy. Moving your own money between
  /// your own accounts is neither, and a bill that has not been paid did not
  /// happen on the day it is dated.
  static DailyNetCalendar build({
    required Iterable<Transaction> transactions,
    required DateTime from,
    required DateTime to,
  }) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);

    final income = <DateTime, int>{};
    final expense = <DateTime, int>{};

    for (final t in transactions) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      if (day.isBefore(start) || day.isAfter(end)) continue;
      if (TransactionPolicy.countsAsIncome(t)) {
        income[day] = (income[day] ?? 0) + t.amount.abs();
      } else if (TransactionPolicy.countsAsExpense(t)) {
        expense[day] = (expense[day] ?? 0) + t.amount.abs();
      }
    }

    final days = <DailyNet>[];
    var busiestSpend = 0;
    var busiestEarn = 0;

    for (
      var day = start;
      !day.isAfter(end);
      day = DateTime(day.year, day.month, day.day + 1)
    ) {
      final entry = DailyNet(
        day: day,
        incomeCents: income[day] ?? 0,
        expenseCents: expense[day] ?? 0,
      );
      days.add(entry);
      if (entry.netCents < 0 && entry.netCents.abs() > busiestSpend) {
        busiestSpend = entry.netCents.abs();
      }
      if (entry.netCents > busiestEarn) busiestEarn = entry.netCents;
    }

    return DailyNetCalendar(
      from: start,
      to: end,
      days: days,
      busiestSpend: busiestSpend,
      busiestEarn: busiestEarn,
    );
  }
}
