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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: isSmallScreen ? 8 : 16),
              child: Column(
                children: [
                  // Hero Section - Feature Icon with glow
                  _buildHeroSection(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Feature Info
                  _buildFeatureInfo(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Benefits Grid
                  _buildBenefitsGrid(isSmallScreen),

                  const Spacer(),

                  // CTA Section
                  _buildCTASection(context, isSmallScreen),

                  SizedBox(height: isSmallScreen ? 8 : 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isSmallScreen) {
    final iconSize = isSmallScreen ? 80.0 : 100.0;
    final innerIconSize = isSmallScreen ? 40.0 : 50.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: iconSize + 40,
          height: iconSize + 40,
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
          child: Icon(
            featureIcon,
            size: innerIconSize,
            color: Colors.white,
          ),
        ),
        // Lock badge
        Positioned(
          bottom: 0,
          right: isSmallScreen ? 0 : 5,
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.warning, width: 2),
            ),
            child: Icon(
              Icons.lock_rounded,
              size: isSmallScreen ? 14 : 16,
              color: AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureInfo(bool isSmallScreen) {
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
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.5),
            ),
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

        SizedBox(height: isSmallScreen ? 12 : 16),

        // Feature name
        Text(
          featureName,
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: isSmallScreen ? 8 : 12),

        // Description
        Text(
          featureDescription,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 15,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBenefitsGrid(bool isSmallScreen) {
    final benefits = [
      _BenefitItem(Icons.smart_toy_outlined, 'AI Insights', AppColors.primaryAccent),
      _BenefitItem(Icons.sync_rounded, 'Cloud Sync', AppColors.neonCyan),
      _BenefitItem(Icons.palette_outlined, 'Themes', AppColors.neonPink),
      _BenefitItem(Icons.all_inclusive, 'Unlimited', AppColors.success),
    ];

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: benefits.map((b) => _buildBenefitItem(b, isSmallScreen)).toList(),
      ),
    );
  }

  Widget _buildBenefitItem(_BenefitItem benefit, bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSmallScreen ? 40 : 48,
          height: isSmallScreen ? 40 : 48,
          decoration: BoxDecoration(
            color: benefit.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            benefit.icon,
            size: isSmallScreen ? 20 : 24,
            color: benefit.color,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          benefit.label,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCTASection(BuildContext context, bool isSmallScreen) {
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
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
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
                Icon(Icons.diamond_rounded, color: Colors.white, size: isSmallScreen ? 20 : 22),
                const SizedBox(width: 10),
                Text(
                  'Unlock Premium',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 10 : 14),

        // Pricing hint
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 14, color: AppColors.success),
            const SizedBox(width: 6),
            Text(
              'One-time purchase • Lifetime access',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
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
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
