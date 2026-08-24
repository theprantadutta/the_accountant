import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/shared/widgets/stat_card.dart';

/// Amounts on the dashboard tiles must stay readable.
///
/// The tile used to elide the value, and the branch that produced the *longest*
/// string was the one for the smallest numbers: 3,289.99 rendered as "3.3K"
/// (four characters) while 249.39 rendered as "249.39" (six) and clipped to
/// "249.…". So the Income tile fitted and the Expenses tile beside it did not,
/// with the larger figure being the one that fitted.
///
/// An elided amount is worse than a rounded one — it still looks like a precise
/// figure, so there is nothing to tell the reader that digits are missing.
void main() {
  Future<void> pumpCard(WidgetTester tester, double value) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            // Roughly the half-width the dashboard gives each tile.
            width: 180,
            child: StatCard(
              label: 'Expenses',
              value: value,
              prefix: r'$',
              animateValue: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('a sub-thousand amount keeps every digit', (tester) async {
    await pumpCard(tester, 249.39);

    expect(find.text('249.39'), findsOneWidget);
    expect(
      find.textContaining('…'),
      findsNothing,
      reason: 'a truncated amount reads as an exact one',
    );
  });

  testWidgets('thousands still shorten to K', (tester) async {
    await pumpCard(tester, 3289.99);
    expect(find.text('3.3K'), findsOneWidget);
  });

  testWidgets('millions still shorten to M', (tester) async {
    await pumpCard(tester, 2450000);
    expect(find.text('2.5M'), findsOneWidget);
  });

  testWidgets('a whole number shows no decimals', (tester) async {
    await pumpCard(tester, 249);
    expect(find.text('249'), findsOneWidget);
  });

  testWidgets('a narrow tile shrinks the amount rather than clipping it', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            child: StatCard(
              label: 'Expenses',
              value: 987654.32,
              prefix: r'$',
              animateValue: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('987.7K'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
