import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';

import '../helpers/test_database.dart';

/// Moving money between accounts held in different currencies.
///
/// This was refused outright, and refusing was the honest answer at the time:
/// the two legs carried one figure, so writing 100 into a dollar account and a
/// taka account alike would have turned $100 into 100 taka — inventing nine
/// tenths of the money and reporting a loss of nothing at all. But it left
/// anyone with accounts in two places unable to record a movement they had
/// really made.
///
/// Now each leg carries its own currency's amount, what the other side
/// received, and the rate between them. The rate is stored rather than looked
/// up again: rates move, and recomputing would restate what a past transfer
/// cost.
void main() {
  late AppDatabase db;
  late TransferService service;
  late String dollars;
  late String euros;
  late String moreDollars;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = TransferService(db);
    dollars = await seedWallet(
      db,
      name: 'Checking',
      currency: 'USD',
      openingBalance: 1000000,
    );
    moreDollars = await seedWallet(
      db,
      name: 'Savings',
      currency: 'USD',
      openingBalance: 1000000,
    );
    euros = await seedWallet(
      db,
      name: 'Holiday',
      currency: 'EUR',
      openingBalance: 0,
    );
  });

  tearDown(() => db.close());

  Future<(Transaction out, Transaction into)> legsOf(
    (String, String) ids,
  ) async {
    final out = await db.findTransactionById(ids.$1);
    final into = await db.findTransactionById(ids.$2);
    return (out!, into!);
  }

  /// Editing a transfer must not re-price it.
  ///
  /// `updateTransfer` used to re-resolve the conversion on every call, and with
  /// no explicit received figure that meant looking up *today's* rate. Fixing a
  /// typo in the note of a transfer made months ago quietly restated what it had
  /// cost. A stored rate is a record of what happened.
  group('editing without re-pricing', () {
    test('changing the note leaves both legs exactly as they were', () async {
      final ids = await service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: euros,
        amount: 10000,
        date: DateTime(2026, 3, 1),
        receivedAmount: 9200,
      );
      final (outBefore, intoBefore) = await legsOf(ids);

      // A rate the app would find today, quite different from the one the
      // transfer actually happened at.
      await db.setCustomRate('USD', 'EUR', 0.4);

      await service.updateTransfer(
        transactionId: ids.$1,
        notes: 'Paid the deposit',
      );

      final (out, into) = await legsOf(ids);
      expect(out.amount, outBefore.amount);
      expect(into.amount, intoBefore.amount);
      expect(out.fxRate, outBefore.fxRate);
      expect(into.fxRate, intoBefore.fxRate);
      expect(out.counterAmount, outBefore.counterAmount);
      expect(into.counterAmount, intoBefore.counterAmount);
      expect(out.notes, 'Paid the deposit');
    });

    test('changing the date leaves the figures alone too', () async {
      final ids = await service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: euros,
        amount: 10000,
        date: DateTime(2026, 3, 1),
        receivedAmount: 9200,
      );
      await db.setCustomRate('USD', 'EUR', 0.4);

      await service.updateTransfer(
        transactionId: ids.$1,
        date: DateTime(2026, 3, 2),
      );

      final (out, into) = await legsOf(ids);
      expect(out.amount, 10000);
      expect(into.amount, 9200);
    });

    test('changing the amount does re-price it', () async {
      final ids = await service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: euros,
        amount: 10000,
        date: DateTime(2026, 3, 1),
        receivedAmount: 9200,
      );
      await db.setCustomRate('USD', 'EUR', 0.4);

      await service.updateTransfer(transactionId: ids.$1, amount: 20000);

      final (out, into) = await legsOf(ids);
      expect(out.amount, 20000);
      expect(
        into.amount,
        8000,
        reason: 'a new amount has no recorded counterpart, so the rate has to '
            'come from somewhere — today\'s is the only figure there is',
      );
    });

    test('moving a leg to another currency re-prices it', () async {
      final ids = await service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: moreDollars,
        amount: 10000,
        date: DateTime(2026, 3, 1),
      );
      await db.setCustomRate('USD', 'EUR', 0.4);

      await service.updateTransfer(
        transactionId: ids.$1,
        destinationWalletId: euros,
      );

      final (out, into) = await legsOf(ids);
      expect(out.amount, 10000);
      expect(into.amount, 4000);
      expect(into.walletId, euros);
    });

    test('a same-currency transfer keeps carrying one figure', () async {
      final ids = await service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: moreDollars,
        amount: 10000,
        date: DateTime(2026, 3, 1),
      );

      await service.updateTransfer(transactionId: ids.$1, notes: 'Rent');

      final (out, into) = await legsOf(ids);
      expect(out.amount, into.amount);
      expect(out.fxRate, isNull);
      expect(out.counterAmount, isNull);
      expect(into.counterAmount, isNull);
    });
  });

  test('each leg keeps its own currency amount', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    final (out, into) = await legsOf(ids);
    expect(out.amount, 10000);
    expect(
      into.amount,
      9200,
      reason:
          'writing the source figure into a euro account would invent money '
          'out of nothing',
    );
  });

  test('each leg records what the other side received', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    final (out, into) = await legsOf(ids);
    expect(out.counterAmount, 9200);
    expect(into.counterAmount, 10000);
  });

  test('the rate explains the two amounts beside it', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    final (out, _) = await legsOf(ids);
    expect(out.fxRate, closeTo(0.92, 0.0001));
  });

  test('each account moves by its own figure', () async {
    await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    expect((await db.findWalletById(dollars))!.balance, 1000000 - 10000);
    expect(
      (await db.findWalletById(euros))!.balance,
      9200,
      reason: 'the euro account received euros, not dollars',
    );
  });

  test('a transfer within one currency still carries one figure', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: moreDollars,
      amount: 10000,
      date: DateTime(2026, 3, 1),
    );

    final (out, into) = await legsOf(ids);
    expect(out.amount, into.amount);
    expect(
      out.fxRate,
      isNull,
      reason: 'there is no rate between an account and another like it',
    );
    expect(out.counterAmount, isNull);
  });

  test('a different received amount within one currency is refused', () async {
    expect(
      () => service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: moreDollars,
        amount: 10000,
        date: DateTime(2026, 3, 1),
        receivedAmount: 9000,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('nothing received is refused', () async {
    expect(
      () => service.createTransfer(
        sourceWalletId: dollars,
        destinationWalletId: euros,
        amount: 10000,
        date: DateTime(2026, 3, 1),
        receivedAmount: 0,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('the pair reads as sound to the integrity check', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    final (out, into) = await legsOf(ids);
    expect(
      TransferIntegrity.validatePair(out, into),
      isEmpty,
      reason:
          'the check used to demand equal amounts, which no cross-currency '
          'transfer can satisfy',
    );
  });

  test('legs that disagree about what arrived are reported', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    // Corrupt one leg the way a bad merge would.
    await db.customStatement(
      'UPDATE transactions SET counter_amount = 5000 WHERE id = ?',
      [ids.$1],
    );

    final (out, into) = await legsOf(ids);
    expect(TransferIntegrity.validatePair(out, into), isNotEmpty);
  });

  test('deleting one leg still takes the other', () async {
    final ids = await service.createTransfer(
      sourceWalletId: dollars,
      destinationWalletId: euros,
      amount: 10000,
      date: DateTime(2026, 3, 1),
      receivedAmount: 9200,
    );

    await service.deleteTransfer(ids.$1);

    final (out, into) = await legsOf(ids);
    expect(out.deletedAt, isNotNull);
    expect(into.deletedAt, isNotNull);
  });
}
