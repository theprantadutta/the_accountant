import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/features/ads/reward_flow.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// White in the theme previews: part of the fixed preview art, not page chrome.
const _previewWhite = Color(0xFFFFFFFF);

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
    final subscribed = ref.watch(premiumProvider).features.isUnlocked;
    // A subscription, or a trial earned by watching an ad.
    final unlocked = theme.premiumUnlocked;
    final trialEnds = subscribed ? null : notifier.trialEndsAt;
    final c = context.sunrise;
    final effective = theme.brightnessFor(
      MediaQuery.platformBrightnessOf(context),
    );

    return SunrisePushPage(
      title: l10n.appearanceTitle,
      bottom: subscribed
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
                label: theme.accent == SunriseAccent.sunrise
                    ? l10n.themeSunriseLight
                    : l10n.themeAppearanceValue(
                        accentLabel(theme.accent, l10n),
                        l10n.themeLight,
                      ),
                preview: theme.colorsFor(Brightness.light),
                selected: effective == Brightness.light,
                onTap: () => notifier.setMode(ThemeMode.light),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModeCard(
                label: theme.accent == SunriseAccent.sunrise
                    ? l10n.themeSunriseDark
                    : l10n.themeAppearanceValue(
                        accentLabel(theme.accent, l10n),
                        l10n.themeDark,
                      ),
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
        if (trialEnds != null) ...[
          const SizedBox(height: 10),
          SunrisePill(
            icon: Symbols.timer_rounded,
            label: l10n.themeTrialUntil(
              DateFormat.jm(
                Localizations.localeOf(context).toString(),
              ).format(trialEnds),
            ),
          ),
        ],
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, box) {
            const gap = 12.0;
            final w = (box.maxWidth - gap) / 2;
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
                          _tryAccent(context, ref, accent);
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

  /// A locked accent: watch an ad for a day of every premium theme, starting
  /// with this one, or go Premium.
  static Future<void> _tryAccent(
    BuildContext context,
    WidgetRef ref,
    SunriseAccent accent,
  ) async {
    final earned = await earnWithAd(context, ref, RewardKind.themeTrial);
    if (!earned) return;

    await ref.read(aiQuotaProvider.notifier).refresh();
    final ends =
        ref.read(aiQuotaProvider).themeTrialEndsAt ??
        DateTime.now().add(const Duration(hours: 24));
    final theme = ref.read(themeProvider.notifier);
    await theme.startTrial(ends);
    theme.setAccent(accent);
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
  static String currentLabel(ThemeState theme, Brightness platform, L10n l10n) {
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
  ThemeMode get mode =>
      this == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
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
  const _Check({required this.selected, this.color});

  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return AnimatedContainer(
      duration: SunriseMotion.press,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? (color ?? c.accent) : Colors.transparent,
        border: selected ? null : Border.all(color: c.chevron, width: 1.6),
      ),
      child: selected
          ? const Icon(
              Symbols.check_rounded,
              size: 15,
              color: _previewWhite,
              weight: 700,
            )
          : null,
    );
  }
}

/// A theme shown as the app wearing it: the wash, a gradient balance card,
/// a couple of rows and the tab bar, in that accent and the current mode.
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
    final p = SunriseColors.resolve(c.brightness, accent);
    final card = p.isDark ? const Color(0xFF221813) : _previewWhite;

    Widget bar(double w, Color color, {double h = 6}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(h / 2),
      ),
    );

    final preview = ClipRRect(
      borderRadius: BorderRadius.circular(SunriseRadius.card - 4),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: p.washTall, color: p.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bar(46, p.ink.withValues(alpha: .55), h: 7),
                    const SizedBox(height: 6),
                    // The hero card in the accent's gradient.
                    Container(
                      width: double.infinity,
                      height: 40,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: p.gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 6),
                            blurRadius: 12,
                            spreadRadius: -6,
                            color: p.glow.withValues(alpha: .7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          bar(26, _previewWhite.withValues(alpha: .7), h: 4),
                          bar(52, _previewWhite, h: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final w in [42.0, 30.0]) ...[
                      Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: p.tintOrange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: p.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            bar(w, p.ink.withValues(alpha: .3), h: 4),
                            const Spacer(),
                            bar(14, p.ink.withValues(alpha: .5), h: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ],
                ),
              ),
            ),
            // Tab bar with the accent's active tab and Add pill.
            Container(
              height: 18,
              color: p.tabBar,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: p.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  bar(6, p.faint.withValues(alpha: .6)),
                  Container(
                    width: 16,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: p.gradient,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  bar(6, p.faint.withValues(alpha: .6)),
                  bar(6, p.faint.withValues(alpha: .6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Pressable(
        onTap: onTap,
        haptic: true,
        child: AnimatedContainer(
          duration: SunriseMotion.press,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(SunriseRadius.card),
            border: Border.all(
              color: selected ? p.accent : Colors.transparent,
              width: 2,
            ),
            boxShadow: c.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 150,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    preview,
                    if (locked)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Symbols.lock_rounded,
                            size: 15,
                            color: _previewWhite,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 4, 4),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        gradient: p.gradientShort,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SunriseType.rowTitle.copyWith(color: c.ink),
                      ),
                    ),
                    _Check(selected: selected, color: p.accent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
