import 'package:drift/drift.dart';

/// Wallet types for categorizing accounts
enum WalletType {
  /// Physical cash
  cash,

  /// Bank account
  bankAccount,

  /// Credit card with limit and billing cycle
  creditCard,

  /// Subscription grouping wallet
  subscription,
}

/// Wallets table for managing multiple accounts/wallets
class Wallets extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Wallet details
  TextColumn get name => text()();
  TextColumn get iconName => text().withDefault(const Constant('wallet'))();
  TextColumn get color => text().withDefault(const Constant('#6366F1'))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();

  // Balance tracking (integer minor units / cents)
  IntColumn get balance => integer().withDefault(const Constant(0))();

  // Opening balance (integer minor units / cents) - the wallet's starting balance
  IntColumn get openingBalance => integer().withDefault(const Constant(0))();

  // Flags
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get useDecimals => boolean().withDefault(const Constant(true))();

  // Wallet type (cash, bankAccount, creditCard, subscription)
  IntColumn get walletType =>
      intEnum<WalletType>().withDefault(const Constant(0))();

  // Credit card specific fields (integer minor units / cents)
  IntColumn get creditLimit => integer().nullable()();
  IntColumn get billingCycleDay => integer().nullable()(); // 1-31

  // Display ordering
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  /// Kept for its history, but no longer offered or counted.
  ///
  /// Not the same as deleting it: an account someone has closed still explains
  /// where last year's money went, so removing it would rewrite their past.
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  /// Left out of the total across accounts.
  ///
  /// For a balance that is not really the user's to spend — a joint pot, or an
  /// account they only administer — where counting it makes every summary
  /// figure wrong in a way nothing on screen explains.
  BoolColumn get excludeFromTotal =>
      boolean().withDefault(const Constant(false))();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(
    const Constant(0),
  )(); // 0=synced, 1=create, 2=update, 3=delete

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
