import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/controls.dart';

/// Nothing here yet: a soft gradient glyph, a title, a line and an action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  /// An error variant with a retry button.
  factory EmptyState.error({
    Key? key,
    required String title,
    String? message,
    String? retryLabel,
    VoidCallback? onRetry,
  }) => EmptyState(
    key: key,
    icon: Symbols.cloud_off_rounded,
    title: title,
    message: message,
    actionLabel: retryLabel,
    onAction: onRetry,
  );

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Smaller, for use inside a card.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final tile = compact ? 56.0 : 76.0;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: compact ? 20 : 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: tile,
            height: tile,
            decoration: BoxDecoration(
              color: c.tintPeach,
              borderRadius: BorderRadius.circular(tile * .32),
            ),
            alignment: Alignment.center,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (r) => c.gradient.createShader(r),
              child: Icon(icon, size: tile * .48, color: Colors.white),
            ),
          ),
          SizedBox(height: compact ? 12 : 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: (compact ? SunriseType.rowTitle : SunriseType.section)
                .copyWith(color: c.ink),
          ),
          if (message != null) ...[
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: SunriseType.body.copyWith(
                  color: c.muted,
                  fontSize: compact ? 13 : 14,
                ),
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? 14 : 22),
            SunriseButton(
              label: actionLabel!,
              onPressed: onAction,
              expand: false,
              height: 50,
            ),
          ],
        ],
      ),
    );
  }
}

/// A centred accent spinner for full-screen loading.
class SunriseLoader extends StatelessWidget {
  const SunriseLoader({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.6,
        strokeCap: StrokeCap.round,
        color: context.sunrise.accent,
      ),
    ),
  );
}
