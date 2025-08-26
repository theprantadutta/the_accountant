import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart' as category_provider;
import 'package:the_accountant/features/categories/widgets/add_category_form.dart' as add_category_form;
import 'package:the_accountant/features/categories/widgets/add_category_form.dart' show Category;
import 'package:the_accountant/features/categories/widgets/category_list_item.dart' as category_list_item;

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(category_provider.categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddCategoryDialog(context, ref);
            },
          ),
        ],
      ),
      body: categoryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Expense categories section
                _buildCategorySection(
                  context,
                  ref,
                  'Expense Categories',
                  categoryState.categories
                      .where((c) => c.type == 'expense')
                      .toList(),
                ),
                // Income categories section
                _buildCategorySection(
                  context,
                  ref,
                  'Income Categories',
                  categoryState.categories
                      .where((c) => c.type == 'income')
                      .toList(),
                ),
              ],
            ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<category_provider.Category> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (categories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'No ${title.toLowerCase()} yet',
              style: const TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              // Fix: Create a Category object compatible with CategoryListItem
              final listItemCategory = category_list_item.Category(
                id: category.id,
                name: category.name,
                colorCode: category.colorCode,
                type: category.type,
                isDefault: category.isDefault,
              );
              
              return category_list_item.CategoryListItem(
                category: listItemCategory,
                onDelete: category.isDefault
                    ? null
                    : () {
                        _confirmDeleteCategory(context, ref, category);
                      },
                onEdit: category.isDefault
                    ? null
                    : () {
                        _showEditCategoryDialog(context, ref, category);
                      },
              );
            },
          ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const add_category_form.AddCategoryForm();
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, WidgetRef ref, category_provider.Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Create a new Category object compatible with AddCategoryForm
        final addCategoryFormCategory = Category(
          id: category.id,
          name: category.name,
          colorCode: category.colorCode,
          type: category.type,
          isDefault: category.isDefault,
        );
        return add_category_form.AddCategoryForm(category: addCategoryFormCategory);
      },
    );
  }

  void _confirmDeleteCategory(BuildContext context, WidgetRef ref, category_provider.Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(category_provider.categoryProvider.notifier).deleteCategory(category.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}