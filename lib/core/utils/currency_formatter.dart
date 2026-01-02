import 'package:intl/intl.dart';
import 'package:the_accountant/core/services/currency_service.dart';

/// Extension on double for easy currency formatting
extension CurrencyFormatting on double {
  /// Format with currency symbol: $1,234.56
  String formatCurrency(String currencyCode) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = NumberFormat('#,##0.00');
    return '$symbol${formatter.format(this)}';
  }

  /// Format with sign: +$1,234.56 or -$1,234.56
  String formatCurrencyWithSign(String currencyCode, {required bool isIncome}) {
    final formatted = abs().formatCurrency(currencyCode);
    return isIncome ? '+$formatted' : '-$formatted';
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(String currencyCode) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    if (abs() >= 1000000) {
      return '$symbol${(this / 1000000).toStringAsFixed(1)}M';
    } else if (abs() >= 1000) {
      return '$symbol${(this / 1000).toStringAsFixed(1)}K';
    }
    return formatCurrency(currencyCode);
  }

  /// Format without decimal places: $1,235
  String formatCurrencyWhole(String currencyCode) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatter = NumberFormat('#,##0');
    return '$symbol${formatter.format(this)}';
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
  /// Format with currency symbol: $1,234.56
  String formatCurrency(String currencyCode) {
    return toDouble().formatCurrency(currencyCode);
  }

  /// Format with sign: +$1,234.56 or -$1,234.56
  String formatCurrencyWithSign(String currencyCode, {required bool isIncome}) {
    return toDouble().formatCurrencyWithSign(currencyCode, isIncome: isIncome);
  }

  /// Format compact: $1.2K, $1.5M
  String formatCurrencyCompact(String currencyCode) {
    return toDouble().formatCurrencyCompact(currencyCode);
  }
}
