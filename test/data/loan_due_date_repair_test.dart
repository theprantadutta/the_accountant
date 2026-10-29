import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;

import '../helpers/test_database.dart';

/// A loan given a due date only because it was made loses it, so it stops
/// reading as overdue; a date set on purpose, and anything not a loan, stay.
void main() {
  late AppDatabase db;
  late String cash;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    cash = await seedWallet(db, name: 'Cash');
  });

  tearDown(() => db.close());

  Future<String> loan(
    DateTime made,
    DateTime? due, {
    TransactionSpecialType type = TransactionSpecialType.debt,
  }) async {
    final id = await seedTransaction(
      db,
      walletId: cash,
      amount: 5000000,
      date: made,
      specialType: type,
      syncStatus: SyncStatus.synced,
    );
    await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(originalDueDate: Value(due)),
    );
    return id;
  }

  test('due on the day it was made: the date goes, and it syncs', () async {
    final made = DateTime(2026, 3, 13, 17, 25);
    final borrowed = await loan(made, made);
    final lent = await loan(
      made,
      DateTime(2026, 3, 13, 9),
      type: TransactionSpecialType.credit,
    );

    expect(await db.clearLoanDueDatesOnTheirDay(), 2);

    for (final id in [borrowed, lent]) {
      final row = (await db.findTransactionById(id))!;
      expect(row.originalDueDate, isNull);
      expect(row.syncStatus, SyncStatus.pendingUpdate);
    }
  });

  test('a real due date, or an upcoming payment, is left alone', () async {
    final made = DateTime(2026, 3, 13, 17);
    final dated = await loan(made, DateTime(2026, 12, 31));
    final bill = await loan(made, made, type: TransactionSpecialType.upcoming);

    expect(await db.clearLoanDueDatesOnTheirDay(), 0);

    expect((await db.findTransactionById(dated))!.originalDueDate, isNotNull);
    expect((await db.findTransactionById(bill))!.originalDueDate, isNotNull);
  });
}
