import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';

class CustomDateUtils {
  /// Format a DateTime as Month Year (e.g., January 2023)
  static String formatMonthYear(DateTime date) {
    final formatter = DateFormat('MMMM yyyy');
    return formatter.format(date);
  }

  /// Format a DateTime using the user's date format setting
  static String formatShortDate(
    DateTime date, {
    String dateFormat = 'MM/dd/yyyy',
  }) {
    return AppDateFormatter.formatDate(date, dateFormat);
  }

  /// Get the first day of the month for a given date
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the last day of the month for a given date
  static DateTime lastDayOfMonth(DateTime date) {
    final firstDay = firstDayOfMonth(date);
    return DateTime(firstDay.year, firstDay.month + 1, 0);
  }
}
