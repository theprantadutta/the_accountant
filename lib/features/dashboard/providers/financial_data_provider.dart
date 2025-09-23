import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat_provider;

class FinancialData {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlyGrowthPercentage;
  final Map<String, double> categorySpending;
  final Map<String, double> budgetProgress;
  final List<BudgetProgressItem> budgetProgressDetails;
  final List<Transaction> recentTransactions;
  final bool isLoading;
  final String? error;

  FinancialData({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlyGrowthPercentage,
    required this.categorySpending,
    required this.budgetProgress,
    required this.budgetProgressDetails,
    required this.recentTransactions,
    this.isLoading = false,
    this.error,
  });

  FinancialData copyWith({
    double? totalBalance,
    double? monthlyIncome,
    double? monthlyExpenses,
    double? monthlyGrowthPercentage,
    Map<String, double>? categorySpending,
    Map<String, double>? budgetProgress,
    List<BudgetProgressItem>? budgetProgressDetails,
    List<Transaction>? recentTransactions,
    bool? isLoading,
    String? error,
  }) {
    return FinancialData(
      totalBalance: totalBalance ?? this.totalBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      monthlyGrowthPercentage:
          monthlyGrowthPercentage ?? this.monthlyGrowthPercentage,
      categorySpending: categorySpending ?? this.categorySpending,
      budgetProgress: budgetProgress ?? this.budgetProgress,
      budgetProgressDetails:
          budgetProgressDetails ?? this.budgetProgressDetails,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FinancialDataNotifier extends Notifier<FinancialData> {
  late final FinancialCalculationService _calculationService;

  @override
  FinancialData build() {
    final db = ref.watch(databaseProvider);
    _calculationService = FinancialCalculationService(db);

    // Schedule data loading after the initial state is set to avoid
    // reading the state of an uninitialized provider during build.
    Future.microtask(loadFinancialData);

    return FinancialData(
      totalBalance: 0.0,
      monthlyIncome: 0.0,
      monthlyExpenses: 0.0,
      monthlyGrowthPercentage: 0.0,
      categorySpending: {},
      budgetProgress: {},
      budgetProgressDetails: const [],
      recentTransactions: [],
      isLoading: true,
    );
  }

  Future<void> loadFinancialData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Calculate current month date range
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      // Load all financial data in parallel
      final results = await Future.wait([
        _calculationService.getTotalBalance(),
        _calculationService.getTotalIncome(
          startDate: startOfMonth,
          endDate: endOfMonth,
        ),
        _calculationService.getTotalExpenses(
          startDate: startOfMonth,
          endDate: endOfMonth,
        ),
        _calculationService.getMonthlyGrowthPercentage(),
        _calculationService.getSpendingByCategory(),
        _calculationService.getBudgetProgress(),
        _calculationService.getBudgetProgressDetails(),
        _calculationService.getRecentTransactions(),
      ]);

      state = state.copyWith(
        totalBalance: results[0] as double,
        monthlyIncome: results[1] as double,
        monthlyExpenses: results[2] as double,
        monthlyGrowthPercentage: results[3] as double,
        categorySpending: results[4] as Map<String, double>,
        budgetProgress: results[5] as Map<String, double>,
        budgetProgressDetails: results[6] as List<BudgetProgressItem>,
        recentTransactions: results[7] as List<Transaction>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load financial data: ${e.toString()}',
      );
    }
  }

  Future<void> refreshData() async {
    await loadFinancialData();
  }

  // Get category spending with category names
  Map<String, double> getCategorySpendingWithNames() {
    final categories = ref.read(cat_provider.categoryProvider).categories;
    final Map<String, double> namedSpending = {};

    state.categorySpending.forEach((categoryId, amount) {
      final category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => cat_provider.Category(
          id: categoryId,
          name: 'Unknown',
          colorCode: '#999999',
          type: 'expense',
          isDefault: false,
        ),
      );
      namedSpending[category.name] = amount;
    });

    return namedSpending;
  }
}

final financialDataProvider =
    NotifierProvider<FinancialDataNotifier, FinancialData>(() {
      return FinancialDataNotifier();
    });

// Convenience providers for specific data
final totalBalanceProvider = Provider<double>((ref) {
  return ref.watch(financialDataProvider).totalBalance;
});

final monthlyIncomeProvider = Provider<double>((ref) {
  return ref.watch(financialDataProvider).monthlyIncome;
});

final monthlyExpensesProvider = Provider<double>((ref) {
  return ref.watch(financialDataProvider).monthlyExpenses;
});

final monthlyGrowthProvider = Provider<double>((ref) {
  return ref.watch(financialDataProvider).monthlyGrowthPercentage;
});

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(financialDataProvider).recentTransactions;
});

final categorySpendingProvider = Provider<Map<String, double>>((ref) {
  return ref
      .watch(financialDataProvider.notifier)
      .getCategorySpendingWithNames();
});

final budgetProgressDetailsProvider = Provider<List<BudgetProgressItem>>((ref) {
  return ref.watch(financialDataProvider).budgetProgressDetails;
});
