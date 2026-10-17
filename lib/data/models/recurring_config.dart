import 'package:drift/drift.dart';

/// Recurrence types enum
enum RecurrenceType { daily, weekly, monthly, yearly }

/// Recurring configurations table for scheduled transactions
class RecurringConfigs extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Reference to the base transaction that defines the template
  TextColumn get baseTransactionId => text()();

  // Recurrence settings
  IntColumn get periodLength =>
      integer().withDefault(const Constant(1))(); // e.g., every 2 weeks
  TextColumn get reoccurrence => text().withDefault(
    const Constant('monthly'),
  )(); // daily, weekly, monthly, yearly

  // Date range
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get nextOccurrence => dateTime()();

  // Status
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// What each payment from now on is for, in minor units, or null to use the
  /// base transaction's amount.
  ///
  /// The base transaction is the first real payment, so changing the price on
  /// it rewrote what that payment had been. Prices change — a plan is
  /// upgraded, a charge in another currency moves with the rate — and the
  /// change belongs to the payments still to come, so it lives here.
  IntColumn get amount => integer().nullable()();

  /// The wallet each payment from now on comes from, or null for the base
  /// transaction's. Paying from a new card is a change to the future, not a
  /// reason to move last year's payments onto it.
  TextColumn get walletId => text().nullable()();

  /// Whether a payment is recorded as paid on the day it falls due.
  ///
  /// When false the payment is written as pending instead, and waits in
  /// Upcoming for the user to confirm it — with what was actually charged —
  /// or skip it. It is per schedule rather than one switch for everything,
  /// because a fixed rent and a card charge in dollars want different answers.
  BoolColumn get autoPay => boolean().withDefault(const Constant(true))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(
    const Constant(0),
  )(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
