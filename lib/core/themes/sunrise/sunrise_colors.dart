import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_accent.dart';

/// Every Sunrise colour token, resolved for one brightness and one accent.
///
/// Read it with `context.sunrise`. It travels in the `ThemeData`, so a theme
/// change animates through [lerp] instead of snapping.
@immutable
class SunriseColors extends ThemeExtension<SunriseColors> {
  const SunriseColors({
    required this.brightness,
    required this.base,
    required this.washTop,
    required this.washMid,
    required this.washLow,
    required this.washShortTop,
    required this.ink,
    required this.body,
    required this.muted,
    required this.subtle,
    required this.faint,
    required this.chevron,
    required this.surface,
    required this.glass,
    required this.tabBar,
    required this.tabBarBorder,
    required this.divider,
    required this.toggleOff,
    required this.barIdle,
    required this.dashed,
    required this.accent,
    required this.accentText,
    required this.positive,
    required this.negative,
    required this.chipActiveBg,
    required this.chipActiveFg,
    required this.tintOrange,
    required this.tintPeach,
    required this.tintAmber,
    required this.tintRose,
    required this.tintGreen,
    required this.tintSky,
    required this.tintViolet,
    required this.gradientStart,
    required this.gradientMid,
    required this.gradientEnd,
    required this.headerStart,
    required this.headerMid,
    required this.headerEnd,
    required this.orbHighlight,
    required this.glow,
    required this.stripStart,
    required this.stripEnd,
  });

  final Brightness brightness;

  final Color base;
  final Color washTop;
  final Color washMid;
  final Color washLow;
  final Color washShortTop;

  final Color ink;
  final Color body;
  final Color muted;
  final Color subtle;
  final Color faint;
  final Color chevron;

  final Color surface;
  final Color glass;
  final Color tabBar;
  final Color tabBarBorder;
  final Color divider;
  final Color toggleOff;
  final Color barIdle;
  final Color dashed;

  final Color accent;
  final Color accentText;
  final Color positive;
  final Color negative;
  final Color chipActiveBg;
  final Color chipActiveFg;

  /// Accent-tinted icon tile fill. Follows the accent.
  final Color tintOrange;

  /// A deeper accent tint. Follows the accent.
  final Color tintPeach;
  final Color tintAmber;
  final Color tintRose;
  final Color tintGreen;
  final Color tintSky;
  final Color tintViolet;

  final Color gradientStart;
  final Color gradientMid;
  final Color gradientEnd;
  final Color headerStart;
  final Color headerMid;
  final Color headerEnd;
  final Color orbHighlight;

  /// Tint for the coloured shadows under gradient surfaces.
  final Color glow;

  /// The soft summary strip (Activity's month strip).
  final Color stripStart;
  final Color stripEnd;

  bool get isDark => brightness == Brightness.dark;

  /// Text and icons on a coloured fill (gradient, accent, negative): white in
  /// both themes, because the fill does not change brightness with the page.
  Color get onFill => const Color(0xFFFFFFFF);

  // ------------------------------------------------------------ resolve

  static final Map<(Brightness, SunriseAccent), SunriseColors> _cache = {};

  /// The tokens for [brightness] painted in [accent].
  static SunriseColors resolve(Brightness brightness, SunriseAccent accent) =>
      _cache.putIfAbsent(
        (brightness, accent),
        () => _build(brightness, accent.swatch(brightness)),
      );

  static SunriseColors get light =>
      resolve(Brightness.light, SunriseAccent.sunrise);
  static SunriseColors get dark =>
      resolve(Brightness.dark, SunriseAccent.sunrise);

  static SunriseColors _build(Brightness b, AccentSwatch s) {
    final isDark = b == Brightness.dark;
    return SunriseColors(
      brightness: b,
      base: isDark ? const Color(0xFF140D0A) : const Color(0xFFFFFAF6),
      washTop: s.washTop,
      washMid: s.washMid,
      washLow: s.washLow,
      washShortTop: s.washShortTop,
      ink: isDark ? const Color(0xFFFFF4EC) : const Color(0xFF2B1B12),
      body: isDark ? const Color(0xFFE6D3C8) : const Color(0xFF5A3E32),
      muted: isDark ? const Color(0xFFCDB3A6) : const Color(0xFF7A5444),
      subtle: isDark ? const Color(0xFFA88E81) : const Color(0xFF9A7869),
      faint: isDark ? const Color(0xFF8A7064) : const Color(0xFFA8897B),
      chevron: isDark ? const Color(0xFF6E5A50) : const Color(0xFFC9AFA2),
      surface: isDark ? const Color(0xFF221813) : const Color(0xFFFFFFFF),
      glass: isDark ? const Color(0x0FFFFFFF) : const Color(0xBFFFFFFF),
      tabBar: isDark ? const Color(0xE61C130F) : const Color(0xE0FFFAF6),
      tabBarBorder: isDark ? const Color(0x14FFFFFF) : const Color(0xFFF3E4DA),
      divider: isDark ? const Color(0x12FFFFFF) : const Color(0xFFF7EDE6),
      toggleOff: isDark ? const Color(0xFF3A2E28) : const Color(0xFFEDE3DC),
      barIdle: s.barIdle,
      dashed: isDark ? const Color(0xFF5A3A28) : const Color(0xFFF2C9B0),
      accent: s.accent,
      accentText: s.accentText,
      positive: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
      negative: isDark ? const Color(0xFFFB7185) : const Color(0xFFE11D48),
      chipActiveBg: isDark ? const Color(0xFFFFF4EC) : const Color(0xFF2B1B12),
      chipActiveFg: isDark ? const Color(0xFF140D0A) : const Color(0xFFFFFFFF),
      tintOrange: s.tintAccent,
      tintPeach: s.tintAccentSoft,
      tintAmber: isDark ? const Color(0xFF3A2E12) : const Color(0xFFFEF3C7),
      tintRose: isDark ? const Color(0xFF3D1A20) : const Color(0xFFFFE4E6),
      tintGreen: isDark ? const Color(0xFF123222) : const Color(0xFFDCFCE7),
      tintSky: isDark ? const Color(0xFF122A3A) : const Color(0xFFE0F2FE),
      tintViolet: isDark ? const Color(0xFF2A1F45) : const Color(0xFFEDE9FE),
      gradientStart: s.gradient[0],
      gradientMid: s.gradient[1],
      gradientEnd: s.gradient[2],
      headerStart: s.header[0],
      headerMid: s.header[1],
      headerEnd: s.header[2],
      orbHighlight: s.orbHighlight,
      glow: s.glow,
      stripStart: s.tintAccentSoft,
      stripEnd: isDark ? const Color(0xFF3D1A20) : const Color(0xFFFFE4E6),
    );
  }

  // ---------------------------------------------------------- gradients

  /// The 135° brand gradient: buttons, hero cards, Add, selected category.
  LinearGradient get gradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMid, gradientEnd],
    stops: const [0, .5, 1],
  );

  /// Two-stop version, for small fills like the toggle track.
  LinearGradient get gradientShort => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  /// The full-bleed header behind Add (160°).
  LinearGradient get headerGradient => LinearGradient(
    begin: const Alignment(-.35, -1),
    end: const Alignment(.35, 1),
    colors: [headerStart, headerMid, headerEnd],
    stops: const [0, .4, 1],
  );

  /// The AI orb.
  RadialGradient get orbGradient => RadialGradient(
    center: const Alignment(-.3, -.4),
    radius: .9,
    colors: [orbHighlight, gradientMid, gradientEnd],
    stops: const [0, .5, 1],
  );

  /// The peak bar in charts (vertical).
  LinearGradient get barHighlight => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientStart, gradientEnd],
  );

  /// Activity's month summary strip (120°).
  LinearGradient get softStrip => LinearGradient(
    begin: const Alignment(-1, -.6),
    end: const Alignment(1, .6),
    colors: [stripStart, stripEnd],
  );

  /// The tall wash behind tab roots.
  LinearGradient get washTall => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [washTop, washMid, washLow, base],
    stops: const [0, .18, .42, .6],
  );

  /// The short wash behind pushed screens.
  LinearGradient get washShort => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [washShortTop, washLow, base],
    stops: const [0, .24, .44],
  );

  // ------------------------------------------------------------ shadows

  /// Under frosted and white cards. Warm, never grey.
  List<BoxShadow> get glassShadow => [
    BoxShadow(
      offset: const Offset(0, 20),
      blurRadius: 40,
      spreadRadius: -24,
      color: isDark ? const Color(0x66000000) : const Color(0x80C85A28),
    ),
  ];

  /// Under gradient hero cards.
  List<BoxShadow> get gradientShadow => [
    BoxShadow(
      offset: const Offset(0, 24),
      blurRadius: 40,
      spreadRadius: -22,
      color: glow.withValues(alpha: .8),
    ),
  ];

  /// Under primary buttons.
  List<BoxShadow> get buttonShadow => [
    BoxShadow(
      offset: const Offset(0, 18),
      blurRadius: 30,
      spreadRadius: -14,
      color: glow.withValues(alpha: .8),
    ),
  ];

  /// Under the selected category tile.
  List<BoxShadow> get selectedShadow => [
    BoxShadow(
      offset: const Offset(0, 10),
      blurRadius: 20,
      spreadRadius: -10,
      color: glow.withValues(alpha: .8),
    ),
  ];

  /// A soft lift for plain surface cards.
  List<BoxShadow> get cardShadow => [
    BoxShadow(
      offset: const Offset(0, 10),
      blurRadius: 30,
      spreadRadius: -18,
      color: isDark ? const Color(0x40000000) : const Color(0x33C85A28),
    ),
  ];

  // ------------------------------------------------------ ThemeExtension

  @override
  SunriseColors copyWith({Color? accent, Color? accentText}) => SunriseColors(
    brightness: brightness,
    base: base,
    washTop: washTop,
    washMid: washMid,
    washLow: washLow,
    washShortTop: washShortTop,
    ink: ink,
    body: body,
    muted: muted,
    subtle: subtle,
    faint: faint,
    chevron: chevron,
    surface: surface,
    glass: glass,
    tabBar: tabBar,
    tabBarBorder: tabBarBorder,
    divider: divider,
    toggleOff: toggleOff,
    barIdle: barIdle,
    dashed: dashed,
    accent: accent ?? this.accent,
    accentText: accentText ?? this.accentText,
    positive: positive,
    negative: negative,
    chipActiveBg: chipActiveBg,
    chipActiveFg: chipActiveFg,
    tintOrange: tintOrange,
    tintPeach: tintPeach,
    tintAmber: tintAmber,
    tintRose: tintRose,
    tintGreen: tintGreen,
    tintSky: tintSky,
    tintViolet: tintViolet,
    gradientStart: gradientStart,
    gradientMid: gradientMid,
    gradientEnd: gradientEnd,
    headerStart: headerStart,
    headerMid: headerMid,
    headerEnd: headerEnd,
    orbHighlight: orbHighlight,
    glow: glow,
    stripStart: stripStart,
    stripEnd: stripEnd,
  );

  @override
  SunriseColors lerp(ThemeExtension<SunriseColors>? other, double t) {
    if (other is! SunriseColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SunriseColors(
      brightness: t < .5 ? brightness : other.brightness,
      base: l(base, other.base),
      washTop: l(washTop, other.washTop),
      washMid: l(washMid, other.washMid),
      washLow: l(washLow, other.washLow),
      washShortTop: l(washShortTop, other.washShortTop),
      ink: l(ink, other.ink),
      body: l(body, other.body),
      muted: l(muted, other.muted),
      subtle: l(subtle, other.subtle),
      faint: l(faint, other.faint),
      chevron: l(chevron, other.chevron),
      surface: l(surface, other.surface),
      glass: l(glass, other.glass),
      tabBar: l(tabBar, other.tabBar),
      tabBarBorder: l(tabBarBorder, other.tabBarBorder),
      divider: l(divider, other.divider),
      toggleOff: l(toggleOff, other.toggleOff),
      barIdle: l(barIdle, other.barIdle),
      dashed: l(dashed, other.dashed),
      accent: l(accent, other.accent),
      accentText: l(accentText, other.accentText),
      positive: l(positive, other.positive),
      negative: l(negative, other.negative),
      chipActiveBg: l(chipActiveBg, other.chipActiveBg),
      chipActiveFg: l(chipActiveFg, other.chipActiveFg),
      tintOrange: l(tintOrange, other.tintOrange),
      tintPeach: l(tintPeach, other.tintPeach),
      tintAmber: l(tintAmber, other.tintAmber),
      tintRose: l(tintRose, other.tintRose),
      tintGreen: l(tintGreen, other.tintGreen),
      tintSky: l(tintSky, other.tintSky),
      tintViolet: l(tintViolet, other.tintViolet),
      gradientStart: l(gradientStart, other.gradientStart),
      gradientMid: l(gradientMid, other.gradientMid),
      gradientEnd: l(gradientEnd, other.gradientEnd),
      headerStart: l(headerStart, other.headerStart),
      headerMid: l(headerMid, other.headerMid),
      headerEnd: l(headerEnd, other.headerEnd),
      orbHighlight: l(orbHighlight, other.orbHighlight),
      glow: l(glow, other.glow),
      stripStart: l(stripStart, other.stripStart),
      stripEnd: l(stripEnd, other.stripEnd),
    );
  }
}

extension SunriseContext on BuildContext {
  /// The Sunrise tokens in force here.
  ///
  /// Falls back to Sunrise Light outside a themed tree (tests, overlays built
  /// before the app), so a missing extension is never a crash.
  SunriseColors get sunrise =>
      Theme.of(this).extension<SunriseColors>() ?? SunriseColors.light;
}
