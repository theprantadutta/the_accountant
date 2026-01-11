import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/categories/widgets/quick_add_category_form.dart';

/// A grid-based category selector widget.
/// Displays categories as colored icons in a clean grid layout.
class CategoryGridSelector extends ConsumerStatefulWidget {
  /// The currently selected category ID
  final String? selectedCategoryId;

  /// Callback when a category is selected
  final ValueChanged<Category>? onCategorySelected;

  /// Whether to show income or expense categories
  /// If null, shows a tab to switch between them
  final bool? isIncome;

  /// Callback when the income/expense tab changes
  final ValueChanged<bool>? onIsIncomeChanged;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Whether to show the add category button
  final bool showAddButton;

  /// Callback when add button is pressed
  final VoidCallback? onAddCategory;

  const CategoryGridSelector({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.isIncome,
    this.onIsIncomeChanged,
    this.crossAxisCount = 4,
    this.showAddButton = true,
    this.onAddCategory,
  });

  @override
  ConsumerState<CategoryGridSelector> createState() =>
      _CategoryGridSelectorState();
}

class _CategoryGridSelectorState extends ConsumerState<CategoryGridSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _showingIncome;

  @override
  void initState() {
    super.initState();
    _showingIncome = widget.isIncome ?? false;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _showingIncome ? 1 : 0,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _showingIncome = _tabController.index == 1;
    });
    widget.onIsIncomeChanged?.call(_showingIncome);
  }

  @override
  void didUpdateWidget(CategoryGridSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isIncome != null && widget.isIncome != _showingIncome) {
      setState(() {
        _showingIncome = widget.isIncome!;
        _tabController.animateTo(_showingIncome ? 1 : 0);
      });
    }
  }

  void _showAddCategorySheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => QuickAddCategoryForm(
        presetType: _showingIncome ? 'income' : 'expense',
        onCategoryAdded: (name, id) {
          Navigator.pop(context);
          // Auto-select the newly created category
          final categoryState = ref.read(categoryProvider);
          final newCategory = categoryState.categories
              .where((c) => c.id == id)
              .firstOrNull;
          if (newCategory != null) {
            widget.onCategorySelected?.call(newCategory);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return Column(
      children: [
        // Tab Bar (if no fixed isIncome)
        if (widget.isIncome == null) ...[
          _buildTabBar(),
          const SizedBox(height: 16),
        ],

        // Category Grid
        Expanded(
          child: categoryState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildCategoryGrid(categoryState),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBorder.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Expense'),
          Tab(text: 'Income'),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(CategoryState categoryState) {
    final categories = categoryState.categories
        .where((c) => c.isIncome == _showingIncome)
        .toList();

    final itemCount =
        widget.showAddButton ? categories.length + 1 : categories.length;

    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.sm),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.85,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Add button at the end
        if (widget.showAddButton && index == categories.length) {
          return _buildAddButton();
        }

        final category = categories[index];
        final isSelected = category.id == widget.selectedCategoryId;

        return _buildCategoryItem(category, isSelected);
      },
    );
  }

  Widget _buildCategoryItem(Category category, bool isSelected) {
    final color = _parseColor(category.colorCode);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onCategorySelected?.call(category);
      },
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.6)
                : AppColors.glassBorder.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container - smaller and cleaner
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: AppAnimations.quick,
              curve: AppAnimations.spring,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconData(category),
                  color: color,
                  size: 18,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            // Category name - better typography
            Text(
              category.name,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : AppColors.textSecondary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: widget.onAddCategory ?? _showAddCategorySheet,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: AppColors.primaryAccent.withValues(alpha: 0.3),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primaryAccent,
                size: 20,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Add New',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  /// Get icon based on category icon name
  IconData _getIconData(Category category) {
    return IconRegistry.getIcon(category.name.toLowerCase().replaceAll(' ', '_'));
  }
}

/// Compact version of the category selector for use in forms
class CategoryGridSelectorCompact extends ConsumerWidget {
  final String? selectedCategoryId;
  final ValueChanged<Category>? onCategorySelected;
  final bool isIncome;
  final int maxVisible;

  const CategoryGridSelectorCompact({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
    required this.isIncome,
    this.maxVisible = 8,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryProvider);

    final categories = categoryState.categories
        .where((c) => c.isIncome == isIncome)
        .take(maxVisible)
        .toList();

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;
          final color = _parseColor(category.colorCode);

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onCategorySelected?.call(category);
            },
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              width: 64,
              padding: EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.15)
                    : AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: isSelected
                      ? color.withValues(alpha: 0.6)
                      : AppColors.glassBorder.withValues(alpha: 0.3),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category,
                      color: color,
                      size: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    category.name,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9,
                      color: isSelected ? color : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
}
