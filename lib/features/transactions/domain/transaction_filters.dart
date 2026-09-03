import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    show Transaction;

/// Which side of the ledger to show.
enum DirectionFilter { any, income, expense }

/// Whether the money has moved.
enum PaidFilter { any, paid, unpaid, skipped }

/// Whether to include the two legs of wallet-to-wallet transfers.
///
/// Their own screen exists to answer "where did my money go", and a transfer
/// answers neither side of that, so they are hidden unless asked for. But they
/// are real rows the user created, and a list that can never show them makes
/// them impossible to find or correct.
enum TransferFilter { hide, show, only }

/// Everything the transaction list can be narrowed by.
///
/// Immutable, and comparable, so a screen can tell whether anything is actually
/// filtered without inspecting each field. The list previously offered a
/// direction and a single category, which is roughly a tenth of what someone
/// looking for one particular payment needs.
class TransactionFilters {
  final Set<String> walletIds;
  final Set<String> categoryIds;
  final DirectionFilter direction;
  final PaidFilter paid;
  final Set<TransactionSpecialType> specialTypes;
  final TransferFilter transfers;

  /// Inclusive bounds in cents. Null means unbounded on that side.
  final int? minAmount;
  final int? maxAmount;

  /// Inclusive date bounds. Null means unbounded on that side.
  final DateTime? from;
  final DateTime? to;

  /// Free text matched against title, notes, and category name.
  final String query;

  const TransactionFilters({
    this.walletIds = const {},
    this.categoryIds = const {},
    this.direction = DirectionFilter.any,
    this.paid = PaidFilter.any,
    this.specialTypes = const {},
    this.transfers = TransferFilter.hide,
    this.minAmount,
    this.maxAmount,
    this.from,
    this.to,
    this.query = '',
  });

  static const TransactionFilters none = TransactionFilters();

  /// Whether anything is narrowed, ignoring the search box.
  ///
  /// Search is shown in its own field, so counting it here would light up the
  /// filter button for something the user can already see.
  bool get hasActiveFilters =>
      walletIds.isNotEmpty ||
      categoryIds.isNotEmpty ||
      direction != DirectionFilter.any ||
      paid != PaidFilter.any ||
      specialTypes.isNotEmpty ||
      transfers != TransferFilter.hide ||
      minAmount != null ||
      maxAmount != null ||
      from != null ||
      to != null;

  /// How many separate narrowings are in force, for the badge on the button.
  int get activeCount => [
    walletIds.isNotEmpty,
    categoryIds.isNotEmpty,
    direction != DirectionFilter.any,
    paid != PaidFilter.any,
    specialTypes.isNotEmpty,
    transfers != TransferFilter.hide,
    minAmount != null || maxAmount != null,
    from != null || to != null,
  ].where((on) => on).length;

  TransactionFilters copyWith({
    Set<String>? walletIds,
    Set<String>? categoryIds,
    DirectionFilter? direction,
    PaidFilter? paid,
    Set<TransactionSpecialType>? specialTypes,
    TransferFilter? transfers,
    Object? minAmount = _keep,
    Object? maxAmount = _keep,
    Object? from = _keep,
    Object? to = _keep,
    String? query,
  }) {
    return TransactionFilters(
      walletIds: walletIds ?? this.walletIds,
      categoryIds: categoryIds ?? this.categoryIds,
      direction: direction ?? this.direction,
      paid: paid ?? this.paid,
      specialTypes: specialTypes ?? this.specialTypes,
      transfers: transfers ?? this.transfers,
      minAmount: identical(minAmount, _keep)
          ? this.minAmount
          : minAmount as int?,
      maxAmount: identical(maxAmount, _keep)
          ? this.maxAmount
          : maxAmount as int?,
      from: identical(from, _keep) ? this.from : from as DateTime?,
      to: identical(to, _keep) ? this.to : to as DateTime?,
      query: query ?? this.query,
    );
  }

  /// Clear everything except the search text, which has its own field.
  TransactionFilters cleared() => TransactionFilters(query: query);

  /// Whether [t] survives every narrowing.
  bool matches(Transaction t, {Set<String> Function(String)? familyOf}) {
    final isTransfer = t.isTransferLeg;
    switch (transfers) {
      case TransferFilter.hide:
        if (isTransfer) return false;
      case TransferFilter.only:
        if (!isTransfer) return false;
      case TransferFilter.show:
        break;
    }

    if (walletIds.isNotEmpty && !walletIds.contains(t.walletId)) return false;

    if (categoryIds.isNotEmpty) {
      // Choosing a parent means the things filed inside it too, matching how a
      // budget reads its own scope. Picking Food and seeing no lunches, because
      // they were filed under Sandwiches, reads as a broken filter.
      final wanted = familyOf == null
          ? categoryIds
          : {for (final id in categoryIds) ...familyOf(id)};
      if (!wanted.contains(t.categoryId)) return false;
    }

    switch (direction) {
      case DirectionFilter.income:
        if (t.type != 'income') return false;
      case DirectionFilter.expense:
        if (t.type != 'expense') return false;
      case DirectionFilter.any:
        break;
    }

    switch (paid) {
      case PaidFilter.paid:
        if (!t.isPaid || t.skipPaid) return false;
      case PaidFilter.unpaid:
        if (t.isPaid || t.skipPaid) return false;
      case PaidFilter.skipped:
        if (!t.skipPaid) return false;
      case PaidFilter.any:
        break;
    }

    if (specialTypes.isNotEmpty && !specialTypes.contains(t.specialType)) {
      return false;
    }

    if (minAmount != null && t.amount < minAmount!) return false;
    if (maxAmount != null && t.amount > maxAmount!) return false;

    if (from != null && t.date.isBefore(from!)) return false;
    // Inclusive of the whole end day: someone picking "to the 5th" means the
    // 5th, not everything before midnight that morning.
    if (to != null && t.date.isAfter(_endOfDay(to!))) return false;

    if (query.isNotEmpty && !_matchesQuery(t)) return false;

    return true;
  }

  bool _matchesQuery(Transaction t) {
    final parsed = SearchQuery.parse(query);
    if (parsed.amountCents != null) {
      // A bare number searches the amount as well as the words, because
      // "12.50" is far more likely to be a price than part of a shop's name.
      final within = (t.amount - parsed.amountCents!).abs() <= 50;
      if (within) return true;
    }
    if (parsed.month != null) {
      if (t.date.month == parsed.month &&
          (parsed.year == null || t.date.year == parsed.year)) {
        return true;
      }
    }
    final text = parsed.text;
    if (text.isEmpty) return false;
    return t.title.toLowerCase().contains(text) ||
        t.notes.toLowerCase().contains(text) ||
        t.category.toLowerCase().contains(text);
  }

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  static const Object _keep = Object();
}

/// A search box entry, read for the things people actually type into one.
///
/// Someone hunting a transaction types "37.40" or "march" far more often than
/// a substring of a shop name, and a plain `contains` finds neither. Cashew
/// reads amounts and month names the same way; this also accepts a year.
class SearchQuery {
  /// The words left after any amount or month was recognised.
  final String text;

  /// An amount in cents, when the query looks like one.
  final int? amountCents;

  /// A month number, when a month name was given.
  final int? month;

  /// A four-digit year, when one was given.
  final int? year;

  const SearchQuery({
    required this.text,
    this.amountCents,
    this.month,
    this.year,
  });

  static const List<String> _months = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  static SearchQuery parse(String raw) {
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty) return const SearchQuery(text: '');

    int? amount;
    int? month;
    int? year;
    final leftovers = <String>[];

    for (final word in trimmed.split(RegExp(r'\s+'))) {
      final asAmount = _amountOf(word);
      if (asAmount != null) {
        amount ??= asAmount;
        continue;
      }

      final asYear = int.tryParse(word);
      if (asYear != null &&
          word.length == 4 &&
          asYear > 1900 &&
          asYear < 2200) {
        year ??= asYear;
        continue;
      }

      final monthIndex = _monthOf(word);
      if (monthIndex != null) {
        month ??= monthIndex;
        continue;
      }

      leftovers.add(word);
    }

    return SearchQuery(
      text: leftovers.join(' '),
      amountCents: amount,
      month: month,
      year: year,
    );
  }

  /// A word read as money, or null.
  ///
  /// A bare integer is deliberately included: someone searching "40" usually
  /// means forty of something, and the match is fuzzy enough to allow it.
  static int? _amountOf(String word) {
    final cleaned = word.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return null;
    if (cleaned.length == 4 && !cleaned.contains('.')) {
      // Almost certainly a year; the year branch above will take it.
      return null;
    }
    final value = double.tryParse(cleaned);
    if (value == null) return null;
    return (value * 100).round();
  }

  /// A month name or its first three letters, as a 1-based month number.
  static int? _monthOf(String word) {
    if (word.length < 3) return null;
    for (var i = 0; i < _months.length; i++) {
      if (_months[i] == word ||
          _months[i].startsWith(word) && word.length >= 3) {
        return i + 1;
      }
    }
    return null;
  }
}
