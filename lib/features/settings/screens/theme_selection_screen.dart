import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Appearance: Sunrise Light / Dark, Match system, and the accent swatches.
///
/// A premium accent swaps only the gradient, accent and wash, never the
/// layout, and applies to light and dark alike.
class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final theme = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final unlocked = ref.watch(premiumProvider).features.isUnlocked;
    final c = context.sunrise;
    final effective = theme.brightnessFor(MediaQuery.platformBrightnessOf(context));

    return SunrisePushPage(
      title: l10n.appearanceTitle,
      bottom: unlocked
          ? null
          : SunriseButton(
              label: l10n.themeUnlockAll,
              onPressed: () => Navigator.pushNamed(context, '/premium'),
            ),
      children: [
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                label: l10n.themeSunriseLight,
                preview: theme.colorsFor(Brightness.light),
                selected: effective == Brightness.light,
                onTap: () => notifier.setMode(ThemeMode.light),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModeCard(
                label: l10n.themeSunriseDark,
                preview: theme.colorsFor(Brightness.dark),
                selected: effective == Brightness.dark,
                onTap: () => notifier.setMode(ThemeMode.dark),
              ),
            ),
          ],
        ),
        const SizedBox(height: SunriseSpace.sectionTight),
        SunriseCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SettingsRow(
            icon: Symbols.contrast_rounded,
            iconBackground: Colors.transparent,
            title: l10n.themeMatchSystem,
            subtitle: l10n.themeMatchSystemHint,
            trailing: SettingsTrailing.none,
            onTap: () => notifier.setMode(
              theme.matchSystem ? effective.mode : ThemeMode.system,
            ),
            trailingWidget: SunriseToggle(
              value: theme.matchSystem,
              semanticLabel: l10n.themeMatchSystem,
              onChanged: (on) =>
                  notifier.setMode(on ? ThemeMode.system : effective.mode),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.themePremiumHeading,
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 20),
              ),
            ),
            const SizedBox(width: 10),
            SunrisePill(
              label: l10n.themeProBadge,
              gradient: c.gradient,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, box) {
            const gap = 12.0;
            final w = (box.maxWidth - gap * 2) / 3;
            return Wrap(
              spacing: gap,
              runSpacing: 16,
              children: [
                for (final accent in SunriseAccent.values)
                  SizedBox(
                    width: w,
                    child: _AccentSwatch(
                      accent: accent,
                      label: accentLabel(accent, l10n),
                      selected: theme.accent == accent,
                      locked: accent.isPremium && !unlocked,
                      onTap: () {
                        if (accent.isPremium && !unlocked) {
                          Navigator.pushNamed(context, '/premium');
                        } else {
                          notifier.setAccent(accent);
                        }
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// The accent's name as the user reads it (stored names stay English).
  static String accentLabel(SunriseAccent accent, L10n l10n) =>
      switch (accent) {
        SunriseAccent.sunrise => l10n.themeAccentSunrise,
        SunriseAccent.sapphire => l10n.themeAccentSapphire,
        SunriseAccent.emerald => l10n.themeAccentEmerald,
        SunriseAccent.ruby => l10n.themeAccentRuby,
        SunriseAccent.amethyst => l10n.themeAccentAmethyst,
        SunriseAccent.graphite => l10n.themeAccentGraphite,
      };

  /// "Sunrise Light", "Sapphire Dark", ... for the More screen.
  static String currentLabel(
    ThemeState theme,
    Brightness platform,
    L10n l10n,
  ) {
    final dark = theme.brightnessFor(platform) == Brightness.dark;
    if (theme.accent == SunriseAccent.sunrise) {
      return dark ? l10n.themeSunriseDark : l10n.themeSunriseLight;
    }
    return l10n.themeAppearanceValue(
      accentLabel(theme.accent, l10n),
      dark ? l10n.themeDark : l10n.themeLight,
    );
  }
}

extension on Brightness {
  ThemeMode get mode => this == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
}

/// A light or dark preview card with a selection ring.
class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.label,
    required this.preview,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final SunriseColors preview;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final p = preview;
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        haptic: true,
        child: AnimatedContainer(
          duration: SunriseMotion.press,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(SunriseRadius.card),
            border: Border.all(
              color: selected ? c.accent : Colors.transparent,
              width: 2,
            ),
            boxShadow: c.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1.05,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: p.base,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [p.washTop, p.washLow, p.base],
                      stops: const [0, .45, .8],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: .55,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: p.ink.withValues(alpha: .18),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: p.isDark
                                ? p.ink.withValues(alpha: .08)
                                : p.surface.withValues(alpha: .8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 18,
                        decoration: BoxDecoration(
                          gradient: p.gradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 4),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SunriseType.rowTitle.copyWith(color: c.ink),
                      ),
                    ),
                  ),
                  _Check(selected: selected),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return AnimatedContainer(
      duration: SunriseMotion.press,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? c.accent : Colors.transparent,
        border: selected ? null : Border.all(color: c.chevron, width: 1.6),
      ),
      child: selected
          ? const Icon(Symbols.check_rounded, size: 15, color: Colors.white, weight: 700)
          : null,
    );
  }
}

/// A gradient square for one accent, locked or selectable.
class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.accent,
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final SunriseAccent accent;
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final g = accent.swatch(Brightness.light).gradient;
    return Semantics(
      selected: selected,
      label: label,
      child: Pressable(
        onTap: onTap,
        haptic: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: SunriseMotion.press,
              padding: EdgeInsets.all(selected ? 3 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SunriseRadius.card + 3),
                border: Border.all(
                  color: selected ? c.accent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1.15,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: g,
                    ),
                    borderRadius: BorderRadius.circular(SunriseRadius.card),
                  ),
                  alignment: Alignment.center,
                  child: locked
                      ? const Icon(Symbols.lock_rounded, color: Colors.white, size: 26)
                      : selected
                      ? const Icon(
                          Symbols.check_circle_rounded,
                          color: Colors.white,
                          size: 28,
                          fill: 1,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.rowTitle.copyWith(color: c.ink),
            ),
          ],
        ),
      ),
    );
  }
}
