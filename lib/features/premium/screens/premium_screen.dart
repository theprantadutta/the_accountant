import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/providers/iap_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/premium/services/iap_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The paywall: what Premium includes, a plan picker with real store prices,
/// and a sticky purchase button.
///
/// The mock shows lifetime only; the app sells monthly, yearly and lifetime,
/// so all three stay, picked first and then bought with the button. A plan
/// the store did not return is never shown.
class PremiumScreen extends ConsumerStatefulWidget {
  /// Optional name of the feature that triggered this paywall (e.g. "AI Chat").
  final String? triggerFeatureName;

  /// Overrides the default heading.
  final String? customTitle;

  /// Overrides the default tagline below the heading.
  final String? customDescription;

  const PremiumScreen({
    super.key,
    this.triggerFeatureName,
    this.customTitle,
    this.customDescription,
  });

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  /// The plan the button will buy.
  String? _chosenProductId;

  /// The plan a purchase is in flight for.
  String? _selectedProductId;
  String? _errorMessage;
  bool _purchaseCompleted = false;
  bool _emptyStateLogged = false;
  bool _unavailableLogged = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logPaywallShown(featureName: widget.triggerFeatureName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(iapNotifierProvider.notifier).loadProducts();
    });
  }

  @override
  void dispose() {
    if (!_purchaseCompleted) {
      AnalyticsService().logPaywallDismissed();
    }
    super.dispose();
  }

  void _listenForPurchases() {
    // Gate every branch on a status transition (previous != next): IAPState
    // updates several times after a purchase (verify, refresh, product
    // reload) and the listener must act once per event or it double-pops.
    ref.listen<IAPState>(iapNotifierProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        setState(() => _errorMessage = next.error);
        AnalyticsService().logPaywallPurchaseError(
          productId: _selectedProductId ?? 'unknown',
          stage: 'iap_state_error',
          error: next.error,
        );
      }

      if (previous?.lastPurchaseStatus == next.lastPurchaseStatus) return;

      switch (next.lastPurchaseStatus) {
        case PurchaseFlowStatus.canceled:
          AnalyticsService().logPaywallPurchaseCanceled(
            productId: _selectedProductId ?? 'unknown',
          );
        case PurchaseFlowStatus.error:
          AnalyticsService().logPaywallPurchaseError(
            productId: _selectedProductId ?? 'unknown',
            stage: 'purchase_status_error',
            error: next.error,
          );
        case PurchaseFlowStatus.purchased:
        case PurchaseFlowStatus.restored:
          AnalyticsService().logPremiumPurchase(productId: _selectedProductId);
          if (!mounted) return;
          _purchaseCompleted = true;
          final l10n = L10n.of(context);
          showSunriseSnack(
            context,
            next.lastPurchaseStatus == PurchaseFlowStatus.restored
                ? l10n.paywallRestored
                : l10n.paywallPurchased,
            tone: SnackTone.success,
          );
          // Back to the screen that asked for the upgrade.
          if (Navigator.of(context).canPop()) Navigator.of(context).pop(true);
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenForPurchases();
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final premiumState = ref.watch(premiumProvider);
    final iapState = ref.watch(iapNotifierProvider);
    final isPremium = premiumState.isPremium;

    PremiumProduct? productFor(String id) =>
        iapState.products.where((p) => p.id == id).firstOrNull;
    final plans = [
      ?_plan(productFor(PremiumProductIds.lifetime), l10n),
      ?_plan(productFor(PremiumProductIds.yearly), l10n),
      ?_plan(productFor(PremiumProductIds.monthly), l10n),
    ];
    final chosen =
        plans.where((p) => p.id == _chosenProductId).firstOrNull ??
        plans.where((p) => p.id == PremiumProductIds.lifetime).firstOrNull ??
        plans.firstOrNull;

    final busy = iapState.isLoading;
    final cta = !isPremium && chosen != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SunriseButton(
                label: chosen.cta,
                loading: busy && _selectedProductId == chosen.id,
                onPressed: busy ? null : () => _purchaseProduct(chosen.id),
              ),
              const SizedBox(height: 10),
              Text(
                chosen.id == PremiumProductIds.lifetime
                    ? l10n.paywallFootLifetime
                    : l10n.paywallFootSubscription,
                textAlign: TextAlign.center,
                style: SunriseType.label.copyWith(color: c.subtle),
              ),
            ],
          )
        : null;

    return SunrisePushPage(
      title: '',
      close: true,
      actions: [
        TextButton(
          onPressed: busy ? null : _restorePurchases,
          child: Text(
            busy ? l10n.paywallProcessing : l10n.paywallRestore,
            style: SunriseType.rowTitle.copyWith(
              color: c.accentText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      bottom: cta,
      children: [
        _Header(
          isPremium: isPremium,
          title:
              widget.customTitle ??
              (isPremium ? l10n.paywallActiveTitle : l10n.paywallTitle),
          tagline:
              widget.customDescription ??
              (isPremium ? l10n.paywallActiveTagline : l10n.paywallTagline),
          trigger: !isPremium && widget.triggerFeatureName != null
              ? l10n.paywallTriggered(widget.triggerFeatureName!)
              : null,
        ),
        const SizedBox(height: 22),
        if (isPremium) ...[
          _StatusCard(state: premiumState),
          const SizedBox(height: SunriseSpace.section),
        ],
        _FeatureGrid(unlocked: isPremium),
        if (!isPremium) ...[
          const SizedBox(height: 22),
          _iapBanner(iapState, l10n),
          for (final p in plans) ...[
            _PlanCard(
              plan: p,
              selected: p.id == chosen?.id,
              onTap: busy ? null : () => setState(() => _chosenProductId = p.id),
            ),
            const SizedBox(height: 10),
          ],
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          SunriseCard(
            color: c.tintRose,
            shadow: false,
            padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
            child: Row(
              children: [
                Icon(Symbols.error_rounded, color: c.negative),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: SunriseType.label.copyWith(color: c.ink),
                  ),
                ),
                IconButton(
                  icon: Icon(Symbols.close_rounded, color: c.subtle, size: 18),
                  onPressed: () => setState(() => _errorMessage = null),
                ),
              ],
            ),
          ),
        ],
        if (!isPremium) ...[
          const SizedBox(height: 14),
          Text(
            l10n.paywallTerms,
            textAlign: TextAlign.center,
            style: SunriseType.caption.copyWith(color: c.faint, fontSize: 11),
          ),
        ],
      ],
    );
  }

  _Plan? _plan(PremiumProduct? product, L10n l10n) {
    if (product == null) return null;
    String withTrial(String rest) => product.freeTrial == null
        ? rest
        : l10n.paywallTrial(product.freeTrial!, rest);
    return switch (product.id) {
      final id when id == PremiumProductIds.monthly => _Plan(
        id: product.id,
        title: l10n.premiumMonthly,
        price: product.price,
        period: l10n.paywallPerMonth,
        description: withTrial(l10n.paywallMonthlyDesc),
        cta: l10n.paywallCtaMonthly,
      ),
      final id when id == PremiumProductIds.yearly => _Plan(
        id: product.id,
        title: l10n.premiumYearly,
        price: product.price,
        period: l10n.paywallPerYear,
        description: withTrial(l10n.paywallYearlyDesc),
        cta: l10n.paywallCtaYearly,
        badge: l10n.paywallBestValue,
      ),
      _ => _Plan(
        id: product.id,
        title: l10n.premiumLifetime,
        price: product.price,
        period: l10n.paywallOnce,
        description: l10n.paywallLifetimeDesc,
        cta: l10n.paywallCtaLifetime,
        badge: l10n.paywallForever,
      ),
    };
  }

  /// Unavailable store, loading, or nothing returned: say so rather than
  /// leaving a paywall nobody can use.
  Widget _iapBanner(IAPState iapState, L10n l10n) {
    final c = context.sunrise;
    Widget banner(
      IconData icon,
      String message, {
      bool spinner = false,
      VoidCallback? retry,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SunriseCard(
        color: spinner ? c.tintOrange : c.tintRose,
        shadow: false,
        child: Row(
          children: [
            if (spinner)
              const SizedBox(width: 22, height: 22, child: SunriseLoader(size: 20))
            else
              Icon(icon, color: c.negative),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: SunriseType.label.copyWith(color: c.ink),
              ),
            ),
            if (retry != null)
              TextButton(onPressed: retry, child: Text(l10n.paywallTryAgain)),
          ],
        ),
      ),
    );

    if (!ref.watch(iapAvailableProvider)) {
      if (!_unavailableLogged) {
        _unavailableLogged = true;
        AnalyticsService().logPaywallIapUnavailable();
      }
      return banner(Symbols.warning_rounded, l10n.paywallIapUnavailable);
    }
    if (iapState.isLoading && iapState.products.isEmpty) {
      return banner(Symbols.hourglass_top_rounded, l10n.paywallLoadingPlans,
          spinner: true);
    }
    if (iapState.products.isEmpty) {
      if (!_emptyStateLogged) {
        _emptyStateLogged = true;
        AnalyticsService().logPaywallProductsEmpty();
      }
      return banner(
        Symbols.cloud_off_rounded,
        l10n.paywallPlansFailed,
        retry: () => ref.read(iapNotifierProvider.notifier).loadProducts(),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _purchaseProduct(String productId) async {
    HapticFeedback.mediumImpact();
    AnalyticsService().logPaywallPurchaseStarted(productId: productId);
    setState(() {
      _selectedProductId = productId;
      _errorMessage = null;
    });

    final success = await ref
        .read(iapNotifierProvider.notifier)
        .purchase(productId);

    if (!success && mounted) {
      AnalyticsService().logPaywallPurchaseError(
        productId: productId,
        stage: 'buy_request_failed',
      );
      setState(() => _selectedProductId = null);
    }
  }

  Future<void> _restorePurchases() async {
    HapticFeedback.mediumImpact();
    setState(() => _errorMessage = null);
    await ref.read(iapNotifierProvider.notifier).restorePurchases();
  }
}

class _Plan {
  const _Plan({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    required this.description,
    required this.cta,
    this.badge,
  });

  final String id;
  final String title;
  final String price;
  final String period;
  final String description;
  final String cta;
  final String? badge;
}

class _Header extends StatelessWidget {
  const _Header({
    required this.isPremium,
    required this.title,
    required this.tagline,
    this.trigger,
  });

  final bool isPremium;
  final String title;
  final String tagline;
  final String? trigger;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            gradient: c.gradient,
            borderRadius: BorderRadius.circular(26),
            boxShadow: c.gradientShadow,
          ),
          child: Icon(
            isPremium ? Symbols.verified_rounded : Symbols.workspace_premium_rounded,
            color: c.onFill,
            size: 44,
            fill: 1,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: SunriseType.heroTitle.copyWith(color: c.ink),
        ),
        const SizedBox(height: 6),
        Text(
          tagline,
          textAlign: TextAlign.center,
          style: SunriseType.body.copyWith(color: c.muted, fontSize: 16),
        ),
        if (trigger != null) ...[
          const SizedBox(height: 12),
          SunrisePill(label: trigger!, icon: Symbols.lock_rounded),
        ],
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});

  final PremiumState state;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final days = state.daysRemaining;
    return GradientCard(
      child: Row(
        children: [
          Icon(Symbols.verified_rounded, fill: 1, size: 30, color: c.onFill),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.tier.displayName,
                  style: SunriseType.section.copyWith(color: c.onFill),
                ),
                if (state.tier == SubscriptionTier.premiumLifetime)
                  Text(
                    l10n.paywallLifetimeNever,
                    style: SunriseType.label.copyWith(
                      color: c.onFill.withValues(alpha: .9),
                    ),
                  )
                else if (days != null)
                  Text(
                    l10n.paywallDaysRemaining(days),
                    style: SunriseType.label.copyWith(
                      color: c.onFill.withValues(alpha: .9),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// What Premium includes, two to a row.
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.unlocked});

  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final features = [
      (Symbols.auto_awesome_rounded, l10n.paywallFeatAi, l10n.paywallFeatAiSub),
      (Symbols.document_scanner_rounded, l10n.paywallFeatOcr, l10n.paywallFeatOcrSub),
      (Symbols.cloud_sync_rounded, l10n.paywallFeatSync, l10n.paywallFeatSyncSub),
      (Symbols.insights_rounded, l10n.paywallFeatInsights, l10n.paywallFeatInsightsSub),
      (Symbols.palette_rounded, l10n.paywallFeatThemes, l10n.paywallFeatThemesSub),
      (Symbols.all_inclusive_rounded, l10n.paywallFeatUnlimited, l10n.paywallFeatUnlimitedSub),
      (Symbols.picture_as_pdf_rounded, l10n.paywallFeatPdf, l10n.paywallFeatPdfSub),
      (Symbols.support_agent_rounded, l10n.paywallFeatSupport, l10n.paywallFeatSupportSub),
    ];
    return LayoutBuilder(
      builder: (context, box) {
        final w = (box.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final (icon, title, sub) in features)
              SizedBox(
                width: w,
                child: SunriseCard(
                  radius: 18,
                  padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                  child: Row(
                    children: [
                      Icon(icon, color: c.accent, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: SunriseType.rowTitle.copyWith(color: c.ink),
                            ),
                            Text(
                              sub,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: SunriseType.caption.copyWith(
                                color: c.subtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (unlocked)
                        Icon(
                          Symbols.check_circle_rounded,
                          fill: 1,
                          size: 18,
                          color: c.positive,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// One plan: radio, name, description, store price.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final _Plan plan;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Semantics(
      selected: selected,
      button: true,
      child: Pressable(
        onTap: onTap,
        haptic: true,
        child: AnimatedContainer(
          duration: SunriseMotion.press,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: selected ? c.tintOrange : c.surface,
            borderRadius: SunriseRadius.cardAll,
            border: Border.all(
              color: selected ? c.accent : Colors.transparent,
              width: 2,
            ),
            boxShadow: selected ? null : c.cardShadow,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: SunriseMotion.press,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? c.accent : Colors.transparent,
                  border: selected
                      ? null
                      : Border.all(color: c.chevron, width: 1.6),
                ),
                child: selected
                    ? Icon(
                        Symbols.check_rounded,
                        size: 15,
                        color: c.onFill,
                        weight: 700,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SunriseType.rowTitle.copyWith(
                              color: c.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (plan.badge != null) ...[
                          const SizedBox(width: 8),
                          SunrisePill(
                            label: plan.badge!,
                            gradient: c.gradient,
                            fontSize: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plan.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: SunriseType.caption.copyWith(color: c.subtle),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.price,
                    style: SunriseType.statValue.copyWith(
                      color: c.ink,
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    plan.period,
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
