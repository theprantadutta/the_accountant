import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// The app's strings, in the user's language, for code with no widget tree:
/// services, providers and exceptions whose messages reach the screen.
///
/// Inside a widget use `L10n.of(context)` as usual. Out here the language is
/// whatever the app last resolved ([AppL10n.update], called from the
/// MaterialApp builder), or, before that and in background isolates, the one
/// chosen in settings, or the phone's.
L10n get appL10n => AppL10n.current;

class AppL10n {
  const AppL10n._();

  static Locale? _locale;

  /// Records the locale the app is showing. Called on every app build, so a
  /// language change in settings is picked up at once.
  static void update(Locale locale) => _locale = locale;

  static L10n get current => lookupL10n(_locale ?? _fallback());

  /// The phone's language, resolved the same way the app resolves it.
  static Locale _fallback() => AppLanguages.resolve(
    PlatformDispatcher.instance.locales,
    L10n.supportedLocales,
  );

  /// For background isolates, where the app never built: reads the saved
  /// choice once.
  static Future<void> loadSaved() async {
    if (_locale != null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final chosen = prefs.getString(LocaleNotifier.storageKey);
      if (chosen != null && AppLanguages.names.containsKey(chosen)) {
        _locale = Locale(chosen);
      }
    } catch (_) {
      // The phone's language is a fine answer.
    }
  }
}
