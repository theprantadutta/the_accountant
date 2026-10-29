import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';

/// A zakat reminder that is due to be shown.
class ZakatReminder {
  const ZakatReminder({required this.date, required this.daysLeft});

  /// The zakat date it is about.
  final DateTime date;

  /// 0 on the day itself.
  final int daysLeft;

  bool get isToday => daysLeft == 0;

  /// One per zakat date and stage, so each is shown once.
  String get key =>
      '${isToday ? 'day' : 'before'}:${ZakatCalendar.dayKey(date)}';

  /// The text of the notification. In English, like the app's other
  /// reminders worked out in the background, where there is no locale.
  String get title => isToday
      ? 'Your zakat is due today'
      : 'Zakat due in $daysLeft day${daysLeft == 1 ? '' : 's'}';

  String get body => isToday
      ? 'Your zakat year completes today. Tap to see what is due.'
      : 'Your zakat year completes on '
            '${DateFormat('EEEE, MMM d').format(date)}. Tap to see what is due.';

  /// What a tap opens: the zakat screen.
  static const Map<String, String> payload = {'action': 'open_zakat'};
}

/// When to remind about the zakat date: a few days before it, and on it.
class ZakatReminders {
  const ZakatReminders._();

  /// How many days before the zakat date the first reminder comes.
  static const int daysBefore = 3;

  static const String _sentKey = 'zakat_reminder_sent';

  /// One notification id for both, so the day's replaces the early one.
  static const int notificationId = 8700;

  /// The reminder due on [today], if any, whether or not it was shown.
  ///
  /// The early one is due anywhere in the last [daysBefore] days, so a phone
  /// that did not run its check on the third day still says something.
  static ZakatReminder? dueOn(ZakatSettings settings, DateTime today) {
    final anchor = settings.zakatDate;
    // Somebody who does not pay zakat is never reminded of it.
    if (anchor == null || !settings.remind || settings.optedOut) return null;
    final (last, next) = ZakatCalendar.around(anchor, today);
    if (_sameDay(last, today)) return ZakatReminder(date: last, daysLeft: 0);
    final days = DateTime.utc(
      next.year,
      next.month,
      next.day,
    ).difference(DateTime.utc(today.year, today.month, today.day)).inDays;
    if (days <= daysBefore) return ZakatReminder(date: next, daysLeft: days);
    return null;
  }

  /// The reminder to show now, marked as shown; null when there is none or
  /// it has already been shown.
  ///
  /// Called from the background check and whenever the app is opened, which
  /// is why it has to remember: either may get there first.
  static Future<ZakatReminder?> take({
    SharedPreferences? prefs,
    DateTime? now,
  }) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    // The other side may have just shown it; each keeps its own cached copy.
    await p.reload();
    final settings = await ZakatSettingsStore.load(p);
    final reminder = dueOn(settings, now ?? DateTime.now());
    if (reminder == null || p.getString(_sentKey) == reminder.key) return null;
    await p.setString(_sentKey, reminder.key);
    return reminder;
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
