import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType, TransactionType;
import 'package:uuid/uuid.dart';

/// Brings everything from a Cashew backup into this app.
///
/// Cashew's backup is its SQLite database file. Everything in it has a place
/// here, though several things are kept differently, and the mapping is where
/// the work is:
///
/// * A transfer in Cashew links only one leg to the other; here both point at
///   each other and are filed under the Transfer category.
/// * Cashew's balance corrections are filed under its category "0"; here they
///   go under Balance Correction, which keeps them out of income and spending.
/// * A loan Cashew marks collected or settled simply stops counting. Here a
///   loan stays on the books and its repayment is a linked row, so a settled
///   loan gets one, dated when it was last touched in Cashew.
/// * A subscription in Cashew is a chain of copies with the next one waiting
///   unpaid. Here it is a schedule: the latest payment becomes its base, the
///   earlier ones are linked to it as occurrences, and the waiting copy's
///   amount and date become the schedule's price and next payment. Cashew's
///   own auto-pay setting decides whether payments are recorded by themselves.
///
/// The import merges rather than replaces. A Cashew category with the same
/// name as one already here is filed into that one. Accounts are always added
/// as new — two accounts called "Cash" may hold different money, and merging
/// their histories would change both balances — and can be combined
/// afterwards with Merge. Every id is derived from Cashew's own, so importing
/// the same backup twice adds nothing the second time.
class CashewImportService {
  CashewImportService(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  /// Fixed so ids derived from a backup are the same on every run and device.
  static const namespace = '5b7c2a7e-6c8e-4c39-9d43-0c1a2f9e8a11';

  static final _uuidPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  );

  /// Whether [bytes] begin like an SQLite database, which a Cashew backup is.
  static bool looksLikeCashewBackup(List<int> bytes) =>
      bytes.length >= 16 &&
      ascii.decode(bytes.sublist(0, 15), allowInvalid: true) ==
          'SQLite format 3';

  /// What the backup at [path] holds, without changing anything.
  CashewBackupSummary summarize(String path) {
    final backup = _CashewBackup.open(path);
    try {
      return CashewBackupSummary(
        accounts: backup.count('wallets'),
        categories: backup.count('categories'),
        transactions: backup.count('transactions'),
        budgets: backup.count('budgets'),
        goals: backup.count('objectives'),
        titleRules: backup.count('associated_titles'),
      );
    } finally {
      backup.close();
    }
  }

  /// Import the backup at [path]. One database transaction: all or nothing.
  Future<CashewImportResult> import(String path) async {
    final backup = _CashewBackup.open(path);
    try {
      late CashewImportResult result;
      await _db.transaction(() async {
        result = await _import(backup);
        await WalletBalanceService(_db).recalculateAllWalletBalancesLocal();
      });
      return result;
    } finally {
      backup.close();
    }
  }

  // ------------------------------------------------------------------ ids

  static String _derived(String kind, String key) =>
      _uuid.v5(namespace, 'cashew:$kind:$key');

  /// Cashew's built-in rows use ids like "0" and "1"; everything else here is
  /// a UUID, and the server requires one.
  static String _keep(String kind, String pk) =>
      _uuidPattern.hasMatch(pk) ? pk : _derived(kind, pk);

  static DateTime _time(Object? seconds) =>
      DateTime.fromMillisecondsSinceEpoch((seconds as num).toInt() * 1000);

  static DateTime? _timeOrNull(Object? seconds) =>
      seconds == null ? null : _time(seconds);

  static int _cents(Object? amount) => ((amount as num).abs() * 100).round();

  static bool _flag(Object? value) => value == 1 || value == true;

  static String _color(Object? cashew, String seed) {
    if (cashew is String && cashew.length >= 6) {
      return '#${cashew.substring(cashew.length - 6).toUpperCase()}';
    }
    const palette = [
      '#EF5350', '#AB47BC', '#5C6BC0', '#29B6F6', '#26A69A', //
      '#9CCC65', '#FFCA28', '#FF7043', '#8D6E63', '#78909C',
    ];
    return palette[seed.codeUnits.fold<int>(0, (a, b) => a + b) %
        palette.length];
  }

  static String _icon(Map<String, Object?> row, String fallback) {
    final emoji = row['emoji_icon_name'];
    if (emoji is String && emoji.isNotEmpty) {
      return IconRegistry.nameForEmoji(emoji);
    }
    return cashewIcons[row['icon_name']] ?? fallback;
  }

  /// Cashew's icon images, by the nearest icon here.
  static const cashewIcons = {
    'apple.png': 'favorite', 'atm-machine(1).png': 'local_atm', //
    'atm-machine(2).png': 'local_atm', 'barber.png': 'face',
    'battery-charge.png': 'bolt', 'bill.png': 'receipt',
    'bills.png': 'receipt_long', 'briefcase.png': 'work',
    'calendar.png': 'calendar_today', 'camera.png': 'camera_alt',
    'candy.png': 'cookie', 'cash-bill-dollar.png': 'payments',
    'celebration.png': 'celebration', 'charts.png': 'show_chart',
    'chess.png': 'extension', 'church.png': 'church',
    'cleaning.png': 'cleaning_services', 'clothes-hanger.png': 'checkroom',
    'code.png': 'computer', 'coin.png': 'monetization_on',
    'color-palette.png': 'palette', 'compass.png': 'explore',
    'cookies.png': 'cookie', 'credit-card.png': 'credit_card',
    'curry.png': 'ramen_dining', 'cutlery.png': 'restaurant',
    'dental-care.png': 'health_and_safety',
    'desktop-computer.png': 'desktop_windows', 'diamond.png': 'diamond',
    'dollar-coin.png': 'attach_money', 'double-bed.png': 'bed',
    'essay.png': 'description',
    'exchange-arrows-circle.png': 'currency_exchange',
    'fast-food.png': 'fastfood', 'feathers.png': 'brush',
    'fish.png': 'set_meal', 'flower.png': 'spa',
    'fried-egg.png': 'breakfast_dining', 'fruit.png': 'local_grocery_store',
    'gas-station.png': 'local_gas_station', 'gears.png': 'settings',
    'gift.png': 'card_giftcard', 'glass-of-water.png': 'water_drop',
    'groceries.png': 'local_grocery_store', 'haircut.png': 'face',
    'headphones.png': 'headphones',
    'healthcare-and-medical.png': 'medical_services', 'heart.png': 'favorite',
    'helicopter.png': 'flight', 'home2.png': 'home', 'house(1).png': 'house',
    'image.png': 'category', 'internet-globe.png': 'language',
    'lightning-bolt.png': 'bolt', 'loan.png': 'handshake',
    'magnifying-glass.png': 'explore',
    'makeup(1).png': 'face_retouching_natural',
    'makeup.png': 'face_retouching_natural', 'money-bag.png': 'savings',
    'money.png': 'attach_money', 'multivitamin.png': 'medication',
    'open-book.png': 'menu_book', 'orange-juice.png': 'local_bar',
    'paper-ticket.png': 'local_offer', 'parents.png': 'groups',
    'pizza.png': 'local_pizza', 'plane.png': 'flight',
    'popcorn.png': 'movie', 'popsicle.png': 'icecream',
    'price-tag.png': 'sell', 'raw-meat.png': 'set_meal',
    'sandwich.png': 'lunch_dining', 'school-backpack.png': 'school',
    'settings.png': 'settings', 'shopping.png': 'shopping_bag',
    'sneakers.png': 'checkroom', 'socket.png': 'power',
    'spaghetti.png': 'dinner_dining', 'sticky-notes.png': 'sticky_note_2',
    'tea.png': 'local_cafe', 'theatre.png': 'theaters',
    'toiletries.png': 'spa', 'tram.png': 'tram', 'trash.png': 'remove_circle',
    'tshirt.png': 'checkroom', 'user.png': 'person',
    'vision.png': 'visibility', 'water-bottle.png': 'water_drop',
    'wifi.png': 'wifi',
  };

  /// Cashew's special types, which run one behind the ones here.
  static TransactionSpecialType _special(Object? cashewType) =>
      switch (cashewType) {
        0 => TransactionSpecialType.upcoming,
        1 => TransactionSpecialType.subscription,
        2 => TransactionSpecialType.repetitive,
        3 => TransactionSpecialType.credit,
        4 => TransactionSpecialType.debt,
        _ => TransactionSpecialType.none,
      };

  static String _cadence(Object? reoccurrence) => switch (reoccurrence) {
    1 => 'daily',
    2 => 'weekly',
    4 => 'yearly',
    _ => 'monthly',
  };

  // --------------------------------------------------------------- import

  Future<CashewImportResult> _import(_CashewBackup backup) async {
    final now = DateTime.now();
    var added = 0;

    // insertOrIgnore, so a row already here — from an earlier import of the
    // same backup — is left as the user has it since, and is not counted.
    Future<void> insert<T extends Table, D>(
      TableInfo<T, D> table,
      Insertable<D> row,
    ) async {
      final written = await _db
          .into(table)
          .insertReturningOrNull(row, mode: InsertMode.insertOrIgnore);
      if (written != null) added++;
    }

    final settings = backup.settings();
    await _db.ensureSystemCategoriesExist();
    final transferCategory = await _db.requireSystemCategoryId(
      SystemCategoryKeys.transfer,
    );
    final correctionCategory = await _db.requireSystemCategoryId(
      SystemCategoryKeys.balanceCorrection,
    );

    // ---- categories: into an existing one of the same name where there is
    final existing = await _db.getAllCategories();
    String key(String name, bool income, String? parent) =>
        '${name.trim().toLowerCase()}|$income|${parent ?? ''}';
    final byName = {
      for (final c in existing)
        if (!SystemCategoryKeys.all.contains(c.defaultKey))
          key(c.name, c.isIncome, c.mainCategoryId): c.id,
    };

    final categoryIds = <String, String>{'0': correctionCategory};
    final cashewCategories = backup.rows(
      'categories',
      orderBy: 'main_category_pk IS NOT NULL, "order"',
    );
    for (final row in cashewCategories) {
      final pk = '${row['category_pk']}';
      if (pk == '0') continue;
      final parentPk = row['main_category_pk'] as String?;
      final parent = parentPk == null ? null : categoryIds[parentPk];
      final name = '${row['name']}';
      final income = _flag(row['income']);
      final match = byName[key(name, income, parent)];
      if (match != null) {
        categoryIds[pk] = match;
        continue;
      }
      final id = _keep('category', pk);
      categoryIds[pk] = id;
      byName[key(name, income, parent)] = id;
      await insert(
        _db.categories,
        CategoriesCompanion.insert(
          id: id,
          name: name,
          iconName: Value(_icon(row, 'category')),
          color: Value(_color(row['colour'], name)),
          mainCategoryId: Value(parent),
          isIncome: Value(income),
          orderIndex: Value((row['order'] as num?)?.toInt() ?? 0),
          isArchived: Value(_flag(row['archived'])),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(_time(row['date_created'])),
          updatedAt: Value(
            _time(row['date_time_modified'] ?? row['date_created']),
          ),
        ),
      );
    }

    // ---- accounts
    final walletIds = <String, String>{};
    final walletCurrency = <String, String>{};
    for (final row in backup.rows('wallets', orderBy: '"order"')) {
      final pk = '${row['wallet_pk']}';
      final id = _keep('wallet', pk);
      final name = '${row['name']}';
      walletIds[pk] = id;
      walletCurrency[pk] = '${row['currency'] ?? 'usd'}'.toUpperCase();
      await insert(
        _db.wallets,
        WalletsCompanion.insert(
          id: id,
          name: name,
          iconName: Value(_icon(row, 'account_balance_wallet')),
          color: Value(_color(row['colour'], name)),
          currency: Value(walletCurrency[pk]!),
          useDecimals: Value(((row['decimals'] as num?) ?? 2) > 0),
          orderIndex: Value((row['order'] as num?)?.toInt() ?? 0),
          isArchived: Value(_flag(row['archived'])),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(_time(row['date_created'])),
          updatedAt: Value(
            _time(row['date_time_modified'] ?? row['date_created']),
          ),
        ),
      );
    }

    // ---- transactions
    final rows = backup.rows('transactions', orderBy: 'date_created');
    String txId(String pk) => _keep('transaction', pk);

    // Cashew links one leg of a transfer to the other; make it mutual.
    final partner = <String, String>{};
    for (final row in rows) {
      final other = row['paired_transaction_fk'] as String?;
      if (other == null) continue;
      partner[row['transaction_pk'] as String] = other;
      partner[other] = row['transaction_pk'] as String;
    }

    // Subscriptions: a series of copies, the next one waiting unpaid.
    String seriesOf(Map<String, Object?> r) => [
      r['name'],
      r['wallet_fk'],
      r['category_fk'],
      r['sub_category_fk'],
      r['type'],
      r['income'],
    ].join('|');
    final series = <String, List<Map<String, Object?>>>{};
    for (final row in rows) {
      if (row['type'] == 1 || row['type'] == 2) {
        series.putIfAbsent(seriesOf(row), () => []).add(row);
      }
    }

    final dropped = <String>{};
    final occurrenceOf = <String, (String configId, bool isBase)>{};
    final schedules = <RecurringConfigsCompanion>[];
    for (final MapEntry(key: seriesKey, value: members) in series.entries) {
      final waiting = members.where((m) => !_flag(m['paid'])).toList();
      final paid = members.where((m) => _flag(m['paid'])).toList();
      if (waiting.isEmpty || paid.isEmpty) continue;
      final next = waiting.reduce(
        (a, b) =>
            (a['date_created'] as num) <= (b['date_created'] as num) ? a : b,
      );
      final base = paid.reduce(
        (a, b) =>
            (a['date_created'] as num) >= (b['date_created'] as num) ? a : b,
      );
      final configId = _derived('recurring', seriesKey);
      final price = _cents(next['amount']);
      final autoPay = next['type'] == 1
          ? settings['automaticallyPaySubscriptions'] != false
          : settings['automaticallyPayRepetitive'] != false;
      schedules.add(
        RecurringConfigsCompanion.insert(
          id: configId,
          baseTransactionId: txId(base['transaction_pk'] as String),
          periodLength: Value((next['period_length'] as num?)?.toInt() ?? 1),
          reoccurrence: Value(_cadence(next['reoccurrence'])),
          startDate: _time(base['date_created']),
          endDate: Value(_timeOrNull(next['end_date'])),
          nextOccurrence: _time(next['date_created']),
          amount: Value(price == _cents(base['amount']) ? null : price),
          autoPay: Value(autoPay),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(_time(base['date_created'])),
          updatedAt: Value(now),
        ),
      );
      for (final w in waiting) {
        dropped.add(w['transaction_pk'] as String);
      }
      for (final p in paid) {
        occurrenceOf[p['transaction_pk'] as String] = (configId, p == base);
      }
    }

    var transactions = 0;
    for (final row in rows) {
      final pk = row['transaction_pk'] as String;
      if (dropped.contains(pk)) continue;
      final walletId = walletIds[row['wallet_fk']];
      if (walletId == null) continue;

      final special = _special(row['type']);
      final isLoan =
          special == TransactionSpecialType.credit ||
          special == TransactionSpecialType.debt;
      final paid = _flag(row['paid']);
      final isTransfer = partner.containsKey(pk);
      final (configId, isBase) = occurrenceOf[pk] ?? (null, false);
      final isOccurrence = configId != null && !isBase;
      final date = _time(row['date_created']);
      final amount = _cents(row['amount']);

      final String? categoryId;
      if (row['category_fk'] == '0') {
        categoryId = isTransfer ? transferCategory : correctionCategory;
      } else {
        categoryId =
            categoryIds[row['sub_category_fk']] ??
            categoryIds[row['category_fk']];
      }

      final kind = isTransfer
          ? TransactionType.transfer
          : isOccurrence
          ? TransactionType.recurringInstance
          : TransactionType.regular;
      final note = '${row['note'] ?? ''}'.trim();
      final transaction = TransactionsCompanion.insert(
        id: txId(pk),
        amount: amount,
        title: Value('${row['name'] ?? ''}'),
        notes: Value(note.isEmpty ? null : note),
        date: date,
        isIncome: Value(_flag(row['income'])),
        type: Value(_flag(row['income']) ? 'income' : 'expense'),
        transactionType: Value(kind.storageValue),
        categoryId: Value(categoryId),
        walletId: walletId,
        pairedTransactionId: Value(isTransfer ? txId(partner[pk]!) : null),
        recurringConfigId: Value(isOccurrence ? configId : null),
        occurrenceKey: Value(
          isOccurrence ? _occurrenceKey(configId, date) : null,
        ),
        objectiveId: Value(
          (row['objective_loan_fk'] ?? row['objective_fk']) as String?,
        ),
        isRecurring: Value(isBase),
        specialType: Value(special),
        // A loan's principal has moved however Cashew marks it; whether it
        // was paid back is the repaid amount, below.
        isPaid: Value(isLoan || paid),
        skipPaid: Value(
          special == TransactionSpecialType.upcoming &&
              !paid &&
              _flag(row['skip_paid']),
        ),
        originalDueDate: Value(
          isLoan || special == TransactionSpecialType.upcoming ? date : null,
        ),
        paidAmount: Value(isLoan && !paid ? amount : 0),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(date),
        updatedAt: Value(
          _time(row['date_time_modified'] ?? row['date_created']),
        ),
      );
      final before = added;
      await insert(_db.transactions, transaction);
      if (added > before) transactions++;

      // A loan Cashew calls collected or settled: the money came back.
      if (isLoan && !paid) {
        final isCredit = special == TransactionSpecialType.credit;
        final title = '${row['name'] ?? ''}';
        var settledAt = _time(row['date_time_modified'] ?? row['date_created']);
        if (settledAt.isBefore(date)) settledAt = date;
        await insert(
          _db.transactions,
          TransactionsCompanion.insert(
            id: _derived('repayment', pk),
            amount: amount,
            title: Value(
              title.isEmpty
                  ? (isCredit ? 'Received' : 'Paid')
                  : '${isCredit ? 'Received' : 'Paid'}: $title',
            ),
            notes: Value(
              'Settlement for ${isCredit ? 'credit' : 'debt'}: $title',
            ),
            date: settledAt,
            isIncome: Value(isCredit),
            type: Value(isCredit ? 'income' : 'expense'),
            categoryId: Value(categoryId),
            walletId: walletId,
            settlesTransactionId: Value(txId(pk)),
            objectiveId: Value(
              (row['objective_loan_fk'] ?? row['objective_fk']) as String?,
            ),
            isPaid: const Value(true),
            syncStatus: const Value(SyncStatus.pendingCreate),
            createdAt: Value(settledAt),
            updatedAt: Value(settledAt),
          ),
        );
      }
    }

    // Schedules after their base transactions exist.
    for (final schedule in schedules) {
      await insert(_db.recurringConfigs, schedule);
    }

    // ---- goals and loans
    for (final row in backup.rows('objectives')) {
      final id = row['objective_pk'] as String;
      final linked = rows.where(
        (r) => r['objective_loan_fk'] == id || r['objective_fk'] == id,
      );
      final inflow = linked
          .where((r) => _flag(r['income']))
          .fold<int>(0, (s, r) => s + _cents(r['amount']));
      final outflow = linked
          .where((r) => !_flag(r['income']))
          .fold<int>(0, (s, r) => s + _cents(r['amount']));
      final target = _cents(row['amount'] ?? 0);
      final name = '${row['name']}';
      await insert(
        _db.objectives,
        ObjectivesCompanion.insert(
          id: id,
          name: name,
          iconName: Value(_icon(row, 'flag')),
          color: Value(_color(row['colour'], name)),
          targetAmount: target > 0
              ? target
              : (inflow > outflow ? inflow : outflow),
          type: Value(row['type'] == 1 ? 'loan' : 'goal'),
          walletId: Value(walletIds[row['wallet_fk']]),
          startDate: _time(row['date_created']),
          endDate: Value(_timeOrNull(row['end_date'])),
          isPinned: Value(_flag(row['pinned'])),
          isArchived: Value(_flag(row['archived'])),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(_time(row['date_created'])),
          updatedAt: Value(
            _time(row['date_time_modified'] ?? row['date_created']),
          ),
        ),
      );
    }

    // ---- budgets
    for (final row in backup.rows('budgets')) {
      List<String> idsIn(Object? json, Map<String, String> map) {
        if (json is! String || json.isEmpty) return const [];
        return [
          for (final pk in (jsonDecode(json) as List))
            if (map['$pk'] != null) map['$pk']!,
        ];
      }

      final repeats = (row['reoccurrence'] as num?)?.toInt();
      final period = repeats == null || repeats == 0
          ? 'custom'
          : _cadence(repeats);
      await insert(
        _db.budgets,
        BudgetsCompanion.insert(
          id: row['budget_pk'] as String,
          name: '${row['name']}',
          amount: _cents(row['amount']),
          currency: Value(walletCurrency[row['wallet_fk']]),
          period: Value(period),
          periodLength: Value((row['period_length'] as num?)?.toInt() ?? 1),
          startDate: _time(row['start_date']),
          endDate: Value(
            period == 'custom' ? _timeOrNull(row['end_date']) : null,
          ),
          walletIds: Value(jsonEncode(idsIn(row['wallet_fks'], walletIds))),
          categoryIds: Value(
            jsonEncode(idsIn(row['category_fks'], categoryIds)),
          ),
          isIncome: Value(_flag(row['income'])),
          isPinned: Value(_flag(row['pinned'])),
          isArchived: Value(_flag(row['archived'])),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(_time(row['date_created'])),
          updatedAt: Value(
            _time(row['date_time_modified'] ?? row['date_created']),
          ),
        ),
      );
    }

    // ---- title rules
    for (final row in backup.rows('associated_titles')) {
      if (_flag(row['archived'])) continue;
      final categoryId = categoryIds[row['category_fk']];
      if (categoryId == null) continue;
      await insert(
        _db.associatedTitles,
        AssociatedTitlesCompanion.insert(
          id: row['associated_title_pk'] as String,
          title: '${row['title']}',
          categoryId: categoryId,
          isExactMatch: Value(_flag(row['is_exact_match'])),
          syncStatus: const Value(SyncStatus.pendingCreate),
          createdAt: Value(_time(row['date_created'])),
          updatedAt: Value(
            _time(row['date_time_modified'] ?? row['date_created']),
          ),
        ),
      );
    }

    return CashewImportResult(
      rowsAdded: added,
      transactionsAdded: transactions,
      alreadyHere: rows.length - dropped.length - transactions,
    );
  }

  static String _occurrenceKey(String configId, DateTime date) {
    final utc = date.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '$configId@${utc.year.toString().padLeft(4, '0')}-'
        '${two(utc.month)}-${two(utc.day)}';
  }
}

/// What a Cashew backup holds.
class CashewBackupSummary {
  const CashewBackupSummary({
    required this.accounts,
    required this.categories,
    required this.transactions,
    required this.budgets,
    required this.goals,
    required this.titleRules,
  });

  final int accounts;
  final int categories;
  final int transactions;
  final int budgets;
  final int goals;
  final int titleRules;
}

/// What an import actually did, so it can be reported rather than assumed.
class CashewImportResult {
  const CashewImportResult({
    required this.rowsAdded,
    required this.transactionsAdded,
    required this.alreadyHere,
  });

  /// Rows of every kind written.
  final int rowsAdded;

  /// Transactions written.
  final int transactionsAdded;

  /// Transactions skipped because they were already here — from an earlier
  /// import of the same backup.
  final int alreadyHere;
}

/// A read-only view of a Cashew database file, tolerant of older versions.
class _CashewBackup {
  _CashewBackup(this._db);

  factory _CashewBackup.open(String path) {
    if (!File(path).existsSync()) {
      throw const FormatException('The file is not there any more.');
    }
    final db = sqlite.sqlite3.open(path, mode: sqlite.OpenMode.readOnly);
    final backup = _CashewBackup(db);
    try {
      if (backup._has('transactions') && backup._has('wallets')) return backup;
    } on sqlite.SqliteException {
      // Not a database at all; said the same way below.
    }
    db.close();
    throw const FormatException('This is not a Cashew backup.');
  }

  final sqlite.Database _db;

  bool _has(String table) => _db.select(
    "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
    [table],
  ).isNotEmpty;

  int count(String table) => _has(table)
      ? (_db.select('SELECT COUNT(*) AS n FROM "$table"').first['n'] as int)
      : 0;

  /// Every row of [table] as a plain map. A column an older Cashew did not
  /// have simply reads as null.
  List<Map<String, Object?>> rows(String table, {String? orderBy}) {
    if (!_has(table)) return const [];
    final order = orderBy == null ? '' : ' ORDER BY $orderBy';
    return [
      for (final row in _db.select('SELECT * FROM "$table"$order'))
        {for (final column in row.keys) column: row[column]},
    ];
  }

  /// Cashew's settings, which say whether it paid scheduled items itself.
  Map<String, Object?> settings() {
    if (!_has('app_settings')) return const {};
    final rows = _db.select('SELECT settings_j_s_o_n FROM app_settings');
    if (rows.isEmpty) return const {};
    try {
      return (jsonDecode(rows.first['settings_j_s_o_n'] as String) as Map)
          .cast<String, Object?>();
    } on FormatException {
      return const {};
    }
  }

  void close() => _db.close();
}
