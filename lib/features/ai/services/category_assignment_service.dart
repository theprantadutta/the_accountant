import 'package:flutter/foundation.dart';

class CategoryAssignmentService {
  // Predefined keywords for each category
  static final Map<String, List<String>> _categoryKeywords = {
    'Food & Dining': [
      'restaurant',
      'cafe',
      'coffee',
      'meal',
      'dinner',
      'lunch',
      'breakfast',
      'food',
      'grocery',
      'supermarket',
      'groceries',
      'dining',
      'eat',
      'burger',
      'pizza',
      'sandwich',
      'starbucks',
      'mcdonalds',
      'subway',
      'kfc',
      'taco bell',
    ],
    'Transportation': [
      'gas',
      'fuel',
      'petrol',
      'diesel',
      'uber',
      'lyft',
      'taxi',
      'bus',
      'train',
      'subway',
      'metro',
      'flight',
      'airline',
      'parking',
      'toll',
      'car',
      'vehicle',
      'maintenance',
      'repair',
      'uber technologies',
      'lyft inc',
    ],
    'Shopping': [
      'mall',
      'store',
      'shop',
      'clothing',
      'apparel',
      'fashion',
      'electronics',
      'amazon',
      'ebay',
      'walmart',
      'target',
      'best buy',
      'h&m',
      'zara',
      'uniqlo',
      'nike',
      'adidas',
      'purchase',
      'buy',
      'retail',
    ],
    'Entertainment': [
      'movie',
      'cinema',
      'theater',
      'concert',
      'music',
      'streaming',
      'netflix',
      'spotify',
      'hulu',
      'disney',
      'gaming',
      'game',
      'playstation',
      'xbox',
      'nintendo',
      'ticket',
      'amc',
      'cinemark',
      'regal',
    ],
    'Utilities': [
      'electric',
      'electricity',
      'water',
      'gas',
      'internet',
      'wifi',
      'cable',
      'phone',
      'mobile',
      'cellular',
      'insurance',
      'premium',
      'bill',
      'utility',
    ],
    'Healthcare': [
      'doctor',
      'hospital',
      'clinic',
      'pharmacy',
      'medicine',
      'drug',
      'health',
      'medical',
      'dentist',
      'dental',
      'vision',
      'gym',
      'fitness',
      'workout',
    ],
    'Travel': [
      'hotel',
      'motel',
      'airbnb',
      'booking',
      'expedia',
      'travel',
      'vacation',
      'trip',
      'flight',
      'airline',
      'cruise',
      'rental',
      'car rental',
    ],
    'Education': [
      'school',
      'college',
      'university',
      'tuition',
      'books',
      'course',
      'class',
      'education',
      'learning',
      'student',
      'textbook',
    ],
    'Personal Care': [
      'hair',
      'salon',
      'barber',
      'spa',
      'massage',
      'beauty',
      'cosmetics',
      'skincare',
      'makeup',
      'nail',
      'grooming',
    ],
    'Subscriptions': [
      'subscription',
      'monthly',
      'yearly',
      'annual',
      'recurring',
      'membership',
      'netflix',
      'spotify',
      'hulu',
      'disney',
      'hbo',
      'prime',
      'apple music',
      'youtube',
      'adobe',
      'microsoft',
      'office',
      'zoom',
      'slack',
    ],
  };

  /// Assign a category to a transaction based on its description
  String assignCategory(String description) {
    try {
      // Convert description to lowercase for case-insensitive matching
      final lowerDescription = description.toLowerCase();

      // Keep track of match scores for each category
      final categoryScores = <String, int>{};

      // Calculate scores for each category based on keyword matches
      _categoryKeywords.forEach((category, keywords) {
        int score = 0;
        for (final keyword in keywords) {
          if (lowerDescription.contains(keyword)) {
            score++;
          }
        }
        categoryScores[category] = score;
      });

      // Find the category with the highest score
      String bestCategory = 'Other'; // Default category
      int highestScore = 0;

      categoryScores.forEach((category, score) {
        if (score > highestScore) {
          highestScore = score;
          bestCategory = category;
        }
      });

      // Only assign a category if we have at least one keyword match
      return highestScore > 0 ? bestCategory : 'Other';
    } catch (e) {
      debugPrint('Error assigning category: $e');
      return 'Other';
    }
  }

  /// Get category suggestions for a transaction description
  List<String> getSuggestions(String description, {int limit = 3}) {
    try {
      // Convert description to lowercase for case-insensitive matching
      final lowerDescription = description.toLowerCase();

      // Keep track of match scores for each category
      final categoryScores = <String, int>{};

      // Calculate scores for each category based on keyword matches
      _categoryKeywords.forEach((category, keywords) {
        int score = 0;
        for (final keyword in keywords) {
          if (lowerDescription.contains(keyword)) {
            score++;
          }
        }
        categoryScores[category] = score;
      });

      // Sort categories by score and return top suggestions
      final sortedCategories = categoryScores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedCategories
          .take(limit)
          .where(
            (entry) => entry.value > 0,
          ) // Only include categories with matches
          .map((entry) => entry.key)
          .toList();
    } catch (e) {
      debugPrint('Error getting category suggestions: $e');
      return ['Other'];
    }
  }

  /// Add custom keywords for a category
  void addCustomKeywords(String category, List<String> keywords) {
    try {
      if (_categoryKeywords.containsKey(category)) {
        _categoryKeywords[category] = [
          ...?_categoryKeywords[category],
          ...keywords,
        ];
      } else {
        _categoryKeywords[category] = keywords;
      }
    } catch (e) {
      debugPrint('Error adding custom keywords: $e');
    }
  }

  /// Get all available categories
  List<String> getAvailableCategories() {
    return _categoryKeywords.keys.toList();
  }
}
