import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

/// How a bill is shared out.
enum SplitMode {
  /// Everyone pays the same, to the cent.
  equal,

  /// Each share is given as an amount, and they add up to the bill.
  exact,

  /// Each share is given as a percentage, and they add up to 100.
  percent,
}

/// One person's part of a bill. A null [person] is the user.
class SplitShare {
  const SplitShare(this.person, this.amount);

  final String? person;

  /// Minor units.
  final int amount;

  bool get isMe => person == null;
}

/// A bill to be split, as the screen or the coach fills it in.
class SplitDraft {
  const SplitDraft({
    required this.title,
    required this.total,
    required this.walletId,
    required this.categoryId,
    required this.people,
    this.includeMe = true,
    this.paidBy,
    this.mode = SplitMode.equal,
    this.amounts = const {},
    this.percents = const {},
    this.date,
    this.notes,
  });

  final String title;

  /// The whole bill, in minor units.
  final int total;

  /// The account the user paid from, or will settle up from.
  final String walletId;

  /// What the bill was for. The user's own share is spending here.
  final String categoryId;

  /// Everyone else in on the bill, by name.
  final List<String> people;

  /// False when the user paid for the others only and had none of it.
  final bool includeMe;

  /// Who paid the whole bill: null for the user, or one of [people].
  final String? paidBy;

  final SplitMode mode;

  /// For [SplitMode.exact]: each share in minor units, the user's under null.
  final Map<String?, int> amounts;

  /// For [SplitMode.percent]: each share as a percentage, the user's under
  /// null.
  final Map<String?, double> percents;

  final DateTime? date;
  final String? notes;

  bool get iPaid => paidBy == null;
}

/// Splitting a bill with friends, against the database.
///
/// A split adds no new kind of record. It is written as the rows the app
/// already understands, so balances, reports, Lend & borrow, sync and
/// backups need nothing new:
///
/// * **The user paid.** Their own share is an ordinary expense in the bill's
///   category. Each other person's share is money lent to that person: a
///   `credit` row with their name as its title, exactly what Lend & borrow
///   writes, so it is listed there and settled the usual way. Every row is
///   money out of the account, so the balance drops by the whole bill, while
///   spending counts only the user's share, because lending is not spending.
/// * **Someone else paid.** The user's share is still spending, but no money
///   left their account; they owe it instead. That is written as two rows on
///   the chosen account: a `debt` to the payer for the share (money in, as
///   borrowing always is) and the expense itself (money out). In other words
///   the payer lent the user their share and the user spent it, which is
///   exactly what happened. The two cancel, so the balance does not move
///   until the user pays the payer back, and that repayment comes out of the
///   account as a settlement of the debt, which is never spending. The
///   expense is counted once, on the day of the bill. A single unpaid
///   expense would have kept the balance right too, but Lend & borrow could
///   not have shown who is owed or let the debt be settled, and an "upcoming"
///   row would have kept the spending out of reports until it was paid back.
///   What the payer's other friends owe them is between them, so only the
///   user's share is written.
///
/// The parts are kept together by their occurrence key, `split:<id>:<n>`.
/// That column already syncs, is unique per row, is never copied when a row is
/// duplicated and is not shown or edited anywhere, which makes it a link no
/// edit can break. A new column would have needed a migration on the phone and
/// the server for what a key prefix already does.
///
/// No Riverpod here, so the screen and the coach share it as it is.
class SplitService {
  SplitService(this._db) : _balances = WalletBalanceService(_db);

  final AppDatabase _db;
  final WalletBalanceService _balances;
  static const _uuid = Uuid();

  static const _keyPrefix = 'split:';

  /// The split [t] is part of, or null.
  static String? splitIdOf(Transaction t) {
    final key = t.occurrenceKey;
    if (key == null || !key.startsWith(_keyPrefix)) return null;
    final rest = key.substring(_keyPrefix.length);
    final end = rest.lastIndexOf(':');
    return end <= 0 ? null : rest.substring(0, end);
  }

  // ------------------------------------------------------------ the shares

  /// Each person's share of [d], the user's first when they are in on it.
  ///
  /// Equal shares are cut to the cent, and whatever cannot be divided evenly
  /// goes to whoever paid, so the parts always add up to the bill exactly.
  /// When the payer has no share (the user paid for the others only) the
  /// spare cents go one each to the first people instead. Percentages are
  /// rounded the same way, with the rounding left on the payer.
  ///
  /// Throws [ArgumentError] with a message to show when the bill cannot be
  /// split as asked.
  static List<SplitShare> shares(SplitDraft d) {
    if (d.total <= 0) throw ArgumentError('Enter the amount of the bill.');
    final people = _people(d.people);
    if (people.isEmpty) {
      throw ArgumentError('Add someone to split it with.');
    }
    final payer = d.paidBy == null ? null : _match(people, d.paidBy!);
    if (d.paidBy != null && payer == null) {
      throw ArgumentError('${d.paidBy!.trim()} is not in on the bill.');
    }
    if (!d.iPaid && !d.includeMe) {
      throw ArgumentError(
        'Someone else paid and you had none of it, so there is nothing to '
        'record.',
      );
    }

    final parts = <String?>[if (d.includeMe) null, ...people];
    final payerHasShare = d.iPaid ? d.includeMe : true;
    final payerIndex = d.iPaid ? (d.includeMe ? 0 : -1) : parts.indexOf(payer);

    final amounts = switch (d.mode) {
      SplitMode.equal => _equal(d.total, parts.length, payerIndex),
      SplitMode.exact => _exact(d, parts),
      SplitMode.percent => _percent(d, parts, payerHasShare ? payerIndex : -1),
    };
    return [
      for (var i = 0; i < parts.length; i++) SplitShare(parts[i], amounts[i]),
    ];
  }

  static List<int> _equal(int total, int n, int payerIndex) {
    final base = total ~/ n;
    var spare = total - base * n;
    final out = List<int>.filled(n, base);
    if (payerIndex >= 0) {
      out[payerIndex] += spare;
    } else {
      for (var i = 0; spare > 0; i++, spare--) {
        out[i] += 1;
      }
    }
    return out;
  }

  static List<int> _exact(SplitDraft d, List<String?> parts) {
    final out = <int>[];
    for (final p in parts) {
      final v = _lookup(d.amounts, p);
      if (v == null) {
        throw ArgumentError(
          p == null ? 'Give your own share.' : "Give $p's share.",
        );
      }
      if (v < 0) throw ArgumentError('A share cannot be negative.');
      out.add(v);
    }
    final sum = out.fold<int>(0, (a, b) => a + b);
    if (sum != d.total) {
      throw ArgumentError(
        'The shares add up to ${_plain(sum)}, not ${_plain(d.total)}.',
      );
    }
    return out;
  }

  static List<int> _percent(SplitDraft d, List<String?> parts, int payerIndex) {
    final pcts = <double>[];
    for (final p in parts) {
      final v = _lookup(d.percents, p) ?? 0;
      if (v < 0) throw ArgumentError('A share cannot be negative.');
      pcts.add(v);
    }
    final sum = pcts.fold<double>(0, (a, b) => a + b);
    if ((sum - 100).abs() > 0.001) {
      throw ArgumentError(
        'The percentages add up to ${_trim(sum)}%, not 100%.',
      );
    }
    final out = [for (final p in pcts) (d.total * p / 100).round()];
    final diff = d.total - out.fold<int>(0, (a, b) => a + b);
    if (diff != 0) {
      // On the payer, or else on the first person with a share at all, so a
      // part that is 0% stays at nothing.
      final i = payerIndex >= 0 && pcts[payerIndex] > 0
          ? payerIndex
          : pcts.indexWhere((p) => p > 0);
      out[i] += diff;
    }
    return out;
  }

  static T? _lookup<T>(Map<String?, T> map, String? person) {
    if (person == null) return map[null];
    for (final e in map.entries) {
      if (e.key != null && _same(e.key!, person)) return e.value;
    }
    return null;
  }

  /// Names trimmed, blanks dropped, and each person once.
  static List<String> _people(List<String> names) {
    final out = <String>[];
    for (final raw in names) {
      final name = raw.trim();
      if (name.isEmpty) continue;
      if (name.length > 100) {
        throw ArgumentError('Keep names under 100 characters.');
      }
      if (out.any((n) => _same(n, name))) {
        throw ArgumentError('$name is on the bill twice.');
      }
      out.add(name);
    }
    return out;
  }

  static String? _match(List<String> people, String name) =>
      people.where((p) => _same(p, name.trim())).firstOrNull;

  static bool _same(String a, String b) => a.toLowerCase() == b.toLowerCase();

  static String _plain(int cents) => (cents / 100).toStringAsFixed(2);

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  // ------------------------------------------------------------- reading

  /// Everyone already in Lend & borrow, most recent first, each once.
  ///
  /// Those rows carry the person's name as their title, so this is who the
  /// user has lent to or borrowed from before.
  Future<List<String>> knownPeople() async {
    final rows = [
      ...await _db.getCreditTransactions(),
      ...await _db.getDebtTransactions(),
    ]..sort((a, b) => b.date.compareTo(a.date));
    final out = <String>[];
    for (final t in rows) {
      // A plan's loan is titled after the plan, not a person.
      if (t.planId != null) continue;
      final name = t.title.trim();
      if (name.isNotEmpty && !out.any((n) => _same(n, name))) out.add(name);
    }
    return out;
  }

  /// The rows a split was written as, in the order they were made.
  Future<List<Transaction>> partsOf(String splitId) async {
    final rows =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.occurrenceKey.like('$_keyPrefix$splitId:%') &
                  t.deletedAt.isNull(),
            ))
            .get();
    int n(Transaction t) => int.tryParse(t.occurrenceKey!.split(':').last) ?? 0;
    return rows..sort((a, b) => n(a).compareTo(n(b)));
  }

  // ------------------------------------------------------------- writing

  /// Record [d]. Returns the split's id, which [partsOf] reads back.
  ///
  /// A name that differs only in case from someone already in Lend & borrow
  /// takes their spelling, so "alice" joins Alice's list instead of starting
  /// a second one.
  Future<String> record(SplitDraft d) async {
    final title = d.title.trim();
    if (title.length > 200) {
      throw ArgumentError('Keep the title under 200 characters.');
    }
    final wallet = await _db.findWalletById(d.walletId);
    if (wallet == null || wallet.deletedAt != null || wallet.isArchived) {
      throw ArgumentError('Choose the account it was paid from.');
    }
    if (wallet.walletType.isManaged) {
      throw ArgumentError('Choose an ordinary account.');
    }
    final shares = SplitService.shares(d);

    final known = await knownPeople();
    String spelled(String name) =>
        known.where((k) => _same(k, name)).firstOrNull ?? name;

    final id = _uuid.v4();
    final now = DateTime.now();
    final when = d.date ?? now;
    final notes = _blankToNull(d.notes);
    final label = title.isEmpty ? null : title;
    var n = 0;

    Future<void> write({
      required int amount,
      required bool isIncome,
      required String title,
      required String categoryId,
      required TransactionSpecialType specialType,
      String? notes,
    }) => _db.addTransaction(
      TransactionsCompanion(
        id: Value(_uuid.v4()),
        amount: Value(amount),
        isIncome: Value(isIncome),
        title: Value(title),
        notes: Value(notes),
        date: Value(when),
        walletId: Value(wallet.id),
        categoryId: Value(categoryId),
        transactionType: Value(TransactionPolicy.regularType),
        specialType: Value(specialType),
        isPaid: const Value(true),
        // A loan is due from the day it is made, as the add screen records
        // one.
        originalDueDate: Value(
          specialType == TransactionSpecialType.none ? null : when,
        ),
        occurrenceKey: Value('$_keyPrefix$id:${n++}'),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    final mine = shares.where((s) => s.isMe).firstOrNull?.amount ?? 0;
    final lentCategory = await _db.requireSystemCategoryId(
      BuiltInCategoryKeys.moneyLent,
    );
    await _db.transaction(() async {
      if (mine > 0) {
        await write(
          amount: mine,
          isIncome: false,
          title: label ?? '',
          categoryId: d.categoryId,
          specialType: TransactionSpecialType.none,
          notes: notes,
        );
      }
      if (d.iPaid) {
        for (final s in shares.where((s) => !s.isMe && s.amount > 0)) {
          await write(
            amount: s.amount,
            isIncome: false,
            title: spelled(s.person!),
            // Filed as money lent, the way Lend & borrow files it, not under
            // the meal: it is not the user's spending, and a category list
            // showing it as food would say otherwise.
            categoryId: lentCategory,
            specialType: TransactionSpecialType.credit,
            notes: label,
          );
        }
      } else if (mine > 0) {
        await write(
          amount: mine,
          isIncome: true,
          title: spelled(_match(_people(d.people), d.paidBy!)!),
          categoryId: await _db.requireSystemCategoryId(
            BuiltInCategoryKeys.moneyBorrowed,
          ),
          specialType: TransactionSpecialType.debt,
          notes: label,
        );
      } else {
        throw ArgumentError('Your share is nothing, so there is nothing owed.');
      }
      if (n == 0) throw ArgumentError('Every share is nothing.');
    });
    await _balances.updateWalletBalance(wallet.id);
    return id;
  }

  static String? _blankToNull(String? s) =>
      s == null || s.trim().isEmpty ? null : s.trim();
}
