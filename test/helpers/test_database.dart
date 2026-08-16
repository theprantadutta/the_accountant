import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:uuid/uuid.dart';

/// Open an isolated in-memory database.
///
/// Every call returns a completely separate store, which is what lets one test
/// drive "device A" and "device B" simultaneously and assert that data really
/// travelled between them rather than both views reading the same file.
AppDatabase openTestDatabase() => AppDatabase(NativeDatabase.memory());

const _uuid = Uuid();

/// Insert a wallet and return its id.
Future<String> seedWallet(
  AppDatabase db, {
  String? id,
  String name = 'Cash',
  int openingBalance = 0,
  String currency = 'USD',
  int syncStatus = SyncStatus.pendingCreate,
}) async {
  final walletId = id ?? _uuid.v4();
  final now = DateTime.now();
  await db.addWallet(
    WalletsCompanion(
      id: Value(walletId),
      name: Value(name),
      currency: Value(currency),
      balance: Value(openingBalance),
      openingBalance: Value(openingBalance),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: Value(syncStatus),
    ),
  );
  return walletId;
}

/// Insert a category and return its id.
Future<String> seedCategory(
  AppDatabase db, {
  String? id,
  String name = 'Groceries',
  bool isIncome = false,
  bool isDefault = false,
  String? defaultKey,
  int syncStatus = SyncStatus.pendingCreate,
}) async {
  final categoryId = id ?? _uuid.v4();
  final now = DateTime.now();
  await db.addCategory(
    CategoriesCompanion(
      id: Value(categoryId),
      name: Value(name),
      isIncome: Value(isIncome),
      isDefault: Value(isDefault),
      defaultKey: Value(defaultKey),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: Value(syncStatus),
    ),
  );
  return categoryId;
}

/// Prove two test stores really are independent databases.
///
/// The two-device tests are only meaningful if "device A" and "device B" cannot
/// see each other's writes except through sync. Drift warns whenever several
/// AppDatabase instances exist (two instances over ONE executor would race), so
/// this asserts the property that warning is a proxy for, rather than trusting
/// it. See `test/flutter_test_config.dart`.
Future<void> assertStoresAreIndependent(AppDatabase a, AppDatabase b) async {
  final walletId = await seedWallet(a, name: 'independence-probe');
  final leaked = await b.findWalletById(walletId);
  if (leaked != null) {
    throw StateError(
      'Test stores share an executor: a row written to store A is visible in '
      'store B. Two-device assertions would be meaningless.',
    );
  }
  await (a.delete(a.wallets)..where((w) => w.id.equals(walletId))).go();
}

/// Insert a transaction and return its id.
Future<String> seedTransaction(
  AppDatabase db, {
  String? id,
  required String walletId,
  String? categoryId,
  int amount = 1000,
  bool isIncome = false,
  DateTime? date,
  String title = 'Test',
  String transactionType = 'regular',
  TransactionSpecialType specialType = TransactionSpecialType.none,
  bool isPaid = true,
  int paidAmount = 0,
  String? pairedTransactionId,
  String? objectiveId,
  String? recurringConfigId,
  String? occurrenceKey,
  int syncStatus = SyncStatus.pendingCreate,
}) async {
  final txnId = id ?? _uuid.v4();
  final now = DateTime.now();
  await db.addTransaction(
    TransactionsCompanion(
      id: Value(txnId),
      amount: Value(amount),
      title: Value(title),
      date: Value(date ?? now),
      isIncome: Value(isIncome),
      walletId: Value(walletId),
      categoryId: Value(categoryId),
      transactionType: Value(transactionType),
      specialType: Value(specialType),
      isPaid: Value(isPaid),
      paidAmount: Value(paidAmount),
      pairedTransactionId: Value(pairedTransactionId),
      objectiveId: Value(objectiveId),
      recurringConfigId: Value(recurringConfigId),
      occurrenceKey: Value(occurrenceKey),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: Value(syncStatus),
    ),
  );
  return txnId;
}

/// Build an in-memory [Transaction] row without touching a database, for tests
/// that only exercise [TransactionPolicy].
Transaction buildTransaction({
  String id = 't1',
  int amount = 1000,
  bool isIncome = false,
  String transactionType = 'regular',
  TransactionSpecialType? specialType = TransactionSpecialType.none,
  bool isPaid = true,
  int paidAmount = 0,
  bool skipPaid = false,
  DateTime? date,
  DateTime? originalDueDate,
  DateTime? deletedAt,
  String walletId = 'w1',
  String? categoryId,
}) {
  final now = date ?? DateTime(2026, 1, 1);
  return Transaction(
    id: id,
    amount: amount,
    title: 'row',
    date: now,
    isIncome: isIncome,
    type: 'regular',
    transactionType: transactionType,
    walletId: walletId,
    categoryId: categoryId,
    isRecurring: false,
    specialType: specialType,
    isPaid: isPaid,
    originalDueDate: originalDueDate,
    paidAmount: paidAmount,
    skipPaid: skipPaid,
    syncStatus: SyncStatus.synced,
    createdAt: now,
    updatedAt: now,
    deletedAt: deletedAt,
  );
}

/// Convenience for asserting the shared policy in tests.
bool countsAsExpense(Transaction t) => TransactionPolicy.countsAsExpense(t);

/// A budget scoped to [categoryIds] / [walletIds] (and optionally the older
/// single [categoryId]), so tests can pin what happens to those references when
/// the rows they name are merged away or deleted.
Future<String> seedBudget(
  AppDatabase db, {
  String? id,
  String name = 'Groceries budget',
  int amount = 50000,
  List<String> categoryIds = const [],
  List<String> walletIds = const [],
  String? categoryId,
  bool isIncome = false,
  int syncStatus = SyncStatus.pendingCreate,
}) async {
  final budgetId = id ?? const Uuid().v4();
  await db
      .into(db.budgets)
      .insert(
        BudgetsCompanion.insert(
          id: budgetId,
          name: name,
          amount: amount,
          startDate: DateTime.utc(2026, 1, 1),
          categoryIds: Value(jsonEncode(categoryIds)),
          walletIds: Value(jsonEncode(walletIds)),
          categoryId: Value(categoryId),
          isIncome: Value(isIncome),
          syncStatus: Value(syncStatus),
        ),
      );
  return budgetId;
}
