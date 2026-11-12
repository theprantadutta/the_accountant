import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';
import 'package:the_accountant/features/encryption/screens/passphrase_screen.dart';

import '../../helpers/localized_app.dart';

Widget _screen(KeyStatus status, {Locale locale = const Locale('en')}) =>
    ProviderScope(
      overrides: [keyStatusProvider.overrideWith((ref) async => status)],
      child: localizedApp(home: const PassphraseScreen(), locale: locale),
    );

const _off = KeyStatus(protected: false, unlockedHere: true);

void main() {
  testWidgets('before opting in, both sides and the catch are spelled out', (
    tester,
  ) async {
    await tester.pumpWidget(_screen(_off));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('pp_without')), findsOneWidget);
    expect(find.byKey(const Key('pp_with')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('pp_set')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pp_catch')), findsOneWidget);
    expect(find.textContaining('nobody can recover'), findsOneWidget);
  });

  testWidgets('nothing turns on until the user ticks that they understand', (
    tester,
  ) async {
    await tester.pumpWidget(_screen(_off));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('pp_set')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pp_set')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('pp_new_first')),
      'correct horse battery',
    );
    await tester.enterText(
      find.byKey(const Key('pp_new_second')),
      'correct horse battery',
    );
    await tester.pump();

    final submit = tester.widget<Widget>(
      find.byKey(const Key('pp_new_submit')),
    );
    expect((submit as dynamic).onPressed, isNull);

    await tester.tap(find.byKey(const Key('pp_consent')));
    await tester.pump();
    expect(
      (tester.widget<Widget>(find.byKey(const Key('pp_new_submit'))) as dynamic)
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('a short or mismatched passphrase is refused with a reason', (
    tester,
  ) async {
    await tester.pumpWidget(_screen(_off));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('pp_set')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pp_set')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pp_consent')));

    await tester.enterText(find.byKey(const Key('pp_new_first')), 'short');
    await tester.enterText(find.byKey(const Key('pp_new_second')), 'short');
    await tester.tap(find.byKey(const Key('pp_new_submit')));
    await tester.pump();
    expect(find.text('Use at least 10 characters.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('pp_new_first')),
      'long enough one',
    );
    await tester.enterText(
      find.byKey(const Key('pp_new_second')),
      'long enough two',
    );
    await tester.tap(find.byKey(const Key('pp_new_submit')));
    await tester.pump();
    expect(find.text("The two passphrases don't match."), findsOneWidget);
  });

  testWidgets('a protected account offers change, new code and turn off', (
    tester,
  ) async {
    await tester.pumpWidget(
      _screen(const KeyStatus(protected: true, unlockedHere: true)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('pp_change')), findsOneWidget);
    expect(find.byKey(const Key('pp_new_code')), findsOneWidget);
    expect(find.byKey(const Key('pp_turn_off')), findsOneWidget);
  });

  testWidgets('a new phone on a protected account is asked to unlock', (
    tester,
  ) async {
    await tester.pumpWidget(
      _screen(const KeyStatus(protected: true, unlockedHere: false)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pp_unlock')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pp_unlock_field')), findsOneWidget);

    await tester.tap(find.byKey(const Key('pp_unlock_switch')));
    await tester.pumpAndSettle();
    expect(find.text('Recovery code'), findsWidgets);
  });

  for (final locale in const [Locale('de'), Locale('fa'), Locale('bn')]) {
    testWidgets('the explainer lays out in ${locale.languageCode}', (
      tester,
    ) async {
      await tester.pumpWidget(_screen(_off, locale: locale));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
