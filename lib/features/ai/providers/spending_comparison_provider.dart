import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai/services/spending_comparison_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class SpendingComparisonState {
  final SpendingComparison? comparison;
  final bool isLoading;
  final String? errorMessage;
  final String? aiInsights;

  SpendingComparisonState({
    this.comparison,
    this.isLoading = false,
    this.errorMessage,
    this.aiInsights,
  });

  SpendingComparisonState copyWith({
    SpendingComparison? comparison,
    bool? isLoading,
    String? errorMessage,
    String? aiInsights,
  }) {
    return SpendingComparisonState(
      comparison: comparison ?? this.comparison,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      aiInsights: aiInsights ?? this.aiInsights,
    );
  }
}

class SpendingComparisonNotifier
    extends StateNotifier<SpendingComparisonState> {
  final SpendingComparisonService _spendingComparisonService;

  SpendingComparisonNotifier()
    : _spendingComparisonService = SpendingComparisonService(),
      super(SpendingComparisonState());

  /// Compare spending between two periods
  Future<void> comparePeriods({
    required List<Transaction> transactions,
    required DateTime period1Start,
    required DateTime period1End,
    required DateTime period2Start,
    required DateTime period2End,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final comparison = _spendingComparisonService.comparePeriods(
        transactions: transactions,
        period1Start: period1Start,
        period1End: period1End,
        period2Start: period2Start,
        period2End: period2End,
      );

      final insights = _spendingComparisonService.generateAIInsights(
        comparison,
      );

      state = state.copyWith(
        isLoading: false,
        comparison: comparison,
        aiInsights: insights,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      comparison: null,
      isLoading: false,
      errorMessage: null,
      aiInsights: null,
    );
  }
}

final spendingComparisonProvider =
    StateNotifierProvider<SpendingComparisonNotifier, SpendingComparisonState>((
      ref,
    ) {
      return SpendingComparisonNotifier();
    });
