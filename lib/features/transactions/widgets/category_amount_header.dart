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
              // Category icon and name (tappable)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onCategoryTap();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              categoryIconName != null
                                  ? IconRegistry.getIcon(categoryIconName!)
                                  : Icons.category_outlined,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: Icon(
                              Icons.expand_more,
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Category name
                    Text(
                      categoryName ?? 'Select Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Amount (tappable)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onAmountTap();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      currencySymbol,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatAmount(amount),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1.5,
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
