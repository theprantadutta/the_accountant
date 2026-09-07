import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Key for storing default wallet ID in SharedPreferences
const String _defaultWalletKey = 'default_wallet_id';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

/// State for default wallet
class DefaultWalletState {
  final String? walletId;
  final bool isLoaded;

  const DefaultWalletState({this.walletId, this.isLoaded = false});

  DefaultWalletState copyWith({String? walletId, bool? isLoaded}) {
    return DefaultWalletState(
      walletId: walletId ?? this.walletId,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Notifier for managing default wallet selection with persistence
class DefaultWalletNotifier extends Notifier<DefaultWalletState> {
  @override
  DefaultWalletState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final walletId = prefs.getString(_defaultWalletKey);
    return DefaultWalletState(walletId: walletId, isLoaded: true);
  }

  /// Set the default wallet and persist to SharedPreferences
  ///
  /// Written onto the wallet row as well. The preference alone is invisible to
  /// anything that works from the database — a budget's currency, a report's
  /// totals — and a choice those cannot see is a choice they will contradict.
  ///
  /// Through the same operation the accounts screen uses. It briefly called the
  /// seeding path instead, which by then refused to touch an account that
  /// already held the flag — so this setter saved the new preference and then
  /// changed nothing, and the old default stayed in force while every provider
  /// reported the new one. Seeding is for a store with no answer; this is a
  /// person choosing.
  Future<void> setDefaultWallet(String walletId) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_defaultWalletKey, walletId);
    state = state.copyWith(walletId: walletId);
    await ref.read(databaseProvider).setDefaultWallet(walletId);
    // The wallet list holds the flag too, and a screen reading it would go on
    // showing the old default until something else happened to reload.
    await ref.read(walletProvider.notifier).loadWallets();
  }

  /// Clear the default wallet (e.g., when wallet is deleted)
  Future<void> clearDefaultWallet() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_defaultWalletKey);
    state = DefaultWalletState(walletId: null, isLoaded: true);
  }

  /// Check if a wallet ID is the default
  bool isDefaultWallet(String walletId) {
    return state.walletId == walletId;
  }
}

/// Provider for default wallet notifier
final defaultWalletProvider =
    NotifierProvider<DefaultWalletNotifier, DefaultWalletState>(
      DefaultWalletNotifier.new,
    );

/// Convenience provider to get just the default wallet ID
final defaultWalletIdProvider = Provider<String?>((ref) {
  return ref.watch(defaultWalletProvider).walletId;
});

/// Provider to check if default wallet is loaded
final isDefaultWalletLoadedProvider = Provider<bool>((ref) {
  return ref.watch(defaultWalletProvider).isLoaded;
});
