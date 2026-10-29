import 'package:flutter/material.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
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
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';

typedef _Category = category_provider.Category;

/// What the search bar on this screen holds; empty shows everything.
final _categoryQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// How many live transactions each category holds, so a move or a delete can
/// say what it will touch before it touches it.
final _transactionCountsProvider = FutureProvider.autoDispose<Map<String, int>>(
  (ref) {
    // Re-read whenever the transactions change underneath.
    ref.watch(transactionProvider.select((s) => s.transactions.length));
    return ref.watch(databaseProvider).liveTransactionCountsByCategory();
  },
);

/// Which categories have their subcategories showing. Closed to start with,
/// so the screen opens on the top-level categories alone.
final _expandedProvider = StateProvider.autoDispose<Set<String>>((ref) => {});

/// Every category, as the tree it is: the top-level categories, each opening
/// onto its subcategories, and theirs, with what each holds and a menu of
/// what can be done.
///
/// Subcategories could be made but not managed: the list was flat, so one
/// looked like any other category, there was no way to take one out of its
/// parent or put it in another, and moving a category's transactions anywhere
/// meant editing them one at a time.
class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final categoryState = ref.watch(category_provider.categoryProvider);
    final counts = ref.watch(_transactionCountsProvider).value ?? const {};
    final query = ref.watch(_categoryQueryProvider).trim().toLowerCase();
    final all = categoryState.categories;
    final byId = {for (final c in all) c.id: c};

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsCategories),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.actionAdd,
            onPressed: () => _openForm(context),
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
                  ],
                ),
              )
            : SingleChildScrollView(
                // The lists used to sit in a plain Column, which overflowed as
                // soon as there were more categories than fit on screen.
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: query.isEmpty
                      ? _tree(context, ref, all, byId, counts)
                      : _searchResults(context, ref, all, byId, counts, query),
                ),
              ),
      ),
    );
  }

  /// The whole list, unfiltered: expense, income, then archived.
  List<Widget> _tree(
    BuildContext context,
    WidgetRef ref,
    List<_Category> all,
    Map<String, _Category> byId,
    Map<String, int> counts,
  ) {
    final l10n = L10n.of(context);
    // A subcategory whose parent has gone (deleted elsewhere, or archived)
    // stands at the top level rather than disappearing.
    bool isTop(_Category c) {
      final parent = byId[c.mainCategoryId];
      return parent == null || parent.isArchived;
    }

    List<Widget> section(String title, bool income) {
      final tops = all
          .where((c) => c.isIncome == income && !c.isArchived && isTop(c))
          .toList();
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
          child: SectionLabel(title),
        ),
        if (tops.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.catSectionEmpty,
              style: TextStyle(color: context.sunrise.subtle),
            ),
          ),
        for (final top in tops) _branch(context, ref, top, all, byId, counts),
      ];
    }

    final archived = all.where((c) => c.isArchived).toList();
    return [
      const _CategorySearchBar(),
      ...section(l10n.catExpenseSection, false),
      ...section(l10n.catIncomeSection, true),
      if (archived.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
          child: SectionLabel(l10n.catArchivedSection),
        ),
        for (final c in archived) _row(context, ref, c, all, byId, counts),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
          child: Text(
            l10n.catArchivedHint,
            style: TextStyle(color: context.sunrise.subtle),
          ),
        ),
      ],
    ];
  }

  /// [category] and, while it is open, its subcategories beneath it, each of
  /// which can open in turn.
  Widget _branch(
    BuildContext context,
    WidgetRef ref,
    _Category category,
    List<_Category> all,
    Map<String, _Category> byId,
    Map<String, int> counts, {
    int depth = 0,
    Set<String> path = const {},
  }) {
    final kids = all
        .where(
          (c) =>
              c.mainCategoryId == category.id &&
              !c.isArchived &&
              // A category can never be its own ancestor; a bad link in the
              // data must not loop the screen forever.
              !path.contains(c.id),
        )
        .toList();
    final open = ref.watch(_expandedProvider).contains(category.id);
    void toggle() {
      final now = {...ref.read(_expandedProvider)};
      if (!now.remove(category.id)) now.add(category.id);
      ref.read(_expandedProvider.notifier).state = now;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row(
          context,
          ref,
          category,
          all,
          byId,
          counts,
          depth: depth,
          expanded: open,
          onToggle: kids.isEmpty ? null : toggle,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: open && kids.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final k in kids)
                      _branch(
                        context,
                        ref,
                        k,
                        all,
                        byId,
                        counts,
                        depth: depth + 1,
                        path: {...path, category.id},
                      ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  /// A flat list of matches: by name, or by parent, so searching "Food" also
  /// shows what is filed inside it. Each says where it sits.
  List<Widget> _searchResults(
    BuildContext context,
    WidgetRef ref,
    List<_Category> all,
    Map<String, _Category> byId,
    Map<String, int> counts,
    String query,
  ) {
    final shown = all
        .where(
          (c) =>
              c.name.toLowerCase().contains(query) ||
              (byId[c.mainCategoryId]?.name.toLowerCase().contains(query) ??
                  false),
        )
        .toList();
    return [
      const _CategorySearchBar(),
      if (shown.isEmpty)
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            L10n.of(context).catNoMatch,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.sunrise.subtle),
          ),
        ),
      const SizedBox(height: 8),
      for (final c in shown) _row(context, ref, c, all, byId, counts),
    ];
  }

  Widget _row(
    BuildContext context,
    WidgetRef ref,
    _Category category,
    List<_Category> all,
    Map<String, _Category> byId,
    Map<String, int> counts, {
    int depth = 0,
    bool expanded = false,
    VoidCallback? onToggle,
  }) {
    final l10n = L10n.of(context);
    final isChild = depth > 0;
    final children = all.where((c) => c.mainCategoryId == category.id).length;
    final count = counts[category.id] ?? 0;
    final parent = byId[category.mainCategoryId];
    final subtitle = [
      // In a flat list (search, archived) the row has to say where it sits.
      if (!isChild && parent != null) l10n.catInParent(parent.name),
      if (children > 0) l10n.catSubcategoryCount(children),
      l10n.catTransactionCount(count),
    ].join(' · ');

    final editable = !category.isDefault && !category.isArchived;
    final actions = <category_list_item.CategoryAction>[
      if (category.isSystem) ...[
        // Transfer and Balance Correction are the app's own bookkeeping.
      ] else if (category.isArchived)
        category_list_item.CategoryAction(
          key: 'archive',
          icon: Symbols.unarchive_rounded,
          label: l10n.catUnarchive,
          onTap: () => ref
              .read(category_provider.categoryProvider.notifier)
              .setArchived(category.id, false),
        )
      else ...[
        if (editable)
          category_list_item.CategoryAction(
            key: 'edit',
            icon: Symbols.edit_rounded,
            label: l10n.actionEdit,
            onTap: () => _openForm(context, category: category),
          ),
        if (category.mainCategoryId == null || parent == null)
          category_list_item.CategoryAction(
            key: 'add_sub',
            icon: Symbols.add_rounded,
            label: l10n.catAddSubcategory,
            onTap: () => _openForm(context, parentId: category.id),
          ),
        // A category with subcategories of its own stays at the top.
        if (editable && children == 0)
          category_list_item.CategoryAction(
            key: 'move',
            icon: Symbols.drive_file_move_rounded,
            label: l10n.catMoveTo,
            onTap: () => _moveCategory(context, ref, category),
          ),
        if (count > 0)
          category_list_item.CategoryAction(
            key: 'move_transactions',
            icon: Symbols.move_down_rounded,
            label: l10n.catMoveTransactions,
            onTap: () => _moveTransactions(context, ref, category, count),
          ),
        category_list_item.CategoryAction(
          key: 'merge',
          icon: Symbols.merge_rounded,
          label: l10n.catMergeInto,
          onTap: () => _mergeCategory(context, ref, category),
        ),
        category_list_item.CategoryAction(
          key: 'archive',
          icon: Symbols.archive_rounded,
          label: l10n.catArchive,
          onTap: () => ref
              .read(category_provider.categoryProvider.notifier)
              .setArchived(category.id, true),
        ),
        if (editable)
          category_list_item.CategoryAction(
            key: 'delete',
            icon: Symbols.delete_rounded,
            label: l10n.actionDelete,
            destructive: true,
            onTap: () =>
                _deleteCategory(context, ref, category, count, children),
          ),
      ],
    ];

    return category_list_item.CategoryListItem(
      key: Key('category_${category.id}'),
      category: category_list_item.Category(
        id: category.id,
        name: category.name,
        colorCode: category.colorCode,
        type: category.type,
        isDefault: category.isDefault,
        iconName: category.iconName,
      ),
      subtitle: subtitle,
      depth: depth,
      isArchived: category.isArchived,
      childCount: onToggle == null ? 0 : children,
      expanded: expanded,
      onToggle: onToggle,
      onTap: editable ? () => _openForm(context, category: category) : null,
      actions: actions,
    );
  }

  /// Everything [source]'s transactions could be filed under instead: the same
  /// kind, not the app's own, not archived, not itself. Each subcategory
  /// follows its parent, as in the list.
  List<_Category> _destinations(
    List<_Category> all,
    _Category source, {
    bool topLevelOnly = false,
  }) {
    final usable = all
        .where(
          (c) =>
              c.id != source.id &&
              c.type == source.type &&
              !c.isSystem &&
              !c.isArchived &&
              (!topLevelOnly || c.mainCategoryId == null),
        )
        .toList();
    final ids = {for (final c in usable) c.id};
    final ordered = <_Category>[];
    for (final top in usable.where(
      (c) => c.mainCategoryId == null || !ids.contains(c.mainCategoryId),
    )) {
      ordered.add(top);
      ordered.addAll(usable.where((c) => c.mainCategoryId == top.id));
    }
    return ordered;
  }

  /// A sheet listing [options]; resolves to the one picked.
  Future<_Category?> _pickCategory(
    BuildContext context, {
    required String title,
    required List<_Category> options,
    List<_Category> all = const [],
  }) {
    final l10n = L10n.of(context);
    final names = {for (final c in all) c.id: c.name};
    return showSunriseSheet<_Category>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in options)
              Padding(
                padding: EdgeInsets.only(
                  left: names.containsKey(c.mainCategoryId) ? 24 : 0,
                ),
                child: SheetAction(
                  key: Key('pick_${c.id}'),
                  icon: IconRegistry.getIcon(c.iconName),
                  label: c.name,
                  subtitle: c.isDefault ? l10n.catMergeBuiltIn : null,
                  onTap: () => Navigator.pop(sheet, c),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Take [category] out of its parent, or put it inside another.
  Future<void> _moveCategory(
    BuildContext context,
    WidgetRef ref,
    _Category category,
  ) async {
    final l10n = L10n.of(context);
    final all = ref.read(category_provider.categoryProvider).categories;
    final parents = all
        .where(
          (c) =>
              c.id != category.id &&
              c.id != category.mainCategoryId &&
              c.type == category.type &&
              c.mainCategoryId == null &&
              !c.isSystem &&
              !c.isArchived,
        )
        .toList();
    final atTop = category.mainCategoryId == null;
    if (parents.isEmpty && atTop) {
      showSunriseSnack(context, l10n.catMoveNoParents);
      return;
    }

    // A record rather than null for "top level", so dismissing the sheet
    // (also null) cannot be mistaken for choosing it.
    final choice = await showSunriseSheet<({_Category? parent})>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.catMoveToTitle(category.name),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!atTop)
              SheetAction(
                key: const Key('pick_top_level'),
                icon: Symbols.vertical_align_top_rounded,
                label: l10n.catTopLevel,
                subtitle: l10n.catTopLevelHint,
                onTap: () => Navigator.pop(sheet, (parent: null)),
              ),
            for (final p in parents)
              SheetAction(
                key: Key('pick_${p.id}'),
                icon: IconRegistry.getIcon(p.iconName),
                label: p.name,
                subtitle: p.isDefault ? l10n.catMergeBuiltIn : null,
                onTap: () => Navigator.pop(sheet, (parent: p)),
              ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;

    await _run(context, () async {
      await ref
          .read(category_provider.categoryProvider.notifier)
          .setParent(category.id, choice.parent?.id);
      return choice.parent == null
          ? l10n.catMovedToTop(category.name)
          : l10n.catMovedInto(category.name, choice.parent!.name);
    }, reloadEverything: false);
  }

  /// Refile everything in [source] under another category, keeping both.
  Future<void> _moveTransactions(
    BuildContext context,
    WidgetRef ref,
    _Category source,
    int count,
  ) async {
    final l10n = L10n.of(context);
    final all = ref.read(category_provider.categoryProvider).categories;
    final options = _destinations(all, source);
    if (options.isEmpty) {
      showSunriseSnack(context, l10n.catNoMoveTargets);
      return;
    }
    final target = await _pickCategory(
      context,
      title: l10n.catMoveTransactionsTitle(source.name),
      options: options,
      all: all,
    );
    if (target == null || !context.mounted) return;

    final confirmed = await showSunriseConfirm(
      context: context,
      title: l10n.catMoveTransactionsConfirmTitle(count, target.name),
      message: l10n.catMoveTransactionsConfirmBody(source.name, target.name),
      confirmLabel: l10n.catMoveAction,
      icon: Symbols.move_down_rounded,
    );
    if (!confirmed || !context.mounted) return;

    await _run(context, () async {
      final moved = await ref
          .read(category_provider.categoryProvider.notifier)
          .moveTransactions(sourceId: source.id, targetId: target.id);
      return moved == 0
          ? l10n.catNoTransactionsToMove(source.name)
          : l10n.catMovedTransactions(moved, target.name);
    }, ref: ref);
  }

  /// Ask which category to fold [source] into, confirm, and merge.
  Future<void> _mergeCategory(
    BuildContext context,
    WidgetRef ref,
    _Category source,
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

    final target = await _pickCategory(
      context,
      title: l10n.catMergeIntoTitle(source.name),
      options: targets,
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

    await _run(context, () async {
      await ref
          .read(category_provider.categoryProvider.notifier)
          .mergeInto(sourceId: source.id, targetId: target.id);
      return l10n.catMerged(source.name, target.name);
    }, ref: ref);
  }

  /// Delete [category], first asking what becomes of what it holds.
  ///
  /// Deleting used to leave its transactions pointing at a category that no
  /// longer existed, and its subcategories inside a parent nobody could see.
  /// Now the transactions either move somewhere or go to Recently deleted,
  /// and the subcategories move up to the top level.
  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    _Category category,
    int count,
    int children,
  ) async {
    final l10n = L10n.of(context);
    final notifier = ref.read(category_provider.categoryProvider.notifier);
    final note = children > 0 ? ' ${l10n.catDeleteChildrenNote}' : '';

    if (count == 0) {
      final confirmed = await showSunriseConfirm(
        context: context,
        title: l10n.catDeleteTitle(category.name),
        message: '${l10n.catDeleteEmptyBody}$note',
        confirmLabel: l10n.actionDelete,
        destructive: true,
        icon: Symbols.delete_rounded,
      );
      if (!confirmed || !context.mounted) return;
      await _run(context, () async {
        await notifier.deleteCategory(category.id);
        return l10n.catDeleted(category.name);
      }, ref: ref);
      return;
    }

    final all = ref.read(category_provider.categoryProvider).categories;
    // A merge carries subcategories along, and they cannot go inside one.
    final destinations = _destinations(
      all,
      category,
      topLevelOnly: children > 0,
    );
    final choice = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.catDeleteTitle(category.name),
        subtitle: '${l10n.catDeleteWithTransactions(count)}$note',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (destinations.isNotEmpty)
              SheetAction(
                key: const Key('delete_move_them'),
                icon: Symbols.move_down_rounded,
                label: l10n.catDeleteMoveThem,
                subtitle: l10n.catDeleteMoveThemHint(category.name),
                onTap: () => Navigator.pop(sheet, 'move'),
              ),
            SheetAction(
              key: const Key('delete_them_too'),
              icon: Symbols.delete_rounded,
              label: l10n.catDeleteThemToo,
              subtitle: l10n.catDeleteThemTooHint,
              destructive: true,
              onTap: () => Navigator.pop(sheet, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;

    if (choice == 'move') {
      final target = await _pickCategory(
        context,
        title: l10n.catMoveTransactionsTitle(category.name),
        options: destinations,
        all: all,
      );
      if (target == null || !context.mounted) return;
      await _run(context, () async {
        // A merge is exactly "move all of it there, then delete this one",
        // budgets included.
        await notifier.mergeInto(sourceId: category.id, targetId: target.id);
        return l10n.catMovedTransactions(count, target.name);
      }, ref: ref);
      return;
    }

    await _run(context, () async {
      final ids = ref
          .read(transactionProvider)
          .transactions
          .where((t) => t.categoryId == category.id)
          .map((t) => t.id)
          .toList();
      await ref.read(transactionProvider.notifier).deleteMany(ids);
      await notifier.deleteCategory(category.id);
      return l10n.catDeleted(category.name);
    }, ref: ref);
  }

  /// Do [action], then report what it says happened, or that it failed.
  ///
  /// The database refuses moves that would break the tree or change what a
  /// transaction means; its reason is shown as it is.
  Future<void> _run(
    BuildContext context,
    Future<String> Function() action, {
    WidgetRef? ref,
    bool reloadEverything = true,
  }) async {
    final l10n = L10n.of(context);
    try {
      final message = await action();
      // Transactions, budgets and reports moved underneath their screens.
      if (reloadEverything && ref != null) reloadAllData(ref);
      if (context.mounted) {
        showSunriseSnack(context, message, tone: SnackTone.success);
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(
          context,
          e.message?.toString() ?? l10n.catActionFailed,
          tone: SnackTone.error,
        );
      }
    } catch (_) {
      if (context.mounted) {
        showSunriseSnack(context, l10n.catActionFailed, tone: SnackTone.error);
      }
    }
  }

  void _openForm(
    BuildContext context, {
    _Category? category,
    String? parentId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => add_category_form.AddCategoryForm(
        category: category,
        initialParentId: parentId,
      ),
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
