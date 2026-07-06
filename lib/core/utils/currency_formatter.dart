import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';

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
  }) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = AppNumberFormatter.get(
      numberFormat,
      useDecimals: useDecimals,
    );
    final dollars = _asDollars;
    final value = useDecimals ? dollars : dollars.round().toDouble();
    return '$symbol${formatter.format(value)}';
  }

  /// Format with sign: +$1,234.56 or -$1,234.56 (or whole numbers if useDecimals=false)
  String formatCurrencyWithSign(
    String currencyCode, {
    required bool isIncome,
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
  }) {
    final formatted = abs().formatCurrency(
      currencyCode,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );
    return isIncome ? '+$formatted' : '-$formatted';
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(
    String currencyCode, {
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
  }) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final decSep = AppNumberFormatter.decimalSeparator(numberFormat);
    final dollars = _asDollars;
    if (dollars.abs() >= 1000000) {
      return '$symbol${(dollars / 1000000).toStringAsFixed(1).replaceAll('.', decSep)}M';
    } else if (dollars.abs() >= 1000) {
      return '$symbol${(dollars / 1000).toStringAsFixed(1).replaceAll('.', decSep)}K';
    }
    return formatCurrency(
      currencyCode,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );
  }

  /// Format without decimal places: $1,235
  String formatCurrencyWhole(
    String currencyCode, {
    String numberFormat = 'comma_dot',
  }) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = AppNumberFormatter.get(numberFormat, useDecimals: false);
    return '$symbol${formatter.format(_asDollars.round())}';
  }

  /// Format with sign and no decimal: +$1,235 or -$1,235
  String formatCurrencyWholeWithSign(
    String currencyCode, {
    required bool isIncome,
    String numberFormat = 'comma_dot',
  }) {
    final formatted = abs().formatCurrencyWhole(
      currencyCode,
      numberFormat: numberFormat,
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
