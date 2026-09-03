import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// Setting an account aside without losing what it explains.
///
/// Closing an account is not the same as deleting it. A deleted one takes its
/// transactions with it, so last year's spending stops adding up; an archived
/// one keeps every row and simply stops being offered or counted.
///
/// Excluding is a different question again: the balance is real and current,
/// it just is not the user's to spend, so counting it makes every summary
/// figure wrong in a way nothing on screen explains.
void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  Future<String> wallet({
    required String name,
    int balance = 0,
    String currency = 'USD',
    bool archived = false,
    bool excluded = false,
  }) async {
    final id = await seedWallet(
      db,
      name: name,
      currency: currency,
      openingBalance: balance,
    );
    if (archived || excluded) {
      await (db.update(db.wallets)..where((w) => w.id.equals(id))).write(
        WalletsCompanion(
          isArchived: Value(archived),
          excludeFromTotal: Value(excluded),
        ),
      );
    }
    return id;
  }

  /// Every account here is in one currency, so conversion is a no-op — this is
  /// about which accounts count, not about rates.
  FinancialCalculationService service() =>
      FinancialCalculationService(db, CurrencyService(db));

  test('an ordinary account counts toward the total', () async {
    await wallet(name: 'Everyday', balance: 50000);

    expect(await service().getTotalBalanceConverted('USD'), 50000);
  });

  test('an archived account does not', () async {
    await wallet(name: 'Everyday', balance: 50000);
    await wallet(name: 'Old current account', balance: 900000, archived: true);

    expect(
      await service().getTotalBalanceConverted('USD'),
      50000,
      reason:
          'a closed account still holds a figure in the table, and counting it '
          'reports money that is not there',
    );
  });

  test('an excluded account does not either', () async {
    await wallet(name: 'Everyday', balance: 50000);
    await wallet(name: 'Club funds', balance: 300000, excluded: true);

    expect(await service().getTotalBalanceConverted('USD'), 50000);
  });

  test('archiving keeps the transactions filed against it', () async {
    final id = await wallet(name: 'Old account', balance: 10000);
    final txn = await seedTransaction(
      db,
      walletId: id,
      amount: 2500,
      title: 'Last year',
    );

    await (db.update(db.wallets)..where((w) => w.id.equals(id))).write(
      const WalletsCompanion(isArchived: Value(true)),
    );

    final kept = await db.findTransactionById(txn);
    expect(
      kept?.deletedAt,
      isNull,
      reason:
          'deleting the account would take its history with it, which is not '
          'what closing one means',
    );
  });

  test('an archived account is still there to look at', () async {
    final id = await wallet(name: 'Old account', archived: true);

    final all = await db.getAllWallets();
    expect(
      all.map((w) => w.id),
      contains(id),
      reason: 'its history has to stay reachable somewhere',
    );
  });
}
