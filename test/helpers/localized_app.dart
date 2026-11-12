import 'package:material_ui/material_ui.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// A `MaterialApp` set up the way the real one is.
///
/// A widget test that builds its own bare `MaterialApp` has no `L10n` above the
/// screen under test, so every `L10n.of(context)` in that screen returns null
/// and the build throws — which reads as "the widget is missing" rather than
/// "the harness is". Tests that pump a real screen should use this.
///
/// It registers material_ui's delegates, as the app does: the app is written
/// against `package:material_ui`, whose `MaterialLocalizations` is a different
/// type from the deprecated one in `package:flutter/material.dart`.
MaterialApp localizedApp({
  required Widget home,
  Locale locale = const Locale('en'),
}) => MaterialApp(
  locale: locale,
  supportedLocales: L10n.supportedLocales,
  localizationsDelegates: const [
    L10n.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  home: home,
);
