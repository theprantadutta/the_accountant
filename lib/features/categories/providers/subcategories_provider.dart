import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Provider for main categories (top-level, no parent)
final mainCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getMainCategories();
});

/// Provider for subcategories of a main category
final subcategoriesProvider = FutureProvider.family<List<Category>, String>((
  ref,
  mainCategoryId,
) async {
  final database = ref.watch(databaseProvider);
  return await database.getSubcategories(mainCategoryId);
});

/// Provider for categories organized in hierarchy
final categoriesHierarchyProvider =
    FutureProvider<List<CategoryWithSubcategories>>((ref) async {
      final database = ref.watch(databaseProvider);
      final mainCategories = await database.getMainCategories();
      final result = <CategoryWithSubcategories>[];

      for (final main in mainCategories) {
        final subs = await database.getSubcategories(main.id);
        result.add(
          CategoryWithSubcategories(category: main, subcategories: subs),
        );
      }

      return result;
    });

/// Provider for expense categories with hierarchy
final expenseCategoriesHierarchyProvider =
    FutureProvider<List<CategoryWithSubcategories>>((ref) async {
      final hierarchy = await ref.watch(categoriesHierarchyProvider.future);
      return hierarchy.where((c) => !c.category.isIncome).toList();
    });

/// Provider for income categories with hierarchy
final incomeCategoriesHierarchyProvider =
    FutureProvider<List<CategoryWithSubcategories>>((ref) async {
      final hierarchy = await ref.watch(categoriesHierarchyProvider.future);
      return hierarchy.where((c) => c.category.isIncome).toList();
    });

/// Notifier for managing categories with subcategory support
class CategoriesNotifier
    extends StateNotifier<AsyncValue<List<CategoryWithSubcategories>>> {
  final Ref _ref;
  final _uuid = const Uuid();

  CategoriesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final database = _ref.read(databaseProvider);
      final mainCategories = await database.getMainCategories();
      final result = <CategoryWithSubcategories>[];

      for (final main in mainCategories) {
        final subs = await database.getSubcategories(main.id);
        result.add(
          CategoryWithSubcategories(category: main, subcategories: subs),
        );
      }

      state = AsyncValue.data(result);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  /// Create a new main category
  Future<String> createMainCategory({
    required String name,
    required bool isIncome,
    String iconName = 'category',
    String color = '#6366F1',
    int orderIndex = 0,
  }) async {
    final database = _ref.read(databaseProvider);
    final id = _uuid.v4();

    await database.addCategory(
      CategoriesCompanion(
        id: Value(id),
        name: Value(name),
        isIncome: Value(isIncome),
        iconName: Value(iconName),
        color: Value(color),
        orderIndex: Value(orderIndex),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _load();
    return id;
  }

  /// Create a new subcategory
  Future<String> createSubcategory({
    required String name,
    required String mainCategoryId,
    String iconName = 'category',
    String color = '#6366F1',
    int orderIndex = 0,
  }) async {
    final database = _ref.read(databaseProvider);
    final id = _uuid.v4();

    // Get parent to inherit isIncome
    final parent = await database.findCategoryById(mainCategoryId);
    final isIncome = parent?.isIncome ?? false;

    await database.addCategory(
      CategoriesCompanion(
        id: Value(id),
        name: Value(name),
        mainCategoryId: Value(mainCategoryId),
        isIncome: Value(isIncome),
        iconName: Value(iconName),
        color: Value(color),
        orderIndex: Value(orderIndex),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _load();
    return id;
  }

  /// Update a category
  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? iconName,
    String? color,
    int? orderIndex,
  }) async {
    final database = _ref.read(databaseProvider);

    await (database.update(
      database.categories,
    )..where((c) => c.id.equals(categoryId))).write(
      CategoriesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        iconName: iconName != null ? Value(iconName) : const Value.absent(),
        color: color != null ? Value(color) : const Value.absent(),
        orderIndex: orderIndex != null
            ? Value(orderIndex)
            : const Value.absent(),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _load();
  }

  /// Delete a category (soft delete)
  Future<void> deleteCategory(String categoryId) async {
    final database = _ref.read(databaseProvider);

    // First, unlink all subcategories (make them main categories)
    final subcategories = await database.getSubcategories(categoryId);
    for (final sub in subcategories) {
      await (database.update(
        database.categories,
      )..where((c) => c.id.equals(sub.id))).write(
        const CategoriesCompanion(
          mainCategoryId: Value(null),
          syncStatus: Value(SyncStatus.pendingUpdate),
        ),
      );
    }

    // Then delete the category
    await (database.update(
      database.categories,
    )..where((c) => c.id.equals(categoryId))).write(
      CategoriesCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _load();
  }

  /// Move a category to become a subcategory
  Future<void> moveToSubcategory(String categoryId, String? newParentId) async {
    final database = _ref.read(databaseProvider);

    await (database.update(
      database.categories,
    )..where((c) => c.id.equals(categoryId))).write(
      CategoriesCompanion(
        mainCategoryId: Value(newParentId),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _load();
  }

  /// Reorder categories
  Future<void> reorderCategories(List<String> categoryIds) async {
    final database = _ref.read(databaseProvider);

    for (var i = 0; i < categoryIds.length; i++) {
      await (database.update(
        database.categories,
      )..where((c) => c.id.equals(categoryIds[i]))).write(
        CategoriesCompanion(
          orderIndex: Value(i),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    await _load();
  }

  /// Refresh the data
  Future<void> refresh() => _load();
}

/// Provider for categories notifier
final categoriesNotifierProvider =
    StateNotifierProvider<
      CategoriesNotifier,
      AsyncValue<List<CategoryWithSubcategories>>
    >((ref) {
      return CategoriesNotifier(ref);
    });

/// Helper class for category with its subcategories
class CategoryWithSubcategories {
  final Category category;
  final List<Category> subcategories;

  CategoryWithSubcategories({
    required this.category,
    this.subcategories = const [],
  });

  bool get hasSubcategories => subcategories.isNotEmpty;
  int get subcategoryCount => subcategories.length;

  /// Get all categories (main + subs) as flat list
  List<Category> get allCategories => [category, ...subcategories];
}

/// Provider for flat list of all categories (for pickers)
final categoryPickerItemsProvider = FutureProvider<List<CategoryPickerItem>>((
  ref,
) async {
  final hierarchy = await ref.watch(categoriesHierarchyProvider.future);
  final items = <CategoryPickerItem>[];

  for (final main in hierarchy) {
    // Add main category
    items.add(
      CategoryPickerItem(
        category: main.category,
        isSubcategory: false,
        parentName: null,
      ),
    );

    // Add subcategories
    for (final sub in main.subcategories) {
      items.add(
        CategoryPickerItem(
          category: sub,
          isSubcategory: true,
          parentName: main.category.name,
        ),
      );
    }
  }

  return items;
});

/// Item for category picker
class CategoryPickerItem {
  final Category category;
  final bool isSubcategory;
  final String? parentName;

  CategoryPickerItem({
    required this.category,
    required this.isSubcategory,
    this.parentName,
  });

  String get displayName =>
      isSubcategory ? '  ${category.name}' : category.name;

  String get fullName =>
      isSubcategory ? '$parentName > ${category.name}' : category.name;
}
