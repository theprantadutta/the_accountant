import 'package:flutter/foundation.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class MonthlySummaryService {
  /// Generate a monthly summary based on transactions
  MonthlySummary generateMonthlySummary({
    required List<Transaction> transactions,
    required DateTime month,
  }) {
    try {
      // Filter transactions for the specified month
      final monthTransactions = transactions.where((t) {
        return t.date.year == month.year && t.date.month == month.month;
      }).toList();

      // Calculate totals
      double totalIncome = 0.0;
      double totalExpenses = 0.0;

      // Category breakdown
      final Map<String, double> categoryBreakdown = {};

      // Calculate totals and category breakdown
      for (final transaction in monthTransactions) {
        if (transaction.type == 'income') {
          totalIncome += transaction.amount;
        } else {
          totalExpenses += transaction.amount;

          // Add to category breakdown
          if (categoryBreakdown.containsKey(transaction.categoryId)) {
            categoryBreakdown[transaction.categoryId] =
                categoryBreakdown[transaction.categoryId]! + transaction.amount;
          } else {
            categoryBreakdown[transaction.categoryId] = transaction.amount;
          }
        }
      }

      // Net savings
      final double netSavings = totalIncome - totalExpenses;

      // Spending trends (compare with previous month)
      final DateTime previousMonth = DateTime(month.year, month.month - 1, 1);
      final previousMonthTransactions = transactions.where((t) {
        return t.date.year == previousMonth.year &&
            t.date.month == previousMonth.month;
      }).toList();

      double previousMonthExpenses = 0.0;
      for (final transaction in previousMonthTransactions) {
        if (transaction.type == 'expense') {
          previousMonthExpenses += transaction.amount;
        }
      }

      // Calculate spending trend
      String spendingTrend = 'stable';
      if (previousMonthExpenses > 0) {
        final double change =
            ((totalExpenses - previousMonthExpenses) / previousMonthExpenses) *
            100;
        if (change > 5) {
          spendingTrend = 'increased';
        } else if (change < -5) {
          spendingTrend = 'decreased';
        }
      }

      // Identify top spending categories
      final List<CategorySpending> topCategories = [];
      categoryBreakdown.forEach((categoryId, amount) {
        topCategories.add(
          CategorySpending(categoryId: categoryId, amount: amount),
        );
      });

      // Sort by amount (descending)
      topCategories.sort((a, b) => b.amount.compareTo(a.amount));

      // Get top 3 categories
      final List<CategorySpending> top3Categories = topCategories
          .take(3)
          .toList();

      return MonthlySummary(
        month: month,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netSavings: netSavings,
        categoryBreakdown: categoryBreakdown,
        spendingTrend: spendingTrend,
        topCategories: top3Categories,
      );
    } catch (e) {
      debugPrint('Error generating monthly summary: $e');
      // Return a default summary in case of error
      return MonthlySummary(
        month: month,
        totalIncome: 0.0,
        totalExpenses: 0.0,
        netSavings: 0.0,
        categoryBreakdown: {},
        spendingTrend: 'stable',
        topCategories: [],
      );
    }
  }

  /// Generate AI insights for the monthly summary
  String generateAIInsights(MonthlySummary summary) {
    final StringBuffer insights = StringBuffer();

    // Overall financial health
    if (summary.netSavings > 0) {
      insights.write(
        'Great job! You saved \$${summary.netSavings.toStringAsFixed(2)} this month. ',
      );
    } else if (summary.netSavings < 0) {
      insights.write(
        'You spent \$${(-summary.netSavings).toStringAsFixed(2)} more than you earned this month. ',
      );
    } else {
      insights.write('Your income and expenses were balanced this month. ');
    }

    // Spending trend analysis
    if (summary.spendingTrend == 'increased') {
      insights.write('Your spending increased compared to last month. ');
    } else if (summary.spendingTrend == 'decreased') {
      insights.write(
        'Good work! Your spending decreased compared to last month. ',
      );
    }

    // Top spending categories
    if (summary.topCategories.isNotEmpty) {
      insights.write('Your biggest expense categories were: ');
      for (int i = 0; i < summary.topCategories.length && i < 3; i++) {
        final category = summary.topCategories[i];
        insights.write(
          '${category.categoryId} (\$${category.amount.toStringAsFixed(2)})',
        );
        if (i < summary.topCategories.length - 1 && i < 2) {
          insights.write(', ');
        }
      }
      insights.write('. ');
    }

    // Savings rate
    if (summary.totalIncome > 0) {
      final double savingsRate =
          (summary.netSavings / summary.totalIncome) * 100;
      if (savingsRate >= 20) {
        insights.write(
          'You maintained a healthy savings rate of ${savingsRate.toStringAsFixed(1)}%. ',
        );
      } else if (savingsRate >= 10) {
        insights.write(
          'Your savings rate was ${savingsRate.toStringAsFixed(1)}%. ',
        );
      } else if (savingsRate > 0) {
        insights.write(
          'You saved ${savingsRate.toStringAsFixed(1)}% of your income. ',
        );
      } else {
        insights.write('Try to save more next month. ');
      }
    }

    return insights.toString().trim();
  }
}

class MonthlySummary {
  final DateTime month;
  final double totalIncome;
  final double totalExpenses;
  final double netSavings;
  final Map<String, double> categoryBreakdown;
  final String spendingTrend; // 'increased', 'decreased', 'stable'
  final List<CategorySpending> topCategories;

  MonthlySummary({
    required this.month,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netSavings,
    required this.categoryBreakdown,
    required this.spendingTrend,
    required this.topCategories,
  });
}

class CategorySpending {
  final String categoryId;
  final double amount;

  CategorySpending({required this.categoryId, required this.amount});
}
