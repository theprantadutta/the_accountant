import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/amount_converter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/reports/domain/daily_net.dart';

import '../helpers/test_database.dart';

/// The calendar behind the heatmap.
///
/// Neither app this one is measured against gets the question right on its own
/// terms: a square has to mean the same thing as every other spending figure in
/// the app, or the picture and the numbers disagree and the picture is the one
/// people believe.
void main() {
  late AppDatabase db;
  late String wallet;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db, name: 'Everyday');
  });

  tearDown(() => db.close());

  Future<DailyNetCalendar> calendarFor(DateTime from, DateTime to) async =>
      DailyNetCalendar.build(
        transactions: await db.getAllTransactions(),
        from: from,
        to: to,
        converter: await AmountConverter.forDatabase(db),
      );

  /// A calendar reads a year of transactions across every account, and those
  /// accounts need not agree on a currency. Amounts were summed raw and the
  /// total labelled in the default currency, so a taka expense counted the same
  /// as a dollar one — the net, the busiest day and every square's shading were
  /// all wrong for anyone holding money in two places.
  group('accounts in different currencies', () {
    test('amounts are converted before they are added', () async {
      final taka = await seedWallet(db, name: 'bKash', currency: 'BDT');
      await db.setCustomRate('BDT', 'USD', 0.01);
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 10000,
        date: DateTime(2026, 3, 2),
      );
      await seedTransaction(
        db,
        walletId: taka,
        amount: 10000,
        date: DateTime(2026, 3, 2),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 3),
      );

      expect(calendar.currency, 'USD');
      expect(
        calendar.days
            .firstWhere((d) => d.day == DateTime(2026, 3, 2))
            .expenseCents,
        10100,
        reason: 'ten thousand taka is a hundred dollars, not ten thousand',
      );
      expect(calendar.excluded, 0);
    });

    test('a row with no known rate is left out and counted', () async {
      final taka = await seedWallet(db, name: 'bKash', currency: 'BDT');
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 10000,
        date: DateTime(2026, 3, 2),
      );
      await seedTransaction(
        db,
        walletId: taka,
        amount: 10000,
        date: DateTime(2026, 3, 2),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 3),
      );

      expect(
        calendar.days
            .firstWhere((d) => d.day == DateTime(2026, 3, 2))
            .expenseCents,
        10000,
        reason: 'adding an unconvertible amount as though it were dollars is '
            'wrong by a factor of a hundred and looks exactly as settled as a '
            'correct figure',
      );
      expect(
        calendar.excluded,
        1,
        reason: 'a calendar quietly missing a month of spending looks like a '
            'quiet month',
      );
    });
  });

  group('what a square counts', () {
    test('earning and spending on the same day net off', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 10000,
        isIncome: true,
        date: DateTime(2026, 3, 4),
      );
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 4000,
        date: DateTime(2026, 3, 4),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 4),
        DateTime(2026, 3, 4),
      );

      expect(calendar.days.single.incomeCents, 10000);
      expect(calendar.days.single.expenseCents, 4000);
      expect(calendar.days.single.netCents, 6000);
    });

    test('the time of day does not split a square', () async {
      for (final hour in [1, 13, 23]) {
        await seedTransaction(
          db,
          walletId: wallet,
          amount: 1000,
          date: DateTime(2026, 3, 4, hour, 30),
        );
      }

      final calendar = await calendarFor(
        DateTime(2026, 3, 4),
        DateTime(2026, 3, 4),
      );

      expect(calendar.days, hasLength(1));
      expect(calendar.days.single.expenseCents, 3000);
    });

    test('a transfer is neither earned nor spent', () async {
      final other = await seedWallet(db, name: 'Savings');
      final transferCategory = await db.requireSystemCategoryId(
        SystemCategories.transferKey,
      );
      // A transfer is identified by its kind, not by the category it is filed
      // under — a row in the transfer category that is not a transfer is an
      // ordinary transaction and should count.
      await seedTransaction(
        db,
        walletId: wallet,
        categoryId: transferCategory,
        transactionType: 'transfer',
        amount: 50000,
        date: DateTime(2026, 3, 4),
      );
      await seedTransaction(
        db,
        walletId: other,
        categoryId: transferCategory,
        transactionType: 'transfer',
        amount: 50000,
        isIncome: true,
        date: DateTime(2026, 3, 4),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 4),
        DateTime(2026, 3, 4),
      );

      expect(
        calendar.days.single.isEmpty,
        isTrue,
        reason:
            'moving your own money between your own accounts is not a day of '
            'spending, and the budgets and the reports already agree on that',
      );
    });

    test('a bill that has not been paid did not happen yet', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 9000,
        isPaid: false,
        specialType: TransactionSpecialType.upcoming,
        date: DateTime(2026, 3, 4),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 4),
        DateTime(2026, 3, 4),
      );

      expect(calendar.days.single.isEmpty, isTrue);
    });

    test('a deleted transaction leaves no mark', () async {
      final id = await seedTransaction(
        db,
        walletId: wallet,
        amount: 2500,
        date: DateTime(2026, 3, 4),
      );
      await db.softDeleteTransaction(id);

      final calendar = await calendarFor(
        DateTime(2026, 3, 4),
        DateTime(2026, 3, 4),
      );

      expect(calendar.days.single.isEmpty, isTrue);
    });
  });

  group('the shape of the calendar', () {
    test('a day nothing happened on is still a day', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 1000,
        date: DateTime(2026, 3, 1),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 7),
      );

      expect(
        calendar.days,
        hasLength(7),
        reason: 'a gap in a calendar has to be drawn, not skipped',
      );
      expect(calendar.days.skip(1).every((d) => d.isEmpty), isTrue);
    });

    test('a month boundary is crossed correctly', () async {
      final calendar = await calendarFor(
        DateTime(2026, 1, 30),
        DateTime(2026, 2, 2),
      );

      expect(calendar.days.map((d) => d.day), [
        DateTime(2026, 1, 30),
        DateTime(2026, 1, 31),
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 2),
      ]);
    });

    test('a leap day is not skipped', () async {
      final calendar = await calendarFor(
        DateTime(2028, 2, 28),
        DateTime(2028, 3, 1),
      );

      expect(calendar.days.map((d) => d.day.day), [28, 29, 1]);
    });

    test('anything outside the range is ignored', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 5000,
        date: DateTime(2026, 2, 28),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 3),
      );

      expect(calendar.isEmpty, isTrue);
    });

    test('the running total is what the range did overall', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 10000,
        isIncome: true,
        date: DateTime(2026, 3, 1),
      );
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 2500,
        date: DateTime(2026, 3, 2),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 3),
      );

      expect(calendar.totalNetCents, 7500);
    });
  });

  group('how strongly a day is shaded', () {
    test('the busiest day in range is the full strength', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 10000,
        date: DateTime(2026, 3, 1),
      );
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 2000,
        date: DateTime(2026, 3, 2),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 2),
      );
      final heaviest = calendar.shade(calendar.days.first);
      final lighter = calendar.shade(calendar.days.last);

      expect(heaviest.weight, 1.0);
      expect(heaviest.spent, isTrue);
      expect(lighter.weight, lessThan(heaviest.weight));
    });

    test('a day with any activity is never invisible', () async {
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 1000000,
        date: DateTime(2026, 3, 1),
      );
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 1,
        date: DateTime(2026, 3, 2),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 2),
      );

      expect(
        calendar.shade(calendar.days.last).weight,
        greaterThanOrEqualTo(0.2),
        reason:
            'a square that rounds to the empty colour tells the user nothing '
            'happened, which is a different claim from "not much did"',
      );
    });

    test('an empty day has no shade at all', () async {
      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 1),
      );

      expect(calendar.shade(calendar.days.single).weight, 0);
    });

    test('earning and spending are scaled apart', () async {
      // One huge spend must not flatten every earning day to nothing.
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 1000000,
        date: DateTime(2026, 3, 1),
      );
      await seedTransaction(
        db,
        walletId: wallet,
        amount: 5000,
        isIncome: true,
        date: DateTime(2026, 3, 2),
      );

      final calendar = await calendarFor(
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 2),
      );
      final earned = calendar.shade(calendar.days.last);

      expect(earned.spent, isFalse);
      expect(
        earned.weight,
        1.0,
        reason: 'it is the biggest earning day, whatever the spending was',
      );
    });
  });
}
