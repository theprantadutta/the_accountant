import 'package:intl/intl.dart';
import 'package:the_accountant/core/services/currency_service.dart';

/// Extension on double for easy currency formatting
extension CurrencyFormatting on double {
  /// Format with currency symbol: $1,234.56 or $1,235 based on useDecimals
  String formatCurrency(String currencyCode, {bool useDecimals = true}) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = useDecimals ? NumberFormat('#,##0.00') : NumberFormat('#,##0');
    final value = useDecimals ? this : round().toDouble();
    return '$symbol${formatter.format(value)}';
  }

  /// Format with sign: +$1,234.56 or -$1,234.56 (or whole numbers if useDecimals=false)
  String formatCurrencyWithSign(String currencyCode, {required bool isIncome, bool useDecimals = true}) {
    final formatted = abs().formatCurrency(currencyCode, useDecimals: useDecimals);
    return isIncome ? '+$formatted' : '-$formatted';
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(String currencyCode, {bool useDecimals = true}) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    if (abs() >= 1000000) {
      return '$symbol${(this / 1000000).toStringAsFixed(1)}M';
    } else if (abs() >= 1000) {
      return '$symbol${(this / 1000).toStringAsFixed(1)}K';
    }
    return formatCurrency(currencyCode, useDecimals: useDecimals);
  }

  /// Format without decimal places: $1,235
  String formatCurrencyWhole(String currencyCode) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = NumberFormat('#,##0');
    return '$symbol${formatter.format(round())}';
  }

  /// Format with sign and no decimal: +$1,235 or -$1,235
  String formatCurrencyWholeWithSign(String currencyCode,
      {required bool isIncome}) {
    final formatted = abs().formatCurrencyWhole(currencyCode);
    return isIncome ? '+$formatted' : '-$formatted';
  }
}

/// Extension on num for currency formatting (supports int and double)
extension NumCurrencyFormatting on num {
  /// Format with currency symbol: $1,234.56 or $1,235 based on useDecimals
  String formatCurrency(String currencyCode, {bool useDecimals = true}) {
    return toDouble().formatCurrency(currencyCode, useDecimals: useDecimals);
  }

  /// Format with sign: +$1,234.56 or -$1,234.56 (or whole numbers if useDecimals=false)
  String formatCurrencyWithSign(String currencyCode, {required bool isIncome, bool useDecimals = true}) {
    return toDouble().formatCurrencyWithSign(currencyCode, isIncome: isIncome, useDecimals: useDecimals);
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(String currencyCode, {bool useDecimals = true}) {
    return toDouble().formatCurrencyCompact(currencyCode, useDecimals: useDecimals);
  }
}
