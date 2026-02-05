import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// Button style variants
enum NeoButtonStyle {
  /// Gradient fill with glow effect
  primary,

  /// Glass outline style
  secondary,

  /// Text only with underline animation
  ghost,

  /// Danger/destructive action
  danger,

  /// Success/positive action
  success,
}

/// Button size variants
enum NeoButtonSize { small, medium, large }

/// A modern, animated button with multiple style variants.
///
/// Features:
/// - Multiple style variants (primary, secondary, ghost, danger, success)
/// - Scale animation on press
/// - Glow effect for primary style
/// - Loading state with spinner
/// - Icon support (leading and trailing)
/// - Haptic feedback
class NeoButton extends StatefulWidget {
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
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.quick,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: AppAnimations.pressedScale)
        .animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      if (widget.enableHaptics) {
        HapticFeedback.lightImpact();
      }
      widget.onPressed!();
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case NeoButtonSize.small:
        return AppSpacing.paddingButtonCompact;
      case NeoButtonSize.medium:
        return AppSpacing.paddingButton;
      case NeoButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case NeoButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case NeoButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case NeoButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case NeoButtonSize.small:
        return AppSpacing.iconXs;
      case NeoButtonSize.medium:
        return AppSpacing.iconSm;
      case NeoButtonSize.large:
        return AppSpacing.iconMd;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case NeoButtonSize.small:
        return AppTypography.labelMedium;
      case NeoButtonSize.medium:
        return AppTypography.labelLarge;
      case NeoButtonSize.large:
        return AppTypography.titleMedium;
    }
  }

  Color _getBackgroundColor() {
    switch (widget.style) {
      case NeoButtonStyle.primary:
        return AppColors.primaryAccent;
      case NeoButtonStyle.secondary:
        return Colors.transparent;
      case NeoButtonStyle.ghost:
        return Colors.transparent;
      case NeoButtonStyle.danger:
        return AppColors.error;
      case NeoButtonStyle.success:
        return AppColors.success;
    }
  }

  Color _getForegroundColor() {
    switch (widget.style) {
      case NeoButtonStyle.primary:
        return AppColors.textPrimary;
      case NeoButtonStyle.secondary:
        return AppColors.textPrimary;
      case NeoButtonStyle.ghost:
        return AppColors.primaryAccent;
      case NeoButtonStyle.danger:
        return AppColors.textPrimary;
      case NeoButtonStyle.success:
        return AppColors.textPrimary;
    }
  }

  Gradient? _getGradient() {
    if (widget.gradient != null) return widget.gradient;
    if (widget.style == NeoButtonStyle.primary) {
      return AppColors.primaryGradient;
    }
    return null;
  }

  BoxBorder? _getBorder() {
    if (widget.style == NeoButtonStyle.secondary) {
      return Border.all(color: AppColors.glassBorder, width: 1.5);
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (widget.style == NeoButtonStyle.primary) {
      return [
        BoxShadow(
          color: AppColors.primaryAccent.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final foregroundColor = _getForegroundColor();
    final textStyle = _getTextStyle().copyWith(
      color: isDisabled
          ? foregroundColor.withValues(alpha: 0.5)
          : foregroundColor,
    );

    Widget buttonContent = Row(
      mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(foregroundColor),
            ),
          ),
          AppSpacing.gapHSm,
        ] else if (widget.leadingIcon != null) ...[
          Icon(
            widget.leadingIcon,
            size: _getIconSize(),
            color: textStyle.color,
          ),
          AppSpacing.gapHSm,
        ],
        Text(widget.label, style: textStyle),
        if (widget.trailingIcon != null && !widget.isLoading) ...[
          AppSpacing.gapHSm,
          Icon(
            widget.trailingIcon,
            size: _getIconSize(),
            color: textStyle.color,
          ),
        ],
      ],
    );

    Widget button = Container(
      constraints: BoxConstraints(minHeight: _getHeight()),
      padding: _getPadding(),
      decoration: BoxDecoration(
        gradient: isDisabled ? null : _getGradient(),
        color: isDisabled
            ? _getBackgroundColor().withValues(alpha: 0.3)
            : (_getGradient() == null ? _getBackgroundColor() : null),
        borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusMd,
        border: _getBorder(),
        boxShadow: isDisabled ? null : _getBoxShadow(),
      ),
      alignment: Alignment.center,
      child: buttonContent,
    );

    // Ghost style underline effect
    if (widget.style == NeoButtonStyle.ghost) {
      button = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buttonContent,
          AppSpacing.gapXs,
          AnimatedContainer(
            duration: AppAnimations.fast,
            height: 2,
            width: 0, // Will animate on hover/focus
            decoration: BoxDecoration(
              color: AppColors.primaryAccent,
              borderRadius: AppSpacing.borderRadiusFull,
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _handleTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: widget.isExpanded
            ? SizedBox(width: double.infinity, child: button)
            : button,
      ),
    );
  }
}

/// A circular icon button with glass effect
class NeoIconButton extends StatefulWidget {
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
  State<NeoIconButton> createState() => _NeoIconButtonState();
}

class _NeoIconButtonState extends State<NeoIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.quick,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: AppAnimations.pressedScale)
        .animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize = widget.iconSize ?? widget.size * 0.5;
    final effectiveGlowColor = widget.glowColor ?? AppColors.primaryGlow;

    Widget button = GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.glassWhite,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: widget.enableGlow
                ? [
                    BoxShadow(
                      color: effectiveGlowColor.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            size: effectiveIconSize,
            color: widget.iconColor ?? AppColors.textPrimary,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}

/// A floating action button with gradient and glow
class NeoFAB extends StatefulWidget {
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
  State<NeoFAB> createState() => _NeoFABState();
}

class _NeoFABState extends State<NeoFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.quick,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: AppAnimations.pressedScale)
        .animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget fab = GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onPressed?.call();
      },
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            gradient: widget.gradient ?? AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: widget.size * 0.5,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );

    if (widget.heroTag != null) {
      return Hero(tag: widget.heroTag!, child: fab);
    }

    return fab;
  }
}
