import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/transactions/services/transfer_service.dart';
import 'package:the_accountant/features/wallets/services/wallet_maintenance_service.dart';

/// What sort of thing is owned.
///
/// Kept in the asset wallet's `iconName` under [key], so it syncs with the
/// wallet and needs no table of its own. The keys are fixed: other features
/// read them (Zakat counts what is filed under 'gold'), so renaming one would
/// quietly change what they count.
enum AssetKind {
  land,

  /// A flat or a house.
  home,

  /// A car, motorbike or other vehicle.
  car,

  /// Gold and jewellery.
  gold,
  other;

  String get key => name;

  /// The kind stored on [wallet], or null when it is not an asset at all. An
  /// asset whose icon is not one of the keys, made by a newer build or edited
  /// on another device, reads as [other] rather than disappearing.
  static AssetKind? of(Wallet wallet) {
    if (wallet.walletType != WalletType.asset) return null;
    return values.where((k) => k.key == wallet.iconName).firstOrNull ?? other;
  }

  /// A kind from loose text, as the coach or a form gives it.
  static AssetKind parse(String? text) => switch (text?.trim().toLowerCase()) {
    'land' || 'plot' => land,
    'home' || 'house' || 'flat' || 'apartment' => home,
    'car' || 'vehicle' || 'bike' || 'motorbike' => car,
    'gold' || 'jewellery' || 'jewelry' => gold,
    _ => other,
  };
}

/// One thing owned, and where it stands.
class AssetHolding {
  const AssetHolding({
    required this.wallet,
    required this.kind,
    required this.cost,
    required this.received,
  });

  final Wallet wallet;
  final AssetKind kind;

  /// What it cost: the value it was first added at, plus any money moved
  /// into it from an account.
  final int cost;

  /// Money it brought back when sold.
  final int received;

  String get id => wallet.id;
  String get name => wallet.name;
  String get currency => wallet.currency;

  /// What it is worth now.
  int get value => wallet.balance;

  /// Sold, or otherwise closed.
  bool get isClosed => wallet.isArchived;

  /// Up or down since it was bought: what it is worth and what came back
  /// against what it cost.
  int get change => value + received - cost;

  /// [change] as a percentage of [cost], or null when it cost nothing known.
  double? get changePercent => cost == 0 ? null : change / cost * 100;
}

/// Land, a home, a car, gold and anything else owned and valued by hand.
///
/// An asset is a wallet of type [WalletType.asset], so it syncs, backs up and
/// counts toward net worth like any account. Its balance is what it is worth.
/// Buying one is a transfer in from the account that paid, so the money does
/// not vanish from net worth on the day it is spent; a new value is a balance
/// correction, so a rise in the price of land never reads as income; and
/// selling is a transfer out for what it fetched.
///
/// No Riverpod here, so the coach and tests drive it directly.
class AssetService {
  AssetService(this._db)
    : _transfers = TransferService(_db),
      _maintenance = WalletMaintenanceService(_db);

  final AppDatabase _db;
  final TransferService _transfers;
  final WalletMaintenanceService _maintenance;
  static const _uuid = Uuid();

  // ------------------------------------------------------------ reading

  /// Every asset, the ones still owned first and each group oldest first.
  Future<List<AssetHolding>> all() async {
    final wallets =
        await (_db.select(_db.wallets)
              ..where(
                (w) =>
                    w.walletType.equalsValue(WalletType.asset) &
                    w.deletedAt.isNull(),
              )
              ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
            .get();
    final holdings = [for (final w in wallets) await _holdingOf(w)];
    return [
      ...holdings.where((h) => !h.isClosed),
      ...holdings.where((h) => h.isClosed),
    ];
  }

  Future<AssetHolding?> find(String walletId) async {
    final w = await _db.findWalletById(walletId);
    if (w == null || w.deletedAt != null || AssetKind.of(w) == null) {
      return null;
    }
    return _holdingOf(w);
  }

  Future<AssetHolding> _holdingOf(Wallet w) async {
    final rows = await (_db.select(
      _db.transactions,
    )..where((t) => t.walletId.equals(w.id) & t.deletedAt.isNull())).get();
    var cost = w.openingBalance;
    var received = 0;
    for (final r in rows) {
      if (TransactionPolicy.kindOf(r) != TransactionType.transfer) continue;
      if (r.isIncome) {
        cost += r.amount;
      } else {
        received += r.amount;
      }
    }
    return AssetHolding(
      wallet: w,
      kind: AssetKind.of(w)!,
      cost: cost,
      received: received,
    );
  }

  // ----------------------------------------------------------- creating

  /// Start tracking something owned, worth [value] now. Returns its wallet id.
  ///
  /// With [paidFromWalletId], it was bought: [paid] (or [value] when not
  /// given) moves from that account into the asset, and if it is worth
  /// something other than what was paid the difference is a value update.
  /// Without it, it was already owned, so [value] is simply where it starts
  /// and no money moves.
  Future<String> create({
    required String name,
    required AssetKind kind,
    required String currency,
    required int value,
    String? paidFromWalletId,
    int? paid,
    bool useDecimals = true,
    DateTime? date,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('Give the asset a name.');
    if (trimmed.length > 100) {
      throw ArgumentError('Keep the name under 100 characters.');
    }
    if (value < 0) throw ArgumentError('A value cannot be negative.');
    final taken = (await all()).where(
      (a) => !a.isClosed && a.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (taken.isNotEmpty) throw ArgumentError('$trimmed is already tracked.');

    final bought = paidFromWalletId != null;
    final cost = paid ?? value;
    if (bought) {
      if (cost <= 0) throw ArgumentError('Enter what was paid for it.');
      final from = await _db.findWalletById(paidFromWalletId);
      if (from == null || from.isArchived || from.walletType.isManaged) {
        throw ArgumentError('Pay for it from an ordinary account.');
      }
    } else if (value == 0) {
      throw ArgumentError('Enter what it is worth.');
    }

    final id = _uuid.v4();
    final now = DateTime.now();
    final when = _notAfterNow(date ?? now);
    await _db.addWallet(
      WalletsCompanion(
        id: Value(id),
        name: Value(trimmed),
        currency: Value(currency),
        iconName: Value(kind.key),
        color: Value(_colorOf(kind)),
        walletType: const Value(WalletType.asset),
        useDecimals: Value(useDecimals),
        // Already owned: it is simply worth this from the start. Bought: it
        // starts empty and the purchase fills it.
        balance: Value(bought ? 0 : value),
        openingBalance: Value(bought ? 0 : value),
        orderIndex: const Value(9999),
        syncStatus: const Value(SyncStatus.pendingCreate),
        // Dated to when it was had, so the net worth history shows it from
        // then and not from the day it was typed in.
        createdAt: Value(bought ? now : when),
        updatedAt: Value(now),
      ),
    );
    if (bought) {
      await _transfers.createTransfer(
        sourceWalletId: paidFromWalletId,
        destinationWalletId: id,
        amount: cost,
        date: when,
        title: '$trimmed: bought',
      );
      await _correct(id, trimmed, value, when);
    }
    return id;
  }

  // ------------------------------------------------------------ changing

  /// What it is worth now. Recorded as a value update, never as income or
  /// spending: land rising in price has not put money in anyone's pocket.
  Future<void> revalue(String walletId, int newValue, {DateTime? date}) async {
    final a = await _live(walletId);
    if (newValue < 0) throw ArgumentError('A value cannot be negative.');
    await _correct(
      a.id,
      a.name,
      newValue,
      _notAfterNow(date ?? DateTime.now()),
    );
  }

  /// Sold for [amount], received into [toWalletId]. The asset is closed.
  ///
  /// It is first valued at what it fetched, so the sale moves exactly that
  /// out and the gain or loss shows as the last value update. Whatever is
  /// left after the transfer (a rounding across currencies) is cleared, so a
  /// sold asset never leaves a sliver behind in net worth.
  Future<void> sell(
    String walletId, {
    required String toWalletId,
    required int amount,
    DateTime? date,
  }) async {
    final a = await _live(walletId);
    if (amount <= 0) throw ArgumentError('Enter what it was sold for.');
    final to = await _db.findWalletById(toWalletId);
    if (to == null || to.isArchived || to.walletType.isManaged) {
      throw ArgumentError('Receive the money into an ordinary account.');
    }
    final when = _notAfterNow(date ?? DateTime.now());
    await _correct(a.id, a.name, amount, when);
    await _transfers.createTransfer(
      sourceWalletId: a.id,
      destinationWalletId: toWalletId,
      amount: amount,
      date: when,
      title: '${a.name}: sold',
    );
    await _correct(a.id, a.name, 0, when);
    await _archive(a.id);
  }

  /// Stop tracking it. Refused while it is worth something: that value would
  /// vanish from net worth with nothing to say where it went. Sell it, or
  /// set its value to nothing first. The wallet is archived rather than
  /// deleted, so the history of buying and selling it stays.
  Future<void> delete(String walletId) async {
    final a = await find(walletId);
    if (a == null) return;
    if (a.value != 0) {
      throw ArgumentError(
        '${a.name} is still worth something. Sell it, or set its value to '
        'zero, first.',
      );
    }
    if (!a.isClosed) await _archive(a.id);
  }

  Future<void> rename(String walletId, String name) async {
    final a = await _live(walletId);
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('Give the asset a name.');
    await (_db.update(_db.wallets)..where((w) => w.id.equals(a.id))).write(
      WalletsCompanion(
        name: Value(trimmed),
        syncStatus: Value(_edited(a.wallet.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ------------------------------------------------------------ internals

  Future<AssetHolding> _live(String walletId) async {
    final a = await find(walletId);
    if (a == null || a.isClosed) {
      throw ArgumentError('That asset is no longer tracked.');
    }
    return a;
  }

  Future<void> _correct(
    String walletId,
    String name,
    int value,
    DateTime when,
  ) => _maintenance.correctBalance(
    walletId: walletId,
    actualBalance: value,
    date: when,
    title: '$name: value update',
    notes: 'Valued by hand.',
  );

  Future<void> _archive(String walletId) async {
    final w = (await _db.findWalletById(walletId))!;
    await (_db.update(_db.wallets)..where((x) => x.id.equals(walletId))).write(
      WalletsCompanion(
        isArchived: const Value(true),
        syncStatus: Value(_edited(w.syncStatus)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  static String _colorOf(AssetKind kind) => switch (kind) {
    AssetKind.land => '#65A30D',
    AssetKind.home => '#0EA5E9',
    AssetKind.car => '#64748B',
    AssetKind.gold => '#CA8A04',
    AssetKind.other => '#A855F7',
  };

  static int _edited(int status) =>
      status == SyncStatus.pendingCreate ? status : SyncStatus.pendingUpdate;

  static DateTime _notAfterNow(DateTime d) {
    final now = DateTime.now();
    return d.isAfter(now) ? now : d;
  }
}
