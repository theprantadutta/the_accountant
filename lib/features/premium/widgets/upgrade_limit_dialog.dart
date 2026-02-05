import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';

/// Dialog shown when user hits a free tier limit
class UpgradeLimitDialog extends StatelessWidget {
  final String entityType;
  final int currentCount;
  final int limit;
  final VoidCallback? onUpgrade;

  const UpgradeLimitDialog({
    super.key,
    required this.entityType,
    required this.currentCount,
    required this.limit,
    this.onUpgrade,
  });

  /// Show the upgrade limit dialog
  static Future<bool?> show(
    BuildContext context, {
    required String entityType,
    required int currentCount,
    required int limit,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => UpgradeLimitDialog(
        entityType: entityType,
        currentCount: currentCount,
        limit: limit,
        onUpgrade: () {
          Navigator.pop(context, true);
          Navigator.pushNamed(context, '/premium');
        },
      ),
    );
  }

  /// Show from a PremiumLimitException
  static Future<bool?> showFromException(
    BuildContext context,
    PremiumLimitException exception,
  ) {
    return show(
      context,
      entityType: exception.entityType,
      currentCount: exception.currentCount,
      limit: exception.limit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = PremiumLimitException.getEntityDisplayName(entityType);

    return Dialog(
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.diamond_outlined,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Limit Reached',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              'You\'ve used $currentCount of $limit free $displayName.',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Upgrade to Premium for unlimited $displayName and more!',
              style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        onUpgrade ??
                        () {
                          Navigator.pop(context, true);
                          Navigator.pushNamed(context, '/premium');
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Upgrade'),
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
