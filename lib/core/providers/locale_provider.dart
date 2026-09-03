import 'dart:ui';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The languages the app ships translations for.
///
/// English and Bangla to start with. Adding a third means an ARB file and an
/// entry here; nothing else in the app has to know.
class AppLanguages {
  const AppLanguages._();

  /// Null means follow the phone, which is the default and what most people
  /// expect without being asked.
  static const List<Locale?> supported = [null, Locale('en'), Locale('bn')];

  static const Map<String, String> names = {'en': 'English', 'bn': 'বাংলা'};

  static String labelFor(Locale? locale) =>
      locale == null ? 'Match my phone' : (names[locale.languageCode] ?? '');

  /// The language to show, given what the phone asks for.
  ///
  /// Flutter's default is to fall back to the FIRST supported locale, and the
  /// generated list is in alphabetical order — so without this a phone set to
  /// French, or Spanish, or anything else the app does not ship, would come up
  /// in Bangla. English is the fallback because it is the language the strings
  /// are authored in and the one a missing translation resolves to anyway.
  static Locale resolve(List<Locale>? preferred, Iterable<Locale> supported) {
    final codes = {for (final locale in supported) locale.languageCode};
    for (final locale in preferred ?? const <Locale>[]) {
      if (codes.contains(locale.languageCode)) {
        return Locale(locale.languageCode);
      }
    }
    return const Locale('en');
  }
}

/// The language the user has chosen, or null to follow the phone.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _restore();
  }

  static const String _storageKey = 'selected_locale';

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved == null || saved.isEmpty) return;
      // A language this build no longer ships would leave the app showing
      // nothing but resource keys, so an unknown code falls back to the phone.
      if (!AppLanguages.names.containsKey(saved)) return;
      state = Locale(saved);
    } catch (_) {
      // A preferences store that will not open is not a reason to fail to
      // start; following the phone is a perfectly good answer.
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(_storageKey);
      } else {
        await prefs.setString(_storageKey, locale.languageCode);
      }
    } catch (_) {
      // Losing the preference is not worth interrupting the user for.
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>(
  (ref) => LocaleNotifier(),
);
