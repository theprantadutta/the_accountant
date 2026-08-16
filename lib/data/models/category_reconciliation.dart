import 'package:drift/drift.dart';

/// A question the server asked about a built-in category, waiting on the user.
///
/// Accounts created before built-in categories had slugs hold cloud categories
/// with `default_key = NULL`. When this device seeds its own copy of a built-in
/// and tries to push it, the server may find one of those pre-slug rows sitting
/// there with the same name and direction — possibly the same category, possibly
/// one the user typed themselves. It refuses to guess, and rejects the create
/// with the candidates attached. This table is where that question lives until
/// the user answers it.
///
/// It is **device-local and never synced**: it describes a decision this
/// installation still owes, not shared account state. Once the answer has been
/// pushed and applied the row is deleted.
///
/// While a row here is unresolved, the provisional category it names is held
/// back from every push, along with anything that references it. That is what
/// stops the same rejection from being retried on every sync forever — and the
/// held-back records keep their pending-create status, so they upload intact
/// the moment the question is answered.
@DataClassName('CategoryReconciliation')
class CategoryReconciliations extends Table {
  /// The built-in this question is about. One open question per built-in.
  TextColumn get defaultKey => text()();

  /// The local category seeded for that built-in, still unpushed.
  TextColumn get provisionalCategoryId => text()();

  /// The built-in's catalogue name and direction, as the server described them.
  TextColumn get catalogName => text()();
  BoolColumn get catalogIsIncome => boolean()();

  /// The candidates the server offered, as a JSON array. Stored verbatim so the
  /// question can still be shown offline, long after the push that raised it.
  TextColumn get candidatesJson => text()();

  /// The user's answer, or null while the question is still open.
  ///
  /// One of the `kind` values in `CategoryReconciliationKinds`.
  TextColumn get resolutionKind => text().nullable()();

  /// Which candidate the user chose, for an adopt answer.
  TextColumn get resolutionCandidateId => text().nullable()();

  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {defaultKey};
}
