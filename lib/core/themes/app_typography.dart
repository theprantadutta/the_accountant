import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for The Accountant app
/// Uses Inter for UI and JetBrains Mono for numbers
class AppTypography {
  AppTypography._();

  // ============================================
  // FONT FAMILIES
  // ============================================

  static String get fontFamily => GoogleFonts.inter().fontFamily!;
  static String get monoFontFamily => GoogleFonts.jetBrainsMono().fontFamily!;

  // ============================================
  // DISPLAY STYLES - Hero text, large numbers
  // ============================================

  /// Extra large display - main balance
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.5,
    color: AppColors.textPrimary,
  );

  /// Large display - section headers
  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
  );

  /// Small display - card titles
  static TextStyle get displaySmall => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // ============================================
  // HEADLINE STYLES - Screen titles, sections
  // ============================================

  /// Large headline - screen titles
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
  );

  /// Medium headline - section headers
  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Small headline - card headers
  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================
  // TITLE STYLES - List items, buttons
  // ============================================

  /// Large title
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Medium title
  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Small title
  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================
  // BODY STYLES - Regular content
  // ============================================

  /// Large body text
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Medium body text (default)
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Small body text
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ============================================
  // LABEL STYLES - Buttons, chips, tags
  // ============================================

  /// Large label - primary buttons
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Medium label - secondary buttons
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Small label - chips, tags
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.8,
    color: AppColors.textSecondary,
  );

  // ============================================
  // MONOSPACE STYLES - Currency, numbers
  // ============================================

  /// Large mono - main balance display
  static TextStyle get monoLarge => GoogleFonts.jetBrainsMono(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// Medium mono - transaction amounts
  static TextStyle get monoMedium => GoogleFonts.jetBrainsMono(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Small mono - stats, small numbers
  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Apply secondary color to any style
  static TextStyle secondary(TextStyle style) {
    return style.copyWith(color: AppColors.textSecondary);
  }

  /// Apply muted color to any style
  static TextStyle muted(TextStyle style) {
    return style.copyWith(color: AppColors.textMuted);
  }

  /// Apply success color to any style
  static TextStyle success(TextStyle style) {
    return style.copyWith(color: AppColors.success);
  }

  /// Apply error color to any style
  static TextStyle error(TextStyle style) {
    return style.copyWith(color: AppColors.error);
  }

  /// Apply custom color to any style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply bold to any style
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Apply medium weight to any style
  static TextStyle medium(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w500);
  }

  // ============================================
  // TEXT THEME FOR MATERIAL
  // ============================================

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
