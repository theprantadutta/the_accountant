import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// A single explanatory point shown in a permission-priming sheet.
class PrimingPoint {
  final IconData icon;
  final String text;
  const PrimingPoint(this.icon, this.text);
}

/// Shows an in-app "priming" sheet that explains, in the app's own voice, why a
/// permission is needed BEFORE the OS permission dialog is triggered. This is
/// the pattern Apple's guidelines expect and it reduces denials on Android too.
///
/// Returns true if the user opts in (the caller should then request the actual
/// OS permission); false if they decline.
Future<bool> showPermissionPrimingSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  List<PrimingPoint> points = const [],
  String allowLabel = 'Continue',
  String cancelLabel = 'Not now',
}) async {
  HapticFeedback.lightImpact();
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryAccent.withValues(alpha: 0.14),
                    border: Border.all(
                      color: AppColors.primaryAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(icon, color: AppColors.primaryAccent, size: 30),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                if (points.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.lg),
                  ...points.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              p.icon,
                              color: AppColors.primaryAccent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p.text,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.xl),
                NeoButton(
                  label: allowLabel,
                  isExpanded: true,
                  onPressed: () => Navigator.pop(ctx, true),
                ),
                SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    cancelLabel,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  return result ?? false;
}
