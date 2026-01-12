import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/categories/widgets/add_category_form.dart' as add_category_form;

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

    final color = widget.accentColor ??
        (_isIncome ? AppColors.success : AppColors.error);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Header with type toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Type toggle
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _TypeToggleButton(
                            label: 'Expense',
                            isSelected: !_isIncome,
                            color: AppColors.error,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _isIncome = false);
                            },
                          ),
                          _TypeToggleButton(
                            label: 'Income',
                            isSelected: _isIncome,
                            color: AppColors.success,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _isIncome = true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category grid
              Expanded(
                child: categoryState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: categories.length + 1, // +1 for add button
                        itemBuilder: (context, index) {
                          // First item is the add button
                          if (index == 0) {
                            return _AddCategoryButton(
                              isIncome: _isIncome,
                              onTap: () => _showAddCategoryForm(context),
                            );
                          }

                          final category = categories[index - 1];
                          final isSelected =
                              category.id == widget.selectedCategoryId;
                          final categoryColor =
                              _parseColor(category.colorCode);

                          return _CategoryGridItem(
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
      ),
    );
  }
}

class _TypeToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeToggleButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? color : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryGridItem({
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
              : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconRegistry.getIcon(category.iconName ?? 'category'),
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

class _AddCategoryButton extends StatelessWidget {
  final bool isIncome;
  final VoidCallback onTap;

  const _AddCategoryButton({
    required this.isIncome,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.success : AppColors.error;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.divider,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
