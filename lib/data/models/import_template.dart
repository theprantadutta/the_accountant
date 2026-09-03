import 'package:drift/drift.dart';

/// A saved answer to "which column is which" for one bank's export.
///
/// Cashew asks for the whole mapping every time a file is imported. Nobody
/// should have to re-describe their bank's statement every month, so the answer
/// is kept and offered back the next time a file with the same columns turns
/// up.
///
/// Local only. A mapping describes a file on this device's disk and means
/// nothing on another one, so it is deliberately absent from the sync tables —
/// but it *is* included in a backup, because losing it is a small, pointless
/// annoyance that a backup can prevent.
class ImportTemplates extends Table {
  TextColumn get id => text()();

  /// What the user calls it — usually the bank and the account.
  TextColumn get name => text()();

  /// The character that separated the fields when this was saved.
  TextColumn get delimiter => text().withDefault(const Constant(','))();

  BoolColumn get hasHeader => boolean().withDefault(const Constant(true))();

  /// The mapping itself, as JSON. Stored opaquely so a new import field can be
  /// added without a migration.
  TextColumn get mapping => text()();

  /// A fingerprint of the column titles this was built against.
  ///
  /// This is what lets the right template be offered without the user having to
  /// remember which one they made: the next file whose headings match is
  /// recognised on sight.
  TextColumn get columnSignature => text().withDefault(const Constant(''))();

  /// The account rows land in when the file does not name one.
  TextColumn get defaultWalletId => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Used to offer the most recently useful template first.
  DateTimeColumn get lastUsedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
