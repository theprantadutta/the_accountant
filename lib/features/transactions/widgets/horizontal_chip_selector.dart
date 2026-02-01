import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// A generic horizontal scrolling chip selector widget.
/// Used for wallet selection, special type selection, and loan type selection.
class HorizontalChipSelector<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) labelBuilder;
  final Color Function(T)? colorBuilder;
  final IconData? Function(T)? iconBuilder;
  final ValueChanged<T> onSelected;
  final bool showLeadingIcon;
  final IconData? leadingIcon;
  final Widget? trailing;
  final EdgeInsets padding;

  const HorizontalChipSelector({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    this.colorBuilder,
    this.iconBuilder,
    required this.onSelected,
    this.showLeadingIcon = false,
    this.leadingIcon,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          if (showLeadingIcon && leadingIcon != null) ...[
            Padding(
              padding: EdgeInsets.only(left: padding.left),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  leadingIcon,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: showLeadingIcon ? 0 : padding.left,
                right: trailing != null ? 8 : padding.right,
              ),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedItem;
                final color = colorBuilder?.call(item) ?? AppColors.primaryAccent;
                final icon = iconBuilder?.call(item);

                return _ChipItem(
                  label: labelBuilder(item),
                  isSelected: isSelected,
                  color: color,
                  icon: icon,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSelected(item);
                  },
                );
              },
            ),
          ),
          if (trailing != null) ...[
            trailing!,
            SizedBox(width: padding.right),
          ],
        ],
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final IconData? icon;
  final VoidCallback onTap;

  const _ChipItem({
    required this.label,
    required this.isSelected,
    required this.color,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.5) : AppColors.divider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Labeled section with horizontal chip selector
class LabeledChipSection<T> extends StatelessWidget {
  final String label;
  final IconData? labelIcon;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) labelBuilder;
  final Color Function(T)? colorBuilder;
  final IconData? Function(T)? iconBuilder;
  final ValueChanged<T> onSelected;
  final Widget? trailing;

  const LabeledChipSection({
    super.key,
    required this.label,
    this.labelIcon,
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    this.colorBuilder,
    this.iconBuilder,
    required this.onSelected,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (labelIcon != null) ...[
                Icon(
                  labelIcon,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        HorizontalChipSelector<T>(
          items: items,
          selectedItem: selectedItem,
          labelBuilder: labelBuilder,
          colorBuilder: colorBuilder,
          iconBuilder: iconBuilder,
          onSelected: onSelected,
          trailing: trailing,
        ),
      ],
    );
  }
}
