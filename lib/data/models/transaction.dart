import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';
import 'package:the_accountant/data/models/wallet.dart';
import 'package:the_accountant/data/models/payment_method.dart';
import 'package:the_accountant/data/models/recurring_config.dart';

/// Transaction types enum (internal processing type)
enum TransactionType {
  regular,
  transfer,
  recurringInstance,
}

/// Transaction special types enum (like Cashew)
/// Used for filtering and special handling of transactions
enum TransactionSpecialType {
  /// Default transaction - no special handling
  none,

  /// Future unpaid transaction - shows in "Upcoming" section
  upcoming,

  /// Subscription payment - recurring service payment
  subscription,

  /// Repetitive transaction - recurring non-subscription payment
  repetitive,

  /// Credit - money lent to someone (they owe you)
  credit,

  /// Debt - money borrowed from someone (you owe them)
  debt,
}

/// Transactions table for financial records
class Transactions extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL PRIMARY KEY')();

  // Transaction details
  RealColumn get amount => real()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();

  // Transaction type - income or expense
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();

  // Legacy type field (kept for backward compatibility)
  TextColumn get type => text().withDefault(const Constant('regular'))(); // 'expense', 'income', 'regular'

  // Transaction type for special cases
  TextColumn get transactionType =>
      text().withDefault(const Constant('regular'))(); // regular, transfer, recurring_instance

  // Foreign keys
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get walletId => text().references(Wallets, #id)();
  TextColumn get paymentMethodId =>
      text().nullable().references(PaymentMethods, #id)();

  // Legacy payment method field
  TextColumn get paymentMethod => text().nullable()();

  // For transfers - paired transaction
  TextColumn get pairedTransactionId => text().nullable()();

  // For recurring instances
  TextColumn get recurringConfigId =>
      text().nullable().references(RecurringConfigs, #id)();

  // Legacy recurrence fields
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrencePattern => text().nullable()();

  // Receipt image
  TextColumn get receiptImageUrl => text().nullable()();

  // Special transaction type (like Cashew)
  IntColumn get specialType =>
      intEnum<TransactionSpecialType>().withDefault(const Constant(0)).nullable()();

  // Paid status - for upcoming/debt/credit transactions
  // When true: transaction is paid/settled
  // When false: transaction is still pending
  BoolColumn get isPaid => boolean().withDefault(const Constant(true))();

  // Original due date - stores when transaction was originally due
  // Useful when a transaction is marked as paid (date updates to payment date)
  DateTimeColumn get originalDueDate => dateTime().nullable()();

  // Skip this payment (for recurring unpaid transactions)
  BoolColumn get skipPaid => boolean().withDefault(const Constant(false))();

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
