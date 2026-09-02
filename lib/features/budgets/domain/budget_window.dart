import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;

/// A single span of a repeating budget: half-open, `[start, end)`.
class BudgetWindow {
  final DateTime start;
  final DateTime end;

  const BudgetWindow(this.start, this.end);

  bool contains(DateTime moment) =>
      !moment.isBefore(start) && moment.isBefore(end);

  /// How far through the window [moment] is, from 0 to 1.
  ///
  /// Used to draw the "you should be about here by now" marker, so a budget can
  /// be read as ahead or behind rather than only as a total.
  double elapsedFraction(DateTime moment) {
    final span = end.difference(start).inSeconds;
    if (span <= 0) return 1;
    final through = moment.difference(start).inSeconds;
    if (through <= 0) return 0;
    if (through >= span) return 1;
    return through / span;
  }

  @override
  String toString() => 'BudgetWindow($start .. $end)';
}

/// Works out which span of a repeating budget a given moment falls in.
///
/// Windows are anchored on the budget's own start date, not on the calendar.
/// Someone paid on the 12th who sets a monthly budget starting the 12th is
/// budgeting from the 12th to the 11th; snapping that to the first of the month
/// would charge half of one month's spending against the other's limit.
///
/// The server runs the same arithmetic in `BudgetPeriodResolver`, and the two
/// have to agree or the scheduled alert fires against a different window than
/// the one the app is showing.
class BudgetWindows {
  const BudgetWindows._();

  /// The window containing [moment].
  ///
  /// A `custom` budget does not repeat: it is the single span from its start to
  /// its end. For everything else [explicitEnd] is ignored, since a repeating
  /// budget's end date says when it stops repeating, not how long a window is.
  static BudgetWindow containing({
    required DateTime start,
    required BudgetPeriod period,
    required int periodLength,
    required DateTime moment,
    DateTime? explicitEnd,
  }) {
    final step = periodLength < 1 ? 1 : periodLength;

    if (period == BudgetPeriod.custom) {
      return BudgetWindow(start, explicitEnd ?? _farFuture);
    }

    // Before the budget opens, the first window is still the honest answer: a
    // budget that has not started has spent nothing, and reporting a window
    // that already closed would make that read as an overspend.
    if (moment.isBefore(start)) {
      return BudgetWindow(start, advance(start, period, step));
    }

    var windowStart = start;
    while (true) {
      final next = advance(windowStart, period, step);
      // A step that failed to move would spin here for ever.
      if (!next.isAfter(windowStart)) {
        return BudgetWindow(windowStart, _farFuture);
      }
      if (moment.isBefore(next)) return BudgetWindow(windowStart, next);
      windowStart = next;
    }
  }

  /// The window [offset] steps away from the one containing [moment].
  ///
  /// Negative goes back, which is how the detail screen walks through past
  /// periods. Never returns a window that starts before the budget does.
  static BudgetWindow relative({
    required DateTime start,
    required BudgetPeriod period,
    required int periodLength,
    required DateTime moment,
    required int offset,
    DateTime? explicitEnd,
  }) {
    final current = containing(
      start: start,
      period: period,
      periodLength: periodLength,
      moment: moment,
      explicitEnd: explicitEnd,
    );
    if (offset == 0 || period == BudgetPeriod.custom) return current;

    final step = periodLength < 1 ? 1 : periodLength;
    var windowStart = current.start;

    if (offset > 0) {
      for (var i = 0; i < offset; i++) {
        windowStart = advance(windowStart, period, step);
      }
    } else {
      for (var i = 0; i < -offset; i++) {
        final previous = retreat(windowStart, period, step);
        if (previous.isBefore(start)) break;
        windowStart = previous;
      }
    }

    return BudgetWindow(windowStart, advance(windowStart, period, step));
  }

  /// How many whole windows separate [start] from the one containing [moment].
  static int indexOf({
    required DateTime start,
    required BudgetPeriod period,
    required int periodLength,
    required DateTime moment,
  }) {
    if (period == BudgetPeriod.custom || !moment.isAfter(start)) return 0;
    final step = periodLength < 1 ? 1 : periodLength;
    var windowStart = start;
    var index = 0;
    while (true) {
      final next = advance(windowStart, period, step);
      if (!next.isAfter(windowStart)) return index;
      if (moment.isBefore(next)) return index;
      windowStart = next;
      index++;
    }
  }

  /// The start of the window after the one opening at [from].
  static DateTime advance(DateTime from, BudgetPeriod period, int periodLength) {
    final n = periodLength < 1 ? 1 : periodLength;
    switch (period) {
      case BudgetPeriod.daily:
        return from.add(Duration(days: n));
      case BudgetPeriod.weekly:
        return from.add(Duration(days: 7 * n));
      case BudgetPeriod.biweekly:
        return from.add(Duration(days: 14 * n));
      case BudgetPeriod.monthly:
        return _addMonths(from, n);
      case BudgetPeriod.yearly:
        return _addMonths(from, 12 * n);
      case BudgetPeriod.custom:
        return from;
    }
  }

  /// The start of the window before the one opening at [from].
  static DateTime retreat(DateTime from, BudgetPeriod period, int periodLength) {
    final n = periodLength < 1 ? 1 : periodLength;
    switch (period) {
      case BudgetPeriod.daily:
        return from.subtract(Duration(days: n));
      case BudgetPeriod.weekly:
        return from.subtract(Duration(days: 7 * n));
      case BudgetPeriod.biweekly:
        return from.subtract(Duration(days: 14 * n));
      case BudgetPeriod.monthly:
        return _addMonths(from, -n);
      case BudgetPeriod.yearly:
        return _addMonths(from, -12 * n);
      case BudgetPeriod.custom:
        return from;
    }
  }

  /// [from] moved by [months], clamped to the end of the target month.
  ///
  /// Dart normalises an overflowing day, so a naive `DateTime(y, m + 1, 31)`
  /// turns 31 January into 3 March and the budget quietly skips February.
  /// Someone whose budget starts on the 31st means the last day of the month.
  static DateTime _addMonths(DateTime from, int months) {
    // Count months from year zero so the arithmetic works in both directions.
    // Splitting the year and month separately gets the sign wrong for a
    // negative step: Dart's remainder is non-negative for a positive divisor,
    // so going back one month from January landed in the following December
    // rather than the previous one, and stepping to an earlier period walked
    // forward instead.
    final total = from.year * 12 + (from.month - 1) + months;
    final year = total ~/ 12;
    final month = (total % 12) + 1;

    // Day zero of the next month is the last day of this one.
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = from.day > lastDay ? lastDay : from.day;

    return DateTime(
      year,
      month,
      day,
      from.hour,
      from.minute,
      from.second,
      from.millisecond,
      from.microsecond,
    );
  }

  static final DateTime _farFuture = DateTime(9999, 12, 31);
}
