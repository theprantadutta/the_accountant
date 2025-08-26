import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

class Category {
  final String id;
  final String name;
  final String colorCode;
  final String type; // 'expense' or 'income'
  final bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.type,
    required this.isDefault,
  });
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

  CategoryNotifier(this._db)
      : super(
          CategoryState(
            categories: [],
            isLoading: false,
          ),
        ) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    state = state.copyWith(isLoading: true);
    try {
      final dbCategories = await _db.getAllCategories();
      final categories = dbCategories.map((c) => Category(
        id: c.id,
        name: c.name,
        colorCode: c.colorCode,
        type: c.type,
        isDefault: c.isDefault,
      )).toList();

      state = state.copyWith(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load categories',
      );
    }
  }

  Future<void> addCategory({
    required String name,
    required String colorCode,
    required String type,
    bool isDefault = false,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final newCategory = CategoriesCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        colorCode: Value(colorCode),
        type: Value(type),
        isDefault: Value(isDefault),
      );

      await _db.addCategory(newCategory);

      // Reload categories to get the new one
      await _loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add category',
      );
    }
  }

  Future<void> updateCategory({
    required String id,
    String? name,
    String? colorCode,
    String? type,
    bool? isDefault,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findCategoryById(id);
      if (existing == null) {
        throw Exception('Category not found');
      }

      final updatedCategory = CategoriesCompanion(
        id: Value(id),
        name: Value(name ?? existing.name),
        colorCode: Value(colorCode ?? existing.colorCode),
        type: Value(type ?? existing.type),
        isDefault: Value(isDefault ?? existing.isDefault),
      );

      await _db.updateCategory(updatedCategory);

      // Reload categories to get the updated one
      await _loadCategories();
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
      await _loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('default') 
            ? e.toString() 
            : 'Failed to delete category',
      );
    }
  }

  List<Category> getCategoriesByType(String type) {
    return state.categories.where((c) => c.type == type).toList();
  }

  Category? getCategoryById(String id) {
    try {
      return state.categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoryNotifier(db);
});