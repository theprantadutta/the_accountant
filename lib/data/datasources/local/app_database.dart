import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/models/category.dart';
import 'package:the_accountant/data/models/transaction.dart';
import 'package:the_accountant/data/models/wallet.dart';
import 'package:the_accountant/data/models/budget.dart';
import 'package:the_accountant/data/models/user.dart';
import 'package:the_accountant/data/models/settings.dart';
import 'package:the_accountant/data/models/user_profile.dart';
import 'package:the_accountant/data/models/payment_method.dart';
import 'package:the_accountant/data/models/recurring_config.dart';
import 'package:the_accountant/data/models/objective.dart';
import 'package:the_accountant/data/models/objective_transaction.dart';
import 'package:the_accountant/data/models/associated_title.dart';
import 'package:the_accountant/data/models/sync_state.dart';
import 'package:the_accountant/data/models/exchange_rate.dart';
import 'package:the_accountant/data/models/local_store_meta.dart';
import 'package:the_accountant/data/models/category_reconciliation.dart';
import 'package:the_accountant/data/models/local_id_repair.dart';

part 'app_database.g.dart';

/// Data class for export queries with resolved category/wallet names
class ExportTransaction {
  final Transaction transaction;
  final String categoryName;
  final String walletName;

  const ExportTransaction({
    required this.transaction,
    required this.categoryName,
    required this.walletName,
  });
}

/// Sync status values
class SyncStatus {
  static const int synced = 0;
  static const int pendingCreate = 1;
  static const int pendingUpdate = 2;
  static const int pendingDelete = 3;
  static const int conflict = 4;

  /// The status a row should carry after being edited locally.
  ///
  /// **An edit must never downgrade a create.** A row the server has never
  /// acknowledged is `pendingCreate`; rewriting it to `pendingUpdate` makes the
  /// next push ask the server to update a row that does not exist, which the
  /// server answers with "not found" — every time, for ever. The record then
  /// sits pending on the device and can never reach the cloud.
  ///
  /// That is not a rare edge case: a brand-new device records transactions
  /// against its own not-yet-uploaded categories and wallets, and the wallet
  /// balance is rewritten on every single transaction. Any mutation helper that
  /// hard-codes `pendingUpdate` will silently strand those records.
  ///
  /// A tombstone stays a tombstone — editing a deleted row is not a
  /// resurrection.
  static int markEdited(int current) {
    if (current == pendingCreate) return pendingCreate;
    if (current == pendingDelete) return pendingDelete;
    return pendingUpdate;
  }

  /// SQL fragment equivalent to [markEdited], for bulk updates that would
  /// otherwise have to read every row first.
  ///
  /// Usable directly in a `customStatement`:
  /// `UPDATE wallets SET balance = ?, sync_status = $markEditedSql WHERE ...`
  static const String markEditedSql =
      'CASE WHEN sync_status = $pendingCreate THEN $pendingCreate '
      'WHEN sync_status = $pendingDelete THEN $pendingDelete '
      'ELSE $pendingUpdate END';
}

/// Identifiers for the system-managed categories.
///
/// System categories are addressed by **slug**, not by a hard-coded id.
///
/// Schema 12 gave them fixed UUIDs so they would resolve to the same row on
/// every device. That turned out to be actively dangerous: the backend's
/// category primary key is global, so the second user on a server to sync a
/// transfer hit a primary-key collision — and because that collision surfaces at
/// flush time rather than at apply time, it aborted their entire push batch, not
/// just the one record.
///
/// Ids are therefore random per install again, and cross-device identity comes
/// from `categories.default_key` (see [DefaultCategoryCatalog]). Callers resolve
/// the current id with [AppDatabase.requireSystemCategoryId].
class SystemCategories {
  const SystemCategories._();

  static const String transferKey = SystemCategoryKeys.transfer;
  static const String balanceCorrectionKey =
      SystemCategoryKeys.balanceCorrection;

  /// Fixed UUIDs assigned by schema 12, migrated away from in schema 13.
  /// Retained so the migration can find and re-key those rows.
  static const String legacyFixedTransferCategoryId =
      '00000000-0000-4000-8000-000000000001';
  static const String legacyFixedBalanceCorrectionCategoryId =
      '00000000-0000-4000-8000-000000000002';

  /// Pre-schema-12 sentinel ids, which were not GUIDs at all.
  static const String legacyTransferCategoryId = 'transfer-category-0';
  static const String legacyBalanceCorrectionCategoryId =
      'balance-correction-0';

  /// Every slug that identifies a system category.
  static const List<String> allKeys = SystemCategoryKeys.all;
}

@DriftDatabase(
  tables: [
    // Core tables
    Users,
    Categories,
    Wallets,
    Transactions,
    Budgets,
    Settings,
    UserProfiles,
    PaymentMethods,
    // New tables
    RecurringConfigs,
    Objectives,
    ObjectiveTransactions,
    AssociatedTitles,
    SyncStates,
    ExchangeRates,
    LocalStoreMetas,
    CategoryReconciliations,
    LocalIdRepairs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 17;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 10) {
        // Fix credit/debt isIncome values and recalculate wallet balances
        // Debt (borrowed) transactions should be isIncome=true (money comes IN)
        await customStatement('''
          UPDATE transactions
          SET is_income = 1, updated_at = datetime('now')
          WHERE special_type = 5 AND is_income = 0 AND deleted_at IS NULL
        ''');

        // Credit (lent) transactions should be isIncome=false (money goes OUT)
        await customStatement('''
          UPDATE transactions
          SET is_income = 0, updated_at = datetime('now')
          WHERE special_type = 4 AND is_income = 1 AND deleted_at IS NULL
        ''');

        // Recalculate all wallet balances from scratch
        // Count paid transactions + credit/debt (special_type 4=credit, 5=debt)
        // Skip unpaid upcoming transactions (special_type 1)
        await customStatement('''
          UPDATE wallets SET balance = COALESCE(
            (SELECT SUM(
              CASE WHEN t.is_income = 1 THEN t.amount ELSE -t.amount END
            ) FROM transactions t
            WHERE t.wallet_id = wallets.id
              AND t.deleted_at IS NULL
              AND (t.is_paid = 1 OR t.special_type IN (4, 5))),
            0.0
          ) WHERE deleted_at IS NULL
        ''');
      }

      if (from < 11) {
        // Convert all MONEY from REAL (double dollars) to INTEGER minor units (cents).
        // SQLite column affinity is loose, so we focus on converting the stored VALUES.
        // Order matters: (1) multiply money by 100, (2) add opening_balance column,
        // (3) backfill opening_balance from now-integer cents values.

        // 1) Convert money values to integer cents.
        await customStatement(
          'UPDATE wallets SET balance = CAST(ROUND(balance * 100) AS INTEGER), '
          'credit_limit = CASE WHEN credit_limit IS NULL THEN NULL '
          'ELSE CAST(ROUND(credit_limit * 100) AS INTEGER) END;',
        );
        await customStatement(
          'UPDATE transactions SET amount = CAST(ROUND(amount * 100) AS INTEGER), '
          'paid_amount = CAST(ROUND(paid_amount * 100) AS INTEGER);',
        );
        await customStatement(
          'UPDATE budgets SET amount = CAST(ROUND(amount * 100) AS INTEGER);',
        );
        await customStatement(
          'UPDATE objectives SET target_amount = CAST(ROUND(target_amount * 100) AS INTEGER);',
        );

        // 2) Add the new opening_balance column (defaults to 0).
        await m.addColumn(wallets, wallets.openingBalance);

        // 3) Backfill opening_balance so that
        //    opening_balance + Σ(realized txn effects) == current balance.
        //    Money is already integer cents at this point.
        await customStatement(
          'UPDATE wallets SET opening_balance = balance - COALESCE('
          '(SELECT SUM(CASE WHEN t.is_income = 1 THEN t.amount ELSE -t.amount END) '
          'FROM transactions t WHERE t.wallet_id = wallets.id '
          'AND t.deleted_at IS NULL '
          'AND (t.is_paid = 1 OR t.special_type IN (4, 5))), 0);',
        );
      }

      if (from < 12) {
        await _migrateToV12(m);
      }

      if (from < 13) {
        await _migrateToV13(m);
      }

      if (from < 14) {
        await _migrateToV14(m);
      }

      if (from < 15) {
        await _migrateToV15(m);
      }

      if (from < 16) {
        await _migrateToV16(m);
      }
      if (from < 17) {
        await _migrateToV17();
      }
    },
    beforeOpen: (details) async {
      // NOTE on foreign keys: SQLite leaves FK enforcement off by default and we
      // deliberately keep it that way. Existing installs can contain rows that
      // reference hard-deleted parents, and switching enforcement on globally
      // would turn those legacy rows into hard write failures during ordinary
      // use. Instead, the sync layer validates every referenced parent
      // explicitly before applying a pulled child (see
      // `SyncService._missingParentFor`), which gives the same protection with
      // an actionable diagnostic and a retry path rather than a raw constraint
      // error.
      //
      // The single LocalStoreMeta row must exist before anything reads it.
      await _ensureLocalStoreMetaRow();
      await _installSyncStatusGuards();
    },
  );

  /// Schema 12 does four things, all of them designed to leave existing rows
  /// recoverable:
  ///
  /// 1. **System categories get real UUIDs.** `transfer-category-0` /
  ///    `balance-correction-0` are not GUIDs, so the backend could never accept
  ///    a transfer. Both the category rows and every transaction referencing
  ///    them are rewritten to the new deterministic ids, in that order, so no
  ///    reference is ever dangling. If a row with the new id somehow already
  ///    exists the legacy row is folded into it rather than colliding.
  /// 2. **Every never-uploaded category becomes pending-create.** Default
  ///    categories were written with `syncStatus = synced` even though they had
  ///    never been pushed, so the server rejected every transaction that
  ///    referenced them. Re-pushing an already-present category is a no-op
  ///    server-side (create is idempotent on id), so flipping all synced rows is
  ///    safe and self-healing for users whose categories *did* upload.
  /// 3. **Objective links move to `transactions.objective_id`.** The junction
  ///    table never synced; its contents are backfilled onto the transaction so
  ///    the single synced column becomes the source of truth.
  /// 4. **Recurrence occurrence keys are backfilled** for already-generated
  ///    instances so the new uniqueness constraint can't reject legitimate
  ///    history, and duplicates that already exist are collapsed first.
  Future<void> _migrateToV12(Migrator m) async {
    await _ensureTable(m, localStoreMetas);
    await _ensureColumn(m, transactions, transactions.occurrenceKey);
    await applyV12DataMigrations();
  }

  /// The data half of the schema-12 migration, separated from the schema half so
  /// it can be exercised directly by tests against a database that already has
  /// the v12 columns. (Public for that reason only; nothing else should call it.)
  Future<void> applyV12DataMigrations() async {
    // --- 1. System category identity ------------------------------------
    for (final (legacyId, newId) in const [
      (
        SystemCategories.legacyTransferCategoryId,
        SystemCategories.legacyFixedTransferCategoryId,
      ),
      (
        SystemCategories.legacyBalanceCorrectionCategoryId,
        SystemCategories.legacyFixedBalanceCorrectionCategoryId,
      ),
    ]) {
      // Re-point children first only if the new parent already exists;
      // otherwise rename the parent row in place and children follow.
      await customStatement(
        'UPDATE OR IGNORE categories SET id = ?, sync_status = ? '
        'WHERE id = ? AND NOT EXISTS (SELECT 1 FROM categories WHERE id = ?)',
        [newId, SyncStatus.pendingCreate, legacyId, newId],
      );
      await customStatement(
        'UPDATE transactions SET category_id = ? WHERE category_id = ?',
        [newId, legacyId],
      );
      await customStatement(
        'UPDATE categories SET main_category_id = ? WHERE main_category_id = ?',
        [newId, legacyId],
      );
      // Anything still on the legacy id means the new row already existed;
      // drop the now-unreferenced legacy row.
      await customStatement('DELETE FROM categories WHERE id = ?', [legacyId]);
    }

    // --- 2. Make local categories uploadable -----------------------------
    await customStatement(
      'UPDATE categories SET sync_status = ? WHERE sync_status = ? '
      'AND deleted_at IS NULL',
      [SyncStatus.pendingCreate, SyncStatus.synced],
    );

    // --- 3. Objective junction -> transactions.objective_id --------------
    await customStatement('''
      UPDATE transactions
      SET objective_id = (
            SELECT ot.objective_id FROM objective_transactions ot
            WHERE ot.transaction_id = transactions.id LIMIT 1
          ),
          sync_status = CASE WHEN sync_status = ${SyncStatus.synced}
                             THEN ${SyncStatus.pendingUpdate} ELSE sync_status END
      WHERE objective_id IS NULL
        AND EXISTS (SELECT 1 FROM objective_transactions ot
                    WHERE ot.transaction_id = transactions.id)
    ''');

    // --- 4. Recurrence occurrence keys -----------------------------------
    // Drift stores DateTime columns as Unix seconds, so the 'unixepoch'
    // modifier is required to read a calendar day out of them. The resulting
    // day is UTC, which is exactly what RecurringService.occurrenceKeyFor
    // produces at runtime — the two must agree or the backfilled keys would
    // never match newly generated ones.
    //
    // Collapse pre-existing duplicates (same config + same UTC day) down to the
    // oldest row so the unique index below can be created at all.
    await customStatement('''
      DELETE FROM transactions
      WHERE recurring_config_id IS NOT NULL
        AND rowid NOT IN (
          SELECT MIN(rowid) FROM transactions
          WHERE recurring_config_id IS NOT NULL
          GROUP BY recurring_config_id, date(date, 'unixepoch')
        )
    ''');
    await customStatement('''
      UPDATE transactions
      SET occurrence_key =
            recurring_config_id || '@' || date(date, 'unixepoch')
      WHERE recurring_config_id IS NOT NULL AND occurrence_key IS NULL
    ''');
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_transactions_occurrence_key '
      'ON transactions (occurrence_key)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_paired '
      'ON transactions (paired_transaction_id)',
    );
  }

  /// Schema 13 gives every built-in category a cross-device identity and
  /// retires the two fixed system-category UUIDs.
  ///
  /// 1. **Add `categories.default_key`.**
  /// 2. **Re-key the fixed system UUIDs.** Schema 12 gave Transfer and Balance
  ///    Correction hard-coded ids so they would resolve identically everywhere.
  ///    That is unsafe: the backend's category primary key is global, so the
  ///    second user to sync a transfer collides — and the collision surfaces at
  ///    flush time, aborting their whole push batch rather than one record. Those
  ///    rows get fresh random ids (references re-pointed) plus their slug.
  /// 3. **Backfill slugs for existing defaults**, matched on name + direction.
  ///    Only rows flagged `is_default` are considered, so a user-created category
  ///    that happens to be called "Groceries" is never claimed as a built-in.
  /// 4. **Merge duplicates** that already accumulated — one row per slug,
  ///    survivor chosen deterministically, references re-pointed, nothing
  ///    deleted outright.
  /// 5. **Normalise `transaction_type`.** Rows pulled by an older build were
  ///    written as `recurringInstance`, which matched neither the column
  ///    convention nor the domain policy, so a synced recurrence instance
  ///    stopped being recognised as one.
  Future<void> _migrateToV13(Migrator m) async {
    await _ensureColumn(m, categories, categories.defaultKey);
    await applyV13DataMigrations();
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_default_key '
      'ON categories (default_key)',
    );
  }

  // ==================== MIGRATION INTROSPECTION ====================
  //
  // Every schema step below asks the database what it actually contains before
  // changing it, instead of trusting `user_version` to describe it.
  //
  // Those two can disagree. An upgrade that adds a column and then fails —
  // process killed, device out of storage, app force-closed mid-update — leaves
  // the column in place with the version un-recorded, because SQLite commits
  // each `ALTER TABLE` on its own and Drift stamps the version at the end. The
  // next launch replays the migration from the old version, hits
  // `duplicate column name: occurrence_key`, and the database will not open at
  // all. The user is then locked out of their own records, and the only advice
  // that "works" — clear app data — destroys everything not yet uploaded.
  //
  // So a schema step that is already done is skipped, and the data step that
  // follows it still runs. Skipping the whole migration because its column
  // exists would be the same bug wearing a different hat: the column would be
  // there and the backfill that gives it meaning would not.

  Future<bool> _tableExists(String name) async {
    final rows = await customSelect(
      "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
      variables: [Variable<String>(name)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<bool> _columnExists(String table, String column) async {
    if (!await _tableExists(table)) return false;
    // PRAGMA does not take bound parameters, but `table` here is always a
    // Drift-generated name, never user input.
    final rows = await customSelect('PRAGMA table_info($table)').get();
    return rows.any((row) => row.read<String>('name') == column);
  }

  /// Create [table] unless the database already has it.
  Future<void> _ensureTable(Migrator m, TableInfo table) async {
    if (await _tableExists(table.actualTableName)) return;
    await m.createTable(table);
  }

  /// Add [column] to [table] unless the database already has it.
  Future<void> _ensureColumn(
    Migrator m,
    TableInfo table,
    GeneratedColumn column,
  ) async {
    if (await _columnExists(table.actualTableName, column.name)) return;
    await m.addColumn(table, column);
  }

  /// Schema 14: somewhere to keep a reconciliation question the server asked
  /// about a built-in category, until the user answers it — plus a one-off
  /// clean-up of budget category references.
  ///
  /// The new table is device-local and exists because the question outlives the
  /// sync that raised it: the user may be offline, or simply not looking, and
  /// the alternative to remembering it is re-pushing a create the server will
  /// reject every single time.
  ///
  /// The clean-up drops budget references to wallets and categories that are
  /// already gone. `walletIds`, `categoryIds`, and the legacy `categoryId` are
  /// not foreign keys and earlier builds did not prune them on delete, so a
  /// budget can be scoped to rows that no longer exist — which makes it count
  /// nothing, and would make it unpushable now that the server checks that a
  /// budget's wallets and categories are live. Non-destructive: it removes
  /// pointers to deleted rows, never a budget.
  Future<void> _migrateToV14(Migrator m) async {
    await _ensureTable(m, categoryReconciliations);
    await applyV14DataMigrations();
  }

  /// The data half of the schema-14 migration. (Public so it can be exercised
  /// directly.)
  Future<void> applyV14DataMigrations() async {
    await pruneDeadBudgetReferences();
  }

  /// Schema 15: give onboarding's timestamp wallet ids a real UUID.
  ///
  /// Post-signup onboarding minted its wallet id from
  /// `DateTime.now().millisecondsSinceEpoch`. The backend's `SyncChange.EntityId`
  /// is a `Guid`, so such an id cannot bind at all — and because the push is one
  /// request, the single bad wallet rejects the whole batch. The user's first
  /// wallet, and every transaction, objective and budget filed against it, stay
  /// pending forever with nothing on screen to say why.
  ///
  /// Only a wallet the server has never seen is re-keyed; see
  /// [rekeyUnsyncedNonUuidWallets] for why the rest are left alone.
  Future<void> _migrateToV15(Migrator m) async {
    await _ensureTable(m, localIdRepairs);
    await applyV15DataMigrations();
  }

  /// The data half of the schema-15 migration. (Public so it can be exercised
  /// directly.)
  Future<void> applyV15DataMigrations() async {
    await rekeyUnsyncedNonUuidWallets();
  }

  /// Schema 16: record which transfer a fee belongs to.
  ///
  /// Purely additive — one nullable column, no backfill. Existing transfers have
  /// no fee, which is exactly what null means here.
  Future<void> _migrateToV16(Migrator m) async {
    await _ensureColumn(m, transactions, transactions.feeForTransactionId);
  }

  /// Schema 17: give the two built-ins that were both called "Loan" distinct
  /// names.
  ///
  /// Categories are one flat list now — the user picks from all of them
  /// whichever way the money is going — so two rows called "Loan" are two rows
  /// nobody can tell apart. They used to be distinguishable only by which side
  /// of the ledger they sat on, which is exactly the distinction that stopped
  /// being shown.
  ///
  /// Only rows still carrying the old default name are touched: someone who
  /// renamed the category themselves keeps their own name. Tombstones are left
  /// alone, so this cannot push an update for a row that is on its way out.
  Future<void> _migrateToV17() async {
    if (!await _tableExists('categories')) return;

    for (final spec in DefaultCategoryCatalog.all) {
      final previousName = spec.legacyName;
      if (previousName == null) continue;

      final stale =
          await (select(categories)..where(
                (c) =>
                    c.defaultKey.equals(spec.key) &
                    c.name.equals(previousName) &
                    c.deletedAt.isNull(),
              ))
              .get();

      for (final row in stale) {
        await (update(categories)..where((c) => c.id.equals(row.id))).write(
          CategoriesCompanion(
            name: Value(spec.name),
            updatedAt: Value(DateTime.now()),
            // Never downgrades a create; never resurrects a tombstone.
            syncStatus: Value(SyncStatus.markEdited(row.syncStatus)),
          ),
        );
      }
    }
  }

  /// A canonical 8-4-4-4-12 hexadecimal id, which is the only shape the backend
  /// will accept.
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  static bool isSyncableId(String id) => _uuidPattern.hasMatch(id);

  /// Replaces unsyncable wallet ids, moving every local reference with them.
  ///
  /// Returns the old-to-new mapping so callers can repoint whatever lives
  /// outside the database.
  ///
  /// The whole thing runs in one transaction: a wallet whose id changed while
  /// its transactions still pointed at the old one would read as an empty
  /// wallet plus a pile of orphaned records, which is worse than the bug being
  /// fixed.
  ///
  /// **A wallet the server might already know is never touched.** Only
  /// `pendingCreate` rows are re-keyed, because those provably have not been
  /// uploaded. If an unsyncable id turns up in any other sync state, something
  /// happened that this migration cannot reason about — so it changes nothing
  /// and records a diagnostic instead. Guessing there could orphan the cloud
  /// copy of real financial data, and a stuck wallet is recoverable in a way
  /// that a severed one is not.
  Future<Map<String, String>> rekeyUnsyncedNonUuidWallets() async {
    return transaction(() async {
      final all = await select(wallets).get();
      final invalid = all.where((w) => !isSyncableId(w.id)).toList();
      if (invalid.isEmpty) return <String, String>{};

      final mapping = <String, String>{};
      final now = DateTime.now();

      for (final wallet in invalid) {
        if (wallet.syncStatus != SyncStatus.pendingCreate) {
          final alreadyLogged =
              await (select(localIdRepairs)
                    ..where((r) => r.oldId.equals(wallet.id))
                    ..where((r) => r.status.equals('blocked'))
                    ..limit(1))
                  .getSingleOrNull();
          if (alreadyLogged == null) {
            await into(localIdRepairs).insert(
              LocalIdRepairsCompanion.insert(
                entityTable: wallets.actualTableName,
                oldId: wallet.id,
                newId: const Value(null),
                status: 'blocked',
                detail: Value(
                  'Wallet "${wallet.name}" has an id the server cannot accept '
                  'but is in sync state ${wallet.syncStatus}, so the cloud may '
                  'already hold it. Left unchanged; needs manual review.',
                ),
                createdAt: Value(now),
              ),
            );
          }
          continue;
        }

        final newId = const Uuid().v4();
        mapping[wallet.id] = newId;

        // Children first, then the wallet itself. Foreign keys are off by
        // design (see beforeOpen), so ordering is a readability choice rather
        // than a constraint — but the transaction is what makes it safe.
        await customStatement(
          'UPDATE transactions SET wallet_id = ? WHERE wallet_id = ?',
          [newId, wallet.id],
        );
        await customStatement(
          'UPDATE objectives SET wallet_id = ? WHERE wallet_id = ?',
          [newId, wallet.id],
        );
        await _repointBudgetWalletIds(from: wallet.id, to: newId);

        // `sync_status` is deliberately not written: the row must stay a
        // pending create, and the guard trigger only watches writes to that
        // column anyway.
        await customStatement('UPDATE wallets SET id = ? WHERE id = ?', [
          newId,
          wallet.id,
        ]);

        await into(localIdRepairs).insert(
          LocalIdRepairsCompanion.insert(
            entityTable: wallets.actualTableName,
            oldId: wallet.id,
            newId: Value(newId),
            status: 'applied',
            detail: Value('Onboarding wallet "${wallet.name}" re-keyed.'),
            createdAt: Value(now),
          ),
        );
      }

      return mapping;
    });
  }

  /// Rewrites a wallet id inside every budget's `walletIds` JSON array.
  Future<void> _repointBudgetWalletIds({
    required String from,
    required String to,
  }) async {
    final affected = await budgetsReferencingWallets({from});
    for (final b in affected) {
      await _writeBudgetScope(
        b.id,
        BudgetsCompanion(
          walletIds: Value(
            jsonEncode(_replaceId(decodeIdList(b.walletIds), from, to)),
          ),
        ),
      );
    }
  }

  /// Re-keys this device has carried out but not yet applied outside the
  /// database.
  Future<List<LocalIdRepair>> unsettledIdRepairs() =>
      (select(localIdRepairs)
            ..where((r) => r.status.equals('applied'))
            ..where((r) => r.settledAt.isNull()))
          .get();

  /// Re-keys that were refused because the server may already hold the id.
  ///
  /// These are surfaced rather than retried: the data is intact and the
  /// resolution is a human decision.
  Future<List<LocalIdRepair>> blockedIdRepairs() =>
      (select(localIdRepairs)..where((r) => r.status.equals('blocked'))).get();

  /// Total repairs logged for wallets, so a test can prove a second open does
  /// not log the same one again.
  Future<int> allWalletRepairCount() async => (await (select(
    localIdRepairs,
  )..where((r) => r.entityTable.equals('wallets'))).get()).length;

  Future<void> markIdRepairSettled(int id) =>
      (update(localIdRepairs)..where((r) => r.id.equals(id))).write(
        LocalIdRepairsCompanion(settledAt: Value(DateTime.now())),
      );

  /// The data half of the schema-13 migration, separated from the schema half so
  /// it can be exercised directly. (Public for that reason only.)
  Future<void> applyV13DataMigrations() async {
    // --- 2. Retire the fixed system category UUIDs -----------------------
    //
    // Schema 12 gave Transfer and Balance Correction hard-coded ids. That is
    // unsafe going forward — the backend's category primary key is global, so a
    // shared id collides across users — but it must be retired WITHOUT breaking
    // rows the cloud already holds.
    //
    // The rule is therefore: re-key only a row the server has never seen.
    //
    // * `pendingCreate` — never uploaded. Safe to give a fresh random id; no
    //   cloud row references it. This covers every user except the single
    //   account that actually managed to push the fixed id (a global primary key
    //   means at most one can exist server-wide).
    // * anything else — the server has this row, and cloud transactions may
    //   reference it. Re-keying here would leave the device pointing at one id
    //   while the cloud points at another, and a later restore would hand back
    //   the stale relationship. The id is kept; only the slug is assigned, which
    //   is enough for cross-device identity from now on. The backend migration
    //   assigns the same slug to its copy.
    for (final (legacyId, slug) in const [
      (
        SystemCategories.legacyFixedTransferCategoryId,
        SystemCategories.transferKey,
      ),
      (
        SystemCategories.legacyFixedBalanceCorrectionCategoryId,
        SystemCategories.balanceCorrectionKey,
      ),
    ]) {
      final existing = await (select(
        categories,
      )..where((c) => c.id.equals(legacyId))).getSingleOrNull();
      if (existing == null) continue;

      if (existing.syncStatus != SyncStatus.pendingCreate) {
        // Known to the cloud: keep the id, just give it its identity.
        await (update(categories)..where((c) => c.id.equals(legacyId))).write(
          CategoriesCompanion(
            defaultKey: Value(slug),
            isDefault: const Value(true),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );
        continue;
      }

      final freshId = const Uuid().v4();
      await customStatement(
        'UPDATE OR IGNORE categories SET id = ?, default_key = ?, '
        'is_default = 1, sync_status = ? WHERE id = ?',
        [freshId, slug, SyncStatus.pendingCreate, legacyId],
      );
      // Re-point children, preserving each row's create/delete sync state: a
      // never-uploaded transaction must stay a create, or the server would be
      // asked to update a row it has never seen and would refuse for ever.
      await repointTransactionsToCategory(
        fromCategoryId: legacyId,
        toCategoryId: freshId,
      );
      await _repointSubcategories(fromId: legacyId, toId: freshId);
      await customStatement(
        'UPDATE associated_titles SET category_id = ? WHERE category_id = ?',
        [freshId, legacyId],
      );
      // If the rename was ignored (a row already held the fresh id — effectively
      // impossible for a v4 UUID) the legacy row would linger; drop it rather
      // than leave a second claimant on the slug.
      await customStatement('DELETE FROM categories WHERE id = ?', [legacyId]);
    }

    // --- 3. Give pre-existing default categories their identity ----------
    //
    // Rows are matched on name AND direction (two built-ins are both called
    // "Loan"), and only rows flagged `is_default` are considered — the app sets
    // that flag, a user cannot, so it is what separates a built-in from a
    // user-created category that happens to share a name.
    //
    // When several rows match the same built-in, the first takes the slug and
    // the rest are MERGED into it rather than left behind. Leaving them would
    // have prevented future slug collisions while doing nothing about the
    // duplicates already on the user's screen, which is the defect this
    // migration exists to repair. Their transactions are re-filed onto the
    // survivor; nothing financial is deleted.
    final defaults =
        await (select(categories)
              ..where((c) => c.isDefault.equals(true))
              ..where((c) => c.defaultKey.isNull())
              ..where((c) => c.deletedAt.isNull())
              ..orderBy([
                (c) => OrderingTerm.asc(c.createdAt),
                (c) => OrderingTerm.asc(c.id),
              ]))
            .get();

    final claimedBy = <String, String>{
      for (final row
          in await (select(categories)
                ..where((c) => c.defaultKey.isNotNull())
                ..where((c) => c.deletedAt.isNull()))
              .get())
        row.defaultKey!: row.id,
    };

    for (final row in defaults) {
      final key = DefaultCategoryCatalog.keyForLegacyDefault(
        name: row.name,
        isIncome: row.isIncome,
      );
      // An unrecognised name is left alone: guessing would claim a category the
      // catalogue does not describe.
      if (key == null) continue;

      final incumbent = claimedBy[key];
      if (incumbent != null) {
        // Provably the same built-in as the incumbent: app-created (is_default)
        // and matching a catalogue entry on name and direction.
        await _absorbCategory(loser: row, survivorId: incumbent);
        continue;
      }

      claimedBy[key] = row.id;
      await (update(categories)..where((c) => c.id.equals(row.id))).write(
        CategoriesCompanion(
          defaultKey: Value(key),
          syncStatus: Value(
            row.syncStatus == SyncStatus.synced
                ? SyncStatus.pendingUpdate
                : row.syncStatus,
          ),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    // --- 4. Collapse duplicates that already exist -----------------------
    await mergeDuplicateDefaultCategories();

    // --- 5. Normalise the transaction type spelling ----------------------
    await customStatement(
      "UPDATE transactions SET transaction_type = ? "
      "WHERE LOWER(REPLACE(transaction_type, '_', '')) = 'recurringinstance' "
      "AND transaction_type <> ?",
      [
        TransactionType.recurringInstance.storageValue,
        TransactionType.recurringInstance.storageValue,
      ],
    );
  }

  /// Every table whose rows are synchronized, and which therefore must never
  /// have a pending create downgraded into a pending update.
  static const List<String> _syncedTableNames = [
    'transactions',
    'categories',
    'wallets',
    'budgets',
    'objectives',
    'payment_methods',
    'recurring_configs',
  ];

  /// Install a database-level guard: **a pending create can never become a
  /// pending update.**
  ///
  /// A row the server has never acknowledged is `pendingCreate`. Downgrading it
  /// to `pendingUpdate` makes every subsequent push ask the server to update a
  /// row that does not exist — which it answers with "not found", for ever. The
  /// record is then stranded on the device and can never reach the cloud.
  ///
  /// This is easy to cause by accident and invisible when it happens: any of a
  /// few dozen mutation helpers that hard-code `pendingUpdate` will do it, and
  /// one of them (`updateWalletBalance`) runs on *every transaction the user
  /// records*. A per-call-site convention would be forgotten by the next edit,
  /// so the rule is enforced by the database itself and applies to code that has
  /// not been written yet.
  ///
  /// Recursive triggers are off by default in SQLite, and the corrective write
  /// would not match the `WHEN` clause anyway, so this cannot loop.
  Future<void> _installSyncStatusGuards() async {
    for (final table in _syncedTableNames) {
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS trg_${table}_keep_pending_create
        AFTER UPDATE OF sync_status ON $table
        WHEN OLD.sync_status = ${SyncStatus.pendingCreate}
         AND NEW.sync_status = ${SyncStatus.pendingUpdate}
        BEGIN
          UPDATE $table SET sync_status = ${SyncStatus.pendingCreate}
          WHERE rowid = NEW.rowid;
        END;
      ''');
    }
  }

  /// Guarantees the single [localStoreMetas] row exists.
  Future<void> _ensureLocalStoreMetaRow() async {
    final existing = await select(localStoreMetas).getSingleOrNull();
    if (existing == null) {
      await into(localStoreMetas).insert(
        LocalStoreMetasCompanion.insert(updatedAt: Value(DateTime.now())),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  // ============================================================
  // Local store ownership
  // ============================================================

  /// Backend user id that owns this database file, or null if never claimed.
  Future<String?> getLocalStoreOwnerUserId() async {
    await _ensureLocalStoreMetaRow();
    final row = await select(localStoreMetas).getSingleOrNull();
    return row?.ownerUserId;
  }

  /// The full ownership record for this store.
  Future<LocalStoreMeta?> getLocalStoreMeta() async {
    await _ensureLocalStoreMetaRow();
    return select(localStoreMetas).getSingleOrNull();
  }

  /// Bind this database to [userId].
  ///
  /// Claiming is one-way: an already-owned store cannot be silently re-claimed
  /// by a different account, because that is precisely how one user's records
  /// would end up being pushed under another user's credentials. Callers that
  /// genuinely need to hand the store over must clear it first via
  /// [releaseLocalStore].
  Future<void> claimLocalStore({required String userId, String? email}) async {
    await _ensureLocalStoreMetaRow();
    final current = await select(localStoreMetas).getSingleOrNull();
    if (current?.ownerUserId != null && current!.ownerUserId != userId) {
      throw StateError(
        'Local store already belongs to ${current.ownerUserId}; '
        'refusing to re-claim it for $userId.',
      );
    }
    await update(localStoreMetas).write(
      LocalStoreMetasCompanion(
        ownerUserId: Value(userId),
        ownerEmail: Value(email),
        claimedAt: Value(current?.claimedAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Whether this store may be synchronized on behalf of [userId].
  ///
  /// An unclaimed store is allowed (it is about to be claimed); a store owned by
  /// somebody else is not.
  Future<bool> isLocalStoreUsableBy(String userId) async {
    final owner = await getLocalStoreOwnerUserId();
    return owner == null || owner == userId;
  }

  /// Wipe this store's financial data and detach it from its owner.
  ///
  /// This is the destructive "hand the device to another account" path and is
  /// only ever reached from an explicit, confirmed user action.
  Future<void> releaseLocalStore() async {
    await clearAllData();
    await _ensureLocalStoreMetaRow();
    await update(localStoreMetas).write(
      LocalStoreMetasCompanion(
        ownerUserId: const Value(null),
        ownerEmail: const Value(null),
        claimedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ============================================================
  // Settings DAO methods
  // ============================================================
  Future<Setting?> getSettings() => select(settings).getSingleOrNull();

  Future<int> insertSettings(SettingsCompanion entry) =>
      into(settings).insert(entry);

  Future<bool> updateSettings(SettingsCompanion entry) =>
      update(settings).replace(entry);

  // ============================================================
  // Transaction DAO methods
  // ============================================================
  Future<List<Transaction>> getAllTransactions() =>
      (select(transactions)..where((t) => t.deletedAt.isNull())).get();

  /// Get all transactions with category names via JOIN
  /// Returns a list of maps containing transaction data and resolved category info
  Future<List<Map<String, dynamic>>>
  getAllTransactionsWithCategoryName() async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
    ]);

    query.where(transactions.deletedAt.isNull());
    query.orderBy([OrderingTerm.desc(transactions.date)]);

    final results = await query.get();
    return results.map((row) {
      final txn = row.readTable(transactions);
      final cat = row.readTableOrNull(categories);
      return {
        'transaction': txn,
        'categoryName': cat?.name ?? 'Uncategorized',
        'categoryColor': cat?.color ?? '#808080',
        'categoryIconName': cat?.iconName ?? 'category',
      };
    }).toList();
  }

  /// Get transactions for export with resolved category and wallet names via JOIN
  Future<List<ExportTransaction>> getTransactionsForExport({
    DateTime? start,
    DateTime? end,
  }) async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      leftOuterJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
    ]);

    query.where(transactions.deletedAt.isNull());
    if (start != null && end != null) {
      query.where(transactions.date.isBetweenValues(start, end));
    }
    query.orderBy([OrderingTerm.desc(transactions.date)]);

    final results = await query.get();
    return results.map((row) {
      final txn = row.readTable(transactions);
      final cat = row.readTableOrNull(categories);
      final wallet = row.readTableOrNull(wallets);
      return ExportTransaction(
        transaction: txn,
        categoryName: cat?.name ?? 'Uncategorized',
        walletName: wallet?.name ?? 'Unknown',
      );
    }).toList();
  }

  Future<Transaction?> findTransactionById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> addTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<bool> updateTransaction(TransactionsCompanion entry) =>
      update(transactions).replace(entry);

  Future<int> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  /// Soft delete a transaction (sets deletedAt and marks for sync)
  Future<void> softDeleteTransaction(String id) async {
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// @deprecated - Use getIncomeTransactions or getExpenseTransactions instead
  Future<List<Transaction>> getTransactionsByType(String type) =>
      (select(transactions)
            ..where((t) => t.type.equals(type))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get all income transactions
  Future<List<Transaction>> getIncomeTransactions() =>
      (select(transactions)
            ..where((t) => t.isIncome.equals(true))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get all expense transactions
  Future<List<Transaction>> getExpenseTransactions() =>
      (select(transactions)
            ..where((t) => t.isIncome.equals(false))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) =>
      (select(transactions)
            ..where((t) => t.categoryId.equals(categoryId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get a single transaction by ID
  Future<Transaction?> getTransactionById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(transactions)
            ..where((t) => t.date.isBetweenValues(start, end))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  Future<List<Transaction>> getTransactionsByWallet(String walletId) =>
      (select(transactions)
            ..where((t) => t.walletId.equals(walletId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get transactions that need to be synced
  Future<List<Transaction>> getPendingSyncTransactions() => (select(
    transactions,
  )..where((t) => t.syncStatus.isBiggerThanValue(0))).get();

  /// Get recurring transaction instances
  Future<List<Transaction>> getRecurringInstances(String recurringConfigId) =>
      (select(transactions)
            ..where((t) => t.recurringConfigId.equals(recurringConfigId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get upcoming (unpaid future) transactions
  Future<List<Transaction>> getUpcomingTransactions() =>
      (select(transactions)
            ..where((t) => t.isPaid.equals(false))
            ..where((t) => t.skipPaid.equals(false))
            ..where((t) => t.date.isBiggerThanValue(DateTime.now()))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  /// Get overdue (unpaid past) transactions
  Future<List<Transaction>> getOverdueTransactions() =>
      (select(transactions)
            ..where((t) => t.isPaid.equals(false))
            ..where((t) => t.skipPaid.equals(false))
            ..where((t) => t.date.isSmallerThanValue(DateTime.now()))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  /// Get credit transactions (money lent - they owe you)
  Future<List<Transaction>> getCreditTransactions() =>
      (select(transactions)
            ..where(
              (t) => t.specialType.equals(4),
            ) // TransactionSpecialType.credit index
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get debt transactions (money borrowed - you owe them)
  Future<List<Transaction>> getDebtTransactions() =>
      (select(transactions)
            ..where(
              (t) => t.specialType.equals(5),
            ) // TransactionSpecialType.debt index
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get all credit and debt transactions
  Future<List<Transaction>> getCreditDebtTransactions() async {
    final query = select(transactions)
      ..where(
        (t) => t.specialType.equals(4) | t.specialType.equals(5),
      ) // credit or debt
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.get();
  }

  /// Get unpaid credit/debt transactions
  Future<List<Transaction>> getUnpaidCreditDebtTransactions() async {
    final query = select(transactions)
      ..where(
        (t) => t.specialType.equals(4) | t.specialType.equals(5),
      ) // credit or debt
      ..where((t) => t.isPaid.equals(false))
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.get();
  }

  /// Get subscription transactions
  Future<List<Transaction>> getSubscriptionTransactions() =>
      (select(transactions)
            ..where(
              (t) => t.specialType.equals(2),
            ) // TransactionSpecialType.subscription
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Mark transaction as paid
  Future<void> markTransactionAsPaid(String id, {DateTime? paymentDate}) async {
    final transaction = await findTransactionById(id);
    if (transaction == null) return;

    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isPaid: const Value(true),
        originalDueDate: Value(transaction.originalDueDate ?? transaction.date),
        date: Value(paymentDate ?? DateTime.now()),
        syncStatus: Value(SyncStatus.markEdited(transaction.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Skip a scheduled occurrence.
  ///
  /// Sync-aware: it marks the row pending-update so the skip reaches other
  /// devices. A raw SQL update (which is what this used to be) changed the row
  /// without touching `syncStatus`, so the change was never pushed and the
  /// user's other device kept reminding them about an item they had dismissed.
  Future<void> skipTransaction(String id, {bool skipped = true}) async {
    await customStatement(
      'UPDATE transactions SET skip_paid = ?, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} WHERE id = ?',
      [skipped ? 1 : 0, DateTime.now().millisecondsSinceEpoch ~/ 1000, id],
    );
  }

  /// Mark transaction as unpaid
  Future<void> markTransactionAsUnpaid(String id) async {
    final transaction = await findTransactionById(id);
    if (transaction == null) return;

    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isPaid: const Value(false),
        // Restore original due date if available
        date: Value(transaction.originalDueDate ?? transaction.date),
        syncStatus: Value(SyncStatus.markEdited(transaction.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ============================================================
  // Payment Method DAO methods
  // ============================================================
  Future<List<PaymentMethod>> getAllPaymentMethods() =>
      (select(paymentMethods)..where((p) => p.deletedAt.isNull())).get();

  Future<PaymentMethod?> findPaymentMethodById(String id) =>
      (select(paymentMethods)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> addPaymentMethod(PaymentMethodsCompanion entry) =>
      into(paymentMethods).insert(entry);

  Future<bool> updatePaymentMethod(PaymentMethodsCompanion entry) =>
      update(paymentMethods).replace(entry);

  Future<int> deletePaymentMethod(String id) =>
      (delete(paymentMethods)..where((p) => p.id.equals(id))).go();

  /// Soft delete a payment method (sets deletedAt and marks for sync)
  Future<void> softDeletePaymentMethod(String id) async {
    await (update(paymentMethods)..where((p) => p.id.equals(id))).write(
      PaymentMethodsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<PaymentMethod>> getDefaultPaymentMethods() =>
      (select(paymentMethods)
            ..where((p) => p.isDefault.equals(true))
            ..where((p) => p.deletedAt.isNull()))
          .get();

  // ============================================================
  // Budget DAO methods
  // ============================================================
  Future<List<Budget>> getAllBudgets() =>
      (select(budgets)..where((b) => b.deletedAt.isNull())).get();

  Future<Budget?> findBudgetById(String id) =>
      (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> addBudget(BudgetsCompanion entry) => into(budgets).insert(entry);

  Future<bool> updateBudget(BudgetsCompanion entry) =>
      update(budgets).replace(entry);

  Future<int> deleteBudget(String id) =>
      (delete(budgets)..where((b) => b.id.equals(id))).go();

  /// Soft delete a budget (sets deletedAt and marks for sync)
  Future<void> softDeleteBudget(String id) async {
    await (update(budgets)..where((b) => b.id.equals(id))).write(
      BudgetsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<Budget>> getActiveBudgets() =>
      (select(budgets)
            ..where((b) => b.startDate.isSmallerThanValue(DateTime.now()))
            ..where(
              (b) =>
                  b.endDate.isNull() |
                  b.endDate.isBiggerThanValue(DateTime.now()),
            )
            ..where((b) => b.isArchived.equals(false))
            ..where((b) => b.deletedAt.isNull()))
          .get();

  Future<List<Budget>> getPinnedBudgets() =>
      (select(budgets)
            ..where((b) => b.isPinned.equals(true))
            ..where((b) => b.deletedAt.isNull()))
          .get();

  // ============================================================
  // Category DAO methods
  // ============================================================
  Future<List<Category>> getAllCategories() =>
      (select(categories)..where((c) => c.deletedAt.isNull())).get();

  Future<Category?> findCategoryById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> addCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<bool> updateCategory(CategoriesCompanion entry) =>
      update(categories).replace(entry);

  Future<int> deleteCategory(String id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  /// Soft delete a category (sets deletedAt and marks for sync)
  ///
  /// Budgets scoped to this category stop filtering on it. They are not foreign
  /// keys, so nothing else would remove the reference, and a budget pointing at
  /// a deleted category silently counts nothing.
  Future<void> softDeleteCategory(String id) async {
    await transaction(() async {
      await (update(categories)..where((c) => c.id.equals(id))).write(
        CategoriesCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await pruneCategoryFromBudgets(id);
    });
  }

  /// @deprecated - Use getIncomeCategories or getExpenseCategories instead
  Future<List<Category>> getCategoriesByType(String type) =>
      (select(categories)
            ..where((c) => c.type.equals(type))
            ..where((c) => c.deletedAt.isNull()))
          .get();

  /// Get income categories
  Future<List<Category>> getIncomeCategories() =>
      (select(categories)
            ..where((c) => c.isIncome.equals(true))
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Get expense categories
  Future<List<Category>> getExpenseCategories() =>
      (select(categories)
            ..where((c) => c.isIncome.equals(false))
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Get main categories (no parent)
  Future<List<Category>> getMainCategories() =>
      (select(categories)
            ..where((c) => c.mainCategoryId.isNull())
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Get subcategories for a main category
  Future<List<Category>> getSubcategories(String mainCategoryId) =>
      (select(categories)
            ..where((c) => c.mainCategoryId.equals(mainCategoryId))
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Ensure the built-in categories named by [specs] exist, keyed by slug.
  ///
  /// Seeding is **per slug**, not all-or-nothing: only the built-ins that are
  /// missing are inserted. That makes it safe to call repeatedly, and it means a
  /// device that has already pulled some of the account's categories from the
  /// cloud adds only what is genuinely absent instead of a fresh duplicate set.
  ///
  /// Rows are created **pending-create**, not `synced`. They are ordinary
  /// per-user categories as far as the backend is concerned, and the server
  /// requires a transaction's category to exist and belong to the caller — so a
  /// category that is never pushed makes every transaction referencing it
  /// unsyncable.
  ///
  /// Returns the slugs that were actually inserted.
  Future<List<String>> ensureDefaultCategories(
    List<DefaultCategorySpec> specs,
  ) async {
    final now = DateTime.now();
    final existingKeys = await liveDefaultKeys();
    final inserted = <String>[];

    for (final spec in specs) {
      if (existingKeys.contains(spec.key)) continue;
      await into(categories).insert(
        CategoriesCompanion(
          id: Value(const Uuid().v4()),
          name: Value(spec.name),
          iconName: Value(spec.iconName),
          color: Value(spec.colorCode),
          isIncome: Value(spec.isIncome),
          isDefault: const Value(true),
          defaultKey: Value(spec.key),
          orderIndex: Value(spec.orderIndex),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingCreate),
        ),
        mode: InsertMode.insertOrIgnore,
      );
      inserted.add(spec.key);
    }
    return inserted;
  }

  /// Slugs of every live built-in category currently in this store.
  Future<Set<String>> liveDefaultKeys() async {
    final rows =
        await (select(categories)
              ..where((c) => c.defaultKey.isNotNull())
              ..where((c) => c.deletedAt.isNull()))
            .get();
    return rows.map((c) => c.defaultKey!).toSet();
  }

  /// Ensure the internal system categories (Transfer, Balance Correction) exist.
  Future<void> ensureSystemCategoriesExist() =>
      ensureDefaultCategories(DefaultCategoryCatalog.system);

  /// The live category carrying [defaultKey], or null.
  Future<Category?> findCategoryByDefaultKey(String defaultKey) =>
      (select(categories)
            ..where((c) => c.defaultKey.equals(defaultKey))
            ..where((c) => c.deletedAt.isNull()))
          .getSingleOrNull();

  /// Resolve the id of a system category by slug, creating it if absent.
  ///
  /// Callers hold a slug rather than an id because the id is random per install
  /// — see [SystemCategories] for why a fixed id was unsafe.
  Future<String> requireSystemCategoryId(String defaultKey) async {
    final existing = await findCategoryByDefaultKey(defaultKey);
    if (existing != null) return existing.id;

    final spec = DefaultCategoryCatalog.byKey[defaultKey];
    if (spec == null) {
      throw ArgumentError('Unknown system category slug: $defaultKey');
    }
    await ensureDefaultCategories([spec]);

    final created = await findCategoryByDefaultKey(defaultKey);
    if (created == null) {
      throw StateError('Failed to provision system category $defaultKey');
    }
    return created.id;
  }

  /// The live fee recorded against [transferTransactionId], if any.
  Future<Transaction?> findFeeForTransfer(String transferTransactionId) =>
      (select(transactions)
            ..where((t) => t.feeForTransactionId.equals(transferTransactionId))
            ..where((t) => t.deletedAt.isNull())
            ..limit(1))
          .getSingleOrNull();

  /// Collapse duplicate built-in categories down to one row per slug.
  ///
  /// Two rows sharing a `defaultKey` are *provably* the same built-in category,
  /// which is what makes an automatic merge safe here. User-created categories
  /// have a null slug and are never touched, even when their names match a
  /// built-in.
  ///
  /// The survivor is chosen deterministically so every device converges on the
  /// same row: an already-synced copy wins over a local-only one (the synced copy
  /// is the one the server holds), and ties break on the lexicographically
  /// smallest id. Losers have their transactions and subcategories re-pointed at
  /// the survivor, lose their slug (so they no longer claim the built-in), and
  /// are tombstoned for sync.
  ///
  /// Returns the number of duplicate rows merged away.
  Future<int> mergeDuplicateDefaultCategories() async {
    final rows =
        await (select(categories)
              ..where((c) => c.defaultKey.isNotNull())
              ..where((c) => c.deletedAt.isNull()))
            .get();

    final byKey = <String, List<Category>>{};
    for (final row in rows) {
      byKey.putIfAbsent(row.defaultKey!, () => []).add(row);
    }

    var merged = 0;
    for (final entry in byKey.entries) {
      if (entry.value.length < 2) continue;

      final candidates = [...entry.value]
        ..sort((a, b) {
          final aSynced = a.syncStatus == SyncStatus.synced ? 0 : 1;
          final bSynced = b.syncStatus == SyncStatus.synced ? 0 : 1;
          if (aSynced != bSynced) return aSynced - bSynced;
          return a.id.compareTo(b.id);
        });

      final survivor = candidates.first;
      for (final loser in candidates.skip(1)) {
        await _absorbCategory(loser: loser, survivorId: survivor.id);
        merged++;
      }
    }
    return merged;
  }

  /// Move every transaction filed under [fromCategoryId] to [toCategoryId],
  /// advancing each row's sync state **without ever downgrading a create into an
  /// update**.
  ///
  /// This distinction is load-bearing. A transaction the server has never seen
  /// is `pendingCreate`; rewriting it to `pendingUpdate` makes the next push ask
  /// the server to update a row that does not exist, which the server correctly
  /// answers with "not found" — for ever. The record would sit pending on the
  /// device and never reach the cloud. That is exactly the state a brand-new
  /// device is in when it records transactions against its own provisional
  /// default categories before its first pull, so it is the common case rather
  /// than an edge case.
  ///
  /// Rows already tombstoned (`pendingDelete`) keep that state too: a re-file is
  /// not a resurrection.
  Future<void> repointTransactionsToCategory({
    required String fromCategoryId,
    required String toCategoryId,
  }) async {
    final now = DateTime.now();

    await customStatement(
      'UPDATE transactions SET category_id = ?, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} WHERE category_id = ?',
      [toCategoryId, now.millisecondsSinceEpoch ~/ 1000, fromCategoryId],
    );
  }

  /// Re-parent subcategories, preserving create/delete sync state for the same
  /// reason as [repointTransactionsToCategory].
  Future<void> _repointSubcategories({
    required String fromId,
    required String toId,
  }) async {
    final now = DateTime.now();

    await customStatement(
      'UPDATE categories SET main_category_id = ?, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} WHERE main_category_id = ?',
      [toId, now.millisecondsSinceEpoch ~/ 1000, fromId],
    );
  }

  /// Fold a local duplicate of a built-in category into the canonical row.
  ///
  /// Called when a pulled category arrives carrying a `defaultKey` this device
  /// already has under a different id — i.e. this device seeded its own
  /// provisional defaults before it saw the account's cloud data. The server
  /// copy is canonical, so the local one is absorbed: its transactions,
  /// subcategories, and learned titles are re-pointed, and only then is it
  /// removed. Nothing financial is deleted.
  ///
  /// Doing this *before* the insert is what lets the canonical row land at all:
  /// the unique index on `default_key` would otherwise reject it while the
  /// provisional row still claims the slug, which failed the whole pull.
  Future<void> absorbDuplicateDefaultCategory({
    required String loserId,
    required String survivorId,
  }) async {
    final loser = await findCategoryById(loserId);
    if (loser == null || loserId == survivorId) return;
    await _absorbCategory(loser: loser, survivorId: survivorId);
  }

  // ==================== BUDGET SCOPE REFERENCES ====================
  //
  // A budget scopes itself to wallets and categories by id: `walletIds` and
  // `categoryIds`, both JSON arrays, plus the older single `categoryId`. None
  // of them is a foreign key, so nothing in the database keeps them honest — a
  // reference can outlive the row it names, and the only symptom is a budget
  // that quietly stops counting the transactions it is supposed to count. No
  // error, no conflict; just a progress bar that never moves and alerts that
  // never fire.
  //
  // The helpers below are what keep those references true when a category is
  // merged away, or when a wallet or category is deleted.

  /// Decodes one of a budget's JSON id lists, tolerating anything malformed.
  ///
  /// A budget with an unreadable list is not worth failing a merge or a sync
  /// over; it is treated as scoping nothing, which is how the rest of the app
  /// already reads an empty list. (The server's column is `jsonb`, so malformed
  /// JSON cannot reach the cloud in the first place — SQLite has no such type,
  /// hence the tolerance here.)
  static List<String> decodeIdList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<String>().toList();
    } on FormatException {
      return const [];
    }
  }

  /// Every category id a budget refers to, from both places it can store one.
  static Set<String> budgetCategoryReferences(Budget b) => {
    ...decodeIdList(b.categoryIds),
    if (b.categoryId != null && b.categoryId!.isNotEmpty) b.categoryId!,
  };

  /// Every wallet id a budget refers to.
  static Set<String> budgetWalletReferences(Budget b) =>
      decodeIdList(b.walletIds).toSet();

  /// Live budgets whose scope names any of [ids], in either dimension.
  Future<List<Budget>> _budgetsReferencing(
    Set<String> ids,
    Set<String> Function(Budget) referencesOf,
  ) async {
    if (ids.isEmpty) return const [];
    final all = await (select(
      budgets,
    )..where((b) => b.deletedAt.isNull())).get();
    return all.where((b) => referencesOf(b).any(ids.contains)).toList();
  }

  Future<List<Budget>> budgetsReferencingCategories(Set<String> categoryIds) =>
      _budgetsReferencing(categoryIds, budgetCategoryReferences);

  Future<List<Budget>> budgetsReferencingWallets(Set<String> walletIds) =>
      _budgetsReferencing(walletIds, budgetWalletReferences);

  /// Writes a budget's rewritten scope, preserving its sync state.
  ///
  /// Sync state goes through [SyncStatus.markEdited]: a budget the server has
  /// never seen stays a pending create, because downgrading it to an update
  /// would make it permanently unsyncable.
  Future<void> _writeBudgetScope(
    String budgetId,
    BudgetsCompanion scope,
  ) async {
    await (update(budgets)..where((t) => t.id.equals(budgetId))).write(
      scope.copyWith(updatedAt: Value(DateTime.now())),
    );
    await customStatement(
      'UPDATE budgets SET sync_status = ${SyncStatus.markEditedSql} WHERE id = ?',
      [budgetId],
    );
  }

  /// Rewrites [ids] with [from] replaced by [to], collapsing a duplicate.
  static List<String> _replaceId(List<String> ids, String from, String to) {
    final rewritten = <String>[];
    for (final id in ids) {
      final next = id == from ? to : id;
      if (!rewritten.contains(next)) rewritten.add(next);
    }
    return rewritten;
  }

  /// Rewrites every budget reference from [fromCategoryId] to [toCategoryId].
  ///
  /// Both storage locations are updated together, in one transaction, so a
  /// budget can never be left scoped half to the old category and half to the
  /// new one. If the budget already names the survivor, the two references
  /// collapse into one rather than the survivor appearing twice.
  Future<void> repointBudgetsToCategory({
    required String fromCategoryId,
    required String toCategoryId,
  }) async {
    if (fromCategoryId == toCategoryId) return;
    await transaction(() async {
      for (final b in await budgetsReferencingCategories({fromCategoryId})) {
        await _writeBudgetScope(
          b.id,
          BudgetsCompanion(
            categoryIds: Value(
              jsonEncode(
                _replaceId(
                  decodeIdList(b.categoryIds),
                  fromCategoryId,
                  toCategoryId,
                ),
              ),
            ),
            categoryId: b.categoryId == fromCategoryId
                ? Value(toCategoryId)
                : const Value.absent(),
          ),
        );
      }
    });
  }

  /// Drops [categoryId] from every budget that scopes itself to it.
  ///
  /// Called when a category is deleted. A budget keeps existing — the user
  /// deleted a category, not a budget — it simply stops filtering on something
  /// that is no longer there. Leaving the reference behind would mean the
  /// budget silently matches nothing, and would also make it unpushable, since
  /// the server checks that budget categories are live.
  Future<void> pruneCategoryFromBudgets(String categoryId) async {
    await transaction(() async {
      for (final b in await budgetsReferencingCategories({categoryId})) {
        await _writeBudgetScope(
          b.id,
          BudgetsCompanion(
            categoryIds: Value(
              jsonEncode(
                decodeIdList(
                  b.categoryIds,
                ).where((id) => id != categoryId).toList(),
              ),
            ),
            categoryId: b.categoryId == categoryId
                ? const Value(null)
                : const Value.absent(),
          ),
        );
      }
    });
  }

  /// Drops [walletId] from every budget that scopes itself to it.
  ///
  /// The same reasoning as [pruneCategoryFromBudgets]. A budget scoped only to
  /// a deleted wallet becomes scoped to no wallet, which the app reads as "all
  /// wallets" — a visible widening rather than a silent zero, and the honest
  /// outcome once the wallet it named is gone.
  Future<void> pruneWalletFromBudgets(String walletId) async {
    await transaction(() async {
      for (final b in await budgetsReferencingWallets({walletId})) {
        await _writeBudgetScope(
          b.id,
          BudgetsCompanion(
            walletIds: Value(
              jsonEncode(
                decodeIdList(
                  b.walletIds,
                ).where((id) => id != walletId).toList(),
              ),
            ),
          ),
        );
      }
    });
  }

  /// Drops budget references to wallets and categories that no longer exist or
  /// are tombstoned.
  ///
  /// Returns the number of budgets changed. Used by the schema-14 migration to
  /// clean up references left behind by builds that did not prune on delete.
  Future<int> pruneDeadBudgetReferences() async {
    return transaction(() async {
      final liveCategories = {
        for (final c in await (select(
          categories,
        )..where((c) => c.deletedAt.isNull())).get())
          c.id,
      };
      final liveWallets = {
        for (final w in await (select(
          wallets,
        )..where((w) => w.deletedAt.isNull())).get())
          w.id,
      };
      final all = await (select(
        budgets,
      )..where((b) => b.deletedAt.isNull())).get();

      var changed = 0;
      for (final b in all) {
        final categoryIds = decodeIdList(b.categoryIds);
        final walletIds = decodeIdList(b.walletIds);
        final keptCategories = categoryIds
            .where(liveCategories.contains)
            .toList();
        final keptWallets = walletIds.where(liveWallets.contains).toList();
        final legacyIsDead =
            b.categoryId != null &&
            b.categoryId!.isNotEmpty &&
            !liveCategories.contains(b.categoryId);

        if (keptCategories.length == categoryIds.length &&
            keptWallets.length == walletIds.length &&
            !legacyIsDead) {
          continue;
        }

        await _writeBudgetScope(
          b.id,
          BudgetsCompanion(
            categoryIds: Value(jsonEncode(keptCategories)),
            walletIds: Value(jsonEncode(keptWallets)),
            categoryId: legacyIsDead ? const Value(null) : const Value.absent(),
          ),
        );
        changed++;
      }
      return changed;
    });
  }

  // ==================== LEGACY CATEGORY RECONCILIATION ====================

  /// Every open or answered reconciliation question, oldest first.
  Future<List<CategoryReconciliation>> allCategoryReconciliations() => (select(
    categoryReconciliations,
  )..orderBy([(r) => OrderingTerm(expression: r.detectedAt)])).get();

  /// Questions the user has not answered yet.
  Future<List<CategoryReconciliation>> unresolvedCategoryReconciliations() =>
      (select(categoryReconciliations)
            ..where((r) => r.resolutionKind.isNull())
            ..orderBy([(r) => OrderingTerm(expression: r.detectedAt)]))
          .get();

  Stream<List<CategoryReconciliation>> watchCategoryReconciliations() =>
      (select(
        categoryReconciliations,
      )..orderBy([(r) => OrderingTerm(expression: r.detectedAt)])).watch();

  Future<CategoryReconciliation?> findCategoryReconciliation(
    String defaultKey,
  ) =>
      (select(categoryReconciliations)
            ..where((r) => r.defaultKey.equals(defaultKey))
            ..limit(1))
          .getSingleOrNull();

  /// Categories that must not be pushed because the server is still waiting on
  /// the user to say what they are.
  ///
  /// Pushing one again would simply be rejected again — every sync, forever —
  /// so the record is held back instead. It keeps its `pendingCreate` status
  /// throughout; nothing here downgrades or discards it.
  Future<Set<String>> blockedProvisionalCategoryIds() async {
    final rows = await unresolvedCategoryReconciliations();
    return rows.map((r) => r.provisionalCategoryId).toSet();
  }

  /// Provisional categories whose fate is not settled yet — including ones the
  /// user has answered but whose answer has not reached the server.
  ///
  /// Nothing may be pushed *referencing* one of these. If the answer turns out
  /// to be "adopt the existing category", the provisional id is one the server
  /// will never hold, and a record uploaded against it would point at nothing.
  Future<Set<String>> unsettledProvisionalCategoryIds() async {
    final rows = await allCategoryReconciliations();
    return rows.map((r) => r.provisionalCategoryId).toSet();
  }

  /// Records a question the server asked, without ever overwriting an answer.
  ///
  /// A re-detection is expected: until the answer has been pushed and applied
  /// the client keeps holding the provisional category back, and any sync that
  /// does get through can raise the same question again. Refreshing the
  /// candidate list is useful; clearing the user's decision is not.
  Future<void> recordCategoryReconciliation({
    required String defaultKey,
    required String provisionalCategoryId,
    required String catalogName,
    required bool catalogIsIncome,
    required String candidatesJson,
  }) async {
    final existing = await findCategoryReconciliation(defaultKey);
    final now = DateTime.now();
    if (existing != null) {
      await (update(
        categoryReconciliations,
      )..where((r) => r.defaultKey.equals(defaultKey))).write(
        CategoryReconciliationsCompanion(
          provisionalCategoryId: Value(provisionalCategoryId),
          catalogName: Value(catalogName),
          catalogIsIncome: Value(catalogIsIncome),
          candidatesJson: Value(candidatesJson),
        ),
      );
      return;
    }
    await into(categoryReconciliations).insert(
      CategoryReconciliationsCompanion.insert(
        defaultKey: defaultKey,
        provisionalCategoryId: provisionalCategoryId,
        catalogName: catalogName,
        catalogIsIncome: catalogIsIncome,
        candidatesJson: candidatesJson,
        detectedAt: now,
      ),
    );
  }

  /// Stores the user's decision. The next push carries it to the server.
  Future<void> resolveCategoryReconciliation({
    required String defaultKey,
    required String kind,
    String? candidateId,
  }) =>
      (update(
        categoryReconciliations,
      )..where((r) => r.defaultKey.equals(defaultKey))).write(
        CategoryReconciliationsCompanion(
          resolutionKind: Value(kind),
          resolutionCandidateId: Value(candidateId),
          resolvedAt: Value(DateTime.now()),
        ),
      );

  /// Puts a question back to the user after their answer stopped being
  /// applicable — the category they picked was deleted or claimed elsewhere.
  ///
  /// The row stays, so the provisional category stays held back; only the
  /// decision is cleared.
  Future<void> reopenCategoryReconciliation(String defaultKey) =>
      (update(
        categoryReconciliations,
      )..where((r) => r.defaultKey.equals(defaultKey))).write(
        const CategoryReconciliationsCompanion(
          resolutionKind: Value(null),
          resolutionCandidateId: Value(null),
          resolvedAt: Value(null),
        ),
      );

  /// Drops the question once the server has acted on the answer.
  Future<void> clearCategoryReconciliation(String defaultKey) => (delete(
    categoryReconciliations,
  )..where((r) => r.defaultKey.equals(defaultKey))).go();

  /// Hands a built-in slug back, so another row can take it.
  ///
  /// `idx_categories_default_key` is unique, so the provisional copy has to let
  /// go before the adopted category can claim the slug. Only the slug is
  /// touched — the row itself is about to be folded into the survivor, which is
  /// what carries its transactions across.
  Future<void> releaseDefaultKey(String categoryId) =>
      (update(categories)..where((c) => c.id.equals(categoryId))).write(
        const CategoriesCompanion(defaultKey: Value(null)),
      );

  /// Makes sure the category the server says now owns [defaultKey] exists
  /// locally, so the provisional copy has somewhere to be folded into.
  ///
  /// The adopted row is server state the moment the adoption is applied, so it
  /// is inserted as already-synced. If this device happens to hold it already —
  /// it may have pulled it as an ordinary category before the slug existed —
  /// only the identity fields are set, because the user's own name, colour, and
  /// icon are not this operation's business.
  Future<void> materializeAdoptedCategory({
    required String id,
    required String defaultKey,
    required String name,
    required bool isIncome,
    required String iconName,
    required String colorCode,
    required int orderIndex,
  }) async {
    final existing = await findCategoryById(id);
    final now = DateTime.now();
    if (existing != null) {
      await (update(categories)..where((c) => c.id.equals(id))).write(
        CategoriesCompanion(
          defaultKey: Value(defaultKey),
          isDefault: const Value(true),
          deletedAt: const Value(null),
        ),
      );
      return;
    }
    await into(categories).insert(
      CategoriesCompanion.insert(
        id: id,
        name: name,
        color: Value(colorCode),
        iconName: Value(iconName),
        isIncome: Value(isIncome),
        isDefault: const Value(true),
        defaultKey: Value(defaultKey),
        orderIndex: Value(orderIndex),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.synced),
      ),
    );
  }

  /// Re-point everything that referenced [loser] at [survivorId], then tombstone
  /// the loser. No financial record is deleted — only re-filed.
  Future<void> _absorbCategory({
    required Category loser,
    required String survivorId,
  }) async {
    // One transaction for the whole fold. Every reference to the loser has to
    // move together with the row disappearing — a budget left scoped to a
    // category that no longer exists does not fail loudly, it just silently
    // stops counting, and the user finds out from a progress bar that is wrong.
    await transaction(() async {
      await _absorbCategoryInner(loser: loser, survivorId: survivorId);
    });
  }

  Future<void> _absorbCategoryInner({
    required Category loser,
    required String survivorId,
  }) async {
    final now = DateTime.now();

    await repointTransactionsToCategory(
      fromCategoryId: loser.id,
      toCategoryId: survivorId,
    );

    await _repointSubcategories(fromId: loser.id, toId: survivorId);

    await repointBudgetsToCategory(
      fromCategoryId: loser.id,
      toCategoryId: survivorId,
    );

    await (update(associatedTitles)
          ..where((a) => a.categoryId.equals(loser.id)))
        .write(AssociatedTitlesCompanion(categoryId: Value(survivorId)));

    if (loser.syncStatus == SyncStatus.pendingCreate) {
      // The server has never seen this row, so there is nothing to tombstone —
      // and leaving a pending-create duplicate would upload it after the merge.
      await (delete(categories)..where((c) => c.id.equals(loser.id))).go();
      return;
    }

    await (update(categories)..where((c) => c.id.equals(loser.id))).write(
      CategoriesCompanion(
        // Give up the slug: this row no longer represents the built-in, and the
        // unique index would otherwise keep it reserved.
        defaultKey: const Value(null),
        deletedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(now),
      ),
    );
  }

  // ============================================================
  // Wallet DAO methods
  // ============================================================
  Future<List<Wallet>> getAllWallets() =>
      (select(wallets)
            ..where((w) => w.deletedAt.isNull())
            ..orderBy([
              (w) => OrderingTerm.asc(w.orderIndex),
              (w) => OrderingTerm.asc(w.createdAt),
            ]))
          .get();

  Future<Wallet?> findWalletById(String id) =>
      (select(wallets)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<int> addWallet(WalletsCompanion entry) => into(wallets).insert(entry);

  /// Persist a manual wallet ordering: each wallet's orderIndex becomes its
  /// position in [orderedIds]. Marks the rows pending so the order syncs.
  Future<void> updateWalletOrder(List<String> orderedIds) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    for (var i = 0; i < orderedIds.length; i++) {
      // SyncStatus.markEditedSql rather than a hard-coded pendingUpdate: a
      // wallet the server has never seen must stay a create.
      await customStatement(
        'UPDATE wallets SET order_index = ?, updated_at = ?, '
        'sync_status = ${SyncStatus.markEditedSql} WHERE id = ?',
        [i, now, orderedIds[i]],
      );
    }
  }

  Future<bool> updateWallet(WalletsCompanion entry) =>
      update(wallets).replace(entry);

  Future<int> deleteWallet(String id) =>
      (delete(wallets)..where((w) => w.id.equals(id))).go();

  /// Soft-delete a wallet (sets deletedAt + marks for sync) so the deletion propagates
  /// to the server instead of being a local-only hard delete.
  ///
  /// Budgets scoped to this wallet stop filtering on it. `walletIds` is not a
  /// foreign key, so nothing else would remove the reference, and a budget
  /// scoped only to a deleted wallet would otherwise match nothing at all.
  Future<void> softDeleteWallet(String id) async {
    await transaction(() async {
      await (update(wallets)..where((w) => w.id.equals(id))).write(
        WalletsCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await pruneWalletFromBudgets(id);
    });
  }

  /// Soft-delete every not-already-deleted transaction belonging to a wallet, marking them
  /// for sync. Called when a wallet is deleted so its transactions don't become orphans
  /// that keep skewing dashboard/report totals.
  Future<void> softDeleteTransactionsForWallet(String walletId) async {
    await (update(
      transactions,
    )..where((t) => t.walletId.equals(walletId) & t.deletedAt.isNull())).write(
      TransactionsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// FIXED: Was incorrectly filtering by balance.equals(0.0)
  Future<List<Wallet>> getDefaultWallets() =>
      (select(wallets)
            ..where((w) => w.isDefault.equals(true))
            ..where((w) => w.deletedAt.isNull()))
          .get();

  /// Update wallet balance (integer minor units / cents)
  Future<void> updateWalletBalance(String walletId, int newBalance) async {
    // Runs on EVERY transaction create, so hard-coding pendingUpdate here would
    // strand a brand-new device's wallet the moment its first transaction was
    // recorded — the wallet could then never be uploaded, and neither could any
    // transaction referencing it.
    await customStatement(
      'UPDATE wallets SET balance = ?, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} WHERE id = ?',
      [newBalance, DateTime.now().millisecondsSinceEpoch ~/ 1000, walletId],
    );
  }

  /// Persist a locally-derived wallet balance WITHOUT marking it for sync.
  ///
  /// Balance is client-authoritative: each device recomputes it from its opening
  /// balance + transactions. After a pull we recompute locally and store the
  /// result with this method so the derived value is never re-pushed — that would
  /// cause a cross-device last-write-wins balance ping-pong. `syncStatus` and
  /// `updatedAt` are intentionally left untouched.
  Future<void> setWalletBalanceLocal(String walletId, int newBalance) async {
    await (update(wallets)..where((w) => w.id.equals(walletId))).write(
      WalletsCompanion(balance: Value(newBalance)),
    );
  }

  // ============================================================
  // User Profile DAO methods
  // ============================================================
  Future<List<UserProfile>> getAllUserProfiles() => select(userProfiles).get();

  Future<UserProfile?> findUserProfileById(String userId) => (select(
    userProfiles,
  )..where((u) => u.userId.equals(userId))).getSingleOrNull();

  Future<int> addUserProfile(UserProfilesCompanion entry) =>
      into(userProfiles).insert(entry);

  Future<bool> updateUserProfile(UserProfilesCompanion entry) =>
      update(userProfiles).replace(entry);

  Future<int> deleteUserProfile(String userId) =>
      (delete(userProfiles)..where((u) => u.userId.equals(userId))).go();

  // ============================================================
  // Recurring Config DAO methods
  // ============================================================
  /// Every recurring config the user still has, excluding cancellation
  /// tombstones.
  ///
  /// Cancelling is a soft delete (`isActive = false` + `pendingDelete`) so the
  /// cancellation can be pushed to the server. Those rows must not show up in
  /// the subscriptions list — from the user's point of view they are gone.
  Future<List<RecurringConfig>> getAllRecurringConfigs() => (select(
    recurringConfigs,
  )..where((r) => r.syncStatus.equals(SyncStatus.pendingDelete).not())).get();

  /// Includes cancellation tombstones. Only the sync layer needs these.
  Future<List<RecurringConfig>> getAllRecurringConfigsIncludingTombstones() =>
      select(recurringConfigs).get();

  Future<RecurringConfig?> findRecurringConfigById(String id) => (select(
    recurringConfigs,
  )..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<int> addRecurringConfig(RecurringConfigsCompanion entry) =>
      into(recurringConfigs).insert(entry);

  Future<bool> updateRecurringConfig(RecurringConfigsCompanion entry) =>
      update(recurringConfigs).replace(entry);

  Future<int> deleteRecurringConfig(String id) =>
      (delete(recurringConfigs)..where((r) => r.id.equals(id))).go();

  /// Get active recurring configs
  Future<List<RecurringConfig>> getActiveRecurringConfigs() =>
      (select(recurringConfigs)..where((r) => r.isActive.equals(true))).get();

  /// Get recurring configs due for processing
  Future<List<RecurringConfig>> getDueRecurringConfigs() =>
      (select(recurringConfigs)
            ..where((r) => r.isActive.equals(true))
            ..where(
              (r) => r.nextOccurrence.isSmallerOrEqualValue(DateTime.now()),
            ))
          .get();

  /// Update next occurrence after processing
  Future<void> updateNextOccurrence(
    String id,
    DateTime nextOccurrence,
    bool isActive,
  ) async {
    await customStatement(
      'UPDATE recurring_configs SET next_occurrence = ?, is_active = ?, '
      'updated_at = ?, sync_status = ${SyncStatus.markEditedSql} WHERE id = ?',
      [
        nextOccurrence.millisecondsSinceEpoch ~/ 1000,
        isActive ? 1 : 0,
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        id,
      ],
    );
  }

  // ============================================================
  // Objective DAO methods
  // ============================================================
  Future<List<Objective>> getAllObjectives() =>
      (select(objectives)..where((o) => o.deletedAt.isNull())).get();

  Future<Objective?> findObjectiveById(String id) =>
      (select(objectives)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<int> addObjective(ObjectivesCompanion entry) =>
      into(objectives).insert(entry);

  Future<bool> updateObjective(ObjectivesCompanion entry) =>
      update(objectives).replace(entry);

  Future<int> deleteObjective(String id) =>
      (delete(objectives)..where((o) => o.id.equals(id))).go();

  /// Get active (non-archived) objectives
  Future<List<Objective>> getActiveObjectives() =>
      (select(objectives)
            ..where((o) => o.isArchived.equals(false))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  /// Get pinned objectives
  Future<List<Objective>> getPinnedObjectives() =>
      (select(objectives)
            ..where((o) => o.isPinned.equals(true))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  /// Get goals (saving type objectives)
  Future<List<Objective>> getGoals() =>
      (select(objectives)
            ..where((o) => o.type.equals('goal'))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  /// Get loans (debt type objectives)
  Future<List<Objective>> getLoans() =>
      (select(objectives)
            ..where((o) => o.type.equals('loan'))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  // ============================================================
  // Objective Transaction DAO methods
  // ============================================================
  Future<List<ObjectiveTransaction>> getObjectiveTransactions(
    String objectiveId,
  ) => (select(
    objectiveTransactions,
  )..where((ot) => ot.objectiveId.equals(objectiveId))).get();

  Future<int> addObjectiveTransaction(ObjectiveTransactionsCompanion entry) =>
      into(objectiveTransactions).insert(entry);

  Future<int> removeObjectiveTransaction(
    String objectiveId,
    String transactionId,
  ) =>
      (delete(objectiveTransactions)..where(
            (ot) =>
                ot.objectiveId.equals(objectiveId) &
                ot.transactionId.equals(transactionId),
          ))
          .go();

  /// Transactions assigned to an objective.
  ///
  /// The assignment lives in `transactions.objective_id`, which is part of the
  /// sync contract and therefore travels between devices. The
  /// `objective_transactions` junction table is legacy: it was never
  /// synchronized, so progress recorded through it existed on one device only
  /// and disappeared on a reinstall. Schema 12 backfilled its rows onto this
  /// column, and nothing writes to it any more.
  Future<List<Transaction>> getTransactionsForObjective(String objectiveId) =>
      (select(transactions)
            ..where((t) => t.objectiveId.equals(objectiveId))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get total amount contributed to an objective (integer minor units / cents).
  Future<int> getObjectiveProgress(String objectiveId) async {
    final linked = await getTransactionsForObjective(objectiveId);
    return linked.fold<int>(0, (sum, t) => sum + t.amount);
  }

  /// Assign [transactionId] to [objectiveId], marking the row for sync so the
  /// link reaches other devices.
  Future<void> linkTransactionToObjective(
    String objectiveId,
    String transactionId,
  ) async {
    await customStatement(
      'UPDATE transactions SET objective_id = ?, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} WHERE id = ?',
      [
        objectiveId,
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        transactionId,
      ],
    );
  }

  /// Remove [transactionId]'s objective assignment (sync-aware).
  Future<void> unlinkTransactionFromObjective(
    String objectiveId,
    String transactionId,
  ) async {
    await customStatement(
      'UPDATE transactions SET objective_id = NULL, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} '
      'WHERE id = ? AND objective_id = ?',
      [
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        transactionId,
        objectiveId,
      ],
    );
  }

  /// Detach every transaction from [objectiveId] (used when it is deleted).
  Future<void> unlinkAllTransactionsFromObjective(String objectiveId) async {
    await customStatement(
      'UPDATE transactions SET objective_id = NULL, updated_at = ?, '
      'sync_status = ${SyncStatus.markEditedSql} WHERE objective_id = ?',
      [DateTime.now().millisecondsSinceEpoch ~/ 1000, objectiveId],
    );
  }

  // ============================================================
  // Associated Title DAO methods (Smart Categorization)
  // ============================================================
  Future<List<AssociatedTitle>> getAllAssociatedTitles() =>
      select(associatedTitles).get();

  Future<AssociatedTitle?> findAssociatedTitleById(String id) => (select(
    associatedTitles,
  )..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> addAssociatedTitle(AssociatedTitlesCompanion entry) =>
      into(associatedTitles).insert(entry);

  Future<bool> updateAssociatedTitle(AssociatedTitlesCompanion entry) =>
      update(associatedTitles).replace(entry);

  Future<int> deleteAssociatedTitle(String id) =>
      (delete(associatedTitles)..where((a) => a.id.equals(id))).go();

  /// Find category suggestion by exact title match
  Future<AssociatedTitle?> findExactTitleMatch(String title) =>
      (select(associatedTitles)
            ..where((a) => a.title.equals(title.toLowerCase()))
            ..where((a) => a.isExactMatch.equals(true)))
          .getSingleOrNull();

  /// Find category suggestion by contains match
  Future<List<AssociatedTitle>> findContainsTitleMatches() => (select(
    associatedTitles,
  )..where((a) => a.isExactMatch.equals(false))).get();

  /// Get associated titles for a category
  Future<List<AssociatedTitle>> getAssociatedTitlesForCategory(
    String categoryId,
  ) => (select(
    associatedTitles,
  )..where((a) => a.categoryId.equals(categoryId))).get();

  // ============================================================
  // Sync State DAO methods
  // ============================================================
  Future<List<SyncState>> getAllSyncStates() => select(syncStates).get();

  Future<SyncState?> getSyncStateForTable(String tableName) => (select(
    syncStates,
  )..where((s) => s.syncTableName.equals(tableName))).getSingleOrNull();

  Future<int> addSyncState(SyncStatesCompanion entry) =>
      into(syncStates).insert(entry);

  Future<void> updateSyncState(String tableName, int serverVersion) async {
    final existing = await getSyncStateForTable(tableName);
    if (existing != null) {
      await (update(
        syncStates,
      )..where((s) => s.syncTableName.equals(tableName))).write(
        SyncStatesCompanion(
          lastServerVersion: Value(serverVersion),
          lastSyncAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await addSyncState(
        SyncStatesCompanion(
          syncTableName: Value(tableName),
          lastServerVersion: Value(serverVersion),
          lastSyncAt: Value(DateTime.now()),
        ),
      );
    }
  }

  /// Mark all records in a table as synced
  Future<void> markTableAsSynced(String tableName) async {
    // Update sync status based on table name
    switch (tableName) {
      case 'categories':
        await (update(categories)
              ..where((c) => c.syncStatus.isBiggerThanValue(0)))
            .write(const CategoriesCompanion(syncStatus: Value(0)));
        break;
      case 'wallets':
        await (update(wallets)..where((w) => w.syncStatus.isBiggerThanValue(0)))
            .write(const WalletsCompanion(syncStatus: Value(0)));
        break;
      case 'transactions':
        await (update(transactions)
              ..where((t) => t.syncStatus.isBiggerThanValue(0)))
            .write(const TransactionsCompanion(syncStatus: Value(0)));
        break;
      case 'budgets':
        await (update(budgets)..where((b) => b.syncStatus.isBiggerThanValue(0)))
            .write(const BudgetsCompanion(syncStatus: Value(0)));
        break;
      case 'payment_methods':
        await (update(paymentMethods)
              ..where((p) => p.syncStatus.isBiggerThanValue(0)))
            .write(const PaymentMethodsCompanion(syncStatus: Value(0)));
        break;
      case 'recurring_configs':
        await (update(recurringConfigs)
              ..where((r) => r.syncStatus.isBiggerThanValue(0)))
            .write(const RecurringConfigsCompanion(syncStatus: Value(0)));
        break;
      case 'objectives':
        await (update(objectives)
              ..where((o) => o.syncStatus.isBiggerThanValue(0)))
            .write(const ObjectivesCompanion(syncStatus: Value(0)));
        break;
      case 'associated_titles':
        await (update(associatedTitles)
              ..where((a) => a.syncStatus.isBiggerThanValue(0)))
            .write(const AssociatedTitlesCompanion(syncStatus: Value(0)));
        break;
      case 'exchange_rates':
        await (update(exchangeRates)
              ..where((e) => e.syncStatus.isBiggerThanValue(0)))
            .write(const ExchangeRatesCompanion(syncStatus: Value(0)));
        break;
    }
  }

  // ============================================================
  // Exchange Rate DAO methods
  // ============================================================
  Future<List<ExchangeRate>> getAllExchangeRates() =>
      select(exchangeRates).get();

  Future<ExchangeRate?> findExchangeRateById(String id) =>
      (select(exchangeRates)..where((e) => e.id.equals(id))).getSingleOrNull();

  /// Get exchange rate for a specific currency pair
  Future<ExchangeRate?> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) =>
      (select(exchangeRates)
            ..where((e) => e.fromCurrency.equals(fromCurrency.toUpperCase()))
            ..where((e) => e.toCurrency.equals(toCurrency.toUpperCase())))
          .getSingleOrNull();

  Future<int> addExchangeRate(ExchangeRatesCompanion entry) =>
      into(exchangeRates).insert(entry);

  Future<bool> updateExchangeRate(ExchangeRatesCompanion entry) =>
      update(exchangeRates).replace(entry);

  Future<int> deleteExchangeRate(String id) =>
      (delete(exchangeRates)..where((e) => e.id.equals(id))).go();

  /// Upsert exchange rate (insert or update if exists)
  Future<void> upsertExchangeRate({
    required String fromCurrency,
    required String toCurrency,
    double? apiRate,
    double? customRate,
    bool? useCustomRate,
    DateTime? apiRateFetchedAt,
  }) async {
    final existing = await getExchangeRate(fromCurrency, toCurrency);
    final now = DateTime.now();

    if (existing != null) {
      // Update existing
      await (update(
        exchangeRates,
      )..where((e) => e.id.equals(existing.id))).write(
        ExchangeRatesCompanion(
          apiRate: apiRate != null ? Value(apiRate) : const Value.absent(),
          customRate: customRate != null
              ? Value(customRate)
              : const Value.absent(),
          useCustomRate: useCustomRate != null
              ? Value(useCustomRate)
              : const Value.absent(),
          apiRateFetchedAt: apiRateFetchedAt != null
              ? Value(apiRateFetchedAt)
              : const Value.absent(),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingUpdate),
        ),
      );
    } else {
      // Insert new
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await into(exchangeRates).insert(
        ExchangeRatesCompanion(
          id: Value(id),
          fromCurrency: Value(fromCurrency.toUpperCase()),
          toCurrency: Value(toCurrency.toUpperCase()),
          apiRate: Value(apiRate),
          customRate: Value(customRate),
          useCustomRate: Value(useCustomRate ?? false),
          apiRateFetchedAt: Value(apiRateFetchedAt),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingCreate),
        ),
      );
    }
  }

  /// Get all exchange rates with custom overrides
  Future<List<ExchangeRate>> getCustomExchangeRates() =>
      (select(exchangeRates)..where((e) => e.useCustomRate.equals(true))).get();

  /// Get exchange rates that need to be synced
  Future<List<ExchangeRate>> getPendingSyncExchangeRates() => (select(
    exchangeRates,
  )..where((e) => e.syncStatus.isBiggerThanValue(0))).get();

  /// Clear custom rate and use API rate
  Future<void> clearCustomRate(String fromCurrency, String toCurrency) async {
    final existing = await getExchangeRate(fromCurrency, toCurrency);
    if (existing != null) {
      await (update(
        exchangeRates,
      )..where((e) => e.id.equals(existing.id))).write(
        ExchangeRatesCompanion(
          customRate: const Value(null),
          useCustomRate: const Value(false),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingUpdate),
        ),
      );
    }
  }

  /// Set a custom rate override
  Future<void> setCustomRate(
    String fromCurrency,
    String toCurrency,
    double rate,
  ) async {
    await upsertExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      customRate: rate,
      useCustomRate: true,
    );
  }

  // ============================================================
  // Global Sync Timestamp Methods
  // ============================================================

  /// Get the persisted last-sync timestamp (stored as a '_global' row in SyncStates)
  Future<DateTime?> getLastSyncTimestamp() async {
    final row = await (select(
      syncStates,
    )..where((s) => s.syncTableName.equals('_global'))).getSingleOrNull();
    return row?.lastSyncAt;
  }

  /// Upsert the global last-sync timestamp
  Future<void> setLastSyncTimestamp(DateTime timestamp) async {
    final existing = await (select(
      syncStates,
    )..where((s) => s.syncTableName.equals('_global'))).getSingleOrNull();

    if (existing != null) {
      await (update(
        syncStates,
      )..where((s) => s.syncTableName.equals('_global'))).write(
        SyncStatesCompanion(
          lastSyncAt: Value(timestamp),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await into(syncStates).insert(
        SyncStatesCompanion(
          syncTableName: const Value('_global'),
          lastSyncAt: Value(timestamp),
        ),
      );
    }
  }

  // ============================================================
  // Data Management Methods
  // ============================================================

  /// Clear all user data (transactions, categories, wallets, budgets, etc.)
  /// and reset settings to defaults. Used for "Clear All Data" in settings.
  ///
  /// [reseedSystemCategories] must be false when the caller is about to apply a
  /// cloud snapshot: re-creating the system categories here would give them
  /// fresh local ids that then collide, on the unique `default_key` index, with
  /// the account's own copies arriving from the server — aborting the restore.
  /// Restore calls [ensureSystemCategoriesExist] afterwards instead, which fills
  /// only genuine gaps.
  Future<void> clearAllData({bool reseedSystemCategories = true}) async {
    // Delete all transactions first (foreign key references)
    await delete(transactions).go();

    // Delete objective transactions (junction table)
    await delete(objectiveTransactions).go();

    // Delete objectives
    await delete(objectives).go();

    // Delete budgets
    await delete(budgets).go();

    // Delete recurring configs
    await delete(recurringConfigs).go();

    // Delete associated titles (smart categorization)
    await delete(associatedTitles).go();

    // Delete all categories (including system categories)
    await delete(categories).go();

    // Delete all wallets
    await delete(wallets).go();

    // Delete all payment methods
    await delete(paymentMethods).go();

    // Delete exchange rates
    await delete(exchangeRates).go();

    // Clear sync states
    await delete(syncStates).go();

    // Reset settings to defaults
    await delete(settings).go();
    await insertSettings(SettingsCompanion.insert());

    // Recreate system categories
    if (reseedSystemCategories) {
      await ensureSystemCategoriesExist();
    }
  }

  /// Clear app cache (sync states only, preserves user data)
  /// Used for "Clear Cache" in settings.
  Future<void> clearCache() async {
    // Clear sync states (forces re-sync)
    await delete(syncStates).go();

    // Reset all sync statuses to pending
    await customStatement('''
      UPDATE transactions SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE categories SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE wallets SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE budgets SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE objectives SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE payment_methods SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE recurring_configs SET sync_status = 1 WHERE sync_status = 0
    ''');
    // NOTE: exchange_rates and associated_titles are intentionally NOT reset
    // here. They carry a syncStatus column for historical reasons but are
    // DEVICE-LOCAL: SyncService has no cloud operation for either, so flagging
    // them pending only produced rows that could never drain. See
    // [deviceLocalTables].
  }

  /// Tables that carry a `syncStatus` column but are deliberately device-local.
  ///
  /// Neither the client nor the backend has a sync operation for these, so their
  /// contents stay on the device that created them:
  ///
  /// * `exchange_rates` — custom FX overrides, meaningful only alongside the
  ///   locally cached API rates they override.
  /// * `associated_titles` — the smart-categorization learning cache, rebuilt
  ///   from the user's own transactions on any device.
  ///
  /// Listed explicitly so the vestigial column is not mistaken for a promise
  /// that this data follows the user across premium devices.
  static const List<String> deviceLocalTables = [
    'exchange_rates',
    'associated_titles',
  ];

  /// Get database statistics for display in settings
  Future<Map<String, int>> getDatabaseStats() async {
    final transactionCount = await (select(
      transactions,
    )..where((t) => t.deletedAt.isNull())).get().then((list) => list.length);

    final categoryCount = await (select(
      categories,
    )..where((c) => c.deletedAt.isNull())).get().then((list) => list.length);

    final walletCount = await (select(
      wallets,
    )..where((w) => w.deletedAt.isNull())).get().then((list) => list.length);

    final budgetCount = await (select(
      budgets,
    )..where((b) => b.deletedAt.isNull())).get().then((list) => list.length);

    final objectiveCount = await (select(
      objectives,
    )..where((o) => o.deletedAt.isNull())).get().then((list) => list.length);

    return {
      'transactions': transactionCount,
      'categories': categoryCount,
      'wallets': walletCount,
      'budgets': budgetCount,
      'objectives': objectiveCount,
    };
  }
}
