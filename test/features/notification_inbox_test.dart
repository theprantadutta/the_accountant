import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/app_destination.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';

/// The notifications inbox, which always said 0.
///
/// The server writes snake_case with snake_case enum values, and the inbox
/// only read camelCase, so every row it sent failed to parse.
void main() {
  test('reads a row the way the server writes it', () {
    final item = NotificationItem.fromJson({
      'id': 'n1',
      'user_id': 'u1',
      'type': 'card_payment_due',
      'title': 'SCB Credit bill is due in 3 days',
      'body': 'Pay ৳600.00 by Tuesday, Nov 3.',
      'data': '{"action":"open_card_bills"}',
      'status': 'sent',
      'sent_at': '2026-10-31T04:00:05Z',
      'read_at': null,
      'created_at': '2026-10-31T04:00:00Z',
    });

    expect(item.type, NotificationType.cardPaymentDue);
    expect(item.status, NotificationStatus.sent);
    expect(item.isRead, isFalse);
    expect(item.userId, 'u1');
    expect(item.createdAt.toUtc(), DateTime.utc(2026, 10, 31, 4));
  });

  test('still reads the older shape', () {
    final item = NotificationItem.fromJson({
      'id': 'n2',
      'userId': 'u1',
      'type': 'DailyReminder',
      'title': 't',
      'body': 'b',
      'status': 'Read',
      'createdAt': '2026-10-31T04:00:00Z',
    });
    expect(item.type, NotificationType.dailyReminder);
    expect(item.isRead, isTrue);
  });

  test('a phone-made notification round-trips for the local log', () {
    final item = NotificationItem(
      id: 'local-1',
      userId: '',
      type: NotificationType.budgetWarning,
      title: 'Budget alert: Food',
      body: 'You have used 82% of your Food budget.',
      status: NotificationStatus.sent,
      createdAt: DateTime(2026, 10, 24, 9),
      isLocal: true,
    );
    final back = NotificationItem.fromJson(item.toJson());
    expect(back.isLocal, isTrue);
    expect(back.type, NotificationType.budgetWarning);
    expect(back.createdAt, item.createdAt);
  });

  group('a tapped notification goes', () {
    test('to the card it is about', () {
      expect(
        NotificationService.linkFor({
          'action': 'open_card_bills',
          'walletId': 'w1',
        }),
        const DeepLink(AppDestination.cardBills, entityId: 'w1'),
      );
    });

    test('to adding a transaction, for the daily reminder', () {
      expect(
        NotificationService.linkFor({'action': 'open_add_transaction'}),
        const DeepLink(AppDestination.addExpense),
      );
    });

    test('to the transaction a due reminder names', () {
      expect(
        NotificationService.linkFor({'transactionId': 't1', 'type': 'upcoming'}),
        const DeepLink(AppDestination.transactionDetail, entityId: 't1'),
      );
    });

    test('to the inbox otherwise', () {
      expect(
        NotificationService.linkFor(const {}),
        const DeepLink(AppDestination.notifications),
      );
    });
  });
}
