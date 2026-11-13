import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

import '../helpers/localized_app.dart';

/// A sheet's content has to survive the keyboard coming and going.
///
/// SunriseBottomSheet used to move its child under a different parent when
/// the keyboard rose, which rebuilt it from scratch. In the add-account form
/// that reset what had been picked, and the icon picker opened from it kept
/// the dead form's context and crashed on `L10n.of` (Crashlytics, 5.2.2).
void main() {
  Widget sheet({required double keyboard, String? title}) => localizedApp(
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(viewInsets: EdgeInsets.only(bottom: keyboard)),
        // Not a Scaffold: it hides the keyboard inset from its body, and a
        // sheet is a route of its own that sees it.
        child: Material(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SunriseBottomSheet(title: title, child: const _Counter()),
          ),
        ),
      ),
    ),
  );

  for (final title in [null, 'Add account']) {
    testWidgets('keeps its child as the keyboard rises and falls '
        '(title: $title)', (tester) async {
      await tester.pumpWidget(sheet(keyboard: 0, title: title));
      final before = tester.state<_CounterState>(find.byType(_Counter));
      await tester.tap(find.text('0'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await tester.pumpWidget(sheet(keyboard: 300, title: title));
      expect(tester.state(find.byType(_Counter)), same(before));
      expect(find.text('1'), findsOneWidget);

      await tester.pumpWidget(sheet(keyboard: 0, title: title));
      expect(tester.state(find.byType(_Counter)), same(before));
      expect(before.mounted, isTrue);
      expect(find.text('1'), findsOneWidget);
    });
  }
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int taps = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => taps++),
    child: Text('$taps'),
  );
}
