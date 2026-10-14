import 'package:flutter/material.dart';

/// The colour a theme is "about": its gradient, its accent and the wash at the
/// top of every screen.
///
/// Sunrise is free; the other five are premium. Picking one swaps only these
/// values, never neutrals, surfaces or the positive and negative colours, so
/// every accent keeps the contrast Sunrise was designed with and a premium
/// theme can never make an amount unreadable.
enum SunriseAccent {
  sunrise('Sunrise', isPremium: false),
  sapphire('Sapphire'),
  emerald('Emerald'),
  ruby('Ruby'),
  amethyst('Amethyst'),
  graphite('Graphite');

  const SunriseAccent(this.storageName, {this.isPremium = true});

  /// What is written to preferences. English on purpose: it is data, not copy.
  final String storageName;
  final bool isPremium;

  static List<SunriseAccent> get premium =>
      values.where((a) => a.isPremium).toList(growable: false);

  /// Read a stored name back, including the names older builds wrote.
  ///
  /// "Midnight" was the grey premium theme before the redesign renamed it.
  static SunriseAccent? fromStorage(String? name) {
    if (name == null) return null;
    if (name == 'Midnight') return graphite;
    for (final accent in values) {
      if (accent.storageName == name) return accent;
    }
    return null;
  }

  AccentSwatch swatch(Brightness brightness) =>
      brightness == Brightness.dark ? _dark[this]! : _light[this]!;
}

/// Everything an accent decides, for one brightness.
@immutable
class AccentSwatch {
  const AccentSwatch({
    required this.gradient,
    required this.header,
    required this.orbHighlight,
    required this.accent,
    required this.accentText,
    required this.washTop,
    required this.washMid,
    required this.washLow,
    required this.washShortTop,
    required this.barIdle,
    required this.tintAccent,
    required this.tintAccentSoft,
    required this.glow,
  });

  /// Three stops of the main 135° gradient: start, middle, end.
  final List<Color> gradient;

  /// Three stops of the full-bleed header behind Add.
  final List<Color> header;

  /// The bright centre of the AI orb.
  final Color orbHighlight;
  final Color accent;
  final Color accentText;
  final Color washTop;
  final Color washMid;
  final Color washLow;
  final Color washShortTop;
  final Color barIdle;

  /// Tinted fill for accent icon tiles (Sunrise's `tintOrange`).
  final Color tintAccent;

  /// A second, slightly deeper tint (Sunrise's `tintPeach`).
  final Color tintAccentSoft;

  /// What the coloured shadows under gradient surfaces are tinted with.
  final Color glow;
}

const _sunriseGradient = [
  Color(0xFFF59E0B),
  Color(0xFFF97316),
  Color(0xFFF43F5E),
];
const _sunriseHeader = [
  Color(0xFFFDBA74),
  Color(0xFFFB923C),
  Color(0xFFF43F5E),
];
const _sapphireGradient = [
  Color(0xFF60A5FA),
  Color(0xFF2563EB),
  Color(0xFF1E3A8A),
];
const _sapphireHeader = [
  Color(0xFF93C5FD),
  Color(0xFF60A5FA),
  Color(0xFF2563EB),
];
const _emeraldGradient = [
  Color(0xFF34D399),
  Color(0xFF059669),
  Color(0xFF065F46),
];
const _emeraldHeader = [
  Color(0xFF6EE7B7),
  Color(0xFF34D399),
  Color(0xFF059669),
];
const _rubyGradient = [Color(0xFFFB7185), Color(0xFFE11D48), Color(0xFF9F1239)];
const _rubyHeader = [Color(0xFFFDA4AF), Color(0xFFFB7185), Color(0xFFBE123C)];
const _amethystGradient = [
  Color(0xFFA78BFA),
  Color(0xFF7C3AED),
  Color(0xFF5B21B6),
];
const _amethystHeader = [
  Color(0xFFC4B5FD),
  Color(0xFFA78BFA),
  Color(0xFF7C3AED),
];
const _graphiteGradient = [
  Color(0xFF9CA3AF),
  Color(0xFF4B5563),
  Color(0xFF111827),
];
const _graphiteHeader = [
  Color(0xFFBFC4CC),
  Color(0xFF6B7280),
  Color(0xFF374151),
];

const Map<SunriseAccent, AccentSwatch> _light = {
  SunriseAccent.sunrise: AccentSwatch(
    gradient: _sunriseGradient,
    header: _sunriseHeader,
    orbHighlight: Color(0xFFFDE68A),
    accent: Color(0xFFEA580C),
    accentText: Color(0xFFC2410C),
    washTop: Color(0xFFFFD7A8),
    washMid: Color(0xFFFFC4B4),
    washLow: Color(0xFFFFF3EA),
    washShortTop: Color(0xFFFFE4CC),
    barIdle: Color(0xFFFED7AA),
    tintAccent: Color(0xFFFFF0E5),
    tintAccentSoft: Color(0xFFFFEDD5),
    glow: Color(0xFFF43F5E),
  ),
  SunriseAccent.sapphire: AccentSwatch(
    gradient: _sapphireGradient,
    header: _sapphireHeader,
    orbHighlight: Color(0xFFBAE6FD),
    accent: Color(0xFF2563EB),
    accentText: Color(0xFF1D4ED8),
    washTop: Color(0xFFCFE0FF),
    washMid: Color(0xFFD9D9FF),
    washLow: Color(0xFFF2F5FF),
    washShortTop: Color(0xFFDCE8FF),
    barIdle: Color(0xFFBFDBFE),
    tintAccent: Color(0xFFEAF2FF),
    tintAccentSoft: Color(0xFFDBEAFE),
    glow: Color(0xFF2563EB),
  ),
  SunriseAccent.emerald: AccentSwatch(
    gradient: _emeraldGradient,
    header: _emeraldHeader,
    orbHighlight: Color(0xFFD1FAE5),
    accent: Color(0xFF059669),
    accentText: Color(0xFF047857),
    washTop: Color(0xFFC9F2DD),
    washMid: Color(0xFFD3EFE5),
    washLow: Color(0xFFF0FAF5),
    washShortTop: Color(0xFFDDF5E9),
    barIdle: Color(0xFFA7F3D0),
    tintAccent: Color(0xFFE8F8F0),
    tintAccentSoft: Color(0xFFD1FAE5),
    glow: Color(0xFF059669),
  ),
  SunriseAccent.ruby: AccentSwatch(
    gradient: _rubyGradient,
    header: _rubyHeader,
    orbHighlight: Color(0xFFFFE4E6),
    accent: Color(0xFFE11D48),
    accentText: Color(0xFFBE123C),
    washTop: Color(0xFFFFC9D2),
    washMid: Color(0xFFFFD2DA),
    washLow: Color(0xFFFFF1F3),
    washShortTop: Color(0xFFFFDDE3),
    barIdle: Color(0xFFFECDD3),
    tintAccent: Color(0xFFFFEEF1),
    tintAccentSoft: Color(0xFFFFE4E6),
    glow: Color(0xFFE11D48),
  ),
  SunriseAccent.amethyst: AccentSwatch(
    gradient: _amethystGradient,
    header: _amethystHeader,
    orbHighlight: Color(0xFFEDE9FE),
    accent: Color(0xFF7C3AED),
    accentText: Color(0xFF6D28D9),
    washTop: Color(0xFFE2D6FF),
    washMid: Color(0xFFEBD5F5),
    washLow: Color(0xFFF7F3FF),
    washShortTop: Color(0xFFE9E1FF),
    barIdle: Color(0xFFDDD6FE),
    tintAccent: Color(0xFFF3EEFF),
    tintAccentSoft: Color(0xFFEDE9FE),
    glow: Color(0xFF7C3AED),
  ),
  SunriseAccent.graphite: AccentSwatch(
    gradient: _graphiteGradient,
    header: _graphiteHeader,
    orbHighlight: Color(0xFFF3F4F6),
    accent: Color(0xFF4B5563),
    accentText: Color(0xFF374151),
    washTop: Color(0xFFE1E3E8),
    washMid: Color(0xFFE8E5E6),
    washLow: Color(0xFFF7F7F7),
    washShortTop: Color(0xFFEBECEF),
    barIdle: Color(0xFFD1D5DB),
    tintAccent: Color(0xFFF1F2F4),
    tintAccentSoft: Color(0xFFE5E7EB),
    glow: Color(0xFF374151),
  ),
};

const Map<SunriseAccent, AccentSwatch> _dark = {
  SunriseAccent.sunrise: AccentSwatch(
    gradient: _sunriseGradient,
    header: _sunriseHeader,
    orbHighlight: Color(0xFFFDE68A),
    accent: Color(0xFFFB923C),
    accentText: Color(0xFFFDBA74),
    washTop: Color(0xFF4A2410),
    washMid: Color(0xFF3E1A1C),
    washLow: Color(0xFF1E1410),
    washShortTop: Color(0xFF3A1F10),
    barIdle: Color(0xFF4A2C18),
    tintAccent: Color(0xFF3A2214),
    tintAccentSoft: Color(0xFF3A2414),
    glow: Color(0xFFF43F5E),
  ),
  SunriseAccent.sapphire: AccentSwatch(
    gradient: _sapphireGradient,
    header: _sapphireHeader,
    orbHighlight: Color(0xFFBAE6FD),
    accent: Color(0xFF60A5FA),
    accentText: Color(0xFF93C5FD),
    washTop: Color(0xFF10264D),
    washMid: Color(0xFF1C1B42),
    washLow: Color(0xFF14141C),
    washShortTop: Color(0xFF10223F),
    barIdle: Color(0xFF1E3157),
    tintAccent: Color(0xFF15233A),
    tintAccentSoft: Color(0xFF172A45),
    glow: Color(0xFF2563EB),
  ),
  SunriseAccent.emerald: AccentSwatch(
    gradient: _emeraldGradient,
    header: _emeraldHeader,
    orbHighlight: Color(0xFFD1FAE5),
    accent: Color(0xFF34D399),
    accentText: Color(0xFF6EE7B7),
    washTop: Color(0xFF0E3326),
    washMid: Color(0xFF12302A),
    washLow: Color(0xFF121915),
    washShortTop: Color(0xFF0F2C20),
    barIdle: Color(0xFF154232),
    tintAccent: Color(0xFF12301F),
    tintAccentSoft: Color(0xFF143826),
    glow: Color(0xFF059669),
  ),
  SunriseAccent.ruby: AccentSwatch(
    gradient: _rubyGradient,
    header: _rubyHeader,
    orbHighlight: Color(0xFFFFE4E6),
    accent: Color(0xFFFB7185),
    accentText: Color(0xFFFDA4AF),
    washTop: Color(0xFF4A1020),
    washMid: Color(0xFF3E1426),
    washLow: Color(0xFF1E1214),
    washShortTop: Color(0xFF3A1018),
    barIdle: Color(0xFF4A1A26),
    tintAccent: Color(0xFF3D1A20),
    tintAccentSoft: Color(0xFF42182A),
    glow: Color(0xFFE11D48),
  ),
  SunriseAccent.amethyst: AccentSwatch(
    gradient: _amethystGradient,
    header: _amethystHeader,
    orbHighlight: Color(0xFFEDE9FE),
    accent: Color(0xFFA78BFA),
    accentText: Color(0xFFC4B5FD),
    washTop: Color(0xFF2C1A4A),
    washMid: Color(0xFF301A3E),
    washLow: Color(0xFF18131E),
    washShortTop: Color(0xFF26183F),
    barIdle: Color(0xFF33245A),
    tintAccent: Color(0xFF2A1F45),
    tintAccentSoft: Color(0xFF2E2350),
    glow: Color(0xFF7C3AED),
  ),
  SunriseAccent.graphite: AccentSwatch(
    gradient: _graphiteGradient,
    header: _graphiteHeader,
    orbHighlight: Color(0xFFF3F4F6),
    accent: Color(0xFF9CA3AF),
    accentText: Color(0xFFD1D5DB),
    washTop: Color(0xFF2A2D33),
    washMid: Color(0xFF26262B),
    washLow: Color(0xFF17161A),
    washShortTop: Color(0xFF24262B),
    barIdle: Color(0xFF374151),
    tintAccent: Color(0xFF24272D),
    tintAccentSoft: Color(0xFF2A2D33),
    glow: Color(0xFF374151),
  ),
};
