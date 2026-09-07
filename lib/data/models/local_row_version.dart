import 'package:drift/drift.dart';

/// A counter that goes up every time a synced row is written locally.
///
/// Purely local: never pushed, never pulled, and meaningless on any other
/// device. It exists to answer one question the rest of the sync could not:
/// **is the version of this row sitting here the same one we last handed to the
/// server?**
///
/// Everything that tried to answer it from `updatedAt` failed, because Drift
/// stores that at one-second resolution and a push is assembled in
/// milliseconds — an edit made while a push was in flight carried the same
/// timestamp as the version being pushed. Two separate defects came out of
/// that: acknowledgements cleared the pending flag over the top of unsent
/// edits, and the pull could not tell "the server has already rejected exactly
/// this version" from "this device has something the server has not seen".
/// The first loses the edit; the second, if you guard against it bluntly, wedges
/// every conflict instead. A counter distinguishes them exactly.
///
/// Maintained by database triggers rather than by the call sites, so a write
/// through a path nobody remembered to update still bumps it. Installed on open
/// alongside the other guards, in `AppDatabase._installRowVersionTriggers`.
@DataClassName('LocalRowVersion')
class LocalRowVersions extends Table {
  /// The synced table the row lives in — one of `AppDatabase.syncedTableNames`.
  ///
  /// Not called `tableName`: Drift's own `Table` already has a member by that
  /// name and a column would silently override it.
  TextColumn get syncTable => text()();

  /// The row's id within that table.
  TextColumn get entityId => text()();

  /// Bumped on every insert and update of that row.
  IntColumn get revision => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {syncTable, entityId};
}
