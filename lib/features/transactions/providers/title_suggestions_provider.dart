import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// Model for title suggestions
class TitleSuggestion {
  final String title;
  final String? categoryId;
  final String? categoryName;
  final String? categoryColor;
  final int useCount;

  const TitleSuggestion({
    required this.title,
    this.categoryId,
    this.categoryName,
    this.categoryColor,
    this.useCount = 1,
  });
}

/// State for title suggestions
class TitleSuggestionsState {
  final List<TitleSuggestion> recentTitles;
  final List<TitleSuggestion> searchResults;
  final bool isLoading;
  final String? error;

  const TitleSuggestionsState({
    this.recentTitles = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
  });

  TitleSuggestionsState copyWith({
    List<TitleSuggestion>? recentTitles,
    List<TitleSuggestion>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return TitleSuggestionsState(
      recentTitles: recentTitles ?? this.recentTitles,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing title suggestions
class TitleSuggestionsNotifier extends StateNotifier<TitleSuggestionsState> {
  final AppDatabase _db;

  TitleSuggestionsNotifier(this._db) : super(const TitleSuggestionsState()) {
    loadRecentTitles();
  }

  /// Load recent unique titles from transaction history
  Future<void> loadRecentTitles() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Get all transactions with category info
      final transactions = await _db.getAllTransactionsWithCategoryName();

      // Extract unique titles with their associated categories
      final titleMap = <String, TitleSuggestion>{};

      for (final txn in transactions) {
        final transaction = txn['transaction'] as Transaction;
        final title = transaction.title;
        if (title.isNotEmpty) {
          final lowerTitle = title.toLowerCase();
          if (titleMap.containsKey(lowerTitle)) {
            // Increment use count
            final existing = titleMap[lowerTitle]!;
            titleMap[lowerTitle] = TitleSuggestion(
              title: existing.title,
              categoryId: existing.categoryId,
              categoryName: existing.categoryName,
              categoryColor: existing.categoryColor,
              useCount: existing.useCount + 1,
            );
          } else {
            titleMap[lowerTitle] = TitleSuggestion(
              title: title,
              categoryId: transaction.categoryId,
              categoryName: txn['categoryName'] as String?,
              categoryColor: txn['categoryColor'] as String?,
              useCount: 1,
            );
          }
        }
      }

      // Sort by use count (most frequent first), then by title
      final recentTitles = titleMap.values.toList()
        ..sort((a, b) {
          final countCompare = b.useCount.compareTo(a.useCount);
          if (countCompare != 0) return countCompare;
          return a.title.compareTo(b.title);
        });

      state = state.copyWith(
        isLoading: false,
        recentTitles: recentTitles.take(20).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load recent titles: $e',
      );
    }
  }

  /// Search titles matching a query
  Future<void> searchTitles(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    final lowerQuery = query.toLowerCase();

    // First, search in associated titles for exact matches
    final associatedTitles = await _db.getAllAssociatedTitles();
    final associatedMatches = <TitleSuggestion>[];

    for (final assoc in associatedTitles) {
      if (assoc.title.toLowerCase().contains(lowerQuery)) {
        final category = await _db.findCategoryById(assoc.categoryId);
        associatedMatches.add(
          TitleSuggestion(
            title: assoc.title,
            categoryId: assoc.categoryId,
            categoryName: category?.name,
            categoryColor: category?.color,
            useCount: 100, // Higher priority for associated titles
          ),
        );
      }
    }

    // Then, filter recent titles
    final recentMatches = state.recentTitles
        .where((t) => t.title.toLowerCase().contains(lowerQuery))
        .toList();

    // Combine and deduplicate
    final allMatches = <String, TitleSuggestion>{};
    for (final match in associatedMatches) {
      allMatches[match.title.toLowerCase()] = match;
    }
    for (final match in recentMatches) {
      final key = match.title.toLowerCase();
      if (!allMatches.containsKey(key)) {
        allMatches[key] = match;
      }
    }

    // Sort by use count
    final results = allMatches.values.toList()
      ..sort((a, b) => b.useCount.compareTo(a.useCount));

    state = state.copyWith(searchResults: results.take(10).toList());
  }

  /// Get category suggestion for a specific title
  Future<CategorySuggestionResult?> getCategorySuggestion(String title) async {
    if (title.isEmpty) return null;

    // First, check for exact match in associated titles
    final exactMatch = await _db.findExactTitleMatch(title);
    if (exactMatch != null) {
      final category = await _db.findCategoryById(exactMatch.categoryId);
      if (category != null) {
        return CategorySuggestionResult(
          categoryId: category.id,
          categoryName: category.name,
          categoryColor: category.color,
          matchType: 'exact',
          confidence: 1.0,
        );
      }
    }

    // Then, check for contains matches
    final containsMatches = await _db.findContainsTitleMatches();
    for (final match in containsMatches) {
      if (title.toLowerCase().contains(match.title.toLowerCase())) {
        final category = await _db.findCategoryById(match.categoryId);
        if (category != null) {
          return CategorySuggestionResult(
            categoryId: category.id,
            categoryName: category.name,
            categoryColor: category.color,
            matchType: 'contains',
            confidence: 0.8,
          );
        }
      }
    }

    // Finally, check recent transactions with similar titles
    final lowerTitle = title.toLowerCase();
    for (final recent in state.recentTitles) {
      if (recent.title.toLowerCase() == lowerTitle &&
          recent.categoryId != null) {
        return CategorySuggestionResult(
          categoryId: recent.categoryId!,
          categoryName: recent.categoryName,
          categoryColor: recent.categoryColor,
          matchType: 'history',
          confidence: 0.6,
        );
      }
    }

    return null;
  }

  /// Add a new title association (learning from user input)
  Future<void> addTitleAssociation({
    required String title,
    required String categoryId,
    bool isExactMatch = true,
  }) async {
    try {
      // Check if already exists
      final existing = await _db.findExactTitleMatch(title);
      if (existing != null) {
        // Update existing
        await _db.updateAssociatedTitle(
          AssociatedTitlesCompanion(
            id: Value(existing.id),
            title: Value(title.toLowerCase()),
            categoryId: Value(categoryId),
            isExactMatch: Value(isExactMatch),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        // Create new
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        await _db.addAssociatedTitle(
          AssociatedTitlesCompanion(
            id: Value(id),
            title: Value(title.toLowerCase()),
            categoryId: Value(categoryId),
            isExactMatch: Value(isExactMatch),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // Refresh recent titles
      await loadRecentTitles();
    } catch (e) {
      // Silently fail - this is a learning feature
    }
  }

  /// Clear search results
  void clearSearch() {
    state = state.copyWith(searchResults: []);
  }
}

/// Result of a category suggestion
class CategorySuggestionResult {
  final String categoryId;
  final String? categoryName;
  final String? categoryColor;
  final String matchType; // 'exact', 'contains', 'history'
  final double confidence; // 0.0 - 1.0

  const CategorySuggestionResult({
    required this.categoryId,
    this.categoryName,
    this.categoryColor,
    required this.matchType,
    required this.confidence,
  });
}

/// Provider for title suggestions
final titleSuggestionsProvider =
    StateNotifierProvider<TitleSuggestionsNotifier, TitleSuggestionsState>((
      ref,
    ) {
      final db = ref.watch(databaseProvider);
      return TitleSuggestionsNotifier(db);
    });
