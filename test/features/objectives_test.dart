import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/objectives/services/objectives_service.dart';

import '../helpers/test_database.dart';

/// What counts toward a goal.
///
/// Progress used to sum every linked row, whatever its state, which was the
/// last money surface in the app not going through the shared policy. An unpaid
/// bill scheduled for next month already counted, so a goal could report itself
/// complete on money that had not left anyone's account.
///
/// Transfers are the deliberate difference from how budgets and reports read
/// the same rows. Those ask what was earned and spent, and moving your own
/// money between your own accounts is neither. A goal asks how much has been
/// set aside, and moving money into savings is exactly how that is done.
void main() {
  late AppDatabase db;
  late ObjectivesService service;
  late String walletId;
  late String savingsId;

  setUp(() async {
    db = openTestDatabase();
    service = ObjectivesService(database: db);
    walletId = await seedWallet(db, name: 'Everyday', openingBalance: 500000);
    savingsId = await seedWallet(db, name: 'Savings');
  });

  tearDown(() => db.close());

  Future<String> goal({int target = 100000, DateTime? endDate}) =>
      service.createObjective(
        name: 'New laptop',
        targetAmount: target,
        type: 'goal',
        startDate: DateTime(2026, 1, 1),
        endDate: endDate,
      );

  test('a paid contribution counts', () async {
    final id = await goal();
    final txn = await seedTransaction(
      db,
      walletId: walletId,
      amount: 25000,
      date: DateTime(2026, 1, 5),
    );
    await service.linkTransaction(id, txn);

    final progress = await service.getObjectiveWithProgress(id);
    expect(progress.currentAmount, 25000);
    expect(progress.remainingAmount, 75000);
    expect(progress.isComplete, isFalse);
  });

  test('an unpaid bill scheduled for later does not', () async {
    final id = await goal();
    final txn = await seedTransaction(
      db,
      walletId: walletId,
      amount: 100000,
      date: DateTime(2026, 2, 1),
      isPaid: false,
      specialType: TransactionSpecialType.upcoming,
    );
    await service.linkTransaction(id, txn);

    final progress = await service.getObjectiveWithProgress(id);
    expect(
      progress.currentAmount,
      0,
      reason:
          'a goal that reports itself complete on money that has not moved is '
          'worse than one that reports nothing',
    );
    expect(progress.isComplete, isFalse);
  });

  test('money moved into savings counts', () async {
    final id = await goal();
    final txn = await seedTransaction(
      db,
      walletId: savingsId,
      amount: 40000,
      date: DateTime(2026, 1, 8),
      transactionType: 'transfer',
      isIncome: true,
    );
    await service.linkTransaction(id, txn);

    final progress = await service.getObjectiveWithProgress(id);
    expect(
      progress.currentAmount,
      40000,
      reason:
          'excluding transfers, as budgets do, would hide the most common way '
          'of funding a goal from the goal itself',
    );
  });

  test('a deleted transaction stops counting', () async {
    final id = await goal();
    final txn = await seedTransaction(
      db,
      walletId: walletId,
      amount: 30000,
      date: DateTime(2026, 1, 5),
    );
    await service.linkTransaction(id, txn);
    await db.softDeleteTransaction(txn);

    expect((await service.getObjectiveWithProgress(id)).currentAmount, 0);
  });

  test('unlinking removes it from the goal but keeps the transaction', () async {
    final id = await goal();
    final txn = await seedTransaction(
      db,
      walletId: walletId,
      amount: 30000,
      date: DateTime(2026, 1, 5),
    );
    await service.linkTransaction(id, txn);
    await service.unlinkTransaction(id, txn);

    expect((await service.getObjectiveWithProgress(id)).currentAmount, 0);
    expect(
      await db.findTransactionById(txn),
      isNotNull,
      reason: 'detaching a transaction from a goal must not delete it',
    );
  });

  test('deleting a goal detaches its transactions rather than removing them', () async {
    final id = await goal();
    final txn = await seedTransaction(
      db,
      walletId: walletId,
      amount: 30000,
      date: DateTime(2026, 1, 5),
    );
    await service.linkTransaction(id, txn);

    await service.deleteObjective(id);

    final kept = await db.findTransactionById(txn);
    expect(kept, isNotNull);
    expect(kept!.objectiveId, isNull);
  });

  test('a deadline gives a daily amount, without one there is none', () async {
    final dated = await goal(endDate: DateTime.now().add(const Duration(days: 10)));
    final open = await goal();

    expect(
      (await service.getObjectiveWithProgress(dated)).dailyTargetCents,
      isNotNull,
    );
    expect(
      (await service.getObjectiveWithProgress(open)).dailyTargetCents,
      isNull,
      reason: 'with no date there is nothing to be on schedule for',
    );
  });

  test('progress never reports more than complete', () async {
    final id = await goal(target: 10000);
    final txn = await seedTransaction(
      db,
      walletId: walletId,
      amount: 90000,
      date: DateTime(2026, 1, 5),
    );
    await service.linkTransaction(id, txn);

    final progress = await service.getObjectiveWithProgress(id);
    expect(progress.progressPercent, 100);
    expect(progress.isComplete, isTrue);
  });

  group('working out what it takes to finish', () {
    test('a deadline gives a payment count and a payment size', () async {
      final id = await goal(
        target: 120000,
        endDate: DateTime.now().add(const Duration(days: 90)),
      );
      final progress = await service.getObjectiveWithProgress(id);

      final plan = progress.planForDeadline(InstallmentCadence.monthly);

      expect(plan, isNotNull);
      expect(plan!.payments, 3);
      expect(plan.amountCents, 40000);
    });

    test('the payment is rounded up so the last one is never short', () async {
      final id = await goal(
        target: 100000,
        endDate: DateTime.now().add(const Duration(days: 90)),
      );
      final progress = await service.getObjectiveWithProgress(id);

      final plan = progress.planForDeadline(InstallmentCadence.monthly)!;

      expect(plan.payments, 3);
      expect(
        plan.amountCents * plan.payments,
        greaterThanOrEqualTo(100000),
        reason:
            'rounding down would leave the goal a few pence short after every '
            'payment had been made, which is the one outcome nobody wants',
      );
    });

    test('what is already saved is taken off the plan', () async {
      final id = await goal(
        target: 120000,
        endDate: DateTime.now().add(const Duration(days: 60)),
      );
      final txn = await seedTransaction(
        db,
        walletId: walletId,
        amount: 60000,
        date: DateTime(2026, 1, 5),
      );
      await service.linkTransaction(id, txn);

      final progress = await service.getObjectiveWithProgress(id);
      final plan = progress.planForDeadline(InstallmentCadence.monthly)!;

      expect(plan.payments, 2);
      expect(plan.amountCents, 30000);
    });

    test('no deadline means no plan to work back from', () async {
      final id = await goal(target: 50000);
      final progress = await service.getObjectiveWithProgress(id);

      expect(progress.planForDeadline(InstallmentCadence.monthly), isNull);
    });

    test('read the other way, a payment gives a number of payments', () async {
      final id = await goal(target: 100000);
      final progress = await service.getObjectiveWithProgress(id);

      final plan = progress.planForPayment(InstallmentCadence.weekly, 15000)!;

      expect(
        plan.payments,
        7,
        reason: 'seven payments of 15000 is the first that clears 100000',
      );
    });

    test('a goal already reached needs no plan', () async {
      final id = await goal(target: 10000);
      final txn = await seedTransaction(
        db,
        walletId: walletId,
        amount: 20000,
        date: DateTime(2026, 1, 5),
      );
      await service.linkTransaction(id, txn);

      final progress = await service.getObjectiveWithProgress(id);
      expect(progress.planForDeadline(InstallmentCadence.monthly), isNull);
      expect(progress.planForPayment(InstallmentCadence.monthly, 5000), isNull);
    });
  });
}
