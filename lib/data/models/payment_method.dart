import 'package:drift/drift.dart';

class PaymentMethods extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'card', 'bank', 'cash', 'digital_wallet'
  TextColumn get lastFourDigits => text().nullable()(); // For cards
  TextColumn get institution =>
      text().nullable()(); // Bank name, card issuer, etc.
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
