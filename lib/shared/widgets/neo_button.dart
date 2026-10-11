import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// Button style variants.
enum NeoButtonStyle {
  /// The brand gradient with its glow.
  primary,

  /// A surface button.
  secondary,

  /// Accent text only.
  ghost,

  /// Destructive action.
  danger,

  /// Positive action.
  success,
}

/// Button size variants.
enum NeoButtonSize { small, medium, large }

/// The original button, now drawn in Sunrise. API unchanged.
class NeoButton extends StatelessWidget {
  const NeoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = NeoButtonStyle.primary,
    this.size = NeoButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isExpanded = false,
    this.enableHaptics = true,
    this.gradient,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final NeoButtonStyle style;
  final NeoButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isExpanded;
  final bool enableHaptics;
  final Gradient? gradient;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final enabled = onPressed != null && !isLoading;
    final (double height, double font, double hPad, double icon) =
        switch (size) {
          NeoButtonSize.small => (40.0, 14.0, 16.0, 18.0),
          NeoButtonSize.medium => (52.0, 16.0, 22.0, 20.0),
          NeoButtonSize.large => (58.0, 16.0, 26.0, 22.0),
        };

    final (Color? bg, Gradient? grad, Color fg, List<BoxShadow>? shadow) =
        switch (style) {
          NeoButtonStyle.primary => (
            null,
            gradient ?? c.gradient,
            Colors.white,
            enabled ? c.buttonShadow : null,
          ),
          NeoButtonStyle.secondary => (c.surface, null, c.ink, c.cardShadow),
          NeoButtonStyle.ghost => (Colors.transparent, null, c.accentText, null),
          NeoButtonStyle.danger => (c.negative, null, Colors.white, null),
          NeoButtonStyle.success => (c.positive, null, Colors.white, null),
        };

    final content = isLoading
        ? SizedBox(
            width: icon,
            height: icon,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: icon, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.button.copyWith(color: fg, fontSize: font),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: icon, color: fg),
              ],
            ],
          );

    final radius =
        borderRadius ??
        BorderRadius.circular(
          size == NeoButtonSize.small ? 14 : SunriseRadius.button,
        );

    return Semantics(
      button: true,
      enabled: enabled,
      child: Pressable(
        onTap: enabled
            ? () {
                if (enableHaptics) HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        child: AnimatedOpacity(
          duration: SunriseMotion.press,
          opacity: onPressed == null ? .5 : 1,
          child: Container(
            height: height,
            width: isExpanded ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: hPad),
            decoration: BoxDecoration(
              color: bg,
              gradient: grad,
              borderRadius: radius,
              boxShadow: shadow,
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// A circular icon button on the surface colour.
class NeoIconButton extends StatelessWidget {
  const NeoIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.enableGlow = false,
    this.glowColor,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool enableGlow;
  final Color? glowColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    Widget button = Pressable(
      onTap: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
      semanticLabel: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? c.surface,
          shape: BoxShape.circle,
          boxShadow: [
            if (backgroundColor == null) ...c.cardShadow,
            if (enableGlow)
              BoxShadow(
                color: (glowColor ?? c.glow).withValues(alpha: .35),
                blurRadius: 16,
                spreadRadius: -4,
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize ?? size * .46, color: iconColor ?? c.ink),
      ),
    );
    if (tooltip != null) button = Tooltip(message: tooltip!, child: button);
    return button;
  }
}

/// A gradient floating action button.
class NeoFAB extends StatelessWidget {
  const NeoFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 56.0,
    this.gradient,
    this.heroTag,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Gradient? gradient;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final fab = Pressable(
      onTap: onPressed == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              onPressed!();
            },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: gradient ?? c.gradient,
          borderRadius: BorderRadius.circular(SunriseRadius.button),
          boxShadow: c.buttonShadow,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: size * .46),
      ),
    );
    return heroTag == null ? fab : Hero(tag: heroTag!, child: fab);
  }
}
