import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/core/constants/app_constants.dart';
import 'package:the_accountant/core/utils/color_utils.dart';

class AddCategoryForm extends ConsumerStatefulWidget {
  final Category? category;

  const AddCategoryForm({super.key, this.category});

  @override
  ConsumerState<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends ConsumerState<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = AppConstants.categoryTypeExpense;
  String _selectedColor = '#FF6B6B'; // Default red color

  static final List<Map<String, String>> _defaultColors = [
    {'name': 'Red', 'code': '#FF6B6B'},
    {'name': 'Blue', 'code': '#4ECDC4'},
    {'name': 'Green', 'code': '#45B7D1'},
    {'name': 'Orange', 'code': '#FFA07A'},
    {'name': 'Purple', 'code': '#96CEB4'},
    {'name': 'Yellow', 'code': '#FFEAA7'},
    {'name': 'Pink', 'code': '#DDA0DD'},
    {'name': 'Teal', 'code': '#98D8C8'},
    {'name': 'Cyan', 'code': '#F7DC6F'},
    {'name': 'Lime', 'code': '#58D68D'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedType = widget.category!.type;
      _selectedColor = widget.category!.colorCode;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final categoryProviderNotifier = ref.read(categoryProvider.notifier);

      if (widget.category != null) {
        // Update existing category
        categoryProviderNotifier.updateCategory(
          id: widget.category!.id,
          name: _nameController.text,
          colorCode: _selectedColor,
          type: _selectedType,
        );
      } else {
        // Add new category
        categoryProviderNotifier.addCategory(
          name: _nameController.text,
          colorCode: _selectedColor,
          type: _selectedType,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category != null ? 'Edit Category' : 'Add Category',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Category name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Category type
              const Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: _selectedType == AppConstants.categoryTypeExpense,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = AppConstants.categoryTypeExpense;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: _selectedType == AppConstants.categoryTypeIncome,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = AppConstants.categoryTypeIncome;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Color selection
              const Text(
                'Color',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _defaultColors.map((colorOption) {
                  final color = ColorUtils.hexToColor(colorOption['code']!);
                  return ChoiceChip(
                    label: Text(colorOption['name']!),
                    selected: _selectedColor == colorOption['code'],
                    selectedColor: color.withValues(alpha: 0.3),
                    onSelected: (selected) {
                      setState(() {
                        _selectedColor = colorOption['code']!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ColorUtils.hexToColor(
                          _selectedColor,
                        ).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedType == AppConstants.categoryTypeExpense
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: ColorUtils.hexToColor(_selectedColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _nameController.text.isEmpty
                          ? 'Category Preview'
                          : _nameController.text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: categoryState.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: categoryState.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.category != null
                              ? 'Update Category'
                              : 'Add Category',
                        ),
                ),
              ),
              if (categoryState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    categoryState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Simple Category class for the form
class Category {
  final String id;
  final String name;
  final String colorCode;
  final String type; // 'expense' or 'income'
  final bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.type,
    required this.isDefault,
  });
}
