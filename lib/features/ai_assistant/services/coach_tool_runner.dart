import 'dart:convert';

import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat;
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    show transactionProvider;
import 'package:the_accountant/features/wallets/domain/credit_card_position.dart';
import 'package:the_accountant/core/domain/default_wallet.dart';

enum CoachActionKind { add, update, delete }

/// A change the coach wants to make, as the user is shown it before it happens.
class CoachActionPreview {
  final CoachActionKind kind;
  final String title;
  final int amount;
  final String currency;
  final bool isIncome;
  final String? category;
  final String? account;
  final DateTime date;
  final String? notes;

  /// For an update: each field that changes, from and to, already formatted.
  final Map<String, (String, String)> changes;

  const CoachActionPreview({
    required this.kind,
    required this.title,
    required this.amount,
    required this.currency,
    required this.isIncome,
    required this.date,
    this.category,
    this.account,
    this.notes,
    this.changes = const {},
  });
}

/// A write the coach asked for: either something to show and then do, or
/// why it cannot be done.
class CoachPlan {
  final CoachActionPreview? preview;
  final Future<String> Function()? execute;
  final String? error;

  const CoachPlan.ready(CoachActionPreview this.preview, this.execute)
    : error = null;

  const CoachPlan.failed(String this.error) : preview = null, execute = null;
}

/// Runs the money coach's tools against the data on this phone.
///
/// The coach lives on the server but the transactions live here, and for
/// anyone without Premium only here, so every tool is answered by the app.
/// Reads answer straight away. Writes are planned first: the user sees exactly
/// what will change and confirms it, and only then does [CoachPlan.execute]
/// run, through the same notifier the add and edit screens use, so balances,
/// sync and Recently deleted behave exactly as if the user had done it by hand.
///
/// Every answer is JSON. Amounts are in normal units of their own currency
/// (250.5, not cents), dates are yyyy-MM-dd, and names are the user's own.
class CoachToolRunner {
  CoachToolRunner(this._read);

  final ProviderReader _read;

  static const writes = {
    'add_transaction',
    'update_transaction',
    'delete_transaction',
  };

  static const _maxResults = 50;

  bool isWrite(CoachToolCall call) => writes.contains(call.name);

  /// Every account, read fresh for each call so a change the coach just made
  /// is already reflected.
  List<Wallet> _allWallets = const [];

  Future<void> _load() async =>
      _allWallets = await _read(databaseProvider).getAllWallets();

  /// Answers a read-only tool.
  Future<String> read(CoachToolCall call) async {
    try {
      await _load();
      return switch (call.name) {
        'search_transactions' => await _search(call.args),
        'summarize' => await _summarize(call.args),
        'list_accounts' => await _accounts(),
        'list_categories' => _categories(call.args),
        _ => _error('There is no tool called ${call.name}.'),
      };
    } on _ToolError catch (e) {
      return _error(e.message);
    } catch (e) {
      return _error('The app could not run ${call.name}: $e');
    }
  }

  /// Works out what a write would do, without doing it.
  Future<CoachPlan> plan(CoachToolCall call) async {
    try {
      await _load();
      return switch (call.name) {
        'add_transaction' => _planAdd(call.args),
        'update_transaction' => await _planUpdate(call.args),
        'delete_transaction' => await _planDelete(call.args),
        _ => CoachPlan.failed(_error('There is no tool called ${call.name}.')),
      };
    } on _ToolError catch (e) {
      return CoachPlan.failed(_error(e.message));
    }
  }

  static String cancelled() =>
      jsonEncode({'status': 'cancelled', 'note': 'The user said no.'});

  // ------------------------------------------------------------------ reads

  Future<String> _search(Map<String, dynamic> args) async {
    final from = _date(args['from']);
    final to = _date(args['to']);
    final kind = (args['kind'] as String?)?.toLowerCase() ?? 'any';
    final categoryId = args['category'] == null
        ? null
        : _category(args['category'] as String).id;
    final walletId = args['account'] == null
        ? null
        : _wallet(args['account'] as String).id;
    final min = _amount(args['min_amount']);
    final max = _amount(args['max_amount']);
    final limit = ((args['limit'] as num?)?.toInt() ?? 25).clamp(
      1,
      _maxResults,
    );
    final tokens = _tokens(args['query'] as String?);

    final names = _categoryNames();
    final wallets = _wallets();
    final rows = (await _read(databaseProvider).getAllTransactions()).where((
      t,
    ) {
      if (from != null && t.date.isBefore(from)) return false;
      if (to != null && !t.date.isBefore(_endOf(to))) return false;
      if (kind != 'any' && _kindOf(t) != kind) return false;
      if (categoryId != null &&
          t.categoryId != categoryId &&
          _parentOf(t.categoryId) != categoryId) {
        return false;
      }
      if (walletId != null && t.walletId != walletId) return false;
      if (min != null && t.amount < min) return false;
      if (max != null && t.amount > max) return false;
      if (tokens.isEmpty) return true;
      final haystack = [
        t.title,
        t.notes ?? '',
        names[t.categoryId] ?? '',
        wallets[t.walletId]?.name ?? '',
        (t.amount / 100).toStringAsFixed(2),
        (t.amount / 100).round().toString(),
      ].join(' ').toLowerCase();
      return tokens.every(haystack.contains);
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    final currency = _read(defaultCurrencyProvider);
    var spent = 0.0;
    var earned = 0.0;
    for (final t in rows) {
      final value = await _toMain(t.amount, wallets[t.walletId], currency);
      if (TransactionPolicy.countsAsExpense(t)) spent += value;
      if (TransactionPolicy.countsAsIncome(t)) earned += value;
    }

    return jsonEncode({
      'matched': rows.length,
      'shown': rows.length < limit ? rows.length : limit,
      'currency': currency,
      'total_spent': _round(spent),
      'total_earned': _round(earned),
      'note':
          'Totals are in $currency and leave out transfers, balance '
          'corrections and loans.',
      'transactions': [
        for (final t in rows.take(limit)) _describe(t, names, wallets),
      ],
    });
  }

  Future<String> _summarize(Map<String, dynamic> args) async {
    final from = _date(args['from']) ?? (throw _ToolError('from is required.'));
    final to = _date(args['to']) ?? (throw _ToolError('to is required.'));
    final by = (args['by'] as String?)?.toLowerCase() ?? 'category';
    final kind = (args['kind'] as String?)?.toLowerCase();

    final names = _categoryNames();
    final wallets = _wallets();
    final currency = _read(defaultCurrencyProvider);
    final groups = <String, ({double spent, double earned, int count})>{};
    var spent = 0.0;
    var earned = 0.0;

    final rows = (await _read(databaseProvider).getAllTransactions()).where(
      (t) =>
          !t.date.isBefore(from) &&
          t.date.isBefore(_endOf(to)) &&
          TransactionPolicy.countsInAnalytics(t),
    );

    for (final t in rows) {
      final isExpense = TransactionPolicy.countsAsExpense(t);
      final isIncome = TransactionPolicy.countsAsIncome(t);
      if (kind == 'expense' && !isExpense) continue;
      if (kind == 'income' && !isIncome) continue;

      final value = await _toMain(t.amount, wallets[t.walletId], currency);
      final key = switch (by) {
        'account' => wallets[t.walletId]?.name ?? 'Unknown account',
        'month' => _date8(t.date).substring(0, 7),
        'day' => _date8(t.date),
        _ =>
          names[_parentOf(t.categoryId) ?? t.categoryId] ??
              names[t.categoryId] ??
              'Uncategorised',
      };
      final g = groups[key] ?? (spent: 0.0, earned: 0.0, count: 0);
      groups[key] = (
        spent: g.spent + (isExpense ? value : 0),
        earned: g.earned + (isIncome ? value : 0),
        count: g.count + 1,
      );
      if (isExpense) spent += value;
      if (isIncome) earned += value;
    }

    final ordered = groups.entries.toList()
      ..sort(
        (a, b) => by == 'month' || by == 'day'
            ? a.key.compareTo(b.key)
            : (b.value.spent + b.value.earned).compareTo(
                a.value.spent + a.value.earned,
              ),
      );

    return jsonEncode({
      'from': _date8(from),
      'to': _date8(to),
      'currency': currency,
      'total_spent': _round(spent),
      'total_earned': _round(earned),
      'groups': [
        for (final e in ordered.take(60))
          {
            'name': e.key,
            'spent': _round(e.value.spent),
            'earned': _round(e.value.earned),
            'count': e.value.count,
          },
      ],
    });
  }

  Future<String> _accounts() async {
    final wallets = _allWallets;
    return jsonEncode({
      'accounts': [
        for (final w in wallets)
          {
            'name': w.name,
            'type': switch (w.walletType) {
              WalletType.cash => 'cash',
              WalletType.bankAccount => 'bank_account',
              WalletType.creditCard => 'credit_card',
              WalletType.subscription => 'subscription',
            },
            'currency': w.currency,
            'balance': (w.balance) / 100,
            if (w.walletType == WalletType.creditCard) ...{
              'owed':
                  CreditCardPosition.of(
                    balance: w.balance,
                    limit: w.creditLimit ?? 0,
                  ).owed /
                  100,
              if (w.creditLimit != null) 'limit': w.creditLimit! / 100,
            },
            if (w.isArchived) 'archived': true,
            if (w.isDefault) 'default': true,
          },
      ],
    });
  }

  String _categories(Map<String, dynamic> args) {
    final kind = (args['kind'] as String?)?.toLowerCase();
    final all = _selectableCategories();
    return jsonEncode({
      'categories': [
        for (final c in all)
          if (kind == null || c.type == kind)
            {
              'name': c.name,
              'kind': c.type,
              if (c.mainCategoryId != null)
                'inside': all
                    .where((p) => p.id == c.mainCategoryId)
                    .firstOrNull
                    ?.name,
            },
      ],
    });
  }

  // ----------------------------------------------------------------- writes

  CoachPlan _planAdd(Map<String, dynamic> args) {
    final amount =
        _amount(args['amount']) ??
        (throw _ToolError('amount is required and must be above 0.'));
    if (amount <= 0) throw _ToolError('amount must be above 0.');
    final isIncome = (args['kind'] as String?)?.toLowerCase() == 'income';
    final title = (args['title'] as String?)?.trim() ?? '';
    final category = args['category'] is String
        ? _category(args['category'] as String, kind: _kindName(isIncome))
        : _guessCategory(title, isIncome);
    final wallet = args['account'] is String
        ? _wallet(args['account'] as String)
        : _defaultWallet();
    final day = _date(args['date']);
    final now = DateTime.now();
    final when = day == null || _sameDay(day, now)
        ? now
        : DateTime(day.year, day.month, day.day, 12);
    final notes = (args['notes'] as String?)?.trim();

    final preview = CoachActionPreview(
      kind: CoachActionKind.add,
      title: title.isEmpty ? category.name : title,
      amount: amount,
      currency: wallet.currency,
      isIncome: isIncome,
      category: category.name,
      account: wallet.name,
      date: when,
      notes: notes == null || notes.isEmpty ? null : notes,
    );

    return CoachPlan.ready(preview, () async {
      final id = await _read(transactionProvider.notifier).addTransactionFull(
        amount: amount,
        isIncome: isIncome,
        categoryId: category.id,
        walletId: wallet.id,
        dateTime: when,
        title: title.isEmpty ? null : title,
        notes: preview.notes,
      );
      return id == null
          ? _error('The app could not save it.')
          : jsonEncode({'status': 'done', 'id': id});
    });
  }

  Future<CoachPlan> _planUpdate(Map<String, dynamic> args) async {
    final row = await _existing(args['id']);
    final wallets = _wallets();
    final names = _categoryNames();
    final wallet = wallets[row.walletId];

    final isIncome = args['kind'] is String
        ? (args['kind'] as String).toLowerCase() == 'income'
        : row.isIncome;
    final amount = args.containsKey('amount') ? _amount(args['amount']) : null;
    if (amount != null && amount <= 0) {
      throw _ToolError('amount must be above 0.');
    }
    final title = (args['title'] as String?)?.trim();
    final category = args['category'] is String
        ? _category(args['category'] as String, kind: _kindName(isIncome))
        : null;
    final newWallet = args['account'] is String
        ? _wallet(args['account'] as String)
        : null;
    final day = _date(args['date']);
    final date = day == null
        ? null
        : DateTime(
            day.year,
            day.month,
            day.day,
            row.date.hour,
            row.date.minute,
          );
    final notes = (args['notes'] as String?)?.trim();

    final currency = wallet?.currency ?? '';
    final changes = <String, (String, String)>{
      if (amount != null && amount != row.amount)
        'amount': (_money(row.amount, currency), _money(amount, currency)),
      if (isIncome != row.isIncome)
        'kind': (_kindName(row.isIncome), _kindName(isIncome)),
      if (title != null && title != row.title) 'title': (row.title, title),
      if (category != null && category.id != row.categoryId)
        'category': (names[row.categoryId] ?? '', category.name),
      if (newWallet != null && newWallet.id != row.walletId)
        'account': (wallet?.name ?? '', newWallet.name),
      if (date != null && !_sameDay(date, row.date))
        'date': (_date8(row.date), _date8(date)),
      if (notes != null && notes != (row.notes ?? ''))
        'notes': (row.notes ?? '', notes),
    };
    if (changes.isEmpty) {
      throw _ToolError(
        'Nothing would change; the transaction already says that.',
      );
    }

    final preview = CoachActionPreview(
      kind: CoachActionKind.update,
      title: row.title.isEmpty ? (names[row.categoryId] ?? '') : row.title,
      amount: row.amount,
      currency: currency,
      isIncome: row.isIncome,
      category: names[row.categoryId],
      account: wallet?.name,
      date: row.date,
      changes: changes,
    );

    return CoachPlan.ready(preview, () async {
      await _read(transactionProvider.notifier).updateTransaction(
        id: row.id,
        amount: amount,
        isIncome: isIncome != row.isIncome ? isIncome : null,
        title: title,
        categoryId: category?.id,
        walletId: newWallet?.id,
        date: date,
        notes: notes,
      );
      return jsonEncode({'status': 'done', 'id': row.id});
    });
  }

  Future<CoachPlan> _planDelete(Map<String, dynamic> args) async {
    final row = await _existing(args['id']);
    final wallet = _wallets()[row.walletId];
    final names = _categoryNames();

    final preview = CoachActionPreview(
      kind: CoachActionKind.delete,
      title: row.title.isEmpty ? (names[row.categoryId] ?? '') : row.title,
      amount: row.amount,
      currency: wallet?.currency ?? '',
      isIncome: row.isIncome,
      category: names[row.categoryId],
      account: wallet?.name,
      date: row.date,
    );

    return CoachPlan.ready(preview, () async {
      await _read(transactionProvider.notifier).deleteTransaction(row.id);
      return jsonEncode({
        'status': 'done',
        'note': 'Moved to Recently deleted; it can be restored for 30 days.',
      });
    });
  }

  // ---------------------------------------------------------------- helpers

  Future<Transaction> _existing(Object? id) async {
    if (id is! String || id.isEmpty) {
      throw _ToolError('id is required; find it with search_transactions.');
    }
    final row = await _read(databaseProvider).findTransactionById(id);
    if (row == null || row.deletedAt != null) {
      throw _ToolError(
        'No transaction has id $id. Search again and use an id from the results.',
      );
    }
    if (TransactionPolicy.isTransfer(row)) {
      throw _ToolError(
        'That is one side of a transfer between accounts. Transfers can only '
        'be changed in the app, so both sides stay matched.',
      );
    }
    if (TransactionPolicy.isCreditOrDebt(row) ||
        TransactionPolicy.isSettlement(row)) {
      throw _ToolError(
        'That is a loan or a loan repayment. Change it from Lend & borrow so '
        'what is owed stays right.',
      );
    }
    return row;
  }

  Map<String, Object?> _describe(
    Transaction t,
    Map<String, String> names,
    Map<String, Wallet> wallets,
  ) => {
    'id': t.id,
    'date': _date8(t.date),
    'title': t.title,
    'amount': t.amount / 100,
    'currency': wallets[t.walletId]?.currency,
    'kind': _kindOf(t),
    'category': names[t.categoryId],
    'account': wallets[t.walletId]?.name,
    if ((t.notes ?? '').isNotEmpty) 'notes': t.notes,
    if (TransactionPolicy.isAdjustment(t)) 'is': 'balance correction',
    if (TransactionPolicy.isCreditOrDebt(t)) 'is': 'loan',
    if (TransactionPolicy.isSettlement(t)) 'is': 'loan repayment',
    if (!t.isPaid) 'paid': false,
  };

  String _kindOf(Transaction t) => TransactionPolicy.isTransfer(t)
      ? 'transfer'
      : (t.isIncome ? 'income' : 'expense');

  static String _kindName(bool isIncome) => isIncome ? 'income' : 'expense';

  List<cat.Category> _selectableCategories() =>
      _read(cat.categoryProvider).selectable.where((c) => !c.isSystem).toList();

  Map<String, String> _categoryNames() => {
    for (final c in _read(cat.categoryProvider).categories) c.id: c.name,
  };

  String? _parentOf(String? categoryId) => _read(
    cat.categoryProvider,
  ).categories.where((c) => c.id == categoryId).firstOrNull?.mainCategoryId;

  Map<String, Wallet> _wallets() => {for (final w in _allWallets) w.id: w};

  List<Wallet> get _selectableWallets =>
      _allWallets.where((w) => !w.isArchived).toList();

  cat.Category _category(String name, {String? kind}) {
    final options = _selectableCategories()
        .where((c) => kind == null || c.type == kind)
        .toList();
    final match = _byName(options, name, (c) => c.name);
    if (match != null) return match;
    throw _ToolError(
      'No ${kind ?? ''} category is called "$name". The categories are: '
      '${options.map((c) => c.name).take(40).join(', ')}.',
    );
  }

  cat.Category _guessCategory(String title, bool isIncome) {
    final options = _selectableCategories()
        .where((c) => c.type == _kindName(isIncome))
        .toList();
    if (options.isEmpty) {
      throw _ToolError('There are no ${_kindName(isIncome)} categories yet.');
    }
    final words = _tokens(title);
    for (final c in options) {
      final name = c.name.toLowerCase();
      if (words.any((w) => w.length > 2 && name.contains(w))) return c;
    }
    const fallbacks = ['other', 'others', 'miscellaneous', 'misc', 'general'];
    return options.firstWhere(
      (c) => fallbacks.contains(c.name.toLowerCase()),
      orElse: () => options.first,
    );
  }

  Wallet _wallet(String name) {
    final options = _selectableWallets;
    final match = _byName(options, name, (w) => w.name);
    if (match != null) return match;
    throw _ToolError(
      'No account is called "$name". The accounts are: '
      '${options.map((w) => w.name).join(', ')}.',
    );
  }

  Wallet _defaultWallet() =>
      resolveDefaultWallet(_selectableWallets) ??
      (throw _ToolError('There is no account to add it to.'));

  /// Exact name first, then one that contains it; never a guess between several.
  static T? _byName<T>(List<T> items, String name, String Function(T) nameOf) {
    final wanted = name.trim().toLowerCase();
    final exact = items.where((i) => nameOf(i).toLowerCase() == wanted);
    if (exact.isNotEmpty) return exact.first;
    final partial = items
        .where((i) => nameOf(i).toLowerCase().contains(wanted))
        .toList();
    return partial.length == 1 ? partial.first : null;
  }

  Future<double> _toMain(int cents, Wallet? wallet, String currency) async {
    final from = wallet?.currency ?? currency;
    if (from == currency) return cents / 100;
    try {
      return await _read(
        currencyServiceProvider,
      ).convert(cents / 100, from, currency);
    } catch (_) {
      return cents / 100;
    }
  }

  static List<String> _tokens(String? text) => (text ?? '')
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();

  static int? _amount(Object? value) => switch (value) {
    num n => (n * 100).round(),
    String s => double.tryParse(
      s.replaceAll(',', ''),
    )?.let((d) => (d * 100).round()),
    _ => null,
  };

  static DateTime? _date(Object? value) {
    if (value is! String || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw _ToolError('Dates must be yyyy-MM-dd; "$value" is not one.');
    }
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static DateTime _endOf(DateTime day) =>
      DateTime(day.year, day.month, day.day + 1);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _date8(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  static String _money(int cents, String currency) =>
      '${(cents / 100).toStringAsFixed(2)} $currency'.trim();

  static double _round(double v) => (v * 100).round() / 100;

  static String _error(String message) =>
      jsonEncode({'status': 'error', 'error': message});
}

class _ToolError implements Exception {
  final String message;
  _ToolError(this.message);
}

extension<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
