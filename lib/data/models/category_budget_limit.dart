import 'package:drift/drift.dart';

/// A cap on one category inside a budget.
///
/// A budget answers whether the period has been overspent. A limit inside it
/// answers where, which is usually the more useful question: a food budget
/// that is on track overall can still be mostly takeaway, and nothing about
/// the budget's own total will say so.
///
/// Uniqueness per budget and category is enforced by a partial index created in
/// the migration rather than a table constraint here, so that a limit which was
/// deleted does not block setting a new one for the same pair.
@DataClassName('CategoryBudgetLimit')
class CategoryBudgetLimits extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  /// The budget this cap belongs to.
  ///
  /// Not a foreign key, matching how the rest of the scope references work
  /// here; the prune helpers keep it honest instead.
  TextColumn get budgetId => text()();

  TextColumn get categoryId => text()();

  /// Minor units, or hundredths of a percent when [isPercent].
  ///
  /// A percentage is an integer for the same reason money is: 25.5% is 2550.
  /// Storing it as a fraction of a budget that can itself change would leave
  /// two numbers to keep in step.
  IntColumn get amount => integer()();

  /// Whether [amount] is a share of the budget rather than a sum.
  ///
  /// A share survives a change to the budget's own amount: someone who decides
  /// groceries should be half their food budget means half, whatever half
  /// turns out to be.
  BoolColumn get isPercent => boolean().withDefault(const Constant(false))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
