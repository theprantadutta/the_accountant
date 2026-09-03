import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/test_database.dart';

/// Whether a stored balance still matches the transactions behind it.
///
/// The balance is a cache, and it used to be maintained two ways: a full
/// recalculation, and a blind add-or-subtract applied when a transaction was
/// created or paid. The second could not check anything, so a path that ran
/// twice, or not at all, left an account quietly wrong — and a wrong balance is
/// the one number in this app nobody thinks to double-check.
void main() {
  late AppDatabase db;
  late WalletBalanceService balances;

  setUp(() {
    db = openTestDatabase();
    balances = WalletBalanceService(db);
  });

  tearDown(() => db.close());

  test('an untouched account reports no drift', () async {
    final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);
    await seedTransaction(db, walletId: id, amount: 2500);
    await balances.updateWalletBalance(id);

    expect(await balances.findBalanceDrift(), isEmpty);
  });

  test('a balance nudged out of step is reported, with the gap', () async {
    final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);
    await balances.updateWalletBalance(id);

    // Exactly the shape a double-applied delta left behind.
    await db.updateWalletBalance(id, 47500);

    final drift = await balances.findBalanceDrift();
    expect(drift, hasLength(1));
    expect(
      drift[id],
      -2500,
      reason: 'the size of the gap is what says how bad the problem is',
    );
  });

  test('recalculating clears it', () async {
    final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);
    await db.updateWalletBalance(id, 999);

    await balances.recalculateAllWalletBalancesLocal();

    expect(await balances.findBalanceDrift(), isEmpty);
  });

  test('an unpaid transaction is not counted, and is not drift', () async {
    final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);
    await seedTransaction(
      db,
      walletId: id,
      amount: 9000,
      isPaid: false,
      specialType: TransactionSpecialType.upcoming,
    );
    await balances.updateWalletBalance(id);

    expect((await db.findWalletById(id))!.balance, 50000);
    expect(await balances.findBalanceDrift(), isEmpty);
  });

  test('several accounts are each checked on their own', () async {
    final good = await seedWallet(db, name: 'Good', openingBalance: 10000);
    final bad = await seedWallet(db, name: 'Bad', openingBalance: 10000);
    await balances.recalculateAllWalletBalancesLocal();
    await db.updateWalletBalance(bad, 1);

    final drift = await balances.findBalanceDrift();
    expect(drift.keys, [bad]);
    expect(drift.containsKey(good), isFalse);
  });
}
