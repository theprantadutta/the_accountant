import 'package:intl/intl.dart';

class AppDateFormatter {
  /// Full date using the user's setting string (all 5 are valid DateFormat patterns)
  static String formatDate(DateTime date, String dateFormat) {
    return DateFormat(dateFormat).format(date);
  }

  /// Short date (no year) — maps each setting to a short variant
  static String formatShortDate(DateTime date, String dateFormat) {
    switch (dateFormat) {
      case 'dd/MM/yyyy':
      case 'dd MMM yyyy':
        return DateFormat('d MMM').format(date);
      case 'MM/dd/yyyy':
      case 'yyyy-MM-dd':
      case 'MMM dd, yyyy':
      default:
        return DateFormat('MMM d').format(date);
    }
  }

  /// Relative: Today/Yesterday/Tomorrow, else short (same year) or full (different year)
  static String formatRelativeDate(DateTime date, String dateFormat) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';

    if (date.year == now.year) {
      return formatShortDate(date, dateFormat);
    }
    return formatDate(date, dateFormat);
  }

  /// Month-year — always 'MMMM yyyy'
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Short month-year — 'MMM yyyy'
  static String formatShortMonthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }
}
