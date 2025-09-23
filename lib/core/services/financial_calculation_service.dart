import 'package:the_accountant/data/datasources/local/app_database.dart';

class BudgetProgressItem {
  final String budgetId;
  final String budgetName;
  final String categoryId;
  final String categoryName;
  final String colorCode; // e.g. #RRGGBB
  final double spent;
  final double limit;

  const BudgetProgressItem({
    required this.budgetId,
    required this.budgetName,
    required this.categoryId,
    required this.categoryName,
    required this.colorCode,
    required this.spent,
    required this.limit,
  });

  double get percentage =>
      limit <= 0 ? 0.0 : (spent / limit).clamp(0.0, double.infinity);
}

class FinancialCalculationService {
  final AppDatabase _db;

  FinancialCalculationService(this._db);

  /// Calculate total balance across all wallets
  Future<double> getTotalBalance() async {
    try {
      final transactions = await _db.getAllTransactions();
      double totalBalance = 0.0;

      for (final transaction in transactions) {
        if (transaction.type == 'income') {
          totalBalance += transaction.amount;
        } else if (transaction.type == 'expense') {
          totalBalance -= transaction.amount;
        }
      }

      return totalBalance;
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total income for a specific period
  Future<double> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      List<Transaction> transactions;

      if (startDate != null && endDate != null) {
        transactions = await _db.getTransactionsByDateRange(startDate, endDate);
      } else {
        transactions = await _db.getAllTransactions();
      }

      return transactions
          .where((t) => t.type == 'income')
          .fold<double>(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total expenses for a specific period
  Future<double> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      List<Transaction> transactions;

      if (startDate != null && endDate != null) {
        transactions = await _db.getTransactionsByDateRange(startDate, endDate);
      } else {
        transactions = await _db.getAllTransactions();
      }

      return transactions
          .where((t) => t.type == 'expense')
          .fold<double>(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate balance for a specific wallet
  Future<double> getWalletBalance(String walletId) async {
    try {
      final transactions = await _db.getAllTransactions();
      double balance = 0.0;

      for (final transaction in transactions.where(
        (t) => t.walletId == walletId,
      )) {
        if (transaction.type == 'income') {
          balance += transaction.amount;
        } else if (transaction.type == 'expense') {
          balance -= transaction.amount;
        }
      }

      return balance;
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate spending by category for the current month
  Future<Map<String, double>> getSpendingByCategory() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final transactions = await _db.getTransactionsByDateRange(
        startOfMonth,
        endOfMonth,
      );
      final expenses = transactions.where((t) => t.type == 'expense');

      final Map<String, double> categorySpending = {};

      for (final transaction in expenses) {
        final categoryId = transaction.categoryId;
        categorySpending[categoryId] =
            (categorySpending[categoryId] ?? 0.0) + transaction.amount;
      }

      return categorySpending;
    } catch (e) {
      return {};
    }
  }

  /// Calculate budget progress for active budgets
  Future<Map<String, double>> getBudgetProgress() async {
    try {
      final activeBudgets = await _db.getActiveBudgets();
      final Map<String, double> budgetProgress = {};

      for (final budget in activeBudgets) {
        final transactions = await _db.getTransactionsByDateRange(
          budget.startDate,
          budget.endDate,
        );

        final categoryExpenses = transactions
            .where(
              (t) => t.type == 'expense' && t.categoryId == budget.categoryId,
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        final progressPercentage = budget.limit > 0
            ? (categoryExpenses / budget.limit) * 100
            : 0.0;
        budgetProgress[budget.id] = progressPercentage.clamp(0.0, 100.0);
      }

      return budgetProgress;
    } catch (e) {
      return {};
    }
  }

  /// Detailed budget progress for active budgets with category and amounts
  Future<List<BudgetProgressItem>> getBudgetProgressDetails() async {
    try {
      final activeBudgets = await _db.getActiveBudgets();
      final List<BudgetProgressItem> items = [];

      for (final budget in activeBudgets) {
        final transactions = await _db.getTransactionsByDateRange(
          budget.startDate,
          budget.endDate,
        );

        final spent = transactions
            .where(
              (t) => t.type == 'expense' && t.categoryId == budget.categoryId,
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        final category = await _db.findCategoryById(budget.categoryId);

        items.add(
          BudgetProgressItem(
            budgetId: budget.id,
            budgetName: budget.name,
            categoryId: budget.categoryId,
            categoryName: category?.name ?? 'Unknown',
            colorCode: category?.colorCode ?? '#999999',
            spent: spent,
            limit: budget.limit,
          ),
        );
      }

      return items;
    } catch (e) {
      return [];
    }
  }

  /// Get recent transactions (last 10)
  Future<List<Transaction>> getRecentTransactions({int limit = 10}) async {
    try {
      final allTransactions = await _db.getAllTransactions();
      allTransactions.sort((a, b) => b.date.compareTo(a.date));
      return allTransactions.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Calculate monthly growth percentage
  Future<double> getMonthlyGrowthPercentage() async {
    try {
      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month, 1);
      final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
      final lastMonthStart = DateTime(now.year, now.month - 1, 1);
      final lastMonthEnd = DateTime(now.year, now.month, 0);

      final currentMonthIncome = await getTotalIncome(
        startDate: currentMonthStart,
        endDate: currentMonthEnd,
      );
      final currentMonthExpenses = await getTotalExpenses(
        startDate: currentMonthStart,
        endDate: currentMonthEnd,
      );
      final currentMonthNet = currentMonthIncome - currentMonthExpenses;

      final lastMonthIncome = await getTotalIncome(
        startDate: lastMonthStart,
        endDate: lastMonthEnd,
      );
      final lastMonthExpenses = await getTotalExpenses(
        startDate: lastMonthStart,
        endDate: lastMonthEnd,
      );
      final lastMonthNet = lastMonthIncome - lastMonthExpenses;

      if (lastMonthNet == 0) return 0.0;

      return ((currentMonthNet - lastMonthNet) / lastMonthNet.abs()) * 100;
    } catch (e) {
      return 0.0;
    }
  }
}
