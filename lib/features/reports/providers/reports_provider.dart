import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat_provider;

/// Data model for category spending in pie chart
class CategorySpendingData {
  final String categoryId;
  final String categoryName;
  final Color color;
  final double amount;
  final double percentage;

  const CategorySpendingData({
    required this.categoryId,
    required this.categoryName,
    required this.color,
    required this.amount,
    required this.percentage,
  });
}

/// Data model for daily spending in line chart
class DailySpendingData {
  final DateTime date;
  final double amount;
  final String dayLabel;

  const DailySpendingData({
    required this.date,
    required this.amount,
    required this.dayLabel,
  });
}

/// Data model for budget comparison
class BudgetComparisonData {
  final String budgetId;
  final String budgetName;
  final double budgetLimit;
  final double spent;
  final Color color;
  final double percentage;
  final bool isOverBudget;

  const BudgetComparisonData({
    required this.budgetId,
    required this.budgetName,
    required this.budgetLimit,
    required this.spent,
    required this.color,
    required this.percentage,
    required this.isOverBudget,
  });
}

/// State for reports data
class ReportsState {
  final List<CategorySpendingData> categorySpending;
  final List<DailySpendingData> dailySpending;
  final List<BudgetComparisonData> budgetComparison;
  final double totalSpending;
  final double totalIncome;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.categorySpending = const [],
    this.dailySpending = const [],
    this.budgetComparison = const [],
    this.totalSpending = 0,
    this.totalIncome = 0,
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<CategorySpendingData>? categorySpending,
    List<DailySpendingData>? dailySpending,
    List<BudgetComparisonData>? budgetComparison,
    double? totalSpending,
    double? totalIncome,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      categorySpending: categorySpending ?? this.categorySpending,
      dailySpending: dailySpending ?? this.dailySpending,
      budgetComparison: budgetComparison ?? this.budgetComparison,
      totalSpending: totalSpending ?? this.totalSpending,
      totalIncome: totalIncome ?? this.totalIncome,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Convert category spending to pie chart sections
  List<PieChartSectionData> toPieChartSections() {
    if (categorySpending.isEmpty) return [];

    return categorySpending.map((data) {
      return PieChartSectionData(
        color: data.color,
        value: data.percentage,
        title: '${data.categoryName}\n${data.percentage.toStringAsFixed(0)}%',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _getContrastColor(data.color),
        ),
      );
    }).toList();
  }

  /// Convert daily spending to line chart spots
  List<FlSpot> toLineChartSpots() {
    if (dailySpending.isEmpty) return [];

    return dailySpending.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();
  }

  /// Get max Y value for line chart
  double getMaxY() {
    if (dailySpending.isEmpty) return 1000;
    final maxSpending = dailySpending
        .map((d) => d.amount)
        .reduce((a, b) => a > b ? a : b);
    // Round up to nearest 500 or 1000 for nice axis
    if (maxSpending <= 0) return 100;
    if (maxSpending <= 100) return 100;
    if (maxSpending <= 500) return 500;
    if (maxSpending <= 1000) return 1000;
    return ((maxSpending / 1000).ceil() * 1000).toDouble();
  }

  /// Get day labels for line chart
  List<String> getDayLabels() {
    return dailySpending.map((d) => d.dayLabel).toList();
  }

  static Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  final AppDatabase _db;
  final Ref _ref;

  ReportsNotifier(this._db, this._ref) : super(const ReportsState()) {
    loadReportsData();
  }

  /// Load all reports data based on timeframe
  /// timeframe: 0 = Week, 1 = Month, 2 = Year
  Future<void> loadReportsData({int timeframe = 0}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate = now;

      // Calculate date range based on timeframe
      switch (timeframe) {
        case 0: // Week
          startDate = now.subtract(const Duration(days: 6));
          break;
        case 1: // Month
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 2: // Year
          startDate = DateTime(now.year, 1, 1);
          break;
        default:
          startDate = now.subtract(const Duration(days: 6));
      }

      // Load transactions for the period
      final transactions = await _db.getTransactionsByDateRange(startDate, endDate);

      // Calculate totals
      double totalSpending = 0;
      double totalIncome = 0;
      for (final t in transactions) {
        if (!t.isIncome) {
          totalSpending += t.amount;
        } else if (t.isIncome) {
          totalIncome += t.amount;
        }
      }

      // Calculate category spending
      final categorySpending = await _calculateCategorySpending(
        transactions,
        totalSpending,
      );

      // Calculate daily spending
      final dailySpending = _calculateDailySpending(
        transactions,
        startDate,
        endDate,
        timeframe,
      );

      // Calculate budget comparison
      final budgetComparison = await _calculateBudgetComparison();

      state = state.copyWith(
        categorySpending: categorySpending,
        dailySpending: dailySpending,
        budgetComparison: budgetComparison,
        totalSpending: totalSpending,
        totalIncome: totalIncome,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load reports: ${e.toString()}',
      );
    }
  }

  Future<List<CategorySpendingData>> _calculateCategorySpending(
    List<Transaction> transactions,
    double totalSpending,
  ) async {
    final expenses = transactions.where((t) => !t.isIncome);
    final Map<String, double> categoryTotals = {};

    // Sum by category
    for (final t in expenses) {
      final categoryId = t.categoryId ?? 'uncategorized';
      categoryTotals[categoryId] = (categoryTotals[categoryId] ?? 0) + t.amount;
    }

    // Get category details and convert to CategorySpendingData
    final categories = _ref.read(cat_provider.categoryProvider).categories;
    final List<CategorySpendingData> result = [];

    for (final entry in categoryTotals.entries) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => cat_provider.Category(
          id: entry.key,
          name: entry.key == 'uncategorized' ? 'Uncategorized' : 'Unknown',
          colorCode: '#999999',
          type: 'expense',
          isDefault: false,
        ),
      );

      final percentage = totalSpending > 0
          ? (entry.value / totalSpending * 100)
          : 0.0;

      result.add(CategorySpendingData(
        categoryId: entry.key,
        categoryName: category.name,
        color: _parseColor(category.colorCode),
        amount: entry.value,
        percentage: percentage,
      ));
    }

    // Sort by amount descending
    result.sort((a, b) => b.amount.compareTo(a.amount));

    // Limit to top 5 categories, group rest as "Other"
    if (result.length > 5) {
      final top5 = result.take(5).toList();
      final others = result.skip(5);
      final otherTotal = others.fold(0.0, (sum, d) => sum + d.amount);
      final otherPercentage = totalSpending > 0
          ? (otherTotal / totalSpending * 100)
          : 0.0;

      if (otherTotal > 0) {
        top5.add(CategorySpendingData(
          categoryId: 'other',
          categoryName: 'Other',
          color: const Color(0xFF999999),
          amount: otherTotal,
          percentage: otherPercentage,
        ));
      }
      return top5;
    }

    return result;
  }

  List<DailySpendingData> _calculateDailySpending(
    List<Transaction> transactions,
    DateTime startDate,
    DateTime endDate,
    int timeframe,
  ) {
    final expenses = transactions.where((t) => !t.isIncome).toList();
    final List<DailySpendingData> result = [];

    if (timeframe == 0) {
      // Weekly - show last 7 days
      for (int i = 0; i < 7; i++) {
        final date = startDate.add(Duration(days: i));
        final dayExpenses = expenses
            .where((t) =>
                t.date.year == date.year &&
                t.date.month == date.month &&
                t.date.day == date.day)
            .fold(0.0, (sum, t) => sum + t.amount);

        result.add(DailySpendingData(
          date: date,
          amount: dayExpenses,
          dayLabel: _getDayLabel(date),
        ));
      }
    } else if (timeframe == 1) {
      // Monthly - group by week
      final weeksInMonth = ((endDate.day - 1) ~/ 7) + 1;
      for (int week = 0; week < weeksInMonth; week++) {
        final weekStart = DateTime(startDate.year, startDate.month, 1 + (week * 7));
        final weekEnd = DateTime(startDate.year, startDate.month, (week + 1) * 7);

        final weekExpenses = expenses
            .where((t) =>
                t.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                t.date.isBefore(weekEnd.add(const Duration(days: 1))))
            .fold(0.0, (sum, t) => sum + t.amount);

        result.add(DailySpendingData(
          date: weekStart,
          amount: weekExpenses,
          dayLabel: 'W${week + 1}',
        ));
      }
    } else {
      // Yearly - group by month
      for (int month = 1; month <= DateTime.now().month; month++) {
        final monthStart = DateTime(startDate.year, month, 1);
        final monthEnd = DateTime(startDate.year, month + 1, 0);

        final monthExpenses = expenses
            .where((t) =>
                t.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
                t.date.isBefore(monthEnd.add(const Duration(days: 1))))
            .fold(0.0, (sum, t) => sum + t.amount);

        result.add(DailySpendingData(
          date: monthStart,
          amount: monthExpenses,
          dayLabel: _getMonthLabel(month),
        ));
      }
    }

    return result;
  }

  Future<List<BudgetComparisonData>> _calculateBudgetComparison() async {
    final budgetState = _ref.read(budgetProvider);
    final List<BudgetComparisonData> result = [];

    for (final budget in budgetState.budgets) {
      // Get transactions within budget period
      final transactions = await _db.getTransactionsByDateRange(
        budget.startDate,
        budget.endDate,
      );

      // Calculate spent amount
      final spent = transactions
          .where((t) =>
              !t.isIncome &&
              (budget.categoryId.isEmpty || t.categoryId == budget.categoryId))
          .fold(0.0, (sum, t) => sum + t.amount);

      final percentage = budget.limit > 0 ? (spent / budget.limit) : 0.0;

      result.add(BudgetComparisonData(
        budgetId: budget.id,
        budgetName: budget.name,
        budgetLimit: budget.limit,
        spent: spent,
        color: const Color(0xFF667eea), // Default color
        percentage: percentage,
        isOverBudget: percentage > 1.0,
      ));
    }

    return result;
  }

  String _getDayLabel(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getMonthLabel(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Color _parseColor(String colorCode) {
    try {
      final hex = colorCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFF667eea);
    }
  }

  /// Refresh data for a specific timeframe
  Future<void> refreshForTimeframe(int timeframe) async {
    await loadReportsData(timeframe: timeframe);
  }
}

/// Provider for reports data
final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final db = ref.watch(databaseProvider);
  return ReportsNotifier(db, ref);
});
