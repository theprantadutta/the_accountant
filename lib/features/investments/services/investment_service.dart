import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/transactions/services/transfer_service.dart';
import 'package:the_accountant/features/wallets/services/wallet_maintenance_service.dart';

/// What someone fills in to start tracking a holding.
class InvestmentDraft {
  const InvestmentDraft({
    required this.name,
    required this.kind,
    required this.currency,
    this.symbol,
    this.price = 0,
    this.useDecimals = true,
    this.notes,
  });

  final String name;
  final InvestmentKind kind;
  final String currency;
  final String? symbol;

  /// The price of one unit now, in minor units, if known.
  final int price;
  final bool useDecimals;
  final String? notes;
}

/// One buy, sell or revaluation of a holding, as its history shows it.
class InvestmentTrade {
  const InvestmentTrade(this.row);

  final Transaction row;

  bool get isRevaluation =>
      TransactionPolicy.kindOf(row) == TransactionType.adjustment;

  /// Money into the holding: a buy, or a rise in price.
  bool get isIn => row.isIncome;

  /// Units moved, signed: positive bought, negative sold. Zero for a
  /// revaluation.
  double get units => (row.units ?? 0) * (row.isIncome ? 1 : -1);
}

/// Where a holding stands.
class InvestmentHolding {
  const InvestmentHolding({
    required this.investment,
    required this.wallet,
    required this.units,
    required this.putIn,
    required this.takenOut,
  });

  final Investment investment;
  final Wallet wallet;

  /// Units held now.
  final double units;

  /// Minor units paid in by buying, and received back by selling.
  final int putIn;
  final int takenOut;

  /// What it is worth now: units at the latest price.
  int get value => wallet.balance;

  /// Gain or loss over everything: what it is worth and what came back,
  /// against what went in.
  int get gain => value + takenOut - putIn;

  /// [gain] as a percentage of what went in, or null before anything did.
  double? get gainPercent => putIn == 0 ? null : gain / putIn * 100;

  String get currency => wallet.currency;
}

/// Funds, shares and other holdings, against the database.
///
/// A holding's value sits in a wallet of its own, so net worth, sync and
/// backups treat it like any account. Buying and selling are transfers with
/// the units they moved on the investment's leg; the units held are their sum,
/// so two phones trading at once cannot overwrite each other's count. Every
/// trade and every new price revalues the wallet to units × price with a
/// balance correction, which keeps "what it is worth" and "what was paid"
/// apart in the history.
///
/// No Riverpod here, so the plan collector can buy for a SIP in the
/// background.
class InvestmentService {
  InvestmentService(this._db)
    : _balances = WalletBalanceService(_db),
      _transfers = TransferService(_db),
      _maintenance = WalletMaintenanceService(_db);

  final AppDatabase _db;
  final WalletBalanceService _balances;
  final TransferService _transfers;
  final WalletMaintenanceService _maintenance;
  static const _uuid = Uuid();

  /// Units are kept to six places, enough for any fund statement, and the
  /// rest is noise from dividing money by a price.
  static double roundUnits(double u) => (u * 1e6).roundToDouble() / 1e6;

  // ------------------------------------------------------------ reading

  Future<List<Investment>> all() =>
      (_db.select(_db.investments)
            ..where((i) => i.deletedAt.isNull())
            ..orderBy([(i) => OrderingTerm.asc(i.createdAt)]))
          .get();

  Future<Investment?> find(String id) => (_db.select(
    _db.investments,
  )..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<Investment?> byWallet(String walletId) =>
      (_db.select(_db.investments)
            ..where((i) => i.walletId.equals(walletId) & i.deletedAt.isNull()))
          .getSingleOrNull();

  Future<List<Transaction>> _rowsOf(String walletId) =>
      (_db.select(_db.transactions)
            ..where((t) => t.walletId.equals(walletId) & t.deletedAt.isNull())
            ..orderBy([
              (t) => OrderingTerm.desc(t.date),
              (t) => OrderingTerm.desc(t.createdAt),
            ]))
          .get();

  /// The holding's buys, sells and revaluations, newest first.
  Future<List<InvestmentTrade>> tradesOf(Investment i) async => [
    for (final r in await _rowsOf(i.walletId)) InvestmentTrade(r),
  ];

  Future<double> unitsHeld(String walletId) async {
    var units = 0.0;
    for (final r in await _rowsOf(walletId)) {
      units += (r.units ?? 0) * (r.isIncome ? 1 : -1);
    }
    return roundUnits(units);
  }

  Future<InvestmentHolding?> holdingOf(Investment i) async {
    final wallet = await _db.findWalletById(i.walletId);
    if (wallet == null) return null;
    var units = 0.0;
    var putIn = 0;
    var takenOut = 0;
    for (final r in await _rowsOf(i.walletId)) {
      units += (r.units ?? 0) * (r.isIncome ? 1 : -1);
      if (TransactionPolicy.kindOf(r) == TransactionType.transfer) {
        if (r.isIncome) {
          putIn += r.amount;
        } else {
          takenOut += r.amount;
        }
      }
    }
    return InvestmentHolding(
      investment: i,
      wallet: wallet,
      units: roundUnits(units),
      putIn: putIn,
      takenOut: takenOut,
    );
  }

  Future<List<InvestmentHolding>> holdings() async => [
    for (final i in await all()) ?await holdingOf(i),
  ];

  // ----------------------------------------------------------- creating

  /// Start tracking a holding. Returns its id. Nothing is bought yet; use
  /// [buy] for that.
  Future<String> create(InvestmentDraft d) async {
    final name = d.name.trim();
    if (name.isEmpty) throw ArgumentError('Give the investment a name.');
    if (name.length > 100) {
      throw ArgumentError('Keep the name under 100 characters.');
    }
    if ((d.symbol?.trim().length ?? 0) > 20) {
      throw ArgumentError('Keep the symbol under 20 characters.');
    }
    if (d.price < 0) throw ArgumentError('A price cannot be negative.');
    final existing = (await all()).where(
      (i) => i.name.toLowerCase() == name.toLowerCase(),
    );
    if (existing.isNotEmpty) {
      throw ArgumentError('$name is already tracked.');
    }

    final id = _uuid.v4();
    final walletId = _uuid.v4();
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.addWallet(
        WalletsCompanion(
          id: Value(walletId),
          name: Value(name),
          currency: Value(d.currency),
          iconName: const Value('trending_up'),
          color: Value(switch (d.kind) {
            InvestmentKind.fund => '#7C3AED',
            InvestmentKind.stock => '#2563EB',
            InvestmentKind.other => '#CA8A04',
          }),
          walletType: const Value(WalletType.investment),
          useDecimals: Value(d.useDecimals),
          balance: const Value(0),
          openingBalance: const Value(0),
          orderIndex: const Value(9999),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await _db
          .into(_db.investments)
          .insert(
            InvestmentsCompanion(
              id: Value(id),
              name: Value(name),
              kind: Value(d.kind),
              symbol: Value(_blankToNull(d.symbol)?.toUpperCase()),
              walletId: Value(walletId),
              price: Value(d.price),
              priceDate: Value(d.price > 0 ? now : null),
              notes: Value(_blankToNull(d.notes)),
              syncStatus: const Value(SyncStatus.pendingCreate),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    });
    return id;
  }

  // ------------------------------------------------------------ trading

  /// Buy [units] for [amount] from [fromWalletId], with any [fee] the broker
  /// charged on top. The price becomes what was paid per unit, and the whole
  /// holding is valued at it.
  ///
  /// [key], [planId] and [planInstallment] are for a SIP, whose installments
  /// must never be bought twice.
  Future<void> buy(
    String investmentId, {
    required String fromWalletId,
    required int amount,
    double? units,
    int fee = 0,
    DateTime? date,
    String? title,
    String? key,
    String? planId,
    int? planInstallment,
  }) async {
    final i = await _live(investmentId);
    if (amount <= 0) throw ArgumentError('Enter what was paid.');
    if (units != null && units <= 0) {
      throw ArgumentError('Units bought must be more than zero.');
    }
    if (fromWalletId == i.walletId) {
      throw ArgumentError('Pay for it from another account.');
    }
    if (key != null && await _keyTaken(key)) return;
    final when = _notAfterNow(date ?? DateTime.now());
    final (outId, inId) = await _transfers.createTransfer(
      sourceWalletId: fromWalletId,
      destinationWalletId: i.walletId,
      amount: amount,
      date: when,
      title: title ?? '${i.name}: bought',
      feeAmount: fee,
      feeWalletId: fee > 0 ? fromWalletId : null,
    );
    final bought = units == null ? null : roundUnits(units);
    await _tag(outId, key: key, planId: planId, number: planInstallment);
    await _tag(
      inId,
      units: bought,
      key: key == null ? null : '$key:in',
      planId: planId,
      number: planInstallment,
    );
    if (bought != null) {
      final received = (await _db.findTransactionById(inId))!.amount;
      await _setPrice(i, (received / bought).round(), when);
    }
    await revalue(investmentId, date: when);
  }

  /// Sell [units] for [amount], paid into [toWalletId], less any [fee].
  Future<void> sell(
    String investmentId, {
    required String toWalletId,
    required int amount,
    required double units,
    int fee = 0,
    DateTime? date,
  }) async {
    final i = await _live(investmentId);
    if (amount <= 0) throw ArgumentError('Enter what the sale brought in.');
    if (units <= 0) throw ArgumentError('Units sold must be more than zero.');
    if (toWalletId == i.walletId) {
      throw ArgumentError('Sell into another account.');
    }
    final held = await unitsHeld(i.walletId);
    final sold = roundUnits(units);
    if (sold > held + 1e-6) {
      throw ArgumentError('Only ${_units(held)} units of ${i.name} are held.');
    }
    final when = _notAfterNow(date ?? DateTime.now());
    // What is in the wallet is what it was last valued at; the sale is
    // recorded at what it actually brought, so revalue to the sale price
    // first and the transfer then takes out exactly what was received.
    final price = (amount / sold).round();
    await _setPrice(i, price, when);
    await revalue(investmentId, date: when);
    final (outId, _) = await _transfers.createTransfer(
      sourceWalletId: i.walletId,
      destinationWalletId: toWalletId,
      amount: amount,
      date: when,
      title: '${i.name}: sold',
      feeAmount: fee,
      feeWalletId: fee > 0 ? toWalletId : null,
    );
    await _tag(outId, units: sold);
    await revalue(investmentId, date: when);
  }

  /// A dividend or other payout from the holding, received into
  /// [toWalletId] as income.
  Future<void> dividend(
    String investmentId, {
    required String toWalletId,
    required int amount,
    DateTime? date,
  }) async {
    final i = await _live(investmentId);
    if (amount <= 0) throw ArgumentError('Enter the dividend received.');
    final wallet = await _db.findWalletById(toWalletId);
    if (wallet == null || wallet.walletType.isManaged) {
      throw ArgumentError('Receive it into an ordinary account.');
    }
    final now = DateTime.now();
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(_uuid.v4()),
        amount: Value(amount),
        isIncome: const Value(true),
        title: Value('${i.name}: dividend'),
        date: Value(_notAfterNow(date ?? now)),
        walletId: Value(toWalletId),
        categoryId: Value(
          await _db.requireSystemCategoryId(BuiltInCategoryKeys.investment),
        ),
        transactionType: Value(TransactionPolicy.regularType),
        isPaid: const Value(true),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await _balances.updateWalletBalance(toWalletId);
  }

  /// A new price for one unit, in minor units: the holding is revalued at it.
  Future<void> updatePrice(
    String investmentId,
    int price, {
    DateTime? date,
  }) async {
    final i = await _live(investmentId);
    if (price <= 0) throw ArgumentError('A price must be more than zero.');
    final when = _notAfterNow(date ?? DateTime.now());
    await _setPrice(i, price, when);
    await revalue(investmentId, date: when);
  }

  /// Correct the units recorded on one buy or sell, as a fund statement
  /// gives them. The holding is revalued at the price it already has.
  Future<void> correctUnits(String transactionId, double units) async {
    if (units <= 0) throw ArgumentError('Units must be more than zero.');
    final row = await _db.findTransactionById(transactionId);
    final i = row == null ? null : await byWallet(row.walletId);
    if (row == null ||
        i == null ||
        TransactionPolicy.kindOf(row) != TransactionType.transfer) {
      throw ArgumentError('That is not a trade of an investment.');
    }
    await _tag(transactionId, units: roundUnits(units));
    await revalue(i.id);
  }

  /// Make the holding's wallet read units × price, recording the difference
  /// as a price update. Nothing happens before a price is known.
  Future<void> revalue(String investmentId, {DateTime? date}) async {
    final i = (await find(investmentId))!;
    if (i.price <= 0) return;
    final units = await unitsHeld(i.walletId);
    await _maintenance.correctBalance(
      walletId: i.walletId,
      actualBalance: (units * i.price).round(),
      date: date,
      title: '${i.name}: price update',
      notes: '${_units(units)} units at the latest price.',
    );
  }

  // ------------------------------------------------------------ changing

  Future<void> update(
    String investmentId, {
    String? name,
    String? symbol,
    String? notes,
  }) async {
    final i = await _live(investmentId);
    final now = DateTime.now();
    await (_db.update(_db.investments)..where((x) => x.id.equals(i.id))).write(
      InvestmentsCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        symbol: symbol == null
            ? const Value.absent()
            : Value(_blankToNull(symbol)?.toUpperCase()),
        notes: notes == null ? const Value.absent() : Value(notes),
        syncStatus: Value(_edited(i.syncStatus)),
        updatedAt: Value(now),
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      await (_db.update(
        _db.wallets,
      )..where((w) => w.id.equals(i.walletId))).write(
        WalletsCompanion(
          name: Value(name.trim()),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(now),
        ),
      );
    }
  }

  /// Stop tracking it. Refused while it still holds units or value: sell
  /// first, or the money would vanish from net worth.
  Future<void> delete(String investmentId) async {
    final i = await find(investmentId);
    if (i == null || i.deletedAt != null) return;
    final wallet = await _db.findWalletById(i.walletId);
    if ((wallet?.balance ?? 0) != 0 || await unitsHeld(i.walletId) > 0) {
      throw ArgumentError('${i.name} still holds units. Sell them first.');
    }
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(
        _db.investments,
      )..where((x) => x.id.equals(i.id))).write(
        InvestmentsCompanion(
          deletedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(now),
        ),
      );
      await (_db.update(
        _db.wallets,
      )..where((w) => w.id.equals(i.walletId))).write(
        WalletsCompanion(
          isArchived: const Value(true),
          syncStatus: const Value(SyncStatus.pendingUpdate),
          updatedAt: Value(now),
        ),
      );
    });
  }

  // ------------------------------------------------------------ internals

  Future<Investment> _live(String id) async {
    final i = await find(id);
    if (i == null || i.deletedAt != null) {
      throw ArgumentError('That investment no longer exists.');
    }
    return i;
  }

  Future<void> _setPrice(Investment i, int price, DateTime when) async {
    if (price <= 0) return;
    await (_db.update(_db.investments)..where((x) => x.id.equals(i.id))).write(
      InvestmentsCompanion(
        price: Value(price),
        priceDate: Value(when),
        syncStatus: Value(_edited(i.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _tag(
    String id, {
    double? units,
    String? key,
    String? planId,
    int? number,
  }) async {
    final row = await _db.findTransactionById(id);
    if (row == null) return;
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        units: units == null ? const Value.absent() : Value(units),
        occurrenceKey: key == null ? const Value.absent() : Value(key),
        planId: planId == null ? const Value.absent() : Value(planId),
        planInstallment: number == null ? const Value.absent() : Value(number),
        syncStatus: Value(_edited(row.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> _keyTaken(String key) async =>
      await (_db.select(
        _db.transactions,
      )..where((t) => t.occurrenceKey.equals(key))).getSingleOrNull() !=
      null;

  static String _units(double u) =>
      u == u.roundToDouble() ? u.toStringAsFixed(0) : u.toString();

  static String? _blankToNull(String? s) =>
      s == null || s.trim().isEmpty ? null : s.trim();

  static int _edited(int status) =>
      status == SyncStatus.pendingCreate ? status : SyncStatus.pendingUpdate;

  static DateTime _notAfterNow(DateTime d) {
    final now = DateTime.now();
    return d.isAfter(now) ? now : d;
  }
}
