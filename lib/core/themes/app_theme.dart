import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_page_transitions.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/premium_themes.dart';

/// Main theme configuration for The Accountant app
/// Uses the design system tokens from app_colors, app_typography, app_spacing
class AppTheme {
  AppTheme._();

  // ============================================
  // GRADIENTS (re-exported from AppColors for compatibility)
  // ============================================

  static const LinearGradient primaryGradient = AppColors.primaryGradient;
  static const LinearGradient secondaryGradient = AppColors.secondaryGradient;
  static const LinearGradient accentGradient = AppColors.accentGradient;

  // Surface gradients follow the palette, so these have to be read each time
  // rather than captured once.
  static LinearGradient get cardGradient => AppColors.cardGradient;
  static LinearGradient get backgroundGradient => AppColors.backgroundGradient;

  // ============================================
  // THEME DATA
  // ============================================

  /// The light theme, built from the light palette.
  ///
  /// It used to be four lines — a seeded colour scheme and nothing else — which
  /// is part of why it was never selectable: even if it had been reachable, it
  /// would have themed none of the components the dark theme themes. Both are
  /// now the same builder over a different set of colours, so neither can drift
  /// away from the other.
  static ThemeData get lightTheme => themeFor(AppPalette.light);

  /// The dark theme, built from the dark palette.
  static ThemeData get darkTheme => themeFor(AppPalette.dark);

  /// Build the app's theme over [palette].
  /// Call [AppColors.usePalette] with the same palette first: the text styles
  /// come from [AppTypography], which reads the palette that is current rather
  /// than one handed to it, and the two disagreeing would give a theme with the
  /// wrong text colour in it.
  static ThemeData themeFor(AppPalette palette) => ThemeData(
    useMaterial3: true,
    brightness: palette.brightness,
    // Transparent so the app-wide AppBackground gradient shows through.
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: palette.brightness,
      primary: palette.primaryAccent,
      secondary: palette.neonCyan,
      tertiary: palette.neonPurple,
      surface: palette.primarySurface,
      error: palette.error,
      // White on the accent either way: these sit on a saturated fill, not on
      // the page, so they do not follow the palette's text colour.
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: palette.textPrimary,
      onError: Colors.white,
    ),
    textTheme: AppTypography.textTheme,
    pageTransitionsTheme: appPageTransitionsTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      iconTheme: IconThemeData(color: palette.textPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Inverted: dark icons are what shows up on a light bar.
        statusBarIconBrightness: palette.isDark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: palette.brightness,
        systemNavigationBarColor: palette.primaryDark,
        systemNavigationBarIconBrightness: palette.isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    ),
    cardTheme: CardThemeData(
      color: palette.primarySurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.primaryAccent,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        padding: AppSpacing.paddingButton,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.textPrimary,
        side: BorderSide(color: palette.glassBorder),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        padding: AppSpacing.paddingButton,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: palette.primaryAccent,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        padding: AppSpacing.paddingButtonCompact,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.glassWhite,
      hintStyle: TextStyle(color: palette.textMuted),
      labelStyle: TextStyle(color: palette.textSecondary),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: palette.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: palette.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: palette.primaryAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: palette.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: palette.error, width: 2),
      ),
      contentPadding: AppSpacing.paddingInput,
    ),
    dividerTheme: DividerThemeData(
      color: palette.divider,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: palette.primaryAccent,
      unselectedItemColor: palette.textMuted,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: palette.primaryAccent,
      foregroundColor: palette.textPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: palette.primaryElevated,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: palette.primarySurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.primarySurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: palette.glassWhite,
      selectedColor: palette.primaryAccent.withValues(alpha: 0.2),
      labelStyle: AppTypography.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusFull,
        side: BorderSide(color: palette.glassBorder),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.primaryAccent,
      linearTrackColor: palette.glassWhite,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.primaryAccent;
        }
        return palette.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.primaryAccent.withValues(alpha: 0.3);
        }
        return palette.glassWhite;
      }),
    ),
  );

  /// Get the current theme based on user selection
  static ThemeData getCurrentTheme(String themeName) {
    // Return premium theme if it exists
    if (PremiumThemes.themeMap.containsKey(themeName)) {
      return PremiumThemes.themeMap[themeName]!;
    }
    // Return default dark theme
    return darkTheme;
  }

  // ============================================
  // CONTAINER BUILDERS
  // ============================================

  /// Gradient container with shadow
  static Widget gradientContainer({
    required Widget child,
    Gradient? gradient,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? primaryGradient,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusLg,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: (gradient?.colors.first ?? AppColors.primaryAccent)
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: child,
    );
  }

  /// Glassmorphic container with blur effect
  static Widget glassmorphicContainer({
    required Widget child,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? borderColor,
    double borderWidth = 1,
    bool enableBlur = false,
    double blurAmount = 10,
    Gradient? gradient,
  }) {
    final container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.glassGradient,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusXl,
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (enableBlur) {
      return ClipRRect(
        borderRadius: borderRadius ?? AppSpacing.borderRadiusXl,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: container,
        ),
      );
    }

    return container;
  }

  /// Card container with elevation effect
  static Widget cardContainer({
    required Widget child,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: color ?? AppColors.primarySurface,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusXl,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }

  /// Glow container (for highlighted elements)
  static Widget glowContainer({
    required Widget child,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    // Nullable rather than defaulted: a palette colour is no longer a
    // compile-time constant, so it cannot be a default value.
    Color? glowColor,
    double glowSpread = 20,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? AppSpacing.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? AppColors.primaryGlow).withValues(alpha: 0.4),
            blurRadius: glowSpread,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
