import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// Card color variants for easy theming
enum GlassCardVariant {
  standard, // Default indigo tint
  accent, // Stronger indigo
  success, // Green (income)
  error, // Red (expense)
  info, // Blue
  warning, // Amber
  cyan, // Cyan
  purple, // Purple
}

/// A modern glassmorphic card with optional blur, glow, and press animations.
///
/// Features:
/// - Frosted glass effect with BackdropFilter
/// - Gradient border with customizable colors
/// - Glow effect for highlighted states
/// - Scale animation on press
/// - Customizable border radius and padding
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.enableBlur = false,
    this.blurAmount = 10.0,
    this.enableGlow = false,
    this.glowColor,
    this.glowSpread = 20.0,
    this.onTap,
    this.onLongPress,
    this.enablePressAnimation = true,
    this.gradient,
    this.backgroundColor,
    this.variant = GlassCardVariant.standard,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final bool enableBlur;
  final double blurAmount;
  final bool enableGlow;
  final Color? glowColor;
  final double glowSpread;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enablePressAnimation;
  final Gradient? gradient;
  final Color? backgroundColor;
  final GlassCardVariant variant;

  /// Get gradient for variant
  static Gradient getVariantGradient(GlassCardVariant variant) {
    switch (variant) {
      case GlassCardVariant.standard:
        return AppColors.glassGradient;
      case GlassCardVariant.accent:
        return AppColors.accentCardGradient;
      case GlassCardVariant.success:
        return AppColors.successCardGradient;
      case GlassCardVariant.error:
        return AppColors.errorCardGradient;
      case GlassCardVariant.info:
        return AppColors.infoCardGradient;
      case GlassCardVariant.warning:
        return AppColors.warningCardGradient;
      case GlassCardVariant.cyan:
        return AppColors.cyanCardGradient;
      case GlassCardVariant.purple:
        return AppColors.purpleCardGradient;
    }
  }

  /// Get border color for variant
  static Color getVariantBorderColor(GlassCardVariant variant) {
    switch (variant) {
      case GlassCardVariant.standard:
        return AppColors.glassBorder;
      case GlassCardVariant.accent:
        return AppColors.primaryAccent.withValues(alpha: 0.3);
      case GlassCardVariant.success:
        return AppColors.success.withValues(alpha: 0.3);
      case GlassCardVariant.error:
        return AppColors.error.withValues(alpha: 0.3);
      case GlassCardVariant.info:
        return AppColors.info.withValues(alpha: 0.3);
      case GlassCardVariant.warning:
        return AppColors.warning.withValues(alpha: 0.3);
      case GlassCardVariant.cyan:
        return AppColors.neonCyan.withValues(alpha: 0.3);
      case GlassCardVariant.purple:
        return AppColors.neonPurple.withValues(alpha: 0.3);
    }
  }

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: AppAnimations.tappedScale)
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
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? AppSpacing.borderRadiusXl;
    final effectiveGlowColor = widget.glowColor ?? AppColors.primaryGlow;
    final effectiveGradient =
        widget.gradient ?? GlassCard.getVariantGradient(widget.variant);
    final effectiveBorderColor =
        widget.borderColor ?? GlassCard.getVariantBorderColor(widget.variant);

    Widget card = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? AppSpacing.paddingCard,
      margin: widget.margin,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        color: widget.backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: widget.borderWidth,
        ),
        boxShadow: [
          // Base shadow
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          // Glow effect
          if (widget.enableGlow)
            BoxShadow(
              color: effectiveGlowColor.withValues(alpha: 0.3),
              blurRadius: widget.glowSpread,
              spreadRadius: 0,
            ),
        ],
      ),
      child: widget.child,
    );

    // Apply blur effect
    if (widget.enableBlur) {
      card = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurAmount,
            sigmaY: widget.blurAmount,
          ),
          child: card,
        ),
      );
    }

    // Apply press animation
    if (widget.enablePressAnimation && widget.onTap != null) {
      card = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: card,
      );
    }

    // Wrap with gesture detector if interactive
    if (widget.onTap != null || widget.onLongPress != null) {
      return GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: card,
      );
    }

    return card;
  }
}

/// A compact variant of GlassCard for list items
class GlassListTile extends StatelessWidget {
  const GlassListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.enableGlow = false,
    this.glowColor,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool enableGlow;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding ?? AppSpacing.paddingListItem,
      enableGlow: enableGlow,
      glowColor: glowColor,
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) ...[leading!, AppSpacing.gapHMd],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) ...[AppSpacing.gapXs, subtitle!],
              ],
            ),
          ),
          if (trailing != null) ...[AppSpacing.gapHMd, trailing!],
        ],
      ),
    );
  }
}

/// A glass card with a gradient accent border
class AccentGlassCard extends StatelessWidget {
  const AccentGlassCard({
    super.key,
    required this.child,
    this.accentGradient,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final Gradient? accentGradient;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: accentGradient ?? AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      padding: const EdgeInsets.all(1.5),
      child: GlassCard(
        padding: padding,
        borderWidth: 0,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
