import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_accountant/core/utils/env_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  final String _apiKey = EnvService.geminiApiKey;

  Future<String> generateFinancialInsight(String prompt) async {
    if (_apiKey.isEmpty) {
      return 'AI features require API key configuration';
    }

    final url = Uri.parse(
      '$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'You are a personal finance assistant. $prompt'},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } catch (e) {
        return 'Sorry, I couldn\'t process that request. This is a premium feature that uses AI to analyze your finances.';
      }
    } else {
      return 'Sorry, I\'m having trouble connecting to the AI service. Please try again later.';
    }
  }

  Future<String> processReceiptImage(String base64Image) async {
    if (_apiKey.isEmpty) {
      return 'AI features require API key configuration';
    }

    final url = Uri.parse(
      '$_baseUrl/models/gemini-pro-vision:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Analyze this receipt and extract the total amount, date, and merchant name. Also categorize the expense.',
              },
              {
                'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } catch (e) {
        return 'Sorry, I couldn\'t process that receipt. This is a premium feature that uses AI to analyze receipts.';
      }
    } else {
      return 'Sorry, I\'m having trouble connecting to the AI service. Please try again later.';
    }
  }

  /// Generate financial insights based on transaction data
  Future<String> generateFinancialInsightsFromTransactions(
    List<Transaction> transactions,
  ) async {
    if (_apiKey.isEmpty) {
      return 'AI features require API key configuration';
    }

    // Prepare transaction data for the AI
    final StringBuffer transactionData = StringBuffer();
    transactionData.write('Here is my transaction data for analysis:\n\n');

    // Add income transactions
    final incomeTransactions = transactions
        .where((t) => t.type == 'income')
        .toList();
    if (incomeTransactions.isNotEmpty) {
      transactionData.write('Income Transactions:\n');
      for (final transaction in incomeTransactions.take(10)) {
        // Limit to 10 for brevity
        transactionData.write(
          '- ${transaction.date.toIso8601String().split('T')[0]}: \$${transaction.amount.toStringAsFixed(2)} (${transaction.category})\n',
        );
      }
      transactionData.write('\n');
    }

    // Add expense transactions
    final expenseTransactions = transactions
        .where((t) => t.type == 'expense')
        .toList();
    if (expenseTransactions.isNotEmpty) {
      transactionData.write('Expense Transactions:\n');
      for (final transaction in expenseTransactions.take(20)) {
        // Limit to 20 for brevity
        transactionData.write(
          '- ${transaction.date.toIso8601String().split('T')[0]}: \$${transaction.amount.toStringAsFixed(2)} (${transaction.category}) - ${transaction.notes}\n',
        );
      }
      transactionData.write('\n');
    }

    // Calculate totals
    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
      }
    }

    final double netSavings = totalIncome - totalExpenses;

    transactionData.write('Summary:\n');
    transactionData.write(
      '- Total Income: \$${totalIncome.toStringAsFixed(2)}\n',
    );
    transactionData.write(
      '- Total Expenses: \$${totalExpenses.toStringAsFixed(2)}\n',
    );
    transactionData.write(
      '- Net Savings: \$${netSavings.toStringAsFixed(2)}\n\n',
    );

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

    final url = Uri.parse(
      '$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } catch (e) {
        return 'Sorry, I couldn\'t analyze your financial data. This is a premium feature that uses AI to provide financial insights.';
      }
    } else {
      return 'Sorry, I\'m having trouble connecting to the AI service. Please try again later.';
    }
  }

  /// Generate personalized financial advice
  Future<String> generatePersonalizedAdvice({
    required List<Transaction> transactions,
    required double monthlyIncome,
    required List<String> financialGoals,
  }) async {
    if (_apiKey.isEmpty) {
      return 'AI features require API key configuration';
    }

    // Prepare transaction data for the AI
    final StringBuffer transactionData = StringBuffer();
    transactionData.write(
      'Here is my financial information for personalized advice:\n\n',
    );

    // Add recent transactions (last 10 expenses)
    final expenseTransactions = transactions
        .where((t) => t.type == 'expense')
        .toList();
    if (expenseTransactions.isNotEmpty) {
      transactionData.write('Recent Expense Transactions:\n');
      for (final transaction in expenseTransactions.take(10)) {
        transactionData.write(
          '- ${transaction.date.toIso8601String().split('T')[0]}: \$${transaction.amount.toStringAsFixed(2)} (${transaction.category})\n',
        );
      }
      transactionData.write('\n');
    }

    transactionData.write(
      'Monthly Income: \$${monthlyIncome.toStringAsFixed(2)}\n',
    );
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

    final url = Uri.parse(
      '$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } catch (e) {
        return 'Sorry, I couldn\'t generate personalized advice. This is a premium feature that uses AI to provide tailored financial guidance.';
      }
    } else {
      return 'Sorry, I\'m having trouble connecting to the AI service. Please try again later.';
    }
  }
}
