import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';

/// Branded header shared by the auth screens: a glowing, optionally-floating
/// app logo wrapped in concentric accent rings, the "The Accountant" wordmark,
/// and a screen-specific [title] / [subtitle].
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradient = AppColors.primaryGradient,
    this.glowColor = AppColors.primaryGlow,
    this.floatingAnimation,
    this.showWordmark = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final Color glowColor;

  /// Optional vertical-offset animation to make the logo gently float.
  final Animation<double>? floatingAnimation;

  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogo(),
        AppSpacing.gapXl,
        if (showWordmark) ...[
          Text(
            'THE ACCOUNTANT',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 4,
            ),
          ),
          AppSpacing.gapSm,
        ],
        Text(
          title,
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapSm,
        Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogo() {
    final logo = Container(
      width: 128,
      height: 128,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Faint outermost ring.
        border: Border.all(color: glowColor.withValues(alpha: 0.12)),
      ),
      child: Container(
        width: 104,
        height: 104,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: glowColor.withValues(alpha: 0.22)),
        ),
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.5),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, size: 42, color: AppColors.textPrimary),
        ),
      ),
    );

    if (floatingAnimation == null) {
      return Center(child: logo);
    }

    return Center(
      child: AnimatedBuilder(
        animation: floatingAnimation!,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, floatingAnimation!.value),
          child: child,
        ),
        child: logo,
      ),
    );
  }
}
