import 'package:drift/drift.dart';

/// A local primary key this device had to change, or could not safely change.
///
/// Post-signup onboarding used to mint its wallet id from
/// `DateTime.now().millisecondsSinceEpoch`, which the backend cannot accept —
/// `SyncChange.EntityId` is a `Guid`. One such wallet rejects the whole push,
/// so the wallet and everything filed against it stay pending forever.
///
/// The schema-15 migration re-keys those wallets, but the database is not the
/// only place a wallet id is written down: `default_wallet_id` lives in
/// SharedPreferences, which a Drift migration cannot reach. So the mapping is
/// recorded here and applied to the preferences at startup, then cleared.
///
/// A row with no [newId] is the case the migration deliberately refused: an
/// invalid id the server may already know about. Changing that would orphan the
/// cloud copy, so the data is left exactly as it is and the row stands as a
/// diagnostic for support to act on.
///
/// Device-local, never synced.
@DataClassName('LocalIdRepair')
class LocalIdRepairs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Which table the id belongs to, e.g. `wallets`.
  TextColumn get entityTable => text()();

  TextColumn get oldId => text()();

  /// The replacement, or null when the re-key was refused as unsafe.
  TextColumn get newId => text().nullable()();

  /// `applied` — the database was re-keyed and dependent rows repointed.
  /// `blocked` — nothing was changed; see [detail].
  TextColumn get status => text()();

  TextColumn get detail => text().nullable()();

  /// Set once the preference repoint has been carried out.
  DateTimeColumn get settledAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
