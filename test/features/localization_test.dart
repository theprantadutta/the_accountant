import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// The app can now be read in a language other than English.
///
/// Nothing here was scaffolded before: no localisation packages, no resource
/// files, no delegates, and every string written straight into the widget that
/// showed it. These tests hold the scaffolding, and the one trap in it — that
/// this project already has two different `MaterialLocalizations` types in
/// scope and needs delegates for both.

/// Build a tree the way the app does, and hand back a context inside it.
Widget _app({Locale? locale, required Widget child}) => MaterialApp(
  locale: locale,
  supportedLocales: L10n.supportedLocales,
  localeListResolutionCallback: AppLanguages.resolve,
  localizationsDelegates: const [
    L10n.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    ...material_ui.GlobalMaterialLocalizations.delegates,
  ],
  home: child,
);

void main() {
  group('resolving a string', () {
    testWidgets('English', (tester) async {
      late L10n l10n;
      await tester.pumpWidget(
        _app(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              l10n = L10n.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(l10n.actionCancel, 'Cancel');
      expect(l10n.navToday, 'Today');
    });

    testWidgets('Bangla', (tester) async {
      late L10n l10n;
      await tester.pumpWidget(
        _app(
          locale: const Locale('bn'),
          child: Builder(
            builder: (context) {
              l10n = L10n.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(l10n.actionCancel, 'বাতিল');
      expect(l10n.navToday, 'আজ');
    });

    testWidgets('a language we do not ship falls back to English', (
      tester,
    ) async {
      late L10n l10n;
      await tester.pumpWidget(
        _app(
          locale: const Locale('ja'),
          child: Builder(
            builder: (context) {
              l10n = L10n.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        l10n.actionCancel,
        'Cancel',
        reason: 'showing resource keys would be worse than showing English',
      );
    });
  });

  group('both sets of Material localizations resolve', () {
    // This project has two different MaterialLocalizations types in scope: the
    // one in package:flutter/material.dart, which the app is written against,
    // and the one material_ui declares, which arrives transitively through
    // shimmer 4. flutter_localizations cannot satisfy the second, so anything
    // from a migrated package that asks for localizations throws at runtime
    // unless material_ui's own delegates are registered too. The symptom turns
    // up far from the cause — a crash on long-pressing text, say — so it is
    // worth pinning here.
    testWidgets("Flutter's", (tester) async {
      late MaterialLocalizations found;
      await tester.pumpWidget(
        _app(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              found = MaterialLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(found.okButtonLabel, isNotEmpty);
    });

    testWidgets("material_ui's", (tester) async {
      late material_ui.MaterialLocalizations found;
      await tester.pumpWidget(
        _app(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              found = material_ui.MaterialLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(found.okButtonLabel, isNotEmpty);
    });

    // A language the app offers but Flutter or material_ui cannot draw its
    // own dialogs and pickers in fails only when one of them opens.
    for (final locale in L10n.supportedLocales) {
      testWidgets('both, and ours, in ${locale.languageCode}', (tester) async {
        late MaterialLocalizations flutters;
        late material_ui.MaterialLocalizations materialUis;
        late L10n ours;
        await tester.pumpWidget(
          _app(
            locale: locale,
            child: Builder(
              builder: (context) {
                flutters = MaterialLocalizations.of(context);
                materialUis = material_ui.MaterialLocalizations.of(context);
                ours = L10n.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(flutters.okButtonLabel, isNotEmpty);
        expect(materialUis.okButtonLabel, isNotEmpty);
        expect(ours.localeName, locale.languageCode);
        if (locale.languageCode != 'en') {
          expect(ours.navToday, isNot('Today'));
        }
      });
    }
  });

  group('every language ships every string', () {
    Map<String, dynamic> readArb(String name) {
      final raw = File('lib/l10n/$name').readAsStringSync();
      return jsonDecode(raw) as Map<String, dynamic>;
    }

    final english = readArb('app_en.arb');
    final wanted = english.keys.where((k) => !k.startsWith('@')).toSet();
    final others = [
      for (final f in Directory('lib/l10n').listSync())
        if (f is File &&
            f.path.endsWith('.arb') &&
            !f.path.endsWith('app_en.arb'))
          f.uri.pathSegments.last,
    ]..sort();

    // {name} and the subject of {name, plural, …}: what the code fills in.
    Set<String> placeholders(String s) => {
      for (final m in RegExp(
        r'\{\s*([A-Za-z_][A-Za-z0-9_]*)\s*[,}]',
      ).allMatches(s))
        m.group(1)!,
    };

    test('there are translations to check', () {
      expect(others, contains('app_bn.arb'));
      expect(others.length, greaterThanOrEqualTo(9));
    });

    for (final file in others) {
      group(file, () {
        final arb = readArb(file);
        final have = arb.keys.where((k) => !k.startsWith('@')).toSet();

        test('no gaps against English', () {
          expect(
            wanted.difference(have),
            isEmpty,
            reason:
                'a missing key silently falls back to English mid-sentence, '
                'which reads worse than either language on its own',
          );
        });

        test('nothing English does not have', () {
          expect(
            have.difference(wanted),
            isEmpty,
            reason: 'a translation with no English original is dead weight',
          );
        });

        test('the same placeholders as English', () {
          final wrong = [
            for (final k in wanted.intersection(have))
              if (!_sameSet(
                placeholders(english[k] as String),
                placeholders(arb[k] as String),
              ))
                k,
          ];
          expect(
            wrong,
            isEmpty,
            reason: 'a placeholder the code does not fill shows as {name}',
          );
        });

        test('actually translated', () {
          // Brand names, initialisms and loanwords read the same in most
          // languages; a whole file copied from English does not.
          final same = [
            for (final k in wanted.intersection(have))
              if (arb[k] == english[k]) k,
          ];
          expect(same.length, lessThan(wanted.length * .12), reason: '$same');
        });
      });
    }
  });

  test('no string is shipped that nothing shows', () {
    // A resource file full of strings no screen uses is not preparation, it is
    // clutter a reviewer has to guess about — and every one costs a translator
    // real effort for nothing. Vocabulary arrives with the screen that needs
    // it.
    final direct = RegExp(r'\bl10n[?!]?\.([A-Za-z0-9_]+)');
    // dart format may split the call over lines, so allow whitespace and a
    // trailing comma inside the parentheses.
    final viaOf = RegExp(
      r'L10n\.of\(\s*[A-Za-z_]+\s*,?\s*\)\.([A-Za-z0-9_]+)',
      dotAll: true,
    );

    final used = <String>{};
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('generated')) continue;
      final text = entity.readAsStringSync();
      for (final m in direct.allMatches(text)) {
        used.add(m.group(1)!);
      }
      for (final m in viaOf.allMatches(text)) {
        used.add(m.group(1)!);
      }
    }

    final declared =
        (jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
                as Map<String, dynamic>)
            .keys
            .where((k) => !k.startsWith('@'));

    expect(declared.where((k) => !used.contains(k)), isEmpty);
  });

  group('remembering the language', () {
    test('the list offers following the phone first', () {
      expect(AppLanguages.supported.first, isNull);
      expect(AppLanguages.labelFor(null), 'Match my phone');
    });

    test('each language is named in its own language', () {
      expect(AppLanguages.labelFor(const Locale('en')), 'English');
      expect(AppLanguages.labelFor(const Locale('bn')), 'বাংলা');
    });

    test('every offered language is one the app actually ships', () {
      for (final locale in AppLanguages.supported) {
        if (locale == null) continue;
        expect(
          L10n.supportedLocales.map((l) => l.languageCode),
          contains(locale.languageCode),
          reason: 'offering a language with no ARB file shows resource keys',
        );
      }
    });
  });
}

bool _sameSet(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);
