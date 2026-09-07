import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/features/budgets/domain/budget_window.dart';

/// Where one window of a repeating budget starts and ends.
///
/// Windows used to be found by stepping from one start to the next, which is
/// fine until a month-end date has to be clamped. 31 January became 28
/// February, and the step after that was taken *from* the 28th: the anchor day
/// was lost and every later window drifted. Stepping back had the mirror
/// problem — 28 February gave 28 January, which precedes a budget that started
/// on the 31st, so the history navigator simply refused to move.
void main() {
  BudgetWindow monthly(DateTime start, DateTime moment) =>
      BudgetWindows.containing(
        start: start,
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: moment,
      );

  DateTime monthlyIndex(DateTime anchor, int index) =>
      BudgetWindows.startOfIndex(anchor, BudgetPeriod.monthly, 1, index);

  group('a month-end anchor', () {
    final anchor = DateTime(2026, 1, 31);

    test('comes back to its own day after a short month', () {
      // Stepping from the previous window's clamped value gave 28 March here,
      // and every window after it was wrong by the same three days.
      expect(monthlyIndex(anchor, 2), DateTime(2026, 3, 31));
    });

    test('survives a whole year of clamping', () {
      expect(monthlyIndex(anchor, 12), DateTime(2027, 1, 31));
    });

    test('is still clamped within the short month itself', () {
      final february = monthly(anchor, DateTime(2026, 2, 10));

      expect(february.start, DateTime(2026, 1, 31));
      expect(
        february.end,
        DateTime(2026, 2, 28),
        reason: 'clamping is a fact about February, and belongs to this one '
            'window rather than to every window after it',
      );
    });

    test('every indexed boundary opens the window it belongs to', () {
      for (var i = 0; i < 24; i++) {
        final start = monthlyIndex(anchor, i);
        expect(monthly(anchor, start).start, start);
      }
    });
  });

  group('walking through past windows', () {
    final anchor = DateTime(2026, 1, 31);

    test('stepping back from a clamped window reaches the real one', () {
      final march = BudgetWindows.relative(
        start: anchor,
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: DateTime(2026, 4, 1),
        offset: -1,
      );

      expect(
        march.start,
        DateTime(2026, 2, 28),
        reason: 'retreating from the clamped 28 February gave 28 January, '
            'which is before the budget started, so the navigator refused to '
            'move at all',
      );
    });

    test('back and forward again returns to where it started', () {
      final moment = DateTime(2026, 6, 15);
      final here = monthly(anchor, moment);

      final back = BudgetWindows.relative(
        start: anchor,
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: moment,
        offset: -3,
      );
      final returned = BudgetWindows.relative(
        start: anchor,
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: back.start,
        offset: 3,
      );

      expect(
        returned.start,
        here.start,
        reason: 'an index is reversible; a chain of clamped steps is not',
      );
    });

    test('never walks back past the budget itself', () {
      final first = BudgetWindows.relative(
        start: anchor,
        period: BudgetPeriod.monthly,
        periodLength: 1,
        moment: DateTime(2026, 2, 10),
        offset: -5,
      );

      expect(first.start, anchor);
    });
  });

  test('a budget that has not started reports its first window', () {
    final anchor = DateTime(2026, 6, 1);

    final window = monthly(anchor, DateTime(2026, 5, 1));

    expect(window.start, anchor);
    expect(window.end, DateTime(2026, 7, 1));
  });

  test('a custom budget is one fixed span', () {
    final window = BudgetWindows.containing(
      start: DateTime(2026),
      period: BudgetPeriod.custom,
      periodLength: 1,
      moment: DateTime(2026, 2),
      explicitEnd: DateTime(2026, 3),
    );

    expect(window.start, DateTime(2026));
    expect(window.end, DateTime(2026, 3));
  });

  test('fixed-length periods step by whole multiples', () {
    final anchor = DateTime(2026);

    expect(
      BudgetWindows.startOfIndex(anchor, BudgetPeriod.daily, 1, 7),
      anchor.add(const Duration(days: 7)),
    );
    expect(
      BudgetWindows.startOfIndex(anchor, BudgetPeriod.weekly, 1, 7),
      anchor.add(const Duration(days: 49)),
    );
    expect(
      BudgetWindows.startOfIndex(anchor, BudgetPeriod.biweekly, 1, 7),
      anchor.add(const Duration(days: 98)),
    );
  });
}
