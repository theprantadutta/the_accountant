import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
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
  final WalletBalanceService _balanceService;
  final Ref _ref;

  WalletNotifier(this._database, this._ref)
    : _balanceService = WalletBalanceService(_database),
      super(WalletState(wallets: [])) {
    loadWallets();
  }

  /// Get the WalletBalanceService for external use
  WalletBalanceService get balanceService => _balanceService;

  Future<void> loadWallets({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);
    try {
      final wallets = await _database.getAllWallets();

      // Get wallet balances from stored values (kept in sync by balance service)
      final walletBalances = await _balanceService.getAllWalletBalances();

      state = state.copyWith(
        wallets: wallets,
        isLoading: false,
        walletBalances: walletBalances,
      );
    } catch (e) {
      if (!silent) state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Get the default wallet, or the first wallet if none is set as default
  Wallet? getDefaultWallet() {
    if (state.wallets.isEmpty) return null;

    // First try to find a wallet marked as default
    try {
      return state.wallets.firstWhere((w) => w.isDefault == true);
    } catch (_) {
      // If no default, return the first wallet
      return state.wallets.first;
    }
  }

  /// Get the default wallet ID
  String? getDefaultWalletId() {
    return getDefaultWallet()?.id;
  }

  /// Set a wallet as the default
  Future<void> setDefaultWallet(String walletId) async {
    await _clearOtherDefaults(walletId);
    await _database.updateWallet(
      WalletsCompanion(
        id: Value(walletId),
        isDefault: const Value(true),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await loadWallets();
  }

  Future<void> addWallet({
    required String name,
    required String currency,
    double balance = 0.0,
    String? iconName,
    String? color,
    bool isDefault = false,
    bool useDecimals = true,
    WalletType walletType = WalletType.cash,
    double? creditLimit,
    int? billingCycleDay,
  }) async {
    try {
      // Check premium limit for wallets
      final premiumState = _ref.read(premiumProvider);
      if (!premiumState.isPremium) {
        final currentCount = state.wallets.length;
        if (currentCount >= FreeTierLimits.maxWallets) {
          throw PremiumLimitException(
            entityType: 'wallet',
            currentCount: currentCount,
            limit: FreeTierLimits.maxWallets,
          );
        }
      }

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
        useDecimals: Value(useDecimals),
        walletType: Value(walletType),
        creditLimit: Value(creditLimit),
        billingCycleDay: Value(billingCycleDay),
        syncStatus: const Value(1), // pendingCreate
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _database.addWallet(wallet);
      loadWallets(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow; // Rethrow to let UI handle PremiumLimitException
    }
  }

  /// Clear isDefault on all wallets except the specified one
  Future<void> _clearOtherDefaults(String? exceptId) async {
    for (final wallet in state.wallets) {
      if (wallet.id != exceptId && wallet.isDefault == true) {
        await _database.updateWallet(
          WalletsCompanion(
            id: Value(wallet.id),
            isDefault: const Value(false),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );
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
    bool? useDecimals,
    double? creditLimit,
    int? billingCycleDay,
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
        useDecimals: useDecimals != null
            ? Value(useDecimals)
            : const Value.absent(),
        creditLimit: creditLimit != null
            ? Value(creditLimit)
            : const Value.absent(),
        billingCycleDay: billingCycleDay != null
            ? Value(billingCycleDay)
            : const Value.absent(),
        syncStatus: const Value(SyncStatus.pendingUpdate),
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

/// Provider for the WalletBalanceService
final walletBalanceServiceProvider = Provider<WalletBalanceService>((ref) {
  final database = ref.watch(databaseProvider);
  return WalletBalanceService(database);
});

/// Provider to check if user has any wallets
final hasWalletsProvider = Provider<bool>((ref) {
  final walletState = ref.watch(walletProvider);
  return walletState.wallets.isNotEmpty;
});

/// Provider to check if wallets are still loading
final walletsLoadingProvider = Provider<bool>((ref) {
  final walletState = ref.watch(walletProvider);
  return walletState.isLoading;
});

/// Provider to get the effective default wallet ID
/// Uses SharedPreferences persisted value, falls back to database isDefault flag
final effectiveDefaultWalletIdProvider = Provider<String?>((ref) {
  final persistedDefault = ref.watch(defaultWalletIdProvider);
  final walletState = ref.watch(walletProvider);

  // If we have a persisted default and it exists in current wallets, use it
  if (persistedDefault != null) {
    final exists = walletState.wallets.any((w) => w.id == persistedDefault);
    if (exists) return persistedDefault;
  }

  // Fallback to database isDefault flag or first wallet
  if (walletState.wallets.isEmpty) return null;

  try {
    final defaultWallet = walletState.wallets.firstWhere(
      (w) => w.isDefault == true,
    );
    return defaultWallet.id;
  } catch (_) {
    return walletState.wallets.first.id;
  }
});
