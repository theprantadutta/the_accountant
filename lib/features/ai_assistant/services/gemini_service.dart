import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

/// Client for premium AI text generation.
///
/// Routes all requests through the backend (`POST /ai/insights`, which is `[Authorize]` +
/// `[PremiumRequired]`). The backend holds the AI provider key server-side. The app no longer
/// calls Google Gemini directly and no longer ships an API key — premium is enforced on the
/// server, not just by the client gate.
///
/// The class name is kept for compatibility with existing providers/call sites.
class GeminiService {
  final ApiService _apiService;

  GeminiService({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  /// Send a prompt to the backend AI endpoint and return the generated text.
  Future<String> _generate(String prompt) async {
    try {
      final response = await _apiService.post(
        '/ai/insights',
        data: {'prompt': prompt},
      );
      final data = response.data as Map<String, dynamic>;
      final text = (data['text'] ?? data['Text'] ?? '') as String? ?? '';
      if (text.isEmpty) {
        return 'Sorry, I couldn\'t generate a response right now. Please try again later.';
      }
      return text;
    } catch (e) {
      return 'Sorry, I\'m having trouble connecting to the AI service. Please try again later.';
    }
  }

  Future<String> generateFinancialInsight(String prompt) {
    return _generate('You are a personal finance assistant. $prompt');
  }

  /// Generate financial insights based on transaction data.
  Future<String> generateFinancialInsightsFromTransactions(
    List<Transaction> transactions,
  ) async {
    final StringBuffer transactionData = StringBuffer();
    transactionData.write('Here is my transaction data for analysis:\n\n');

    final incomeTransactions =
        transactions.where((t) => t.type == 'income').toList();
    if (incomeTransactions.isNotEmpty) {
      transactionData.write('Income Transactions:\n');
      for (final transaction in incomeTransactions.take(10)) {
        transactionData.write(
          '- ${transaction.date.toIso8601String().split('T')[0]}: \$${(transaction.amount / 100.0).toStringAsFixed(2)} (${transaction.category})\n',
        );
      }
      transactionData.write('\n');
    }

    final expenseTransactions =
        transactions.where((t) => t.type == 'expense').toList();
    if (expenseTransactions.isNotEmpty) {
      transactionData.write('Expense Transactions:\n');
      for (final transaction in expenseTransactions.take(20)) {
        transactionData.write(
          '- ${transaction.date.toIso8601String().split('T')[0]}: \$${(transaction.amount / 100.0).toStringAsFixed(2)} (${transaction.category}) - ${transaction.notes}\n',
        );
      }
      transactionData.write('\n');
    }

    double totalIncome = 0.0;
    double totalExpenses = 0.0;
    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount / 100.0;
      } else {
        totalExpenses += transaction.amount / 100.0;
      }
    }
    final double netSavings = totalIncome - totalExpenses;

    transactionData.write('Summary:\n');
    transactionData
        .write('- Total Income: \$${totalIncome.toStringAsFixed(2)}\n');
    transactionData
        .write('- Total Expenses: \$${totalExpenses.toStringAsFixed(2)}\n');
    transactionData
        .write('- Net Savings: \$${netSavings.toStringAsFixed(2)}\n\n');

    final prompt =
        '''
    ${transactionData.toString()}

    Based on this financial data, please provide:
    1. An analysis of my spending patterns
    2. Suggestions for improving my financial health
    3. Identification of any concerning spending trends
    4. Recommendations for budgeting or saving strategies
    5. Any other insights that would be valuable for my financial well-being

    Please provide your response in a clear, concise format with actionable advice.
    ''';

    return _generate(prompt);
  }

  /// Generate personalized financial advice.
  Future<String> generatePersonalizedAdvice({
    required List<Transaction> transactions,
    required double monthlyIncome,
    required List<String> financialGoals,
  }) async {
    final StringBuffer transactionData = StringBuffer();
    transactionData.write(
      'Here is my financial information for personalized advice:\n\n',
    );

    final expenseTransactions =
        transactions.where((t) => t.type == 'expense').toList();
    if (expenseTransactions.isNotEmpty) {
      transactionData.write('Recent Expense Transactions:\n');
      for (final transaction in expenseTransactions.take(10)) {
        transactionData.write(
          '- ${transaction.date.toIso8601String().split('T')[0]}: \$${(transaction.amount / 100.0).toStringAsFixed(2)} (${transaction.category})\n',
        );
      }
      transactionData.write('\n');
    }

    transactionData
        .write('Monthly Income: \$${monthlyIncome.toStringAsFixed(2)}\n');
    transactionData.write('Financial Goals: ${financialGoals.join(', ')}\n\n');

    final prompt =
        '''
    ${transactionData.toString()}

    Based on this information, please provide personalized financial advice that:
    1. Helps me achieve my financial goals
    2. Suggests specific actions I can take with my current income
    3. Identifies areas where I might be able to reduce expenses
    4. Recommends strategies for saving more effectively
    5. Provides a realistic timeline for achieving my goals

    Please provide practical, actionable advice that is tailored to my specific situation.
    ''';

    return _generate(prompt);
  }
}
