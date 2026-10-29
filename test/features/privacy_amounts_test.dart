import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/privacy_provider.dart';
import 'package:the_accountant/shared/widgets/sensitive.dart';

import '../helpers/localized_app.dart';

/// Balances and totals start hidden, stay as the user leaves them, and a tap
/// on one shows them all unless that is turned off.
void main() {
  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Map<String, Object> saved = const {},
    VoidCallback? onCardTap,
  }) async {
    SharedPreferences.setMockInitialValues(saved);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(privacyProvider);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(
          home: Scaffold(
            body: Column(
              children: [
                GestureDetector(
                  onTap: onCardTap,
                  child: const Sensitive(child: Text('৳85,000')),
                ),
                PrivacyEyeButton(
                  key: const Key('eye'),
                  builder: (icon, tooltip, onTap) =>
                      IconButton(icon: Icon(icon), onPressed: onTap),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    return container;
  }

  bool blurred(WidgetTester tester) => find
      .ancestor(of: find.text('৳85,000'), matching: find.byType(ImageFiltered))
      .evaluate()
      .isNotEmpty;

  testWidgets('hidden on a first run', (tester) async {
    final c = await pump(tester);
    expect(c.read(amountsHiddenProvider), isTrue);
    expect(blurred(tester), isTrue);
    expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
  });

  testWidgets('the eye shows them, and the choice is kept', (tester) async {
    final c = await pump(tester);
    await tester.tap(find.byKey(const Key('eye')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(blurred(tester), isFalse);
    expect(c.read(amountsHiddenProvider), isFalse);
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    expect(prefs!.getBool(PrivacyNotifier.hideKey), isFalse);
  });

  testWidgets('a saved "show" is honoured', (tester) async {
    await pump(tester, saved: {PrivacyNotifier.hideKey: false});
    expect(blurred(tester), isFalse);
  });

  testWidgets('tapping a hidden amount shows it, not what is under it', (
    tester,
  ) async {
    var opened = 0;
    final c = await pump(tester, onCardTap: () => opened++);

    await tester.tap(find.text('৳85,000'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(c.read(amountsHiddenProvider), isFalse);
    expect(opened, 0);

    await tester.tap(find.text('৳85,000'));
    expect(opened, 1, reason: 'once shown, the card works as usual');
  });

  testWidgets('with tap-to-show off, the tap goes to the card', (tester) async {
    var opened = 0;
    final c = await pump(
      tester,
      saved: {PrivacyNotifier.tapKey: false},
      onCardTap: () => opened++,
    );

    await tester.tap(find.text('৳85,000'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(c.read(amountsHiddenProvider), isTrue);
    expect(opened, 1);
  });
}
