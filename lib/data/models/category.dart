import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();
  TextColumn get name => text()();
  TextColumn get colorCode => text()();
  TextColumn get type => text()(); // 'expense' or 'income'
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
