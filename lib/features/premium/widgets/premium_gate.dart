import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// Widget that gates content behind premium subscription
/// Shows an upgrade prompt for free users, actual content for premium users
class PremiumGate extends ConsumerWidget {
  final String featureId;
  final String featureName;
  final String featureDescription;
  final IconData featureIcon;
  final Widget child;

  const PremiumGate({
    super.key,
    required this.featureId,
    required this.featureName,
    required this.featureDescription,
    required this.featureIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumProvider);

    if (premiumState.isPremium) {
      return child;
    }

    return _PremiumUpgradeScreen(
      featureName: featureName,
      featureDescription: featureDescription,
      featureIcon: featureIcon,
    );
  }
}

/// Upgrade prompt screen shown when a premium feature is accessed by free users
class _PremiumUpgradeScreen extends StatelessWidget {
  final String featureName;
  final String featureDescription;
  final IconData featureIcon;

  const _PremiumUpgradeScreen({
    required this.featureName,
    required this.featureDescription,
    required this.featureIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryAccent.withValues(alpha: 0.3),
                    AppColors.primaryAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonPurple.withValues(alpha: 0.2),
                    AppColors.neonPurple.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scale =
                    (constraints.maxHeight / 600).clamp(0.75, 1.0);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16 * scale,
                  ),
                  child: Column(
                    children: [
                      _buildHeroSection(scale),
                      SizedBox(height: 20 * scale),
                      _buildFeatureInfo(scale),
                      SizedBox(height: 20 * scale),
                      _buildBenefitsGrid(scale),
                      const Spacer(),
                      _buildCTASection(context, scale),
                      SizedBox(height: 16 * scale),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(double scale) {
    final iconSize = 80.0 * scale;
    final innerIconSize = 40.0 * scale;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: iconSize + 32 * scale,
          height: iconSize + 32 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryAccent.withValues(alpha: 0.2),
                AppColors.primaryAccent.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        // Main icon container
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(featureIcon, size: innerIconSize, color: Colors.white),
        ),
        // Lock badge
        Positioned(
          bottom: 0,
          right: 5 * scale,
          child: Container(
            padding: EdgeInsets.all(8 * scale),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.warning, width: 2),
            ),
            child: Icon(
              Icons.lock_rounded,
              size: 16 * scale,
              color: AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureInfo(double scale) {
    return Column(
      children: [
        // Premium badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.warning.withValues(alpha: 0.2),
                AppColors.neonPurple.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.diamond, size: 14, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                'PREMIUM FEATURE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16 * scale),

        // Feature name
        Text(
          featureName,
          style: TextStyle(
            fontSize: 28 * scale,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 12 * scale),

        // Description
        Text(
          featureDescription,
          style: TextStyle(
            fontSize: 14 + scale,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBenefitsGrid(double scale) {
    final benefits = [
      _BenefitItem(
        Icons.smart_toy_outlined,
        'AI Insights',
        AppColors.primaryAccent,
      ),
      _BenefitItem(Icons.sync_rounded, 'Cloud Sync', AppColors.neonCyan),
      _BenefitItem(Icons.palette_outlined, 'Themes', AppColors.neonPink),
      _BenefitItem(Icons.all_inclusive, 'Unlimited', AppColors.success),
    ];

    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: benefits
            .map((b) => _buildBenefitItem(b, scale))
            .toList(),
      ),
    );
  }

  Widget _buildBenefitItem(_BenefitItem benefit, double scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48 * scale,
          height: 48 * scale,
          decoration: BoxDecoration(
            color: benefit.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            benefit.icon,
            size: 24 * scale,
            color: benefit.color,
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          benefit.label,
          style: TextStyle(
            fontSize: 11 + scale,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCTASection(BuildContext context, double scale) {
    return Column(
      children: [
        // Main upgrade button
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamed(context, '/premium');
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16 * scale),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.diamond_rounded,
                  color: Colors.white,
                  size: 22 * scale,
                ),
                const SizedBox(width: 10),
                Text(
                  'Unlock Premium',
                  style: TextStyle(
                    fontSize: 17 * scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 14 * scale),

        // Pricing hint
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 14, color: AppColors.success),
            const SizedBox(width: 6),
            Text(
              'One-time purchase • Lifetime access',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _BenefitItem {
  final IconData icon;
  final String label;
  final Color color;

  _BenefitItem(this.icon, this.label, this.color);
}

/// Convenience widget for gating specific features
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

    return lockedPlaceholder ?? _buildLockedIndicator(context);
  }

  Widget _buildLockedIndicator(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/premium'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              'Premium',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
