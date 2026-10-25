import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/features/transactions/widgets/compact_date_time_picker.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// The form's date row keeps the day and the time on one line on a narrow
/// phone, shows the time as its parts, and opens the right picker from each.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pump(
    WidgetTester tester,
    DateTime value, {
    ValueChanged<DateTime>? onChanged,
    bool use24Hour = false,
  }) async {
    // A 360dp-wide phone, the narrowest the app is laid out for.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeFor(SunriseColors.light),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: use24Hour),
          child: child!,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: CompactDateTimePicker(
              selectedDateTime: value,
              onDateTimeChanged: onChanged ?? (_) {},
              accentColor: Colors.orange,
              dateFormat: 'MMM dd, yyyy',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the day and the time share one line', (tester) async {
    // Far enough back to need a year, the longest label there is.
    await pump(tester, DateTime(2024, 10, 17, 20, 5));

    expect(tester.takeException(), isNull);
    final day = tester.getRect(find.text('October 17, 2024'));
    final hour = tester.getRect(find.text('8'));
    expect(find.text('05'), findsOneWidget);
    expect(find.text('PM'), findsOneWidget);
    expect(hour.left, greaterThan(day.right));
    expect((hour.center.dy - day.center.dy).abs(), lessThan(4));
  });

  testWidgets('a recent day reads as a word', (tester) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await pump(tester, yesterday);
    expect(find.text('Yesterday'), findsOneWidget);
  });

  testWidgets('the month is written out, in the user\'s order', (tester) async {
    final now = DateTime.now();
    // Far enough from today not to read as a word, and this year.
    final day = DateTime(now.year, now.month == 6 ? 1 : 6, 15, 9);
    await pump(tester, day);
    expect(find.text(DateFormat('MMMM d').format(day)), findsOneWidget);
  });

  testWidgets('a 24-hour clock has no AM/PM box', (tester) async {
    await pump(tester, DateTime(2024, 10, 17, 20, 5), use24Hour: true);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('PM'), findsNothing);
  });

  testWidgets('the day opens the calendar and keeps the time', (tester) async {
    DateTime? changed;
    await pump(
      tester,
      DateTime(2024, 10, 17, 20, 5),
      onChanged: (d) => changed = d,
    );

    await tester.tap(find.byKey(const Key('date_button')));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(changed, DateTime(2024, 10, 15, 20, 5));
  });

  testWidgets('the time opens the clock', (tester) async {
    await pump(tester, DateTime(2024, 10, 17, 20, 5));

    await tester.tap(find.text('05'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
  });
}
