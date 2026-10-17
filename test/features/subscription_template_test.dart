import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

import '../helpers/test_database.dart';

/// A subscription's schedule owns what its future payments look like.
///
/// The price and the account used to live on the base transaction — the first
/// real payment — so changing either rewrote that payment, and switching the
/// card a subscription is paid from moved last year's charge onto the new
/// card. And every payment was recorded as paid on its due date, at the base
/// amount, with no chance to say what was actually charged.
void main() {
  late AppDatabase db;
  late RecurringService service;
  late String everyday;
  late String card;
  late String base;

  setUp(() async {
    db = openTestDatabase();
    service = RecurringService(database: db);
    everyday = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    card = await seedWallet(db, name: 'Card', openingBalance: 100000);
    base = await seedTransaction(
      db,
      walletId: everyday,
      amount: 2500,
      title: 'Streaming',
      date: DateTime(2026, 1, 6),
      specialType: TransactionSpecialType.subscription,
    );
  });

  tearDown(() => db.close());

  Future<String> schedule({bool autoPay = true}) async {
    final id = await service.createRecurringConfig(
      baseTransactionId: base,
      reoccurrence: 'monthly',
      startDate: DateTime(2026, 1, 6),
      autoPay: autoPay,
    );
    // Make exactly one payment due.
    await (db.update(db.recurringConfigs)..where((r) => r.id.equals(id))).write(
      RecurringConfigsCompanion(
        nextOccurrence: Value(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ),
    );
    return id;
  }

  Future<int> balance(String wallet) =>
      WalletBalanceService(db).calculateWalletBalance(wallet);

  Future<Transaction> onlyInstance(String configId) async =>
      (await db.getRecurringInstances(configId)).single;

  test('a new price and account apply to the next payment and leave the '
      'first one as it was', () async {
    final id = await schedule();
    await service.updateRecurringConfig(
      configId: id,
      amount: 3000,
      walletId: card,
    );

    await service.processRecurringTransactions();

    final payment = await onlyInstance(id);
    expect(payment.amount, 3000);
    expect(payment.walletId, card);
    final first = (await db.findTransactionById(base))!;
    expect(first.amount, 2500);
    expect(first.walletId, everyday);
    expect(await balance(card), 100000 - 3000);
  });

  test('a schedule that asks first leaves the payment waiting, moving no '
      'money until it is confirmed', () async {
    final id = await schedule(autoPay: false);

    await service.processRecurringTransactions();

    final waiting = await onlyInstance(id);
    expect(waiting.isPaid, isFalse);
    expect(TransactionPolicy.isForecast(waiting), isTrue);
    expect(TransactionPolicy.countsInAnalytics(waiting), isFalse);
    expect(await balance(everyday), 100000 - 2500, reason: 'only the first');
    expect((await db.getPaymentsAwaitingConfirmation()).map((t) => t.id), [
      waiting.id,
    ]);

    // What the card was really charged this month.
    await db.markTransactionAsPaid(waiting.id, amount: 2650);
    await WalletBalanceService(db).updateWalletBalance(everyday);

    final paid = (await db.findTransactionById(waiting.id))!;
    expect(paid.amount, 2650);
    expect(TransactionPolicy.countsInAnalytics(paid), isTrue);
    expect(await balance(everyday), 100000 - 2500 - 2650);
    expect(await db.getPaymentsAwaitingConfirmation(), isEmpty);
  });

  test('a skipped payment moves no money and stops waiting', () async {
    final id = await schedule(autoPay: false);
    await service.processRecurringTransactions();
    final waiting = await onlyInstance(id);

    await db.skipTransaction(waiting.id);

    expect(await db.getPaymentsAwaitingConfirmation(), isEmpty);
    expect(await balance(everyday), 100000 - 2500);
  });

  group('changing the schedule', () {
    Future<DateTime> nextOf(String id) async =>
        (await db.findRecurringConfigById(id))!.nextOccurrence;

    test('saving it unchanged does not move the next payment', () async {
      final id = await service.createRecurringConfig(
        baseTransactionId: base,
        reoccurrence: 'monthly',
        startDate: DateTime(2024, 1, 6),
      );
      // Whole seconds, which is what the column stores.
      final soon = DateTime.now().add(const Duration(days: 9));
      final next = DateTime(
        soon.year,
        soon.month,
        soon.day,
        soon.hour,
        soon.minute,
        soon.second,
      );
      await (db.update(db.recurringConfigs)..where((r) => r.id.equals(id)))
          .write(RecurringConfigsCompanion(nextOccurrence: Value(next)));

      // The edit sheet always sends the cadence back.
      await service.updateRecurringConfig(
        configId: id,
        reoccurrence: 'monthly',
        periodLength: 1,
        amount: 3000,
      );

      expect(await nextOf(id), next);
      expect(
        await service.processRecurringTransactions(),
        0,
        reason: 'nothing since 2024 is back-filled',
      );
    });

    test('a new cadence moves the next payment ahead, never behind', () async {
      final id = await service.createRecurringConfig(
        baseTransactionId: base,
        reoccurrence: 'monthly',
        startDate: DateTime(2024, 1, 6),
      );

      await service.updateRecurringConfig(configId: id, reoccurrence: 'weekly');

      final next = await nextOf(id);
      expect(next.isAfter(DateTime.now()), isTrue);
      expect(
        next.isBefore(DateTime.now().add(const Duration(days: 8))),
        isTrue,
      );
      expect(await service.processRecurringTransactions(), 0);
    });
  });
}
