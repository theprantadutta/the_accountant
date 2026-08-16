import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

import '../helpers/test_database.dart';

/// Schema 12 has to leave every existing row recoverable while making the data
/// synchronizable. These tests drive the data half of the migration directly
/// against a database seeded to look like a pre-12 install.
void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test('rewrites the legacy transfer category and its references', () async {
    final walletId = await seedWallet(db);
    await seedCategory(
      db,
      id: SystemCategories.legacyTransferCategoryId,
      name: 'Transfer',
      syncStatus: SyncStatus.synced,
    );
    final txnId = await seedTransaction(
      db,
      walletId: walletId,
      categoryId: SystemCategories.legacyTransferCategoryId,
      transactionType: 'transfer',
    );

    await db.applyV12DataMigrations();

    // The category is now addressable by a GUID the backend can accept...
    expect(
      await db.findCategoryById(SystemCategories.legacyTransferCategoryId),
      isNull,
    );
    final migrated = await db.findCategoryById(
      SystemCategories.legacyFixedTransferCategoryId,
    );
    expect(migrated, isNotNull);
    expect(migrated!.name, 'Transfer');

    // ...and no transaction was left pointing at the old id.
    final txn = await db.findTransactionById(txnId);
    expect(txn!.categoryId, SystemCategories.legacyFixedTransferCategoryId);
  });

  test(
    'folds the legacy category away when the new id already exists',
    () async {
      final walletId = await seedWallet(db);
      await seedCategory(
        db,
        id: SystemCategories.legacyFixedTransferCategoryId,
        name: 'Transfer',
      );
      await seedCategory(
        db,
        id: SystemCategories.legacyTransferCategoryId,
        name: 'Transfer (old)',
      );
      final txnId = await seedTransaction(
        db,
        walletId: walletId,
        categoryId: SystemCategories.legacyTransferCategoryId,
      );

      await db.applyV12DataMigrations();

      expect(
        await db.findCategoryById(SystemCategories.legacyTransferCategoryId),
        isNull,
      );
      expect(
        (await db.findTransactionById(txnId))!.categoryId,
        SystemCategories.legacyFixedTransferCategoryId,
      );
      // Exactly one row survives — no duplicate category.
      final all = await db.getAllCategories();
      expect(
        all
            .where(
              (c) => c.id == SystemCategories.legacyFixedTransferCategoryId,
            )
            .length,
        1,
      );
    },
  );

  test('makes never-uploaded categories uploadable', () async {
    await seedCategory(
      db,
      name: 'Food & Dining',
      syncStatus: SyncStatus.synced,
    );
    await seedCategory(db, name: 'Salary', syncStatus: SyncStatus.synced);

    await db.applyV12DataMigrations();

    final categories = await db.getAllCategories();
    expect(categories, isNotEmpty);
    expect(
      categories.every((c) => c.syncStatus == SyncStatus.pendingCreate),
      isTrue,
      reason:
          'default categories were marked synced without ever being pushed, so '
          'the server rejected every transaction referencing them',
    );
  });

  test('does not resurrect a soft-deleted category', () async {
    final id = await seedCategory(db, syncStatus: SyncStatus.synced);
    await db.softDeleteCategory(id);
    // softDeleteCategory sets pendingDelete; simulate one that already synced.
    await db.customStatement(
      'UPDATE categories SET sync_status = ? WHERE id = ?',
      [SyncStatus.synced, id],
    );

    await db.applyV12DataMigrations();

    final row = await (db.select(
      db.categories,
    )..where((c) => c.id.equals(id))).getSingle();
    expect(row.syncStatus, SyncStatus.synced);
  });

  test('backfills objective links from the legacy junction table', () async {
    final walletId = await seedWallet(db);
    final txnId = await seedTransaction(
      db,
      walletId: walletId,
      amount: 5000,
      syncStatus: SyncStatus.synced,
    );
    await db.addObjectiveTransaction(
      ObjectiveTransactionsCompanion(
        id: const Value('link-1'),
        objectiveId: const Value('goal-1'),
        transactionId: Value(txnId),
        createdAt: Value(DateTime.now()),
      ),
    );

    await db.applyV12DataMigrations();

    final txn = await db.findTransactionById(txnId);
    expect(txn!.objectiveId, 'goal-1');
    expect(
      txn.syncStatus,
      SyncStatus.pendingUpdate,
      reason: 'the recovered link must be pushed so other devices see progress',
    );
    expect(await db.getObjectiveProgress('goal-1'), 5000);
  });

  test('collapses duplicate recurrence instances and backfills keys', () async {
    final walletId = await seedWallet(db);
    final baseId = await seedTransaction(db, walletId: walletId);
    final now = DateTime.now();
    await db.addRecurringConfig(
      RecurringConfigsCompanion(
        id: const Value('cfg-1'),
        baseTransactionId: Value(baseId),
        periodLength: const Value(1),
        reoccurrence: const Value('monthly'),
        startDate: Value(now),
        nextOccurrence: Value(now),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    final day = DateTime.utc(2026, 4, 10, 9);
    await seedTransaction(
      db,
      id: 'dup-a',
      walletId: walletId,
      recurringConfigId: 'cfg-1',
      date: day,
    );
    await seedTransaction(
      db,
      id: 'dup-b',
      walletId: walletId,
      recurringConfigId: 'cfg-1',
      date: day.add(const Duration(hours: 3)),
    );

    await db.applyV12DataMigrations();

    final instances = await db.getRecurringInstances('cfg-1');
    expect(
      instances,
      hasLength(1),
      reason: 'two rows for one scheduled day are one occurrence',
    );
    // The backfilled key must be byte-identical to what the service now
    // generates, or the same day would be duplicated once more.
    expect(
      instances.single.occurrenceKey,
      RecurringService.occurrenceKeyFor('cfg-1', day),
    );
  });

  test('is safe to run twice', () async {
    final walletId = await seedWallet(db);
    await seedCategory(
      db,
      id: SystemCategories.legacyTransferCategoryId,
      syncStatus: SyncStatus.synced,
    );
    await seedTransaction(
      db,
      walletId: walletId,
      categoryId: SystemCategories.legacyTransferCategoryId,
    );

    await db.applyV12DataMigrations();
    await db.applyV12DataMigrations();

    final categories = await db.getAllCategories();
    expect(
      categories.where(
        (c) => c.id == SystemCategories.legacyFixedTransferCategoryId,
      ),
      hasLength(1),
    );
  });
}
