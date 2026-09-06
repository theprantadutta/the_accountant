import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';

/// Reads the whole local database out to a file, and puts one back.
///
/// This exists because cloud sync is a paid feature, which left a free user
/// with no way at all to get their records off the device — not to move to a
/// new phone, not to survive a reinstall. A finance app that can lose years of
/// records with no recourse is not one worth trusting, so backup and restore
/// are free.
///
/// The dump is taken at the column level with plain SQL rather than through the
/// generated mappers, so a file written today can still be read by a build
/// several schema versions from now: an unknown column is dropped, and a new
/// one takes its default.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  /// Tables that describe *this device* rather than the user's records.
  ///
  /// The sync cursor and the store's owner binding must not travel in a backup.
  /// Carrying the cursor across would tell a fresh device it had already pulled
  /// everything up to a moment it was never present for, and carrying the owner
  /// binding would let one account's file quietly claim another account's
  /// store.
  static const Set<String> deviceLocalTables = {
    'sync_states',
    'local_store_metas',
  };

  /// Marker for a value SQLite can hold that JSON cannot.
  static const String blobMarker = 'base64_blob';

  /// Every table a backup covers, in an order safe to insert in.
  ///
  /// Drift lists tables in the order they are declared, which is parent before
  /// child, so inserting forwards and deleting backwards keeps references
  /// resolvable at every point.
  List<TableInfo<Table, Object?>> get backedUpTables => [
    for (final table in _db.allTables)
      if (!deviceLocalTables.contains(table.actualTableName)) table,
  ];

  /// Take a snapshot of everything on this device.
  Future<BackupDocument> create({
    String appVersion = '',
    String device = '',
  }) async {
    final owner = await _db.getLocalStoreMeta();

    final tables = <String, List<Map<String, Object?>>>{};
    for (final table in backedUpTables) {
      final name = table.actualTableName;
      final rows = await _db.customSelect('SELECT * FROM $name').get();
      tables[name] = [for (final row in rows) _encodeRow(row.data)];
    }

    return BackupDocument(
      metadata: BackupMetadata(
        schemaVersion: _db.schemaVersion,
        createdAt: DateTime.now(),
        appVersion: appVersion,
        device: device,
        ownerUserId: owner?.ownerUserId,
        ownerEmail: owner?.ownerEmail,
      ),
      tables: tables,
    );
  }

  /// Replace everything on this device with what is in [document].
  ///
  /// The whole thing runs in one transaction. A restore that failed halfway
  /// would leave a database that is neither the old one nor the new one, which
  /// for financial records is worse than either — so if any part of it cannot
  /// be written, nothing is.
  Future<RestoreSummary> restore(BackupDocument document) async {
    // Checked here rather than while decoding, because only the database knows
    // what this build can actually hold. A file written against a later schema
    // describes columns and tables that do not exist yet; placing the parts
    // that happen to fit would leave a database that looks restored and is
    // quietly missing whatever the newer version had added.
    if (document.metadata.schemaVersion > _db.schemaVersion) {
      throw BackupFormatException(
        'This backup was made by a newer version of the app (database '
        '${document.metadata.schemaVersion}, this build reads up to '
        '${_db.schemaVersion}). Update The Accountant and try again.',
      );
    }

    final known = {
      for (final table in backedUpTables) table.actualTableName: table,
    };

    final unknownTables = <String>[];
    final skippedColumns = <String>{};
    var restored = 0;

    await _db.transaction(() async {
      // Backwards, so a child is gone before the parent it points at.
      for (final table in backedUpTables.reversed) {
        await _db.customStatement('DELETE FROM ${table.actualTableName}');
      }

      for (final entry in document.tables.entries) {
        final table = known[entry.key];
        if (table == null) {
          // A table this build has never heard of, or one it deliberately
          // leaves alone. Either way there is nowhere to put the rows, and
          // saying so is better than dropping them in silence.
          if (!deviceLocalTables.contains(entry.key)) {
            unknownTables.add(entry.key);
          }
          continue;
        }

        final columns = {
          for (final column in table.$columns) column.name: column,
        };

        for (final row in entry.value) {
          final values = <String, Object?>{};
          for (final field in row.entries) {
            if (!columns.containsKey(field.key)) {
              skippedColumns.add('${entry.key}.${field.key}');
              continue;
            }
            values[field.key] = _decodeValue(field.value);
          }
          if (values.isEmpty) continue;

          _rewriteSyncStatus(values, columns);

          final names = values.keys.toList();
          final placeholders = List.filled(names.length, '?').join(', ');
          await _db.customStatement(
            'INSERT OR REPLACE INTO ${entry.key} (${names.join(', ')}) '
            'VALUES ($placeholders)',
            [for (final name in names) values[name]],
          );
          restored++;
        }
      }

      // A backup from before a category was introduced would otherwise leave
      // the app with no transfer or correction category to file against.
      await _db.ensureSystemCategoriesExist();

      // Balances are a cache over the rows that were just replaced.
      await WalletBalanceService(_db).recalculateAllWalletBalancesLocal();
    });

    // The cursor described a conversation with the server that the rows on this
    // device are no longer part of. Cleared, so the next sync pulls in full and
    // reconciles against what was just restored rather than asking for changes
    // since a moment that no longer means anything.
    //
    // This only works because SyncService reads the cursor from the database
    // at the point of use. It used to hold its own copy, so clearing the row
    // here changed nothing a running service could see, and the next sync
    // quietly skipped everything the server held from before the restore.
    await _db.clearLastSyncTimestamp();

    return RestoreSummary(
      rowsRestored: restored,
      unknownTables: unknownTables,
      skippedColumns: skippedColumns.toList()..sort(),
    );
  }

  /// Make a restored row push itself to the cloud on the next sync.
  ///
  /// A live row becomes `pendingCreate` — never `pendingUpdate`. The server
  /// treats a create for a row it already holds as an accepted no-op, so the
  /// worst case is that the cloud copy wins; whereas an update for a row the
  /// server has never seen is answered "not found" every time, for ever, and
  /// the record is stranded on the device. Restoring must not be able to
  /// produce that.
  ///
  /// A tombstone keeps whatever status the backup gave it: a deletion the
  /// server already acknowledged stays acknowledged, and one still waiting
  /// stays waiting.
  static void _rewriteSyncStatus(
    Map<String, Object?> values,
    Map<String, GeneratedColumn<Object>> columns,
  ) {
    if (!columns.containsKey('sync_status')) return;
    if (columns.containsKey('deleted_at') && values['deleted_at'] != null) {
      return;
    }
    values['sync_status'] = SyncStatus.pendingCreate;
  }

  static Map<String, Object?> _encodeRow(Map<String, Object?> row) => {
    for (final entry in row.entries) entry.key: _encodeValue(entry.value),
  };

  static Object? _encodeValue(Object? value) {
    if (value is Uint8List) {
      return {blobMarker: base64Encode(value)};
    }
    return value;
  }

  static Object? _decodeValue(Object? value) {
    if (value is Map && value.containsKey(blobMarker)) {
      return base64Decode('${value[blobMarker]}');
    }
    return value;
  }
}

/// What a restore actually did, so the result can be reported rather than
/// assumed.
class RestoreSummary {
  const RestoreSummary({
    required this.rowsRestored,
    this.unknownTables = const [],
    this.skippedColumns = const [],
  });

  final int rowsRestored;

  /// Sections of the file this build has no table for.
  final List<String> unknownTables;

  /// Columns dropped because the table no longer has them, as `table.column`.
  final List<String> skippedColumns;

  /// Whether anything in the file could not be placed.
  bool get isComplete => unknownTables.isEmpty && skippedColumns.isEmpty;
}
