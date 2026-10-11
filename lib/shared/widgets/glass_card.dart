import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// Tints a [GlassCard] can take.
enum GlassCardVariant {
  standard, // Plain surface card
  accent, // Accent tint
  success, // Green (income)
  error, // Rose (expense)
  info, // Sky
  warning, // Amber
  cyan, // Peach → rose
  purple, // Violet
}

/// The original card primitive, now drawn as a Sunrise card.
///
/// The API is unchanged so its 40-odd call sites restyle without edits:
/// standard is a white (or dark-surface) card at radius 22 with the warm lift;
/// the variants are soft tinted fills; `enableBlur` makes it frosted. Borders
/// only appear when a caller asks for one explicitly.
class GlassCard extends StatelessWidget {
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

  /// The fill for a variant.
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

  /// Kept for callers that draw their own outline in a variant's colour.
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
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final radius = borderRadius ?? SunriseRadius.cardAll;
    final standard = variant == GlassCardVariant.standard;
    final Color? fill =
        backgroundColor ??
        (gradient == null && standard
            ? (enableBlur ? c.glass : c.surface)
            : null);
    final Gradient? fillGradient =
        gradient ?? (standard ? null : getVariantGradient(variant));

    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(SunriseSpace.card),
      decoration: BoxDecoration(
        color: fill,
        gradient: fill == null ? fillGradient : null,
        borderRadius: radius,
        border: borderColor == null || borderWidth == 0
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
        boxShadow: [
          if (standard && !enableBlur) ...c.cardShadow,
          if (enableGlow)
            BoxShadow(
              color: (glowColor ?? c.glow).withValues(alpha: 0.35),
              blurRadius: glowSpread,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: child,
    );

    if (enableBlur) {
      card = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: card,
        ),
      );
    }

    if (margin != null) card = Padding(padding: margin!, child: card);

    if (onTap != null || onLongPress != null) {
      return Pressable(
        onTap: onTap,
        onLongPress: onLongPress,
        scale: enablePressAnimation ? .97 : 1,
        child: card,
      );
    }
    return card;
  }
}

/// A [GlassCard] laid out as a list row.
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

/// A card with a thin gradient rim (used for highlighted items).
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
    final c = context.sunrise;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: accentGradient ?? c.gradient,
        borderRadius: SunriseRadius.cardAll,
        boxShadow: c.selectedShadow,
      ),
      padding: const EdgeInsets.all(1.5),
      child: GlassCard(
        padding: padding,
        borderWidth: 0,
        borderRadius: BorderRadius.circular(SunriseRadius.card - 1.5),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
