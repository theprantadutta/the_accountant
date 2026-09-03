import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// The integers this client puts on the wire for a budget's period.
///
/// The server receives these as bare numbers and casts them to its own enum, so
/// the two tables have to agree exactly. They did not: the server's enum was
/// implicitly numbered from Weekly, so a budget the user set to Weekly was
/// stored as Monthly and a Monthly one as Custom, while Yearly and BiWeekly had
/// no member at all and were written to the column as the numerals "4" and "5".
/// Pull inverted the same wrong table, which is why the app never showed it.
///
/// The matching assertions on the server live in SyncEnumContractTests. Both
/// sides are pinned so a member cannot be inserted into the middle of either
/// enum without a failing test on that side.
void main() {
  late FakeSyncServer server;
  late AppDatabase device;

  const user = 'user-a';

  setUp(() async {
    server = FakeSyncServer();
    device = openTestDatabase();
    await device.claimLocalStore(userId: user);
  });

  tearDown(() async => device.close());

  Future<int?> pushedPeriodFor(String period) async {
    final id = await seedBudget(device, name: 'B-$period');
    await (device.update(device.budgets)..where((b) => b.id.equals(id))).write(
      BudgetsCompanion(period: Value(period)),
    );

    final result = await SyncService(
      database: device,
      transport: FakeSyncTransport(server: server, userId: user),
    ).syncAll();
    expect(result.success, isTrue, reason: 'the push should be accepted');

    final row = server
        .recordsIn(user, 'budgets')
        .firstWhere((r) => r['Name'] == 'B-$period');
    return row['Period'] as int?;
  }

  test('every period maps to the number the server expects', () async {
    expect(await pushedPeriodFor('daily'), 0);
    expect(await pushedPeriodFor('weekly'), 1);
    expect(await pushedPeriodFor('biweekly'), 2);
    expect(await pushedPeriodFor('monthly'), 3);
    expect(await pushedPeriodFor('yearly'), 4);
    expect(await pushedPeriodFor('custom'), 5);
  });

  test('a budget keeps its shape across a round trip', () async {
    final other = openTestDatabase();
    addTearDown(other.close);
    await other.claimLocalStore(userId: user);

    // The scope has to name real rows: both ends reject a budget pointing at a
    // category or wallet that does not exist for this user.
    final catA = await seedCategory(device, name: 'Food');
    final catB = await seedCategory(device, name: 'Drink');
    final wallet = await seedWallet(device, name: 'Everyday');

    final id = await seedBudget(
      device,
      name: 'Fortnightly food',
      amount: 75000,
      period: 'biweekly',
      periodLength: 2,
      categoryIds: [catA, catB],
      walletIds: [wallet],
      rollover: true,
      isIncome: false,
    );

    final pushed = await SyncService(
      database: device,
      transport: FakeSyncTransport(server: server, userId: user),
    ).syncAll();
    expect(pushed.conflicts, isEmpty, reason: 'the budget should be accepted');

    final pulled = await SyncService(
      database: other,
      transport: FakeSyncTransport(server: server, userId: user),
    ).syncAll();
    expect(pulled.applyFailures, isEmpty);

    final landed = await other.findBudgetById(id);
    expect(landed, isNotNull, reason: 'the budget should have travelled');
    expect(landed!.amount, 75000);
    expect(landed.period, 'biweekly');
    expect(
      landed.periodLength,
      2,
      reason:
          'an interval that does not survive turns a monthly budget '
          'into a fortnightly one on the other device',
    );
    expect(landed.rollover, isTrue);
    expect(AppDatabase.decodeIdList(landed.categoryIds), [catA, catB]);
    expect(AppDatabase.decodeIdList(landed.walletIds), [wallet]);
  });

  test('a category cap travels with its budget', () async {
    final other = openTestDatabase();
    addTearDown(other.close);
    await other.claimLocalStore(userId: user);

    final category = await seedCategory(device, name: 'Snacks');
    final budgetId = await seedBudget(
      device,
      name: 'Food',
      amount: 100000,
      categoryIds: [category],
    );
    await device.setCategoryLimit(
      budgetId: budgetId,
      categoryId: category,
      amount: 2550,
      isPercent: true,
    );

    final pushed = await SyncService(
      database: device,
      transport: FakeSyncTransport(server: server, userId: user),
    ).syncAll();
    expect(
      pushed.conflicts,
      isEmpty,
      reason: 'a cap sent alongside the budget it belongs to must be accepted',
    );

    final pulled = await SyncService(
      database: other,
      transport: FakeSyncTransport(server: server, userId: user),
    ).syncAll();
    expect(pulled.applyFailures, isEmpty);

    final landed = await other.getCategoryLimitsForBudget(budgetId);
    expect(landed, hasLength(1));
    expect(landed.single.categoryId, category);
    expect(landed.single.amount, 2550);
    expect(
      landed.single.isPercent,
      isTrue,
      reason:
          'a share that arrives as a flat sum stops moving with the budget, '
          'which is the whole reason for expressing it as a share',
    );
  });
}
