import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai/services/category_assignment_service.dart';

class CategoryAssignmentState {
  final bool isProcessing;
  final String? assignedCategory;
  final List<String> suggestions;
  final String? errorMessage;

  CategoryAssignmentState({
    this.isProcessing = false,
    this.assignedCategory,
    this.suggestions = const [],
    this.errorMessage,
  });

  CategoryAssignmentState copyWith({
    bool? isProcessing,
    String? assignedCategory,
    List<String>? suggestions,
    String? errorMessage,
  }) {
    return CategoryAssignmentState(
      isProcessing: isProcessing ?? this.isProcessing,
      assignedCategory: assignedCategory ?? this.assignedCategory,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CategoryAssignmentNotifier extends StateNotifier<CategoryAssignmentState> {
  final CategoryAssignmentService _categoryAssignmentService;

  CategoryAssignmentNotifier() 
      : _categoryAssignmentService = CategoryAssignmentService(), 
        super(CategoryAssignmentState());

  /// Assign a category to a transaction based on its description
  Future<void> assignCategory(String description) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final category = _categoryAssignmentService.assignCategory(description);
      
      state = state.copyWith(
        isProcessing: false,
        assignedCategory: category,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Get category suggestions for a transaction description
  Future<void> getSuggestions(String description) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final suggestions = _categoryAssignmentService.getSuggestions(description);
      
      state = state.copyWith(
        isProcessing: false,
        suggestions: suggestions,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      isProcessing: false,
      assignedCategory: null,
      suggestions: const [],
      errorMessage: null,
    );
  }
}

final categoryAssignmentProvider = StateNotifierProvider<CategoryAssignmentNotifier, CategoryAssignmentState>((ref) {
  return CategoryAssignmentNotifier();
});