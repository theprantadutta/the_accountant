import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/networth/services/net_worth_service.dart';

import '../helpers/test_database.dart';

/// Land, homes, cars and gold, owned and valued by hand.
///
/// An asset is worth what the user says it is. Buying one moves money out of
/// an account into it, so net worth does not drop on the day it is paid for;
/// a new value is a correction, never income or spending; and a sold asset
/// leaves nothing behind.
void main() {
  late AppDatabase db;
  late AssetService assets;
  late String bank;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    assets = AssetService(db);
    bank = await seedWallet(db, name: 'Bank', openingBalance: 10000000);
  });

  tearDown(() => db.close());

  Future<int> balanceOf(String id) async =>
      (await db.findWalletById(id))!.balance;

  Future<int> netWorth() async => (await NetWorthService(
    db,
  ).summary('USD', includeCreditCards: false)).total;

  test(
    'something already owned is added at its value, moving no money',
    () async {
      final id = await assets.create(
        name: 'Wedding jewellery',
        kind: AssetKind.gold,
        currency: 'USD',
        value: 1500000,
      );

      final wallet = (await db.findWalletById(id))!;
      expect(wallet.walletType, WalletType.asset);
      expect(wallet.walletType.isManaged, isTrue);
      // Other features read the kind from here, by these exact keys.
      expect(wallet.iconName, 'gold');
      expect(AssetKind.of(wallet), AssetKind.gold);
      expect(wallet.balance, 1500000);
      expect(wallet.openingBalance, 1500000);
      expect(await balanceOf(bank), 10000000);
      expect(await db.getAllTransactions(), isEmpty);

      final a = (await assets.find(id))!;
      expect(a.cost, 1500000);
      expect(a.change, 0);
      expect(await netWorth(), 10000000 + 1500000);
    },
  );

  test('buying one moves the money from the account into it', () async {
    final id = await assets.create(
      name: 'Toyota Axio',
      kind: AssetKind.car,
      currency: 'USD',
      value: 2000000,
      paidFromWalletId: bank,
    );

    expect(await balanceOf(bank), 10000000 - 2000000);
    expect(await balanceOf(id), 2000000);
    expect((await db.findWalletById(id))!.openingBalance, 0);
    expect(
      await netWorth(),
      10000000,
      reason: 'paying for it is not losing it',
    );

    final rows = await db.getAllTransactions();
    expect(rows.every(TransactionPolicy.isTransfer), isTrue);
    expect(rows.where(TransactionPolicy.countsAsExpense), isEmpty);
    expect((await assets.find(id))!.cost, 2000000);
  });

  test(
    'bought for less than it is worth, the difference is a value update',
    () async {
      final id = await assets.create(
        name: 'Plot in Savar',
        kind: AssetKind.land,
        currency: 'USD',
        value: 3000000,
        paidFromWalletId: bank,
        paid: 2500000,
      );

      expect(await balanceOf(bank), 10000000 - 2500000);
      expect(await balanceOf(id), 3000000);
      final a = (await assets.find(id))!;
      expect(a.cost, 2500000);
      expect(a.change, 500000);
      expect(a.changePercent, closeTo(20, 1e-9));
      final rows = await db.getAllTransactions();
      expect(rows.where(TransactionPolicy.isAdjustment).single.amount, 500000);
      expect(rows.where(TransactionPolicy.countsAsIncome), isEmpty);
    },
  );

  test('a new value is a correction, not income or spending', () async {
    final id = await assets.create(
      name: 'Flat in Mirpur',
      kind: AssetKind.home,
      currency: 'USD',
      value: 5000000,
    );
    await assets.revalue(id, 6500000);
    expect(await balanceOf(id), 6500000);
    await assets.revalue(id, 6000000);
    expect(await balanceOf(id), 6000000);

    final rows = await db.getAllTransactions();
    expect(rows, hasLength(2));
    expect(rows.every(TransactionPolicy.isAdjustment), isTrue);
    expect(rows.map((r) => r.title).toSet(), {'Flat in Mirpur: value update'});
    expect(rows.where(TransactionPolicy.countsInAnalytics), isEmpty);
    final a = (await assets.find(id))!;
    expect(a.change, 1000000);
    await expectLater(assets.revalue(id, -1), throwsArgumentError);
  });

  test('selling takes in what it fetched and closes it', () async {
    final id = await assets.create(
      name: 'Toyota Axio',
      kind: AssetKind.car,
      currency: 'USD',
      value: 2000000,
      paidFromWalletId: bank,
    );
    await assets.revalue(id, 1500000);

    await assets.sell(id, toWalletId: bank, amount: 1700000);

    expect(await balanceOf(bank), 10000000 - 2000000 + 1700000);
    expect(await balanceOf(id), 0, reason: 'nothing left behind');
    final a = (await assets.find(id))!;
    expect(a.isClosed, isTrue);
    expect(a.received, 1700000);
    expect(a.change, -300000, reason: 'bought for 20,000, sold for 17,000');
    expect(await netWorth(), 10000000 - 300000);

    // Nothing more can be done to it.
    await expectLater(assets.revalue(id, 100), throwsArgumentError);
    await expectLater(
      assets.sell(id, toWalletId: bank, amount: 100),
      throwsArgumentError,
    );
    final listed = await assets.all();
    expect(listed.single.isClosed, isTrue);
  });

  test('it is not removed while it is worth something', () async {
    final id = await assets.create(
      name: 'Camera',
      kind: AssetKind.other,
      currency: 'USD',
      value: 80000,
    );
    await expectLater(assets.delete(id), throwsArgumentError);
    expect((await db.findWalletById(id))!.isArchived, isFalse);

    await assets.revalue(id, 0);
    await assets.delete(id);
    expect((await db.findWalletById(id))!.isArchived, isTrue);
    expect(await netWorth(), 10000000);
  });

  test('a name twice, or paying from a managed account, is refused', () async {
    await assets.create(
      name: 'Plot',
      kind: AssetKind.land,
      currency: 'USD',
      value: 100,
    );
    await expectLater(
      assets.create(
        name: 'plot',
        kind: AssetKind.land,
        currency: 'USD',
        value: 100,
      ),
      throwsArgumentError,
    );

    final deposit = await seedWallet(db, name: 'DPS', openingBalance: 50000);
    await (db.update(db.wallets)..where((w) => w.id.equals(deposit))).write(
      const WalletsCompanion(walletType: Value(WalletType.deposit)),
    );
    await expectLater(
      assets.create(
        name: 'Gold bar',
        kind: AssetKind.gold,
        currency: 'USD',
        value: 100,
        paidFromWalletId: deposit,
      ),
      throwsArgumentError,
    );
    await expectLater(
      assets.create(
        name: 'Nothing',
        kind: AssetKind.other,
        currency: 'USD',
        value: 0,
      ),
      throwsArgumentError,
    );
  });

  test('kinds are read from loose words and unknown icons', () {
    expect(AssetKind.parse('Flat'), AssetKind.home);
    expect(AssetKind.parse('jewelry'), AssetKind.gold);
    expect(AssetKind.parse('vehicle'), AssetKind.car);
    expect(AssetKind.parse('plot'), AssetKind.land);
    expect(AssetKind.parse('painting'), AssetKind.other);
    expect(AssetKind.values.map((k) => k.key), [
      'land',
      'home',
      'car',
      'gold',
      'other',
    ]);
  });
}
