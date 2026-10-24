import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One category as a Sunrise row: its own icon on its colour, the name, a
/// lock on a built-in, and a menu to edit, archive or delete it.
class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  /// Archives the category, or brings it back when [isArchived]. Null for the
  /// app's own bookkeeping categories, which are never offered anyway.
  final VoidCallback? onArchive;

  /// Folds this category into another. Null when it cannot be merged.
  final VoidCallback? onMerge;
  final bool isArchived;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onDelete,
    this.onEdit,
    this.onArchive,
    this.onMerge,
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

    // One menu rather than three buttons. Archive, edit and delete side by
    // side left a 360dp phone about a hundred points for the name, so most
    // ended in "…". Tapping the row still edits.
    final actions = <(String, IconData, String, Color?)>[
      if (onEdit != null && !isArchived && !category.isDefault)
        ('edit', Symbols.edit_rounded, L10n.of(context).actionEdit, null),
      if (onMerge != null && !isArchived)
        ('merge', Symbols.merge_rounded, L10n.of(context).catMergeInto, null),
      if (onArchive != null)
        (
          'archive',
          isArchived ? Symbols.unarchive_rounded : Symbols.archive_rounded,
          isArchived
              ? L10n.of(context).catUnarchive
              : L10n.of(context).catArchive,
          null,
        ),
      if (onDelete != null && !isArchived && !category.isDefault)
        (
          'delete',
          Symbols.delete_rounded,
          MaterialLocalizations.of(context).deleteButtonTooltip,
          c.negative,
        ),
    ];

    final row = SunriseCard(
      margin: const EdgeInsets.symmetric(
        horizontal: SunriseSpace.screenX,
        vertical: 5,
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      onTap: category.isDefault || isArchived ? null : onEdit,
      child: Row(
        children: [
          IconTile(
            icon: icon,
            emoji: IconRegistry.emojiOf(category.iconName),
            color: color,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.rowTitle.copyWith(color: c.ink),
            ),
          ),
          if (category.isDefault && !isArchived)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Symbols.lock_rounded, size: 16, color: c.faint),
            ),
          if (actions.isEmpty)
            const SizedBox(width: 8)
          else
            PopupMenuButton<String>(
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              icon: Icon(Symbols.more_vert_rounded, color: c.subtle),
              onSelected: (action) => switch (action) {
                'edit' => onEdit?.call(),
                'archive' => onArchive?.call(),
                'merge' => onMerge?.call(),
                'delete' => onDelete?.call(),
                _ => null,
              },
              itemBuilder: (context) => [
                for (final (value, glyph, label, tint) in actions)
                  PopupMenuItem(
                    value: value,
                    child: Row(
                      children: [
                        Icon(glyph, size: 20, color: tint),
                        const SizedBox(width: 12),
                        Text(label, style: TextStyle(color: tint)),
                      ],
                    ),
                  ),
              ],
            ),
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
