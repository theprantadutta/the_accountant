import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/themes/app_theme.dart';

/// The app paints one shared gradient behind transparent scaffolds, so any
/// moment where the outgoing and incoming routes are both partly visible shows
/// the old screen straight through the new one. These tests pin the invariant
/// that makes that impossible: the two routes' opacities never overlap.

const Key _first = Key('first-route');
const Key _second = Key('second-route');

/// Effective opacity of the route containing [key] — the product of every
/// [FadeTransition] wrapping it, since the transition nests an exit fade
/// outside an enter fade.
double _opacityOf(WidgetTester tester, Key key) {
  if (tester.widgetList(find.byKey(key)).isEmpty) return 0.0;
  final fades = tester.widgetList<FadeTransition>(
    find.ancestor(of: find.byKey(key), matching: find.byType(FadeTransition)),
  );
  return fades.fold<double>(1.0, (acc, f) => acc * f.opacity.value);
}

Widget _app(TargetPlatform platform) {
  return MaterialApp(
    theme: AppTheme.darkTheme.copyWith(platform: platform),
    home: Builder(
      builder: (context) => Scaffold(
        key: _first,
        body: TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const Scaffold(key: _second, body: Text('two')),
            ),
          ),
          child: const Text('go'),
        ),
      ),
    ),
  );
}

void main() {
  for (final platform in <TargetPlatform>[
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.windows,
  ]) {
    testWidgets('routes never overlap while pushing on $platform', (
      tester,
    ) async {
      await tester.pumpWidget(_app(platform));
      await tester.tap(find.text('go'));

      var sawBothFullyHidden = false;
      for (
        var elapsed = Duration.zero;
        elapsed < const Duration(milliseconds: 400);
        elapsed += const Duration(milliseconds: 10)
      ) {
        await tester.pump(const Duration(milliseconds: 10));

        final outgoing = _opacityOf(tester, _first);
        final incoming = _opacityOf(tester, _second);

        expect(
          outgoing > 0.01 && incoming > 0.01,
          isFalse,
          reason:
              'both routes visible at $elapsed '
              '(outgoing=$outgoing, incoming=$incoming) — the old screen would '
              'show through the new one',
        );
        if (outgoing <= 0.01 && incoming <= 0.01) sawBothFullyHidden = true;
      }

      // The handoff lands on the shared background rather than cross-fading.
      expect(sawBothFullyHidden, isTrue);
      expect(_opacityOf(tester, _second), 1.0);
    });
  }

  testWidgets('routes never overlap while popping', (tester) async {
    await tester.pumpWidget(_app(TargetPlatform.android));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();

    for (
      var elapsed = Duration.zero;
      elapsed < const Duration(milliseconds: 400);
      elapsed += const Duration(milliseconds: 10)
    ) {
      await tester.pump(const Duration(milliseconds: 10));
      final popping = _opacityOf(tester, _second);
      final revealed = _opacityOf(tester, _first);
      expect(
        popping > 0.01 && revealed > 0.01,
        isFalse,
        reason:
            'both routes visible at $elapsed while popping '
            '(popping=$popping, revealed=$revealed)',
      );
    }

    expect(_opacityOf(tester, _first), 1.0);
  });
}
