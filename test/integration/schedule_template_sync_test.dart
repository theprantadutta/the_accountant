import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// A schedule's price, account, and whether it asks first reach every device.
///
/// Recurring payments are generated on each device, so a second device that
/// did not know the new price would post the old one, and one that did not
/// know the schedule asks first would record the payment as made. And a
/// change from somewhere that does not know these fields — an older build, or
/// a server that predates them — must not reset them.
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

  Future<(String, String)> subscribe() async {
    final everyday = await seedWallet(phone, name: 'Everyday');
    final card = await seedWallet(phone, name: 'Card');
    final base = await seedTransaction(
      phone,
      walletId: everyday,
      amount: 2500,
      title: 'Streaming',
      specialType: TransactionSpecialType.subscription,
    );
    final service = RecurringService(database: phone);
    final id = await service.createRecurringConfig(
      baseTransactionId: base,
      reoccurrence: 'monthly',
      startDate: DateTime(2026, 1, 6),
      autoPay: false,
    );
    await service.updateRecurringConfig(
      configId: id,
      amount: 3000,
      walletId: card,
    );
    return (id, card);
  }

  test(
    'another device learns the price, the account, and to ask first',
    () async {
      final (id, card) = await subscribe();
      expect((await syncFor(phone).syncAll()).success, isTrue);

      expect((await syncFor(tablet).syncAll()).success, isTrue);

      final there = (await tablet.findRecurringConfigById(id))!;
      expect(there.amount, 3000);
      expect(there.walletId, card);
      expect(there.autoPay, isFalse);
    },
  );

  test('an edit from a build that predates them does not reset them', () async {
    final (id, card) = await subscribe();
    await syncFor(phone).syncAll();

    // An older build pauses the subscription, knowing nothing of the fields.
    final legacy = {...server.recordData(user, 'recurring_configs', id)!}
      ..remove('Amount')
      ..remove('WalletId')
      ..remove('AutoPay');
    server.push(user, [
      SyncChange(
        tableName: 'recurring_configs',
        entityId: id,
        operation: 'update',
        data: {
          ...legacy,
          'IsActive': false,
          'UpdatedAt': DateTime.utc(2030).toIso8601String(),
        },
      ),
    ]);

    await syncFor(phone).syncAll();

    final row = (await phone.findRecurringConfigById(id))!;
    expect(row.isActive, isFalse, reason: 'the edit itself applies');
    expect(row.amount, 3000);
    expect(row.walletId, card);
    expect(row.autoPay, isFalse);
  });
}
