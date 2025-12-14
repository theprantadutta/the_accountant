import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().nullable()();
  TextColumn get email => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
