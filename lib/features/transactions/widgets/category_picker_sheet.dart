import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/categories/widgets/add_category_form.dart'
    as add_category_form;
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

/// Shows a category picker in a bottom sheet.
/// Returns the selected category when user makes a selection.
Future<Category?> showCategoryPickerSheet({
  required BuildContext context,
  required WidgetRef ref,
  String? selectedCategoryId,
  Color? accentColor,
}) {
  return showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (context) => _CategoryPickerSheet(
      selectedCategoryId: selectedCategoryId,
      accentColor: accentColor,
    ),
  );
}

class _CategoryPickerSheet extends ConsumerStatefulWidget {
  const _CategoryPickerSheet({this.selectedCategoryId, this.accentColor});

  final String? selectedCategoryId;

  /// The colour of the money being entered. Kept for callers; the tiles take
  /// their colour from the categories themselves.
  final Color? accentColor;

  @override
  ConsumerState<_CategoryPickerSheet> createState() =>
      _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends ConsumerState<_CategoryPickerSheet> {
  /// The category whose subcategories are being shown, or null at the top.
  ///
  /// Opening a parent replaces the grid rather than expanding inside it: at
  /// four tiles to a row, inserting a handful of children after their parent
  /// pushes everything else out of position and leaves the reader hunting for
  /// where the list resumed.
  String? _openParentId;

  static Color _parseColor(String? colorCode) {
    if (colorCode == null) return AppColors.primaryAccent;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return AppColors.primaryAccent;
    } catch (e) {
      return AppColors.primaryAccent;
    }
  }

  void _showAddCategoryForm(BuildContext context, {String? parentId}) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return add_category_form.AddCategoryForm(initialParentId: parentId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    // Every category, whichever way the money is going. A category is a label
    // for what something was — the direction is already recorded on the
    // transaction, and asking the label to agree with it only ever meant
    // maintaining two lists and picking from the wrong one.
    //
    // Transfer and Balance Correction stay out: those are the app's own
    // bookkeeping, written when it moves money between wallets or reconciles a
    // balance, and nothing should be filed under them by hand.
    final usable = categoryState.categories.where((c) => !c.isSystem).toList();

    final openParent = _openParentId == null
        ? null
        : usable.where((c) => c.id == _openParentId).firstOrNull;

    // Inside a parent: its children, and the parent itself, because "Food" is
    // still a legitimate answer for a meal that was not specifically a sandwich.
    // At the top: only categories that stand on their own, so a subcategory is
    // reached through the thing it belongs to rather than sitting beside it
    // with no indication of what it is part of.
    final categories = openParent == null
        ? usable.where((c) => c.mainCategoryId == null).toList()
        : [
            openParent,
            ...usable.where((c) => c.mainCategoryId == openParent.id),
          ];

    final childCounts = <String, int>{};
    for (final category in usable) {
      final parent = category.mainCategoryId;
      if (parent == null) continue;
      childCounts[parent] = (childCounts[parent] ?? 0) + 1;
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        decoration: BoxDecoration(
          // The app's card surface, not the near-black at the bottom of the
          // palette. A sheet sits above the background and should read that
          // way; painted in `primaryDark` it looked like a hole in the screen.
          gradient: AppColors.cardGradient,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXxxl),
          ),
          border: Border(top: BorderSide(color: AppColors.glassBorder)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacing.gapXl,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Row(
                children: [
                  if (openParent != null) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _openParentId = null),
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: AppSpacing.iconSm,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      openParent?.name ?? 'Select category',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            Expanded(
              child: categoryState.isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                      child: Column(
                        children: [
                          ShimmerCard(height: 72),
                          AppSpacing.gapMd,
                          ShimmerCard(height: 72),
                          AppSpacing.gapMd,
                          ShimmerCard(height: 72),
                        ],
                      ),
                    )
                  // Four to a row: a category is recognised by its icon long
                  // before its name is read, so the icons are what the layout
                  // is built around. The tiles carry no frame of their own —
                  // the tinted glyph is the object, and drawing a card around
                  // it as well is what made the old grid feel heavy.
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.xl + MediaQuery.of(context).padding.bottom,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: AppSpacing.lg,
                            crossAxisSpacing: AppSpacing.sm,
                            childAspectRatio: 0.82,
                          ),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == categories.length) {
                          return _NewCategoryTile(
                            // Inside a parent, New makes another of its kind.
                            onTap: () => _showAddCategoryForm(
                              context,
                              parentId: openParent?.id,
                            ),
                          );
                        }

                        final category = categories[index];
                        final children = childCounts[category.id] ?? 0;
                        final opensInto = openParent == null && children > 0;

                        return _CategoryTile(
                          name: category.name,
                          iconName: category.iconName ?? 'category',
                          tint: _parseColor(category.colorCode),
                          isSelected: category.id == widget.selectedCategoryId,
                          subcategoryCount: opensInto ? children : 0,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            if (opensInto) {
                              setState(() => _openParentId = category.id);
                              return;
                            }
                            Navigator.pop(context, category);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One category: its glyph, and its name underneath.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.name,
    required this.iconName,
    required this.tint,
    required this.isSelected,
    required this.onTap,
    this.subcategoryCount = 0,
  });

  final String name;
  final String iconName;
  final Color tint;
  final bool isSelected;
  final VoidCallback onTap;

  /// How many categories sit inside this one. Non-zero means tapping opens it
  /// rather than choosing it, which the tile has to say before it is tapped.
  final int subcategoryCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLg,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: isSelected ? 0.28 : 0.15),
              borderRadius: AppSpacing.borderRadiusLg,
              // Selection is a ring, not more fill: the tile is already this
              // category's colour, so making it more of that colour says
              // nothing. An outline says "this one".
              border: Border.all(
                color: isSelected ? tint : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  IconRegistry.getIcon(iconName),
                  size: AppSpacing.iconMd,
                  color: tint,
                ),
                if (subcategoryCount > 0)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: tint,
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Text(
                        '$subcategoryCount',
                        style: AppTypography.labelSmall.copyWith(
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapXs,
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                letterSpacing: 0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? tint : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The way out of this sheet when none of the categories fit.
class _NewCategoryTile extends StatelessWidget {
  const _NewCategoryTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLg,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(
              Icons.add_rounded,
              size: AppSpacing.iconMd,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapXs,
          Expanded(
            child: Text(
              'New',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                letterSpacing: 0,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
