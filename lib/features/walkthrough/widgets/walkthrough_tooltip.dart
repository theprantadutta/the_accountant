import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

class WalkthroughTooltip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int currentStep;
  final int totalSteps;
  final bool isLastStep;
  final VoidCallback? onSkip;

  const WalkthroughTooltip({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.currentStep,
    required this.totalSteps,
    this.isLastStep = false,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GlassCard(
        variant: GlassCardVariant.accent,
        enableBlur: true,
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: AppSpacing.iconSm,
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapMd,
            // Description
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapLg,
            // Step dots + Skip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Step dots
                Row(
                  children: List.generate(totalSteps, (index) {
                    final isActive = index == currentStep;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: AppSpacing.xs),
                      width: isActive ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryAccent
                            : AppColors.textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                // Skip text (not on last step)
                if (!isLastStep)
                  GestureDetector(
                    onTap: onSkip,
                    child: Text(
                      'Skip',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
