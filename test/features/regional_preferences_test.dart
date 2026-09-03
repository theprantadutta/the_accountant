import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/regional_preferences.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';

/// The three regional settings that had no home.
///
/// Every amount in the app put the currency symbol in front, every clock was a
/// 12-hour clock, and a week always began on Monday — none of which was a
/// decision, and none of which could be changed. These are the rules that
/// replace those assumptions.
void main() {
  tearDown(RegionalPreferences.reset);

  group('where the currency symbol goes', () {
    test('in front, which is what it always used to do', () {
      RegionalPreferences.symbolPosition = SymbolPosition.before;

      expect(123456.formatCurrency('USD'), r'$1,234.56');
    });

    test('after, for the half of Europe that writes it that way', () {
      RegionalPreferences.symbolPosition = SymbolPosition.after;

      expect(123456.formatCurrency('EUR'), '1,234.56 €');
    });

    test('a trailing symbol is joined by a space that will not wrap', () {
      RegionalPreferences.symbolPosition = SymbolPosition.after;

      expect(
        123456.formatCurrency('EUR'),
        contains(' '),
        reason:
            'an amount that wraps between the number and its currency is worse '
            'than no space at all',
      );
      expect(123456.formatCurrency('EUR'), isNot(contains(' €')));
    });

    test('the sign stays in front of the whole thing', () {
      RegionalPreferences.symbolPosition = SymbolPosition.after;

      expect(
        123456.formatCurrencyWithSign('EUR', isIncome: false),
        startsWith('-'),
      );
      expect(
        123456.formatCurrencyWithSign('EUR', isIncome: true),
        startsWith('+'),
      );
    });

    test('the compact form follows the setting too', () {
      RegionalPreferences.symbolPosition = SymbolPosition.after;

      expect(
        150000000.formatCurrencyCompact('EUR'),
        '1.5M €',
        reason: 'the abbreviation belongs to the number, not to the symbol',
      );
    });

    test('the whole-number form follows it as well', () {
      RegionalPreferences.symbolPosition = SymbolPosition.after;

      expect(123456.formatCurrencyWhole('EUR'), '1,235 €');
    });

    test('an explicit position overrides the ambient one', () {
      RegionalPreferences.symbolPosition = SymbolPosition.after;

      expect(
        123456.formatCurrency('USD', symbolPosition: SymbolPosition.before),
        r'$1,234.56',
        reason: 'a caller with a reason to differ can still say so',
      );
    });

    test('an unreadable stored value falls back to the old behaviour', () {
      expect(SymbolPosition.fromStored('sideways'), SymbolPosition.before);
      expect(SymbolPosition.fromStored(null), SymbolPosition.before);
    });
  });

  group('which clock to draw', () {
    test('an explicit choice ignores the phone', () {
      expect(
        TimeFormatChoice.twentyFourHour.resolve(platformUses24Hour: false),
        isTrue,
      );
      expect(
        TimeFormatChoice.twelveHour.resolve(platformUses24Hour: true),
        isFalse,
      );
    });

    test('the default follows it', () {
      expect(TimeFormatChoice.system.resolve(platformUses24Hour: true), isTrue);
      expect(
        TimeFormatChoice.system.resolve(platformUses24Hour: false),
        isFalse,
      );
    });

    test('afternoon reads differently on each', () {
      final afternoon = DateTime(2026, 3, 4, 13, 30);

      expect(AppTimeFormatter.formatTime(afternoon, use24Hour: true), '13:30');
      expect(
        AppTimeFormatter.formatTime(afternoon, use24Hour: false),
        '1:30 PM',
      );
    });

    test('midnight is not written as 0 AM', () {
      final midnight = DateTime(2026, 3, 4, 0, 5);

      expect(AppTimeFormatter.formatTime(midnight, use24Hour: true), '00:05');
      expect(
        AppTimeFormatter.formatTime(midnight, use24Hour: false),
        '12:05 AM',
      );
    });

    test('a TimeOfDay formats the same way', () {
      expect(
        AppTimeFormatter.formatTimeOfDay(
          const TimeOfDay(hour: 19, minute: 0),
          use24Hour: true,
        ),
        '19:00',
      );
    });

    test('an unreadable stored value means follow the phone', () {
      expect(TimeFormatChoice.fromStored('sundial'), TimeFormatChoice.system);
    });
  });

  group('when a week starts', () {
    // A Wednesday.
    final wednesday = DateTime(2026, 3, 4);

    test('Monday', () {
      expect(
        FirstDayOfWeek.startOfWeek(wednesday, DateTime.monday),
        DateTime(2026, 3, 2),
      );
    });

    test('Sunday', () {
      expect(
        FirstDayOfWeek.startOfWeek(wednesday, DateTime.sunday),
        DateTime(2026, 3, 1),
      );
    });

    test('Saturday, which is the working week in much of the world', () {
      expect(
        FirstDayOfWeek.startOfWeek(wednesday, DateTime.saturday),
        DateTime(2026, 2, 28),
      );
    });

    test('the start day is its own week start, not the one before', () {
      final monday = DateTime(2026, 3, 2);

      expect(FirstDayOfWeek.startOfWeek(monday, DateTime.monday), monday);
    });

    test('the time of day is dropped', () {
      expect(
        FirstDayOfWeek.startOfWeek(
          DateTime(2026, 3, 4, 23, 59, 59),
          DateTime.monday,
        ),
        DateTime(2026, 3, 2),
      );
    });

    test('following the phone still gives a usable answer', () {
      expect(
        FirstDayOfWeek.startOfWeek(wednesday, FirstDayOfWeek.followLocale),
        DateTime(2026, 3, 2),
      );
    });

    test('the calendar index uses the other convention, converted once', () {
      // DateTime counts Monday as 1; Material counts Sunday as 0.
      expect(FirstDayOfWeek.materialIndex(DateTime.sunday), 0);
      expect(FirstDayOfWeek.materialIndex(DateTime.monday), 1);
      expect(FirstDayOfWeek.materialIndex(DateTime.saturday), 6);
      expect(
        FirstDayOfWeek.materialIndex(FirstDayOfWeek.followLocale),
        isNull,
        reason: 'null is how Flutter is told to use the locale default',
      );
    });
  });

  group('applying them', () {
    test('a change is reported so the caller can repaint', () {
      expect(
        RegionalPreferences.apply(
          symbol: SymbolPosition.after,
          time: TimeFormatChoice.twentyFourHour,
          weekStart: DateTime.sunday,
        ),
        isTrue,
      );
      expect(RegionalPreferences.symbolPosition, SymbolPosition.after);
    });

    test('applying the same thing again is not a change', () {
      RegionalPreferences.apply(
        symbol: SymbolPosition.after,
        time: TimeFormatChoice.system,
        weekStart: DateTime.sunday,
      );

      expect(
        RegionalPreferences.apply(
          symbol: SymbolPosition.after,
          time: TimeFormatChoice.system,
          weekStart: DateTime.sunday,
        ),
        isFalse,
        reason: 'this runs on every rebuild',
      );
    });
  });
}
