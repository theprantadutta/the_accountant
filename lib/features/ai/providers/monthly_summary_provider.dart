import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai/services/monthly_summary_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class MonthlySummaryState {
  final MonthlySummary? summary;
  final bool isLoading;
  final String? errorMessage;
  final String? aiInsights;

  MonthlySummaryState({
    this.summary,
    this.isLoading = false,
    this.errorMessage,
    this.aiInsights,
  });

  MonthlySummaryState copyWith({
    MonthlySummary? summary,
    bool? isLoading,
    String? errorMessage,
    String? aiInsights,
  }) {
    return MonthlySummaryState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      aiInsights: aiInsights ?? this.aiInsights,
    );
  }
}

class MonthlySummaryNotifier extends StateNotifier<MonthlySummaryState> {
  final MonthlySummaryService _monthlySummaryService;

  MonthlySummaryNotifier()
    : _monthlySummaryService = MonthlySummaryService(),
      super(MonthlySummaryState());

  /// Generate monthly summary for a specific month
  Future<void> generateSummary({
    required List<Transaction> transactions,
    required DateTime month,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final summary = _monthlySummaryService.generateMonthlySummary(
        transactions: transactions,
        month: month,
      );

      final insights = _monthlySummaryService.generateAIInsights(summary);

      state = state.copyWith(
        isLoading: false,
        summary: summary,
        aiInsights: insights,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      summary: null,
      isLoading: false,
      errorMessage: null,
      aiInsights: null,
    );
  }
}

final monthlySummaryProvider =
    StateNotifierProvider<MonthlySummaryNotifier, MonthlySummaryState>((ref) {
      return MonthlySummaryNotifier();
    });
