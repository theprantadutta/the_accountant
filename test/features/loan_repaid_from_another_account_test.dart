import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';

import '../helpers/test_database.dart';

/// Money borrowed into one bank is often paid back from another. A repayment
/// used to be pinned to the loan's own account, so the only way to record that
/// was a transfer between the two first — or a balance that was simply wrong.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late String scb;
  late String brac;
  late String loan;

  setUp(() async {
    db = openTestDatabase();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    scb = await seedWallet(db, name: 'Standard Chartered', currency: 'BDT');
    brac = await seedWallet(
      db,
      name: 'Brac Bank',
      currency: 'BDT',
      openingBalance: 15000000,
    );
    // Borrowed ৳100,000 into Standard Chartered.
    loan = await seedTransaction(
      db,
      walletId: scb,
      amount: 10000000,
      isIncome: true,
      specialType: TransactionSpecialType.debt,
      title: 'Got Some Money From Vasker Sir',
    );
    await WalletBalanceService(db).updateWalletBalance(scb);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<int> balanceOf(String id) =>
      WalletBalanceService(db).calculateWalletBalance(id);

  test('a debt repaid from another account settles it, and the money leaves '
      'that account', () async {
    final n = container.read(creditDebtProvider.notifier);
    await n.loadData();

    await n.recordPayment(
      transactionId: loan,
      paymentAmount: 10000000,
      walletId: brac,
    );

    final repayment = (await db.getSettlementsOf(loan)).single;
    expect(repayment.walletId, brac);
    expect(repayment.isIncome, isFalse);
    expect(await balanceOf(scb), 10000000, reason: 'the borrowing stays put');
    expect(await balanceOf(brac), 5000000, reason: '৳100,000 left Brac');
    final settled = (await db.findTransactionById(loan))!;
    expect(TransactionPolicy.isSettled(settled), isTrue);
  });

  test('without an account the repayment stays on the loan’s own', () async {
    final n = container.read(creditDebtProvider.notifier);
    await n.loadData();

    await n.recordPayment(transactionId: loan, paymentAmount: 4000000);

    expect((await db.getSettlementsOf(loan)).single.walletId, scb);
    expect(await balanceOf(scb), 6000000);
    expect(await balanceOf(brac), 15000000);
  });
}
