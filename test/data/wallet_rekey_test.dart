import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/local_id_repair_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';

/// The wallet id post-signup onboarding used to mint, and everything that
/// pointed at it.
///
/// `DateTime.now().millisecondsSinceEpoch.toString()` cannot bind to
/// `SyncChange.EntityId`, which is a `Guid` server-side. Because a push is a
/// single request, that one wallet rejected the entire batch — so the user's
/// first wallet, and every transaction, objective and budget filed against it,
/// stayed pending forever with nothing on screen to explain why.
///
/// Re-keying it is only safe if every reference moves with it. A wallet whose
/// id changed while its transactions still pointed at the old one would read as
/// an empty wallet next to a pile of orphans — worse than the bug being fixed.
void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('accountant_rekey_test');
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    // Windows keeps a lock on an open SQLite file, and a failing test may leave
    // one open. Cleanup is best-effort so it never masks the real failure.
    try {
      if (tempDir.existsSync()) await tempDir.delete(recursive: true);
    } on FileSystemException {
      // ignore
    }
  });

  const legacyId = '1755331200000';
  // Every other id is a real UUID, because the backend binds every
  // `SyncChange.EntityId` as a `Guid`. Readable ids like `txn-1` made the old
  // version of this test meaningless: the fake server accepted them, so the
  // test passed while the same payload would have been rejected by the real API
  // at model binding — before the repaired wallet was ever looked at.
  const categoryId = '3f2a91c4-5b6d-4e77-8a10-2c9d4e5f6a7b';
  const transactionId = '7d1e4b28-9c3f-4a55-b6e8-1f0a2b3c4d5e';
  const objectiveId = 'a4c7e910-2b83-4d6f-9e12-5a7b8c9d0e1f';
  const budgetId = 'c8b3f5d1-6e42-4a79-8c05-3d1e2f4a5b6c';

  /// A schema-14 database holding an onboarding wallet with a timestamp id and
  /// one of every dependent record.
  Future<File> buildV14WithTimestampWallet({
    int walletSyncStatus = SyncStatus.pendingCreate,
  }) async {
    final file = File('${tempDir.path}/v14.sqlite');
    final db = AppDatabase(NativeDatabase(file));
    await db.customSelect('SELECT 1').get();

    await db.customStatement(
      'INSERT INTO wallets (id, name, balance, opening_balance, currency, '
      'wallet_type, icon_name, color, is_default, order_index, sync_status, '
      "created_at, updated_at) VALUES ('$legacyId', 'My Wallet', 5000, 5000, "
      "'USD', 0, 'wallet', '#6366F1', 1, 0, $walletSyncStatus, 1, 1)",
    );
    await db.customStatement(
      'INSERT INTO categories (id, name, icon_name, color, is_income, '
      'order_index, is_default, default_key, sync_status, created_at, '
      "updated_at) VALUES ('$categoryId', 'Groceries', 'shop', '#fff', 0, 8, 1, "
      "'groceries', 1, 1, 1)",
    );
    await db.customStatement(
      'INSERT INTO transactions (id, title, amount, date, is_income, '
      'wallet_id, category_id, transaction_type, is_paid, paid_amount, '
      'skip_paid, sync_status, created_at, updated_at) VALUES '
      "('$transactionId', 'First shop', 1500, 1, 0, '$legacyId', '$categoryId', 'regular', "
      '1, 0, 0, 1, 1, 1)',
    );
    await db.customStatement(
      'INSERT INTO objectives (id, name, target_amount, wallet_id, '
      'start_date, sync_status, created_at, updated_at) VALUES '
      "('$objectiveId', 'Holiday', 100000, '$legacyId', 1, 1, 1, 1)",
    );
    await db.customStatement(
      'INSERT INTO budgets (id, name, amount, period, start_date, wallet_ids, '
      'category_ids, sync_status, created_at, updated_at) VALUES '
      "('$budgetId', 'Monthly', 50000, 'monthly', 1, '[\"$legacyId\"]', "
      "'[\"$categoryId\"]', 1, 1, 1)",
    );

    await db.customStatement('DROP TABLE IF EXISTS local_id_repairs');
    await db.customStatement('PRAGMA user_version = 14');
    await db.close();
    return file;
  }

  test('the migration re-keys the wallet and every reference to it', () async {
    final file = await buildV14WithTimestampWallet();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final wallets = await db.getAllWallets();
    final wallet = wallets.single;

    expect(
      wallet.id,
      isNot(legacyId),
      reason: 'the unsyncable id must be gone',
    );
    expect(AppDatabase.isSyncableId(wallet.id), isTrue);
    expect(wallet.name, 'My Wallet');
    expect(wallet.balance, 5000);
    expect(
      wallet.syncStatus,
      SyncStatus.pendingCreate,
      reason: 'the wallet was never uploaded and must still be a create',
    );

    // Every dependent reference moved with it.
    expect((await db.findTransactionById(transactionId))!.walletId, wallet.id);
    final objective = await (db.select(
      db.objectives,
    )..where((o) => o.id.equals(objectiveId))).getSingle();
    expect(objective.walletId, wallet.id);
    final budget = await db.findBudgetById(budgetId);
    expect(jsonDecode(budget!.walletIds), [wallet.id]);
  });

  test('the re-key is recorded so the preference can be repointed', () async {
    SharedPreferences.setMockInitialValues({
      LocalIdRepairService.defaultWalletKey: legacyId,
    });
    final file = await buildV14WithTimestampWallet();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    final newId = (await db.getAllWallets()).single.id;

    final prefs = await SharedPreferences.getInstance();
    final service = LocalIdRepairService(db, prefs);

    expect(await db.unsettledIdRepairs(), hasLength(1));
    await service.applyPendingRepairs();

    expect(
      prefs.getString(LocalIdRepairService.defaultWalletKey),
      newId,
      reason: 'the default wallet must follow the wallet, not vanish',
    );
    expect(
      await db.unsettledIdRepairs(),
      isEmpty,
      reason: 'a settled repair must not be applied twice',
    );
  });

  test('an unrelated default-wallet preference is left alone', () async {
    SharedPreferences.setMockInitialValues({
      LocalIdRepairService.defaultWalletKey: 'some-other-wallet',
    });
    final file = await buildV14WithTimestampWallet();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    final prefs = await SharedPreferences.getInstance();
    await LocalIdRepairService(db, prefs).applyPendingRepairs();

    expect(
      prefs.getString(LocalIdRepairService.defaultWalletKey),
      'some-other-wallet',
    );
  });

  test('a wallet the server may already know is never re-keyed', () async {
    // The one case where changing the id would do real damage: if the cloud
    // holds this wallet under the old id, re-keying severs the local copy from
    // it. Preserve and report instead of guessing.
    final file = await buildV14WithTimestampWallet(
      walletSyncStatus: SyncStatus.synced,
    );

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    expect((await db.getAllWallets()).single.id, legacyId);
    expect((await db.findTransactionById(transactionId))!.walletId, legacyId);

    final blocked = await db.blockedIdRepairs();
    expect(blocked, hasLength(1));
    expect(blocked.single.oldId, legacyId);
    expect(blocked.single.newId, isNull);
    expect(blocked.single.detail, contains('manual review'));
  });

  test('re-keying is idempotent across reopens', () async {
    final file = await buildV14WithTimestampWallet();

    final first = AppDatabase(NativeDatabase(file));
    final firstId = (await first.getAllWallets()).single.id;
    await first.close();

    final second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);

    expect((await second.getAllWallets()).single.id, firstId);
    expect(
      await second.allWalletRepairCount(),
      1,
      reason: 'a second open must not log the repair again',
    );
  });

  test('the unrepaired wallet id is rejected by the real contract', () async {
    // The counterpart to the test below, and the reason it means anything: the
    // very same payload with the original timestamp id cannot be uploaded at
    // all. Without this, "the repaired wallet syncs" is a claim about the fake
    // server rather than about the backend.
    expect(AppDatabase.isSyncableId(legacyId), isFalse);

    final server = FakeSyncServer(strictEntityIds: true);
    expect(
      () => server.push('rekey-user', [
        SyncChange(
          tableName: 'wallets',
          entityId: legacyId,
          operation: 'create',
          data: const {'Name': 'My Wallet'},
        ),
      ]),
      throwsA(isA<StateError>()),
    );
  });

  test('the re-keyed wallet and its dependants then sync', () async {
    // The whole point of the fix: what was permanently unsyncable now uploads.
    final file = await buildV14WithTimestampWallet();
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    const userId = 'rekey-user';
    await db.claimLocalStore(userId: userId);
    // Strict: every entity_id must be a GUID, exactly as the real API demands.
    // Without this the fake would accept anything and the test would prove
    // nothing about whether the repaired payload can actually be uploaded.
    final server = FakeSyncServer(strictEntityIds: true);
    final service = SyncService(
      database: db,
      transport: FakeSyncTransport(server: server, userId: userId),
    );

    final result = await service.syncAll();
    expect(result.success, isTrue);

    final walletId = (await db.getAllWallets()).single.id;
    final uploadedWallet = server
        .recordsIn(userId, 'wallets')
        .firstWhere((w) => w['Id'] == walletId);
    expect(uploadedWallet['Name'], 'My Wallet');

    final uploadedTxn = server
        .recordsIn(userId, 'transactions')
        .firstWhere((t) => t['Id'] == transactionId);
    expect(uploadedTxn['WalletId'], walletId);

    expect(
      server.recordsIn(userId, 'objectives').single['WalletId'],
      walletId,
    );
    expect(
      jsonDecode(server.recordsIn(userId, 'budgets').single['WalletIds']
          as String),
      [walletId],
    );

    // And nothing was left behind pointing at the dead id.
    expect(
      server
          .recordsIn(userId, 'wallets')
          .where((w) => w['Id'] == legacyId),
      isEmpty,
    );
  });
}
