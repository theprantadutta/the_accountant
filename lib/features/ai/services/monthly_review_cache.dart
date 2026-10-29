import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// The last monthly review written for a month, and what it was written from.
///
/// A review is an AI call, so one written from figures that have not changed
/// since is shown again rather than asked for again. "Changed" is judged by
/// the transactions: any added, edited or deleted moves the fingerprint, and
/// so does a change of language or currency, which the review is written in.
class MonthlyReviewCache {
  const MonthlyReviewCache._();

  static const String _prefix = 'monthly_review_v1_';

  /// What the transactions look like now, in one line.
  static Future<String> fingerprint(
    AppDatabase db, {
    required DateTime month,
    required String language,
    required String currency,
  }) async {
    final row = await db
        .customSelect(
          'SELECT COUNT(*) AS n, MAX(updated_at) AS changed FROM transactions',
        )
        .getSingle();
    return [
      _monthKey(month),
      row.read<int>('n'),
      row.readNullable<int>('changed') ?? 0,
      language,
      currency,
    ].join('|');
  }

  /// The saved review for [month] and whether it is still up to date with
  /// [current]; null when none was ever written.
  static Future<({String text, bool upToDate})?> read(
    DateTime month,
    String current,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix${_monthKey(month)}');
    if (raw == null) return null;
    try {
      final saved = jsonDecode(raw) as Map<String, dynamic>;
      final text = saved['text'] as String;
      return (text: text, upToDate: saved['fp'] == current);
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(DateTime month, String fp, String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix${_monthKey(month)}',
      jsonEncode({'fp': fp, 'text': text}),
    );
  }

  static String _monthKey(DateTime m) =>
      '${m.year}-${m.month.toString().padLeft(2, '0')}';
}
