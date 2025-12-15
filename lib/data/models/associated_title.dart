import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';

/// Associated titles table for smart categorization
/// Maps transaction titles to categories for automatic suggestions
class AssociatedTitles extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // The title pattern to match
  TextColumn get title => text()();

  // The category to suggest
  TextColumn get categoryId => text().references(Categories, #id)();

  // Match type: exact match or contains match
  BoolColumn get isExactMatch => boolean().withDefault(const Constant(false))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus =>
      integer().withDefault(const Constant(0))(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
