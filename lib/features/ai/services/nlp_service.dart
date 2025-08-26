import 'package:flutter/foundation.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class NLPService {
  /// Parse natural language query and extract intent and parameters
  QueryIntent parseQuery(String query) {
    try {
      final lowerQuery = query.toLowerCase();

      // Check for spending analysis queries
      if (lowerQuery.contains('spend') ||
          lowerQuery.contains('spent') ||
          lowerQuery.contains('expense') ||
          lowerQuery.contains('expenses')) {
        return QueryIntent(
          type: IntentType.spendingAnalysis,
          query: query,
          parameters: _extractSpendingParameters(lowerQuery),
        );
      }

      // Check for income queries
      if (lowerQuery.contains('income') ||
          lowerQuery.contains('earn') ||
          lowerQuery.contains('salary') ||
          lowerQuery.contains('pay')) {
        return QueryIntent(
          type: IntentType.incomeAnalysis,
          query: query,
          parameters: _extractIncomeParameters(lowerQuery),
        );
      }

      // Check for budget queries
      if (lowerQuery.contains('budget') ||
          lowerQuery.contains('limit') ||
          lowerQuery.contains('plan')) {
        return QueryIntent(
          type: IntentType.budgetAnalysis,
          query: query,
          parameters: _extractBudgetParameters(lowerQuery),
        );
      }

      // Check for savings queries
      if (lowerQuery.contains('save') ||
          lowerQuery.contains('savings') ||
          lowerQuery.contains('saved')) {
        return QueryIntent(
          type: IntentType.savingsAnalysis,
          query: query,
          parameters: _extractSavingsParameters(lowerQuery),
        );
      }

      // Check for category queries
      if (lowerQuery.contains('category') || lowerQuery.contains('spent on')) {
        return QueryIntent(
          type: IntentType.categoryAnalysis,
          query: query,
          parameters: _extractCategoryParameters(lowerQuery),
        );
      }

      // Default to general query
      return QueryIntent(
        type: IntentType.general,
        query: query,
        parameters: {},
      );
    } catch (e) {
      debugPrint('Error parsing query: $e');
      return QueryIntent(
        type: IntentType.general,
        query: query,
        parameters: {},
      );
    }
  }

  /// Extract parameters for spending analysis queries
  Map<String, dynamic> _extractSpendingParameters(String query) {
    final parameters = <String, dynamic>{};

    // Extract time period
    if (query.contains('last month') || query.contains('previous month')) {
      parameters['period'] = 'last_month';
    } else if (query.contains('this month') ||
        query.contains('current month')) {
      parameters['period'] = 'current_month';
    } else if (query.contains('last week') || query.contains('previous week')) {
      parameters['period'] = 'last_week';
    } else if (query.contains('this week') || query.contains('current week')) {
      parameters['period'] = 'current_week';
    } else if (query.contains('today')) {
      parameters['period'] = 'today';
    } else if (query.contains('year') || query.contains('annual')) {
      parameters['period'] = 'year';
    }

    // Extract category
    final categoryKeywords = {
      'food': ['food', 'grocery', 'restaurant', 'meal', 'dining'],
      'transportation': ['gas', 'fuel', 'uber', 'taxi', 'bus', 'train', 'car'],
      'shopping': ['shop', 'buy', 'purchase', 'clothes', 'store'],
      'entertainment': ['movie', 'concert', 'game', 'fun', 'entertainment'],
      'utilities': ['electric', 'water', 'internet', 'phone', 'utility'],
      'healthcare': ['doctor', 'hospital', 'medicine', 'health', 'medical'],
    };

    for (final entry in categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (query.contains(keyword)) {
          parameters['category'] = entry.key;
          break;
        }
      }
      if (parameters.containsKey('category')) break;
    }

    return parameters;
  }

  /// Extract parameters for income analysis queries
  Map<String, dynamic> _extractIncomeParameters(String query) {
    final parameters = <String, dynamic>{};

    // Extract time period
    if (query.contains('last month') || query.contains('previous month')) {
      parameters['period'] = 'last_month';
    } else if (query.contains('this month') ||
        query.contains('current month')) {
      parameters['period'] = 'current_month';
    } else if (query.contains('last week') || query.contains('previous week')) {
      parameters['period'] = 'last_week';
    } else if (query.contains('this week') || query.contains('current week')) {
      parameters['period'] = 'current_week';
    } else if (query.contains('today')) {
      parameters['period'] = 'today';
    } else if (query.contains('year') || query.contains('annual')) {
      parameters['period'] = 'year';
    }

    return parameters;
  }

  /// Extract parameters for budget analysis queries
  Map<String, dynamic> _extractBudgetParameters(String query) {
    final parameters = <String, dynamic>{};

    // Extract category
    final categoryKeywords = {
      'food': ['food', 'grocery', 'restaurant', 'meal', 'dining'],
      'transportation': ['gas', 'fuel', 'uber', 'taxi', 'bus', 'train', 'car'],
      'shopping': ['shop', 'buy', 'purchase', 'clothes', 'store'],
      'entertainment': ['movie', 'concert', 'game', 'fun', 'entertainment'],
      'utilities': ['electric', 'water', 'internet', 'phone', 'utility'],
      'healthcare': ['doctor', 'hospital', 'medicine', 'health', 'medical'],
    };

    for (final entry in categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (query.contains(keyword)) {
          parameters['category'] = entry.key;
          break;
        }
      }
      if (parameters.containsKey('category')) break;
    }

    return parameters;
  }

  /// Extract parameters for savings analysis queries
  Map<String, dynamic> _extractSavingsParameters(String query) {
    final parameters = <String, dynamic>{};

    // Extract time period
    if (query.contains('last month') || query.contains('previous month')) {
      parameters['period'] = 'last_month';
    } else if (query.contains('this month') ||
        query.contains('current month')) {
      parameters['period'] = 'current_month';
    } else if (query.contains('last week') || query.contains('previous week')) {
      parameters['period'] = 'last_week';
    } else if (query.contains('this week') || query.contains('current week')) {
      parameters['period'] = 'current_week';
    } else if (query.contains('today')) {
      parameters['period'] = 'today';
    } else if (query.contains('year') || query.contains('annual')) {
      parameters['period'] = 'year';
    }

    return parameters;
  }

  /// Extract parameters for category analysis queries
  Map<String, dynamic> _extractCategoryParameters(String query) {
    final parameters = <String, dynamic>{};

    // Extract category
    final categoryKeywords = {
      'food': ['food', 'grocery', 'restaurant', 'meal', 'dining'],
      'transportation': ['gas', 'fuel', 'uber', 'taxi', 'bus', 'train', 'car'],
      'shopping': ['shop', 'buy', 'purchase', 'clothes', 'store'],
      'entertainment': ['movie', 'concert', 'game', 'fun', 'entertainment'],
      'utilities': ['electric', 'water', 'internet', 'phone', 'utility'],
      'healthcare': ['doctor', 'hospital', 'medicine', 'health', 'medical'],
    };

    for (final entry in categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (query.contains(keyword)) {
          parameters['category'] = entry.key;
          break;
        }
      }
      if (parameters.containsKey('category')) break;
    }

    // Extract time period
    if (query.contains('last month') || query.contains('previous month')) {
      parameters['period'] = 'last_month';
    } else if (query.contains('this month') ||
        query.contains('current month')) {
      parameters['period'] = 'current_month';
    } else if (query.contains('last week') || query.contains('previous week')) {
      parameters['period'] = 'last_week';
    } else if (query.contains('this week') || query.contains('current week')) {
      parameters['period'] = 'current_week';
    } else if (query.contains('today')) {
      parameters['period'] = 'today';
    } else if (query.contains('year') || query.contains('annual')) {
      parameters['period'] = 'year';
    }

    return parameters;
  }

  /// Generate response based on query intent and transaction data
  String generateResponse(QueryIntent intent, List<Transaction> transactions) {
    try {
      switch (intent.type) {
        case IntentType.spendingAnalysis:
          return _generateSpendingResponse(intent, transactions);
        case IntentType.incomeAnalysis:
          return _generateIncomeResponse(intent, transactions);
        case IntentType.budgetAnalysis:
          return _generateBudgetResponse(intent, transactions);
        case IntentType.savingsAnalysis:
          return _generateSavingsResponse(intent, transactions);
        case IntentType.categoryAnalysis:
          return _generateCategoryResponse(intent, transactions);
        case IntentType.general:
          return 'I understand you have a general question. Could you please provide more specific details about what you\'d like to know?';
      }
    } catch (e) {
      debugPrint('Error generating response: $e');
      return 'Sorry, I had trouble processing your request. Could you please rephrase your question?';
    }
  }

  /// Generate spending analysis response
  String _generateSpendingResponse(
    QueryIntent intent,
    List<Transaction> transactions,
  ) {
    final period = intent.parameters['period'] as String?;
    final category = intent.parameters['category'] as String?;

    // Filter transactions based on period
    final filteredTransactions = _filterTransactionsByPeriod(
      transactions,
      period,
    );

    // Filter by category if specified
    final expenseTransactions = filteredTransactions
        .where((t) => t.type == 'expense')
        .toList();

    final categoryTransactions = category != null
        ? expenseTransactions
              .where((t) => t.category.toLowerCase() == category)
              .toList()
        : expenseTransactions;

    // Calculate totals
    double totalSpent = 0.0;
    for (final transaction in categoryTransactions) {
      totalSpent += transaction.amount;
    }

    // Generate response
    final periodText = _getPeriodText(period);
    final categoryText = category != null ? ' on $category' : '';

    if (categoryTransactions.isEmpty) {
      return 'You haven\'t spent anything$categoryText $periodText.';
    }

    return 'You spent \$${totalSpent.toStringAsFixed(2)}$categoryText $periodText. '
        'This accounts for ${(totalSpent / _getTotalExpenses(expenseTransactions) * 100).toStringAsFixed(1)}% of your total expenses.';
  }

  /// Generate income analysis response
  String _generateIncomeResponse(
    QueryIntent intent,
    List<Transaction> transactions,
  ) {
    final period = intent.parameters['period'] as String?;

    // Filter transactions based on period
    final filteredTransactions = _filterTransactionsByPeriod(
      transactions,
      period,
    );

    // Filter income transactions
    final incomeTransactions = filteredTransactions
        .where((t) => t.type == 'income')
        .toList();

    // Calculate totals
    double totalIncome = 0.0;
    for (final transaction in incomeTransactions) {
      totalIncome += transaction.amount;
    }

    // Generate response
    final periodText = _getPeriodText(period);

    if (incomeTransactions.isEmpty) {
      return 'You didn\'t receive any income $periodText.';
    }

    return 'You received \$${totalIncome.toStringAsFixed(2)} in income $periodText.';
  }

  /// Generate budget analysis response
  String _generateBudgetResponse(
    QueryIntent intent,
    List<Transaction> transactions,
  ) {
    final category = intent.parameters['category'] as String?;

    if (category == null) {
      return 'Please specify which category you\'d like to analyze your budget for.';
    }

    // Filter transactions for the category
    final categoryTransactions = transactions
        .where(
          (t) => t.type == 'expense' && t.category.toLowerCase() == category,
        )
        .toList();

    // Calculate total spent on this category
    double totalSpent = 0.0;
    for (final transaction in categoryTransactions) {
      totalSpent += transaction.amount;
    }

    // Generate response
    return 'You\'ve spent \$${totalSpent.toStringAsFixed(2)} on $category so far. '
        'Consider setting a budget limit to help manage your spending in this category.';
  }

  /// Generate savings analysis response
  String _generateSavingsResponse(
    QueryIntent intent,
    List<Transaction> transactions,
  ) {
    final period = intent.parameters['period'] as String?;

    // Filter transactions based on period
    final filteredTransactions = _filterTransactionsByPeriod(
      transactions,
      period,
    );

    // Calculate totals
    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (final transaction in filteredTransactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
      }
    }

    final double savings = totalIncome - totalExpenses;
    final double savingsRate = totalIncome > 0
        ? (savings / totalIncome) * 100
        : 0;

    // Generate response
    final periodText = _getPeriodText(period);

    if (savings > 0) {
      return 'You saved \$${savings.toStringAsFixed(2)} $periodText, which is ${savingsRate.toStringAsFixed(1)}% of your income.';
    } else if (savings < 0) {
      return 'You spent \$${(-savings).toStringAsFixed(2)} more than you earned $periodText.';
    } else {
      return 'Your income and expenses were balanced $periodText.';
    }
  }

  /// Generate category analysis response
  String _generateCategoryResponse(
    QueryIntent intent,
    List<Transaction> transactions,
  ) {
    final category = intent.parameters['category'] as String?;
    final period = intent.parameters['period'] as String?;

    if (category == null) {
      return 'Please specify which category you\'d like to analyze.';
    }

    // Filter transactions based on period
    final filteredTransactions = _filterTransactionsByPeriod(
      transactions,
      period,
    );

    // Filter transactions for the category
    final categoryTransactions = filteredTransactions
        .where(
          (t) => t.type == 'expense' && t.category.toLowerCase() == category,
        )
        .toList();

    // Calculate total spent on this category
    double totalSpent = 0.0;
    for (final transaction in categoryTransactions) {
      totalSpent += transaction.amount;
    }

    // Generate response
    final periodText = period != null ? ' ${_getPeriodText(period)}' : '';

    if (categoryTransactions.isEmpty) {
      return 'You haven\'t spent anything on $category$periodText.';
    }

    return 'You spent \$${totalSpent.toStringAsFixed(2)} on $category$periodText. '
        'This was your ${_getCategoryRank(category, filteredTransactions)} most expensive category.';
  }

  /// Filter transactions by period
  List<Transaction> _filterTransactionsByPeriod(
    List<Transaction> transactions,
    String? period,
  ) {
    if (period == null) {
      // Return last 30 days by default
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
      return transactions.where((t) => t.date.isAfter(cutoffDate)).toList();
    }

    final now = DateTime.now();

    switch (period) {
      case 'today':
        final today = DateTime(now.year, now.month, now.day);
        return transactions
            .where(
              (t) =>
                  t.date.year == today.year &&
                  t.date.month == today.month &&
                  t.date.day == today.day,
            )
            .toList();

      case 'current_week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return transactions
            .where(
              (t) => t.date.isAfter(startOfWeek) && t.date.isBefore(endOfWeek),
            )
            .toList();

      case 'last_week':
        final endOfLastWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfLastWeek = endOfLastWeek.subtract(const Duration(days: 7));
        return transactions
            .where(
              (t) =>
                  t.date.isAfter(startOfLastWeek) &&
                  t.date.isBefore(endOfLastWeek),
            )
            .toList();

      case 'current_month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return transactions
            .where(
              (t) =>
                  t.date.isAfter(startOfMonth) && t.date.isBefore(endOfMonth),
            )
            .toList();

      case 'last_month':
        final endOfLastMonth = DateTime(now.year, now.month, 0);
        final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
        return transactions
            .where(
              (t) =>
                  t.date.isAfter(startOfLastMonth) &&
                  t.date.isBefore(endOfLastMonth),
            )
            .toList();

      case 'year':
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year, 12, 31);
        return transactions
            .where(
              (t) => t.date.isAfter(startOfYear) && t.date.isBefore(endOfYear),
            )
            .toList();

      default:
        // This case should never be reached due to the null check above
        // Return last 30 days as fallback
        final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
        return transactions.where((t) => t.date.isAfter(cutoffDate)).toList();
    }
  }

  /// Get period text for responses
  String _getPeriodText(String? period) {
    switch (period) {
      case 'today':
        return 'today';
      case 'current_week':
        return 'this week';
      case 'last_week':
        return 'last week';
      case 'current_month':
        return 'this month';
      case 'last_month':
        return 'last month';
      case 'year':
        return 'this year';
      default:
        return 'in the last 30 days';
    }
  }

  /// Get total expenses from a list of transactions
  double _getTotalExpenses(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get category rank
  String _getCategoryRank(String category, List<Transaction> transactions) {
    // Calculate spending by category
    final Map<String, double> categorySpending = {};

    for (final transaction in transactions) {
      if (transaction.type == 'expense') {
        if (categorySpending.containsKey(transaction.category)) {
          categorySpending[transaction.category] =
              categorySpending[transaction.category]! + transaction.amount;
        } else {
          categorySpending[transaction.category] = transaction.amount;
        }
      }
    }

    // Sort categories by spending
    final sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Find rank of the specified category
    for (int i = 0; i < sortedCategories.length; i++) {
      if (sortedCategories[i].key.toLowerCase() == category) {
        final rank = i + 1;
        final suffix = rank == 1
            ? 'st'
            : rank == 2
            ? 'nd'
            : rank == 3
            ? 'rd'
            : 'th';
        return '$rank$suffix';
      }
    }

    return 'N/A';
  }
}

class QueryIntent {
  final IntentType type;
  final String query;
  final Map<String, dynamic> parameters;

  QueryIntent({
    required this.type,
    required this.query,
    required this.parameters,
  });
}

enum IntentType {
  spendingAnalysis,
  incomeAnalysis,
  budgetAnalysis,
  savingsAnalysis,
  categoryAnalysis,
  general,
}
