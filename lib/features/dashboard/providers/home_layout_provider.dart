import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/features/dashboard/domain/home_layout.dart';

/// The user's home-screen arrangement, remembered between launches.
///
/// Local-only, like the theme: it describes how this device draws the app, not
/// anything about the user's money, so it has no business in sync.
class HomeLayoutNotifier extends StateNotifier<HomeLayout> {
  HomeLayoutNotifier() : super(HomeLayout.initial) {
    _restore();
  }

  static const String _storageKey = 'home_layout';

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = HomeLayout.decode(prefs.getString(_storageKey));
    } catch (_) {
      // A preferences store that will not open is not a reason to fail to
      // draw the home screen; the default arrangement is a fine answer.
    }
  }

  Future<void> toggle(HomeSection section) => _write(state.toggle(section));

  Future<void> move(int from, int to) => _write(state.move(from, to));

  Future<void> resetToDefault() => _write(HomeLayout.initial);

  Future<void> _write(HomeLayout next) async {
    state = next;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, next.encode());
    } catch (_) {
      // Losing the arrangement is not worth interrupting the user for.
    }
  }
}

final homeLayoutProvider =
    StateNotifierProvider<HomeLayoutNotifier, HomeLayout>(
      (ref) => HomeLayoutNotifier(),
    );
