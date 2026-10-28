import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The period the Stats screen shows: 0 week, 1 month, 2 year.
///
/// Month unless the user picks another, and kept on this device so Stats opens
/// on the period they last looked at. Only the period is kept; the spending,
/// income and categories view always starts on spending. The reports follow
/// this, so changing it (or loading the saved one) reloads them.
class StatsPeriodNotifier extends StateNotifier<int> {
  StatsPeriodNotifier() : super(month) {
    _load();
  }

  static const String prefKey = 'stats_period';
  static const int week = 0;
  static const int month = 1;
  static const int year = 2;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(prefKey);
    if (mounted && saved != null && saved >= week && saved <= year) {
      state = saved;
    }
  }

  Future<void> set(int period) async {
    if (period < week || period > year || period == state) return;
    state = period;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefKey, period);
  }
}

final statsPeriodProvider = StateNotifierProvider<StatsPeriodNotifier, int>(
  (ref) => StatsPeriodNotifier(),
);
