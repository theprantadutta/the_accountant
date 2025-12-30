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
        // Using isIncome boolean instead of deprecated type string
        final defaultCategories = [
          // Expense Categories (isIncome: false)
          {
            'name': 'Food & Dining',
            'colorCode': '#FF6B6B',
            'iconName': 'restaurant',
            'isIncome': false,
            'orderIndex': 0,
          },
          {
            'name': 'Transportation',
            'colorCode': '#4ECDC4',
            'iconName': 'directions_car',
            'isIncome': false,
            'orderIndex': 1,
          },
          {
            'name': 'Shopping',
            'colorCode': '#45B7D1',
            'iconName': 'shopping_bag',
            'isIncome': false,
            'orderIndex': 2,
          },
          {
            'name': 'Entertainment',
            'colorCode': '#96CEB4',
            'iconName': 'movie',
            'isIncome': false,
            'orderIndex': 3,
          },
          {
            'name': 'Bills & Utilities',
            'colorCode': '#FFA07A',
            'iconName': 'receipt',
            'isIncome': false,
            'orderIndex': 4,
          },
          {
            'name': 'Healthcare',
            'colorCode': '#F7DC6F',
            'iconName': 'local_hospital',
            'isIncome': false,
            'orderIndex': 5,
          },
          {
            'name': 'Education',
            'colorCode': '#58D68D',
            'iconName': 'school',
            'isIncome': false,
            'orderIndex': 6,
          },
          {
            'name': 'Travel',
            'colorCode': '#85C1E9',
            'iconName': 'flight',
            'isIncome': false,
            'orderIndex': 7,
          },
          {
            'name': 'Groceries',
            'colorCode': '#82E0AA',
            'iconName': 'local_grocery_store',
            'isIncome': false,
            'orderIndex': 8,
          },
          {
            'name': 'Rent',
            'colorCode': '#F8C471',
            'iconName': 'home',
            'isIncome': false,
            'orderIndex': 9,
          },
          {
            'name': 'Insurance',
            'colorCode': '#BB8FCE',
            'iconName': 'security',
            'isIncome': false,
            'orderIndex': 10,
          },
          {
            'name': 'Personal Care',
            'colorCode': '#F1948A',
            'iconName': 'spa',
            'isIncome': false,
            'orderIndex': 11,
          },
          {
            'name': 'Subscriptions',
            'colorCode': '#7FB3D3',
            'iconName': 'subscriptions',
            'isIncome': false,
            'orderIndex': 12,
          },
          {
            'name': 'Gifts & Donations',
            'colorCode': '#D7BDE2',
            'iconName': 'card_giftcard',
            'isIncome': false,
            'orderIndex': 13,
          },
          {
            'name': 'Other Expenses',
            'colorCode': '#AED6F1',
            'iconName': 'more_horiz',
            'isIncome': false,
            'orderIndex': 14,
          },
          // Income Categories (isIncome: true)
          {
            'name': 'Salary',
            'colorCode': '#FFEAA7',
            'iconName': 'work',
            'isIncome': true,
            'orderIndex': 0,
          },
          {
            'name': 'Freelance',
            'colorCode': '#DDA0DD',
            'iconName': 'laptop',
            'isIncome': true,
            'orderIndex': 1,
          },
          {
            'name': 'Business',
            'colorCode': '#98D8C8',
            'iconName': 'business',
            'isIncome': true,
            'orderIndex': 2,
          },
          {
            'name': 'Investment',
            'colorCode': '#A9DFBF',
            'iconName': 'trending_up',
            'isIncome': true,
            'orderIndex': 3,
          },
          {
            'name': 'Rental Income',
            'colorCode': '#F9E79F',
            'iconName': 'apartment',
            'isIncome': true,
            'orderIndex': 4,
          },
          {
            'name': 'Bonus',
            'colorCode': '#D5A6BD',
            'iconName': 'star',
            'isIncome': true,
            'orderIndex': 5,
          },
          {
            'name': 'Gift Received',
            'colorCode': '#AED6F1',
            'iconName': 'redeem',
            'isIncome': true,
            'orderIndex': 6,
          },
          {
            'name': 'Refund',
            'colorCode': '#A3E4D7',
            'iconName': 'replay',
            'isIncome': true,
            'orderIndex': 7,
          },
          {
            'name': 'Other Income',
            'colorCode': '#D2B4DE',
            'iconName': 'add_circle',
            'isIncome': true,
            'orderIndex': 8,
          },
        ];

        for (final categoryData in defaultCategories) {
          final category = CategoriesCompanion(
            id: Value(const Uuid().v4()),
            name: Value(categoryData['name'] as String),
            color: Value(categoryData['colorCode'] as String),
            iconName: Value(categoryData['iconName'] as String),
            isDefault: const Value(true),
            isIncome: Value(categoryData['isIncome'] as bool),
            orderIndex: Value(categoryData['orderIndex'] as int),
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
