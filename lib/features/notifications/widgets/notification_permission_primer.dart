import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/blurred_bottom_sheet.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Shows the in-app notification "priming" prompt — our own UI that explains
/// why we'd like to send notifications, BEFORE the iOS system dialog.
///
/// Only if the user taps "Enable" do we call [NotificationService.requestPermission],
/// which fires the one-shot OS dialog. Tapping "Not now" leaves that dialog
/// unused so it can still be requested later (e.g. from Settings).
Future<void> showNotificationPermissionPrimer(BuildContext context) async {
  final optedIn = await showBlurredBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _NotificationPrimerContent(),
  );

  if (optedIn == true) {
    await NotificationService().requestPermission();
  }
}

class _NotificationPrimerContent extends StatelessWidget {
  const _NotificationPrimerContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppSpacing.borderRadiusLg,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGlow.withValues(alpha: 0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.textPrimary,
                  size: 32,
                ),
              ),
            ),
            AppSpacing.gapLg,
            Text(
              'Stay on top of your money',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSmall,
            ),
            AppSpacing.gapSm,
            Text(
              'Turn on notifications and we\'ll give you a heads-up on the '
              'things that matter.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapXl,
            _benefit(
              Icons.pie_chart_rounded,
              'Budget alerts',
              'Know before you overspend a budget.',
            ),
            AppSpacing.gapLg,
            _benefit(
              Icons.event_repeat_rounded,
              'Bill & subscription reminders',
              'Never miss a recurring payment.',
            ),
            AppSpacing.gapLg,
            _benefit(
              Icons.trending_up_rounded,
              'Large transactions',
              'Get notified about unusual activity.',
            ),
            AppSpacing.gapXxl,
            NeoButton(
              label: 'Enable Notifications',
              isExpanded: true,
              leadingIcon: Icons.notifications_active_rounded,
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop(true);
              },
            ),
            AppSpacing.gapSm,
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Not now',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.15),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Icon(icon, color: AppColors.primaryAccent, size: 20),
        ),
        AppSpacing.gapHMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleSmall),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
