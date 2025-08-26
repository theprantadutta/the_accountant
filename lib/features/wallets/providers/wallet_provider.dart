import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addWallet({
    required String name,
    required String currency,
    double balance = 0.0,
  }) async {
    try {
      final wallet = WalletsCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        currency: Value(currency),
        balance: Value(balance),
      );
      
      await _database.addWallet(wallet);
      loadWallets(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateWallet({
    required String id,
    String? name,
    String? currency,
    double? balance,
  }) async {
    try {
      final wallet = WalletsCompanion(
        id: Value(id),
        name: name != null ? Value(name) : const Value.absent(),
        currency: currency != null ? Value(currency) : const Value.absent(),
        balance: balance != null ? Value(balance) : const Value.absent(),
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
    return state.wallets.where((wallet) => wallet.currency == currency).toList();
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

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final database = ref.watch(databaseProvider);
  return WalletNotifier(database, ref);
});