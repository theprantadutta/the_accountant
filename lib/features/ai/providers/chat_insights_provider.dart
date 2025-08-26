import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai/services/chat_insights_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

class ChatInsightsState {
  final String? insights;
  final List<String> suggestions;
  final bool isLoading;
  final String? errorMessage;

  ChatInsightsState({
    this.insights,
    this.suggestions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatInsightsState copyWith({
    String? insights,
    List<String>? suggestions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatInsightsState(
      insights: insights ?? this.insights,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChatInsightsNotifier extends StateNotifier<ChatInsightsState> {
  final ChatInsightsService _chatInsightsService;

  ChatInsightsNotifier() 
      : _chatInsightsService = ChatInsightsService(),
        super(ChatInsightsState());

  /// Generate contextual insights based on conversation history
  Future<void> generateInsights({
    required List<Map<String, dynamic>> conversationHistory,
    required List<Transaction> transactions,
    required List<Budget> budgets,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final insights = _chatInsightsService.generateContextualInsights(
        conversationHistory: conversationHistory,
        transactions: transactions,
        budgets: budgets,
      );
      
      final suggestions = _chatInsightsService.generateProactiveSuggestions(
        transactions: transactions,
        budgets: budgets,
      );
      
      state = state.copyWith(
        isLoading: false,
        insights: insights,
        suggestions: suggestions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      insights: null,
      suggestions: const [],
      isLoading: false,
      errorMessage: null,
    );
  }
}

final chatInsightsProvider = StateNotifierProvider<ChatInsightsNotifier, ChatInsightsState>((ref) {
  return ChatInsightsNotifier();
});