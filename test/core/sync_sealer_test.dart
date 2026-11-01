import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_sealer.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

final _key = List<int>.generate(32, (i) => i);
final _otherKey = List<int>.generate(32, (i) => 200 - i);

SyncChange _tx(String id, {String op = 'create'}) => SyncChange(
  tableName: 'transactions',
  entityId: id,
  operation: op,
  data: {
    'WalletId': 'w1',
    'Amount': 6000,
    'Title': 'Rickshaw',
    'Notes': null,
    'IsIncome': false,
    'Date': '2026-11-01T00:00:00.000Z',
    'UpdatedAt': '2026-11-01T00:00:00.000Z',
  },
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  final sealer = SyncSealer(key: () async => _key);

  test(
    'amounts and titles leave as placeholders plus one sealed blob',
    () async {
      final sealed = (await sealer.sealAll([_tx('t1')])).single;

      expect(sealed.data!['Amount'], 0);
      expect(sealed.data!['Title'], '');
      expect(sealed.data!['Notes'], isNull);
      expect(sealed.data!['EncryptedData'], isA<String>());
      expect(jsonEncode(sealed.toJson()), isNot(contains('Rickshaw')));
      expect(jsonEncode(sealed.toJson()), isNot(contains('6000')));
    },
  );

  test('what sync runs on stays readable', () async {
    final sealed = (await sealer.sealAll([_tx('t1')])).single;

    expect(sealed.data!['WalletId'], 'w1');
    expect(sealed.data!['IsIncome'], false);
    expect(sealed.data!['UpdatedAt'], '2026-11-01T00:00:00.000Z');
  });

  test('a pulled row gets its real values back, whatever the casing', () async {
    final sealed = (await sealer.sealAll([_tx('t1')])).single;
    // The server answers in camelCase.
    final fromServer = SyncChange(
      tableName: 'transactions',
      entityId: 't1',
      operation: 'update',
      data: {
        for (final e in sealed.data!.entries)
          '${e.key[0].toLowerCase()}${e.key.substring(1)}': e.value,
      },
    );

    final opened = await sealer.open('transactions', fromServer);

    expect(opened.data!['Amount'], 6000);
    expect(opened.data!['Title'], 'Rickshaw');
    expect(opened.data!.containsKey('amount'), isFalse);
    expect(
      opened.data!.keys.any((k) => k.toLowerCase() == 'encrypteddata'),
      isFalse,
    );
  });

  test('rows from the real server, in snake_case, open too', () async {
    final sealed = (await sealer.sealAll([_tx('t1')])).single;
    String snake(String k) => k
        .replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}')
        .replaceFirst(RegExp('^_'), '');
    final fromServer = SyncChange(
      tableName: 'transactions',
      entityId: 't1',
      operation: 'update',
      data: {for (final e in sealed.data!.entries) snake(e.key): e.value},
    );
    expect(fromServer.data!.containsKey('encrypted_data'), isTrue);

    final opened = await sealer.open('transactions', fromServer);

    expect(opened.data!['Amount'], 6000);
    expect(opened.data!['Title'], 'Rickshaw');
    expect(opened.data!.containsKey('amount'), isFalse);
    expect(opened.data!.containsKey('encrypted_data'), isFalse);
  });

  test('a blob moved onto another row does not open', () async {
    final sealed = (await sealer.sealAll([_tx('t1')])).single;
    final moved = SyncChange(
      tableName: 'transactions',
      entityId: 't2',
      operation: 'update',
      data: sealed.data,
    );

    expect(() => sealer.open('transactions', moved), throwsA(anything));
  });

  test("another account's key cannot open it", () async {
    final sealed = (await sealer.sealAll([_tx('t1')])).single;

    expect(
      () => SyncSealer(key: () async => _otherKey).open('transactions', sealed),
      throwsA(anything),
    );
  });

  test('a row from an older app passes through untouched', () async {
    final plain = _tx('t1');

    final opened = await sealer.open('transactions', plain);

    expect(opened.data!['Title'], 'Rickshaw');
  });

  test('deletes are sent as they are, without asking for the key', () async {
    final keyless = SyncSealer(key: () async => throw StateError('no key'));
    final delete = SyncChange(
      tableName: 'transactions',
      entityId: 't1',
      operation: 'delete',
    );

    expect((await keyless.sealAll([delete])).single, same(delete));
  });

  test('every table that syncs has its financial fields listed', () {
    expect(
      SyncSealer.sealedFields.keys,
      containsAll(SyncEntityOrder.applyOrder),
    );
  });

  test(
    'two phones on one account sync, and the server never sees a figure',
    () async {
      const userId = 'sealed-user';
      final server = FakeSyncServer();

      final phoneA = openTestDatabase();
      addTearDown(phoneA.close);
      await phoneA.ensureSystemCategoriesExist();
      await phoneA.claimLocalStore(userId: userId);
      final wallet = await seedWallet(phoneA, name: 'DBBL Savings');
      final txId = await seedTransaction(
        phoneA,
        walletId: wallet,
        amount: 424179,
        title: 'Loan to Joy',
      );

      await SyncService(
        database: phoneA,
        transport: FakeSyncTransport(server: server, userId: userId),
        sealer: sealer,
      ).syncAll();

      final onServer = jsonEncode([
        ...server.recordsIn(userId, 'transactions'),
        ...server.recordsIn(userId, 'wallets'),
      ]);
      expect(onServer, isNot(contains('Loan to Joy')));
      expect(onServer, isNot(contains('DBBL Savings')));
      expect(onServer, isNot(contains('424179')));

      final phoneB = openTestDatabase();
      addTearDown(phoneB.close);
      await phoneB.claimLocalStore(userId: userId);
      await SyncService(
        database: phoneB,
        transport: FakeSyncTransport(server: server, userId: userId),
        sealer: sealer,
      ).syncAll();

      final pulled = (await phoneB.findTransactionById(txId))!;
      expect(pulled.title, 'Loan to Joy');
      expect(pulled.amount, 424179);
      expect((await phoneB.findWalletById(wallet))!.name, 'DBBL Savings');
    },
  );

  test(
    'upgrading to 5.0 re-sends what the server already holds, sealed',
    () async {
      SharedPreferences.setMockInitialValues({});
      const userId = 'upgrading-user';
      final server = FakeSyncServer();
      final phone = openTestDatabase();
      addTearDown(phone.close);
      await phone.ensureSystemCategoriesExist();
      await phone.claimLocalStore(userId: userId);
      final wallet = await seedWallet(phone, name: 'Cash in hand');
      await seedTransaction(
        phone,
        walletId: wallet,
        title: 'Tea',
        amount: 2000,
      );

      // 4.x: everything goes up readable.
      await SyncService(
        database: phone,
        transport: FakeSyncTransport(server: server, userId: userId),
      ).syncAll();
      expect(
        jsonEncode(server.recordsIn(userId, 'transactions').toList()),
        contains('Tea'),
      );

      // 5.0: the first sync seals it all, without the user touching a thing.
      await SyncService(
        database: phone,
        transport: FakeSyncTransport(server: server, userId: userId),
        sealer: sealer,
      ).syncAll();

      final onServer = jsonEncode([
        ...server.recordsIn(userId, 'transactions'),
        ...server.recordsIn(userId, 'wallets'),
        ...server.recordsIn(userId, 'categories'),
      ]);
      expect(onServer, isNot(contains('Tea')));
      expect(onServer, isNot(contains('Cash in hand')));
      for (final row in server.recordsIn(userId, 'transactions')) {
        expect(row['EncryptedData'], isA<String>());
      }
    },
  );
}
