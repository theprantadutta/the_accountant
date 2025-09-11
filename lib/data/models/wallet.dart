import 'package:drift/drift.dart';

class Wallets extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();
  TextColumn get name => text()();
  TextColumn get currency => text()();
  RealColumn get balance => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}
