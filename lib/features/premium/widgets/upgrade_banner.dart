import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/premium/utils/paywall_utils.dart';

enum UpgradeBannerStyle { standard, warning, locked }

/// Dismissible banner prompting the user to upgrade. Use one of the factory
/// constructors for common contexts (hit free-tier limit, feature locked,
/// grace period ending).
class UpgradeBanner extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final UpgradeBannerStyle style;
  final String ctaLabel;
  final String? featureName;

  const UpgradeBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.workspace_premium,
    this.style = UpgradeBannerStyle.standard,
    this.ctaLabel = 'Upgrade',
    this.featureName,
  });

  factory UpgradeBanner.limitReached({
    Key? key,
    required String resource,
    required int limit,
  }) {
    return UpgradeBanner(
      key: key,
      title: "You've reached your free limit",
      subtitle: 'Free users can keep $limit $resource. Upgrade for unlimited.',
      icon: Icons.block,
      style: UpgradeBannerStyle.warning,
      ctaLabel: 'Unlock Unlimited',
      featureName: resource,
    );
  }

  factory UpgradeBanner.featureLocked({Key? key, required String featureName}) {
    return UpgradeBanner(
      key: key,
      title: '$featureName is a Premium feature',
      subtitle: 'Upgrade to unlock this and everything else.',
      icon: Icons.lock_outline,
      style: UpgradeBannerStyle.locked,
      ctaLabel: 'Go Premium',
      featureName: featureName,
    );
  }

  factory UpgradeBanner.gracePeriodWarning({
    Key? key,
    required int daysRemaining,
  }) {
    return UpgradeBanner(
      key: key,
      title: 'Payment issue detected',
      subtitle: daysRemaining <= 0
          ? 'Your premium access ends today. Update payment to keep access.'
          : 'Your premium access ends in $daysRemaining day${daysRemaining == 1 ? '' : 's'}.',
      icon: Icons.warning_amber,
      style: UpgradeBannerStyle.warning,
      ctaLabel: 'Fix Payment',
    );
  }

  @override
  State<UpgradeBanner> createState() => _UpgradeBannerState();
}

class _UpgradeBannerState extends State<UpgradeBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final gradient = switch (widget.style) {
      UpgradeBannerStyle.standard => const LinearGradient(
        colors: [AppColors.primaryAccent, AppColors.neonPurple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      UpgradeBannerStyle.warning => LinearGradient(
        colors: [
          AppColors.error.withValues(alpha: 0.9),
          AppColors.errorDark.withValues(alpha: 0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      UpgradeBannerStyle.locked => const LinearGradient(
        colors: [Color(0xFF4A4A68), Color(0xFF2D2D42)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => PaywallUtils.showPaywall(
                        context,
                        featureName: widget.featureName,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(
                        widget.ctaLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => setState(() => _dismissed = true),
          ),
        ],
      ),
    );
  }
}
