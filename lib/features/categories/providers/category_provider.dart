import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

/// ViewModel class for displaying categories in UI
/// Uses isIncome boolean instead of deprecated type string
class CategoryViewModel {
  final String id;
  final String name;
  final String colorCode;
  final String iconName;
  final bool isIncome;
  final bool isDefault;
  final String? mainCategoryId;

  CategoryViewModel({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.iconName,
    required this.isIncome,
    required this.isDefault,
    this.mainCategoryId,
  });

  /// Helper to get display type string for backward compatibility
  String get type => isIncome ? 'income' : 'expense';
}

/// @deprecated - Use CategoryViewModel instead
/// Kept for backward compatibility with existing code
class Category {
  final String id;
  final String name;
  final String colorCode;
  final String? iconName;
  final String type; // 'expense' or 'income'
  final bool isDefault;

  /// The category this one sits under, or null when it stands on its own.
  ///
  /// One level only, by design: a category that is part of another cannot
  /// itself be a parent.
  final String? mainCategoryId;

  /// The built-in slug this category was seeded from, or null if the user made
  /// it themselves.
  ///
  /// Categories are seeded per install with random ids, so the slug is the only
  /// stable way to recognise a particular built-in — including the two the app
  /// keeps for its own bookkeeping.
  final String? defaultKey;

  /// Put away by the user; see [CategoryState.selectable].
  final bool isArchived;

  Category({
    required this.id,
    required this.name,
    required this.colorCode,
    this.iconName,
    required this.type,
    required this.isDefault,
    this.defaultKey,
    this.mainCategoryId,
    this.isArchived = false,
  });

  /// Helper to check if this is an income category
  bool get isIncome => type == 'income';

  /// Whether the app keeps this category for its own bookkeeping rather than
  /// for the user to file things under.
  ///
  /// Transfer and Balance Correction are written by the app when it moves money
  /// between wallets or reconciles a balance. They are ordinary rows in the
  /// database and sync like any other category, but nothing should be filed
  /// under them by hand.
  bool get isSystem =>
      defaultKey != null && SystemCategoryKeys.all.contains(defaultKey);
}

class CategoryState {
  final List<Category> categories;
  final bool isLoading;
  final String? errorMessage;

  CategoryState({
    required this.categories,
    required this.isLoading,
    this.errorMessage,
  });

  /// The categories a transaction can be filed under now: not archived, and
  /// not inside an archived parent.
  ///
  /// Pickers read this. Anything that shows history — reports, a transaction
  /// already filed under an archived category, filters over past rows — reads
  /// [categories], so putting a category away never hides what it holds.
  List<Category> get selectable {
    final archived = {
      for (final c in categories)
        if (c.isArchived) c.id,
    };
    return [
      for (final c in categories)
        if (!c.isArchived && !archived.contains(c.mainCategoryId)) c,
    ];
  }

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CategoryNotifier extends StateNotifier<CategoryState> {
  final AppDatabase _db;

  CategoryNotifier(this._db)
    : super(CategoryState(categories: [], isLoading: false)) {
    loadCategories();
  }

  Future<void> loadCategories({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);
    try {
      final dbCategories = await _db.getAllCategories();
      final categories = dbCategories
          .map(
            (c) => Category(
              id: c.id,
              name: c.name,
              colorCode: c.color,
              iconName: c.iconName,
              // Use isIncome to determine type (new approach)
              type: c.isIncome ? 'income' : 'expense',
              isDefault: c.isDefault,
              defaultKey: c.defaultKey,
              mainCategoryId: c.mainCategoryId,
              isArchived: c.isArchived,
            ),
          )
          .toList();

      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      if (!silent) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load categories',
        );
      }
    }
  }

  /// Add a new category
  /// [isIncome] - true for income category, false for expense
  /// [type] - @deprecated, use isIncome instead. Kept for backward compatibility.
  Future<void> addCategory({
    required String name,
    required String colorCode,
    String? type, // @deprecated - use isIncome instead
    bool? isIncome, // New: use this instead of type
    String iconName = 'category',
    String? mainCategoryId,
    bool isDefault = false,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Determine isIncome: prefer explicit isIncome, fallback to type parsing
      final bool categoryIsIncome = isIncome ?? (type == 'income');

      final newCategory = CategoriesCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        color: Value(colorCode),
        iconName: Value(iconName),
        mainCategoryId: Value(mainCategoryId),
        isDefault: Value(isDefault),
        isIncome: Value(categoryIsIncome), // Use isIncome field
        syncStatus: const Value(SyncStatus.pendingCreate),
      );

      await _db.addCategory(newCategory);

      // Reload categories to get the new one
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is PremiumLimitException
            ? e.message
            : 'Failed to add category',
      );
      rethrow; // Rethrow to let UI handle PremiumLimitException
    }
  }

  /// Update an existing category
  /// [isIncome] - true for income category, false for expense
  /// [type] - @deprecated, use isIncome instead. Kept for backward compatibility.
  Future<void> updateCategory({
    required String id,
    String? name,
    String? colorCode,
    String? type, // @deprecated - use isIncome instead
    bool? isIncome, // New: use this instead of type
    String? iconName,
    Object? mainCategoryId = _keepParent,
    bool? isDefault,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findCategoryById(id);
      if (existing == null) {
        throw Exception('Category not found');
      }

      // Determine isIncome: prefer explicit isIncome, then type, then existing
      bool? categoryIsIncome;
      if (isIncome != null) {
        categoryIsIncome = isIncome;
      } else if (type != null) {
        categoryIsIncome = type == 'income';
      }

      final updatedCategory = CategoriesCompanion(
        id: Value(id),
        name: Value(name ?? existing.name),
        color: Value(colorCode ?? existing.color),
        iconName: Value(iconName ?? existing.iconName),
        // Null is a real answer here, "at the top level"; it used to be read
        // as "unchanged", so a subcategory could never be taken out again.
        mainCategoryId: Value(
          identical(mainCategoryId, _keepParent)
              ? existing.mainCategoryId
              : mainCategoryId as String?,
        ),
        isDefault: Value(isDefault ?? existing.isDefault),
        isIncome: Value(categoryIsIncome ?? existing.isIncome),
        // A category the server has not seen yet is still a create.
        syncStatus: Value(
          existing.syncStatus == SyncStatus.pendingCreate
              ? SyncStatus.pendingCreate
              : SyncStatus.pendingUpdate,
        ),
      );

      await _db.updateCategory(updatedCategory);

      // Reload categories to get the updated one
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update category',
      );
    }
  }

  /// Archive or bring back a category.
  Future<void> setArchived(String id, bool archived) async {
    await _db.setCategoryArchived(id, archived);
    await loadCategories(silent: true);
  }

  /// Fold [sourceId] into [targetId]; see [AppDatabase.mergeCategory].
  Future<void> mergeInto({
    required String sourceId,
    required String targetId,
  }) async {
    await _db.mergeCategory(sourceId: sourceId, targetId: targetId);
    await loadCategories(silent: true);
  }

  /// Refile [sourceId]'s transactions under [targetId], keeping both; see
  /// [AppDatabase.moveCategoryTransactions]. Returns how many moved.
  Future<int> moveTransactions({
    required String sourceId,
    required String targetId,
  }) => _db.moveCategoryTransactions(sourceId: sourceId, targetId: targetId);

  /// Put [id] inside [parentId], or at the top level when it is null; see
  /// [AppDatabase.setCategoryParent].
  Future<void> setParent(String id, String? parentId) async {
    await _db.setCategoryParent(id, parentId);
    await loadCategories(silent: true);
  }

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      // The app's own are never deleted, and nothing that still holds
      // transactions is: they would be left pointing at a category that is
      // gone. They are moved, or deleted, first; the screen offers both.
      final category = state.categories.firstWhere((c) => c.id == id);
      if (category.isSystem) {
        throw Exception('Cannot delete the app\'s own categories');
      }
      final held = (await _db.liveTransactionCountsByCategory())[id] ?? 0;
      if (held > 0) {
        throw Exception(
          'Cannot delete a category with transactions; move or delete them '
          'first',
        );
      }

      await _db.softDeleteCategory(id);

      // Reload categories to reflect the deletion
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('Cannot delete')
            ? e.toString()
            : 'Failed to delete category',
      );
    }
  }

  // The four helpers that used to live here all sliced categories by
  // direction: getCategoriesByType, getIncomeCategories,
  // getExpenseCategories, getCategoriesByIsIncome. Nothing called any of them
  // even before categories were merged into one list, and slicing by direction
  // is exactly what no longer means anything.

  Category? getCategoryById(String id) {
    try {
      return state.categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Marks "leave the parent as it is" in [CategoryNotifier.updateCategory],
/// where null means "no parent".
const Object _keepParent = Object();

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) {
    final db = ref.watch(databaseProvider);
    return CategoryNotifier(db);
  },
);
