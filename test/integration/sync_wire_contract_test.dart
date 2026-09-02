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
    await (device.update(
      device.budgets,
    )..where((b) => b.id.equals(id))).write(BudgetsCompanion(period: Value(period)));

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
}
