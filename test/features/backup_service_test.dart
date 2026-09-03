import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/services/backup_service.dart';

import '../helpers/test_database.dart';

/// Taking the whole database out to a file, and putting one back.
///
/// Cloud sync is a paid feature, so a free user had no way at all to move their
/// records to a new phone or survive a reinstall. These tests hold the file
/// format to the two promises that make it worth trusting: what goes out comes
/// back unchanged, and a file that cannot be fully understood is refused rather
/// than half-applied.
void main() {
  late AppDatabase db;
  late BackupService service;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = BackupService(db);
  });

  tearDown(() => db.close());

  /// The same set of records in every test that needs something to lose.
  Future<void> seedSomeHistory() async {
    final wallet = await seedWallet(
      db,
      name: 'Everyday',
      openingBalance: 50000,
    );
    final category = await seedCategory(db, name: 'Groceries');
    await seedTransaction(
      db,
      walletId: wallet,
      categoryId: category,
      amount: 2500,
      title: 'Market',
    );
    await seedTransaction(
      db,
      walletId: wallet,
      categoryId: category,
      amount: 1000,
      title: 'Corner shop',
    );
  }

  group('what a backup contains', () {
    test('every table the user has records in', () async {
      await seedSomeHistory();

      final document = await service.create();

      expect(document.tables.keys, contains('transactions'));
      expect(document.tables.keys, contains('wallets'));
      expect(document.tables.keys, contains('categories'));
      expect(document.tables['transactions'], hasLength(2));
    });

    test('the schema it was taken from, so a reader can refuse it', () async {
      final document = await service.create();

      expect(document.metadata.schemaVersion, db.schemaVersion);
    });

    test('the sync cursor and the owner binding stay behind', () async {
      await db.setLastSyncTimestamp(DateTime(2026, 1, 1));

      final document = await service.create();

      expect(
        document.tables.keys,
        isNot(contains('sync_states')),
        reason:
            'a cursor carried to a new device would claim it had already '
            'pulled changes it was never present for',
      );
      expect(document.tables.keys, isNot(contains('local_store_metas')));
    });

    test('it survives being written out and read back as text', () async {
      await seedSomeHistory();

      final document = BackupDocument.decode((await service.create()).encode());

      expect(document.tables['transactions'], hasLength(2));
      expect(document.metadata.schemaVersion, db.schemaVersion);
    });
  });

  group('restoring', () {
    test('brings back records that were deleted afterwards', () async {
      await seedSomeHistory();
      final document = await service.create();

      await db.customStatement('DELETE FROM transactions');
      expect(await db.getAllTransactions(), isEmpty);

      await service.restore(document);

      expect(await db.getAllTransactions(), hasLength(2));
    });

    test('replaces what is there rather than adding to it', () async {
      await seedSomeHistory();
      final document = await service.create();

      final wallet = (await db.getAllWallets()).first;
      await seedTransaction(db, walletId: wallet.id, amount: 9999);
      expect(await db.getAllTransactions(), hasLength(3));

      await service.restore(document);

      expect(
        await db.getAllTransactions(),
        hasLength(2),
        reason: 'a restore is the file becoming the truth, not a merge',
      );
    });

    test('values come back exactly as they went in', () async {
      final wallet = await seedWallet(db, name: 'Everyday');
      final id = await seedTransaction(
        db,
        walletId: wallet,
        amount: 123456,
        title: 'Rent, and "quotes"',
      );
      final before = (await db.findTransactionById(id))!;

      final document = await service.create();
      await db.customStatement('DELETE FROM transactions');
      await service.restore(document);

      final after = (await db.findTransactionById(id))!;
      expect(after.amount, before.amount);
      expect(after.title, before.title);
      expect(after.date.toIso8601String(), before.date.toIso8601String());
      expect(after.isIncome, before.isIncome);
    });

    test('balances are recomputed from the restored rows', () async {
      final wallet = await seedWallet(
        db,
        name: 'Everyday',
        openingBalance: 50000,
      );
      await seedTransaction(db, walletId: wallet, amount: 2500);
      final document = await service.create();

      // The kind of nonsense a partial write or a crashed migration leaves.
      await db.updateWalletBalance(wallet, 1);
      await service.restore(document);

      expect((await db.findWalletById(wallet))!.balance, 47500);
    });

    test('the sync cursor is dropped', () async {
      await db.setLastSyncTimestamp(DateTime(2026, 1, 1));
      final document = await service.create();

      await service.restore(document);

      expect(
        await db.getLastSyncTimestamp(),
        isNull,
        reason:
            'asking for changes since a moment these rows were never part of '
            'would skip everything the server already held',
      );
    });

    test('a restored row is queued to be created, never updated', () async {
      final wallet = await seedWallet(db, name: 'Everyday');
      await db.customStatement(
        'UPDATE wallets SET sync_status = ${SyncStatus.synced}',
      );
      final document = await service.create();

      await service.restore(document);

      expect(
        (await db.findWalletById(wallet))!.syncStatus,
        SyncStatus.pendingCreate,
        reason:
            'an update for a row the server has never seen is answered "not '
            'found" for ever, and the record is stranded on the device',
      );
    });

    test('a deletion that was already acknowledged stays that way', () async {
      final wallet = await seedWallet(db, name: 'Everyday');
      final id = await seedTransaction(db, walletId: wallet, amount: 100);
      await db.customStatement(
        'UPDATE transactions SET deleted_at = ?, sync_status = '
        '${SyncStatus.synced} WHERE id = ?',
        [DateTime.now().millisecondsSinceEpoch ~/ 1000, id],
      );

      final document = await service.create();
      await service.restore(document);

      final row = await db.findTransactionById(id);
      expect(row!.deletedAt, isNotNull);
      expect(
        row.syncStatus,
        SyncStatus.synced,
        reason: 'a tombstone the server already has must not be re-uploaded',
      );
    });

    test('system categories exist even if the file had none', () async {
      final document = BackupDocument(
        metadata: BackupMetadata(
          schemaVersion: db.schemaVersion,
          createdAt: DateTime.now(),
        ),
        tables: const {'wallets': []},
      );

      await service.restore(document);

      expect(
        await db.requireSystemCategoryId(SystemCategories.transferKey),
        isNotEmpty,
      );
    });

    test('a column this build no longer has is reported, not fatal', () async {
      final document = BackupDocument(
        metadata: BackupMetadata(
          schemaVersion: db.schemaVersion,
          createdAt: DateTime.now(),
        ),
        tables: {
          'wallets': [
            {
              'id': 'w1',
              'name': 'Everyday',
              'currency': 'USD',
              'balance': 0,
              'a_column_from_the_future': 'ignored',
            },
          ],
        },
      );

      final summary = await service.restore(document);

      expect(summary.rowsRestored, 1);
      expect(summary.skippedColumns, ['wallets.a_column_from_the_future']);
      expect(summary.isComplete, isFalse);
      expect((await db.getAllWallets()).single.name, 'Everyday');
    });

    test('a table this build has no home for is reported', () async {
      final document = BackupDocument(
        metadata: BackupMetadata(
          schemaVersion: db.schemaVersion,
          createdAt: DateTime.now(),
        ),
        tables: const {'something_removed': []},
      );

      final summary = await service.restore(document);

      expect(summary.unknownTables, ['something_removed']);
    });
  });

  group('refusing a file that cannot be trusted', () {
    test('one that is not JSON at all', () {
      expect(
        () => BackupDocument.decode('not a backup'),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('one written by a newer version of the app', () {
      final source =
          (BackupDocument(
            metadata: BackupMetadata(
              schemaVersion: 21,
              createdAt: DateTime.now(),
            ),
            tables: const {},
          )).encode().replaceFirst(
            '"format_version": ${BackupDocument.currentFormatVersion}',
            '"format_version": ${BackupDocument.currentFormatVersion + 1}',
          );

      expect(
        () => BackupDocument.decode(source),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.message,
            'message',
            contains('newer version'),
          ),
        ),
      );
    });

    test('one from a database older than anything this build can place', () {
      final source = (BackupDocument(
        metadata: BackupMetadata(
          schemaVersion: BackupDocument.minimumSchemaVersion - 1,
          createdAt: DateTime.now(),
        ),
        tables: const {},
      )).encode();

      expect(
        () => BackupDocument.decode(source),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('one that does not say which database it came from', () {
      expect(
        () => BackupDocument.decode(
          '{"format_version": 1, "metadata": {"created_at": '
          '"2026-01-01T00:00:00Z"}, "tables": {}}',
        ),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.message,
            'message',
            contains('database version'),
          ),
        ),
      );
    });

    test('a damaged section is refused before anything is written', () async {
      await seedSomeHistory();

      expect(
        () => BackupDocument.decode(
          '{"format_version": 1, "metadata": {"schema_version": 21, '
          '"created_at": "2026-01-01T00:00:00Z"}, '
          '"tables": {"transactions": "not rows"}}',
        ),
        throwsA(isA<BackupFormatException>()),
      );
      expect(
        await db.getAllTransactions(),
        hasLength(2),
        reason: 'reading a bad file must not have touched the database',
      );
    });
  });

  group('a backup taken elsewhere', () {
    test('records the account it belonged to', () async {
      await db.claimLocalStore(userId: 'user-1', email: 'someone@example.com');

      final document = await service.create();

      expect(document.metadata.ownerUserId, 'user-1');
      expect(document.metadata.ownerEmail, 'someone@example.com');
    });

    test('does not overwrite this device own binding when restored', () async {
      await db.claimLocalStore(userId: 'user-1', email: 'one@example.com');
      final document = await service.create();

      final other = openTestDatabase();
      addTearDown(other.close);
      await other.claimLocalStore(userId: 'user-2', email: 'two@example.com');

      await BackupService(other).restore(document);

      expect(
        (await other.getLocalStoreMeta())!.ownerUserId,
        'user-2',
        reason: 'a file must not be able to claim a store it does not own',
      );
    });
  });
}
