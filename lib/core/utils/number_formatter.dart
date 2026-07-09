import 'package:intl/intl.dart';

class AppNumberFormatter {
  /// Returns a NumberFormat configured for the user's setting
  static NumberFormat get(String numberFormat, {bool useDecimals = true}) {
    switch (numberFormat) {
      case 'dot_comma':
        return useDecimals
            ? NumberFormat('#,##0.00', 'de_DE')
            : NumberFormat('#,##0', 'de_DE');
      case 'space_comma':
        return useDecimals
            ? NumberFormat('#,##0.00', 'fr_FR')
            : NumberFormat('#,##0', 'fr_FR');
      case 'none_dot':
        return useDecimals ? NumberFormat('###0.00') : NumberFormat('###0');
      case 'comma_dot':
      default:
        return useDecimals
            ? NumberFormat('#,##0.00', 'en_US')
            : NumberFormat('#,##0', 'en_US');
    }
  }

  /// Returns a currency NumberFormat with proper symbol + separator
  static NumberFormat currency(
    String symbol,
    String numberFormat, {
    int decimalDigits = 2,
  }) {
    switch (numberFormat) {
      case 'dot_comma':
        return NumberFormat.currency(
          symbol: symbol,
          decimalDigits: decimalDigits,
          locale: 'de_DE',
        );
      case 'space_comma':
        return NumberFormat.currency(
          symbol: symbol,
          decimalDigits: decimalDigits,
          locale: 'fr_FR',
        );
      case 'none_dot':
        return NumberFormat.currency(
          symbol: symbol,
          decimalDigits: decimalDigits,
          customPattern: '$symbol###0.00',
        );
      case 'comma_dot':
      default:
        return NumberFormat.currency(
          symbol: symbol,
          decimalDigits: decimalDigits,
          locale: 'en_US',
        );
    }
  }

  /// Returns the decimal separator char for the format ('.' or ',')
  static String decimalSeparator(String numberFormat) {
    switch (numberFormat) {
      case 'dot_comma':
      case 'space_comma':
        return ',';
      case 'comma_dot':
      case 'none_dot':
      default:
        return '.';
    }
  }
}
