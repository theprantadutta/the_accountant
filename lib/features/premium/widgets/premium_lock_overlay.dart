import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';

/// Small chip indicating premium status on a feature title.
class PremiumBadge extends StatelessWidget {
  final bool isPremium;
  final bool showLabel;
  final double? iconSize;

  const PremiumBadge({
    super.key,
    required this.isPremium,
    this.showLabel = true,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPremium) return const SizedBox.shrink();

    final size = iconSize ?? 14.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? AppSpacing.sm : AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryAccent, AppColors.neonPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium, color: Colors.white, size: size),
          if (showLabel) ...[
            const SizedBox(width: AppSpacing.xs),
            const Text(
              'PRO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Icon-only premium indicator (for tight spaces).
class PremiumIcon extends StatelessWidget {
  final double size;

  const PremiumIcon({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryAccent, AppColors.neonPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.workspace_premium, color: Colors.white, size: size),
    );
  }
}

/// Wraps a child with a grayscale lock overlay when [isLocked] is true.
/// Tapping the locked state invokes [onTap] — use this to open the paywall.
class PremiumLockOverlay extends StatelessWidget {
  final Widget child;
  final bool isLocked;
  final VoidCallback? onTap;
  final String? message;
  final double borderRadius;

  const PremiumLockOverlay({
    super.key,
    required this.child,
    required this.isLocked,
    this.onTap,
    this.message,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return child;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Opacity(
              opacity: 0.4,
              child: AbsorbPointer(child: child),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryAccent, AppColors.neonPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.lock, color: Colors.white, size: 24),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        message!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
