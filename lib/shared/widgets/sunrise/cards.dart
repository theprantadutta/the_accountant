import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise_background.dart';

/// A white (or dark-surface) card, radius 22. The basic Sunrise container.
class SunriseCard extends StatelessWidget {
  const SunriseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SunriseSpace.card),
    this.radius = SunriseRadius.card,
    this.onTap,
    this.onLongPress,
    this.color,
    this.border,
    this.shadow = true,
    this.glass = false,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final BoxBorder? border;
  final bool shadow;

  /// Frosted instead of solid (the Today net-worth card).
  final bool glass;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final r = BorderRadius.circular(radius);
    Widget body = Padding(padding: padding, child: child);
    if (glass) {
      body = DecoratedBox(
        decoration: BoxDecoration(borderRadius: r, boxShadow: c.glassShadow),
        child: SunriseGlass(
          radius: r,
          blur: 10,
          color: c.isDark ? c.glass : c.surface.withValues(alpha: .75),
          border: border,
          child: body,
        ),
      );
    } else {
      body = DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? c.surface,
          borderRadius: r,
          border: border,
          boxShadow: shadow ? c.cardShadow : null,
        ),
        child: body,
      );
    }
    if (margin != null) body = Padding(padding: margin!, child: body);
    if (onTap == null && onLongPress == null) return body;
    return Pressable(onTap: onTap, onLongPress: onLongPress, child: body);
  }
}

/// A card filled with the brand gradient and its warm glow.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SunriseSpace.hero),
    this.radius = SunriseRadius.hero,
    this.onTap,
    this.height,
    this.gradient,
    this.highlight = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final double? height;
  final Gradient? gradient;

  /// The soft radial bloom in the upper right of hero cards.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final r = BorderRadius.circular(radius);
    Widget card = Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? c.gradient,
        borderRadius: r,
        boxShadow: c.gradientShadow,
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Stack(
          children: [
            if (highlight)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(.6, -.55),
                      radius: .8,
                      colors: [
                        Colors.white.withValues(alpha: .22),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: padding,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: IconTheme.merge(
                  data: const IconThemeData(color: Colors.white),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap != null) card = Pressable(onTap: onTap, child: card);
    return card;
  }
}

/// A rounded square holding an icon on a tinted fill.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.color,
    this.background,
    this.size = 40,
    this.radius = SunriseRadius.iconTile,
    this.iconSize,
    this.fill = 0,
    this.gradient,
  });

  final IconData icon;
  final Color color;

  /// Defaults to [color] at 12%.
  final Color? background;
  final double size;
  final double radius;
  final double? iconSize;
  final double fill;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final isDark = context.sunrise.isDark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient == null
            ? background ?? color.withValues(alpha: isDark ? .18 : .12)
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize ?? size * .5, color: color, fill: fill),
    );
  }
}

/// Earned / Spent style tile: icon, label, big value.
class SunriseStatCard extends StatelessWidget {
  const SunriseStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
    this.footer,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 26),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SunriseType.label.copyWith(color: c.muted, fontSize: 14),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              maxLines: 1,
              style: SunriseType.statValue.copyWith(color: c.ink),
            ),
          ),
          if (footer != null) ...[const SizedBox(height: 8), footer!],
        ],
      ),
    );
  }
}

/// A small pill of text on a tint ("+৳1,850 this month", "Default", "PRO").
class SunrisePill extends StatelessWidget {
  const SunrisePill({
    super.key,
    required this.label,
    this.color,
    this.background,
    this.gradient,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.fontSize = 12,
  });

  final String label;
  final Color? color;
  final Color? background;
  final Gradient? gradient;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final fg = color ?? (gradient != null ? Colors.white : c.accentText);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? background ?? c.tintPeach : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(SunriseRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 3, color: fg, fill: 1),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.label.copyWith(
                color: fg,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
