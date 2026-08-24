import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
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

  /// The built-in slug this category was seeded from, or null if the user made
  /// it themselves.
  ///
  /// Categories are seeded per install with random ids, so the slug is the only
  /// stable way to recognise a particular built-in — including the two the app
  /// keeps for its own bookkeeping.
  final String? defaultKey;

  Category({
    required this.id,
    required this.name,
    required this.colorCode,
    this.iconName,
    required this.type,
    required this.isDefault,
    this.defaultKey,
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
  final Ref _ref;

  CategoryNotifier(this._db, this._ref)
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
      // Check premium limit for custom categories (not default ones)
      if (!isDefault) {
        final premiumState = _ref.read(premiumProvider);
        if (!premiumState.isPremium) {
          final customCount = state.categories
              .where((c) => !c.isDefault)
              .length;
          if (customCount >= FreeTierLimits.maxCustomCategories) {
            throw PremiumLimitException(
              entityType: 'category',
              currentCount: customCount,
              limit: FreeTierLimits.maxCustomCategories,
            );
          }
        }
      }

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
    String? mainCategoryId,
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
        mainCategoryId: Value(mainCategoryId ?? existing.mainCategoryId),
        isDefault: Value(isDefault ?? existing.isDefault),
        isIncome: Value(categoryIsIncome ?? existing.isIncome),
        syncStatus: const Value(SyncStatus.pendingUpdate),
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

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      // Check if this is a default category
      final category = state.categories.firstWhere((c) => c.id == id);
      if (category.isDefault) {
        throw Exception('Cannot delete default categories');
      }

      await _db.softDeleteCategory(id);

      // Reload categories to reflect the deletion
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('default')
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

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) {
    final db = ref.watch(databaseProvider);
    return CategoryNotifier(db, ref);
  },
);
