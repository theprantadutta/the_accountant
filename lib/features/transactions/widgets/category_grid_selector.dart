import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        childAspectRatio: 0.9,
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
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(category.id),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            // Name
            Padding(
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.primary,
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

  /// Get icon based on category name (fallback icons)
  /// In a real app, you'd store icon names in the database
  IconData _getIconData(String categoryId) {
    // Default icon mapping based on common category names
    // This can be extended to use stored iconName from database
    final iconMap = <String, IconData>{
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'shopping_bag': Icons.shopping_bag,
      'movie': Icons.movie,
      'receipt': Icons.receipt,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'flight': Icons.flight,
      'local_grocery_store': Icons.local_grocery_store,
      'home': Icons.home,
      'security': Icons.security,
      'spa': Icons.spa,
      'subscriptions': Icons.subscriptions,
      'card_giftcard': Icons.card_giftcard,
      'more_horiz': Icons.more_horiz,
      'work': Icons.work,
      'laptop': Icons.laptop,
      'business': Icons.business,
      'trending_up': Icons.trending_up,
      'apartment': Icons.apartment,
      'star': Icons.star,
      'redeem': Icons.redeem,
      'replay': Icons.replay,
      'add_circle': Icons.add_circle,
    };

    // For now, return a default icon
    // In a full implementation, we'd look up the category's iconName
    return Icons.category;
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
