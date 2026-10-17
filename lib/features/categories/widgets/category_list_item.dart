import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One category as a Sunrise row: its own icon on its colour, the name, and
/// a lock (built-in) or edit and delete (the user's own), and a way to put it
/// away or bring it back.
class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  /// Archives the category, or brings it back when [isArchived]. Null for the
  /// app's own bookkeeping categories, which are never offered anyway.
  final VoidCallback? onArchive;
  final bool isArchived;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onDelete,
    this.onEdit,
    this.onArchive,
    this.isArchived = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final color = ColorUtils.hexToColor(category.colorCode);
    final icon = category.iconName != null
        ? IconRegistry.getIcon(category.iconName)
        : (category.type == 'expense'
              ? Symbols.north_east_rounded
              : Symbols.south_west_rounded);

    final archiveButton = onArchive == null
        ? null
        : IconButton(
            tooltip: isArchived
                ? L10n.of(context).catUnarchive
                : L10n.of(context).catArchive,
            icon: Icon(
              isArchived ? Symbols.unarchive_rounded : Symbols.archive_rounded,
              size: 20,
              color: c.subtle,
            ),
            onPressed: onArchive,
          );

    final row = SunriseCard(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      onTap: category.isDefault || isArchived ? null : onEdit,
      child: Row(
        children: [
          IconTile(
            icon: icon,
            emoji: IconRegistry.emojiOf(category.iconName),
            color: color,
            size: 42,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.rowTitle.copyWith(color: c.ink),
            ),
          ),
          ?archiveButton,
          if (isArchived)
            const SizedBox.shrink()
          else if (category.isDefault)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Symbols.lock_rounded, size: 18, color: c.faint),
            )
          else ...[
            IconButton(
              icon: Icon(Symbols.edit_rounded, size: 20, color: c.subtle),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              icon: Icon(Symbols.delete_rounded, size: 20, color: c.negative),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
    return isArchived ? Opacity(opacity: .55, child: row) : row;
  }
}

// Simple Category class for the widget
class Category {
  final String id;
  final String name;
  final String colorCode;
  final String type; // 'expense' or 'income'
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
