import 'package:flutter/material.dart';

/// Spacing and sizing system for The Accountant app
/// Base unit: 4px (following 4-point grid)
class AppSpacing {
  AppSpacing._();

  // ============================================
  // SPACING VALUES (4px base unit)
  // ============================================

  /// 4px - Minimal spacing
  static const double xs = 4.0;

  /// 8px - Small spacing
  static const double sm = 8.0;

  /// 12px - Between small and medium
  static const double md = 12.0;

  /// 16px - Default/medium spacing
  static const double lg = 16.0;

  /// 20px - Comfortable spacing
  static const double xl = 20.0;

  /// 24px - Large spacing
  static const double xxl = 24.0;

  /// 32px - Section spacing
  static const double xxxl = 32.0;

  /// 48px - Major section breaks
  static const double huge = 48.0;

  /// 64px - Screen padding (top/bottom)
  static const double massive = 64.0;

  // ============================================
  // BORDER RADIUS
  // ============================================

  /// 4px - Subtle rounding (chips, badges)
  static const double radiusXs = 4.0;

  /// 8px - Small rounding (buttons, inputs)
  static const double radiusSm = 8.0;

  /// 12px - Medium rounding (cards)
  static const double radiusMd = 12.0;

  /// 16px - Large rounding (modals)
  static const double radiusLg = 16.0;

  /// 20px - Extra large rounding (containers)
  static const double radiusXl = 20.0;

  /// 24px - Huge rounding (hero cards)
  static const double radiusXxl = 24.0;

  /// 28px - Major elements
  static const double radiusXxxl = 28.0;

  /// Full/pill shape
  static const double radiusFull = 9999.0;

  // ============================================
  // BORDER RADIUS - BorderRadius objects
  // ============================================

  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusXxl => BorderRadius.circular(radiusXxl);
  static BorderRadius get borderRadiusXxxl => BorderRadius.circular(radiusXxxl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // ============================================
  // EDGE INSETS - Common padding patterns
  // ============================================

  /// No padding
  static const EdgeInsets paddingNone = EdgeInsets.zero;

  /// 4px all sides
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);

  /// 8px all sides
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// 12px all sides
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// 16px all sides
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// 20px all sides
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// 24px all sides
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  /// Screen content padding (horizontal: 20, vertical: 16)
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );

  /// Card content padding (16px all)
  static const EdgeInsets paddingCard = EdgeInsets.all(lg);

  /// Button padding (horizontal: 24, vertical: 16)
  static const EdgeInsets paddingButton = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: lg,
  );

  /// Compact button padding (horizontal: 16, vertical: 12)
  static const EdgeInsets paddingButtonCompact = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// List item padding (horizontal: 16, vertical: 12)
  static const EdgeInsets paddingListItem = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Input field padding (horizontal: 16, vertical: 16)
  static const EdgeInsets paddingInput = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );

  // ============================================
  // GAPS - For Row/Column spacing
  // ============================================

  /// Vertical gap - 4px
  static const SizedBox gapXs = SizedBox(height: xs);

  /// Vertical gap - 8px
  static const SizedBox gapSm = SizedBox(height: sm);

  /// Vertical gap - 12px
  static const SizedBox gapMd = SizedBox(height: md);

  /// Vertical gap - 16px
  static const SizedBox gapLg = SizedBox(height: lg);

  /// Vertical gap - 20px
  static const SizedBox gapXl = SizedBox(height: xl);

  /// Vertical gap - 24px
  static const SizedBox gapXxl = SizedBox(height: xxl);

  /// Vertical gap - 32px
  static const SizedBox gapXxxl = SizedBox(height: xxxl);

  /// Horizontal gap - 4px
  static const SizedBox gapHXs = SizedBox(width: xs);

  /// Horizontal gap - 8px
  static const SizedBox gapHSm = SizedBox(width: sm);

  /// Horizontal gap - 12px
  static const SizedBox gapHMd = SizedBox(width: md);

  /// Horizontal gap - 16px
  static const SizedBox gapHLg = SizedBox(width: lg);

  /// Horizontal gap - 20px
  static const SizedBox gapHXl = SizedBox(width: xl);

  /// Horizontal gap - 24px
  static const SizedBox gapHXxl = SizedBox(width: xxl);

  // ============================================
  // ICON SIZES
  // ============================================

  /// 16px - Small icons (in text, badges)
  static const double iconXs = 16.0;

  /// 20px - Default icons
  static const double iconSm = 20.0;

  /// 24px - Medium icons (nav, actions)
  static const double iconMd = 24.0;

  /// 28px - Large icons
  static const double iconLg = 28.0;

  /// 32px - Extra large icons
  static const double iconXl = 32.0;

  /// 48px - Hero icons
  static const double iconXxl = 48.0;

  // ============================================
  // COMPONENT HEIGHTS
  // ============================================

  /// 36px - Compact button height
  static const double buttonHeightSm = 36.0;

  /// 44px - Default button height
  static const double buttonHeightMd = 44.0;

  /// 52px - Large button height
  static const double buttonHeightLg = 52.0;

  /// 56px - Hero button height
  static const double buttonHeightXl = 56.0;

  /// 48px - Default input field height
  static const double inputHeight = 48.0;

  /// 56px - Large input field height
  static const double inputHeightLg = 56.0;

  /// 60px - Bottom navigation bar height
  static const double bottomNavHeight = 60.0;

  /// 56px - App bar height
  static const double appBarHeight = 56.0;

  /// 80px - Bottom sheet handle area
  static const double bottomSheetHandle = 80.0;

  // ============================================
  // AVATAR SIZES
  // ============================================

  /// 24px - Tiny avatar (inline)
  static const double avatarXs = 24.0;

  /// 32px - Small avatar (list items)
  static const double avatarSm = 32.0;

  /// 40px - Medium avatar (cards)
  static const double avatarMd = 40.0;

  /// 48px - Large avatar (headers)
  static const double avatarLg = 48.0;

  /// 64px - Extra large avatar (profile)
  static const double avatarXl = 64.0;

  /// 96px - Hero avatar (profile screen)
  static const double avatarXxl = 96.0;

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Create a SizedBox with specified height
  static SizedBox verticalGap(double height) => SizedBox(height: height);

  /// Create a SizedBox with specified width
  static SizedBox horizontalGap(double width) => SizedBox(width: width);

  /// Create EdgeInsets with horizontal padding only
  static EdgeInsets horizontalPadding(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  /// Create EdgeInsets with vertical padding only
  static EdgeInsets verticalPadding(double value) =>
      EdgeInsets.symmetric(vertical: value);

  /// Create symmetric EdgeInsets
  static EdgeInsets symmetricPadding({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}
