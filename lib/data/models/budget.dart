import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';

class Budgets extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();
  TextColumn get name => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  RealColumn get limit => real()();
  TextColumn get period => text()(); // 'weekly' or 'monthly'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
