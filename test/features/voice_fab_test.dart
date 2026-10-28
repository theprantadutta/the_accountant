import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/features/voice_log/providers/voice_fab_provider.dart';
import 'package:the_accountant/features/voice_log/widgets/voice_fab.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// The floating mic is off until the user says yes, the question is asked
/// once whatever the answer, and where it was left is remembered.
void main() {
  Future<ProviderContainer> loaded([
    Map<String, Object> saved = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(saved);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(voiceFabProvider);
    await Future<void>.delayed(Duration.zero);
    return container;
  }

  test('off and not yet asked on a new install', () async {
    final fab = (await loaded()).read(voiceFabProvider);
    expect((fab.loaded, fab.enabled, fab.asked), (true, false, false));
  });

  test('turning it on or off also counts as the answer', () async {
    final container = await loaded();
    await container.read(voiceFabProvider.notifier).setEnabled(true);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(VoiceFabNotifier.enabledKey), isTrue);
    expect(prefs.getBool(VoiceFabNotifier.askedKey), isTrue);

    final again = await loaded({
      VoiceFabNotifier.enabledKey: true,
      VoiceFabNotifier.askedKey: true,
    });
    expect(again.read(voiceFabProvider).enabled, isTrue);
  });

  test('where it was dropped is remembered, kept on screen', () async {
    final container = await loaded();
    await container
        .read(voiceFabProvider.notifier)
        .moveTo(onLeft: true, height: 1.4);

    final fab = container.read(voiceFabProvider);
    expect((fab.onLeft, fab.height), (true, 1.0));
  });

  Future<ProviderContainer> ask(WidgetTester tester, String button) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.themeFor(SunriseColors.light),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: TextButton(
                onPressed: () => askAboutVoiceFab(context, ref),
                child: const Text('ask'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ask'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Add a mic to your Today screen?'), findsOneWidget);
    await tester.tap(find.byKey(Key(button)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    return container;
  }

  testWidgets('yes turns the floating mic on', (tester) async {
    final container = await ask(tester, 'voice_fab_yes');
    final fab = container.read(voiceFabProvider);
    expect((fab.enabled, fab.asked), (true, true));
  });

  testWidgets('not now leaves it off and is not asked again', (tester) async {
    final container = await ask(tester, 'voice_fab_no');
    final fab = container.read(voiceFabProvider);
    expect((fab.enabled, fab.asked), (false, true));
  });
}
