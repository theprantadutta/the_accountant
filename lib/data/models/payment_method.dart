import 'package:drift/drift.dart';

/// Payment methods table for tracking payment sources
class PaymentMethods extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Payment method details
  TextColumn get name => text()();
  TextColumn get iconName =>
      text().withDefault(const Constant('credit_card'))();
  TextColumn get type =>
      text().withDefault(const Constant('card'))(); // card, bank, cash, digital_wallet

  // Card-specific fields
  TextColumn get lastFourDigits => text().nullable()();
  TextColumn get institution => text().nullable()(); // Bank name, card issuer

  // Flags
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus =>
      integer().withDefault(const Constant(0))(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
