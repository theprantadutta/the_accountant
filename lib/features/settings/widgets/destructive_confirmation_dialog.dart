import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Shows a destructive confirmation dialog that requires the user to type
/// a confirmation word (e.g. "DELETE") before the confirm button is enabled.
Future<bool?> showDestructiveConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmationWord = 'DELETE',
  String confirmText = 'Confirm',
}) {
  return showSunriseSheet<bool>(
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
    final c = context.sunrise;
    final l10n = L10n.of(context);
    return SunriseBottomSheet(
      actions: [
        SunriseButton.destructive(
          label: widget.confirmText,
          onPressed: _isMatch ? () => Navigator.pop(context, true) : null,
        ),
        SunriseButton.secondary(
          label: l10n.actionCancel,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: Symbols.warning_rounded,
            color: c.negative,
            background: c.tintRose,
            size: 52,
            radius: 16,
            iconSize: 26,
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: SunriseType.section.copyWith(
              color: c.negative,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.message,
            style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SunriseTextField(
            controller: _controller,
            autofocus: true,
            label: 'Type "${widget.confirmationWord}" to confirm',
            hint: widget.confirmationWord,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
