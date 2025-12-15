import 'package:drift/drift.dart';

/// Exchange rates table for storing currency conversion rates
/// Supports both API-fetched rates and user-defined custom rates
class ExchangeRates extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Currency pair (ISO 4217 codes)
  TextColumn get fromCurrency => text()(); // e.g., "USD"
  TextColumn get toCurrency => text()();   // e.g., "EUR"

  // Rates
  RealColumn get apiRate => real().nullable()();      // Rate fetched from API
  RealColumn get customRate => real().nullable()();   // User-defined override rate
  BoolColumn get useCustomRate => boolean().withDefault(const Constant(false))();

  // API rate metadata
  DateTimeColumn get apiRateFetchedAt => dateTime().nullable()();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus =>
      integer().withDefault(const Constant(0))(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
