import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/core/services/currency_service.dart';

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
  final CurrencyService? _currencyService;

  FinancialCalculationService(this._db, [this._currencyService]);

  /// Get wallet currency by ID (returns 'USD' if not found)
  Future<String> _getWalletCurrency(String? walletId) async {
    if (walletId == null) return 'USD';
    final wallet = await _db.findWalletById(walletId);
    return wallet?.currency ?? 'USD';
  }

  /// Convert amount from wallet currency to target currency
  Future<double> _convertAmount(
    double amount,
    String? walletId,
    String targetCurrency,
  ) async {
    if (_currencyService == null) return amount;

    final walletCurrency = await _getWalletCurrency(walletId);
    if (walletCurrency == targetCurrency) return amount;

    return await _currencyService.convert(
      amount,
      walletCurrency,
      targetCurrency,
    );
  }

  /// Calculate total balance across all wallets (no conversion)
  Future<double> getTotalBalance() async {
    try {
      final transactions = await _db.getAllTransactions();
      double totalBalance = 0.0;

      for (final transaction in transactions) {
        if (transaction.isIncome) {
          totalBalance += transaction.amount;
        } else {
          totalBalance -= transaction.amount;
        }
      }

      return totalBalance;
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total balance with currency conversion
  /// Converts all amounts to the target currency
  Future<double> getTotalBalanceConverted(String targetCurrency) async {
    try {
      final wallets = await _db.getAllWallets();
      double totalBalance = 0.0;

      for (final wallet in wallets) {
        // Get transactions for this wallet
        final transactions = await _db.getAllTransactions();
        final walletTransactions = transactions.where(
          (t) => t.walletId == wallet.id,
        );

        double walletBalance = 0.0;
        for (final transaction in walletTransactions) {
          if (transaction.isIncome) {
            walletBalance += transaction.amount;
          } else {
            walletBalance -= transaction.amount;
          }
        }

        // Add initial balance from wallet
        walletBalance += wallet.balance;

        // Convert to target currency
        if (_currencyService != null && wallet.currency != targetCurrency) {
          walletBalance = await _currencyService.convert(
            walletBalance,
            wallet.currency,
            targetCurrency,
          );
        }

        totalBalance += walletBalance;
      }

      return totalBalance;
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total income for a specific period (no conversion)
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
          .where((t) => t.isIncome)
          .fold<double>(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total income with currency conversion
  Future<double> getTotalIncomeConverted({
    DateTime? startDate,
    DateTime? endDate,
    required String targetCurrency,
  }) async {
    try {
      List<Transaction> transactions;

      if (startDate != null && endDate != null) {
        transactions = await _db.getTransactionsByDateRange(startDate, endDate);
      } else {
        transactions = await _db.getAllTransactions();
      }

      final incomeTransactions = transactions.where((t) => t.isIncome);
      double total = 0.0;

      for (final t in incomeTransactions) {
        final converted = await _convertAmount(
          t.amount,
          t.walletId,
          targetCurrency,
        );
        total += converted;
      }

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total expenses for a specific period (no conversion)
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
          .where((t) => !t.isIncome)
          .fold<double>(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate total expenses with currency conversion
  Future<double> getTotalExpensesConverted({
    DateTime? startDate,
    DateTime? endDate,
    required String targetCurrency,
  }) async {
    try {
      List<Transaction> transactions;

      if (startDate != null && endDate != null) {
        transactions = await _db.getTransactionsByDateRange(startDate, endDate);
      } else {
        transactions = await _db.getAllTransactions();
      }

      final expenseTransactions = transactions.where((t) => !t.isIncome);
      double total = 0.0;

      for (final t in expenseTransactions) {
        final converted = await _convertAmount(
          t.amount,
          t.walletId,
          targetCurrency,
        );
        total += converted;
      }

      return total;
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
        if (transaction.isIncome) {
          balance += transaction.amount;
        } else {
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
      final expenses = transactions.where((t) => !t.isIncome);

      final Map<String, double> categorySpending = {};

      for (final transaction in expenses) {
        final categoryId = transaction.categoryId;
        if (categoryId != null) {
          categorySpending[categoryId] =
              (categorySpending[categoryId] ?? 0.0) + transaction.amount;
        }
      }

      return categorySpending;
    } catch (e) {
      return {};
    }
  }

  /// Calculate spending by category with currency conversion
  Future<Map<String, double>> getSpendingByCategoryConverted(
    String targetCurrency,
  ) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final transactions = await _db.getTransactionsByDateRange(
        startOfMonth,
        endOfMonth,
      );
      final expenses = transactions.where((t) => !t.isIncome);

      final Map<String, double> categorySpending = {};

      for (final transaction in expenses) {
        final categoryId = transaction.categoryId;
        if (categoryId != null) {
          final converted = await _convertAmount(
            transaction.amount,
            transaction.walletId,
            targetCurrency,
          );
          categorySpending[categoryId] =
              (categorySpending[categoryId] ?? 0.0) + converted;
        }
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
        // Use amount field instead of limit (limit is legacy and nullable)
        final budgetAmount = budget.amount;
        if (budgetAmount <= 0) continue;

        // Skip if no date range
        final endDate = budget.endDate ?? DateTime.now();
        final transactions = await _db.getTransactionsByDateRange(
          budget.startDate,
          endDate,
        );

        final categoryId = budget.categoryId;
        final categoryExpenses = transactions
            .where(
              (t) =>
                  !t.isIncome &&
                  (categoryId == null || t.categoryId == categoryId),
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        final progressPercentage = (categoryExpenses / budgetAmount) * 100;
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
        // Use amount field instead of limit (limit is legacy and nullable)
        final budgetAmount = budget.amount;

        // Skip if no date range
        final endDate = budget.endDate ?? DateTime.now();
        final transactions = await _db.getTransactionsByDateRange(
          budget.startDate,
          endDate,
        );

        final categoryId = budget.categoryId;
        final spent = transactions
            .where(
              (t) =>
                  !t.isIncome &&
                  (categoryId == null || t.categoryId == categoryId),
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        Category? category;
        if (categoryId != null) {
          category = await _db.findCategoryById(categoryId);
        }

        items.add(
          BudgetProgressItem(
            budgetId: budget.id,
            budgetName: budget.name,
            categoryId: categoryId ?? '',
            categoryName: category?.name ?? 'All Categories',
            colorCode: category?.color ?? '#999999',
            spent: spent,
            limit: budgetAmount,
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
