import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';

/// Shows a modal bottom sheet with a blur effect behind it.
/// Provides a modern glassmorphic look matching the app's design system.
Future<T?> showBlurredBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool isScrollControlled = false,
  bool useSafeArea = true,
  bool isDismissible = true,
  bool enableDrag = true,
  double? initialChildSize,
  double? minChildSize,
  double? maxChildSize,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          border: Border.all(
            color: AppColors.glassBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.glassShadow,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: AppSpacing.paddingMd,
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
            // Content
            Flexible(
              child: builder(context),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows a draggable scrollable bottom sheet with blur effect.
/// Useful for sheets with a lot of content.
Future<T?> showBlurredDraggableSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext, ScrollController) builder,
  double initialChildSize = 0.5,
  double minChildSize = 0.25,
  double maxChildSize = 0.9,
  bool isDismissible = true,
  bool enableDrag = true,
  bool snap = false,
  List<double>? snapSizes,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        snap: snap,
        snapSizes: snapSizes,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: AppSpacing.paddingMd,
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.4),
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
              // Content
              Expanded(
                child: builder(context, scrollController),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
