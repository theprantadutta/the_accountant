import 'package:flutter/material.dart';
import 'package:the_accountant/core/utils/color_utils.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.hexToColor(category.colorCode);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            category.type == 'expense'
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: color,
          ),
        ),
        title: Text(category.name),
        trailing: category.isDefault
            ? const Icon(Icons.lock, size: 16, color: Colors.grey)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18),
                    onPressed: onDelete,
                  ),
                ],
              ),
      ),
    );
  }
}

// Simple Category class for the widget
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
