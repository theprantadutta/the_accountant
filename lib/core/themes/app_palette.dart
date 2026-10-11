import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';

/// Every colour the app draws with, as one swappable set.
///
/// The app was written against `AppColors.textMuted` and friends — 1,800-odd
/// references across 94 files, all of them compile-time constants naming dark
/// values. That is why the light theme existed on paper and could never be
/// selected: switching `ThemeData` changes nothing when the widgets do not read
/// from it.
///
/// Rewriting every call site to `Theme.of(context)` would be a very large
/// change for no gain — `Theme` has no slot for "glass border" — and would lose
/// the vocabulary the design is written in. Instead the names stay exactly as
/// they are and the *values behind them* become swappable: [AppColors] reads
/// through the palette that is current, and a theme change replaces it.
@immutable
class AppPalette {
  const AppPalette({
    required this.brightness,
    required this.primaryDark,
    required this.primarySurface,
    required this.primaryElevated,
    required this.primaryAccent,
    required this.primaryGlow,
    required this.primaryPressed,
    required this.neonCyan,
    required this.neonPurple,
    required this.neonPink,
    required this.neonBlue,
    required this.success,
    required this.successLight,
    required this.successDark,
    required this.error,
    required this.errorLight,
    required this.errorDark,
    required this.warning,
    required this.warningLight,
    required this.warningDark,
    required this.info,
    required this.infoLight,
    required this.infoDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.glassWhite,
    required this.glassBorder,
    required this.glassHighlight,
    required this.glassShadow,
    required this.divider,
    required this.backgroundGradient,
    required this.cardGradient,
    required this.glassGradient,
    required this.accentCardGradient,
    required this.successCardGradient,
    required this.errorCardGradient,
    required this.infoCardGradient,
    required this.warningCardGradient,
    required this.cyanCardGradient,
    required this.purpleCardGradient,
    this.sunrise,
  });

  /// Whether this palette is meant for a light or a dark surface.
  ///
  /// Read by the status-bar and navigation-bar overlay style, which the system
  /// draws and the palette cannot reach any other way.
  final Brightness brightness;

  final Color primaryDark;
  final Color primarySurface;
  final Color primaryElevated;
  final Color primaryAccent;
  final Color primaryGlow;
  final Color primaryPressed;

  final Color neonCyan;
  final Color neonPurple;
  final Color neonPink;
  final Color neonBlue;

  final Color success;
  final Color successLight;
  final Color successDark;
  final Color error;
  final Color errorLight;
  final Color errorDark;
  final Color warning;
  final Color warningLight;
  final Color warningDark;
  final Color info;
  final Color infoLight;
  final Color infoDark;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;

  final Color glassWhite;
  final Color glassBorder;
  final Color glassHighlight;
  final Color glassShadow;
  final Color divider;

  final LinearGradient backgroundGradient;
  final LinearGradient cardGradient;
  final LinearGradient glassGradient;
  final LinearGradient accentCardGradient;
  final LinearGradient successCardGradient;
  final LinearGradient errorCardGradient;
  final LinearGradient infoCardGradient;
  final LinearGradient warningCardGradient;
  final LinearGradient cyanCardGradient;
  final LinearGradient purpleCardGradient;

  bool get isDark => brightness == Brightness.dark;

  /// The Sunrise tokens this palette was derived from.
  ///
  /// Kept so `AppColors` can hand out the brand gradients of the accent in
  /// force, which have no slot of their own in the legacy vocabulary.
  final SunriseColors? sunrise;

  /// Sunrise Light in the default accent.
  static AppPalette get light => fromSunrise(SunriseColors.light);

  /// Sunrise Dark in the default accent.
  static AppPalette get dark => fromSunrise(SunriseColors.dark);

  static final Expando<AppPalette> _bySunrise = Expando('AppPalette');

  /// The legacy names, filled from the Sunrise tokens.
  ///
  /// Every `AppColors.*` call site in the app reads through this, so deriving
  /// it from the same tokens as the `ThemeData` is what makes the redesign,
  /// light/dark and the premium accents reach screens that have not been
  /// rebuilt yet. Cached per token set so [AppColors.usePalette] can compare by
  /// identity on every rebuild.
  static AppPalette fromSunrise(SunriseColors c) =>
      _bySunrise[c] ??= _derive(c);

  static AppPalette _derive(SunriseColors c) {
    final d = c.isDark;
    LinearGradient pair(Color a, Color b) => LinearGradient(
      colors: [a, b],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return AppPalette(
      brightness: c.brightness,
      sunrise: c,
      primaryDark: c.base,
      primarySurface: c.surface,
      primaryElevated: d ? const Color(0xFF2B1F19) : c.surface,
      primaryAccent: c.accent,
      primaryGlow: c.gradientStart,
      primaryPressed: c.accentText,
      neonCyan: c.gradientEnd,
      neonPurple: d ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
      neonPink: d ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
      neonBlue: d ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
      success: c.positive,
      successLight: d ? const Color(0xFF86EFAC) : const Color(0xFF22C55E),
      successDark: d ? const Color(0xFF22C55E) : const Color(0xFF15803D),
      error: c.negative,
      errorLight: d ? const Color(0xFFFDA4AF) : const Color(0xFFF43F5E),
      errorDark: d ? const Color(0xFFF43F5E) : const Color(0xFFBE123C),
      warning: d ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
      warningLight: d ? const Color(0xFFFCD34D) : const Color(0xFFD97706),
      warningDark: d ? const Color(0xFFF59E0B) : const Color(0xFF92400E),
      info: d ? const Color(0xFF38BDF8) : const Color(0xFF0369A1),
      infoLight: d ? const Color(0xFF7DD3FC) : const Color(0xFF0284C7),
      infoDark: d ? const Color(0xFF0EA5E9) : const Color(0xFF075985),
      textPrimary: c.ink,
      textSecondary: c.muted,
      textMuted: c.subtle,
      textInverse: c.base,
      glassWhite: d ? const Color(0x0FFFFFFF) : const Color(0xB3FFFFFF),
      glassBorder: c.tabBarBorder,
      glassHighlight: d ? const Color(0x1AFFFFFF) : const Color(0x0F2B1B12),
      glassShadow: d ? const Color(0x40000000) : const Color(0x1FC85A28),
      divider: c.divider,
      backgroundGradient: c.washTall,
      cardGradient: pair(c.surface, c.surface),
      glassGradient: pair(c.surface, c.surface),
      accentCardGradient: pair(c.tintOrange, c.tintPeach),
      successCardGradient: pair(c.tintGreen, c.tintGreen),
      errorCardGradient: pair(c.tintRose, c.tintRose),
      infoCardGradient: pair(c.tintSky, c.tintSky),
      warningCardGradient: pair(c.tintAmber, c.tintAmber),
      cyanCardGradient: pair(c.tintPeach, c.tintRose),
      purpleCardGradient: pair(c.tintViolet, c.tintViolet),
    );
  }

  static AppPalette of(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}
