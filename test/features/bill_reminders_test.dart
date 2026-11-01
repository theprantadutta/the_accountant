import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/wallet.dart';
import 'package:the_accountant/features/notifications/services/bill_reminders.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';

import '../helpers/test_database.dart';

/// Card-bill and plan reminders, which the phone sends itself from 5.0.
void main() {
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
  });

  tearDown(() => db.close());

  /// A credit card whose statement closes on the 5th and is due on the 20th.
  Future<String> seedCard() async {
    final card = await seedWallet(db, name: 'SCB Credit', currency: 'BDT');
    await db.customStatement(
      'UPDATE wallets SET wallet_type = ?, billing_cycle_day = 5, '
      'payment_due_day = 20, due_reminder_days = 3 WHERE id = ?',
      [WalletType.creditCard.index, card],
    );
    return card;
  }

  Future<List<BillReminder>> runAt(DateTime now) async {
    final shown = <BillReminder>[];
    await BillReminders.run(
      db: db,
      prefs: await SharedPreferences.getInstance(),
      now: now,
      money: (m, _) => '৳${m ~/ 100}',
      date: (d) => '${d.day}/${d.month}',
      show: (r) async => shown.add(r),
    );
    return shown;
  }

  test(
    'a card bill is announced the configured days before it is due',
    () async {
      final card = await seedCard();
      await seedTransaction(
        db,
        walletId: card,
        amount: 450000,
        date: DateTime(2026, 11, 2),
      );

      final shown = await runAt(DateTime(2026, 11, 17, 10));

      expect(
        shown.map((r) => r.title),
        contains('SCB Credit bill is due in 3 days'),
      );
      expect(shown.single.body, 'Pay ৳4500 by 20/11.');
    },
  );

  test('each reminder is said once, however often the task runs', () async {
    final card = await seedCard();
    await seedTransaction(
      db,
      walletId: card,
      amount: 450000,
      date: DateTime(2026, 11, 2),
    );

    await runAt(DateTime(2026, 11, 17, 10));
    final again = await runAt(DateTime(2026, 11, 17, 11));

    expect(again, isEmpty);
  });

  test('a paid bill gets no payment reminder', () async {
    final card = await seedCard();
    await seedTransaction(
      db,
      walletId: card,
      amount: 450000,
      date: DateTime(2026, 11, 2),
    );
    await seedTransaction(
      db,
      walletId: card,
      amount: 450000,
      isIncome: true,
      date: DateTime(2026, 11, 10),
    );

    final shown = await runAt(DateTime(2026, 11, 17, 10));

    expect(shown.where((r) => r.title.contains('due')), isEmpty);
  });

  test('nothing before eight in the morning', () async {
    final card = await seedCard();
    await seedTransaction(
      db,
      walletId: card,
      amount: 450000,
      date: DateTime(2026, 11, 2),
    );

    expect(await runAt(DateTime(2026, 11, 17, 6)), isEmpty);
  });

  test('the bill reminders switch turns them all off', () async {
    SharedPreferences.setMockInitialValues({
      BillReminders.enabledPrefKey: false,
    });
    final card = await seedCard();
    await seedTransaction(
      db,
      walletId: card,
      amount: 450000,
      date: DateTime(2026, 11, 2),
    );

    expect(await runAt(DateTime(2026, 11, 17, 10)), isEmpty);
  });

  test('a plan installment is announced before its day', () async {
    final wallet = await seedWallet(db, name: 'DBBL Savings', currency: 'BDT');
    await PlanService(db).create(
      PlanDraft(
        kind: PlanKind.emi,
        name: 'Walton fridge EMI',
        walletId: wallet,
        startDate: DateTime(2026, 12, 1, 10),
        installmentAmount: 500000,
        installmentCount: 12,
        reminderDaysBefore: 3,
      ),
    );

    final shown = await runAt(DateTime(2026, 11, 28, 10));

    expect(
      shown.map((r) => r.title),
      contains('Walton fridge EMI: installment 1 of 12 due in 3 days'),
    );
  });
}
