import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Type toggle - pill style
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TypePill(
                            label: 'Expense',
                            isSelected: !_isIncome,
                            color: AppColors.error,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _isIncome = false);
                            },
                          ),
                        ),
                        Expanded(
                          child: _TypePill(
                            label: 'Income',
                            isSelected: _isIncome,
                            color: AppColors.success,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _isIncome = true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category grid
            Expanded(
              child: categoryState.isLoading
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          ShimmerCard(height: 56),
                          SizedBox(height: 12),
                          ShimmerCard(height: 56),
                          SizedBox(height: 12),
                          ShimmerCard(height: 56),
                          SizedBox(height: 12),
                          ShimmerCard(height: 56),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.95,
                          ),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        // Last item is add button
                        if (index == categories.length) {
                          return _AddCategoryCard(
                            onTap: () => _showAddCategoryForm(context),
                          );
                        }

                        final category = categories[index];
                        final isSelected =
                            category.id == widget.selectedCategoryId;
                        final categoryColor = _parseColor(category.colorCode);

                        return _CategoryCard(
                          category: category,
                          isSelected: isSelected,
                          color: categoryColor,
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

class _TypePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypePill({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                IconRegistry.getIcon(category.iconName ?? 'category'),
                size: 26,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            // Category name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCategoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 28,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'New',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
