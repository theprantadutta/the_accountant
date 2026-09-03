import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/premium_themes.dart';

/// The three themes everybody has, before any subscription.
class BaseThemes {
  const BaseThemes._();

  /// Follow whatever the phone is set to.
  static const String system = 'System';
  static const String light = 'Light';
  static const String dark = 'Dark';

  static const List<String> all = [system, light, dark];
}

class ThemeState {
  final String currentTheme;
  final bool isPremiumTheme;
  final List<String> availableThemes;

  ThemeState({
    required this.currentTheme,
    required this.isPremiumTheme,
    required this.availableThemes,
  });

  /// Which colours to draw with, given what the phone is currently set to.
  ///
  /// [platformBrightness] only matters for [BaseThemes.system]; the other
  /// choices are an instruction to ignore it.
  AppPalette paletteFor(Brightness platformBrightness) {
    switch (currentTheme) {
      case BaseThemes.system:
        return AppPalette.of(platformBrightness);
      case BaseThemes.light:
        return AppPalette.light;
      default:
        // Every premium theme is a dark theme, so anything unrecognised —
        // including a saved name from a build that had more of them — is dark.
        return AppPalette.dark;
    }
  }

  /// What to hand `MaterialApp.themeMode`.
  ThemeMode get themeMode => switch (currentTheme) {
    BaseThemes.system => ThemeMode.system,
    BaseThemes.light => ThemeMode.light,
    _ => ThemeMode.dark,
  };

  ThemeState copyWith({
    String? currentTheme,
    bool? isPremiumTheme,
    List<String>? availableThemes,
  }) {
    return ThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
      isPremiumTheme: isPremiumTheme ?? this.isPremiumTheme,
      availableThemes: availableThemes ?? this.availableThemes,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  /// Where the chosen theme is remembered between launches.
  static const String _storageKey = 'selected_theme';

  /// Dark, not System, is the default on purpose.
  ///
  /// The app has always been dark and every existing install is looking at it
  /// now. Defaulting to System would turn the app light for anybody whose phone
  /// is, without their having asked for anything — a worse surprise than the
  /// mild unfashionability of not following the system out of the box. System
  /// is the first option in the picker.
  ThemeNotifier()
    : super(
        ThemeState(
          currentTheme: BaseThemes.dark,
          isPremiumTheme: false,
          availableThemes: BaseThemes.all,
        ),
      ) {
    _restore();
  }

  /// Reload the theme the user last chose.
  ///
  /// Nothing was ever written or read before, so every launch reset to Dark and
  /// picking a theme lasted exactly as long as the session. That is also why
  /// the picker was worth hiding: a setting that forgets itself is worse than
  /// no setting.
  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved == null || saved == state.currentTheme) return;
      // A premium theme saved before the subscription lapsed must not come
      // back; lockPremiumThemes has already narrowed what is available.
      if (!state.availableThemes.contains(saved) &&
          !PremiumThemes.themeNames.contains(saved)) {
        return;
      }
      state = state.copyWith(
        currentTheme: saved,
        isPremiumTheme: PremiumThemes.themeNames.contains(saved),
      );
    } catch (_) {
      // A store that will not open is not a reason to fail to start; the
      // default theme is a perfectly good answer.
    }
  }

  /// Set the current theme
  void setTheme(String themeName) {
    final isPremium = PremiumThemes.themeNames.contains(themeName);

    AnalyticsService().logThemeChange();
    state = state.copyWith(currentTheme: themeName, isPremiumTheme: isPremium);
    _persist(themeName);
  }

  Future<void> _persist(String themeName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, themeName);
    } catch (_) {
      // Losing the preference is not worth interrupting the user for.
    }
  }

  /// Unlock premium themes
  void unlockPremiumThemes() {
    state = state.copyWith(
      availableThemes: [...BaseThemes.all, ...PremiumThemes.themeNames],
    );
  }

  /// Lock premium themes
  void lockPremiumThemes() {
    state = state.copyWith(
      availableThemes: BaseThemes.all,
      currentTheme: BaseThemes.all.contains(state.currentTheme)
          ? state.currentTheme
          : BaseThemes.dark,
      isPremiumTheme: false,
    );
    // Persist the fallback too, or the next launch restores a theme the user
    // is no longer entitled to.
    _persist(state.currentTheme);
  }

  /// Get the ThemeData for the current theme
  ThemeData getCurrentTheme() {
    return AppTheme.getCurrentTheme(state.currentTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
