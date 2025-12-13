import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/objective.dart';
import 'package:the_accountant/data/models/transaction.dart';

/// Junction table linking transactions to objectives (goals/savings)
/// Many-to-many relationship: transactions can contribute to multiple objectives
class ObjectiveTransactions extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();

  // Foreign keys
  TextColumn get objectiveId => text().references(Objectives, #id)();
  TextColumn get transactionId => text().references(Transactions, #id)();

  // Timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
