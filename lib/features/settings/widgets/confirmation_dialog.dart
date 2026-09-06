import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// Shows a confirmation dialog for destructive actions
/// [cancelText] and [confirmText] default to the reader's language.
///
/// Nullable rather than defaulted to a literal: a default value has to be a
/// compile-time constant, so an English word was the only thing that could go
/// there. Resolved here instead, where there is a context to resolve it from.
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? cancelText,
  String? confirmText,
  Color? confirmColor,
  bool isDangerous = false,
}) {
  final l10n = L10n.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmationDialog(
      title: title,
      message: message,
      cancelText: cancelText ?? l10n.actionCancel,
      confirmText: confirmText ?? l10n.actionConfirm,
      confirmColor:
          confirmColor ??
          (isDangerous ? AppColors.error : AppColors.primaryAccent),
      isDangerous: isDangerous,
    ),
  );
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.confirmColor,
    this.isDangerous = false,
  });

  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color? confirmColor;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.glassBorder),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDangerous ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(message, style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText, style: TextStyle(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? AppColors.error,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Shows a loading dialog while an async operation is in progress
Future<T?> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() operation,
  String message = 'Please wait...',
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: AppColors.primarySurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.glassBorder),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryAccent),
            const SizedBox(width: 20),
            Text(message, style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
      ),
    ),
  );

  try {
    final result = await operation();
    if (context.mounted) {
      Navigator.pop(context);
    }
    return result;
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
    }
    rethrow;
  }
}

/// Shows a success snackbar
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(message, style: TextStyle(color: AppColors.textPrimary)),
        ],
      ),
      backgroundColor: AppColors.success.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}

/// Shows an error snackbar
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: AppColors.error.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}

/// Shows an info snackbar
void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 8),
          Text(message, style: const TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: AppColors.info.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
