import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// State for currency management
class CurrencyState {
  /// Map of available currencies: code -> name
  final Map<String, String> availableCurrencies;

  /// Map of exchange rates: currency code -> rate from USD
  final Map<String, double> apiRates;

  /// Whether data is loading
  final bool isLoading;

  /// Last time rates were fetched
  final DateTime? lastFetched;

  /// Error message if any
  final String? error;

  const CurrencyState({
    this.availableCurrencies = const {},
    this.apiRates = const {},
    this.isLoading = false,
    this.lastFetched,
    this.error,
  });

  CurrencyState copyWith({
    Map<String, String>? availableCurrencies,
    Map<String, double>? apiRates,
    bool? isLoading,
    DateTime? lastFetched,
    String? error,
  }) {
    return CurrencyState(
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      apiRates: apiRates ?? this.apiRates,
      isLoading: isLoading ?? this.isLoading,
      lastFetched: lastFetched ?? this.lastFetched,
      error: error,
    );
  }

  /// Get sorted list of currency codes
  List<String> get sortedCurrencyCodes {
    final codes = availableCurrencies.keys.toList();
    codes.sort();
    return codes;
  }

  /// Search currencies by code or name
  List<MapEntry<String, String>> searchCurrencies(String query) {
    if (query.isEmpty) {
      return availableCurrencies.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
    }

    final lowerQuery = query.toLowerCase();
    return availableCurrencies.entries
        .where((entry) =>
            entry.key.toLowerCase().contains(lowerQuery) ||
            entry.value.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) {
        // Prioritize exact code matches
        final aExact = a.key.toLowerCase() == lowerQuery;
        final bExact = b.key.toLowerCase() == lowerQuery;
        if (aExact && !bExact) return -1;
        if (bExact && !aExact) return 1;

        // Then prioritize code starts with
        final aStarts = a.key.toLowerCase().startsWith(lowerQuery);
        final bStarts = b.key.toLowerCase().startsWith(lowerQuery);
        if (aStarts && !bStarts) return -1;
        if (bStarts && !aStarts) return 1;

        return a.key.compareTo(b.key);
      });
  }
}

/// Currency state notifier
class CurrencyNotifier extends StateNotifier<CurrencyState> {
  final CurrencyService _currencyService;

  CurrencyNotifier(this._currencyService) : super(const CurrencyState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadCurrencies();
    await loadRates();
  }

  /// Load available currencies from API
  Future<void> loadCurrencies() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currencies = await _currencyService.fetchAvailableCurrencies();
      state = state.copyWith(
        availableCurrencies: currencies,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('[CurrencyProvider] Error loading currencies: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load currencies',
      );
    }
  }

  /// Load exchange rates from API
  Future<void> loadRates() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rates = await _currencyService.fetchApiRates();
      final lastFetched = await _currencyService.getLastFetchedTime();

      state = state.copyWith(
        apiRates: rates,
        isLoading: false,
        lastFetched: lastFetched,
      );
    } catch (e) {
      debugPrint('[CurrencyProvider] Error loading rates: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load exchange rates',
      );
    }
  }

  /// Refresh rates from API
  Future<void> refreshRates() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rates = await _currencyService.refreshRates();
      state = state.copyWith(
        apiRates: rates,
        isLoading: false,
        lastFetched: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[CurrencyProvider] Error refreshing rates: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to refresh exchange rates',
      );
    }
  }

  /// Convert amount between currencies
  Future<double> convert(double amount, String from, String to) async {
    return await _currencyService.convert(amount, from, to);
  }

  /// Get exchange rate between currencies
  Future<double> getRate(String from, String to) async {
    return await _currencyService.getRate(from, to);
  }

  /// Set a custom exchange rate
  Future<void> setCustomRate(String from, String to, double rate) async {
    await _currencyService.setCustomRate(from, to, rate);
    // Reload rates to reflect changes
    await loadRates();
  }

  /// Clear a custom rate (use API rate)
  Future<void> clearCustomRate(String from, String to) async {
    await _currencyService.clearCustomRate(from, to);
    await loadRates();
  }

  /// Get currency name by code
  String getCurrencyName(String code) {
    return state.availableCurrencies[code.toUpperCase()] ?? code;
  }

  /// Get currency symbol by code
  String getCurrencySymbol(String code) {
    return CurrencyInfo.getSymbol(code.toUpperCase());
  }

  /// Format amount with currency symbol
  String formatAmount(double amount, String currency) {
    final symbol = getCurrencySymbol(currency);
    final formatted = amount.toStringAsFixed(2);
    return '$symbol$formatted';
  }
}

/// Currency service provider
final currencyServiceProvider = Provider<CurrencyService>((ref) {
  final database = ref.watch(databaseProvider);
  return CurrencyService(database);
});

/// Currency state provider
final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, CurrencyState>((ref) {
  final service = ref.watch(currencyServiceProvider);
  return CurrencyNotifier(service);
});

/// Provider for searching currencies
final currencySearchProvider = Provider.family<List<MapEntry<String, String>>, String>((ref, query) {
  final state = ref.watch(currencyProvider);
  return state.searchCurrencies(query);
});

/// Provider to get currency name by code
final currencyNameProvider = Provider.family<String, String>((ref, code) {
  final state = ref.watch(currencyProvider);
  return state.availableCurrencies[code.toUpperCase()] ?? code;
});
