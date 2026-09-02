import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/premium_themes.dart';

class ThemeState {
  final String currentTheme;
  final bool isPremiumTheme;
  final List<String> availableThemes;

  ThemeState({
    required this.currentTheme,
    required this.isPremiumTheme,
    required this.availableThemes,
  });

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

  ThemeNotifier()
    : super(
        ThemeState(
          currentTheme: 'Dark',
          isPremiumTheme: false,
          availableThemes: ['Light', 'Dark'],
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
      availableThemes: ['Light', 'Dark', ...PremiumThemes.themeNames],
    );
  }

  /// Lock premium themes
  void lockPremiumThemes() {
    state = state.copyWith(
      availableThemes: ['Light', 'Dark'],
      currentTheme:
          state.currentTheme == 'Light' || state.currentTheme == 'Dark'
          ? state.currentTheme
          : 'Dark',
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
