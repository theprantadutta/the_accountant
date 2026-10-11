import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_page_transitions.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';

/// The app's Material theme, built from the Sunrise tokens.
class AppTheme {
  AppTheme._();

  // ============================================
  // GRADIENTS (re-exported from AppColors for compatibility)
  // ============================================

  static LinearGradient get primaryGradient => AppColors.primaryGradient;
  static LinearGradient get secondaryGradient => AppColors.secondaryGradient;
  static LinearGradient get accentGradient => AppColors.accentGradient;
  static LinearGradient get cardGradient => AppColors.cardGradient;
  static LinearGradient get backgroundGradient => AppColors.backgroundGradient;

  // ============================================
  // THEME DATA
  // ============================================

  static ThemeData get lightTheme => themeFor(SunriseColors.light);
  static ThemeData get darkTheme => themeFor(SunriseColors.dark);

  static final Expando<ThemeData> _built = Expando('ThemeData');

  /// The Material 3 theme for one set of Sunrise tokens.
  ///
  /// The tokens ride along as a [ThemeExtension], so Sunrise widgets read
  /// `context.sunrise` and a theme change animates. Component themes come
  /// from the same tokens, so stock Material widgets (dialogs, snackbars,
  /// pickers, progress indicators) already look like Sunrise.
  static ThemeData themeFor(SunriseColors c) => _built[c] ??= _build(c);

  static ThemeData _build(SunriseColors c) {
    final overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Inverted: dark icons are what shows up on a light bar.
      statusBarIconBrightness: c.isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: c.brightness,
      systemNavigationBarColor: c.base,
      systemNavigationBarIconBrightness: c.isDark
          ? Brightness.light
          : Brightness.dark,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: SunriseRadius.inputAll,
      borderSide: BorderSide(color: c.tabBarBorder),
    );
    const heroShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(SunriseRadius.hero)),
    );
    const menuShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );
    const buttonShape = RoundedRectangleBorder(
      borderRadius: SunriseRadius.buttonAll,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      fontFamily: kSunriseFont,
      extensions: [c],
      // Transparent so the screen's Sunrise wash shows through.
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: c.base,
      highlightColor: c.accent.withValues(alpha: .06),
      splashColor: c.accent.withValues(alpha: .10),
      colorScheme: ColorScheme(
        brightness: c.brightness,
        primary: c.accent,
        onPrimary: Colors.white,
        primaryContainer: c.tintOrange,
        onPrimaryContainer: c.accentText,
        secondary: c.gradientEnd,
        onSecondary: Colors.white,
        secondaryContainer: c.tintRose,
        onSecondaryContainer: c.ink,
        tertiary: c.gradientStart,
        onTertiary: Colors.white,
        error: c.negative,
        onError: Colors.white,
        errorContainer: c.tintRose,
        onErrorContainer: c.negative,
        surface: c.surface,
        onSurface: c.ink,
        onSurfaceVariant: c.muted,
        surfaceContainerLowest: c.base,
        surfaceContainerLow: c.surface,
        surfaceContainer: c.surface,
        surfaceContainerHigh: c.surface,
        surfaceContainerHighest: c.isDark
            ? const Color(0xFF2B1F19)
            : const Color(0xFFFFF3EA),
        outline: c.chevron,
        outlineVariant: c.divider,
        shadow: const Color(0xFF2B1B12),
        scrim: Colors.black,
        inverseSurface: c.ink,
        onInverseSurface: c.base,
        inversePrimary: c.accentText,
        surfaceTint: Colors.transparent,
      ),
      textTheme: _textTheme(c),
      iconTheme: IconThemeData(color: c.ink, size: 24),
      pageTransitionsTheme: appPageTransitionsTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: SunriseType.pushTitle.copyWith(color: c.ink),
        iconTheme: IconThemeData(color: c.ink),
        systemOverlayStyle: overlay,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: SunriseRadius.cardAll,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: SunriseType.button,
          shape: buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          minimumSize: const Size(0, 52),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          textStyle: SunriseType.button,
          shape: buttonShape,
          minimumSize: const Size(0, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          backgroundColor: c.surface,
          textStyle: SunriseType.button,
          side: BorderSide(color: c.tabBarBorder),
          shape: buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          minimumSize: const Size(0, 52),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accentText,
          textStyle: SunriseType.label.copyWith(fontWeight: FontWeight.w600),
          shape: const RoundedRectangleBorder(
            borderRadius: SunriseRadius.inputAll,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: c.ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: SunriseType.body.copyWith(color: c.faint),
        labelStyle: SunriseType.label.copyWith(color: c.muted),
        floatingLabelStyle: SunriseType.label.copyWith(color: c.accentText),
        helperStyle: SunriseType.caption.copyWith(color: c.subtle),
        errorStyle: SunriseType.caption.copyWith(color: c.negative),
        prefixIconColor: c.subtle,
        suffixIconColor: c.subtle,
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: SunriseRadius.inputAll,
          borderSide: BorderSide(color: c.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: SunriseRadius.inputAll,
          borderSide: BorderSide(color: c.negative),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: SunriseRadius.inputAll,
          borderSide: BorderSide(color: c.negative, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.accent,
        selectionColor: c.accent.withValues(alpha: .25),
        selectionHandleColor: c.accent,
      ),
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: c.accent,
        textColor: c.ink,
        titleTextStyle: SunriseType.rowTitle.copyWith(color: c.ink),
        subtitleTextStyle: SunriseType.caption.copyWith(color: c.subtle),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: c.accent,
        unselectedItemColor: c.faint,
        type: BottomNavigationBarType.fixed,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.tabBar,
        indicatorColor: c.tintOrange,
        selectedIconTheme: IconThemeData(color: c.accent),
        unselectedIconTheme: IconThemeData(color: c.faint),
        selectedLabelTextStyle: SunriseType.tabLabel.copyWith(color: c.accent),
        unselectedLabelTextStyle: SunriseType.tabLabel.copyWith(
          color: c.faint,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: buttonShape,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.chipActiveBg,
        contentTextStyle: SunriseType.label.copyWith(color: c.chipActiveFg),
        actionTextColor: c.isDark ? c.accentText : c.accent,
        closeIconColor: c.chipActiveFg,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: const RoundedRectangleBorder(
          borderRadius: SunriseRadius.inputAll,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.base,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: SunriseType.section.copyWith(color: c.ink),
        contentTextStyle: SunriseType.body.copyWith(color: c.body),
        shape: heroShape,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.base,
        modalBackgroundColor: c.base,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: SunriseRadius.sheetTop,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: const Color(0x40C85A28),
        textStyle: SunriseType.rowTitle.copyWith(color: c.ink),
        shape: menuShape,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(c.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: const WidgetStatePropertyAll(menuShape),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: c.chipActiveBg,
        secondarySelectedColor: c.chipActiveBg,
        checkmarkColor: c.chipActiveFg,
        labelStyle: SunriseType.label.copyWith(color: c.muted),
        secondaryLabelStyle: SunriseType.label.copyWith(color: c.chipActiveFg),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: const StadiumBorder(),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.toggleOff,
        circularTrackColor: Colors.transparent,
        refreshBackgroundColor: c.surface,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.accent,
        inactiveTrackColor: c.toggleOff,
        thumbColor: c.accent,
        overlayColor: c.accent.withValues(alpha: .12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? c.accent : c.toggleOff,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? c.accent
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: BorderSide(color: c.chevron, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? c.accent : c.chevron,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: c.ink,
        unselectedLabelColor: c.subtle,
        indicatorColor: c.accent,
        dividerColor: Colors.transparent,
        labelStyle: SunriseType.label.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: SunriseType.label,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.chipActiveBg,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        textStyle: SunriseType.caption.copyWith(color: c.chipActiveFg),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.base,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.accent,
        headerForegroundColor: Colors.white,
        todayBorder: BorderSide(color: c.accent),
        shape: heroShape,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: c.base,
        dialBackgroundColor: c.surface,
        hourMinuteColor: c.surface,
        dayPeriodColor: c.tintOrange,
        shape: heroShape,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: c.accent,
        collapsedIconColor: c.subtle,
        textColor: c.ink,
        collapsedTextColor: c.ink,
        shape: const Border(),
        collapsedShape: const Border(),
      ),
    );
  }

  static TextTheme _textTheme(SunriseColors c) => TextTheme(
    displayLarge: SunriseType.balance.copyWith(color: c.ink, fontSize: 48),
    displayMedium: SunriseType.largeTitle.copyWith(color: c.ink),
    displaySmall: SunriseType.heroTitle.copyWith(color: c.ink),
    headlineLarge: SunriseType.greeting.copyWith(color: c.ink, fontSize: 24),
    headlineMedium: SunriseType.pushTitle.copyWith(color: c.ink),
    headlineSmall: SunriseType.section.copyWith(color: c.ink),
    titleLarge: SunriseType.section.copyWith(color: c.ink),
    titleMedium: SunriseType.button.copyWith(color: c.ink),
    titleSmall: SunriseType.rowTitle.copyWith(color: c.ink),
    bodyLarge: SunriseType.body.copyWith(color: c.ink, fontSize: 16),
    bodyMedium: SunriseType.body.copyWith(color: c.body, fontSize: 14),
    bodySmall: SunriseType.caption.copyWith(color: c.subtle),
    labelLarge: SunriseType.button.copyWith(color: c.ink, fontSize: 14),
    labelMedium: SunriseType.label.copyWith(color: c.muted, fontSize: 12),
    labelSmall: SunriseType.tabLabel.copyWith(color: c.subtle, fontSize: 11),
  );

  // ============================================
  // CONTAINER BUILDERS
  // ============================================

  /// A gradient hero surface with the warm coloured shadow.
  static Widget gradientContainer({
    required Widget child,
    Gradient? gradient,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    List<BoxShadow>? boxShadow,
  }) {
    final sunrise = AppColors.palette.sunrise ?? SunriseColors.light;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? sunrise.gradient,
        borderRadius:
            borderRadius ??
            const BorderRadius.all(Radius.circular(SunriseRadius.hero)),
        boxShadow: boxShadow ?? sunrise.gradientShadow,
      ),
      child: child,
    );
  }

  /// A frosted card. The blur is optional because it is expensive in lists.
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
    final sunrise = AppColors.palette.sunrise ?? SunriseColors.light;
    final radius = borderRadius ?? SunriseRadius.cardAll;
    final container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: gradient == null
            ? (enableBlur ? sunrise.glass : sunrise.surface)
            : null,
        gradient: gradient,
        borderRadius: radius,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: borderWidth),
        boxShadow: sunrise.glassShadow,
      ),
      child: child,
    );

    if (enableBlur) {
      return ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: container,
        ),
      );
    }

    return container;
  }

  /// A plain surface card.
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
      padding: padding ?? const EdgeInsets.all(SunriseSpace.card),
      decoration: BoxDecoration(
        color: color ?? AppColors.primarySurface,
        borderRadius: borderRadius ?? SunriseRadius.cardAll,
      ),
      child: child,
    );
  }

  /// A soft coloured glow behind a highlighted element.
  static Widget glowContainer({
    required Widget child,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? glowColor,
    double glowSpread = 20,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? AppColors.primaryGlow).withValues(alpha: 0.4),
            blurRadius: glowSpread,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
