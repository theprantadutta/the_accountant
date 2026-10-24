import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as category_provider;
import 'package:the_accountant/features/categories/widgets/add_category_form.dart'
    as add_category_form;
import 'package:the_accountant/features/categories/widgets/category_list_item.dart'
    as category_list_item;
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';

/// What the search bar on this screen holds; empty shows everything.
final _categoryQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(category_provider.categoryProvider);
    final query = ref.watch(_categoryQueryProvider).trim().toLowerCase();
    // A name match, or a match on the parent, so searching "Food" also shows
    // what is filed inside it.
    final names = {for (final c in categoryState.categories) c.id: c.name};
    bool matches(category_provider.Category c) =>
        query.isEmpty ||
        c.name.toLowerCase().contains(query) ||
        (names[c.mainCategoryId]?.toLowerCase().contains(query) ?? false);
    final shown = categoryState.categories.where(matches).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).settingsCategories),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddCategoryDialog(context, ref);
            },
          ),
        ],
      ),
      body: CappedBody(
        child: categoryState.isLoading
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ShimmerCard(height: 64),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                  ],
                ),
              )
            : SingleChildScrollView(
                // The two lists used to sit in a plain Column, which overflowed
                // as soon as there were more categories than fit on screen.
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    const _CategorySearchBar(),
                    if (query.isNotEmpty && shown.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          L10n.of(context).catNoMatch,
                          style: TextStyle(color: context.sunrise.subtle),
                        ),
                      ),
                    // Expense categories section
                    if (query.isEmpty || shown.any((c) => c.type == 'expense'))
                      _buildCategorySection(
                        context,
                        ref,
                        'Expense Categories',
                        shown
                            .where((c) => c.type == 'expense' && !c.isArchived)
                            .toList(),
                      ),
                    // Income categories section
                    if (query.isEmpty || shown.any((c) => c.type == 'income'))
                      _buildCategorySection(
                        context,
                        ref,
                        'Income Categories',
                        shown
                            .where((c) => c.type == 'income' && !c.isArchived)
                            .toList(),
                      ),
                    // Put away, but kept for their history
                    if (shown.any((c) => c.isArchived)) ...[
                      _buildCategorySection(
                        context,
                        ref,
                        L10n.of(context).catArchivedSection,
                        shown.where((c) => c.isArchived).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
                        child: Text(
                          L10n.of(context).catArchivedHint,
                          style: TextStyle(color: context.sunrise.subtle),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
          child: SectionLabel(title),
        ),
        if (categories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'No ${title.toLowerCase()} yet',
              style: TextStyle(color: context.sunrise.subtle),
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
                iconName: category.iconName,
              );

              return category_list_item.CategoryListItem(
                category: listItemCategory,
                isArchived: category.isArchived,
                onArchive: category.isSystem
                    ? null
                    : () => ref
                          .read(category_provider.categoryProvider.notifier)
                          .setArchived(category.id, !category.isArchived),
                onMerge: category.isSystem
                    ? null
                    : () => _mergeCategory(context, ref, category),
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

  /// Ask which category to fold [source] into, confirm, and merge.
  Future<void> _mergeCategory(
    BuildContext context,
    WidgetRef ref,
    category_provider.Category source,
  ) async {
    final l10n = L10n.of(context);
    final all = ref.read(category_provider.categoryProvider).categories;
    final targets =
        all
            .where(
              (c) =>
                  c.id != source.id &&
                  c.type == source.type &&
                  !c.isSystem &&
                  !c.isArchived,
            )
            .toList()
          ..sort((a, b) {
            // Same name first: that is almost always the one meant.
            final sameA = a.name.toLowerCase() == source.name.toLowerCase();
            final sameB = b.name.toLowerCase() == source.name.toLowerCase();
            if (sameA != sameB) return sameA ? -1 : 1;
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
    if (targets.isEmpty) {
      showSunriseSnack(context, l10n.catMergeNoTargets);
      return;
    }

    final target = await showSunriseSheet<category_provider.Category>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.catMergeIntoTitle(source.name),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in targets)
              SheetAction(
                icon: IconRegistry.getIcon(c.iconName),
                label: c.name,
                subtitle: c.isDefault ? l10n.catMergeBuiltIn : null,
                onTap: () => Navigator.pop(sheet, c),
              ),
          ],
        ),
      ),
    );
    if (target == null || !context.mounted) return;

    final confirmed = await showSunriseConfirm(
      context: context,
      title: l10n.catMergeConfirmTitle(source.name, target.name),
      message: l10n.catMergeConfirmBody(source.name, target.name),
      confirmLabel: l10n.catMergeAction,
      icon: Symbols.merge_rounded,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref
          .read(category_provider.categoryProvider.notifier)
          .mergeInto(sourceId: source.id, targetId: target.id);
      // Transactions, budgets and reports all moved underneath their screens.
      reloadAllData(ref);
      if (context.mounted) {
        showSunriseSnack(
          context,
          l10n.catMerged(source.name, target.name),
          tone: SnackTone.success,
        );
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(
          context,
          e.message?.toString() ?? l10n.catMergeFailed,
          tone: SnackTone.error,
        );
      }
    }
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

  void _showEditCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    category_provider.Category category,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return add_category_form.AddCategoryForm(category: category);
      },
    );
  }

  void _confirmDeleteCategory(
    BuildContext context,
    WidgetRef ref,
    category_provider.Category category,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.of(context).catDeleteCategory),
          content: Text('Are you sure you want to delete "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(L10n.of(context).actionCancel),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(category_provider.categoryProvider.notifier)
                    .deleteCategory(category.id);
                Navigator.pop(context);
              },
              child: Text(L10n.of(context).actionDelete),
            ),
          ],
        );
      },
    );
  }
}

/// The search bar at the top of the list. Owns its text so the × can clear it.
class _CategorySearchBar extends ConsumerStatefulWidget {
  const _CategorySearchBar();

  @override
  ConsumerState<_CategorySearchBar> createState() => _CategorySearchBarState();
}

class _CategorySearchBarState extends ConsumerState<_CategorySearchBar> {
  // Starts from the query in force: the bar is rebuilt from scratch when the
  // list reloads underneath it (a merge does), and an empty box over a
  // filtered list reads as "this category does not exist".
  late final _controller = TextEditingController(
    text: ref.read(_categoryQueryProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: SunriseSearchField(
        hint: L10n.of(context).catSearch,
        controller: _controller,
        onChanged: (value) =>
            ref.read(_categoryQueryProvider.notifier).state = value,
        onClear: () {
          _controller.clear();
          ref.read(_categoryQueryProvider.notifier).state = '';
        },
      ),
    );
  }
}
