import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai_assistant/services/gemini_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class GeminiInsightsState {
  final String? insights;
  final String? personalizedAdvice;
  final bool isLoading;
  final String? errorMessage;

  GeminiInsightsState({
    this.insights,
    this.personalizedAdvice,
    this.isLoading = false,
    this.errorMessage,
  });

  GeminiInsightsState copyWith({
    String? insights,
    String? personalizedAdvice,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GeminiInsightsState(
      insights: insights ?? this.insights,
      personalizedAdvice: personalizedAdvice ?? this.personalizedAdvice,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class GeminiInsightsNotifier extends StateNotifier<GeminiInsightsState> {
  final GeminiService _geminiService;

  GeminiInsightsNotifier()
    : _geminiService = GeminiService(),
      super(GeminiInsightsState());

  /// Generate financial insights from transaction data
  Future<void> generateInsights(List<Transaction> transactions) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final insights = await _geminiService
          .generateFinancialInsightsFromTransactions(transactions);

      state = state.copyWith(isLoading: false, insights: insights);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Generate personalized financial advice
  Future<void> generatePersonalizedAdvice({
    required List<Transaction> transactions,
    required double monthlyIncome,
    required List<String> financialGoals,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final advice = await _geminiService.generatePersonalizedAdvice(
        transactions: transactions,
        monthlyIncome: monthlyIncome,
        financialGoals: financialGoals,
      );

      state = state.copyWith(isLoading: false, personalizedAdvice: advice);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      insights: null,
      personalizedAdvice: null,
      isLoading: false,
      errorMessage: null,
    );
  }
}

final geminiInsightsProvider =
    StateNotifierProvider<GeminiInsightsNotifier, GeminiInsightsState>((ref) {
      return GeminiInsightsNotifier();
    });
