import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionType;

/// Exercises the REAL Drift upgrade path, not just the data-migration helper.
///
/// The `applyVxxDataMigrations()` tests run against a database that already has
/// the current schema. That verifies the SQL but not `onUpgrade` itself: a
/// column added in the wrong order, a statement referencing a column that does
/// not exist yet, or an index created before its column would all pass those
/// tests and still fail on a real user's device. These tests build a file that
/// genuinely looks like an older version and let Drift upgrade it.
void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('accountant_schema_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  /// Build a database file that genuinely looks like schema [version]: create
  /// the current schema, let [seed] insert period-appropriate rows, then strip
  /// what was added after [version] and stamp the older `user_version`.
  ///
  /// Seeding must happen inside this call. Opening the file with [AppDatabase]
  /// is what triggers the migration, so seeding afterwards would insert into an
  /// already-upgraded database and the test would prove nothing.
  Future<File> buildLegacyDatabase(
    int version, {
    Future<void> Function(AppDatabase db)? seed,
    Set<String> keep = const {},
    String? label,
  }) async {
    final file = File('${tempDir.path}/legacy_v${label ?? version}.sqlite');

    final db = AppDatabase(NativeDatabase(file));
    await db.customSelect('SELECT 1').get(); // force open + createAll
    await seed?.call(db);

    if (version < 15 && !keep.contains('local_id_repairs')) {
      await db.customStatement('DROP TABLE IF EXISTS local_id_repairs');
    }
    if (version < 14 && !keep.contains('category_reconciliations')) {
      await db.customStatement('DROP TABLE IF EXISTS category_reconciliations');
    }
    if (version < 13 && !keep.contains('categories.default_key')) {
      await db.customStatement(
        'DROP INDEX IF EXISTS idx_categories_default_key',
      );
      await db.customStatement(
        'ALTER TABLE categories DROP COLUMN default_key',
      );
    }
    if (version < 12) {
      if (!keep.contains('local_store_metas')) {
        await db.customStatement('DROP TABLE IF EXISTS local_store_metas');
      }
      if (!keep.contains('transactions.occurrence_key')) {
        await db.customStatement(
          'DROP INDEX IF EXISTS idx_transactions_occurrence_key',
        );
        await db.customStatement(
          'ALTER TABLE transactions DROP COLUMN occurrence_key',
        );
      }
    }
    await db.customStatement('PRAGMA user_version = $version');
    await db.close();

    return file;
  }

  /// Every artifact the current schema should have once an upgrade finishes.
  Future<void> expectFullyUpgraded(AppDatabase db) async {
    final version = (await db
        .customSelect('PRAGMA user_version')
        .getSingle()).read<int>('user_version');
    expect(version, db.schemaVersion);

    Future<bool> hasTable(String name) async =>
        (await db
                .customSelect(
                  "SELECT 1 FROM sqlite_master WHERE type='table' AND name='$name'",
                )
                .get())
            .isNotEmpty;
    Future<bool> hasColumn(String table, String column) async =>
        (await db.customSelect('PRAGMA table_info($table)').get()).any(
          (r) => r.read<String>('name') == column,
        );

    expect(await hasTable('local_store_metas'), isTrue);
    expect(await hasTable('category_reconciliations'), isTrue);
    expect(await hasTable('local_id_repairs'), isTrue);
    expect(await hasColumn('transactions', 'occurrence_key'), isTrue);
    expect(await hasColumn('categories', 'default_key'), isTrue);
  }

  test('a schema-12 database upgrades cleanly to the current schema', () async {
    final file = await buildLegacyDatabase(
      12,
      seed: (legacy) async {
        // The kind of rows a real v12 install holds.
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, sync_status, created_at, updated_at) '
          "VALUES (?, 'Groceries', 'local_grocery_store', '#82E0AA', 0, 8, 1, "
          '0, 1, 1)',
          ['cat-groceries'],
        );
        // Already uploaded (sync_status 0): the cloud holds this id, so the
        // migration must KEEP it and only assign the slug.
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, sync_status, created_at, updated_at) '
          "VALUES (?, 'Transfer', 'swap_horiz', '#9E9E9E', 0, -1, 1, 0, 1, 1)",
          [SystemCategories.legacyFixedTransferCategoryId],
        );
        // Never uploaded (sync_status 1): safe to re-key, and it must be —
        // a globally fixed id collides with other users on the backend.
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, sync_status, created_at, updated_at) '
          "VALUES (?, 'Balance Correction', 'tune', '#607D8B', 0, -2, 1, 1, 1, "
          '1)',
          [SystemCategories.legacyFixedBalanceCorrectionCategoryId],
        );
        // A user-created category that happens to share a built-in's name.
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, sync_status, created_at, updated_at) '
          "VALUES ('cat-custom', 'Groceries', 'category', '#111111', 0, 99, 0, "
          '0, 1, 1)',
        );
        await legacy.customStatement(
          'INSERT INTO wallets (id, name, icon_name, color, currency, balance, '
          'opening_balance, is_default, wallet_type, order_index, sync_status, '
          "created_at, updated_at) VALUES ('w1', 'Cash', 'wallet', '#fff', "
          "'USD', 0, 0, 1, 0, 0, 0, 1, 1)",
        );
        await legacy.customStatement(
          'INSERT INTO transactions (id, amount, title, type, '
          'transaction_type, date, is_income, wallet_id, category_id, '
          'is_recurring, is_paid, paid_amount, skip_paid, sync_status, '
          "created_at, updated_at) VALUES ('t-transfer', 500, 'Move', "
          "'regular', 'transfer', 1, 0, 'w1', ?, 0, 1, 0, 0, 0, 1, 1)",
          [SystemCategories.legacyFixedTransferCategoryId],
        );
        // A row written by an older build with the wrong type spelling.
        await legacy.customStatement(
          'INSERT INTO transactions (id, amount, title, type, '
          'transaction_type, date, is_income, wallet_id, is_recurring, '
          'is_paid, paid_amount, skip_paid, sync_status, created_at, '
          "updated_at) VALUES ('t-occurrence', 1500, 'Streaming', 'regular', "
          "'recurringInstance', 1, 0, 'w1', 0, 1, 0, 0, 0, 1, 1)",
        );
      },
    );

    // Opening the rolled-back file runs onUpgrade for real.
    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    // An existing default gains its cross-device identity.
    final groceries = await upgraded.findCategoryById('cat-groceries');
    expect(groceries, isNotNull);
    expect(groceries!.defaultKey, 'groceries');

    // A user-created category with the same NAME is left alone: matching by
    // name is not proof of equivalence.
    final custom = await upgraded.findCategoryById('cat-custom');
    expect(custom, isNotNull);
    expect(custom!.defaultKey, isNull);
    expect(custom.deletedAt, isNull);

    // A fixed id the CLOUD already holds is kept — re-keying it would leave the
    // device pointing at one category while the cloud points at another, and a
    // later restore would hand back the stale relationship.
    final transfer = await upgraded.findCategoryByDefaultKey(
      SystemCategories.transferKey,
    );
    expect(transfer, isNotNull);
    expect(
      transfer!.id,
      SystemCategories.legacyFixedTransferCategoryId,
      reason: 'the server has this id; changing it locally would diverge',
    );
    final transferTxn = await upgraded.findTransactionById('t-transfer');
    expect(transferTxn!.categoryId, transfer.id);

    // A fixed id the cloud has NEVER seen is re-keyed, because leaving it would
    // collide with another user on the backend.
    expect(
      await upgraded.findCategoryById(
        SystemCategories.legacyFixedBalanceCorrectionCategoryId,
      ),
      isNull,
    );
    final correction = await upgraded.findCategoryByDefaultKey(
      SystemCategories.balanceCorrectionKey,
    );
    expect(correction, isNotNull);
    expect(
      correction!.id,
      isNot(SystemCategories.legacyFixedBalanceCorrectionCategoryId),
    );
    expect(correction.syncStatus, SyncStatus.pendingCreate);

    // The transaction type spelling was normalised.
    final occurrence = await upgraded.findTransactionById('t-occurrence');
    expect(
      occurrence!.transactionType,
      TransactionType.recurringInstance.storageValue,
    );

    // The unique index really is in place.
    final indexes = await upgraded
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name = 'idx_categories_default_key'",
        )
        .get();
    expect(indexes, hasLength(1));
  });

  test('the upgraded database rejects a duplicate default slug', () async {
    final file = await buildLegacyDatabase(12);
    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    await upgraded.ensureSystemCategoriesExist();

    // A second row claiming the same built-in must be impossible.
    await expectLater(
      upgraded.customStatement(
        'INSERT INTO categories (id, name, icon_name, color, is_income, '
        'order_index, is_default, default_key, sync_status, created_at, '
        "updated_at) VALUES ('dupe', 'Transfer', 'swap_horiz', '#9E9E9E', 0, "
        '-1, 1, ?, 1, 1, 1)',
        [SystemCategories.transferKey],
      ),
      throwsA(anything),
    );
  });

  test('a v12 database with duplicate defaults is repaired on upgrade', () async {
    final file = await buildLegacyDatabase(
      12,
      seed: (legacy) async {
        await legacy.customStatement(
          'INSERT INTO wallets (id, name, icon_name, color, currency, balance, '
          'opening_balance, is_default, wallet_type, order_index, sync_status, '
          "created_at, updated_at) VALUES ('w1', 'Cash', 'wallet', '#fff', "
          "'USD', 0, 0, 1, 0, 0, 0, 1, 1)",
        );
        for (final id in ['dup-a', 'dup-b']) {
          await legacy.customStatement(
            'INSERT INTO categories (id, name, icon_name, color, is_income, '
            'order_index, is_default, sync_status, created_at, updated_at) '
            "VALUES (?, 'Groceries', 'local_grocery_store', '#82E0AA', 0, 8, "
            '1, 0, 1, 1)',
            [id],
          );
        }
        await legacy.customStatement(
          'INSERT INTO transactions (id, amount, title, type, '
          'transaction_type, date, is_income, wallet_id, category_id, '
          'is_recurring, is_paid, paid_amount, skip_paid, sync_status, '
          "created_at, updated_at) VALUES ('t-dup', 700, 'Shop', 'regular', "
          "'regular', 1, 0, 'w1', 'dup-b', 0, 1, 0, 0, 0, 1, 1)",
        );
      },
    );

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    // Exactly one live row claims the slug...
    final live = (await upgraded.getAllCategories())
        .where((c) => c.defaultKey == 'groceries')
        .toList();
    expect(live, hasLength(1));

    // ...and the duplicate is actually GONE, not merely left slug-less. Simply
    // skipping it would stop future slug collisions while leaving the user
    // staring at two "Groceries" categories — which is the defect this repair
    // exists for.
    final allGroceries = (await upgraded.getAllCategories())
        .where((c) => c.name == 'Groceries')
        .toList();
    expect(
      allGroceries,
      hasLength(1),
      reason: 'the duplicate default must be merged away, not just ignored',
    );

    // The loser's transaction was re-filed onto the survivor, not orphaned or
    // deleted.
    final txn = await upgraded.findTransactionById('t-dup');
    expect(txn, isNotNull);
    expect(txn!.amount, 700);
    expect(txn.categoryId, live.single.id);
    final owner = await upgraded.findCategoryById(txn.categoryId!);
    expect(owner, isNotNull);
    expect(owner!.deletedAt, isNull);
  });

  test('upgrading is idempotent across a second open', () async {
    final file = await buildLegacyDatabase(12);

    final first = AppDatabase(NativeDatabase(file));
    await first.ensureSystemCategoriesExist();
    final firstIds = (await first.getAllCategories()).map((c) => c.id).toSet();
    await first.close();

    final second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);
    expect(
      (await second.getAllCategories()).map((c) => c.id).toSet(),
      firstIds,
    );
  });

  test('a schema-13 database gains the reconciliation table', () async {
    // Schema 14 is purely additive: somewhere to keep a question the server
    // asked about a built-in category until the user answers it. An existing
    // install must gain the table without losing anything it already had.
    final file = await buildLegacyDatabase(
      13,
      seed: (legacy) async {
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, default_key, sync_status, created_at, '
          "updated_at) VALUES ('cat-keep', 'Groceries', 'x', '#fff', 0, 8, 1, "
          "'groceries', 0, 1, 1)",
        );
      },
    );

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    expect(await upgraded.allCategoryReconciliations(), isEmpty);
    await upgraded.recordCategoryReconciliation(
      defaultKey: 'groceries',
      provisionalCategoryId: 'cat-provisional',
      catalogName: 'Groceries',
      catalogIsIncome: false,
      candidatesJson: '[]',
    );
    expect(await upgraded.unresolvedCategoryReconciliations(), hasLength(1));

    final kept = await upgraded.findCategoryById('cat-keep');
    expect(kept, isNotNull);
    expect(kept!.defaultKey, 'groceries');
  });

  test('schema 14 drops budget references to categories that are gone', () async {
    // `categoryIds` and the legacy `categoryId` are not foreign keys, and builds
    // before this one did not prune them when a category was deleted. A budget
    // left pointing at a deleted category does not fail — it silently counts
    // nothing — and it would now be rejected by the server too.
    final file = await buildLegacyDatabase(
      13,
      seed: (legacy) async {
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, sync_status, created_at, updated_at) '
          "VALUES ('cat-live', 'Transport', 'x', '#fff', 0, 1, 0, 0, 1, 1)",
        );
        // Tombstoned: the row is still present but no longer live.
        await legacy.customStatement(
          'INSERT INTO categories (id, name, icon_name, color, is_income, '
          'order_index, is_default, sync_status, created_at, updated_at, '
          "deleted_at) VALUES ('cat-dead', 'Hobbies', 'x', '#fff', 0, 2, 0, 0, "
          '1, 1, 1)',
        );
        // Already uploaded, so the prune must leave it an update, not a create.
        await legacy.customStatement(
          'INSERT INTO budgets (id, name, amount, period, start_date, '
          'wallet_ids, category_ids, category_id, sync_status, created_at, '
          "updated_at) VALUES ('b-synced', 'Mixed', 5000, 'monthly', 1, '[]', "
          '\'["cat-live","cat-dead","cat-vanished"]\', \'cat-dead\', 0, 1, 1)',
        );
        // Never uploaded: must stay a pending create.
        await legacy.customStatement(
          'INSERT INTO budgets (id, name, amount, period, start_date, '
          'wallet_ids, category_ids, category_id, sync_status, created_at, '
          "updated_at) VALUES ('b-new', 'Fresh', 900, 'monthly', 1, '[]', "
          '\'["cat-dead"]\', NULL, 1, 1, 1)',
        );
        // Untouched: nothing dead to remove.
        await legacy.customStatement(
          'INSERT INTO budgets (id, name, amount, period, start_date, '
          'wallet_ids, category_ids, category_id, sync_status, created_at, '
          "updated_at) VALUES ('b-clean', 'Clean', 100, 'monthly', 1, '[]', "
          '\'["cat-live"]\', NULL, 0, 1, 1)',
        );
      },
    );

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);

    final synced = await upgraded.findBudgetById('b-synced');
    expect(AppDatabase.decodeIdList(synced!.categoryIds), ['cat-live']);
    expect(synced.categoryId, isNull);
    expect(synced.syncStatus, SyncStatus.pendingUpdate);

    final fresh = await upgraded.findBudgetById('b-new');
    expect(AppDatabase.decodeIdList(fresh!.categoryIds), isEmpty);
    expect(
      fresh.syncStatus,
      SyncStatus.pendingCreate,
      reason: 'a never-uploaded budget must not be downgraded to an update',
    );

    final clean = await upgraded.findBudgetById('b-clean');
    expect(AppDatabase.decodeIdList(clean!.categoryIds), ['cat-live']);
    expect(clean.syncStatus, SyncStatus.synced);
  });

  group('a partially applied migration still opens', () {
    // The crash this group exists for:
    //
    //   SQLiteException: duplicate column name: occurrence_key
    //
    // SQLite commits each ALTER TABLE on its own, and Drift stamps
    // `user_version` only once the whole upgrade finishes. An upgrade killed in
    // between — force-close, low storage, OS reclaiming the process — therefore
    // leaves the column in place and the version behind. The next launch
    // replays the migration, tries to add the column again, and the database
    // will not open at all.
    //
    // That is the worst possible failure for a local-first app: the user is
    // locked out of records that are sitting right there, and the advice that
    // superficially "works" — clear app data — throws away everything not yet
    // uploaded.

    /// A row in every table the migrations touch, so each case can prove the
    /// upgrade preserved data rather than just completing.
    Future<void> seedRepresentativeRows(AppDatabase legacy) async {
      await legacy.customStatement(
        'INSERT INTO wallets (id, name, balance, opening_balance, currency, '
        'wallet_type, icon_name, color, is_default, order_index, sync_status, '
        "created_at, updated_at) VALUES ('w-keep', 'Cash', 4200, 0, 'USD', 0, "
        "'wallet', '#fff', 1, 0, 0, 1, 1)",
      );
      await legacy.customStatement(
        'INSERT INTO categories (id, name, icon_name, color, is_income, '
        'order_index, is_default, sync_status, created_at, updated_at) '
        "VALUES ('c-keep', 'Groceries', 'shop', '#82E0AA', 0, 8, 1, 0, 1, 1)",
      );
      await legacy.customStatement(
        'INSERT INTO transactions (id, title, amount, date, is_income, '
        'wallet_id, category_id, transaction_type, is_paid, paid_amount, '
        'skip_paid, sync_status, created_at, updated_at) VALUES '
        "('t-keep', 'Weekly shop', 1999, 1, 0, 'w-keep', 'c-keep', 'regular', "
        '1, 0, 0, 0, 1, 1)',
      );
    }

    Future<void> expectRowsSurvived(AppDatabase db) async {
      expect((await db.findWalletById('w-keep'))?.balance, 4200);
      expect((await db.findCategoryById('c-keep'))?.name, 'Groceries');
      final txn = await db.findTransactionById('t-keep');
      expect(txn?.amount, 1999);
      expect(txn?.walletId, 'w-keep');
    }

    /// Opening twice is the real acceptance criterion. The first open fixes the
    /// database; the second proves the fix is stable rather than something that
    /// only works while the version is still behind.
    Future<void> expectOpensTwice(File file) async {
      final first = AppDatabase(NativeDatabase(file));
      await expectFullyUpgraded(first);
      await expectRowsSurvived(first);
      await first.close();

      final second = AppDatabase(NativeDatabase(file));
      addTearDown(second.close);
      await expectFullyUpgraded(second);
      await expectRowsSurvived(second);
    }

    test('v11 that already has occurrence_key', () async {
      // The exact reported state: version 11, schema-12 column already present.
      final file = await buildLegacyDatabase(
        11,
        label: '11_occurrence_key',
        keep: {'transactions.occurrence_key'},
        seed: seedRepresentativeRows,
      );
      await expectOpensTwice(file);
    });

    test('v11 that already has local_store_metas', () async {
      final file = await buildLegacyDatabase(
        11,
        label: '11_store_metas',
        keep: {'local_store_metas'},
        seed: seedRepresentativeRows,
      );
      await expectOpensTwice(file);
    });

    test('v11 that already has both schema-12 artifacts', () async {
      final file = await buildLegacyDatabase(
        11,
        label: '11_both',
        keep: {'transactions.occurrence_key', 'local_store_metas'},
        seed: seedRepresentativeRows,
      );
      await expectOpensTwice(file);
    });

    test('v12 that already has categories.default_key', () async {
      final file = await buildLegacyDatabase(
        12,
        label: '12_default_key',
        keep: {'categories.default_key'},
        seed: seedRepresentativeRows,
      );
      await expectOpensTwice(file);

      // The point of skipping only the schema step: the data step still has to
      // run, or the column would exist with nothing in it and the built-in
      // category would never gain its slug.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      expect((await db.findCategoryById('c-keep'))?.defaultKey, 'groceries');
    });

    test('v13 that already has category_reconciliations', () async {
      final file = await buildLegacyDatabase(
        13,
        label: '13_reconciliations',
        keep: {'category_reconciliations'},
        seed: seedRepresentativeRows,
      );
      await expectOpensTwice(file);
    });

    test('v14 that already has local_id_repairs', () async {
      final file = await buildLegacyDatabase(
        14,
        label: '14_id_repairs',
        keep: {'local_id_repairs'},
        seed: seedRepresentativeRows,
      );
      await expectOpensTwice(file);
    });

    test('an interrupted v11 upgrade keeps unsynced local work', () async {
      // The records that make "clear app data" unacceptable advice: rows this
      // device created and has never uploaded.
      final file = await buildLegacyDatabase(
        11,
        label: '11_unsynced',
        keep: {'transactions.occurrence_key'},
        seed: (legacy) async {
          await seedRepresentativeRows(legacy);
          await legacy.customStatement(
            'INSERT INTO transactions (id, title, amount, date, is_income, '
            'wallet_id, category_id, transaction_type, is_paid, paid_amount, '
            'skip_paid, sync_status, created_at, updated_at) VALUES '
            "('t-unsynced', 'Not yet uploaded', 700, 1, 0, 'w-keep', 'c-keep', "
            "'regular', 1, 0, 0, 1, 1, 1)",
          );
        },
      );

      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      await expectFullyUpgraded(db);

      final unsynced = await db.findTransactionById('t-unsynced');
      expect(unsynced, isNotNull);
      expect(unsynced!.amount, 700);
      expect(
        unsynced.syncStatus,
        SyncStatus.pendingCreate,
        reason: 'an interrupted upgrade must not cost the user unsynced work',
      );
    });
  });

  test('a database already at the current schema is left alone', () async {
    final file = File('${tempDir.path}/current.sqlite');
    final db = AppDatabase(NativeDatabase(file));
    await db.ensureSystemCategoriesExist();
    final before = (await db.getAllCategories()).map((c) => c.id).toSet();
    await db.close();

    final reopened = AppDatabase(NativeDatabase(file));
    addTearDown(reopened.close);
    expect(
      (await reopened.getAllCategories()).map((c) => c.id).toSet(),
      before,
    );
  });
}
