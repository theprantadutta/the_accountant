import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How balances and totals look each time the app opens.
enum PrivacyStart {
  /// Hidden on every open, whatever the eye was left at.
  hidden,

  /// Shown on every open.
  shown,

  /// As the user last left them.
  remember,
}

/// Whether balances and totals are hidden, for when someone can see the
/// screen: at work, on a bus, across a table.
///
/// The user decides how the app opens: always hidden, always shown, or as
/// they left it (the default, starting hidden). The eye on Today changes it
/// for now either way. Only balances and totals hide; a single transaction's
/// amount stays, so the lists can still be used with amounts hidden.
class PrivacyState {
  const PrivacyState({
    this.hideAmounts = true,
    this.tapToReveal = true,
    this.start = PrivacyStart.remember,
  });

  final bool hideAmounts;

  /// Whether tapping a hidden amount shows them all, rather than only the eye.
  final bool tapToReveal;

  final PrivacyStart start;

  PrivacyState copyWith({
    bool? hideAmounts,
    bool? tapToReveal,
    PrivacyStart? start,
  }) => PrivacyState(
    hideAmounts: hideAmounts ?? this.hideAmounts,
    tapToReveal: tapToReveal ?? this.tapToReveal,
    start: start ?? this.start,
  );
}

class PrivacyNotifier extends StateNotifier<PrivacyState> {
  // Starts hidden, so nothing flashes on screen before the saved choice is
  // read.
  PrivacyNotifier() : super(const PrivacyState()) {
    _load();
  }

  static const String hideKey = 'privacy_hide_amounts';
  static const String tapKey = 'privacy_tap_to_reveal';
  static const String startKey = 'privacy_start';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final start = PrivacyStart.values.firstWhere(
      (s) => s.name == prefs.getString(startKey),
      orElse: () => PrivacyStart.remember,
    );
    state = PrivacyState(
      hideAmounts: switch (start) {
        PrivacyStart.hidden => true,
        PrivacyStart.shown => false,
        PrivacyStart.remember => prefs.getBool(hideKey) ?? true,
      },
      tapToReveal: prefs.getBool(tapKey) ?? true,
      start: start,
    );
  }

  /// Hide or show them now. Kept for next time only when the app opens as
  /// it was left.
  Future<void> setHidden(bool hidden) async {
    state = state.copyWith(hideAmounts: hidden);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hideKey, hidden);
  }

  Future<void> toggle() => setHidden(!state.hideAmounts);

  Future<void> setTapToReveal(bool on) async {
    state = state.copyWith(tapToReveal: on);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tapKey, on);
  }

  /// How the app opens from now on. Choosing hidden or shown applies now as
  /// well, so the choice is seen to take effect.
  Future<void> setStart(PrivacyStart start) async {
    state = state.copyWith(
      start: start,
      hideAmounts: switch (start) {
        PrivacyStart.hidden => true,
        PrivacyStart.shown => false,
        PrivacyStart.remember => state.hideAmounts,
      },
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(startKey, start.name);
    await prefs.setBool(hideKey, state.hideAmounts);
  }
}

final privacyProvider = StateNotifierProvider<PrivacyNotifier, PrivacyState>(
  (ref) => PrivacyNotifier(),
);

/// Shorthand for the one thing most widgets need to know.
final amountsHiddenProvider = Provider<bool>(
  (ref) => ref.watch(privacyProvider).hideAmounts,
);
