import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
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
  static const LinearGradient cardGradient = AppColors.cardGradient;
  static const LinearGradient backgroundGradient = AppColors.backgroundGradient;
  static const LinearGradient accentGradient = AppColors.accentGradient;

  // ============================================
  // THEME DATA
  // ============================================

  /// Light theme (minimal - app is dark-first)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryAccent,
      brightness: Brightness.light,
    ),
    textTheme: AppTypography.textTheme,
  );

  /// Dark theme (primary)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // Transparent so the app-wide AppBackground gradient shows through.
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryAccent,
      secondary: AppColors.neonCyan,
      tertiary: AppColors.neonPurple,
      surface: AppColors.primarySurface,
      error: AppColors.error,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textPrimary,
    ),
    textTheme: AppTypography.textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primaryDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.primarySurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        padding: AppSpacing.paddingButton,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.glassBorder),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        padding: AppSpacing.paddingButton,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryAccent,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        padding: AppSpacing.paddingButtonCompact,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassWhite,
      hintStyle: TextStyle(color: AppColors.textMuted),
      labelStyle: TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.primaryAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppSpacing.paddingInput,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColors.primaryAccent,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryAccent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryElevated,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.primarySurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.primarySurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.glassWhite,
      selectedColor: AppColors.primaryAccent.withValues(alpha: 0.2),
      labelStyle: AppTypography.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusFull,
        side: BorderSide(color: AppColors.glassBorder),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryAccent,
      linearTrackColor: AppColors.glassWhite,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryAccent;
        }
        return AppColors.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryAccent.withValues(alpha: 0.3);
        }
        return AppColors.glassWhite;
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
    Color glowColor = AppColors.primaryGlow,
    double glowSpread = 20,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? AppSpacing.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: glowSpread,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
