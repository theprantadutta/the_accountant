import 'package:flutter/foundation.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

class ChatInsightsService {
  /// Generate contextual financial insights based on conversation history and transaction data
  String generateContextualInsights({
    required List<Map<String, dynamic>> conversationHistory,
    required List<Transaction> transactions,
    required List<Budget> budgets,
  }) {
    try {
      // Analyze the conversation to understand context
      final conversationContext = _analyzeConversationContext(
        conversationHistory,
      );

      // Generate insights based on context
      final insights = _generateInsightsByContext(
        context: conversationContext,
        transactions: transactions,
        budgets: budgets,
      );

      return insights;
    } catch (e) {
      debugPrint('Error generating contextual insights: $e');
      return '';
    }
  }

  /// Analyze conversation context
  ConversationContext _analyzeConversationContext(
    List<Map<String, dynamic>> conversationHistory,
  ) {
    // Look at the last few messages to understand the context
    final recentMessages = conversationHistory.length > 3
        ? conversationHistory.sublist(conversationHistory.length - 3)
        : conversationHistory;

    // Check for spending-related keywords
    bool hasSpendingContext = false;
    bool hasBudgetContext = false;
    bool hasSavingsContext = false;
    bool hasCategoryContext = false;

    for (final message in recentMessages) {
      final text = (message['text'] as String).toLowerCase();

      if (text.contains('spend') ||
          text.contains('spent') ||
          text.contains('expense')) {
        hasSpendingContext = true;
      }

      if (text.contains('budget') || text.contains('limit')) {
        hasBudgetContext = true;
      }

      if (text.contains('save') || text.contains('savings')) {
        hasSavingsContext = true;
      }

      if (text.contains('category') ||
          text.contains('food') ||
          text.contains('transport')) {
        hasCategoryContext = true;
      }
    }

    return ConversationContext(
      hasSpendingContext: hasSpendingContext,
      hasBudgetContext: hasBudgetContext,
      hasSavingsContext: hasSavingsContext,
      hasCategoryContext: hasCategoryContext,
    );
  }

  /// Generate insights based on conversation context
  String _generateInsightsByContext({
    required ConversationContext context,
    required List<Transaction> transactions,
    required List<Budget> budgets,
  }) {
    final StringBuffer insights = StringBuffer();

    // Generate spending insights if relevant
    if (context.hasSpendingContext) {
      final spendingInsight = _generateSpendingInsight(transactions);
      if (spendingInsight.isNotEmpty) {
        insights.write('$spendingInsight\n');
      }
    }

    // Generate budget insights if relevant
    if (context.hasBudgetContext && budgets.isNotEmpty) {
      final budgetInsight = _generateBudgetInsight(transactions, budgets);
      if (budgetInsight.isNotEmpty) {
        insights.write('$budgetInsight\n');
      }
    }

    // Generate savings insights if relevant
    if (context.hasSavingsContext) {
      final savingsInsight = _generateSavingsInsight(transactions);
      if (savingsInsight.isNotEmpty) {
        insights.write('$savingsInsight\n');
      }
    }

    // Generate category insights if relevant
    if (context.hasCategoryContext) {
      final categoryInsight = _generateCategoryInsight(transactions);
      if (categoryInsight.isNotEmpty) {
        insights.write('$categoryInsight\n');
      }
    }

    return insights.toString().trim();
  }

  /// Generate spending insight
  String _generateSpendingInsight(List<Transaction> transactions) {
    // Get recent expenses (last 30 days)
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    final recentExpenses = transactions
        .where((t) => t.type == 'expense' && t.date.isAfter(cutoffDate))
        .toList();

    if (recentExpenses.isEmpty) {
      return '';
    }

    // Calculate total spending
    double totalSpending = 0.0;
    for (final transaction in recentExpenses) {
      totalSpending += transaction.amount;
    }

    // Calculate average daily spending
    final double averageDailySpending = totalSpending / 30;

    // Compare with previous period
    final previousCutoffDate = DateTime.now().subtract(
      const Duration(days: 60),
    );
    final previousExpenses = transactions
        .where(
          (t) =>
              t.type == 'expense' &&
              t.date.isAfter(previousCutoffDate) &&
              t.date.isBefore(cutoffDate),
        )
        .toList();

    double previousTotalSpending = 0.0;
    for (final transaction in previousExpenses) {
      previousTotalSpending += transaction.amount;
    }

    final double previousAverageDailySpending = previousTotalSpending / 30;

    // Generate insight
    if (averageDailySpending > previousAverageDailySpending * 1.2) {
      return '💡 Your spending has increased by ${((averageDailySpending - previousAverageDailySpending) / previousAverageDailySpending * 100).toStringAsFixed(1)}% compared to the previous month.';
    } else if (averageDailySpending < previousAverageDailySpending * 0.8) {
      return '💡 Great job! Your spending has decreased by ${((previousAverageDailySpending - averageDailySpending) / previousAverageDailySpending * 100).toStringAsFixed(1)}% compared to the previous month.';
    }

    return '';
  }

  /// Generate budget insight
  String _generateBudgetInsight(
    List<Transaction> transactions,
    List<Budget> budgets,
  ) {
    // Check if any budgets are close to their limits
    final List<String> budgetWarnings = [];

    for (final budget in budgets) {
      // Calculate spent amount for this budget's category
      final spent = transactions
          .where(
            (transaction) =>
                transaction.categoryId == budget.categoryId &&
                transaction.type == 'expense' &&
                transaction.date.isAfter(budget.startDate) &&
                transaction.date.isBefore(budget.endDate),
          )
          .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);

      final percentage = budget.limit > 0
          ? (spent / budget.limit) * 100.0
          : 0.0;

      if (percentage >= 90) {
        budgetWarnings.add(
          '${budget.name} is at ${percentage.toStringAsFixed(1)}% of its limit',
        );
      } else if (percentage >= 75) {
        budgetWarnings.add(
          '${budget.name} is at ${percentage.toStringAsFixed(1)}% of its limit',
        );
      }
    }

    if (budgetWarnings.isNotEmpty) {
      return '💰 Budget Alert: ${budgetWarnings.join(', ')}';
    }

    return '';
  }

  /// Generate savings insight
  String _generateSavingsInsight(List<Transaction> transactions) {
    // Calculate savings rate
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    final recentTransactions = transactions
        .where((t) => t.date.isAfter(cutoffDate))
        .toList();

    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (final transaction in recentTransactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
      }
    }

    if (totalIncome > 0) {
      final double savingsRate =
          ((totalIncome - totalExpenses) / totalIncome) * 100;

      if (savingsRate < 10) {
        return '🏦 Your savings rate is ${savingsRate.toStringAsFixed(1)}%. Consider setting aside more each month.';
      } else if (savingsRate >= 20) {
        return '🏦 Excellent! You\'re saving ${savingsRate.toStringAsFixed(1)}% of your income.';
      }
    }

    return '';
  }

  /// Generate category insight
  String _generateCategoryInsight(List<Transaction> transactions) {
    // Get spending by category
    final Map<String, double> categorySpending = {};

    for (final transaction in transactions) {
      if (transaction.type == 'expense') {
        if (categorySpending.containsKey(transaction.categoryId)) {
          categorySpending[transaction.categoryId] =
              categorySpending[transaction.categoryId]! + transaction.amount;
        } else {
          categorySpending[transaction.categoryId] = transaction.amount;
        }
      }
    }

    if (categorySpending.isEmpty) {
      return '';
    }

    // Find the highest spending category
    String highestCategory = '';
    double highestAmount = 0.0;

    categorySpending.forEach((category, amount) {
      if (amount > highestAmount) {
        highestAmount = amount;
        highestCategory = category;
      }
    });

    // Calculate percentage of total spending
    double totalSpending = 0.0;
    for (final amount in categorySpending.values) {
      totalSpending += amount;
    }

    if (totalSpending > 0) {
      final double percentage = (highestAmount / totalSpending) * 100;

      if (percentage > 30) {
        return '📊 You\'re spending ${percentage.toStringAsFixed(1)}% of your total expenses on $highestCategory.';
      }
    }

    return '';
  }

  /// Generate proactive financial suggestions
  List<String> generateProactiveSuggestions({
    required List<Transaction> transactions,
    required List<Budget> budgets,
  }) {
    final List<String> suggestions = [];

    // Suggestion: Set up a budget if none exists
    if (budgets.isEmpty) {
      suggestions.add(
        'Consider setting up budgets to help manage your spending.',
      );
    }

    // Suggestion: Review spending patterns
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    final recentExpenses = transactions
        .where((t) => t.type == 'expense' && t.date.isAfter(cutoffDate))
        .toList();

    if (recentExpenses.length > 10) {
      suggestions.add(
        'Review your recent spending to identify areas where you could cut back.',
      );
    }

    // Suggestion: Increase savings
    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (final transaction in recentExpenses) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
      }
    }

    if (totalIncome > 0) {
      final double savingsRate =
          ((totalIncome - totalExpenses) / totalIncome) * 100;

      if (savingsRate < 15) {
        suggestions.add(
          'Try to increase your savings rate. Even 1% more can make a difference over time.',
        );
      }
    }

    return suggestions;
  }
}

class ConversationContext {
  final bool hasSpendingContext;
  final bool hasBudgetContext;
  final bool hasSavingsContext;
  final bool hasCategoryContext;

  ConversationContext({
    required this.hasSpendingContext,
    required this.hasBudgetContext,
    required this.hasSavingsContext,
    required this.hasCategoryContext,
  });
}
