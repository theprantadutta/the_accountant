import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

  Category({
    required this.id,
    required this.name,
    required this.colorCode,
    this.iconName,
    required this.type,
    required this.isDefault,
  });

  /// Helper to check if this is an income category
  bool get isIncome => type == 'income';
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
            ),
          )
          .toList();

      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      if (!silent) state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load categories',
      );
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

      await _db.deleteCategory(id);

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

  /// @deprecated - Use getIncomeCategories or getExpenseCategories instead
  List<Category> getCategoriesByType(String type) {
    return state.categories.where((c) => c.type == type).toList();
  }

  /// Get all income categories
  List<Category> getIncomeCategories() {
    return state.categories.where((c) => c.isIncome).toList();
  }

  /// Get all expense categories
  List<Category> getExpenseCategories() {
    return state.categories.where((c) => !c.isIncome).toList();
  }

  /// Get categories filtered by isIncome flag
  List<Category> getCategoriesByIsIncome(bool isIncome) {
    return state.categories.where((c) => c.isIncome == isIncome).toList();
  }

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
