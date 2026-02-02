import 'package:flutter/material.dart';

/// Comprehensive color system for The Accountant app
/// Futuristic dark theme with neon accents
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY PALETTE - Cyber Purple/Blue
  // ============================================

  /// Deep space black - main background
  static const Color primaryDark = Color(0xFF0D0D1A);

  /// Card/surface backgrounds
  static const Color primarySurface = Color(0xFF1A1A2E);

  /// Elevated surface (modals, dialogs)
  static const Color primaryElevated = Color(0xFF252542);

  /// Main accent color - Indigo
  static const Color primaryAccent = Color(0xFF6366F1);

  /// Lighter accent for glows/highlights
  static const Color primaryGlow = Color(0xFF818CF8);

  /// Darker accent for pressed states
  static const Color primaryPressed = Color(0xFF4F46E5);

  // ============================================
  // SECONDARY PALETTE - Neon Accents
  // ============================================

  /// Cyan neon accent
  static const Color neonCyan = Color(0xFF22D3EE);

  /// Purple neon accent
  static const Color neonPurple = Color(0xFFA855F7);

  /// Pink neon accent
  static const Color neonPink = Color(0xFFEC4899);

  /// Blue neon accent
  static const Color neonBlue = Color(0xFF3B82F6);

  // ============================================
  // SEMANTIC COLORS
  // ============================================

  /// Success/Income - Emerald green
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Error/Expense - Red
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// Warning - Amber
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// Info - Blue
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // ============================================
  // TEXT COLORS
  // ============================================

  /// Primary text - almost white
  static const Color textPrimary = Color(0xFFF8FAFC);

  /// Secondary text - muted
  static const Color textSecondary = Color(0xFF94A3B8);

  /// Tertiary/disabled text
  static const Color textMuted = Color(0xFF64748B);

  /// Inverse text (for light backgrounds)
  static const Color textInverse = Color(0xFF0F172A);

  // ============================================
  // GLASS/SURFACE COLORS
  // ============================================

  /// Glass effect - 5% white
  static const Color glassWhite = Color(0x0DFFFFFF);

  /// Glass border - subtle accent tint
  static const Color glassBorder = Color(0x306366F1);

  /// Glass highlight - 20% white
  static const Color glassHighlight = Color(0x33FFFFFF);

  /// Glass shadow
  static const Color glassShadow = Color(0x40000000);

  /// Divider color
  static const Color divider = Color(0xFF2D2D44);

  // ============================================
  // GRADIENTS
  // ============================================

  /// Primary gradient - Purple to Indigo
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient - Cyan to Teal
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient - Pink to Purple
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient - Deep space
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  /// Card gradient - Surface with subtle accent tint
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E38), Color(0xFF2A2A4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Glass gradient - Frosted effect with subtle accent tint
  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x206366F1), Color(0x10252542)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent card gradient - Indigo tint
  static const LinearGradient accentCardGradient = LinearGradient(
    colors: [Color(0x256366F1), Color(0x15818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success card gradient - Green tint (for income)
  static const LinearGradient successCardGradient = LinearGradient(
    colors: [Color(0x2010B981), Color(0x1034D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error card gradient - Red tint (for expenses)
  static const LinearGradient errorCardGradient = LinearGradient(
    colors: [Color(0x20EF4444), Color(0x10F87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Info card gradient - Blue tint
  static const LinearGradient infoCardGradient = LinearGradient(
    colors: [Color(0x203B82F6), Color(0x1060A5FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning card gradient - Amber tint
  static const LinearGradient warningCardGradient = LinearGradient(
    colors: [Color(0x20F59E0B), Color(0x10FBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Cyan card gradient - Cyan tint
  static const LinearGradient cyanCardGradient = LinearGradient(
    colors: [Color(0x2022D3EE), Color(0x1006B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Purple card gradient - Purple tint
  static const LinearGradient purpleCardGradient = LinearGradient(
    colors: [Color(0x20A855F7), Color(0x108B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient - Income
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error gradient - Expense
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // CATEGORY COLORS (for transactions)
  // ============================================

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
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Darken a color by percentage (0.0 - 1.0)
  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
