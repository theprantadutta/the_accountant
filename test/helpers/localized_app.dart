import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// A `MaterialApp` set up the way the real one is.
///
/// A widget test that builds its own bare `MaterialApp` has no `L10n` above the
/// screen under test, so every `L10n.of(context)` in that screen returns null
/// and the build throws — which reads as "the widget is missing" rather than
/// "the harness is". Tests that pump a real screen should use this.
///
/// It registers both sets of Material delegates for the same reason the app
/// does: `material_ui` declares its own `MaterialLocalizations`, a different
/// type from the one in `package:flutter/material.dart`, and
/// `flutter_localizations` cannot satisfy it.
MaterialApp localizedApp({
  required Widget home,
  Locale locale = const Locale('en'),
}) => MaterialApp(
  locale: locale,
  supportedLocales: L10n.supportedLocales,
  localizationsDelegates: const [
    L10n.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    ...material_ui.GlobalMaterialLocalizations.delegates,
  ],
  home: home,
);
