import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_theme.dart';

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

    test('the default is the palette the app was drawn against', () {
      expect(AppPalette.dark.primaryDark, const Color(0xFF0D0D1A));
      expect(AppPalette.dark.textPrimary, const Color(0xFFF8FAFC));
      expect(AppPalette.dark.primaryAccent, const Color(0xFF6366F1));
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

    test('white on the accent works either way', () {
      // Buttons keep white labels in both themes rather than following the
      // palette, so the accent has to stay dark enough to carry them.
      for (final palette in [AppPalette.dark, AppPalette.light]) {
        expect(
          _contrast(const Color(0xFFFFFFFF), palette.primaryAccent),
          greaterThanOrEqualTo(4.0),
          reason: '${palette.brightness} accent cannot carry a white label',
        );
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
    ThemeState stateFor(String theme) => ThemeState(
      currentTheme: theme,
      isPremiumTheme: false,
      availableThemes: BaseThemes.all,
    );

    test('System follows the phone', () {
      expect(
        stateFor(BaseThemes.system).paletteFor(Brightness.light),
        AppPalette.light,
      );
      expect(
        stateFor(BaseThemes.system).paletteFor(Brightness.dark),
        AppPalette.dark,
      );
    });

    test('Light and Dark ignore it, which is the point of choosing', () {
      expect(
        stateFor(BaseThemes.light).paletteFor(Brightness.dark),
        AppPalette.light,
      );
      expect(
        stateFor(BaseThemes.dark).paletteFor(Brightness.light),
        AppPalette.dark,
      );
    });

    test('a premium theme, or a name from a later build, is dark', () {
      expect(
        stateFor('Sapphire').paletteFor(Brightness.light),
        AppPalette.dark,
      );
      expect(
        stateFor('SomethingFromTheFuture').paletteFor(Brightness.light),
        AppPalette.dark,
      );
    });

    test('the mode handed to MaterialApp matches the choice', () {
      expect(stateFor(BaseThemes.system).themeMode, ThemeMode.system);
      expect(stateFor(BaseThemes.light).themeMode, ThemeMode.light);
      expect(stateFor(BaseThemes.dark).themeMode, ThemeMode.dark);
      expect(stateFor('Ruby').themeMode, ThemeMode.dark);
    });
  });

  group('the ThemeData built from a palette', () {
    test('it declares the brightness it was built for', () {
      expect(AppTheme.themeFor(AppPalette.light).brightness, Brightness.light);
      expect(AppTheme.themeFor(AppPalette.dark).brightness, Brightness.dark);
    });

    test('the light theme is themed, not a bare colour scheme', () {
      // It used to be four lines: a seeded scheme and nothing else. Even had it
      // been reachable, it would have themed none of the components the dark
      // theme themes.
      final light = AppTheme.themeFor(AppPalette.light);

      expect(light.colorScheme.surface, AppPalette.light.primarySurface);
      expect(light.cardTheme.color, AppPalette.light.primarySurface);
      expect(
        light.dialogTheme.backgroundColor,
        AppPalette.light.primarySurface,
      );
      expect(
        light.dividerTheme.color,
        AppPalette.light.divider,
        reason: 'the dark divider is invisible on a white card',
      );
    });

    test('the system bars are told which way round they are', () {
      final light = AppTheme.themeFor(AppPalette.light);
      final dark = AppTheme.themeFor(AppPalette.dark);

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

    test('a button label stays white on the accent', () {
      for (final palette in [AppPalette.dark, AppPalette.light]) {
        expect(AppTheme.themeFor(palette).colorScheme.onPrimary, Colors.white);
      }
    });
  });

  group('remembering the choice', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('System survives a restart', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final notifier = ThemeNotifier();
      notifier.setTheme(BaseThemes.system);

      final reopened = ThemeNotifier();
      // The restore is async and fires from the constructor.
      await Future<void>.delayed(Duration.zero);

      expect(reopened.state.currentTheme, BaseThemes.system);
    });

    test('the default is Dark, not System', () {
      TestWidgetsFlutterBinding.ensureInitialized();

      expect(
        ThemeNotifier().state.currentTheme,
        BaseThemes.dark,
        reason:
            'every existing install is looking at dark; defaulting to System '
            'would turn the app light for anybody whose phone is, without '
            'their having asked for anything',
      );
    });

    test('losing a subscription falls back to a theme that still exists', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final notifier = ThemeNotifier();
      notifier.unlockPremiumThemes();
      notifier.setTheme('Sapphire');

      notifier.lockPremiumThemes();

      expect(notifier.state.currentTheme, BaseThemes.dark);
      expect(notifier.state.availableThemes, BaseThemes.all);
    });

    test('a base theme is kept when premium lapses', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final notifier = ThemeNotifier();
      notifier.setTheme(BaseThemes.light);

      notifier.lockPremiumThemes();

      expect(notifier.state.currentTheme, BaseThemes.light);
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
      r'|Colors\.black\d*|CircleAvatar|backgroundColor: color',
    );

    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      // The palettes and the premium ThemeData are fixed sets of colours, not
      // page chrome.
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
