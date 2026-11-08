import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_wrapper.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// The intro holds still so an ordinary launch never starts an animation only
/// to cut it off, but a long wait, like a restore, must still come alive.
void main() {
  Future<void> pumpIntro(WidgetTester tester) => tester.pumpWidget(
    const MaterialApp(
      locale: Locale('en'),
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.localizationsDelegates,
      home: AuthLoadingScreen(),
    ),
  );

  double wordmarkOpacity(WidgetTester tester) => tester
      .widget<Opacity>(
        find
            .ancestor(
              of: find.text('The Accountant'),
              matching: find.byType(Opacity),
            )
            .first,
      )
      .opacity;

  testWidgets('it holds still through an ordinary launch', (tester) async {
    await pumpIntro(tester);
    await tester.pump(const Duration(milliseconds: 650));

    expect(wordmarkOpacity(tester), 0);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('it comes alive when the wait runs long', (tester) async {
    await pumpIntro(tester);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(wordmarkOpacity(tester), 1);
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('leaving before it starts leaves nothing behind', (tester) async {
    await pumpIntro(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
