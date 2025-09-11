import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';
import 'package:the_accountant/data/models/wallet.dart';

class Transactions extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'expense' or 'income'
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get walletId => text().references(Wallets, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrencePattern =>
      text().nullable()(); // JSON string for recurrence details
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
