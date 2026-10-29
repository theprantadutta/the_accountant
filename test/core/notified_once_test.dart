import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/notified_once.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';
import 'package:the_accountant/features/notifications/services/local_notification_log.dart';

/// A reminder is posted once however often the checks run, and the inbox
/// keeps one row for a notice said twice.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  final now = DateTime(2030, 3, 1, 9);

  group('NotifiedOnce', () {
    test('a key is claimed once', () async {
      expect(await NotifiedOnce.claim('due:a:2030-03-02', now: now), isTrue);
      expect(await NotifiedOnce.claim('due:a:2030-03-02', now: now), isFalse);
      expect(
        await NotifiedOnce.claim(
          'due:a:2030-03-02',
          now: now.add(const Duration(days: 3)),
        ),
        isFalse,
      );
      expect(await NotifiedOnce.claim('due:b:2030-03-02', now: now), isTrue);
    });

    test('with a period, again once it has passed', () async {
      const day = Duration(days: 1);
      expect(
        await NotifiedOnce.claim('overdue:x', every: day, now: now),
        isTrue,
      );
      expect(
        await NotifiedOnce.claim(
          'overdue:x',
          every: day,
          now: now.add(const Duration(hours: 5)),
        ),
        isFalse,
      );
      expect(
        await NotifiedOnce.claim('overdue:x', every: day, now: now.add(day)),
        isTrue,
      );
    });

    test('old marks are forgotten', () async {
      await NotifiedOnce.claim('due:a', now: now);
      await NotifiedOnce.claim('due:b', now: now.add(const Duration(days: 61)));

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(NotifiedOnce.storageKey),
        isNot(contains('due:a')),
      );
    });
  });

  group('inbox', () {
    Future<void> say(String body, DateTime at) => LocalNotificationLog.record(
      type: NotificationType.budgetWarning,
      title: 'Budget alert',
      body: body,
      now: at,
    );

    test('the same notice twice in a day is one row, the latest', () async {
      await say('93%', now);
      await say('93%', now.add(const Duration(minutes: 1)));

      final items = await LocalNotificationLog.read();
      expect(items, hasLength(1));
      expect(items.single.createdAt, now.add(const Duration(minutes: 1)));
    });

    test(
      'a different notice, or the same a day later, is its own row',
      () async {
        await say('83%', now);
        await say('93%', now.add(const Duration(hours: 1)));
        await say('93%', now.add(const Duration(days: 2)));

        expect(await LocalNotificationLog.read(), hasLength(3));
      },
    );
  });
}
