import 'package:drift/drift.dart';

/// Budget periods enum
enum BudgetPeriod {
  weekly,
  monthly,
  yearly,
  custom,
}

/// Budgets table for spending limits tracking
class Budgets extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Budget details
  TextColumn get name => text()();
  RealColumn get amount => real()(); // Renamed from 'limit' for clarity (limit is reserved in SQL)
  TextColumn get period =>
      text().withDefault(const Constant('monthly'))(); // weekly, monthly, yearly, custom

  // Date range
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  // Scope - JSON arrays of IDs
  TextColumn get walletIds =>
      text().withDefault(const Constant('[]'))(); // JSON array of wallet IDs
  TextColumn get categoryIds =>
      text().withDefault(const Constant('[]'))(); // JSON array of category IDs

  // Legacy single category reference
  TextColumn get categoryId => text().nullable()();

  // Budget type
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();

  // Display flags
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  // Legacy field
  RealColumn get limit => real().nullable()();

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
