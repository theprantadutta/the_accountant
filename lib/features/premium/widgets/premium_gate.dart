import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(featureName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Feature icon with lock overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      featureIcon,
                      size: 60,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Feature name
              Text(
                featureName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                featureDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Upgrade button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/premium'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.diamond_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Benefits
              _buildBenefitRow(Icons.sync, 'Sync across devices'),
              _buildBenefitRow(Icons.smart_toy, 'AI-powered insights'),
              _buildBenefitRow(Icons.all_inclusive, 'Unlimited everything'),
              _buildBenefitRow(Icons.palette, 'Premium themes'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
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
