import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai/services/nlp_service.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';

class NLPState {
  final String? response;
  final bool isLoading;
  final String? errorMessage;

  NLPState({this.response, this.isLoading = false, this.errorMessage});

  NLPState copyWith({String? response, bool? isLoading, String? errorMessage}) {
    return NLPState(
      response: response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class NLPNotifier extends StateNotifier<NLPState> {
  final NLPService _nlpService;

  NLPNotifier() : _nlpService = NLPService(), super(NLPState());

  /// Process a natural language query
  Future<void> processQuery(
    String query,
    List<Transaction> transactions,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Parse the query to understand intent
      final intent = _nlpService.parseQuery(query);

      // Generate a response based on the intent and transaction data
      final response = _nlpService.generateResponse(intent, transactions);

      state = state.copyWith(isLoading: false, response: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      response: null,
      isLoading: false,
      errorMessage: null,
    );
  }
}

final nlpProvider = StateNotifierProvider<NLPNotifier, NLPState>((ref) {
  return NLPNotifier();
});
