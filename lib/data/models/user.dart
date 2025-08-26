import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();
  TextColumn get fullName => text().nullable()();
  TextColumn get email => text().customConstraint('UNIQUE NOT NULL')();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}