import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';

/// Header widget displaying category icon and amount in a colored container.
/// Tapping the category icon opens category picker.
/// Tapping the amount opens calculator.
class CategoryAmountHeader extends StatelessWidget {
  final String? categoryName;
  final String? categoryIconName;
  final String? categoryColor;
  final double amount;
  final String currencySymbol;
  final bool isIncome;
  final VoidCallback onCategoryTap;
  final VoidCallback onAmountTap;

  const CategoryAmountHeader({
    super.key,
    this.categoryName,
    this.categoryIconName,
    this.categoryColor,
    required this.amount,
    required this.currencySymbol,
    required this.isIncome,
    required this.onCategoryTap,
    required this.onAmountTap,
  });

  Color get _headerColor {
    if (categoryColor != null) {
      return _parseColor(categoryColor!);
    }
    return isIncome ? AppColors.success : AppColors.error;
  }

  Color _parseColor(String colorCode) {
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return isIncome ? AppColors.success : AppColors.error;
    } catch (e) {
      return isIncome ? AppColors.success : AppColors.error;
    }
  }

  String _formatAmount(double amount) {
    if (amount == 0) return '0';

    // Format with thousand separators
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    // Add thousand separators
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }

    // Only show decimals if not .00
    if (decPart != '00') {
      buffer.write('.');
      buffer.write(decPart);
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final color = _headerColor;

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category icon (tappable)
              _CategoryIconButton(
                iconName: categoryIconName,
                color: color,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onCategoryTap();
                },
              ),

              const Spacer(),

              // Amount and category name (tappable)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onAmountTap();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Amount display
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currencySymbol,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatAmount(amount),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Category name
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        categoryName ?? 'Select Category',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryIconButton extends StatelessWidget {
  final String? iconName;
  final Color color;
  final VoidCallback onTap;

  const _CategoryIconButton({
    this.iconName,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconName != null
                  ? IconRegistry.getIcon(iconName!)
                  : Icons.category_outlined,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(height: 2),
            Icon(
              Icons.expand_more,
              size: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
