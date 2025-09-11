import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai_assistant/services/gemini_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/ai/services/nlp_service.dart';
import 'package:the_accountant/features/ai/services/chat_insights_service.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final aiAssistantProvider =
    StateNotifierProvider<AIAssistantNotifier, AIAssistantState>((ref) {
      final geminiService = ref.watch(geminiServiceProvider);
      return AIAssistantNotifier(geminiService);
    });

class AIAssistantState {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  final String error;

  AIAssistantState({
    required this.messages,
    required this.isLoading,
    required this.error,
  });

  AIAssistantState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AIAssistantState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AIAssistantNotifier extends StateNotifier<AIAssistantState> {
  final GeminiService _geminiService;

  AIAssistantNotifier(this._geminiService)
    : super(
        AIAssistantState(
          messages: [
            {
              'text':
                  'Hello! I\'m your financial assistant. How can I help you today?',
              'isUser': false,
              'timestamp': DateTime.now(),
            },
          ],
          isLoading: false,
          error: '',
        ),
      );

  Future<void> sendMessage(
    String message, {
    List<Transaction>? transactions,
    List<Budget>? budgets,
  }) async {
    if (message.trim().isEmpty) return;

    // Add user message
    state = state.copyWith(
      messages: [
        ...state.messages,
        {'text': message, 'isUser': true, 'timestamp': DateTime.now()},
      ],
      isLoading: true,
      error: '',
    );

    try {
      String response;

      // If transactions and budgets are provided, try to process with NLP first
      if (transactions != null && budgets != null && _shouldUseNLP(message)) {
        // Use NLP service for simple financial queries
        final nlpResponse = await _processWithNLP(message, transactions);
        response = nlpResponse;
      } else {
        // Use Gemini for complex queries
        response = await _geminiService.generateFinancialInsight(message);
      }

      // Add AI response
      state = state.copyWith(
        messages: [
          ...state.messages,
          {'text': response, 'isUser': false, 'timestamp': DateTime.now()},
        ],
        isLoading: false,
      );

      // Generate contextual insights after each response
      if (transactions != null && budgets != null) {
        _generateContextualInsights(transactions, budgets);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get response from AI assistant',
      );
    }
  }

  /// Generate detailed financial insights from transaction data
  Future<void> generateFinancialInsights(List<Transaction> transactions) async {
    state = state.copyWith(isLoading: true, error: '');

    try {
      final insights = await _geminiService
          .generateFinancialInsightsFromTransactions(transactions);

      state = state.copyWith(
        messages: [
          ...state.messages,
          {
            'text': insights,
            'isUser': false,
            'timestamp': DateTime.now(),
            'isInsight': true,
          },
        ],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate financial insights',
      );
    }
  }

  /// Generate personalized financial advice
  Future<void> generatePersonalizedAdvice({
    required List<Transaction> transactions,
    required double monthlyIncome,
    required List<String> financialGoals,
  }) async {
    state = state.copyWith(isLoading: true, error: '');

    try {
      final advice = await _geminiService.generatePersonalizedAdvice(
        transactions: transactions,
        monthlyIncome: monthlyIncome,
        financialGoals: financialGoals,
      );

      state = state.copyWith(
        messages: [
          ...state.messages,
          {
            'text': advice,
            'isUser': false,
            'timestamp': DateTime.now(),
            'isInsight': true,
          },
        ],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate personalized advice',
      );
    }
  }

  /// Generate contextual insights and add them to the conversation
  void _generateContextualInsights(
    List<Transaction> transactions,
    List<Budget> budgets,
  ) async {
    try {
      final chatInsightsService = ChatInsightsService();

      // Generate insights based on conversation history
      final insights = chatInsightsService.generateContextualInsights(
        conversationHistory: state.messages,
        transactions: transactions,
        budgets: budgets,
      );

      // If we have insights, add them to the conversation
      if (insights.isNotEmpty) {
        state = state.copyWith(
          messages: [
            ...state.messages,
            {
              'text': insights,
              'isUser': false,
              'timestamp': DateTime.now(),
              'isInsight': true, // Flag to indicate this is an insight
            },
          ],
        );
      }

      // Generate proactive suggestions
      final suggestions = chatInsightsService.generateProactiveSuggestions(
        transactions: transactions,
        budgets: budgets,
      );

      // If we have suggestions, add them to the conversation
      if (suggestions.isNotEmpty) {
        final suggestionText =
            '💡 Pro Tips:\n${suggestions.map((s) => '• $s').join('\n')}';

        state = state.copyWith(
          messages: [
            ...state.messages,
            {
              'text': suggestionText,
              'isUser': false,
              'timestamp': DateTime.now(),
              'isSuggestion': true, // Flag to indicate this is a suggestion
            },
          ],
        );
      }
    } catch (e) {
      // Silently ignore insight generation errors
      debugPrint('Error generating contextual insights: $e');
    }
  }

  /// Determine if we should use NLP for this query
  bool _shouldUseNLP(String message) {
    final lowerMessage = message.toLowerCase();

    // Use NLP for simple financial queries
    final nlpKeywords = [
      'how much did i spend',
      'what did i spend on',
      'how much did i earn',
      'what is my income',
      'how much have i saved',
      'am i saving',
      'budget for',
      'spent on',
      'income from',
      'total expenses',
      'total income',
      'savings rate',
    ];

    for (final keyword in nlpKeywords) {
      if (lowerMessage.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  /// Process message with NLP service
  Future<String> _processWithNLP(
    String message,
    List<Transaction> transactions,
  ) async {
    // In a real implementation, we would use a ref to access the NLP provider
    // For now, we'll create a temporary instance
    final nlpService = NLPService();

    // Parse the query to understand intent
    final intent = nlpService.parseQuery(message);

    // Generate a response based on the intent and transaction data
    final response = nlpService.generateResponse(intent, transactions);

    return response;
  }

  /// Clear the conversation
  void clearConversation() {
    state = AIAssistantState(
      messages: [
        {
          'text':
              'Hello! I\'m your financial assistant. How can I help you today?',
          'isUser': false,
          'timestamp': DateTime.now(),
        },
      ],
      isLoading: false,
      error: '',
    );
  }
}
