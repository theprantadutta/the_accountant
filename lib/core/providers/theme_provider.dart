import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
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
  ThemeNotifier()
    : super(
        ThemeState(
          currentTheme: 'Dark',
          isPremiumTheme: false,
          availableThemes: ['Light', 'Dark'],
        ),
      );

  /// Set the current theme
  void setTheme(String themeName) {
    final isPremium = PremiumThemes.themeNames.contains(themeName);

    state = state.copyWith(currentTheme: themeName, isPremiumTheme: isPremium);
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
  }

  /// Get the ThemeData for the current theme
  ThemeData getCurrentTheme() {
    return AppTheme.getCurrentTheme(state.currentTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
