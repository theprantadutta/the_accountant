import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';

/// The light theme, and the indirection that finally makes one possible.
///
/// A light theme was defined in the codebase from the beginning and could never
/// be selected, because the widgets read colours from `AppColors` constants
/// rather than from `Theme.of(context)` — so changing the `ThemeData` changed
/// nothing anybody could see. What these tests hold is the replacement: the
/// names stayed, the values behind them became swappable, and both palettes are
/// now readable rather than only the one the app was drawn against.

/// WCAG relative luminance.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

/// WCAG contrast ratio between two opaque colours.
double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  // The palette is global, so a test that swaps it has to put it back or it
  // leaks into whatever runs next.
  tearDown(() => AppColors.usePalette(AppPalette.dark));

  group('swapping the palette', () {
    test('the colour behind a name changes with it', () {
      AppColors.usePalette(AppPalette.dark);
      final darkText = AppColors.textPrimary;
      final darkSurface = AppColors.primarySurface;

      AppColors.usePalette(AppPalette.light);

      expect(AppColors.textPrimary, isNot(darkText));
      expect(AppColors.primarySurface, isNot(darkSurface));
    });

    test('setting the same one again reports no change', () {
      AppColors.usePalette(AppPalette.light);

      expect(
        AppColors.usePalette(AppPalette.light),
        isFalse,
        reason:
            'this runs on every rebuild, and a repaint of the whole tree is '
            'too expensive to trigger for nothing',
      );
      expect(AppColors.usePalette(AppPalette.dark), isTrue);
    });

    test('the legacy palette is Sunrise underneath', () {
      expect(AppPalette.light.primaryDark, const Color(0xFFFFFAF6));
      expect(AppPalette.dark.primaryDark, const Color(0xFF140D0A));
      expect(AppPalette.light.primaryAccent, const Color(0xFFEA580C));
      expect(AppPalette.dark.textPrimary, const Color(0xFFFFF4EC));
    });
  });

  group('the two palettes', () {
    test('one is light and the other is dark, where it counts', () {
      expect(_luminance(AppPalette.light.primarySurface), greaterThan(0.7));
      expect(_luminance(AppPalette.dark.primarySurface), lessThan(0.1));
      expect(_luminance(AppPalette.light.textPrimary), lessThan(0.1));
      expect(_luminance(AppPalette.dark.textPrimary), greaterThan(0.7));
    });

    test('body text is readable on its own surface', () {
      for (final palette in [AppPalette.dark, AppPalette.light]) {
        expect(
          _contrast(palette.textPrimary, palette.primarySurface),
          greaterThanOrEqualTo(4.5),
          reason: '${palette.brightness} primary text fails WCAG AA',
        );
        expect(
          _contrast(palette.textSecondary, palette.primarySurface),
          greaterThanOrEqualTo(4.5),
          reason: '${palette.brightness} secondary text fails WCAG AA',
        );
      }
    });

    test('muted text still clears the large-text threshold', () {
      for (final palette in [AppPalette.dark, AppPalette.light]) {
        expect(
          _contrast(palette.textMuted, palette.primarySurface),
          greaterThanOrEqualTo(3.0),
          reason: '${palette.brightness} muted text is unreadable',
        );
      }
    });

    test('the accent and the status colours read on their surface', () {
      for (final palette in [AppPalette.dark, AppPalette.light]) {
        for (final entry in {
          'accent': palette.primaryAccent,
          'error': palette.error,
          'success': palette.success,
          'warning': palette.warning,
          'info': palette.info,
        }.entries) {
          expect(
            _contrast(entry.value, palette.primarySurface),
            greaterThanOrEqualTo(3.0),
            reason:
                '${palette.brightness} ${entry.key} is too close to the '
                'surface it is drawn on',
          );
        }
      }
    });

    test('white labels sit on the gradient, not on the bare accent', () {
      // Sunrise puts white button labels on the brand gradient, whose deep end
      // carries them; the flat accent is for icons and rings. The ThemeData
      // still says onPrimary is white for the stock buttons that use it.
      for (final c in [SunriseColors.light, SunriseColors.dark]) {
        expect(
          _contrast(const Color(0xFFFFFFFF), c.gradientEnd),
          greaterThanOrEqualTo(3.0),
        );
        expect(AppTheme.themeFor(c).colorScheme.onPrimary, Colors.white);
      }
    });

    test('category colours do not move between themes', () {
      // A category colour is the user's data, recognised by sight and shown
      // beside its own legend. Shifting it would make the same category look
      // like a different one.
      AppColors.usePalette(AppPalette.light);
      final inLight = [...AppColors.categoryColors];
      AppColors.usePalette(AppPalette.dark);

      expect(AppColors.categoryColors, inLight);
    });
  });

  group('choosing a theme', () {
    ThemeState stateFor(ThemeMode mode, [SunriseAccent? accent]) => ThemeState(
      mode: mode,
      accent: accent ?? SunriseAccent.sunrise,
      premiumUnlocked: true,
    );

    test('System follows the phone, the others ignore it', () {
      expect(
        stateFor(ThemeMode.system).paletteFor(Brightness.light),
        same(AppPalette.light),
      );
      expect(
        stateFor(ThemeMode.system).paletteFor(Brightness.dark),
        same(AppPalette.dark),
      );
      expect(
        stateFor(ThemeMode.light).paletteFor(Brightness.dark),
        same(AppPalette.light),
      );
      expect(
        stateFor(ThemeMode.dark).paletteFor(Brightness.light),
        same(AppPalette.dark),
      );
    });

    test('a premium accent reaches the legacy palette, light and dark', () {
      // This is what was broken: a premium theme used to be a separate
      // ThemeData that the AppColors call sites never read.
      for (final b in Brightness.values) {
        final sunrise = stateFor(ThemeMode.system).paletteFor(b);
        final sapphire = stateFor(
          ThemeMode.system,
          SunriseAccent.sapphire,
        ).paletteFor(b);
        expect(sapphire.primaryAccent, isNot(sunrise.primaryAccent));
        expect(sapphire.brightness, b);
        // Neutrals never move with the accent.
        expect(sapphire.textPrimary, sunrise.textPrimary);
        expect(sapphire.primarySurface, sunrise.primarySurface);
        expect(sapphire.success, sunrise.success);
      }
    });

    test('the mode is handed to MaterialApp unchanged', () {
      for (final m in ThemeMode.values) {
        expect(stateFor(m).themeMode, m);
      }
    });
  });

  group('every accent stays readable', () {
    for (final accent in SunriseAccent.values) {
      for (final b in Brightness.values) {
        test('${accent.name} ${b.name}', () {
          final c = SunriseColors.resolve(b, accent);
          expect(
            _contrast(c.accentText, c.base),
            greaterThanOrEqualTo(4.5),
            reason: 'accent text (links, values) must pass AA on the page',
          );
          expect(
            _contrast(c.accentText, c.surface),
            greaterThanOrEqualTo(4.5),
            reason: 'accent text must pass AA on cards',
          );
          expect(
            _contrast(c.accent, c.surface),
            greaterThanOrEqualTo(2.4),
            reason: 'icons and rings in the accent must stay visible',
          );
        });
      }
    }
  });

  group('the ThemeData built from the tokens', () {
    test('it declares the brightness it was built for', () {
      expect(
        AppTheme.themeFor(SunriseColors.light).brightness,
        Brightness.light,
      );
      expect(AppTheme.themeFor(SunriseColors.dark).brightness, Brightness.dark);
    });

    test('it carries the tokens as an extension', () {
      final theme = AppTheme.themeFor(SunriseColors.dark);
      expect(theme.extension<SunriseColors>(), same(SunriseColors.dark));
    });

    test('components are themed from the tokens', () {
      final c = SunriseColors.light;
      final light = AppTheme.themeFor(c);

      expect(light.colorScheme.surface, c.surface);
      expect(light.colorScheme.primary, c.accent);
      expect(light.cardTheme.color, c.surface);
      expect(light.dialogTheme.backgroundColor, c.base);
      expect(light.dividerTheme.color, c.divider);
    });

    test('the system bars are told which way round they are', () {
      final light = AppTheme.themeFor(SunriseColors.light);
      final dark = AppTheme.themeFor(SunriseColors.dark);

      expect(
        light.appBarTheme.systemOverlayStyle?.statusBarIconBrightness,
        Brightness.dark,
        reason: 'light icons on a light status bar cannot be seen',
      );
      expect(
        dark.appBarTheme.systemOverlayStyle?.statusBarIconBrightness,
        Brightness.light,
      );
    });

    test('lerp blends every colour rather than snapping', () {
      final mid = SunriseColors.light.lerp(SunriseColors.dark, .5);
      expect(mid.base, isNot(SunriseColors.light.base));
      expect(mid.base, isNot(SunriseColors.dark.base));
      expect(
        mid.ink,
        Color.lerp(SunriseColors.light.ink, SunriseColors.dark.ink, .5),
      );
    });
  });

  group('remembering the choice', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    Future<ThemeNotifier> reopen() async {
      final n = ThemeNotifier();
      // The restore is async and fires from the constructor.
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return n;
    }

    test('mode and accent survive a restart', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final notifier = ThemeNotifier()..unlockPremiumThemes();
      notifier.setMode(ThemeMode.light);
      notifier.setAccent(SunriseAccent.emerald);
      await Future<void>.delayed(Duration.zero);

      final reopened = await reopen();

      expect(reopened.state.mode, ThemeMode.light);
      expect(reopened.state.accent, SunriseAccent.emerald);
    });

    test('the default follows the phone, in Sunrise', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final state = ThemeNotifier().state;

      expect(state.mode, ThemeMode.system);
      expect(state.accent, SunriseAccent.sunrise);
    });

    test('an old Dark choice migrates to the dark mode', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({'selected_theme': 'Dark'});

      final n = await reopen();

      expect(n.state.mode, ThemeMode.dark);
      expect(n.state.accent, SunriseAccent.sunrise);
    });

    test('an old premium theme keeps its look: that accent, in dark', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({'selected_theme': 'Midnight'});

      final n = await reopen();

      expect(n.state.mode, ThemeMode.dark);
      expect(
        n.state.accent,
        SunriseAccent.graphite,
        reason: 'Midnight was renamed Graphite',
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_theme'), isNull);
    });

    test('a premium accent cannot be picked while locked', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final notifier = ThemeNotifier();

      notifier.setAccent(SunriseAccent.ruby);

      expect(notifier.state.accent, SunriseAccent.sunrise);
    });

    test('losing premium falls back to Sunrise and keeps the mode', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final notifier = ThemeNotifier()..unlockPremiumThemes();
      notifier.setMode(ThemeMode.light);
      notifier.setAccent(SunriseAccent.sapphire);

      notifier.lockPremiumThemes();

      expect(notifier.state.accent, SunriseAccent.sunrise);
      expect(notifier.state.mode, ThemeMode.light);
      expect(notifier.state.premiumUnlocked, isFalse);
    });
  });

  test('no screen paints itself white on the page any more', () {
    // The whole app used to say `Colors.white` for text, because the page was
    // always dark. Those are now the palette's foreground colour; what is left
    // sits on a coloured fill, where white is right in either theme.
    //
    // This is a ratchet rather than a style rule: one `Colors.white` on a page
    // is invisible in light mode and nothing in the test suite would otherwise
    // notice.
    final fill = RegExp(
      r'gradient:|gradientContainer'
      r'|backgroundColor: AppColors\.(primaryAccent|error|success|warning|info)'
      r'|color: AppColors\.(primaryAccent|error|success|warning|info)'
      r'|ElevatedButton\.styleFrom|FilledButton'
      r'|backgroundColor: Colors\.(black|transparent)'
      r'|Colors\.black\d*|CircleAvatar|backgroundColor: color'
      // Sunrise fills: the brand gradient and its variants, solid accent,
      // negative or positive buttons, and white-on-white knobs.
      r'|GradientCard|[gG]radient|onGradient|SunrisePill'
      r'|c\.(accent|negative|positive|glow)|destructive|shape: BoxShape\.circle',
    );

    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      // The palettes and accents are fixed sets of colours, not page chrome.
      if (path.contains('lib/core/themes/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (!lines[i].contains('Colors.white')) continue;
        final window = lines.sublist(math.max(0, i - 20), i + 1).join('\n');
        if (fill.hasMatch(window)) continue;
        offenders.add('$path:${i + 1}');
      }
    }

    expect(offenders, isEmpty);
  });
}
