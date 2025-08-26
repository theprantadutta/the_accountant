import 'package:drift/drift.dart';

class UserProfiles extends Table {
  TextColumn get userId => text().customConstraint('NOT NULL PRIMARY KEY')();
  TextColumn get fullName => text().nullable()();
  TextColumn get email => text().customConstraint('UNIQUE NOT NULL')();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get profileImageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {userId};
}