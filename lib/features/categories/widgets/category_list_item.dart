import 'package:flutter/material.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One thing that can be done to a category, offered in its row's menu.
class CategoryAction {
  const CategoryAction({
    required this.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  /// Stable identifier, for tests and for the menu's value.
  final String key;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
}

/// One category as a Sunrise row: its own icon on its colour, the name, what
/// it holds, a lock on a built-in, and a menu of what can be done with it.
///
/// A subcategory is drawn indented under its parent, one step per level,
/// and smaller, so the list reads as the tree it is. One with subcategories
/// of its own says how many and carries a chevron that turns as it opens.
class CategoryListItem extends StatelessWidget {
  final Category category;

  /// "3 subcategories · 12 transactions", or where a search result sits.
  final String? subtitle;

  /// How far down the tree it sits: 0 for a top-level category.
  final int depth;
  final bool isArchived;

  /// What tapping the row does; usually edit. Null makes it inert.
  final VoidCallback? onTap;
  final List<CategoryAction> actions;

  /// How many subcategories it has; with [onToggle], it can be opened.
  final int childCount;
  final bool expanded;
  final VoidCallback? onToggle;

  const CategoryListItem({
    super.key,
    required this.category,
    this.subtitle,
    this.depth = 0,
    this.isArchived = false,
    this.onTap,
    this.actions = const [],
    this.childCount = 0,
    this.expanded = false,
    this.onToggle,
  });

  bool get isChild => depth > 0;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final color = ColorUtils.hexToColor(category.colorCode);
    final icon = category.iconName != null
        ? IconRegistry.getIcon(category.iconName)
        : (category.type == 'expense'
              ? Symbols.north_east_rounded
              : Symbols.south_west_rounded);

    final row = SunriseCard(
      margin: EdgeInsets.fromLTRB(
        SunriseSpace.screenX + 24.0 * depth,
        isChild ? 3 : 5,
        SunriseSpace.screenX,
        isChild ? 3 : 5,
      ),
      padding: EdgeInsets.fromLTRB(12, isChild ? 6 : 10, 4, isChild ? 6 : 10),
      onTap: isArchived ? null : (onToggle ?? onTap),
      child: Row(
        children: [
          IconTile(
            icon: icon,
            emoji: IconRegistry.emojiOf(category.iconName),
            color: color,
            size: isChild ? 34 : 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(
                    color: c.ink,
                    fontSize: isChild ? 15 : null,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
              ],
            ),
          ),
          if (category.isDefault && !isArchived)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Symbols.lock_rounded, size: 16, color: c.faint),
            ),
          if (onToggle != null)
            _ExpandChevron(
              key: Key('category_expand_${category.id}'),
              count: childCount,
              expanded: expanded,
              color: color,
              onTap: onToggle!,
            ),
          if (actions.isEmpty)
            const SizedBox(width: 8)
          else
            PopupMenuButton<String>(
              key: Key('category_menu_${category.id}'),
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              icon: Icon(Symbols.more_vert_rounded, color: c.subtle),
              onSelected: (key) =>
                  actions.firstWhere((a) => a.key == key).onTap(),
              itemBuilder: (context) => [
                for (final action in actions)
                  PopupMenuItem(
                    value: action.key,
                    child: Row(
                      children: [
                        Icon(
                          action.icon,
                          size: 20,
                          color: action.destructive ? c.negative : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          action.label,
                          style: TextStyle(
                            color: action.destructive ? c.negative : null,
                          ),
                        ),
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

/// How many subcategories a category has, and a chevron that turns down
/// when they are shown.
class _ExpandChevron extends StatelessWidget {
  const _ExpandChevron({
    super.key,
    required this.count,
    required this.expanded,
    required this.color,
    required this.onTap,
  });

  final int count;
  final bool expanded;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Semantics(
      button: true,
      expanded: expanded,
      child: Pressable(
        onTap: onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.only(left: 10, right: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: expanded ? .2 : .12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (count > 0)
                Text(
                  '$count',
                  style: SunriseType.label.copyWith(
                    color: c.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              AnimatedRotation(
                turns: expanded ? .5 : 0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Symbols.expand_more_rounded,
                  size: 20,
                  color: c.ink,
                ),
              ),
            ],
          ),
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
