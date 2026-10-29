import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/cards/domain/card_statement.dart';

import '../helpers/test_database.dart';

/// Credit card bills, worked out from the card's own transactions.
///
/// The same rules the server sends its reminders by (see the backend's
/// NotificationJobTests), so the amount and date on the screen are the ones
/// in the notification.
void main() {
  group('where the dates fall', () {
    test('the last statement is the one that has closed', () {
      expect(
        CardCycle.lastStatementBefore(DateTime(2026, 10, 24), 13),
        DateTime(2026, 10, 13),
      );
      // Today's statement closes at the end of today.
      expect(
        CardCycle.lastStatementBefore(DateTime(2026, 10, 13, 22), 13),
        DateTime(2026, 9, 13),
      );
      // A short month closes on its last day.
      expect(
        CardCycle.lastStatementBefore(DateTime(2026, 3, 1), 31),
        DateTime(2026, 2, 28),
      );
      expect(
        CardCycle.lastStatementBefore(DateTime(2026, 1, 5), 13),
        DateTime(2025, 12, 13),
      );
    });

    test('the due date is the first due day after the statement', () {
      expect(
        CardCycle.dueDateAfter(DateTime(2026, 10, 13), 3),
        DateTime(2026, 11, 3),
      );
      expect(
        CardCycle.dueDateAfter(DateTime(2026, 10, 5), 25),
        DateTime(2026, 10, 25),
      );
      expect(
        CardCycle.dueDateAfter(DateTime(2026, 10, 13), 13),
        DateTime(2026, 11, 13),
      );
      expect(
        CardCycle.dueDateAfter(DateTime(2026, 12, 20), 5),
        DateTime(2027, 1, 5),
      );
    });
  });

  group('the bill', () {
    late AppDatabase db;
    late String cardId;

    setUp(() async {
      db = openTestDatabase();
      cardId = await seedWallet(db, name: 'SCB Credit', currency: 'BDT');
      await (db.update(db.wallets)..where((w) => w.id.equals(cardId))).write(
        const WalletsCompanion(
          walletType: Value(WalletType.creditCard),
          billingCycleDay: Value(13),
          paymentDueDay: Value(3),
          dueReminderDays: Value(3),
        ),
      );
    });

    tearDown(() => db.close());

    Future<CardBill> billOn(DateTime today) async => CardBill.of(
      (await db.findWalletById(cardId))!,
      await db.getTransactionsByWallet(cardId),
      today: today,
    );

    Future<void> charge(int cents, DateTime date) =>
        seedTransaction(db, walletId: cardId, amount: cents, date: date);
    Future<void> pay(int cents, DateTime date) => seedTransaction(
      db,
      walletId: cardId,
      amount: cents,
      isIncome: true,
      date: date,
    );

    test('is what was owed at the close, less what was paid since', () async {
      await charge(20000, DateTime(2026, 10, 2, 12));
      // Late on the statement day still counts.
      await charge(50000, DateTime(2026, 10, 13, 23, 30));
      // The next cycle.
      await charge(9000, DateTime(2026, 10, 14, 0, 30));
      await pay(30000, DateTime(2026, 10, 20));

      final bill = await billOn(DateTime(2026, 10, 24));

      expect(bill.latest!.statementDate, DateTime(2026, 10, 13));
      expect(bill.latest!.dueDate, DateTime(2026, 11, 3));
      expect(bill.latest!.owed, 70000);
      expect(bill.latest!.paid, 30000);
      expect(bill.latest!.remaining, 40000);
      expect(bill.spentThisCycle, 9000);
      expect(bill.nextStatementDate, DateTime(2026, 11, 13));
      expect(bill.status, CardBillStatus.due);
    });

    test('is due soon inside the reminder window, and overdue after', () async {
      await charge(10000, DateTime(2026, 10, 10));
      expect(
        (await billOn(DateTime(2026, 10, 31))).status,
        CardBillStatus.dueSoon,
      );
      expect(
        (await billOn(DateTime(2026, 11, 3))).status,
        CardBillStatus.dueSoon,
      );
      expect(
        (await billOn(DateTime(2026, 11, 4))).status,
        CardBillStatus.overdue,
      );
    });

    test('paid in full reads as paid', () async {
      await charge(10000, DateTime(2026, 10, 10));
      await pay(10000, DateTime(2026, 10, 15));
      final bill = await billOn(DateTime(2026, 10, 31));
      expect(bill.status, CardBillStatus.paid);
      expect(bill.latest!.remaining, 0);
    });

    test('a card that owed nothing has nothing due', () async {
      final bill = await billOn(DateTime(2026, 10, 31));
      expect(bill.status, CardBillStatus.nothingDue);
    });

    test('earlier statements say whether they were paid', () async {
      await charge(10000, DateTime(2026, 9, 1));
      await pay(10000, DateTime(2026, 9, 20));
      await charge(5000, DateTime(2026, 10, 1));
      final bill = await billOn(DateTime(2026, 10, 24));

      expect(bill.latest!.owed, 5000);
      final september = bill.history.single;
      expect(september.statementDate, DateTime(2026, 9, 13));
      expect(september.owed, 10000);
      expect(september.isSettled, isTrue);
    });

    test('without both days there is no bill', () async {
      await (db.update(db.wallets)..where((w) => w.id.equals(cardId))).write(
        const WalletsCompanion(paymentDueDay: Value(null)),
      );
      final bill = await billOn(DateTime(2026, 10, 24));
      expect(bill.status, CardBillStatus.notSetUp);
      expect(bill.latest, isNull);
    });
  });
}
