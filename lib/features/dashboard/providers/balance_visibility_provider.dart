import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing balance visibility per wallet
/// Stores visibility preferences locally

class BalanceVisibilityNotifier extends StateNotifier<Map<String, bool>> {
  static const String _prefKey = 'wallet_balance_visibility';

  BalanceVisibilityNotifier() : super({}) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('$_prefKey:'));
    final Map<String, bool> visibility = {};

    for (final key in keys) {
      final walletId = key.replaceFirst('$_prefKey:', '');
      visibility[walletId] = prefs.getBool(key) ?? true;
    }

    state = visibility;
  }

  Future<void> _saveToPrefs(String walletId, bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefKey:$walletId', isVisible);
  }

  /// Check if balance is visible for a wallet (defaults to true)
  bool isVisible(String walletId) {
    return state[walletId] ?? true;
  }

  /// Toggle visibility for a specific wallet
  Future<void> toggleVisibility(String walletId) async {
    final currentVisibility = state[walletId] ?? true;
    final newVisibility = !currentVisibility;

    state = {...state, walletId: newVisibility};
    await _saveToPrefs(walletId, newVisibility);
  }

  /// Set visibility for a specific wallet
  Future<void> setVisibility(String walletId, bool isVisible) async {
    state = {...state, walletId: isVisible};
    await _saveToPrefs(walletId, isVisible);
  }

  /// Toggle visibility for all wallets at once
  Future<void> toggleAllVisibility() async {
    // If any wallet is hidden, show all. Otherwise hide all.
    final anyHidden = state.values.any((v) => !v);
    final newVisibility = anyHidden; // If any hidden, show all (true)

    final prefs = await SharedPreferences.getInstance();
    final newState = <String, bool>{};

    for (final walletId in state.keys) {
      newState[walletId] = newVisibility;
      await prefs.setBool('$_prefKey:$walletId', newVisibility);
    }

    state = newState;
  }
}

final balanceVisibilityProvider =
    StateNotifierProvider<BalanceVisibilityNotifier, Map<String, bool>>((ref) {
  return BalanceVisibilityNotifier();
});

/// Convenience provider to check visibility for a specific wallet
final walletBalanceVisibleProvider = Provider.family<bool, String>((ref, walletId) {
  final visibilityMap = ref.watch(balanceVisibilityProvider);
  return visibilityMap[walletId] ?? true;
});
