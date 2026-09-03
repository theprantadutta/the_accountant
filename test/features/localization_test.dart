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

      expect(l10n.actionSave, 'Save');
      expect(l10n.moneyIncome, 'Income');
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

      expect(l10n.actionSave, 'সংরক্ষণ');
      expect(l10n.moneyIncome, 'আয়');
    });

    testWidgets('a language we do not ship falls back to English', (
      tester,
    ) async {
      late L10n l10n;
      await tester.pumpWidget(
        _app(
          locale: const Locale('fr'),
          child: Builder(
            builder: (context) {
              l10n = L10n.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        l10n.actionSave,
        'Save',
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
  });

  group('every language ships every string', () {
    Map<String, dynamic> readArb(String name) {
      final raw = File('lib/l10n/$name').readAsStringSync();
      return jsonDecode(raw) as Map<String, dynamic>;
    }

    test('Bangla has no gaps against English', () {
      final english = readArb('app_en.arb');
      final bangla = readArb('app_bn.arb');

      // Keys beginning with @ are metadata about a string, not a string.
      final wanted = english.keys.where((k) => !k.startsWith('@')).toSet();
      final have = bangla.keys.where((k) => !k.startsWith('@')).toSet();

      expect(
        wanted.difference(have),
        isEmpty,
        reason:
            'a missing key silently falls back to English mid-sentence, which '
            'reads worse than either language on its own',
      );
    });

    test('Bangla has nothing English does not', () {
      final english = readArb('app_en.arb');
      final bangla = readArb('app_bn.arb');

      final wanted = english.keys.where((k) => !k.startsWith('@')).toSet();
      final have = bangla.keys.where((k) => !k.startsWith('@')).toSet();

      expect(
        have.difference(wanted),
        isEmpty,
        reason: 'a translation with no English original is dead weight',
      );
    });

    test('nothing is left untranslated by accident', () {
      final english = readArb('app_en.arb');
      final bangla = readArb('app_bn.arb');

      // A handful are the same in both by design: a brand name, and the two
      // language names, which are always written in their own language.
      const sameByDesign = {
        'appTitle',
        'languageEnglish',
        'entityBudget',
        'entityTransaction',
      };

      final untranslated = [
        for (final key in english.keys)
          if (!key.startsWith('@') &&
              !sameByDesign.contains(key) &&
              bangla[key] == english[key])
            key,
      ];

      expect(untranslated, isEmpty);
    });
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
