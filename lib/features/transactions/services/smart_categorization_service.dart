import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for smart categorization of transactions
/// Learns from user behavior and suggests categories based on transaction titles
class SmartCategorizationService {
  final AppDatabase _database;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  SmartCategorizationService({required AppDatabase database})
    : _database = database;

  /// Suggest a category based on the transaction title
  /// Returns null if no suggestion is found
  Future<CategorySuggestion?> suggestCategory(String title) async {
    if (title.isEmpty) return null;

    final normalizedTitle = title.toLowerCase().trim();

    // 1. First, check for exact matches
    final exactMatch = await _database.findExactTitleMatch(normalizedTitle);
    if (exactMatch != null) {
      final category = await _database.findCategoryById(exactMatch.categoryId);
      if (category != null && category.deletedAt == null) {
        _logger.d('Found exact match for "$title" -> ${category.name}');
        return CategorySuggestion(
          category: category,
          confidence: CategorySuggestionConfidence.exact,
          matchedTitle: exactMatch.title,
        );
      }
    }

    // 2. Check for contains matches
    final containsMatches = await _database.findContainsTitleMatches();
    for (final match in containsMatches) {
      if (normalizedTitle.contains(match.title.toLowerCase())) {
        final category = await _database.findCategoryById(match.categoryId);
        if (category != null && category.deletedAt == null) {
          _logger.d('Found contains match for "$title" -> ${category.name}');
          return CategorySuggestion(
            category: category,
            confidence: CategorySuggestionConfidence.contains,
            matchedTitle: match.title,
          );
        }
      }
    }

    // 3. Check for keyword matches in existing transactions
    final keywordSuggestion = await _suggestFromTransactionHistory(
      normalizedTitle,
    );
    if (keywordSuggestion != null) {
      return keywordSuggestion;
    }

    _logger.d('No category suggestion found for "$title"');
    return null;
  }

  /// Suggest a category based on similar transaction titles in history
  Future<CategorySuggestion?> _suggestFromTransactionHistory(
    String title,
  ) async {
    // Get all transactions and their categories
    final transactions = await _database.getAllTransactions();

    // Build a map of category -> count for similar titles
    final categoryScores = <String, int>{};
    final categoryNames = <String, Category>{};

    for (final transaction in transactions) {
      if (transaction.categoryId != null &&
          transaction.title.isNotEmpty &&
          transaction.deletedAt == null) {
        // Check if titles are similar
        final transactionTitle = transaction.title.toLowerCase();
        if (_isSimilar(title, transactionTitle)) {
          final categoryId = transaction.categoryId!;
          categoryScores[categoryId] = (categoryScores[categoryId] ?? 0) + 1;

          if (!categoryNames.containsKey(categoryId)) {
            final category = await _database.findCategoryById(categoryId);
            if (category != null && category.deletedAt == null) {
              categoryNames[categoryId] = category;
            }
          }
        }
      }
    }

    // Find the category with the highest score
    if (categoryScores.isNotEmpty) {
      final bestMatch = categoryScores.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );

      if (bestMatch.value >= 2) {
        // Require at least 2 matches
        final category = categoryNames[bestMatch.key];
        if (category != null) {
          _logger.d(
            'Found history match for "$title" -> ${category.name} (score: ${bestMatch.value})',
          );
          return CategorySuggestion(
            category: category,
            confidence: CategorySuggestionConfidence.history,
            matchedTitle: null,
          );
        }
      }
    }

    return null;
  }

  /// Check if two titles are similar
  bool _isSimilar(String title1, String title2) {
    // Exact match
    if (title1 == title2) return true;

    // One contains the other
    if (title1.contains(title2) || title2.contains(title1)) return true;

    // Check for common words
    final words1 = title1
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toSet();
    final words2 = title2
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toSet();

    if (words1.isEmpty || words2.isEmpty) return false;

    final commonWords = words1.intersection(words2);
    final similarity =
        commonWords.length / words1.length.clamp(1, double.infinity);

    return similarity >= 0.5; // At least 50% common words
  }

  /// Learn from a transaction (associate title with category)
  Future<void> learnFromTransaction(Transaction transaction) async {
    if (transaction.categoryId == null || transaction.title.isEmpty) {
      return;
    }

    final normalizedTitle = transaction.title.toLowerCase().trim();

    // Check if this title already exists
    final existing = await _database.findExactTitleMatch(normalizedTitle);
    if (existing != null) {
      // Update if category changed
      if (existing.categoryId != transaction.categoryId) {
        await (_database.update(
          _database.associatedTitles,
        )..where((a) => a.id.equals(existing.id))).write(
          AssociatedTitlesCompanion(
            categoryId: Value(transaction.categoryId!),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );
        _logger.d(
          'Updated title association: "$normalizedTitle" -> ${transaction.categoryId}',
        );
      }
      return;
    }

    // Create new association
    final id = _uuid.v4();
    await _database.addAssociatedTitle(
      AssociatedTitlesCompanion(
        id: Value(id),
        title: Value(normalizedTitle),
        categoryId: Value(transaction.categoryId!),
        isExactMatch: const Value(true),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    _logger.d(
      'Created title association: "$normalizedTitle" -> ${transaction.categoryId}',
    );
  }

  /// Add a manual title association
  Future<String> addTitleAssociation({
    required String title,
    required String categoryId,
    bool isExactMatch = false,
  }) async {
    final normalizedTitle = title.toLowerCase().trim();
    final id = _uuid.v4();

    // Check if already exists
    final existing = await (_database.select(
      _database.associatedTitles,
    )..where((a) => a.title.equals(normalizedTitle))).getSingleOrNull();

    if (existing != null) {
      // Update existing
      await (_database.update(
        _database.associatedTitles,
      )..where((a) => a.id.equals(existing.id))).write(
        AssociatedTitlesCompanion(
          categoryId: Value(categoryId),
          isExactMatch: Value(isExactMatch),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return existing.id;
    }

    // Create new
    await _database.addAssociatedTitle(
      AssociatedTitlesCompanion(
        id: Value(id),
        title: Value(normalizedTitle),
        categoryId: Value(categoryId),
        isExactMatch: Value(isExactMatch),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return id;
  }

  /// Remove a title association
  Future<void> removeTitleAssociation(String id) async {
    await _database.deleteAssociatedTitle(id);
    _logger.d('Removed title association: $id');
  }

  /// Get all title associations for a category
  Future<List<AssociatedTitle>> getAssociationsForCategory(
    String categoryId,
  ) async {
    return await _database.getAssociatedTitlesForCategory(categoryId);
  }

  /// Get all title associations
  Future<List<AssociatedTitle>> getAllAssociations() async {
    return await _database.getAllAssociatedTitles();
  }

  /// Extract keywords from a title for pattern learning
  List<String> extractKeywords(String title) {
    return title
        .toLowerCase()
        .split(RegExp(r'[\s\-_.,;:!?()]+'))
        .where((word) => word.length > 2)
        .toSet()
        .toList();
  }
}

/// Result of a category suggestion
class CategorySuggestion {
  final Category category;
  final CategorySuggestionConfidence confidence;
  final String? matchedTitle;

  CategorySuggestion({
    required this.category,
    required this.confidence,
    this.matchedTitle,
  });

  /// Get a human-readable explanation of the suggestion
  String get explanation {
    switch (confidence) {
      case CategorySuggestionConfidence.exact:
        return 'Exact match: "$matchedTitle"';
      case CategorySuggestionConfidence.contains:
        return 'Contains: "$matchedTitle"';
      case CategorySuggestionConfidence.history:
        return 'Based on similar transactions';
    }
  }

  /// Get confidence as a percentage (for UI display)
  int get confidencePercent {
    switch (confidence) {
      case CategorySuggestionConfidence.exact:
        return 100;
      case CategorySuggestionConfidence.contains:
        return 80;
      case CategorySuggestionConfidence.history:
        return 60;
    }
  }
}

/// Confidence level of a category suggestion
enum CategorySuggestionConfidence {
  exact, // Title matches exactly
  contains, // Title contains the pattern
  history, // Based on transaction history
}
