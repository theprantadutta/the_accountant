import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/foreign_amount_service.dart';

import '../helpers/test_database.dart';

/// $500 from AdMob, wired into a taka account, arrives as ৳60,500. The entry is
/// the taka that landed; its foreign amount is the $500 it was, and a charge
/// the bank took separately is its own expense, linked to it.
void main() {
  late AppDatabase db;
  late ForeignAmountService service;
  late String bank;
  late String cash;
  late String income;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = ForeignAmountService(db);
    bank = await seedWallet(db, name: 'Bank', currency: 'BDT');
    cash = await seedWallet(db, name: 'Cash', currency: 'BDT');
    income = await seedTransaction(
      db,
      walletId: bank,
      amount: 6050000,
      isIncome: true,
      title: 'AdMob payout',
    );
  });

  tearDown(() async => db.close());

  Future<Transaction> row(String id) async =>
      (await db.getTransactionById(id))!;
  Future<int> balanceOf(String walletId) async =>
      (await db.findWalletById(walletId))!.balance;

  test(
    'records what the entry was in the other currency, and the rate',
    () async {
      await service.apply(
        income,
        const ForeignAmount(currency: 'USD', amount: 50000),
      );

      final saved = await row(income);
      expect(saved.counterCurrency, 'USD');
      expect(saved.counterAmount, 50000);
      expect(saved.fxRate, closeTo(121.0, 1e-9));
      expect(await service.feeFor(income), isNull);
    },
  );

  test(
    'a fee is its own expense, linked, on the wallet it was charged to',
    () async {
      await service.apply(
        income,
        ForeignAmount(
          currency: 'USD',
          amount: 50000,
          fee: 15000,
          feeWalletId: cash,
        ),
      );

      final fee = (await service.feeFor(income))!;
      expect(fee.amount, 15000);
      expect(fee.isIncome, isFalse);
      expect(fee.walletId, cash);
      expect(fee.feeForTransactionId, income);
      expect(await balanceOf(bank), 6050000);
      expect(await balanceOf(cash), -15000);
    },
  );

  test(
    'editing the fee changes the same row; clearing it removes it',
    () async {
      await service.apply(
        income,
        const ForeignAmount(currency: 'USD', amount: 50000, fee: 15000),
      );
      final first = (await service.feeFor(income))!;

      await service.apply(
        income,
        const ForeignAmount(currency: 'USD', amount: 50000, fee: 20000),
      );
      final second = (await service.feeFor(income))!;
      expect(second.id, first.id);
      expect(second.amount, 20000);
      expect(await balanceOf(bank), 6050000 - 20000);

      await service.apply(
        income,
        const ForeignAmount(currency: 'USD', amount: 50000),
      );
      expect(await service.feeFor(income), isNull);
      expect(await balanceOf(bank), 6050000);
    },
  );

  test('removing the foreign amount clears it and its fee', () async {
    await service.apply(
      income,
      const ForeignAmount(currency: 'USD', amount: 50000, fee: 15000),
    );
    await service.apply(income, null);

    final saved = await row(income);
    expect(saved.counterCurrency, isNull);
    expect(saved.counterAmount, isNull);
    expect(saved.fxRate, isNull);
    expect(await service.feeFor(income), isNull);
  });

  test(
    'deleting the entry takes its fee, and restoring brings both back',
    () async {
      await service.apply(
        income,
        const ForeignAmount(currency: 'USD', amount: 50000, fee: 15000),
      );
      final feeId = (await service.feeFor(income))!.id;

      await db.softDeleteTransaction(income);
      expect((await row(feeId)).deletedAt, isNotNull);

      await db.restoreTransaction(income);
      expect((await row(income)).deletedAt, isNull);
      expect((await row(feeId)).deletedAt, isNull);
    },
  );

  test(
    'a transfer is left alone: its own conversion is set by the transfer',
    () async {
      final leg = await seedTransaction(
        db,
        walletId: bank,
        amount: 1000,
        transactionType: 'transfer',
      );
      await service.apply(
        leg,
        const ForeignAmount(currency: 'USD', amount: 10, fee: 5),
      );
      expect((await row(leg)).counterCurrency, isNull);
      expect(await service.feeFor(leg), isNull);
    },
  );
}
