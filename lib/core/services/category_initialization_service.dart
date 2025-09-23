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
        // Comprehensive default categories for better user experience
        final defaultCategories = [
          // Expense Categories
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
            'name': 'Bills & Utilities',
            'colorCode': '#FFA07A',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Healthcare',
            'colorCode': '#F7DC6F',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Education',
            'colorCode': '#58D68D',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Travel',
            'colorCode': '#85C1E9',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Groceries',
            'colorCode': '#82E0AA',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Rent',
            'colorCode': '#F8C471',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Insurance',
            'colorCode': '#BB8FCE',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Personal Care',
            'colorCode': '#F1948A',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Subscriptions',
            'colorCode': '#7FB3D3',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Gifts & Donations',
            'colorCode': '#D7BDE2',
            'type': 'expense',
            'isDefault': true,
          },
          {
            'name': 'Other Expenses',
            'colorCode': '#AED6F1',
            'type': 'expense',
            'isDefault': true,
          },
          // Income Categories
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
          {
            'name': 'Business',
            'colorCode': '#98D8C8',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Investment',
            'colorCode': '#A9DFBF',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Rental Income',
            'colorCode': '#F9E79F',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Bonus',
            'colorCode': '#D5A6BD',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Gift Received',
            'colorCode': '#AED6F1',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Refund',
            'colorCode': '#A3E4D7',
            'type': 'income',
            'isDefault': true,
          },
          {
            'name': 'Other Income',
            'colorCode': '#D2B4DE',
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
