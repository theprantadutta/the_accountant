import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';

/// A widget for selecting an icon from a grid of wallet-related icons
class IconPicker extends StatelessWidget {
  final String? selectedIcon;
  final ValueChanged<String> onIconSelected;
  final String? label;
  final Color? selectedColor;

  const IconPicker({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.label,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = selectedColor ?? AppColors.primaryAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          AppSpacing.gapSm,
        ],
        InkWell(
          onTap: () => _showIconPicker(context, effectiveColor),
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.2),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    WalletIcons.getIcon(selectedIcon ?? 'wallet'),
                    color: effectiveColor,
                    size: 24,
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    _getIconLabel(selectedIcon ?? 'wallet'),
                    style: AppTypography.bodyLarge,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getIconLabel(String iconName) {
    return iconName
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  void _showIconPicker(BuildContext context, Color selectedColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: _IconPickerSheet(
          selectedIcon: selectedIcon,
          selectedColor: selectedColor,
          onIconSelected: (icon) {
            onIconSelected(icon);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _IconPickerSheet extends StatelessWidget {
  final String? selectedIcon;
  final Color selectedColor;
  final ValueChanged<String> onIconSelected;

  const _IconPickerSheet({
    this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icons = WalletIcons.allIcons;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: AppSpacing.horizontalPadding(AppSpacing.md),
            child: Row(
              children: [
                Text('Select Icon', style: AppTypography.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Icon grid
          Expanded(
            child: GridView.builder(
              padding: AppSpacing.paddingMd,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final entry = icons.entries.elementAt(index);
                final isSelected = selectedIcon == entry.key;

                return InkWell(
                  onTap: () => onIconSelected(entry.key),
                  borderRadius: AppSpacing.borderRadiusMd,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withValues(alpha: 0.2)
                          : AppColors.glassWhite,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(
                        color: isSelected
                            ? selectedColor
                            : AppColors.glassBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      entry.value,
                      color: isSelected ? selectedColor : AppColors.textPrimary,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Predefined wallet icons
class WalletIcons {
  static const Map<String, IconData> allIcons = {
    'wallet': Icons.account_balance_wallet,
    'account_balance': Icons.account_balance,
    'credit_card': Icons.credit_card,
    'savings': Icons.savings,
    'money': Icons.attach_money,
    'euro': Icons.euro,
    'currency_pound': Icons.currency_pound,
    'currency_yen': Icons.currency_yen,
    'currency_bitcoin': Icons.currency_bitcoin,
    'payments': Icons.payments,
    'account_box': Icons.account_box,
    'business': Icons.business,
    'work': Icons.work,
    'home': Icons.home,
    'shopping_bag': Icons.shopping_bag,
    'shopping_cart': Icons.shopping_cart,
    'receipt_long': Icons.receipt_long,
    'storefront': Icons.storefront,
    'local_atm': Icons.local_atm,
    'monetization_on': Icons.monetization_on,
    'trending_up': Icons.trending_up,
    'pie_chart': Icons.pie_chart,
    'insights': Icons.insights,
    'toll': Icons.toll,
    'paid': Icons.paid,
    'redeem': Icons.redeem,
    'card_giftcard': Icons.card_giftcard,
    'loyalty': Icons.loyalty,
    'favorite': Icons.favorite,
    'star': Icons.star,
    'school': Icons.school,
    'medical_services': Icons.medical_services,
    'flight': Icons.flight,
    'directions_car': Icons.directions_car,
    'restaurant': Icons.restaurant,
    'sports_esports': Icons.sports_esports,
    'fitness_center': Icons.fitness_center,
    'pets': Icons.pets,
    'child_care': Icons.child_care,
    'family_restroom': Icons.family_restroom,
  };

  static IconData getIcon(String name) {
    return allIcons[name] ?? Icons.account_balance_wallet;
  }
}
