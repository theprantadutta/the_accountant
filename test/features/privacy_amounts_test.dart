import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/privacy_provider.dart';
import 'package:the_accountant/features/settings/widgets/privacy_sheets.dart';
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

  testWidgets('in a sentence, only the figures hide', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: localizedApp(
          home: const Scaffold(
            body: SensitiveText(
              'Paid ৳4,000 of ৳12,000',
              amounts: ['৳4,000', '৳12,000'],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    bool blurredText(String text) => find
        .ancestor(of: find.text(text), matching: find.byType(ImageFiltered))
        .evaluate()
        .isNotEmpty;
    expect(blurredText('৳4,000'), isTrue);
    expect(blurredText('৳12,000'), isTrue);
    expect(find.byType(ImageFiltered), findsNWidgets(2));

    await tester.tap(find.text('৳4,000'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.text('Paid ৳4,000 of ৳12,000'), findsOneWidget);
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

  group('when the app opens', () {
    Future<PrivacyState> opened(Map<String, Object> saved) async {
      SharedPreferences.setMockInitialValues(saved);
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(privacyProvider);
      await Future<void>.delayed(Duration.zero);
      return c.read(privacyProvider);
    }

    test('as left by default: hidden first, then as left', () async {
      expect((await opened({})).hideAmounts, isTrue);
      expect(
        (await opened({PrivacyNotifier.hideKey: false})).hideAmounts,
        isFalse,
      );
    });

    test('"hidden" and "shown" ignore how the eye was left', () async {
      expect(
        (await opened({
          PrivacyNotifier.startKey: 'hidden',
          PrivacyNotifier.hideKey: false,
        })).hideAmounts,
        isTrue,
      );
      expect(
        (await opened({
          PrivacyNotifier.startKey: 'shown',
          PrivacyNotifier.hideKey: true,
        })).hideAmounts,
        isFalse,
      );
    });

    test('choosing one applies it now and is kept', () async {
      SharedPreferences.setMockInitialValues({});
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(privacyProvider);
      await Future<void>.delayed(Duration.zero);

      await c.read(privacyProvider.notifier).setStart(PrivacyStart.shown);

      expect(c.read(privacyProvider).hideAmounts, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(PrivacyNotifier.startKey), 'shown');
    });
  });

  testWidgets('the new-feature note shows once', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final shown = <bool>[];
    await tester.pumpWidget(
      ProviderScope(
        child: localizedApp(
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: TextButton(
                onPressed: () async =>
                    shown.add(await PrivacyIntro.maybeShow(context, ref)),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('New: hide your balances'), findsOneWidget);
    await tester.tap(find.byKey(const Key('privacy_intro_ok')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(shown, [true, false]);
  });
}
