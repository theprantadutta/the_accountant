import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for fetching and managing currency exchange rates
/// Uses fawazahmed0/exchange-api for rate data
class CurrencyService {
  final AppDatabase _database;

  // Primary API endpoint (jsdelivr CDN)
  static const String _primaryBaseUrl =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1';

  // Fallback API endpoint (GitHub Pages)
  static const String _fallbackBaseUrl =
      'https://latest.currency-api.pages.dev/v1';

  // Cache keys
  static const String _currenciesCacheKey = 'currencies_list_cache';
  static const String _currenciesCacheTimeKey = 'currencies_list_cache_time';
  static const String _ratesCacheKey = 'exchange_rates_cache';
  static const String _ratesCacheTimeKey = 'exchange_rates_cache_time';

  // Cache duration: 24 hours for currency list, 6 hours for rates
  static const Duration _currenciesCacheDuration = Duration(hours: 24);
  static const Duration _ratesCacheDuration = Duration(hours: 6);

  CurrencyService(this._database);

  /// Fetch all available currencies from API
  /// Returns: {"usd": "United States Dollar", "eur": "Euro", ...}
  Future<Map<String, String>> fetchAvailableCurrencies() async {
    // Try cache first
    final cached = await _getCachedCurrencies();
    if (cached != null) {
      return cached;
    }

    // Fetch from API
    try {
      final response = await _fetchWithFallback('/currencies.json');
      if (response != null) {
        final Map<String, dynamic> data = json.decode(response);
        final currencies = data.map(
          (key, value) =>
              MapEntry(key.toString().toUpperCase(), value.toString()),
        );

        // Cache the result
        await _cacheCurrencies(currencies);

        return currencies;
      }
    } catch (e) {
      debugPrint('[CurrencyService] Error fetching currencies: $e');
    }

    // Return empty map on failure
    return {};
  }

  /// Fetch exchange rates from API (USD as base)
  /// Returns: {"EUR": 0.95, "GBP": 0.79, ...}
  Future<Map<String, double>> fetchApiRates() async {
    // Try cache first
    final cached = await _getCachedRates();
    if (cached != null) {
      return cached;
    }

    try {
      final response = await _fetchWithFallback('/currencies/usd.json');
      if (response != null) {
        final Map<String, dynamic> data = json.decode(response);
        final usdRates = data['usd'] as Map<String, dynamic>?;

        if (usdRates != null) {
          final rates = <String, double>{};
          usdRates.forEach((key, value) {
            if (value is num) {
              rates[key.toUpperCase()] = value.toDouble();
            }
          });

          // Cache the result
          await _cacheRates(rates);

          // Store in database
          await _storeRatesInDatabase(rates);

          return rates;
        }
      }
    } catch (e) {
      debugPrint('[CurrencyService] Error fetching rates: $e');
    }

    // Try to get from database as fallback
    return await _getRatesFromDatabase();
  }

  /// Get conversion rate between two currencies
  /// Checks custom rate first, then uses API rate via USD as base
  Future<double> getRate(String from, String to) async {
    final fromUpper = from.toUpperCase();
    final toUpper = to.toUpperCase();

    // Same currency = no conversion
    if (fromUpper == toUpper) {
      return 1.0;
    }

    // Check for custom rate in database
    final customRate = await _database.getExchangeRate(fromUpper, toUpper);
    if (customRate != null &&
        customRate.useCustomRate &&
        customRate.customRate != null) {
      return customRate.customRate!;
    }

    // Use API rates via USD as base
    final rates = await fetchApiRates();

    if (rates.isEmpty) {
      debugPrint('[CurrencyService] No rates available, returning 1.0');
      return 1.0;
    }

    // Calculate rate through USD
    // rate = (1/fromUSD) * toUSD
    final fromRate = fromUpper == 'USD' ? 1.0 : rates[fromUpper];
    final toRate = toUpper == 'USD' ? 1.0 : rates[toUpper];

    if (fromRate == null || toRate == null) {
      debugPrint('[CurrencyService] Rate not found for $fromUpper or $toUpper');
      return 1.0;
    }

    // Convert: (1/fromRate) * toRate
    // If we have USD/from rate and USD/to rate:
    // from -> USD: amount / fromRate
    // USD -> to: amount * toRate
    // Combined: amount * (toRate / fromRate)
    return toRate / fromRate;
  }

  /// Convert amount between currencies
  Future<double> convert(double amount, String from, String to) async {
    final rate = await getRate(from, to);
    return amount * rate;
  }

  /// Save custom rate override
  Future<void> setCustomRate(String from, String to, double rate) async {
    await _database.setCustomRate(from.toUpperCase(), to.toUpperCase(), rate);
  }

  /// Clear custom rate (use API rate)
  Future<void> clearCustomRate(String from, String to) async {
    await _database.clearCustomRate(from.toUpperCase(), to.toUpperCase());
  }

  /// Get all custom rates
  Future<List<ExchangeRate>> getCustomRates() async {
    return await _database.getCustomExchangeRates();
  }

  /// Force refresh rates from API
  Future<Map<String, double>> refreshRates() async {
    // Clear cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ratesCacheKey);
    await prefs.remove(_ratesCacheTimeKey);

    return await fetchApiRates();
  }

  /// Get last fetched time for rates
  Future<DateTime?> getLastFetchedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_ratesCacheTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  // ============================================================
  // Private helper methods
  // ============================================================

  /// Fetch with fallback to secondary endpoint
  Future<String?> _fetchWithFallback(String endpoint) async {
    try {
      final primaryResponse = await http
          .get(Uri.parse('$_primaryBaseUrl$endpoint'))
          .timeout(const Duration(seconds: 10));

      if (primaryResponse.statusCode == 200) {
        return primaryResponse.body;
      }
    } catch (e) {
      debugPrint('[CurrencyService] Primary API failed: $e');
    }

    // Try fallback
    try {
      final fallbackResponse = await http
          .get(Uri.parse('$_fallbackBaseUrl$endpoint'))
          .timeout(const Duration(seconds: 10));

      if (fallbackResponse.statusCode == 200) {
        return fallbackResponse.body;
      }
    } catch (e) {
      debugPrint('[CurrencyService] Fallback API failed: $e');
    }

    return null;
  }

  /// Get cached currencies
  Future<Map<String, String>?> _getCachedCurrencies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheTime = prefs.getInt(_currenciesCacheTimeKey);

      if (cacheTime != null) {
        final cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheTime);
        if (DateTime.now().difference(cachedAt) < _currenciesCacheDuration) {
          final cached = prefs.getString(_currenciesCacheKey);
          if (cached != null) {
            final Map<String, dynamic> data = json.decode(cached);
            return data.map((k, v) => MapEntry(k, v.toString()));
          }
        }
      }
    } catch (e) {
      debugPrint('[CurrencyService] Cache read error: $e');
    }
    return null;
  }

  /// Cache currencies
  Future<void> _cacheCurrencies(Map<String, String> currencies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currenciesCacheKey, json.encode(currencies));
      await prefs.setInt(
        _currenciesCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('[CurrencyService] Cache write error: $e');
    }
  }

  /// Get cached rates
  Future<Map<String, double>?> _getCachedRates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheTime = prefs.getInt(_ratesCacheTimeKey);

      if (cacheTime != null) {
        final cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheTime);
        if (DateTime.now().difference(cachedAt) < _ratesCacheDuration) {
          final cached = prefs.getString(_ratesCacheKey);
          if (cached != null) {
            final Map<String, dynamic> data = json.decode(cached);
            return data.map((k, v) => MapEntry(k, (v as num).toDouble()));
          }
        }
      }
    } catch (e) {
      debugPrint('[CurrencyService] Cache read error: $e');
    }
    return null;
  }

  /// Cache rates
  Future<void> _cacheRates(Map<String, double> rates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_ratesCacheKey, json.encode(rates));
      await prefs.setInt(
        _ratesCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('[CurrencyService] Cache write error: $e');
    }
  }

  /// Store rates in database
  Future<void> _storeRatesInDatabase(Map<String, double> rates) async {
    final now = DateTime.now();
    for (final entry in rates.entries) {
      if (entry.key != 'USD') {
        await _database.upsertExchangeRate(
          fromCurrency: 'USD',
          toCurrency: entry.key,
          apiRate: entry.value,
          apiRateFetchedAt: now,
        );
      }
    }
  }

  /// Get rates from database
  Future<Map<String, double>> _getRatesFromDatabase() async {
    final rates = <String, double>{};
    final dbRates = await _database.getAllExchangeRates();
    for (final rate in dbRates) {
      if (rate.fromCurrency == 'USD' && rate.apiRate != null) {
        rates[rate.toCurrency] = rate.apiRate!;
      }
    }
    return rates;
  }
}

/// Currency info for display
class CurrencyInfo {
  final String code;
  final String name;
  final String? symbol;

  const CurrencyInfo({required this.code, required this.name, this.symbol});

  /// Get currency symbol from code
  static String getSymbol(String code) {
    return _currencySymbols[code.toUpperCase()] ?? code;
  }

  // Common currency symbols
  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'KRW': '₩',
    'INR': '₹',
    'RUB': '₽',
    'BRL': 'R\$',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'CHF': 'Fr',
    'HKD': 'HK\$',
    'SGD': 'S\$',
    'SEK': 'kr',
    'NOK': 'kr',
    'DKK': 'kr',
    'NZD': 'NZ\$',
    'ZAR': 'R',
    'MXN': '\$',
    'THB': '฿',
    'PHP': '₱',
    'IDR': 'Rp',
    'MYR': 'RM',
    'TRY': '₺',
    'PLN': 'zł',
    'ILS': '₪',
    'AED': 'د.إ',
    'SAR': '﷼',
    'EGP': 'E£',
    'PKR': '₨',
    'BDT': '৳',
    'VND': '₫',
    'NGN': '₦',
    'KES': 'KSh',
    'GHS': 'GH₵',
    'COP': '\$',
    'ARS': '\$',
    'CLP': '\$',
    'PEN': 'S/',
    'UAH': '₴',
    'CZK': 'Kč',
    'HUF': 'Ft',
    'RON': 'lei',
    'BGN': 'лв',
  };
}
