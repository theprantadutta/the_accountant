import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// A 56dp category square with its name underneath.
///
/// Idle: accent glyph on a peach tint. Selected: white glyph on the brand
/// gradient with its glow. Pass [color] to tint by the category's own colour.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.icon,
    this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
    this.size = 56,
    this.onLongPress,
    this.width,
  });

  final IconData icon;

  /// Shown instead of [icon] when the category has an emoji.
  final String? emoji;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double size;

  /// The slot the label may use. Defaults to the tile plus a little.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final glyph = color ?? c.accent;
    final labelStyle = SunriseType.label.copyWith(
      color: c.ink,
      fontSize: 12.5,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
    );
    return Pressable(
      onTap: onTap,
      onLongPress: onLongPress,
      haptic: true,
      semanticLabel: label,
      child: SizedBox(
        width: width ?? size + 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: SunriseMotion.press,
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: selected ? c.gradient : null,
                color: selected
                    ? null
                    : color == null
                    ? c.tintPeach
                    : glyph.withValues(alpha: c.isDark ? .2 : .12),
                borderRadius: BorderRadius.circular(SunriseRadius.category),
                boxShadow: selected ? c.selectedShadow : null,
              ),
              alignment: Alignment.center,
              child: emoji != null
                  ? Text(
                      emoji!,
                      style: TextStyle(fontSize: size * .42, height: 1),
                    )
                  : Icon(
                      icon,
                      size: size * .46,
                      color: selected ? Colors.white : glyph,
                      fill: selected ? 1 : 0,
                    ),
            ),
            const SizedBox(height: 8),
            // Under a 56dp tile one line cut ordinary names short. Names with
            // a space wrap onto a second line there; a single long word
            // ("Transportation") shrinks a little instead, since wrapping it
            // would break it mid-word.
            if (label.trim().contains(' '))
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: labelStyle,
              )
            else
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, maxLines: 1, style: labelStyle),
              ),
          ],
        ),
      ),
    );
  }
}
