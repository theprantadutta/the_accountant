import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/domain/regional_preferences.dart';

/// Showing a time of day the way the user asked for it.
///
/// Every time in the app was hard-coded to a 12-hour clock, which is wrong for
/// most of the world and had no setting to fix it. The choice is theirs, with
/// "match my phone" as the default, because that is the answer people expect
/// without having to be asked.
class AppTimeFormatter {
  const AppTimeFormatter._();

  /// Whether the phone itself is set to a 24-hour clock.
  ///
  /// Read through MediaQuery so a change to the system setting rebuilds
  /// whatever is showing a time.
  static bool platformUses24Hour(BuildContext context) =>
      MediaQuery.alwaysUse24HourFormatOf(context);

  /// Whether to draw a 24-hour clock right now.
  static bool use24Hour(BuildContext context) => RegionalPreferences.timeFormat
      .resolve(platformUses24Hour: platformUses24Hour(context));

  /// `13:30` or `1:30 PM`.
  static String formatTime(DateTime moment, {required bool use24Hour}) =>
      DateFormat(use24Hour ? 'HH:mm' : 'h:mm a').format(moment);

  /// The same, for a [TimeOfDay].
  static String formatTimeOfDay(TimeOfDay time, {required bool use24Hour}) =>
      formatTime(
        DateTime(2000, 1, 1, time.hour, time.minute),
        use24Hour: use24Hour,
      );

  /// A date and a time together, using the user's date format for the date.
  static String formatDateTime(
    DateTime moment, {
    required String dateFormat,
    required bool use24Hour,
  }) =>
      '${DateFormat(dateFormat).format(moment)} '
      '${formatTime(moment, use24Hour: use24Hour)}';

  /// Read the setting straight from the context, for callers that have one.
  static String of(BuildContext context, DateTime moment) =>
      formatTime(moment, use24Hour: use24Hour(context));

  /// Force a picker to honour the setting rather than only the phone.
  ///
  /// `showTimePicker` reads `MediaQuery.alwaysUse24HourFormat`, so a user who
  /// has chosen a clock the phone disagrees with gets the wrong picker unless
  /// the query is overridden on the way in.
  static Widget withClock(BuildContext context, Widget child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(alwaysUse24HourFormat: use24Hour(context)),
    child: child,
  );
}
