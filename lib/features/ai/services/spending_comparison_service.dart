import 'package:flutter/foundation.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class SpendingComparisonService {
  /// Compare spending between two periods
  SpendingComparison comparePeriods({
    required List<Transaction> transactions,
    required DateTime period1Start,
    required DateTime period1End,
    required DateTime period2Start,
    required DateTime period2End,
  }) {
    try {
      // Filter transactions for each period
      final period1Transactions = transactions.where((t) {
        return t.date.isAfter(period1Start) && t.date.isBefore(period1End);
      }).toList();

      final period2Transactions = transactions.where((t) {
        return t.date.isAfter(period2Start) && t.date.isBefore(period2End);
      }).toList();

      // Calculate totals for each period
      double period1Income = 0.0;
      double period1Expenses = 0.0;
      double period2Income = 0.0;
      double period2Expenses = 0.0;

      // Category breakdown for each period
      final Map<String, double> period1CategoryBreakdown = {};
      final Map<String, double> period2CategoryBreakdown = {};

      // Calculate totals and category breakdown for period 1
      for (final transaction in period1Transactions) {
        if (transaction.type == 'income') {
          period1Income += transaction.amount;
        } else {
          period1Expenses += transaction.amount;

          // Add to category breakdown
          if (period1CategoryBreakdown.containsKey(transaction.categoryId)) {
            period1CategoryBreakdown[transaction.categoryId] =
                period1CategoryBreakdown[transaction.categoryId]! +
                transaction.amount;
          } else {
            period1CategoryBreakdown[transaction.categoryId] =
                transaction.amount;
          }
        }
      }

      // Calculate totals and category breakdown for period 2
      for (final transaction in period2Transactions) {
        if (transaction.type == 'income') {
          period2Income += transaction.amount;
        } else {
          period2Expenses += transaction.amount;

          // Add to category breakdown
          if (period2CategoryBreakdown.containsKey(transaction.categoryId)) {
            period2CategoryBreakdown[transaction.categoryId] =
                period2CategoryBreakdown[transaction.categoryId]! +
                transaction.amount;
          } else {
            period2CategoryBreakdown[transaction.categoryId] =
                transaction.amount;
          }
        }
      }

      // Calculate net savings for each period
      final double period1NetSavings = period1Income - period1Expenses;
      final double period2NetSavings = period2Income - period2Expenses;

      // Calculate changes
      final double incomeChange = period2Income - period1Income;
      final double expenseChange = period2Expenses - period1Expenses;
      final double netSavingsChange = period2NetSavings - period1NetSavings;

      // Calculate percentage changes
      final double incomeChangePercent = period1Income > 0
          ? (incomeChange / period1Income) * 100
          : 0;
      final double expenseChangePercent = period1Expenses > 0
          ? (expenseChange / period1Expenses) * 100
          : 0;
      final double netSavingsChangePercent = period1NetSavings != 0
          ? (netSavingsChange / period1NetSavings) * 100
          : 0;

      // Identify categories with significant changes
      final List<CategoryComparison> categoryComparisons = [];

      // Get all unique categories from both periods
      final Set<String> allCategories = {
        ...period1CategoryBreakdown.keys,
        ...period2CategoryBreakdown.keys,
      };

      for (final categoryId in allCategories) {
        final double amount1 = period1CategoryBreakdown[categoryId] ?? 0.0;
        final double amount2 = period2CategoryBreakdown[categoryId] ?? 0.0;
        final double change = amount2 - amount1;
        final double changePercent = amount1 > 0 ? (change / amount1) * 100 : 0;

        categoryComparisons.add(
          CategoryComparison(
            categoryId: categoryId,
            period1Amount: amount1,
            period2Amount: amount2,
            change: change,
            changePercent: changePercent,
          ),
        );
      }

      // Sort by absolute change (descending)
      categoryComparisons.sort(
        (a, b) => (b.change.abs()).compareTo(a.change.abs()),
      );

      return SpendingComparison(
        period1: SpendingPeriod(
          startDate: period1Start,
          endDate: period1End,
          totalIncome: period1Income,
          totalExpenses: period1Expenses,
          netSavings: period1NetSavings,
          categoryBreakdown: period1CategoryBreakdown,
        ),
        period2: SpendingPeriod(
          startDate: period2Start,
          endDate: period2End,
          totalIncome: period2Income,
          totalExpenses: period2Expenses,
          netSavings: period2NetSavings,
          categoryBreakdown: period2CategoryBreakdown,
        ),
        incomeChange: incomeChange,
        incomeChangePercent: incomeChangePercent,
        expenseChange: expenseChange,
        expenseChangePercent: expenseChangePercent,
        netSavingsChange: netSavingsChange,
        netSavingsChangePercent: netSavingsChangePercent,
        categoryComparisons: categoryComparisons,
      );
    } catch (e) {
      debugPrint('Error comparing spending periods: $e');
      // Return a default comparison in case of error
      return SpendingComparison(
        period1: SpendingPeriod(
          startDate: period1Start,
          endDate: period1End,
          totalIncome: 0.0,
          totalExpenses: 0.0,
          netSavings: 0.0,
          categoryBreakdown: {},
        ),
        period2: SpendingPeriod(
          startDate: period2Start,
          endDate: period2End,
          totalIncome: 0.0,
          totalExpenses: 0.0,
          netSavings: 0.0,
          categoryBreakdown: {},
        ),
        incomeChange: 0.0,
        incomeChangePercent: 0.0,
        expenseChange: 0.0,
        expenseChangePercent: 0.0,
        netSavingsChange: 0.0,
        netSavingsChangePercent: 0.0,
        categoryComparisons: [],
      );
    }
  }

  /// Generate AI insights for the spending comparison
  String generateAIInsights(SpendingComparison comparison) {
    final StringBuffer insights = StringBuffer();

    // Overall income comparison
    if (comparison.incomeChange > 0) {
      insights.write(
        'Your income increased by \$${comparison.incomeChange.toStringAsFixed(2)} (${comparison.incomeChangePercent.toStringAsFixed(1)}%). ',
      );
    } else if (comparison.incomeChange < 0) {
      insights.write(
        'Your income decreased by \$${(-comparison.incomeChange).toStringAsFixed(2)} (${(-comparison.incomeChangePercent).toStringAsFixed(1)}%). ',
      );
    } else {
      insights.write('Your income remained the same. ');
    }

    // Overall expense comparison
    if (comparison.expenseChange > 0) {
      insights.write(
        'Your expenses increased by \$${comparison.expenseChange.toStringAsFixed(2)} (${comparison.expenseChangePercent.toStringAsFixed(1)}%). ',
      );
    } else if (comparison.expenseChange < 0) {
      insights.write(
        'Your expenses decreased by \$${(-comparison.expenseChange).toStringAsFixed(2)} (${(-comparison.expenseChangePercent).toStringAsFixed(1)}%). ',
      );
    } else {
      insights.write('Your expenses remained the same. ');
    }

    // Net savings comparison
    if (comparison.netSavingsChange > 0) {
      insights.write(
        'This resulted in \$${comparison.netSavingsChange.toStringAsFixed(2)} (${comparison.netSavingsChangePercent.toStringAsFixed(1)}%) more savings. ',
      );
    } else if (comparison.netSavingsChange < 0) {
      insights.write(
        'This resulted in \$${(-comparison.netSavingsChange).toStringAsFixed(2)} (${(-comparison.netSavingsChangePercent).toStringAsFixed(1)}%) less savings. ',
      );
    } else {
      insights.write('Your net savings remained the same. ');
    }

    // Significant category changes
    if (comparison.categoryComparisons.isNotEmpty) {
      // Get top 3 categories with biggest changes
      final topChanges = comparison.categoryComparisons
          .take(3)
          .where((c) => c.change.abs() > 10)
          .toList();

      if (topChanges.isNotEmpty) {
        insights.write('The biggest changes were in: ');
        for (int i = 0; i < topChanges.length; i++) {
          final category = topChanges[i];
          if (category.change > 0) {
            insights.write(
              '${category.categoryId} (+\$${category.change.toStringAsFixed(2)})',
            );
          } else {
            insights.write(
              '${category.categoryId} (-\$${(-category.change).toStringAsFixed(2)})',
            );
          }

          if (i < topChanges.length - 1) {
            insights.write(', ');
          }
        }
        insights.write('. ');
      }
    }

    return insights.toString().trim();
  }
}

class SpendingComparison {
  final SpendingPeriod period1;
  final SpendingPeriod period2;
  final double incomeChange;
  final double incomeChangePercent;
  final double expenseChange;
  final double expenseChangePercent;
  final double netSavingsChange;
  final double netSavingsChangePercent;
  final List<CategoryComparison> categoryComparisons;

  SpendingComparison({
    required this.period1,
    required this.period2,
    required this.incomeChange,
    required this.incomeChangePercent,
    required this.expenseChange,
    required this.expenseChangePercent,
    required this.netSavingsChange,
    required this.netSavingsChangePercent,
    required this.categoryComparisons,
  });
}

class SpendingPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpenses;
  final double netSavings;
  final Map<String, double> categoryBreakdown;

  SpendingPeriod({
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netSavings,
    required this.categoryBreakdown,
  });
}

class CategoryComparison {
  final String categoryId;
  final double period1Amount;
  final double period2Amount;
  final double change;
  final double changePercent;

  CategoryComparison({
    required this.categoryId,
    required this.period1Amount,
    required this.period2Amount,
    required this.change,
    required this.changePercent,
  });
}
