import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_palette.dart';

export 'package:the_accountant/core/themes/app_palette.dart' show AppPalette;

/// The colour vocabulary the whole app is written in.
///
/// Every name here used to be a `static const` holding a dark value, which is
/// the reason the light theme could be defined and never selected: the widgets
/// read these constants rather than `Theme.of(context)`, so changing the
/// `ThemeData` changed nothing anybody could see.
///
/// The names are unchanged and the 1,800-odd call sites are untouched. What
/// changed is that each one now reads through [palette], so swapping the
/// palette repaints the app.
///
/// **Read these in `build`, not in `initState`.** A colour captured once in a
/// field will not follow a theme change. That is the one rule this indirection
/// asks for, and it is what the whole codebase already did anyway.
class AppColors {
  AppColors._();

  static AppPalette _palette = AppPalette.dark;

  /// The set currently in force.
  static AppPalette get palette => _palette;

  /// Switch to [next], returning whether anything actually changed.
  ///
  /// The caller uses the answer to decide whether a repaint is needed; setting
  /// the same palette twice — which happens on every rebuild — must not cost a
  /// full-tree rebuild.
  static bool usePalette(AppPalette next) {
    if (identical(_palette, next)) return false;
    _palette = next;
    return true;
  }

  // ============================================
  // PRIMARY PALETTE
  // ============================================

  /// Main background.
  static Color get primaryDark => _palette.primaryDark;

  /// Card and surface backgrounds.
  static Color get primarySurface => _palette.primarySurface;

  /// Elevated surface (modals, dialogs).
  static Color get primaryElevated => _palette.primaryElevated;

  /// Main accent colour.
  static Color get primaryAccent => _palette.primaryAccent;

  /// Lighter accent for glows and highlights.
  static Color get primaryGlow => _palette.primaryGlow;

  /// Darker accent for pressed states.
  static Color get primaryPressed => _palette.primaryPressed;

  // ============================================
  // SECONDARY PALETTE
  // ============================================

  static Color get neonCyan => _palette.neonCyan;
  static Color get neonPurple => _palette.neonPurple;
  static Color get neonPink => _palette.neonPink;
  static Color get neonBlue => _palette.neonBlue;

  // ============================================
  // SEMANTIC COLORS
  // ============================================

  /// Success and income.
  static Color get success => _palette.success;
  static Color get successLight => _palette.successLight;
  static Color get successDark => _palette.successDark;

  /// Error and expense.
  static Color get error => _palette.error;
  static Color get errorLight => _palette.errorLight;
  static Color get errorDark => _palette.errorDark;

  static Color get warning => _palette.warning;
  static Color get warningLight => _palette.warningLight;
  static Color get warningDark => _palette.warningDark;

  static Color get info => _palette.info;
  static Color get infoLight => _palette.infoLight;
  static Color get infoDark => _palette.infoDark;

  // ============================================
  // TEXT COLORS
  // ============================================

  static Color get textPrimary => _palette.textPrimary;
  static Color get textSecondary => _palette.textSecondary;
  static Color get textMuted => _palette.textMuted;

  /// Text for a surface of the opposite brightness.
  static Color get textInverse => _palette.textInverse;

  // ============================================
  // GLASS/SURFACE COLORS
  // ============================================

  static Color get glassWhite => _palette.glassWhite;
  static Color get glassBorder => _palette.glassBorder;
  static Color get glassHighlight => _palette.glassHighlight;
  static Color get glassShadow => _palette.glassShadow;
  static Color get divider => _palette.divider;

  // ============================================
  // GRADIENTS
  // ============================================

  /// Brand gradients do not change with the theme.
  ///
  /// They are the identity of the app rather than part of its surface, and they
  /// are always drawn behind white text, so they read the same either way.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Surface gradients, which do.
  static LinearGradient get backgroundGradient => _palette.backgroundGradient;
  static LinearGradient get cardGradient => _palette.cardGradient;
  static LinearGradient get glassGradient => _palette.glassGradient;
  static LinearGradient get accentCardGradient => _palette.accentCardGradient;
  static LinearGradient get successCardGradient => _palette.successCardGradient;
  static LinearGradient get errorCardGradient => _palette.errorCardGradient;
  static LinearGradient get infoCardGradient => _palette.infoCardGradient;
  static LinearGradient get warningCardGradient => _palette.warningCardGradient;
  static LinearGradient get cyanCardGradient => _palette.cyanCardGradient;
  static LinearGradient get purpleCardGradient => _palette.purpleCardGradient;

  // ============================================
  // CATEGORY COLORS (for transactions)
  // ============================================

  /// Fixed in both themes.
  ///
  /// A category's colour is the user's data, not decoration: it is stored
  /// against the row, shown in charts beside its own legend, and recognised by
  /// sight. Shifting it when the theme changes would make the same category
  /// look like a different one.
  static const List<Color> categoryColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
    Color(0xFF84CC16), // Lime
    Color(0xFFF97316), // Orange
  ];

  /// Get category color by index (cycles through)
  static Color getCategoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Create a color with custom opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Lighten a color by percentage (0.0 - 1.0)
  static Color lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken a color by percentage (0.0 - 1.0)
  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
