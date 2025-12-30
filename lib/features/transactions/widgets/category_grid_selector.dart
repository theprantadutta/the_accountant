import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';

/// A grid-based category selector widget (like Cashew).
/// Displays categories as colored icons in a 4-column grid.
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
  ConsumerState<CategoryGridSelector> createState() => _CategoryGridSelectorState();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryState = ref.watch(categoryProvider);

    return Column(
      children: [
        // Tab Bar (if no fixed isIncome)
        if (widget.isIncome == null) ...[
          _buildTabBar(theme),
          const SizedBox(height: 16),
        ],

        // Category Grid
        Expanded(
          child: categoryState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildCategoryGrid(theme, categoryState),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: theme.colorScheme.onSurface,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Expense'),
          Tab(text: 'Income'),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(ThemeData theme, CategoryState categoryState) {
    final categories = categoryState.categories
        .where((c) => c.isIncome == _showingIncome)
        .toList();

    final itemCount = widget.showAddButton ? categories.length + 1 : categories.length;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8, // Taller cells to fit icon + text
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Add button at the end
        if (widget.showAddButton && index == categories.length) {
          return _buildAddButton(theme);
        }

        final category = categories[index];
        final isSelected = category.id == widget.selectedCategoryId;

        return _buildCategoryItem(theme, category, isSelected);
      },
    );
  }

  Widget _buildCategoryItem(ThemeData theme, Category category, bool isSelected) {
    final color = _parseColor(category.colorCode);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onCategorySelected?.call(category);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with selection animation
            AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: AppAnimations.quick,
              curve: AppAnimations.spring,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _getIconData(category),
                  color: color,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? color : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onAddCategory?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
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
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.primary,
                ),
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
    // Use the IconRegistry to map icon name to IconData
    // The category provider's Category model has colorCode, but the database has iconName
    // For now, we try to infer from category name or use default
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
    final theme = Theme.of(context);
    final categoryState = ref.watch(categoryProvider);

    final categories = categoryState.categories
        .where((c) => c.isIncome == isIncome)
        .take(maxVisible)
        .toList();

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
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
              duration: const Duration(milliseconds: 200),
              width: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : theme.colorScheme.outline.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.colorScheme.onSurface,
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
