import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';

/// Extension on double for easy currency formatting
extension CurrencyFormatting on double {
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
    final value = useDecimals ? this : round().toDouble();
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
    if (abs() >= 1000000) {
      return '$symbol${(this / 1000000).toStringAsFixed(1).replaceAll('.', decSep)}M';
    } else if (abs() >= 1000) {
      return '$symbol${(this / 1000).toStringAsFixed(1).replaceAll('.', decSep)}K';
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
    return '$symbol${formatter.format(round())}';
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

/// Extension on num for currency formatting (supports int and double)
extension NumCurrencyFormatting on num {
  /// Format with currency symbol: $1,234.56 or $1,235 based on useDecimals
  String formatCurrency(
    String currencyCode, {
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
  }) {
    return toDouble().formatCurrency(
      currencyCode,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );
  }

  /// Format with sign: +$1,234.56 or -$1,234.56 (or whole numbers if useDecimals=false)
  String formatCurrencyWithSign(
    String currencyCode, {
    required bool isIncome,
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
  }) {
    return toDouble().formatCurrencyWithSign(
      currencyCode,
      isIncome: isIncome,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(
    String currencyCode, {
    bool useDecimals = true,
    String numberFormat = 'comma_dot',
  }) {
    return toDouble().formatCurrencyCompact(
      currencyCode,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );
  }
}
