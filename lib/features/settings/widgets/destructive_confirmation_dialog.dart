import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// Shows a destructive confirmation dialog that requires the user to type
/// a confirmation word (e.g. "DELETE") before the confirm button is enabled.
Future<bool?> showDestructiveConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmationWord = 'DELETE',
  String confirmText = 'Confirm',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => DestructiveConfirmationDialog(
      title: title,
      message: message,
      confirmationWord: confirmationWord,
      confirmText: confirmText,
    ),
  );
}

class DestructiveConfirmationDialog extends StatefulWidget {
  const DestructiveConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmationWord,
    required this.confirmText,
  });

  final String title;
  final String message;
  final String confirmationWord;
  final String confirmText;

  @override
  State<DestructiveConfirmationDialog> createState() =>
      _DestructiveConfirmationDialogState();
}

class _DestructiveConfirmationDialogState
    extends State<DestructiveConfirmationDialog> {
  final _controller = TextEditingController();
  bool _isMatch = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final match =
          _controller.text.trim().toUpperCase() ==
          widget.confirmationWord.toUpperCase();
      if (match != _isMatch) {
        setState(() => _isMatch = match);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.glassBorder),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'Type "${widget.confirmationWord}" to confirm:',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.confirmationWord,
              hintStyle: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: AppColors.primaryDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: _isMatch ? AppColors.error : AppColors.glassBorder,
                  width: _isMatch ? 1.5 : 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: _isMatch ? () => Navigator.pop(context, true) : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.error,
            disabledForegroundColor: AppColors.error.withValues(alpha: 0.3),
          ),
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
