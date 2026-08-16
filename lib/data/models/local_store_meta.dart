import 'package:drift/drift.dart';

/// Single-row table recording which backend account this local database belongs
/// to, plus the bookkeeping needed to make account switching safe.
///
/// The local Drift store used to be completely anonymous: signing out cleared
/// only the auth tokens, so the next account to sign in on the same device saw
/// — and could push — the previous account's financial records. Binding the
/// store to an owner id lets every sync verify "this data is mine" before a
/// single byte leaves the device, and lets the app open a *different* database
/// file when a different account signs in instead of mixing the two.
///
/// [ownerUserId] is null only for a store that has never been claimed (a
/// brand-new install, or a user who has only ever used the app offline). The
/// first account to sign in claims such a store, which is what preserves the
/// pre-login work of an existing local-only user.
class LocalStoreMetas extends Table {
  /// Always 1 — this table holds exactly one row.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Backend user id that owns the data in this database file.
  TextColumn get ownerUserId => text().nullable()();

  /// Email of the owner, purely for diagnostics and confirmation dialogs.
  TextColumn get ownerEmail => text().nullable()();

  /// When the store was bound to [ownerUserId].
  DateTimeColumn get claimedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
