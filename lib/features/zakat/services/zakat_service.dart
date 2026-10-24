import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';

/// The kinds of line a zakat calculation is made of, in the order they are
/// shown.
enum ZakatGroup {
  /// Cash and ordinary bank or mobile accounts in credit.
  cash,

  /// DPS, FDR and bond holdings.
  deposits,

  /// Funds, shares and other holdings, at their latest value.
  investments,

  /// Gold and silver, at what the user valued them.
  metals,

  /// Money lent that has not come back yet.
  lent,

  /// Land, a home, a car: owned, but not zakatable unless held for trade, so
  /// listed switched off.
  otherAssets,

  /// Zakat already paid this year. It left the accounts above after the
  /// wealth it was due on was counted, so it is added back; otherwise every
  /// payment would shrink what was due and the part left would never reach
  /// zero.
  paid,

  /// Added by hand.
  manual,

  /// Money borrowed and not yet repaid.
  borrowed,

  /// What is owed on credit cards.
  cards;

  bool get isDeduction => this == borrowed || this == cards;
}

/// One amount in the calculation.
class ZakatLine {
  const ZakatLine({
    required this.key,
    required this.group,
    required this.name,
    required this.amount,
    required this.original,
    required this.currency,
    required this.included,
    required this.includedByDefault,
    this.deduct = false,
  });

  /// Stable across visits, so the user's switch stays with the line.
  final String key;
  final ZakatGroup group;

  /// The account's, person's or item's name.
  final String name;

  /// In the user's own currency, always positive.
  final int amount;

  /// The same amount in the currency it is held in.
  final int original;
  final String currency;

  final bool included;
  final bool includedByDefault;

  /// Comes off the wealth: a debt, a card balance, or a manual deduction.
  final bool deduct;
}

/// Where the user's zakat stands.
class ZakatReport {
  const ZakatReport({
    required this.currency,
    required this.settings,
    required this.lines,
    required this.paid,
    required this.yearStart,
    required this.nextDate,
    this.zakatCategoryId,
  });

  /// The user's own currency, which every figure here is in.
  final String currency;
  final ZakatSettings settings;
  final List<ZakatLine> lines;

  /// Zakat paid since [yearStart].
  final int paid;

  /// The start of the zakat year payments count toward.
  final DateTime yearStart;

  /// The next zakat date, or null when none is set.
  final DateTime? nextDate;

  final String? zakatCategoryId;

  /// The rate zakat is due at, in thousandths: 2.5%.
  static const int ratePerMille = 25;

  NisabBasis get basis => settings.basis;
  int get pricePerGram => settings.pricePerGram;

  /// Null until a price per gram is entered.
  int? get nisab => settings.nisab;

  Iterable<ZakatLine> get _included => lines.where((l) => l.included);

  /// Everything zakatable that is switched on.
  int get wealth =>
      _included.where((l) => !l.deduct).fold(0, (sum, l) => sum + l.amount);

  /// Debts due now that are switched on.
  int get deductions =>
      _included.where((l) => l.deduct).fold(0, (sum, l) => sum + l.amount);

  int get net => wealth - deductions;

  /// Whether the net wealth reaches the nisab; null until it can be known.
  bool? get meetsNisab => nisab == null ? null : net > 0 && net >= nisab!;

  /// How far below the nisab the net wealth is; zero when it is not.
  int get shortfall => meetsNisab == false ? nisab! - (net < 0 ? 0 : net) : 0;

  /// 2.5% of the net wealth, whether or not it reaches the nisab.
  int get rateOfNet => net <= 0 ? 0 : (net * ratePerMille / 1000).round();

  /// Zakat due this year: nothing below the nisab, or before it is known.
  int get due => meetsNisab == true ? rateOfNet : 0;

  /// What is still to pay.
  int get left => due > paid ? due - paid : 0;

  /// Days until [nextDate], or null when no date is set.
  int? daysUntilDue(DateTime today) {
    final next = nextDate;
    if (next == null) return null;
    return DateTime.utc(
      next.year,
      next.month,
      next.day,
    ).difference(DateTime.utc(today.year, today.month, today.day)).inDays;
  }

  List<ZakatLine> of(ZakatGroup group) =>
      lines.where((l) => l.group == group).toList();
}

/// Zakat on what the app knows the user has, and the payments toward it.
///
/// Reads the stored balances rather than adding transactions up, so it
/// agrees with every account screen. Other currencies are converted into the
/// user's own the way the home total is.
///
/// No Riverpod here, so the coach and the tests run exactly what the screen
/// runs.
class ZakatService {
  ZakatService(this._db, [this._currency])
    : _balances = WalletBalanceService(_db);

  final AppDatabase _db;
  final CurrencyService? _currency;
  final WalletBalanceService _balances;
  static const _uuid = Uuid();

  /// The icon the asset form gives gold and silver; the only assets counted
  /// without being switched on.
  static const metalIcon = 'gold';

  /// Work out the zakat for [settings], with every figure in [currency].
  Future<ZakatReport> compute(
    ZakatSettings settings, {
    required String currency,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final lines = <ZakatLine>[];

    Future<void> add({
      required String key,
      required ZakatGroup group,
      required String name,
      required int amount,
      required String from,
      bool byDefault = true,
      bool deduct = false,
    }) async {
      if (amount <= 0) return;
      lines.add(
        ZakatLine(
          key: key,
          group: group,
          name: name,
          amount: await _convert(amount, from, currency),
          original: amount,
          currency: from,
          included: settings.switches[key] ?? byDefault,
          includedByDefault: byDefault,
          deduct: deduct,
        ),
      );
    }

    final wallets = await _db.getAllWallets();
    final walletCurrency = {for (final w in wallets) w.id: w.currency};
    for (final w in wallets) {
      // A closed account holds nothing, and one left out of the total is a
      // balance the user has said is not theirs.
      if (w.isArchived || w.excludeFromTotal || w.deletedAt != null) continue;
      final key = 'w:${w.id}';
      switch (w.walletType) {
        case WalletType.cash ||
            WalletType.bankAccount ||
            WalletType.subscription:
          await add(
            key: key,
            group: ZakatGroup.cash,
            name: w.name,
            amount: w.balance,
            from: w.currency,
          );
        case WalletType.deposit:
          await add(
            key: key,
            group: ZakatGroup.deposits,
            name: w.name,
            amount: w.balance,
            from: w.currency,
          );
        case WalletType.investment:
          await add(
            key: key,
            group: ZakatGroup.investments,
            name: w.name,
            amount: w.balance,
            from: w.currency,
          );
        case WalletType.asset:
          final metal = w.iconName == metalIcon;
          await add(
            key: key,
            group: metal ? ZakatGroup.metals : ZakatGroup.otherAssets,
            name: w.name,
            amount: w.balance,
            from: w.currency,
            byDefault: metal,
          );
        case WalletType.creditCard:
          // Only a card in debt is owed; one paid ahead is not a debt, and
          // not counted as cash either, since it can only be spent on.
          await add(
            key: key,
            group: ZakatGroup.cards,
            name: w.name,
            amount: -w.balance,
            from: w.currency,
            deduct: true,
          );
      }
    }

    for (final t in await _db.getCreditDebtTransactions()) {
      final lent = TransactionPolicy.isCredit(t);
      await add(
        key: 'l:${t.id}',
        group: lent ? ZakatGroup.lent : ZakatGroup.borrowed,
        name: t.title,
        amount: TransactionPolicy.outstandingAmount(t),
        from: walletCurrency[t.walletId] ?? currency,
        deduct: !lent,
      );
    }

    final start = ZakatCalendar.yearStart(settings.zakatDate, today);
    final category = await _db.findCategoryByDefaultKey(
      BuiltInCategoryKeys.zakat,
    );
    var paid = 0;
    if (category != null) {
      for (final t in await _paymentsSince(category.id, start)) {
        paid += await _convert(
          t.amount,
          walletCurrency[t.walletId] ?? currency,
          currency,
        );
      }
    }
    if (paid > 0) {
      lines.add(
        ZakatLine(
          key: 'paid',
          group: ZakatGroup.paid,
          name: 'paid',
          amount: paid,
          original: paid,
          currency: currency,
          included: settings.switches['paid'] ?? true,
          includedByDefault: true,
        ),
      );
    }

    for (final m in settings.manual) {
      if (m.amount <= 0) continue;
      final key = 'm:${m.id}';
      lines.add(
        ZakatLine(
          key: key,
          group: ZakatGroup.manual,
          name: m.label,
          amount: m.amount,
          original: m.amount,
          currency: currency,
          included: settings.switches[key] ?? true,
          includedByDefault: true,
          deduct: m.deduct,
        ),
      );
    }

    lines.sort((a, b) => a.group.index.compareTo(b.group.index));
    return ZakatReport(
      currency: currency,
      settings: settings,
      lines: lines,
      paid: paid,
      yearStart: start,
      nextDate: ZakatCalendar.nextDate(settings.zakatDate, today),
      zakatCategoryId: category?.id,
    );
  }

  /// Zakat paid on or after [start], as recorded under the Zakat category.
  Future<List<Transaction>> _paymentsSince(
    String categoryId,
    DateTime start,
  ) async {
    final rows =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.categoryId.equals(categoryId) &
                  t.deletedAt.isNull() &
                  t.date.isBiggerOrEqualValue(start),
            ))
            .get();
    return rows.where(TransactionPolicy.countsAsExpense).toList();
  }

  /// Record [amount] of zakat paid from [walletId], as an expense under the
  /// Zakat category. Returns the new transaction's id.
  ///
  /// [amount] is in the account's own currency.
  Future<String> pay({
    required String walletId,
    required int amount,
    DateTime? date,
    String title = 'Zakat',
    String? notes,
  }) async {
    if (amount <= 0) throw ArgumentError('Enter the amount paid.');
    final wallet = await _db.findWalletById(walletId);
    if (wallet == null ||
        wallet.isArchived ||
        wallet.deletedAt != null ||
        wallet.walletType.isManaged) {
      throw ArgumentError('Pay it from an ordinary account.');
    }
    final now = DateTime.now();
    final when = date == null || date.isAfter(now) ? now : date;
    final id = _uuid.v4();
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(id),
        amount: Value(amount),
        isIncome: const Value(false),
        title: Value(title.trim().isEmpty ? 'Zakat' : title.trim()),
        notes: Value(notes == null || notes.trim().isEmpty ? null : notes),
        date: Value(when),
        walletId: Value(walletId),
        categoryId: Value(
          await _db.requireSystemCategoryId(BuiltInCategoryKeys.zakat),
        ),
        transactionType: Value(TransactionPolicy.regularType),
        isPaid: const Value(true),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await _balances.updateWalletBalance(walletId);
    return id;
  }

  Future<int> _convert(int amount, String from, String to) async {
    final service = _currency;
    if (service == null || from.toUpperCase() == to.toUpperCase()) {
      return amount;
    }
    final converted = await service.convert(amount / 100.0, from, to);
    return (converted * 100).round();
  }
}
