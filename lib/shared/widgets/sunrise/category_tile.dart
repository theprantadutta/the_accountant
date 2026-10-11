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
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
    this.size = 56,
    this.onLongPress,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final glyph = color ?? c.accent;
    return Pressable(
      onTap: onTap,
      onLongPress: onLongPress,
      haptic: true,
      semanticLabel: label,
      child: SizedBox(
        width: size + 20,
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
              child: Icon(
                icon,
                size: size * .46,
                color: selected ? Colors.white : glyph,
                fill: selected ? 1 : 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: SunriseType.label.copyWith(
                color: c.ink,
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
