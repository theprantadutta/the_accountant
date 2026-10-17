import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// An archived category stays archived on every device, and a change from a
/// build that predates archiving does not bring it back.
void main() {
  const user = 'user-a';
  late FakeSyncServer server;
  late AppDatabase phone;
  late AppDatabase tablet;

  SyncService syncFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: user),
  );

  setUp(() async {
    server = FakeSyncServer();
    phone = openTestDatabase();
    tablet = openTestDatabase();
    await phone.claimLocalStore(userId: user);
    await tablet.claimLocalStore(userId: user);
    await assertStoresAreIndependent(phone, tablet);
  });

  tearDown(() async {
    await phone.close();
    await tablet.close();
  });

  test('another device puts it away too, and an older build renaming it '
      'does not bring it back', () async {
    final id = await seedCategory(phone, name: 'Mela');
    await phone.setCategoryArchived(id, true);
    expect((await syncFor(phone).syncAll()).success, isTrue);
    expect((await syncFor(tablet).syncAll()).success, isTrue);
    expect((await tablet.findCategoryById(id))!.isArchived, isTrue);

    final legacy = {...server.recordData(user, 'categories', id)!}
      ..remove('IsArchived');
    server.push(user, [
      SyncChange(
        tableName: 'categories',
        entityId: id,
        operation: 'update',
        data: {
          ...legacy,
          'Name': 'Fair',
          'UpdatedAt': DateTime.utc(2030).toIso8601String(),
        },
      ),
    ]);
    await syncFor(phone).syncAll();

    final row = (await phone.findCategoryById(id))!;
    expect(row.name, 'Fair');
    expect(row.isArchived, isTrue);
  });
}
