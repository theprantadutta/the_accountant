import 'package:drift/drift.dart';

/// Categories table for organizing transactions
/// Supports subcategories via mainCategoryId self-reference
class Categories extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Category details
  TextColumn get name => text()();
  TextColumn get iconName => text().withDefault(const Constant('category'))();
  TextColumn get color => text().withDefault(const Constant('#6366F1'))();

  // Subcategory support - references parent category
  TextColumn get mainCategoryId => text().nullable()();

  // Category type - expense or income
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();

  // Display ordering
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  // Legacy field for backward compatibility
  TextColumn get type => text().nullable()(); // 'expense' or 'income'
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

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
