import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Asks "are you sure?" as a Sunrise bottom sheet. Resolves to true on
/// confirm, false on cancel, null when dismissed.
///
/// [cancelText] and [confirmText] default to the reader's language.
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
  return showSunriseSheet<bool>(
    context: context,
    builder: (_) => ConfirmationDialog(
      title: title,
      message: message,
      cancelText: cancelText ?? l10n.actionCancel,
      confirmText: confirmText ?? l10n.actionConfirm,
      confirmColor: confirmColor,
      isDangerous: isDangerous,
    ),
  );
}

/// The body of [showConfirmationDialog].
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

  /// Kept for callers; the button follows [isDangerous].
  final Color? confirmColor;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseBottomSheet(
      actions: [
        if (isDangerous)
          SunriseButton.destructive(
            label: confirmText,
            onPressed: () => Navigator.pop(context, true),
          )
        else
          SunriseButton(
            label: confirmText,
            height: 54,
            onPressed: () => Navigator.pop(context, true),
          ),
        SunriseButton.secondary(
          label: cancelText,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: isDangerous ? Symbols.warning_rounded : Symbols.help_rounded,
            color: isDangerous ? c.negative : c.accent,
            background: isDangerous ? c.tintRose : c.tintOrange,
            size: 52,
            radius: 16,
            iconSize: 26,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: SunriseType.section.copyWith(
              color: isDangerous ? c.negative : c.ink,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Shows a small blocking dialog while [operation] runs.
Future<T?> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() operation,
  String message = 'Please wait...',
}) async {
  showSunriseDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final c = context.sunrise;
      return PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: c.base,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(SunriseRadius.hero)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SunriseLoader(size: 24),
                const SizedBox(width: 18),
                Flexible(
                  child: Text(
                    message,
                    style: SunriseType.rowTitle.copyWith(color: c.ink),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  try {
    final result = await operation();
    if (context.mounted) Navigator.pop(context);
    return result;
  } catch (e) {
    if (context.mounted) Navigator.pop(context);
    rethrow;
  }
}

void showSuccessSnackBar(BuildContext context, String message) =>
    showSunriseSnack(context, message, tone: SnackTone.success);

void showErrorSnackBar(BuildContext context, String message) =>
    showSunriseSnack(context, message, tone: SnackTone.error);

void showInfoSnackBar(BuildContext context, String message) =>
    showSunriseSnack(context, message);
