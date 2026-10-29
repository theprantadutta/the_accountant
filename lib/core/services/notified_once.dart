import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// What this phone has already told the user about, so a reminder is posted
/// once rather than on every check.
///
/// The background task runs every hour and the app checks on every start; the
/// reminders they post used to have no memory between runs, so something due
/// tomorrow was announced about twenty times and an overdue loan every hour.
///
/// SharedPreferences because the background isolate and the app both write
/// here; each has its own cached copy, so every read reloads first.
class NotifiedOnce {
  NotifiedOnce._();

  static const String storageKey = 'notified_once_v1';

  /// Older marks are dropped; nothing is reminded about that long after.
  static const Duration _keepFor = Duration(days: 60);

  /// Whether [key] may be told about now, and if so marks it told.
  ///
  /// Once only, unless [every] is given: then again once that long has passed
  /// since the last time.
  static Future<bool> claim(
    String key, {
    Duration? every,
    SharedPreferences? prefs,
    DateTime? now,
  }) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    await p.reload();
    final at = now ?? DateTime.now();
    final marks = _read(p)
      ..removeWhere((_, told) => at.difference(told) > _keepFor);

    final last = marks[key];
    final due = last == null || (every != null && at.difference(last) >= every);
    if (due) marks[key] = at;
    await p.setString(storageKey, jsonEncode(_encode(marks)));
    return due;
  }

  static Map<String, DateTime> _read(SharedPreferences p) {
    final raw = p.getString(storageKey);
    if (raw == null) return {};
    try {
      return {
        for (final e in (jsonDecode(raw) as Map<String, dynamic>).entries)
          e.key: ?DateTime.tryParse(e.value as String),
      };
    } catch (_) {
      return {};
    }
  }

  static Map<String, String> _encode(Map<String, DateTime> marks) => {
    for (final e in marks.entries) e.key: e.value.toIso8601String(),
  };

  /// A day as yyyy-MM-dd, for keys that are once per due date.
  static String day(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
