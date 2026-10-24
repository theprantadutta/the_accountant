import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;

/// The lines net worth is made of, in the order the screen shows them.
enum NetWorthPart {
  /// Cash, bank and mobile accounts, and subscription pots.
  cash,

  /// Credit cards: what is owed, so usually negative. Only when the user
  /// counts cards.
  cards,

  /// DPS, FDR and bonds.
  deposits,
  investments,

  /// Land, a home, a car, gold.
  assets,

  /// Money lent to others and not yet repaid.
  lent,

  /// Money borrowed and not yet repaid, as a negative figure.
  borrowed;

  static NetWorthPart ofWallet(WalletType type) => switch (type) {
    WalletType.creditCard => cards,
    WalletType.deposit => deposits,
    WalletType.investment => investments,
    WalletType.asset => assets,
    WalletType.cash ||
    WalletType.bankAccount ||
    WalletType.subscription => cash,
  };
}

/// What the user is worth now, in [currency] minor units, and what it is
/// made of.
class NetWorthSummary {
  const NetWorthSummary({
    required this.currency,
    required this.parts,
    required this.includesCards,
  });

  final String currency;

  /// Each line's signed amount. Every part is present, zero when empty.
  final Map<NetWorthPart, int> parts;

  /// Whether credit cards were counted; see [FinancialCalculationService.countsInNetWorth].
  final bool includesCards;

  int get total => parts.values.fold(0, (s, v) => s + v);

  /// Accounts alone, before money lent and borrowed: what the home card used
  /// to show.
  int get accounts =>
      total -
      (parts[NetWorthPart.lent] ?? 0) -
      (parts[NetWorthPart.borrowed] ?? 0);

  int operator [](NetWorthPart part) => parts[part] ?? 0;
}

/// Net worth at the end of one month.
class NetWorthPoint {
  const NetWorthPoint(this.month, this.value);

  /// The first day of the month this is the end of.
  final DateTime month;
  final int value;
}

/// What the user is worth: everything they have, less everything they owe.
///
/// ## The definition
///
/// Every account that [FinancialCalculationService.countsInNetWorth] counts —
/// cash and bank, savings deposits, investments and assets, and credit cards
/// when the user has said to count them — at its balance, plus money lent to
/// others that is still owed back, less money borrowed that is still owed.
///
/// The loans are what change the figure from the old home card, which added
/// up account balances alone. Lending a friend 5,000 takes 5,000 out of the
/// wallet the moment it is recorded (see [TransactionPolicy.affectsWalletBalance]),
/// so balances alone made the user 5,000 poorer for lending it, and then
/// richer again as it came back. The money is still theirs; it is just with
/// someone else. Borrowing was the mirror: the money borrowed sat in a wallet
/// and read as wealth. Counting what is outstanding puts both right, and a
/// loan and its repayment no longer move net worth at all, as they should not.
/// A loan counts when the account it went through counts, so a loan made from
/// an account the user leaves out stays out with it.
///
/// Everything is converted into the user's currency at today's rate, the
/// same conversion the home card has always used, including for the history:
/// a past month valued at that month's rates would move with the exchange
/// rate rather than with anything the user did.
///
/// ## The history
///
/// Net worth at each month end is rebuilt from the records rather than kept:
/// each account's opening balance plus the effect of every row dated before
/// the month ended (the same [TransactionPolicy.walletBalanceEffect] the stored
/// balances are made of), plus each loan's outstanding amount on that date. An
/// account's opening balance counts from when it was opened, or from its
/// first row if that is earlier, so an account added in March does not
/// appear in January. An archived account counts in the months it was open
/// but not today, which is what archiving means; it is normally empty by
/// then, so the line does not jump.
class NetWorthService {
  NetWorthService(this._db, [this._currency]);

  final AppDatabase _db;
  final CurrencyService? _currency;

  /// What the user is worth now.
  Future<NetWorthSummary> summary(
    String currency, {
    required bool includeCreditCards,
  }) async {
    final rates = _Rates(_currency, currency);
    final wallets = await _db.getAllWallets();
    final counted = {
      for (final w in wallets)
        if (FinancialCalculationService.countsInNetWorth(
          w,
          includeCreditCards: includeCreditCards,
        ))
          w.id: w,
    };
    final parts = {for (final p in NetWorthPart.values) p: 0};
    for (final w in counted.values) {
      final part = NetWorthPart.ofWallet(w.walletType);
      parts[part] = parts[part]! + await rates.convert(w.balance, w.currency);
    }
    for (final loan in await _db.getCreditDebtTransactions()) {
      final w = counted[loan.walletId];
      if (w == null) continue;
      final owed = await rates.convert(
        TransactionPolicy.outstandingAmount(loan),
        w.currency,
      );
      if (TransactionPolicy.isCredit(loan)) {
        parts[NetWorthPart.lent] = parts[NetWorthPart.lent]! + owed;
      } else {
        parts[NetWorthPart.borrowed] = parts[NetWorthPart.borrowed]! - owed;
      }
    }
    return NetWorthSummary(
      currency: currency,
      parts: parts,
      includesCards: includeCreditCards,
    );
  }

  /// Net worth at the end of each month, oldest first, ending with this
  /// month (whose point is [summary]'s total, so the line ends where the
  /// screen's figure is). [months] is how many to go back; null goes back to
  /// the first month anything was recorded.
  Future<List<NetWorthPoint>> history(
    String currency, {
    required bool includeCreditCards,
    int? months,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final thisMonth = DateTime(today.year, today.month);
    final rates = _Rates(_currency, currency);

    // Archived accounts stay in: they were open in the months being drawn.
    // Excluded ones and, unless counted, cards are left out of every month.
    final wallets = {
      for (final w in await _db.getAllWallets())
        if (FinancialCalculationService.countsInNetWorth(
          w.copyWith(isArchived: false),
          includeCreditCards: includeCreditCards,
        ))
          w.id: w,
    };
    final rows = (await _db.getAllTransactions())
        .where((t) => wallets.containsKey(t.walletId))
        .toList();

    // When each account starts to count.
    final opened = <String, DateTime>{
      for (final w in wallets.values) w.id: w.createdAt,
    };
    for (final t in rows) {
      final o = opened[t.walletId]!;
      if (t.date.isBefore(o)) opened[t.walletId] = t.date;
    }

    var first = thisMonth;
    if (months != null) {
      first = DateTime(thisMonth.year, thisMonth.month - (months - 1));
    } else {
      for (final o in opened.values) {
        final m = DateTime(o.year, o.month);
        if (m.isBefore(first)) first = m;
      }
    }

    // Repayments by loan, so each loan can say what it was owed on a date.
    final loans = rows.where(TransactionPolicy.isCreditOrDebt).toList();
    final repayments = <String, List<Transaction>>{};
    for (final t in rows) {
      final loanId = t.settlesTransactionId;
      if (loanId != null) (repayments[loanId] ??= []).add(t);
    }

    final points = <NetWorthPoint>[];
    for (
      var m = first;
      m.isBefore(thisMonth);
      m = DateTime(m.year, m.month + 1)
    ) {
      final end = DateTime(m.year, m.month + 1);
      var value = 0;
      final byWallet = <String, int>{};
      for (final w in wallets.values) {
        if (opened[w.id]!.isBefore(end)) byWallet[w.id] = w.openingBalance;
      }
      for (final t in rows) {
        if (!t.date.isBefore(end)) continue;
        byWallet[t.walletId] =
            (byWallet[t.walletId] ?? 0) +
            TransactionPolicy.walletBalanceEffect(t);
      }
      for (final MapEntry(key: id, value: balance) in byWallet.entries) {
        value += await rates.convert(balance, wallets[id]!.currency);
      }
      for (final loan in loans) {
        if (!loan.date.isBefore(end)) continue;
        final owed = _outstandingAt(loan, repayments[loan.id] ?? const [], end);
        final inMain = await rates.convert(
          owed,
          wallets[loan.walletId]!.currency,
        );
        value += TransactionPolicy.isCredit(loan) ? inMain : -inMain;
      }
      points.add(NetWorthPoint(m, value));
    }

    final current = await summary(
      currency,
      includeCreditCards: includeCreditCards,
    );
    points.add(NetWorthPoint(thisMonth, current.total));
    return points;
  }

  /// What was still owed on [loan] just before [end].
  ///
  /// Its repayments are the rows that settle it, each dated when the money
  /// changed hands; one in the opposite direction undoes an earlier one. Any
  /// part of the repaid amount no row accounts for (recorded by an older
  /// build) is taken as repaid from the start, so the figure for today is
  /// exactly [TransactionPolicy.outstandingAmount].
  static int _outstandingAt(
    Transaction loan,
    List<Transaction> repayments,
    DateTime end,
  ) {
    final isCredit = TransactionPolicy.isCredit(loan);
    int signed(Transaction r) => r.isIncome == isCredit ? r.amount : -r.amount;
    final linked = repayments.fold<int>(0, (s, r) => s + signed(r));
    var paid = loan.paidAmount - linked;
    for (final r in repayments) {
      if (r.date.isBefore(end)) paid += signed(r);
    }
    return (loan.amount - paid).clamp(0, loan.amount);
  }
}

/// Conversion into one currency, asking for each rate once.
class _Rates {
  _Rates(this._service, this._to);

  final CurrencyService? _service;
  final String _to;
  final _cache = <String, double>{};

  Future<int> convert(int cents, String from) async {
    if (cents == 0 || from == _to || _service == null) return cents;
    // With no rate to be had (offline, never fetched) the amount is counted
    // as it stands, as the rest of the app does, rather than as nothing.
    final rate = _cache[from] ??= await _service
        .convert(1, from, _to)
        .catchError((Object _) => 1.0);
    return (cents * rate).round();
  }
}
