import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';
import 'package:the_accountant/features/encryption/screens/passphrase_screen.dart';
import 'package:the_accountant/features/encryption/widgets/encryption_intro.dart';

import '../../helpers/localized_app.dart';

/// A screen with one button that asks for the intro, like Today does.
class _Host extends ConsumerWidget {
  const _Host();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: Center(
      child: TextButton(
        key: const Key('open'),
        onPressed: () => EncryptionIntro.maybeShow(context, ref),
        child: const Text('open'),
      ),
    ),
  );
}

Widget _app() => ProviderScope(
  overrides: [
    keyStatusProvider.overrideWith(
      (ref) async => const KeyStatus(protected: false, unlockedHere: true),
    ),
  ],
  child: localizedApp(home: const _Host()),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('it explains the change and offers the passphrase', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();

    expect(find.text('Your data is now encrypted'), findsOneWidget);
    expect(find.textContaining('optional'), findsOneWidget);
    expect(find.byKey(const Key('encryption_intro_set_up')), findsOneWidget);
    expect(find.byKey(const Key('encryption_intro_not_now')), findsOneWidget);
  });

  testWidgets('"Not now" changes nothing and it never shows again', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('encryption_intro_not_now')));
    await tester.pumpAndSettle();

    expect(find.byType(PassphraseScreen), findsNothing);

    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
    expect(find.text('Your data is now encrypted'), findsNothing);
  });

  testWidgets('"Set a passphrase" opens the screen that asks for consent', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('encryption_intro_set_up')));
    await tester.pumpAndSettle();

    expect(find.byType(PassphraseScreen), findsOneWidget);
    // Nothing is turned on here: the screen explains first and asks.
    expect(find.byKey(const Key('pp_set')), findsOneWidget);
  });
}
