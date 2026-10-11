import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/premium/utils/paywall_utils.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Gates content behind premium: the content for premium users, the Sunrise
/// locked screen for everyone else.
class PremiumGate extends ConsumerWidget {
  final String featureId;
  final String featureName;
  final String featureDescription;
  final IconData featureIcon;
  final Widget child;

  /// Replaces [featureName] as the big title ("Meet your money coach").
  final String? headline;

  /// A taste of the feature under the description (a sample chat).
  final Widget? preview;

  /// Short highlights shown as chips.
  final List<String> highlights;

  const PremiumGate({
    super.key,
    required this.featureId,
    required this.featureName,
    required this.featureDescription,
    required this.featureIcon,
    required this.child,
    this.headline,
    this.preview,
    this.highlights = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumProvider);

    if (premiumState.isPremium) {
      return child;
    }

    return _PremiumUpgradeScreen(
      featureName: featureName,
      headline: headline ?? featureName,
      featureDescription: featureDescription,
      featureIcon: featureIcon,
      preview: preview,
      highlights: highlights,
    );
  }
}

void _openPaywall(BuildContext context, {String? featureName}) {
  PaywallUtils.showPaywall(context, featureName: featureName);
}

/// The locked state: a glowing orb with a lock, the pitch, and Unlock.
class _PremiumUpgradeScreen extends StatelessWidget {
  final String featureName;
  final String headline;
  final String featureDescription;
  final IconData featureIcon;
  final Widget? preview;
  final List<String> highlights;

  const _PremiumUpgradeScreen({
    required this.featureName,
    required this.headline,
    required this.featureDescription,
    required this.featureIcon,
    required this.preview,
    required this.highlights,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final canPop = Navigator.of(context).canPop();

    return SunriseBackground(
      tall: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SunriseContentWidth(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SunriseSpace.screenX,
                    SunriseSpace.screenTop,
                    SunriseSpace.screenX,
                    0,
                  ),
                  child: Row(
                    children: [
                      if (canPop)
                        SunriseIconButton(
                          icon: Symbols.arrow_back_rounded,
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                      const Spacer(),
                      SunrisePill(
                        label: l10n.gatePremium,
                        icon: Symbols.workspace_premium_rounded,
                        fontSize: 14,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      SunriseSpace.screenX,
                      8,
                      SunriseSpace.screenX,
                      24,
                    ),
                    children: [
                      Center(child: _Orb(icon: featureIcon)),
                      const SizedBox(height: 22),
                      Text(
                        headline,
                        textAlign: TextAlign.center,
                        style: SunriseType.heroTitle.copyWith(color: c.ink),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        featureDescription,
                        textAlign: TextAlign.center,
                        style: SunriseType.body.copyWith(
                          color: c.muted,
                          fontSize: 16,
                        ),
                      ),
                      if (preview != null) ...[
                        const SizedBox(height: 22),
                        preview!,
                      ],
                      if (highlights.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final h in highlights)
                              SunriseChip(
                                label: h,
                                selected: false,
                                onTap: null,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SunriseSpace.screenX,
                    0,
                    SunriseSpace.screenX,
                    16,
                  ),
                  child: Column(
                    children: [
                      SunriseButton(
                        label: l10n.gateUnlock,
                        onPressed: () =>
                            _openPaywall(context, featureName: featureName),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.check_circle_rounded,
                            size: 18,
                            fill: 1,
                            color: c.positive,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.gateFootnote,
                              textAlign: TextAlign.center,
                              style: SunriseType.label.copyWith(
                                color: c.subtle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The 128dp radial orb with two halo rings and a lock badge.
class _Orb extends StatelessWidget {
  const _Orb({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SizedBox(
      width: 188,
      height: 188,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 188,
            height: 188,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.gradientMid.withValues(alpha: .05),
            ),
          ),
          Container(
            width: 156,
            height: 156,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.gradientMid.withValues(alpha: .10),
            ),
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: c.orbGradient,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 30),
                  blurRadius: 60,
                  spreadRadius: -20,
                  color: c.glow.withValues(alpha: .8),
                ),
              ],
            ),
            child: Icon(icon, size: 56, color: c.onFill, fill: 1),
          ),
          Positioned(
            right: 26,
            bottom: 26,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: c.surface,
                shape: BoxShape.circle,
                boxShadow: c.cardShadow,
              ),
              child: Icon(
                Symbols.lock_rounded,
                color: c.accent,
                size: 22,
                fill: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline lock chip for gating a single control.
class PremiumFeatureGate extends ConsumerWidget {
  final String featureId;
  final Widget child;
  final Widget? lockedPlaceholder;

  const PremiumFeatureGate({
    super.key,
    required this.featureId,
    required this.child,
    this.lockedPlaceholder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumProvider);

    if (premiumState.isPremium) {
      return child;
    }

    return lockedPlaceholder ??
        Pressable(
          onTap: () => _openPaywall(context),
          child: SunrisePill(
            label: L10n.of(context).premiumPremium,
            icon: Symbols.lock_rounded,
          ),
        );
  }
}
