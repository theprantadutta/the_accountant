import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether balances and totals are hidden, for when someone can see the
/// screen: at work, on a bus, across a table.
///
/// Hidden unless the user says otherwise, and it stays as they last left it,
/// whether they flipped the eye on Today or the switch in settings. Only
/// balances and totals hide; a single transaction's amount stays, so the
/// lists can still be used with amounts hidden.
class PrivacyState {
  const PrivacyState({this.hideAmounts = true, this.tapToReveal = true});

  final bool hideAmounts;

  /// Whether tapping a hidden amount shows them all, rather than only the eye.
  final bool tapToReveal;

  PrivacyState copyWith({bool? hideAmounts, bool? tapToReveal}) => PrivacyState(
    hideAmounts: hideAmounts ?? this.hideAmounts,
    tapToReveal: tapToReveal ?? this.tapToReveal,
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

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    state = PrivacyState(
      hideAmounts: prefs.getBool(hideKey) ?? true,
      tapToReveal: prefs.getBool(tapKey) ?? true,
    );
  }

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
}

final privacyProvider = StateNotifierProvider<PrivacyNotifier, PrivacyState>(
  (ref) => PrivacyNotifier(),
);

/// Shorthand for the one thing most widgets need to know.
final amountsHiddenProvider = Provider<bool>(
  (ref) => ref.watch(privacyProvider).hideAmounts,
);
