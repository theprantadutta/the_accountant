import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/analytics_service.dart';

/// Asks for a store rating, once someone has really used the app.
///
/// The app had no ratings at all, so its store listing showed no stars, and
/// nothing ever asked. This asks only after [minTransactions] entries over at
/// least [minDays] days, and at most once per [cooldown]. It never asks
/// whether the person likes the app first, and never rewards a rating: both
/// are against store policy. The store decides whether its dialog appears.
class ReviewPromptService {
  ReviewPromptService({InAppReview? review, DateTime Function()? clock})
    : _review = review ?? InAppReview.instance,
      _now = clock ?? DateTime.now;

  final InAppReview _review;
  final DateTime Function() _now;

  static const minTransactions = 10;
  static const minDays = 5;
  static const cooldown = Duration(days: 120);

  static const _countKey = 'review_prompt_transactions';
  static const _firstSeenKey = 'review_prompt_first_seen_at';
  static const _lastAskedKey = 'review_prompt_last_asked_at';

  /// The App Store id, which iOS needs to open the listing.
  static const appStoreId = '6794265000';

  /// Counts a newly recorded transaction and asks for a rating when due.
  Future<void> onTransactionRecorded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = _now();
      final count = (prefs.getInt(_countKey) ?? 0) + 1;
      await prefs.setInt(_countKey, count);
      final firstSeen = prefs.getInt(_firstSeenKey);
      if (firstSeen == null) {
        await prefs.setInt(_firstSeenKey, now.millisecondsSinceEpoch);
      }
      if (!isDue(
        transactions: count,
        firstSeen: firstSeen == null
            ? now
            : DateTime.fromMillisecondsSinceEpoch(firstSeen),
        lastAsked: _read(prefs, _lastAskedKey),
        now: now,
      )) {
        return;
      }
      if (!await _review.isAvailable()) return;
      await prefs.setInt(_lastAskedKey, now.millisecondsSinceEpoch);
      // Let the saved entry settle on screen before the store sheet rises.
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      await _review.requestReview();
      AnalyticsService().logReviewPromptRequested(count);
    } catch (e) {
      debugPrint('Review prompt skipped: $e');
    }
  }

  /// Opens the app's store page, for the Settings row.
  Future<void> openStoreListing() =>
      _review.openStoreListing(appStoreId: appStoreId);

  @visibleForTesting
  static bool isDue({
    required int transactions,
    required DateTime firstSeen,
    required DateTime? lastAsked,
    required DateTime now,
  }) {
    if (transactions < minTransactions) return false;
    if (now.difference(firstSeen) < const Duration(days: minDays)) {
      return false;
    }
    if (lastAsked != null && now.difference(lastAsked) < cooldown) {
      return false;
    }
    return true;
  }

  static DateTime? _read(SharedPreferences prefs, String key) {
    final ms = prefs.getInt(key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }
}
