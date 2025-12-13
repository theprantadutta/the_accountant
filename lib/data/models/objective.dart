import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/wallet.dart';

/// Objective types enum
enum ObjectiveType {
  goal, // Saving up for something
  loan, // Paying off debt
}

/// Objectives table for goals and savings tracking
class Objectives extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();

  // Objective details
  TextColumn get name => text()();
  TextColumn get iconName => text().withDefault(const Constant('flag'))();
  TextColumn get color => text().withDefault(const Constant('#6366F1'))();

  // Target amount
  RealColumn get targetAmount => real()();

  // Type: goal (saving) or loan (paying off)
  TextColumn get type => text().withDefault(const Constant('goal'))();

  // Associated wallet (optional)
  TextColumn get walletId => text().nullable().references(Wallets, #id)();

  // Date range
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  // Display flags
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

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
