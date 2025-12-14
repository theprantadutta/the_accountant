import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' hide Transaction;
import 'package:the_accountant/features/dashboard/widgets/wallet_switcher.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Dashboard state combining wallet selection and filtered data
class DashboardState {
  final String? selectedWalletId;
  final List<Transaction> filteredTransactions;
  final Map<String, double> balancesByCurrency;
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  const DashboardState({
    this.selectedWalletId,
    this.filteredTransactions = const [],
    this.balancesByCurrency = const {},
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
  });

  DashboardState copyWith({
    String? selectedWalletId,
    List<Transaction>? filteredTransactions,
    Map<String, double>? balancesByCurrency,
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
  }) {
    return DashboardState(
      selectedWalletId: selectedWalletId ?? this.selectedWalletId,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      balancesByCurrency: balancesByCurrency ?? this.balancesByCurrency,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
    );
  }

  /// Whether "All Wallets" is selected
  bool get isAllWalletsSelected => selectedWalletId == null;
}

/// Provider for filtered transactions based on selected wallet
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final selectedWalletId = ref.watch(selectedWalletIdProvider);
  final transactionState = ref.watch(transactionProvider);

  if (selectedWalletId == null) {
    // Return all transactions
    return transactionState.transactions;
  }

  // Filter by wallet
  return transactionState.transactions
      .where((t) => t.walletId == selectedWalletId)
      .toList();
});

/// Provider for balance by currency when "All Wallets" is selected
final balancesByCurrencyProvider = Provider<Map<String, double>>((ref) {
  final walletState = ref.watch(walletProvider);
  final balances = <String, double>{};

  for (final wallet in walletState.wallets) {
    final currency = wallet.currency;
    balances[currency] = (balances[currency] ?? 0) + wallet.balance;
  }

  return balances;
});

/// Provider for total income in selected period/wallet
final filteredIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  return transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);
});

/// Provider for total expenses in selected period/wallet
final filteredExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  return transactions
      .where((t) => t.type != 'income')
      .fold(0.0, (sum, t) => sum + t.amount);
});

/// Provider for selected wallet details
final selectedWalletProvider = Provider<Wallet?>((ref) {
  final selectedWalletId = ref.watch(selectedWalletIdProvider);
  if (selectedWalletId == null) return null;

  final walletState = ref.watch(walletProvider);
  return walletState.wallets.cast<Wallet?>().firstWhere(
        (w) => w?.id == selectedWalletId,
        orElse: () => null,
      );
});

/// Provider for current display currency
final displayCurrencyProvider = Provider<String>((ref) {
  final selectedWallet = ref.watch(selectedWalletProvider);
  if (selectedWallet != null) {
    return selectedWallet.currency;
  }
  // When "All Wallets" selected, use primary currency from first wallet
  final walletState = ref.watch(walletProvider);
  if (walletState.wallets.isNotEmpty) {
    // Try to find default wallet first
    final defaultWallet = walletState.wallets.cast<Wallet?>().firstWhere(
          (w) => w?.isDefault == true,
          orElse: () => walletState.wallets.first,
        );
    return defaultWallet?.currency ?? 'USD';
  }
  return 'USD';
});
