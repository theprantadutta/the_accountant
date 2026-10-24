import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/wallet.dart';

/// What is held. Stored by index, and the server holds the same numbers, so
/// new kinds go on the end.
enum InvestmentKind {
  /// A mutual fund, unit trust or ETF, priced by its NAV.
  fund,

  /// Shares of one company.
  stock,

  /// Anything else bought in units: gold by the gram, crypto, a bond fund.
  other,
}

/// A fund, share or other holding bought and sold in units.
///
/// The value lives in a wallet of its own ([walletId], of type
/// [WalletType.investment]), so net worth counts it like any account. Buying
/// and selling are transfers into and out of that wallet carrying the units
/// they moved ([Transactions.units]); the units held are their sum. A new
/// price revalues the wallet to units × price with a balance correction, so
/// what it is worth now and what was paid stay separate in the history.
class Investments extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  TextColumn get name => text()();
  IntColumn get kind => intEnum<InvestmentKind>()();

  /// Ticker or fund code, if it has one.
  TextColumn get symbol => text().nullable()();

  /// The wallet that holds its value.
  TextColumn get walletId => text().references(Wallets, #id)();

  /// The latest price of one unit, in minor units. Zero until one is known.
  IntColumn get price => integer().withDefault(const Constant(0))();

  /// When [price] was last set, by a trade or by hand.
  DateTimeColumn get priceDate => dateTime().nullable()();

  TextColumn get notes => text().nullable()();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
