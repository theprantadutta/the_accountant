import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// **A pending create must never become a pending update.**
///
/// A row the server has never acknowledged is `pendingCreate`. Downgrading it to
/// `pendingUpdate` makes every subsequent push ask the server to update a row
/// that does not exist, which the server answers with "not found" — for ever.
/// The record is then stranded on the device: visible locally, permanently
/// absent from the cloud, and silently so.
///
/// This is not exotic. `updateWalletBalance` runs on every transaction the user
/// records, and a brand-new device files transactions against categories and
/// wallets it has not uploaded yet. The rule is enforced by a database trigger
/// rather than by convention, so code written later inherits it automatically.
void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  group('SyncStatus.markEdited', () {
    test('keeps a create a create', () {
      expect(
        SyncStatus.markEdited(SyncStatus.pendingCreate),
        SyncStatus.pendingCreate,
      );
    });

    test('keeps a tombstone a tombstone', () {
      expect(
        SyncStatus.markEdited(SyncStatus.pendingDelete),
        SyncStatus.pendingDelete,
      );
    });

    test('promotes a synced row to an update', () {
      expect(
        SyncStatus.markEdited(SyncStatus.synced),
        SyncStatus.pendingUpdate,
      );
      expect(
        SyncStatus.markEdited(SyncStatus.pendingUpdate),
        SyncStatus.pendingUpdate,
      );
      expect(
        SyncStatus.markEdited(SyncStatus.conflict),
        SyncStatus.pendingUpdate,
      );
    });
  });

  group('the database guard holds regardless of the call site', () {
    test('a raw downgrade of a transaction is reverted', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(db, walletId: walletId);

      // Exactly what a mutation helper that hard-codes pendingUpdate does.
      await db.customStatement(
        'UPDATE transactions SET sync_status = ? WHERE id = ?',
        [SyncStatus.pendingUpdate, id],
      );

      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingCreate,
      );
    });

    test('a synced transaction still becomes an update', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(
        db,
        walletId: walletId,
        syncStatus: SyncStatus.synced,
      );

      await db.customStatement(
        'UPDATE transactions SET sync_status = ? WHERE id = ?',
        [SyncStatus.pendingUpdate, id],
      );

      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingUpdate,
        reason: 'the guard must not block a legitimate update',
      );
    });

    test('a create can still be tombstoned', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(db, walletId: walletId);

      await db.softDeleteTransaction(id);

      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingDelete,
        reason: 'deleting is not the downgrade the guard exists to stop',
      );
    });

    test('every synced table is protected', () async {
      final walletId = await seedWallet(db);
      final categoryId = await seedCategory(db);

      await db.customStatement(
        'UPDATE wallets SET sync_status = ? WHERE id = ?',
        [SyncStatus.pendingUpdate, walletId],
      );
      await db.customStatement(
        'UPDATE categories SET sync_status = ? WHERE id = ?',
        [SyncStatus.pendingUpdate, categoryId],
      );

      expect(
        (await db.findWalletById(walletId))!.syncStatus,
        SyncStatus.pendingCreate,
      );
      expect(
        (await db.findCategoryById(categoryId))!.syncStatus,
        SyncStatus.pendingCreate,
      );
    });
  });

  group('the real mutation paths preserve a create', () {
    test('recording a transaction does not strand its wallet', () async {
      // The common case: a brand-new device. Recording anything rewrites the
      // wallet balance, which used to downgrade the not-yet-uploaded wallet.
      final walletId = await seedWallet(db, openingBalance: 10000);
      await seedTransaction(db, walletId: walletId, amount: 2500);

      await WalletBalanceService(db).updateWalletBalance(walletId);

      final wallet = await db.findWalletById(walletId);
      expect(wallet!.balance, 10000 - 2500);
      expect(
        wallet.syncStatus,
        SyncStatus.pendingCreate,
        reason:
            'a wallet stranded as an update can never be uploaded, and neither '
            'can any transaction that references it',
      );
    });

    test(
      'a synced wallet is marked for update when its balance changes',
      () async {
        final walletId = await seedWallet(
          db,
          openingBalance: 10000,
          syncStatus: SyncStatus.synced,
        );
        await seedTransaction(db, walletId: walletId, amount: 2500);

        await WalletBalanceService(db).updateWalletBalance(walletId);

        expect(
          (await db.findWalletById(walletId))!.syncStatus,
          SyncStatus.pendingUpdate,
        );
      },
    );

    test('re-filing a never-uploaded transaction keeps it a create', () async {
      final walletId = await seedWallet(db);
      final from = await seedCategory(db, name: 'Provisional');
      final to = await seedCategory(db, name: 'Canonical');
      final id = await seedTransaction(
        db,
        walletId: walletId,
        categoryId: from,
      );

      await db.repointTransactionsToCategory(
        fromCategoryId: from,
        toCategoryId: to,
      );

      final row = await db.findTransactionById(id);
      expect(row!.categoryId, to);
      expect(row.syncStatus, SyncStatus.pendingCreate);
    });

    test('re-filing a synced transaction marks it for update', () async {
      final walletId = await seedWallet(db);
      final from = await seedCategory(db, name: 'Old');
      final to = await seedCategory(db, name: 'New');
      final id = await seedTransaction(
        db,
        walletId: walletId,
        categoryId: from,
        syncStatus: SyncStatus.synced,
      );

      await db.repointTransactionsToCategory(
        fromCategoryId: from,
        toCategoryId: to,
      );

      final row = await db.findTransactionById(id);
      expect(row!.categoryId, to);
      expect(row.syncStatus, SyncStatus.pendingUpdate);
    });

    test('skipping and paying keep a create a create', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(db, walletId: walletId, isPaid: false);

      await db.skipTransaction(id);
      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingCreate,
      );

      await db.markTransactionAsPaid(id);
      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingCreate,
      );
    });

    test('objective linking keeps a create a create', () async {
      final walletId = await seedWallet(db);
      final id = await seedTransaction(db, walletId: walletId);

      await db.linkTransactionToObjective('goal-1', id);
      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingCreate,
      );
      expect((await db.findTransactionById(id))!.objectiveId, 'goal-1');

      await db.unlinkTransactionFromObjective('goal-1', id);
      expect(
        (await db.findTransactionById(id))!.syncStatus,
        SyncStatus.pendingCreate,
      );
      expect((await db.findTransactionById(id))!.objectiveId, isNull);
    });

    test('advancing a recurrence cursor keeps a create a create', () async {
      final walletId = await seedWallet(db);
      final baseId = await seedTransaction(db, walletId: walletId);
      await db.customStatement(
        'INSERT INTO recurring_configs (id, base_transaction_id, period_length, '
        'reoccurrence, start_date, next_occurrence, is_active, sync_status, '
        'created_at, updated_at) VALUES (?, ?, 1, ?, 1, 1, 1, ?, 1, 1)',
        ['cfg-1', baseId, 'monthly', SyncStatus.pendingCreate],
      );

      await db.updateNextOccurrence('cfg-1', DateTime(2027, 1, 1), true);

      final config = await db.findRecurringConfigById('cfg-1');
      expect(config!.syncStatus, SyncStatus.pendingCreate);
      expect(config.nextOccurrence.year, 2027);
    });
  });
}
