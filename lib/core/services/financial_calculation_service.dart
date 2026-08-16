import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/core/services/currency_service.dart';

class BudgetProgressItem {
  final String budgetId;
  final String budgetName;
  final String categoryId;
  final String categoryName;
  final String colorCode; // e.g. #RRGGBB
  final int spent; // integer minor units / cents
  final int limit; // integer minor units / cents

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

  // Eligibility is delegated entirely to TransactionPolicy so these figures,
  // the stored wallet balances, the reports tab, and budget progress can never
  // drift apart. In particular transfers are excluded here: an internal
  // wallet-to-wallet movement used to be counted once as income AND once as
  // expense, inflating both gross totals and every category/budget figure.

  /// Get wallet currency by ID (returns 'USD' if not found)
  Future<String> _getWalletCurrency(String? walletId) async {
    if (walletId == null) return 'USD';
    final wallet = await _db.findWalletById(walletId);
    return wallet?.currency ?? 'USD';
  }

  /// Convert amount (integer minor units / cents) from wallet currency to target currency.
  /// CurrencyService works in double dollars, so we convert cents→dollars for the rate math
  /// then round back to int cents at the boundary.
  Future<int> _convertAmount(
    int amountCents,
    String? walletId,
    String targetCurrency,
  ) async {
    if (_currencyService == null) return amountCents;

    final walletCurrency = await _getWalletCurrency(walletId);
    if (walletCurrency == targetCurrency) return amountCents;

    final converted = await _currencyService.convert(
      amountCents / 100.0,
      walletCurrency,
      targetCurrency,
    );
    return (converted * 100).round();
  }

  /// Calculate total balance across all wallets (no conversion).
  /// Uses the authoritative stored wallet balances (which already reflect opening balance +
  /// realized transaction effects) rather than re-summing transactions with a different
  /// filter — the two used to diverge whenever unpaid "upcoming" items existed.
  Future<int> getTotalBalance() async {
    try {
      final wallets = await _db.getAllWallets();
      return wallets.fold<int>(0, (sum, w) => sum + w.balance);
    } catch (e) {
      return 0;
    }
  }

  /// Calculate total balance with currency conversion
  /// Converts all amounts to the target currency
  Future<int> getTotalBalanceConverted(String targetCurrency) async {
    try {
      final wallets = await _db.getAllWallets();
      int totalBalance = 0;

      for (final wallet in wallets) {
        // wallet.balance is the authoritative running balance (opening balance + realized
        // transaction effects). Do NOT also sum transactions here — that double-counted every
        // transaction (balance ≈ opening + 2×Σtxns).
        int walletBalance = wallet.balance;

        // Convert to target currency (rate math in double dollars, back to int cents)
        if (_currencyService != null && wallet.currency != targetCurrency) {
          final converted = await _currencyService.convert(
            walletBalance / 100.0,
            wallet.currency,
            targetCurrency,
          );
          walletBalance = (converted * 100).round();
        }

        totalBalance += walletBalance;
      }

      return totalBalance;
    } catch (e) {
      return 0;
    }
  }

  /// Calculate total income for a specific period (no conversion)
  Future<int> getTotalIncome({DateTime? startDate, DateTime? endDate}) async {
    try {
      List<Transaction> transactions;

      if (startDate != null && endDate != null) {
        transactions = await _db.getTransactionsByDateRange(startDate, endDate);
      } else {
        transactions = await _db.getAllTransactions();
      }

      return transactions
          .where(TransactionPolicy.countsAsIncome)
          .fold<int>(0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0;
    }
  }

  /// Calculate total income with currency conversion
  Future<int> getTotalIncomeConverted({
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

      final incomeTransactions = transactions.where(
        TransactionPolicy.countsAsIncome,
      );
      int total = 0;

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
      return 0;
    }
  }

  /// Calculate total expenses for a specific period (no conversion)
  Future<int> getTotalExpenses({DateTime? startDate, DateTime? endDate}) async {
    try {
      List<Transaction> transactions;

      if (startDate != null && endDate != null) {
        transactions = await _db.getTransactionsByDateRange(startDate, endDate);
      } else {
        transactions = await _db.getAllTransactions();
      }

      return transactions
          .where(TransactionPolicy.countsAsExpense)
          .fold<int>(0, (sum, t) => sum + t.amount);
    } catch (e) {
      return 0;
    }
  }

  /// Calculate total expenses with currency conversion
  Future<int> getTotalExpensesConverted({
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

      final expenseTransactions = transactions.where(
        TransactionPolicy.countsAsExpense,
      );
      int total = 0;

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
      return 0;
    }
  }

  /// Calculate balance for a specific wallet.
  /// Returns the authoritative stored balance so it agrees with the total-balance figures
  /// (both exclude unpaid "upcoming" transactions).
  Future<int> getWalletBalance(String walletId) async {
    try {
      final wallet = await _db.findWalletById(walletId);
      return wallet?.balance ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Calculate spending by category for the current month
  Future<Map<String, int>> getSpendingByCategory() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final transactions = await _db.getTransactionsByDateRange(
        startOfMonth,
        endOfMonth,
      );
      final expenses = transactions.where(TransactionPolicy.countsAsExpense);

      final Map<String, int> categorySpending = {};

      for (final transaction in expenses) {
        final categoryId = transaction.categoryId;
        if (categoryId != null) {
          categorySpending[categoryId] =
              (categorySpending[categoryId] ?? 0) + transaction.amount;
        }
      }

      return categorySpending;
    } catch (e) {
      return {};
    }
  }

  /// Calculate spending by category with currency conversion
  Future<Map<String, int>> getSpendingByCategoryConverted(
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
      final expenses = transactions.where(TransactionPolicy.countsAsExpense);

      final Map<String, int> categorySpending = {};

      for (final transaction in expenses) {
        final categoryId = transaction.categoryId;
        if (categoryId != null) {
          final converted = await _convertAmount(
            transaction.amount,
            transaction.walletId,
            targetCurrency,
          );
          categorySpending[categoryId] =
              (categorySpending[categoryId] ?? 0) + converted;
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
              (t) => TransactionPolicy.countsTowardBudget(
                t,
                budgetIsIncome: budget.isIncome,
                budgetCategoryId: categoryId,
              ),
            )
            .fold<int>(0, (sum, t) => sum + t.amount);

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
              (t) => TransactionPolicy.countsTowardBudget(
                t,
                budgetIsIncome: budget.isIncome,
                budgetCategoryId: categoryId,
              ),
            )
            .fold<int>(0, (sum, t) => sum + t.amount);

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
