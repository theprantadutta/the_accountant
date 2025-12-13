import 'package:drift/drift.dart';

/// Sync state table for tracking synchronization status per table
/// Used by the hybrid sync system to know what needs to be synced
class SyncStates extends Table {
  // Primary key - auto-increment
  IntColumn get id => integer().autoIncrement()();

  // Table name being tracked (renamed to avoid conflict with Table.tableName)
  TextColumn get syncTableName => text()();

  // Last successful sync timestamp
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  // Server version number for incremental sync
  IntColumn get lastServerVersion => integer().withDefault(const Constant(0))();

  // Pending changes as JSON array (for offline queue)
  TextColumn get pendingChanges => text().withDefault(const Constant('[]'))();

  // Timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
