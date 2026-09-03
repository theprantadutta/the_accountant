import 'package:flutter/material.dart';

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

  // ---------------------------------------------------------------- dark

  /// The original palette, value for value.
  ///
  /// Nothing here is new. It is the set the whole app was designed against,
  /// lifted out of the constants it used to live in, so that the light set
  /// below can be its peer rather than an afterthought.
  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    primaryDark: Color(0xFF0D0D1A),
    primarySurface: Color(0xFF1A1A2E),
    primaryElevated: Color(0xFF252542),
    primaryAccent: Color(0xFF6366F1),
    primaryGlow: Color(0xFF818CF8),
    primaryPressed: Color(0xFF4F46E5),
    neonCyan: Color(0xFF22D3EE),
    neonPurple: Color(0xFFA855F7),
    neonPink: Color(0xFFEC4899),
    neonBlue: Color(0xFF3B82F6),
    success: Color(0xFF10B981),
    successLight: Color(0xFF34D399),
    successDark: Color(0xFF059669),
    error: Color(0xFFEF4444),
    errorLight: Color(0xFFF87171),
    errorDark: Color(0xFFDC2626),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFFFBBF24),
    warningDark: Color(0xFFD97706),
    info: Color(0xFF3B82F6),
    infoLight: Color(0xFF60A5FA),
    infoDark: Color(0xFF2563EB),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    textInverse: Color(0xFF0F172A),
    glassWhite: Color(0x0DFFFFFF),
    glassBorder: Color(0x306366F1),
    glassHighlight: Color(0x33FFFFFF),
    glassShadow: Color(0x40000000),
    divider: Color(0xFF2D2D44),
    backgroundGradient: LinearGradient(
      colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 1.0],
    ),
    cardGradient: LinearGradient(
      colors: [Color(0xFF1E1E38), Color(0xFF2A2A4A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    glassGradient: LinearGradient(
      colors: [Color(0x206366F1), Color(0x10252542)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentCardGradient: LinearGradient(
      colors: [Color(0x256366F1), Color(0x15818CF8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    successCardGradient: LinearGradient(
      colors: [Color(0x2010B981), Color(0x1034D399)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    errorCardGradient: LinearGradient(
      colors: [Color(0x20EF4444), Color(0x10F87171)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    infoCardGradient: LinearGradient(
      colors: [Color(0x203B82F6), Color(0x1060A5FA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    warningCardGradient: LinearGradient(
      colors: [Color(0x20F59E0B), Color(0x10FBBF24)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cyanCardGradient: LinearGradient(
      colors: [Color(0x2022D3EE), Color(0x1006B6D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    purpleCardGradient: LinearGradient(
      colors: [Color(0x20A855F7), Color(0x108B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // --------------------------------------------------------------- light

  /// The same design, lit from the other side.
  ///
  /// Two things are not simply inverted. The accents are a step darker than
  /// their dark-theme counterparts, because a colour with enough contrast
  /// against near-black almost never has enough against white — indigo 500 on
  /// white is a little under 4.5:1, indigo 600 clears it. And the tinted card
  /// gradients carry roughly half again the alpha, because a wash that reads
  /// clearly over a dark surface disappears entirely over a white one.
  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    primaryDark: Color(0xFFF1F5F9),
    primarySurface: Color(0xFFFFFFFF),
    primaryElevated: Color(0xFFFFFFFF),
    primaryAccent: Color(0xFF4F46E5),
    primaryGlow: Color(0xFF6366F1),
    primaryPressed: Color(0xFF4338CA),
    neonCyan: Color(0xFF0891B2),
    neonPurple: Color(0xFF9333EA),
    neonPink: Color(0xFFDB2777),
    neonBlue: Color(0xFF2563EB),
    success: Color(0xFF059669),
    successLight: Color(0xFF10B981),
    successDark: Color(0xFF047857),
    error: Color(0xFFDC2626),
    errorLight: Color(0xFFEF4444),
    errorDark: Color(0xFFB91C1C),
    warning: Color(0xFFB45309),
    warningLight: Color(0xFFD97706),
    warningDark: Color(0xFF92400E),
    info: Color(0xFF2563EB),
    infoLight: Color(0xFF3B82F6),
    infoDark: Color(0xFF1D4ED8),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    textInverse: Color(0xFFF8FAFC),
    glassWhite: Color(0x0A0F172A),
    glassBorder: Color(0x334F46E5),
    glassHighlight: Color(0x14000000),
    glassShadow: Color(0x1A0F172A),
    divider: Color(0xFFE2E8F0),
    backgroundGradient: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFEEF2F8), Color(0xFFFFFFFF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 1.0],
    ),
    cardGradient: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF6F8FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    glassGradient: LinearGradient(
      colors: [Color(0x146366F1), Color(0x0AF8FAFC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentCardGradient: LinearGradient(
      colors: [Color(0x2E4F46E5), Color(0x1A6366F1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    successCardGradient: LinearGradient(
      colors: [Color(0x2E059669), Color(0x1A10B981)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    errorCardGradient: LinearGradient(
      colors: [Color(0x2EDC2626), Color(0x1AEF4444)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    infoCardGradient: LinearGradient(
      colors: [Color(0x2E2563EB), Color(0x1A3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    warningCardGradient: LinearGradient(
      colors: [Color(0x2EB45309), Color(0x1AD97706)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cyanCardGradient: LinearGradient(
      colors: [Color(0x2E0891B2), Color(0x1A06B6D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    purpleCardGradient: LinearGradient(
      colors: [Color(0x2E9333EA), Color(0x1AA855F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static AppPalette of(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}
