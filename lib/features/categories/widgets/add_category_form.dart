import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/core/constants/app_constants.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/widgets/upgrade_limit_dialog.dart';

class AddCategoryForm extends ConsumerStatefulWidget {
  final Category? category;

  const AddCategoryForm({super.key, this.category});

  @override
  ConsumerState<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends ConsumerState<AddCategoryForm> {
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedType = AppConstants.categoryTypeExpense;
  String _selectedColor = '#FF6B6B';
  String _selectedIcon = 'category';

  static const List<String> _colors = [
    '#FF6B6B', // Red
    '#FF8E72', // Coral
    '#FFA94D', // Orange
    '#FFD43B', // Yellow
    '#A9E34B', // Lime
    '#69DB7C', // Green
    '#38D9A9', // Teal
    '#4ECDC4', // Cyan
    '#74C0FC', // Light Blue
    '#748FFC', // Indigo
    '#9775FA', // Purple
    '#DA77F2', // Magenta
    '#F783AC', // Pink
    '#CED4DA', // Gray
  ];

  static const List<String> _icons = [
    'shopping_cart',
    'restaurant',
    'local_grocery_store',
    'directions_car',
    'flight',
    'home',
    'medical_services',
    'school',
    'fitness_center',
    'movie',
    'music_note',
    'pets',
    'child_care',
    'work',
    'attach_money',
    'card_giftcard',
    'category',
    'more_horiz',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedType = widget.category!.type;
      _selectedColor = widget.category!.colorCode;
      _selectedIcon = widget.category!.iconName ?? 'category';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a category name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final categoryProviderNotifier = ref.read(categoryProvider.notifier);

    try {
      if (widget.category != null) {
        await categoryProviderNotifier.updateCategory(
          id: widget.category!.id,
          name: name,
          colorCode: _selectedColor,
          type: _selectedType,
          iconName: _selectedIcon,
        );
      } else {
        await categoryProviderNotifier.addCategory(
          name: name,
          colorCode: _selectedColor,
          type: _selectedType,
          iconName: _selectedIcon,
        );
      }

      HapticFeedback.mediumImpact();
      if (mounted) Navigator.pop(context);
    } on PremiumLimitException catch (e) {
      if (mounted) {
        await UpgradeLimitDialog.showFromException(context, e);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save category: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Color get _color => ColorUtils.hexToColor(_selectedColor);
  bool get _isIncome => _selectedType == AppConstants.categoryTypeIncome;

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
              child: Row(
                children: [
                  Text(
                    widget.category != null ? 'Edit Category' : 'New Category',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview card
                    _buildPreviewCard(),
                    const SizedBox(height: 28),

                    // Category name input
                    _buildSectionLabel('Name'),
                    const SizedBox(height: 10),
                    _buildNameInput(),
                    const SizedBox(height: 24),

                    // Type selection
                    _buildSectionLabel('Type'),
                    const SizedBox(height: 10),
                    _buildTypeToggle(),
                    const SizedBox(height: 24),

                    // Color selection
                    _buildSectionLabel('Color'),
                    const SizedBox(height: 10),
                    _buildColorGrid(),
                    const SizedBox(height: 24),

                    // Icon selection
                    _buildSectionLabel('Icon'),
                    const SizedBox(height: 10),
                    _buildIconGrid(),
                    const SizedBox(height: 32),

                    // Submit button
                    _buildSubmitButton(categoryState.isLoading),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              IconRegistry.getIcon(_selectedIcon),
              size: 28,
              color: _color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text.isEmpty
                      ? 'Category Name'
                      : _nameController.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _nameController.text.isEmpty
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (_isIncome ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _isIncome ? 'Income' : 'Expense',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isIncome ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return TextField(
      controller: _nameController,
      focusNode: _focusNode,
      style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Enter category name',
        hintStyle: TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _color, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(
                  () => _selectedType = AppConstants.categoryTypeExpense,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isIncome ? AppColors.error : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Expense',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_isIncome ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedType = AppConstants.categoryTypeIncome);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isIncome ? AppColors.success : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Income',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isIncome ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _colors.map((colorCode) {
        final color = ColorUtils.hexToColor(colorCode);
        final isSelected = _selectedColor == colorCode;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _selectedColor = colorCode);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIconGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _icons.map((iconName) {
        final isSelected = _selectedIcon == iconName;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _selectedIcon = iconName);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? _color.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              IconRegistry.getIcon(iconName),
              size: 24,
              color: isSelected ? _color : AppColors.textSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _color.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.category != null ? 'Update Category' : 'Create Category',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
  final String type;
  final bool isDefault;
  final String? iconName;

  Category({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.type,
    required this.isDefault,
    this.iconName,
  });
}
