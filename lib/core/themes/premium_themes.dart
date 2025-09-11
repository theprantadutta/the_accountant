import 'package:flutter/material.dart';

class PremiumThemes {
  // Sapphire Theme
  static final sapphireTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0D1B2A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B263B),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1B263B),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
    ),
  );

  // Emerald Theme
  static final emeraldTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0A1F1A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B3A2A),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1B3A2A),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF4CAF50),
      foregroundColor: Colors.white,
    ),
  );

  // Ruby Theme
  static final rubyTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF44336),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF2A0A1A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3A1B2A),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF3A1B2A),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFF44336),
      foregroundColor: Colors.white,
    ),
  );

  // Amethyst Theme
  static final amethystTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9C27B0),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF1A0A2A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A1B3A),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2A1B3A),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9C27B0),
      foregroundColor: Colors.white,
    ),
  );

  // Midnight Theme
  static final midnightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF607D8B),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0A0F14),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF141E27),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF141E27),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF607D8B),
      foregroundColor: Colors.white,
    ),
  );

  // List of all premium themes
  static final List<ThemeData> allThemes = [
    sapphireTheme,
    emeraldTheme,
    rubyTheme,
    amethystTheme,
    midnightTheme,
  ];

  // Names of all premium themes
  static final List<String> themeNames = [
    'Sapphire',
    'Emerald',
    'Ruby',
    'Amethyst',
    'Midnight',
  ];

  // Map theme names to themes
  static final Map<String, ThemeData> themeMap = {
    'Sapphire': sapphireTheme,
    'Emerald': emeraldTheme,
    'Ruby': rubyTheme,
    'Amethyst': amethystTheme,
    'Midnight': midnightTheme,
  };
}
