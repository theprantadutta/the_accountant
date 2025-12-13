import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/smart_categorization_service.dart';

/// Provider for the SmartCategorizationService instance
final smartCategorizationServiceProvider =
    Provider<SmartCategorizationService>((ref) {
  final database = ref.watch(databaseProvider);
  return SmartCategorizationService(database: database);
});

/// Provider for category suggestion based on title
final categorySuggestionProvider =
    FutureProvider.family<CategorySuggestion?, String>((ref, title) async {
  if (title.isEmpty) return null;

  final service = ref.watch(smartCategorizationServiceProvider);
  return await service.suggestCategory(title);
});

/// Provider for all associated titles
final allAssociatedTitlesProvider =
    FutureProvider<List<AssociatedTitle>>((ref) async {
  final service = ref.watch(smartCategorizationServiceProvider);
  return await service.getAllAssociations();
});

/// State for smart categorization
class SmartCategorizationState {
  final List<AssociatedTitle> associations;
  final bool isLoading;
  final String? error;

  SmartCategorizationState({
    this.associations = const [],
    this.isLoading = false,
    this.error,
  });

  SmartCategorizationState copyWith({
    List<AssociatedTitle>? associations,
    bool? isLoading,
    String? error,
  }) {
    return SmartCategorizationState(
      associations: associations ?? this.associations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing smart categorization
class SmartCategorizationNotifier extends StateNotifier<SmartCategorizationState> {
  final Ref _ref;

  SmartCategorizationNotifier(this._ref) : super(SmartCategorizationState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    try {
      final service = _ref.read(smartCategorizationServiceProvider);
      final associations = await service.getAllAssociations();
      state = state.copyWith(associations: associations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add a title association
  Future<String> addAssociation({
    required String title,
    required String categoryId,
    bool isExactMatch = false,
  }) async {
    final service = _ref.read(smartCategorizationServiceProvider);

    final id = await service.addTitleAssociation(
      title: title,
      categoryId: categoryId,
      isExactMatch: isExactMatch,
    );

    await _load();
    return id;
  }

  /// Remove a title association
  Future<void> removeAssociation(String id) async {
    final service = _ref.read(smartCategorizationServiceProvider);
    await service.removeTitleAssociation(id);
    await _load();
  }

  /// Learn from a transaction
  Future<void> learnFromTransaction(Transaction transaction) async {
    final service = _ref.read(smartCategorizationServiceProvider);
    await service.learnFromTransaction(transaction);
    await _load();
  }

  /// Get associations for a specific category
  Future<List<AssociatedTitle>> getAssociationsForCategory(
      String categoryId) async {
    final service = _ref.read(smartCategorizationServiceProvider);
    return await service.getAssociationsForCategory(categoryId);
  }

  /// Refresh the data
  Future<void> refresh() => _load();
}

/// Provider for smart categorization notifier
final smartCategorizationNotifierProvider = StateNotifierProvider<
    SmartCategorizationNotifier, SmartCategorizationState>((ref) {
  return SmartCategorizationNotifier(ref);
});

/// Provider for associations grouped by category
final associationsByCategoryProvider =
    FutureProvider<Map<String, List<AssociatedTitle>>>((ref) async {
  final associations = await ref.watch(allAssociatedTitlesProvider.future);
  final grouped = <String, List<AssociatedTitle>>{};

  for (final association in associations) {
    grouped.putIfAbsent(association.categoryId, () => []).add(association);
  }

  return grouped;
});
