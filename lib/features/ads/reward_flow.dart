import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/premium/utils/paywall_utils.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Offers a rewarded ad for [kind] and, if the user agrees and watches it,
/// delivers the reward. True when the reward landed.
///
/// The user always decides: the sheet says plainly that an ad is coming and
/// asks before anything plays. It also says, every time, that Premium gets
/// the same thing with no ads, and offers that instead.
Future<bool> earnWithAd(
  BuildContext context,
  WidgetRef ref,
  RewardKind kind,
) async {
  final l10n = L10n.of(context);
  final quota = ref.read(aiQuotaProvider);

  if (!quota.canWatchAd && !quota.unlimited) {
    showSunriseSnack(context, l10n.adDailyCapReached, tone: SnackTone.info);
    return false;
  }

  final choice = await showSunriseSheet<_Choice>(
    context: context,
    builder: (sheet) => _RewardSheet(
      kind: kind,
      adsLeft: quota.maxAdsPerDay - quota.adsWatched,
    ),
  );

  if (!context.mounted) return false;
  if (choice == _Choice.premium) {
    await PaywallUtils.showPaywall(context);
    return false;
  }
  if (choice != _Choice.watch) return false;

  final userId = ref.read(authProvider).userId;
  final result = await _withLoading(
    context,
    l10n.adLoading,
    RewardedAds.instance.show(kind, userId: userId),
  );
  if (!context.mounted) return false;

  switch (result.outcome) {
    case AdOutcome.unavailable:
      showSunriseSnack(context, l10n.adUnavailable, tone: SnackTone.info);
      return false;
    case AdOutcome.skipped:
      showSunriseSnack(context, l10n.adSkipped, tone: SnackTone.info);
      return false;
    case AdOutcome.earned:
      break;
  }

  final quotaNotifier = ref.read(aiQuotaProvider.notifier);
  try {
    final claim = await ref
        .read(aiApiProvider)
        .claimReward(
          rewardType: kind.wire,
          clientRewardId: const Uuid().v4(),
          adUnitId: result.adUnitId,
        );
    quotaNotifier.apply(claim.quota);

    if (claim.outcome == 'pending_verification') {
      // AdMob tells the server directly; give it a moment to arrive.
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(const Duration(seconds: 2));
        await quotaNotifier.refresh();
      }
    }
    if (!context.mounted) return false;

    if (claim.outcome == 'daily_cap_reached') {
      showSunriseSnack(context, l10n.adDailyCapReached, tone: SnackTone.info);
      return false;
    }

    showSunriseSnack(context, switch (kind) {
      RewardKind.aiCall => l10n.adRewardAiCall,
      RewardKind.themeTrial => l10n.adRewardTheme,
      RewardKind.pdfExport => l10n.adRewardPdf,
    }, tone: SnackTone.success);
    return true;
  } catch (_) {
    await quotaNotifier.refresh();
    if (context.mounted) {
      showSunriseSnack(context, l10n.adRewardPending, tone: SnackTone.info);
    }
    return false;
  }
}

enum _Choice { watch, premium }

/// Covers the screen while the ad loads, so a second tap cannot start another.
Future<T> _withLoading<T>(
  BuildContext context,
  String label,
  Future<T> work,
) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => PopScope(
      canPop: false,
      child: Center(
        child: SunriseCard(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 22, height: 22, child: SunriseLoader()),
              const SizedBox(width: 14),
              Text(label, style: SunriseType.label),
            ],
          ),
        ),
      ),
    ),
  );
  try {
    return await work;
  } finally {
    navigator.pop();
  }
}

class _RewardSheet extends StatelessWidget {
  const _RewardSheet({required this.kind, required this.adsLeft});

  final RewardKind kind;
  final int adsLeft;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;

    final (title, body, icon) = switch (kind) {
      RewardKind.aiCall => (
        l10n.adConfirmTitleAiCall,
        l10n.adConfirmBodyAiCall,
        Symbols.auto_awesome_rounded,
      ),
      RewardKind.themeTrial => (
        l10n.adConfirmTitleTheme,
        l10n.adConfirmBodyTheme,
        Symbols.palette_rounded,
      ),
      RewardKind.pdfExport => (
        l10n.adConfirmTitlePdf,
        l10n.adConfirmBodyPdf,
        Symbols.picture_as_pdf_rounded,
      ),
    };

    return SunriseBottomSheet(
      actions: [
        SunriseButton(
          label: l10n.adWatch,
          icon: Symbols.play_circle_rounded,
          onPressed: () => Navigator.pop(context, _Choice.watch),
        ),
        SunriseButton(
          label: l10n.adGetPremium,
          icon: Symbols.workspace_premium_rounded,
          style: SunriseButtonStyle.secondary,
          onPressed: () => Navigator.pop(context, _Choice.premium),
        ),
        SunriseButton(
          label: l10n.adNotNow,
          style: SunriseButtonStyle.ghost,
          onPressed: () => Navigator.pop(context),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(icon: icon, color: c.accent, size: 48, fill: 1),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: SunriseType.section.copyWith(
                    color: c.ink,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(body, style: SunriseType.body.copyWith(color: c.body)),
          const SizedBox(height: 14),
          // The plain warning, before anything plays.
          SunriseCard(
            shadow: false,
            color: c.tintPeach,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Symbols.smart_display_rounded, color: c.accent, fill: 1),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.adConfirmWarning,
                        style: SunriseType.label.copyWith(color: c.ink),
                      ),
                      if (kind == RewardKind.aiCall) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.adConfirmLeft(adsLeft),
                          style: SunriseType.caption.copyWith(color: c.muted),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Symbols.workspace_premium_rounded,
                size: 18,
                color: c.accent,
                fill: 1,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.adPremiumPitch,
                  style: SunriseType.caption.copyWith(color: c.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
