import 'package:drift/drift.dart';

/// Recurrence types enum
enum RecurrenceType { daily, weekly, monthly, yearly }

/// Recurring configurations table for scheduled transactions
class RecurringConfigs extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Reference to the base transaction that defines the template
  TextColumn get baseTransactionId => text()();

  // Recurrence settings
  IntColumn get periodLength =>
      integer().withDefault(const Constant(1))(); // e.g., every 2 weeks
  TextColumn get reoccurrence => text().withDefault(
    const Constant('monthly'),
  )(); // daily, weekly, monthly, yearly

  // Date range
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get nextOccurrence => dateTime()();

  // Status
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(
    const Constant(0),
  )(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
