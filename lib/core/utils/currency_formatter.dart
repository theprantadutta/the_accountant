import 'package:the_accountant/core/domain/regional_preferences.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';

/// Put the symbol where the user wants it.
///
/// A non-breaking space before a trailing symbol, because an amount that wraps
/// between the number and its currency is worse than no space at all.
String _place(String symbol, String amount, SymbolPosition? position) {
  final where = position ?? RegionalPreferences.symbolPosition;
  return switch (where) {
    SymbolPosition.before => '$symbol$amount',
    SymbolPosition.after => '$amount\u00A0$symbol',
  };
}

/// Extension on int for currency formatting.
///
/// IMPORTANT: the int receiver is MONEY expressed in integer MINOR UNITS (cents).
/// Every method converts cents -> major units (dollars) by dividing by 100 for display.
extension CentsCurrencyFormatting on int {
  /// This value (cents) expressed as major-unit dollars.
  double get _asDollars => this / 100.0;

  /// Format with currency symbol: $1,234.56 or $1,235 based on useDecimals
  String formatCurrency(
    String currencyCode, {
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
    SymbolPosition? symbolPosition,
  }) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = AppNumberFormatter.get(
      numberFormat,
      useDecimals: useDecimals,
    );
    final dollars = _asDollars;
    final value = useDecimals ? dollars : dollars.round().toDouble();
    return _place(symbol, formatter.format(value), symbolPosition);
  }

  /// Format with sign: +$1,234.56 or -$1,234.56 (or whole numbers if useDecimals=false)
  String formatCurrencyWithSign(
    String currencyCode, {
    required bool isIncome,
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
    SymbolPosition? symbolPosition,
  }) {
    final formatted = abs().formatCurrency(
      currencyCode,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
      symbolPosition: symbolPosition,
    );
    return isIncome ? '+$formatted' : '-$formatted';
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(
    String currencyCode, {
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
    SymbolPosition? symbolPosition,
  }) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final decSep = AppNumberFormatter.decimalSeparator(numberFormat);
    final dollars = _asDollars;
    if (dollars.abs() >= 1000000) {
      final short = (dollars / 1000000)
          .toStringAsFixed(1)
          .replaceAll('.', decSep);
      return _place(symbol, '${short}M', symbolPosition);
    } else if (dollars.abs() >= 1000) {
      final short = (dollars / 1000).toStringAsFixed(1).replaceAll('.', decSep);
      return _place(symbol, '${short}K', symbolPosition);
    }
    return formatCurrency(
      currencyCode,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
      symbolPosition: symbolPosition,
    );
  }

  /// Format without decimal places: $1,235
  String formatCurrencyWhole(
    String currencyCode, {
    String numberFormat = 'comma_dot',
    SymbolPosition? symbolPosition,
  }) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = AppNumberFormatter.get(numberFormat, useDecimals: false);
    return _place(symbol, formatter.format(_asDollars.round()), symbolPosition);
  }

  /// Format with sign and no decimal: +$1,235 or -$1,235
  String formatCurrencyWholeWithSign(
    String currencyCode, {
    required bool isIncome,
    String numberFormat = 'comma_dot',
    SymbolPosition? symbolPosition,
  }) {
    final formatted = abs().formatCurrencyWhole(
      currencyCode,
      numberFormat: numberFormat,
      symbolPosition: symbolPosition,
    );
    return isIncome ? '+$formatted' : '-$formatted';
  }
}

/// Helpers for converting between user-entered/display dollars and stored cents.
extension MoneyParsing on String {
  /// Parse user-entered text (e.g. "12.34", "1,234.56") into integer cents.
  /// Returns null if the text cannot be parsed as a number.
  int? toCentsOrNull() {
    if (trim().isEmpty) return null;
    // Strip common grouping separators/spaces and currency symbols, keep digits,
    // a decimal separator and sign. Treat both '.' and ',' as possible decimal.
    var cleaned = replaceAll(RegExp(r'[^0-9,.\-]'), '').trim();
    if (cleaned.isEmpty) return null;
    // If both separators present, assume the last one is the decimal separator.
    final lastDot = cleaned.lastIndexOf('.');
    final lastComma = cleaned.lastIndexOf(',');
    if (lastDot >= 0 && lastComma >= 0) {
      if (lastComma > lastDot) {
        // comma is decimal separator
        cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
      } else {
        // dot is decimal separator
        cleaned = cleaned.replaceAll(',', '');
      }
    } else if (lastComma >= 0) {
      // Only commas: treat as decimal separator
      cleaned = cleaned.replaceAll(',', '.');
    }
    final dollars = double.tryParse(cleaned);
    if (dollars == null) return null;
    return (dollars * 100).round();
  }
}

/// Convert a whole/major-unit dollar value into integer cents.
int dollarsToCents(num dollars) => (dollars * 100).round();

/// Convert integer cents into major-unit dollars (double).
double centsToDollars(int cents) => cents / 100.0;
