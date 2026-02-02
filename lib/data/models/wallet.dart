import 'package:drift/drift.dart';

/// Wallets table for managing multiple accounts/wallets
class Wallets extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Wallet details
  TextColumn get name => text()();
  TextColumn get iconName => text().withDefault(const Constant('wallet'))();
  TextColumn get color => text().withDefault(const Constant('#6366F1'))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();

  // Balance tracking
  RealColumn get balance => real().withDefault(const Constant(0.0))();

  // Flags
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get useDecimals => boolean().withDefault(const Constant(true))();

  // Display ordering
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus =>
      integer().withDefault(const Constant(0))(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
