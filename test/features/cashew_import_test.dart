import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/import/services/cashew_import_service.dart';
import 'package:uuid/uuid.dart';

import '../helpers/test_database.dart';

/// Importing a Cashew backup.
///
/// Built against a small Cashew database written here with the columns Cashew
/// uses, holding one of each thing that has to be translated: a transfer
/// Cashew links from one side only, a balance correction, a settled loan, a
/// subscription whose next payment costs more than the last, an emoji, an
/// archived category, and a category that already exists here.
void main() {
  late Directory dir;
  late String path;
  late AppDatabase db;

  int at(int year, int month, int day) =>
      DateTime(year, month, day, 12).millisecondsSinceEpoch ~/ 1000;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('cashew_import');
    path = '${dir.path}/cashew.sql';
    final cashew = sqlite.sqlite3.open(path);
    cashew.execute('''
      CREATE TABLE wallets (wallet_pk TEXT PRIMARY KEY, name TEXT, colour TEXT,
        icon_name TEXT, emoji_icon_name TEXT, date_created INT,
        date_time_modified INT, "order" INT, currency TEXT, decimals INT,
        archived INT);
      CREATE TABLE categories (category_pk TEXT PRIMARY KEY, name TEXT,
        colour TEXT, icon_name TEXT, emoji_icon_name TEXT, date_created INT,
        date_time_modified INT, "order" INT, income INT,
        main_category_pk TEXT, archived INT);
      CREATE TABLE transactions (transaction_pk TEXT PRIMARY KEY,
        paired_transaction_fk TEXT, name TEXT, amount REAL, note TEXT,
        category_fk TEXT, sub_category_fk TEXT, wallet_fk TEXT,
        date_created INT, date_time_modified INT, income INT,
        period_length INT, reoccurrence INT, end_date INT, type INT, paid INT,
        skip_paid INT, objective_fk TEXT, objective_loan_fk TEXT);
      CREATE TABLE app_settings (settings_pk INT, settings_j_s_o_n TEXT,
        date_updated INT);
    ''');
    cashew.execute(
      "INSERT INTO app_settings VALUES (1, "
      "'{\"automaticallyPaySubscriptions\": false}', 0)",
    );
    for (final w in [
      ['0', 'Bank', 'bdt', 0],
      ['b3442544-25d9-43ae-9763-4c122344930c', 'Cash', 'bdt', 1],
    ]) {
      cashew.execute(
        'INSERT INTO wallets VALUES (?, ?, NULL, NULL, NULL, ?, ?, ?, ?, 2, 0)',
        [w[0], w[1], at(2025, 1, 1), at(2025, 1, 1), w[3], w[2]],
      );
    }
    for (final c in [
      ['0', 'Balance Correction', 'charts.png', null, 0, 0],
      ['1', 'Groceries', 'groceries.png', null, 0, 0],
      ['c-fair', 'Mela', null, '🎡', 0, 1],
      ['c-lent', 'Lent to Sam', 'user.png', null, 0, 0],
      ['c-dev', 'Developer Cost', 'gears.png', null, 0, 0],
    ]) {
      cashew.execute(
        "INSERT INTO categories VALUES (?, ?, '0xff4caf50', ?, ?, ?, ?, 0, ?, "
        'NULL, ?)',
        [c[0], c[1], c[2], c[3], at(2025, 1, 1), at(2025, 1, 1), c[4], c[5]],
      );
    }
    void tx(
      String pk,
      String name,
      double amount,
      String category,
      String wallet,
      int date, {
      String? pairedWith,
      int? type,
      int paid = 1,
      int? modified,
    }) => cashew.execute(
      "INSERT INTO transactions VALUES (?, ?, ?, ?, '', ?, NULL, ?, ?, ?, ?, "
      '1, 3, NULL, ?, ?, 0, NULL, NULL)',
      [
        pk, pairedWith, name, amount, category, wallet, date,
        modified ?? date, amount > 0 ? 1 : 0, type, paid, //
      ],
    );
    const cash = 'b3442544-25d9-43ae-9763-4c122344930c';
    tx('t-open', 'Opening', 50000, '0', '0', at(2025, 1, 1));
    tx('t-food', 'Market', -1200, '1', cash, at(2025, 2, 1));
    tx('t-out', 'To cash', -3000, '0', '0', at(2025, 2, 2), pairedWith: 't-in');
    tx('t-in', 'From bank', 3000, '0', cash, at(2025, 2, 2));
    tx(
      't-lend',
      'Lent to Sam',
      -500,
      'c-lent',
      cash,
      at(2025, 3, 1),
      type: 3,
      paid: 0,
      modified: at(2025, 4, 1),
    );
    tx('t-sub1', 'Hosting', -2400, 'c-dev', '0', at(2025, 5, 1), type: 2);
    tx('t-sub2', 'Hosting', -2400, 'c-dev', '0', at(2025, 6, 1), type: 2);
    tx(
      't-sub3',
      'Hosting',
      -2600,
      'c-dev',
      '0',
      at(2030, 7, 1),
      type: 2,
      paid: 0,
    );
    cashew.close();

    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    await seedCategory(db, name: 'Groceries');
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<Transaction> tx(String cashewPk) async =>
      (await db.findTransactionById(
        RegExp(r'^[0-9a-f-]{36}$').hasMatch(cashewPk)
            ? cashewPk
            : const Uuid().v5(
                CashewImportService.namespace,
                'cashew:transaction:$cashewPk',
              ),
      ))!;

  test('ids match the ones derived outside the app', () {
    // Pinned against Python's uuid5 over the same namespace, which produced
    // the file restored onto a real device before this import existed.
    String derived(String key) =>
        const Uuid().v5(CashewImportService.namespace, key);
    expect(derived('cashew:wallet:0'), 'f46d0166-87b2-5911-bf90-75fbc02c79c1');
    expect(
      derived('cashew:category:1'),
      '097ea2c2-89b6-52f3-93b2-ebac917a9de8',
    );
  });

  test('a summary is read without changing anything', () async {
    final summary = CashewImportService(db).summarize(path);
    expect(summary.accounts, 2);
    expect(summary.transactions, 8);
    expect(await db.getAllTransactions(), isEmpty);
  });

  test('everything arrives, translated, with Cashew\'s balances', () async {
    await CashewImportService(db).import(path);

    final wallets = {for (final w in await db.getAllWallets()) w.name: w};
    // Cashew's balance: the sum of every paid row.
    expect(wallets['Bank']!.balance, (50000 - 3000 - 2400 - 2400) * 100);
    expect(wallets['Cash']!.balance, (-1200 + 3000) * 100);

    final out = await tx('t-out');
    final into = await tx('t-in');
    expect(TransactionPolicy.isTransfer(out), isTrue);
    expect(out.pairedTransactionId, into.id);
    expect(into.pairedTransactionId, out.id, reason: 'made mutual');

    expect(TransactionPolicy.isAdjustment(await tx('t-open')), isTrue);

    final loan = await tx('t-lend');
    expect(loan.specialType, TransactionSpecialType.credit);
    expect(TransactionPolicy.isSettled(loan), isTrue);
    final repayment = (await db.getSettlementsOf(loan.id)).single;
    expect(repayment.date, DateTime(2025, 4, 1, 12));
    expect(TransactionPolicy.countsInAnalytics(repayment), isFalse);

    final schedule = (await db.getAllRecurringConfigs()).single;
    expect(schedule.baseTransactionId, (await tx('t-sub2')).id);
    expect(schedule.amount, 260000, reason: 'the next payment costs more');
    expect(schedule.nextOccurrence, DateTime(2030, 7, 1, 12));
    expect(schedule.autoPay, isTrue, reason: 'repeating, not a subscription');
    expect((await tx('t-sub1')).recurringConfigId, schedule.id);

    final categories = await db.getAllCategories();
    expect(
      categories.where((c) => c.name == 'Groceries'),
      hasLength(1),
      reason: 'filed into the one already here',
    );
    final fair = categories.singleWhere((c) => c.name == 'Mela');
    expect(fair.iconName, 'emoji:🎡');
    expect(fair.isArchived, isTrue);
    expect(
      categories.where((c) => SystemCategoryKeys.all.contains(c.defaultKey)),
      hasLength(2),
      reason: 'Cashew\'s "0" is the correction category already here',
    );

    for (final t in await db.getAllTransactions()) {
      expect(t.syncStatus, SyncStatus.pendingCreate, reason: 'to the cloud');
    }
  });

  test('importing the same backup again adds nothing', () async {
    final service = CashewImportService(db);
    final first = await service.import(path);
    expect(
      first.transactionsAdded,
      7,
      reason: 'the waiting copy is a schedule',
    );

    final balances = {
      for (final w in await db.getAllWallets()) w.id: w.balance,
    };
    final again = await service.import(path);

    expect(again.rowsAdded, 0);
    expect(again.alreadyHere, 7);
    for (final w in await db.getAllWallets()) {
      expect(
        await WalletBalanceService(db).calculateWalletBalance(w.id),
        balances[w.id],
      );
    }
  });

  test('a file that is not a Cashew backup is refused', () async {
    final other = File('${dir.path}/notes.sql')..writeAsStringSync('hello');
    expect(
      CashewImportService.looksLikeCashewBackup(other.readAsBytesSync()),
      isFalse,
    );
    expect(
      () => CashewImportService(db).summarize(other.path),
      throwsA(anything),
    );
  });
}
