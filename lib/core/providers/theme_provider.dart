import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_accent.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';

export 'package:the_accountant/core/themes/sunrise/sunrise_accent.dart'
    show SunriseAccent;

/// What the user picked: a brightness (or "follow the phone") and an accent.
///
/// The two used to be one string ("Dark", "Sapphire", ...), and every premium
/// theme was a separate dark `ThemeData` that most of the app never read, so
/// picking one barely changed anything. Splitting them is what lets a premium
/// accent repaint the whole app, in light as well as dark.
@immutable
class ThemeState {
  const ThemeState({
    required this.mode,
    required this.accent,
    required this.premiumUnlocked,
  });

  final ThemeMode mode;
  final SunriseAccent accent;

  /// Whether the premium accents may be chosen.
  final bool premiumUnlocked;

  /// What to hand `MaterialApp.themeMode`.
  ThemeMode get themeMode => mode;

  bool get matchSystem => mode == ThemeMode.system;

  /// The brightness actually in force, given the phone's own setting.
  Brightness brightnessFor(Brightness platformBrightness) => switch (mode) {
    ThemeMode.system => platformBrightness,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };

  /// The Sunrise tokens for [brightness] in the chosen accent.
  SunriseColors colorsFor(Brightness brightness) =>
      SunriseColors.resolve(brightness, accent);

  /// The legacy palette the `AppColors` call sites read, derived from the same
  /// tokens so the two can never disagree.
  AppPalette paletteFor(Brightness platformBrightness) =>
      AppPalette.fromSunrise(colorsFor(brightnessFor(platformBrightness)));

  ThemeState copyWith({
    ThemeMode? mode,
    SunriseAccent? accent,
    bool? premiumUnlocked,
  }) => ThemeState(
    mode: mode ?? this.mode,
    accent: accent ?? this.accent,
    premiumUnlocked: premiumUnlocked ?? this.premiumUnlocked,
  );
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _modeKey = 'theme_mode';
  static const String _accentKey = 'theme_accent';

  /// The single key older builds stored "System" / "Light" / "Dark" or a
  /// premium theme name under. Read once to migrate, then removed.
  static const String _legacyKey = 'selected_theme';

  /// When an ad-earned premium-theme trial ends (ISO 8601). Kept on the device
  /// so the trial survives a restart before the server has been asked.
  static const String _trialKey = 'theme_trial_ends_at';

  /// Premium themes because of a subscription, as opposed to a trial.
  bool _subscribed = false;
  DateTime? _trialEndsAt;
  Timer? _trialTimer;

  bool get trialActive =>
      _trialEndsAt != null && _trialEndsAt!.isAfter(DateTime.now());

  DateTime? get trialEndsAt => trialActive ? _trialEndsAt : null;

  /// Follows the phone out of the box: Sunrise was designed light and dark as
  /// equals, and "Match system" is the first thing on the Appearance screen.
  ThemeNotifier()
    : super(
        const ThemeState(
          mode: ThemeMode.system,
          accent: SunriseAccent.sunrise,
          premiumUnlocked: false,
        ),
      ) {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var mode = _modeFromStorage(prefs.getString(_modeKey));
      var accent = SunriseAccent.fromStorage(prefs.getString(_accentKey));

      final legacy = prefs.getString(_legacyKey);
      if (legacy != null && mode == null && accent == null) {
        switch (legacy) {
          case 'System':
            mode = ThemeMode.system;
          case 'Light':
            mode = ThemeMode.light;
          case 'Dark':
            mode = ThemeMode.dark;
          default:
            // Every old premium theme was dark: keep the look they had.
            accent = SunriseAccent.fromStorage(legacy);
            if (accent != null) mode = ThemeMode.dark;
        }
        if (mode != null) await prefs.setString(_modeKey, mode.name);
        if (accent != null) {
          await prefs.setString(_accentKey, accent.storageName);
        }
        await prefs.remove(_legacyKey);
      }

      final trial = DateTime.tryParse(prefs.getString(_trialKey) ?? '');
      if (trial != null && trial.isAfter(DateTime.now())) {
        _trialEndsAt = trial;
        _scheduleTrialEnd();
      }

      if (!mounted) return;
      state = state.copyWith(
        mode: mode,
        accent: accent,
        premiumUnlocked: trialActive ? true : null,
      );
    } catch (_) {
      // A store that will not open is not a reason to fail to start; the
      // default theme is a perfectly good answer.
    }
  }

  static ThemeMode? _modeFromStorage(String? name) {
    for (final m in ThemeMode.values) {
      if (m.name == name) return m;
    }
    return null;
  }

  /// Light, dark, or follow the phone.
  void setMode(ThemeMode mode) {
    if (mode == state.mode) return;
    AnalyticsService().logThemeChange();
    state = state.copyWith(mode: mode);
    _persist(_modeKey, mode.name);
  }

  /// Pick an accent. Premium accents are refused while locked.
  void setAccent(SunriseAccent accent) {
    if (accent == state.accent) return;
    if (accent.isPremium && !state.premiumUnlocked) return;
    AnalyticsService().logThemeChange();
    state = state.copyWith(accent: accent);
    _persist(_accentKey, accent.storageName);
  }

  Future<void> _persist(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (_) {
      // Losing the preference is not worth interrupting the user for.
    }
  }

  void unlockPremiumThemes() {
    _subscribed = true;
    state = state.copyWith(premiumUnlocked: true);
  }

  /// Premium themes until [endsAt], bought with a rewarded ad. Extends an
  /// earlier trial rather than shortening it.
  Future<void> startTrial(DateTime endsAt) async {
    if (_trialEndsAt != null && !endsAt.isAfter(_trialEndsAt!)) return;
    _trialEndsAt = endsAt;
    _scheduleTrialEnd();
    state = state.copyWith(premiumUnlocked: true);
    await _persist(_trialKey, endsAt.toIso8601String());
  }

  void _scheduleTrialEnd() {
    _trialTimer?.cancel();
    final left = _trialEndsAt!.difference(DateTime.now());
    _trialTimer = Timer(left.isNegative ? Duration.zero : left, () {
      _trialEndsAt = null;
      if (!_subscribed) lockPremiumThemes();
    });
  }

  @override
  void dispose() {
    _trialTimer?.cancel();
    super.dispose();
  }

  /// Premium lapsed: back to Sunrise, keeping the brightness they chose.
  /// A trial still running keeps its themes until it ends.
  void lockPremiumThemes() {
    _subscribed = false;
    if (trialActive) return;
    final wasPremium = state.accent.isPremium;
    state = state.copyWith(
      premiumUnlocked: false,
      accent: wasPremium ? SunriseAccent.sunrise : state.accent,
    );
    // Persist the fallback too, or the next launch restores an accent the user
    // is no longer entitled to.
    if (wasPremium) _persist(_accentKey, SunriseAccent.sunrise.storageName);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
