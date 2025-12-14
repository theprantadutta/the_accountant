import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

class WalletState {
  final List<Wallet> wallets;
  final bool isLoading;
  final String? error;
  final Map<String, double> walletBalances; // Add wallet balances

  WalletState({
    required this.wallets,
    this.isLoading = false,
    this.error,
    this.walletBalances = const {},
  });

  WalletState copyWith({
    List<Wallet>? wallets,
    bool? isLoading,
    String? error,
    Map<String, double>? walletBalances,
  }) {
    return WalletState(
      wallets: wallets ?? this.wallets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      walletBalances: walletBalances ?? this.walletBalances,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final AppDatabase _database;
  final Ref _ref;

  WalletNotifier(this._database, this._ref) : super(WalletState(wallets: [])) {
    loadWallets();
  }

  Future<void> loadWallets() async {
    state = state.copyWith(isLoading: true);
    try {
      final wallets = await _database.getAllWallets();

      // Calculate wallet balances
      final transactionNotifier = _ref.read(transactionProvider.notifier);
      final walletBalances = transactionNotifier.getAllWalletBalances();

      state = state.copyWith(
        wallets: wallets,
        isLoading: false,
        walletBalances: walletBalances,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addWallet({
    required String name,
    required String currency,
    double balance = 0.0,
    String? iconName,
    String? color,
    bool isDefault = false,
  }) async {
    try {
      // If setting as default, clear other defaults first
      if (isDefault) {
        await _clearOtherDefaults(null);
      }

      final now = DateTime.now();
      final wallet = WalletsCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        currency: Value(currency),
        balance: Value(balance),
        iconName: Value(iconName ?? 'wallet'),
        color: Value(color ?? '#6366F1'),
        isDefault: Value(isDefault),
        syncStatus: const Value(1), // pendingCreate
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _database.addWallet(wallet);
      loadWallets(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear isDefault on all wallets except the specified one
  Future<void> _clearOtherDefaults(String? exceptId) async {
    for (final wallet in state.wallets) {
      if (wallet.id != exceptId && wallet.isDefault == true) {
        await _database.updateWallet(WalletsCompanion(
          id: Value(wallet.id),
          isDefault: const Value(false),
          updatedAt: Value(DateTime.now()),
        ));
      }
    }
  }

  Future<void> updateWallet({
    required String id,
    String? name,
    String? currency,
    double? balance,
    String? iconName,
    String? color,
    bool? isDefault,
  }) async {
    try {
      // If setting as default, clear other defaults first
      if (isDefault == true) {
        await _clearOtherDefaults(id);
      }

      final wallet = WalletsCompanion(
        id: Value(id),
        name: name != null ? Value(name) : const Value.absent(),
        currency: currency != null ? Value(currency) : const Value.absent(),
        balance: balance != null ? Value(balance) : const Value.absent(),
        iconName: iconName != null ? Value(iconName) : const Value.absent(),
        color: color != null ? Value(color) : const Value.absent(),
        isDefault: isDefault != null ? Value(isDefault) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      await _database.updateWallet(wallet);
      loadWallets(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteWallet(String id) async {
    try {
      await _database.deleteWallet(id);
      loadWallets(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Wallet? getWalletById(String id) {
    try {
      return state.wallets.firstWhere((wallet) => wallet.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Wallet> getWalletsByCurrency(String currency) {
    return state.wallets
        .where((wallet) => wallet.currency == currency)
        .toList();
  }

  // Get the calculated balance for a wallet
  double getWalletBalance(String walletId) {
    return state.walletBalances[walletId] ?? 0.0;
  }

  // Get all wallet balances
  Map<String, double> getAllWalletBalances() {
    return state.walletBalances;
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return WalletNotifier(database, ref);
});
