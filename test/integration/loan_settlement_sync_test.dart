import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// The link from a repayment to its loan has to reach every device.
///
/// It is what keeps the repayment out of earnings and spending, so a second
/// device without it would report income the first device does not. And a
/// device must not lose it to a change from somewhere that does not know it
/// exists — an older build editing the row, or a server that predates it.
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

  Future<String> lendAndRepay() async {
    final wallet = await seedWallet(phone, openingBalance: 100000);
    final loan = await seedTransaction(
      phone,
      walletId: wallet,
      amount: 20000,
      specialType: TransactionSpecialType.credit,
      title: 'Lent to Sam',
    );
    final repayment = await seedTransaction(
      phone,
      walletId: wallet,
      amount: 5000,
      isIncome: true,
      title: 'Received: Lent to Sam',
    );
    await (phone.update(phone.transactions)
          ..where((t) => t.id.equals(repayment)))
        .write(TransactionsCompanion(settlesTransactionId: Value(loan)));
    return repayment;
  }

  test('another device learns the repayment is not income', () async {
    final repayment = await lendAndRepay();
    expect((await syncFor(phone).syncAll()).success, isTrue);

    expect((await syncFor(tablet).syncAll()).success, isTrue);

    final there = (await tablet.findTransactionById(repayment))!;
    expect(there.settlesTransactionId, isNotNull);
    expect(TransactionPolicy.countsInAnalytics(there), isFalse);
  });

  test(
    'an edit from a build that predates the link does not erase it',
    () async {
      final repayment = await lendAndRepay();
      await syncFor(phone).syncAll();
      final loan = (await phone.findTransactionById(
        repayment,
      ))!.settlesTransactionId;

      // An older build renames the repayment. It has never heard of the link,
      // so its payload simply does not carry one.
      final legacy = {...server.recordData(user, 'transactions', repayment)!}
        ..remove('SettlesTransactionId');
      server.push(user, [
        SyncChange(
          tableName: 'transactions',
          entityId: repayment,
          operation: 'update',
          data: {
            ...legacy,
            'Title': 'Sam paid me back',
            'UpdatedAt': DateTime.utc(2030).toIso8601String(),
          },
        ),
      ]);

      await syncFor(phone).syncAll();

      final row = (await phone.findTransactionById(repayment))!;
      expect(row.title, 'Sam paid me back', reason: 'the edit itself applies');
      expect(row.settlesTransactionId, loan);
    },
  );
}
