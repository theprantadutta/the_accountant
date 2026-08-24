import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/categories/widgets/add_category_form.dart'
    as add_category_form;
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

/// Shows a category picker in a bottom sheet.
/// Returns the selected category when user makes a selection.
Future<Category?> showCategoryPickerSheet({
  required BuildContext context,
  required WidgetRef ref,
  required bool isIncome,
  String? selectedCategoryId,
  Color? accentColor,
}) {
  return showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (context) => _CategoryPickerSheet(
      isIncome: isIncome,
      selectedCategoryId: selectedCategoryId,
      accentColor: accentColor,
    ),
  );
}

class _CategoryPickerSheet extends ConsumerStatefulWidget {
  final bool isIncome;
  final String? selectedCategoryId;
  final Color? accentColor;

  const _CategoryPickerSheet({
    required this.isIncome,
    this.selectedCategoryId,
    this.accentColor,
  });

  @override
  ConsumerState<_CategoryPickerSheet> createState() =>
      _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends ConsumerState<_CategoryPickerSheet> {
  late bool _isIncome;

  @override
  void initState() {
    super.initState();
    _isIncome = widget.isIncome;
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return AppColors.primaryAccent;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return AppColors.primaryAccent;
    } catch (e) {
      return AppColors.primaryAccent;
    }
  }

  void _showAddCategoryForm(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return const add_category_form.AddCategoryForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final categories = categoryState.categories
        .where((c) => c.isIncome == _isIncome)
        .toList();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXxxl),
          ),
          border: Border(top: BorderSide(color: AppColors.glassBorder)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacing.gapXl,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select category', style: AppTypography.headlineSmall),
                  AppSpacing.gapLg,

                  // Two chips, in the same language as the type toggle on the
                  // form that opened this sheet. It used to be a segmented
                  // control with a solid red or green fill, which is the only
                  // place in the app those colours are used as a background
                  // rather than as a signal about a number.
                  Row(
                    children: [
                      Expanded(
                        child: _TypeChip(
                          label: 'Expense',
                          icon: Icons.arrow_downward,
                          color: AppColors.error,
                          isSelected: !_isIncome,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _isIncome = false);
                          },
                        ),
                      ),
                      AppSpacing.gapHSm,
                      Expanded(
                        child: _TypeChip(
                          label: 'Income',
                          icon: Icons.arrow_upward,
                          color: AppColors.success,
                          isSelected: _isIncome,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _isIncome = true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            Expanded(
              child: categoryState.isLoading
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.xxl,
                        0,
                        AppSpacing.xxl,
                        AppSpacing.xl,
                      ),
                      child: Column(
                        children: [
                          ShimmerCard(height: 56),
                          AppSpacing.gapMd,
                          ShimmerCard(height: 56),
                          AppSpacing.gapMd,
                          ShimmerCard(height: 56),
                          AppSpacing.gapMd,
                          ShimmerCard(height: 56),
                        ],
                      ),
                    )
                  // A list, not a grid. Every other list of things in this app
                  // is a row with a tinted glyph, a name and a value on the
                  // right; the grid of chunky tiles was the only screen that
                  // looked like a different product, and it wrapped longer
                  // names like "Balance Correction" onto two lines to boot.
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        bottom:
                            AppSpacing.xl +
                            MediaQuery.of(context).padding.bottom,
                      ),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == categories.length) {
                          return _NewCategoryRow(
                            onTap: () => _showAddCategoryForm(context),
                          );
                        }

                        final category = categories[index];
                        return _CategoryRow(
                          category: category,
                          isSelected: category.id == widget.selectedCategoryId,
                          color: _parseColor(category.colorCode),
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context, category);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expense or income, as an outlined chip that tints when chosen.
class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.glassWhite,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(color: isSelected ? color : AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconXs,
              color: isSelected ? color : AppColors.textMuted,
            ),
            AppSpacing.gapHXs,
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  letterSpacing: 0.2,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One category, laid out like a transaction row.
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final Category category;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            _CategoryGlyph(
              tint: color,
              iconName: category.iconName ?? 'category',
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall.copyWith(
                  color: isSelected ? color : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: AppSpacing.iconSm, color: color),
          ],
        ),
      ),
    );
  }
}

/// The way out of this sheet when none of the categories fit.
class _NewCategoryRow extends StatelessWidget {
  const _NewCategoryRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(
                Icons.add_rounded,
                size: AppSpacing.iconSm,
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapHMd,
            Text(
              'New category',
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The same rounded, tinted icon tile the transaction list uses.
class _CategoryGlyph extends StatelessWidget {
  const _CategoryGlyph({required this.tint, required this.iconName});

  final Color tint;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Icon(
        IconRegistry.getIcon(iconName),
        size: AppSpacing.iconSm,
        color: tint,
      ),
    );
  }
}
