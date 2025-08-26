import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

class CategoryInitializationService {
  final AppDatabase _db;

  CategoryInitializationService(this._db);

  Future<void> initializeDefaultCategories() async {
    try {
      // Check if categories already exist
      final existingCategories = await _db.getAllCategories();
      
      // If no categories exist, insert the default ones
      if (existingCategories.isEmpty) {
        // Using a local definition of default categories since we removed the import
        final defaultCategories = [
          {
            'name': 'Food & Dining',
            'colorCode': '#FF6B6B',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Transportation',
            'colorCode': '#4ECDC4',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Shopping',
            'colorCode': '#45B7D1',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Entertainment',
            'colorCode': '#96CEB4',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Salary',
            'colorCode': '#FFEAA7',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Freelance',
            'colorCode': '#DDA0DD',
            'type': 'income',
            'isDefault': true,
          },
        ];
        
        for (final categoryData in defaultCategories) {
          final category = CategoriesCompanion(
            id: Value(const Uuid().v4()),
            name: Value(categoryData['name'] as String),
            colorCode: Value(categoryData['colorCode'] as String),
            type: Value(categoryData['type'] as String),
            isDefault: Value(categoryData['isDefault'] as bool),
          );
          
          await _db.addCategory(category);
        }
      }
    } catch (e) {
      // Handle error silently or log it
      // Using a proper logger would be better in production
    }
  }
}