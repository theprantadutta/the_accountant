import 'package:drift/drift.dart';

/// How often a budget's window repeats.
///
/// The order is the sync wire contract: push and pull carry this as an integer
/// and the server maps the same numbers onto its own enum. A new member goes on
/// the end, in the same release on both sides, or budgets silently change
/// meaning on every device. See `SyncEnumContractTests` on the server and
/// `sync_wire_contract_test.dart` here, which pin both halves.
enum BudgetPeriod { daily, weekly, biweekly, monthly, yearly, custom }

/// Budgets table for spending limits tracking
class Budgets extends Table {
  // Primary key - UUID string
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  // Budget details
  TextColumn get name => text()();

  /// The limit, in integer minor units (cents).
  ///
  /// Named `amount` rather than `limit` because the latter is reserved in SQL.
  IntColumn get amount => integer()();

  /// The currency [amount] is stated in, as an ISO code.
  ///
  /// An amount is a bare count of minor units, and nothing else on the row says
  /// what kind of money it counts. That used to be answered with whatever the
  /// user's default account happened to be at the moment of reading — so
  /// opening a euro account and making it the default turned a $100 budget into
  /// a €100 budget, with the figure on screen never changing. Recorded here, a
  /// budget entered in dollars stays a budget in dollars however the accounts
  /// around it change.
  ///
  /// Null on a budget written before this existed, and on one pulled from a
  /// server that predates it. Readers treat null as "not stated" and fall back
  /// to the display currency, which is exactly the old behaviour.
  TextColumn get currency => text().nullable()();

  /// One of [BudgetPeriod]'s names.
  TextColumn get period => text().withDefault(const Constant('monthly'))();

  /// How many [period] units one window spans, so "every 2 weeks" is expressible.
  ///
  /// Always at least 1. The server carries this as an integer and treats a
  /// missing value as 1, which is what every budget written before this column
  /// existed meant.
  IntColumn get periodLength => integer().withDefault(const Constant(1))();

  // Date range. `endDate` is null for a repeating budget that has no finish;
  // only a `custom` budget is required to have one.
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  // Scope: JSON arrays of ids. Neither is a foreign key, so nothing in the
  // database keeps them honest; AppDatabase's prune helpers do that instead.
  // An empty array means "not narrowed", not "matches nothing".
  TextColumn get walletIds => text().withDefault(const Constant('[]'))();
  TextColumn get categoryIds => text().withDefault(const Constant('[]'))();

  /// Whether an unspent balance carries into the next window.
  ///
  /// Cashew has no equivalent: its budgets always restart at zero, so someone
  /// who underspends one month and wants that headroom the next has to edit the
  /// amount by hand.
  BoolColumn get rollover => boolean().withDefault(const Constant(false))();

  // Budget type: a budget either limits spending or targets earnings.
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();

  // Display flags
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

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
