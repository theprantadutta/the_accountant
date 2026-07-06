import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';
import 'package:the_accountant/data/models/transaction.dart';
import 'package:the_accountant/data/models/wallet.dart';
import 'package:the_accountant/data/models/budget.dart';
import 'package:the_accountant/data/models/user.dart';
import 'package:the_accountant/data/models/settings.dart';
import 'package:the_accountant/data/models/user_profile.dart';
import 'package:the_accountant/data/models/payment_method.dart';
import 'package:the_accountant/data/models/recurring_config.dart';
import 'package:the_accountant/data/models/objective.dart';
import 'package:the_accountant/data/models/objective_transaction.dart';
import 'package:the_accountant/data/models/associated_title.dart';
import 'package:the_accountant/data/models/sync_state.dart';
import 'package:the_accountant/data/models/exchange_rate.dart';

part 'app_database.g.dart';

/// Data class for export queries with resolved category/wallet names
class ExportTransaction {
  final Transaction transaction;
  final String categoryName;
  final String walletName;

  const ExportTransaction({
    required this.transaction,
    required this.categoryName,
    required this.walletName,
  });
}

/// Sync status values
class SyncStatus {
  static const int synced = 0;
  static const int pendingCreate = 1;
  static const int pendingUpdate = 2;
  static const int pendingDelete = 3;
  static const int conflict = 4;
}

/// Special category IDs for system-managed categories
class SystemCategories {
  /// Category ID for transfer transactions (like Cashew's "0" category)
  static const String transferCategoryId = 'transfer-category-0';

  /// Category ID for balance corrections
  static const String balanceCorrectionCategoryId = 'balance-correction-0';
}

@DriftDatabase(
  tables: [
    // Core tables
    Users,
    Categories,
    Wallets,
    Transactions,
    Budgets,
    Settings,
    UserProfiles,
    PaymentMethods,
    // New tables
    RecurringConfigs,
    Objectives,
    ObjectiveTransactions,
    AssociatedTitles,
    SyncStates,
    ExchangeRates,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 10) {
        // Fix credit/debt isIncome values and recalculate wallet balances
        // Debt (borrowed) transactions should be isIncome=true (money comes IN)
        await customStatement('''
          UPDATE transactions
          SET is_income = 1, updated_at = datetime('now')
          WHERE special_type = 5 AND is_income = 0 AND deleted_at IS NULL
        ''');

        // Credit (lent) transactions should be isIncome=false (money goes OUT)
        await customStatement('''
          UPDATE transactions
          SET is_income = 0, updated_at = datetime('now')
          WHERE special_type = 4 AND is_income = 1 AND deleted_at IS NULL
        ''');

        // Recalculate all wallet balances from scratch
        // Count paid transactions + credit/debt (special_type 4=credit, 5=debt)
        // Skip unpaid upcoming transactions (special_type 1)
        await customStatement('''
          UPDATE wallets SET balance = COALESCE(
            (SELECT SUM(
              CASE WHEN t.is_income = 1 THEN t.amount ELSE -t.amount END
            ) FROM transactions t
            WHERE t.wallet_id = wallets.id
              AND t.deleted_at IS NULL
              AND (t.is_paid = 1 OR t.special_type IN (4, 5))),
            0.0
          ) WHERE deleted_at IS NULL
        ''');
      }

      if (from < 11) {
        // Convert all MONEY from REAL (double dollars) to INTEGER minor units (cents).
        // SQLite column affinity is loose, so we focus on converting the stored VALUES.
        // Order matters: (1) multiply money by 100, (2) add opening_balance column,
        // (3) backfill opening_balance from now-integer cents values.

        // 1) Convert money values to integer cents.
        await customStatement(
          'UPDATE wallets SET balance = CAST(ROUND(balance * 100) AS INTEGER), '
          'credit_limit = CASE WHEN credit_limit IS NULL THEN NULL '
          'ELSE CAST(ROUND(credit_limit * 100) AS INTEGER) END;',
        );
        await customStatement(
          'UPDATE transactions SET amount = CAST(ROUND(amount * 100) AS INTEGER), '
          'paid_amount = CAST(ROUND(paid_amount * 100) AS INTEGER);',
        );
        await customStatement(
          'UPDATE budgets SET amount = CAST(ROUND(amount * 100) AS INTEGER);',
        );
        await customStatement(
          'UPDATE objectives SET target_amount = CAST(ROUND(target_amount * 100) AS INTEGER);',
        );

        // 2) Add the new opening_balance column (defaults to 0).
        await m.addColumn(wallets, wallets.openingBalance);

        // 3) Backfill opening_balance so that
        //    opening_balance + Σ(realized txn effects) == current balance.
        //    Money is already integer cents at this point.
        await customStatement(
          'UPDATE wallets SET opening_balance = balance - COALESCE('
          '(SELECT SUM(CASE WHEN t.is_income = 1 THEN t.amount ELSE -t.amount END) '
          'FROM transactions t WHERE t.wallet_id = wallets.id '
          'AND t.deleted_at IS NULL '
          'AND (t.is_paid = 1 OR t.special_type IN (4, 5))), 0);',
        );
      }
    },
  );

  // ============================================================
  // Settings DAO methods
  // ============================================================
  Future<Setting?> getSettings() => select(settings).getSingleOrNull();

  Future<int> insertSettings(SettingsCompanion entry) =>
      into(settings).insert(entry);

  Future<bool> updateSettings(SettingsCompanion entry) =>
      update(settings).replace(entry);

  // ============================================================
  // Transaction DAO methods
  // ============================================================
  Future<List<Transaction>> getAllTransactions() =>
      (select(transactions)..where((t) => t.deletedAt.isNull())).get();

  /// Get all transactions with category names via JOIN
  /// Returns a list of maps containing transaction data and resolved category info
  Future<List<Map<String, dynamic>>>
  getAllTransactionsWithCategoryName() async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
    ]);

    query.where(transactions.deletedAt.isNull());
    query.orderBy([OrderingTerm.desc(transactions.date)]);

    final results = await query.get();
    return results.map((row) {
      final txn = row.readTable(transactions);
      final cat = row.readTableOrNull(categories);
      return {
        'transaction': txn,
        'categoryName': cat?.name ?? 'Uncategorized',
        'categoryColor': cat?.color ?? '#808080',
        'categoryIconName': cat?.iconName ?? 'category',
      };
    }).toList();
  }

  /// Get transactions for export with resolved category and wallet names via JOIN
  Future<List<ExportTransaction>> getTransactionsForExport({
    DateTime? start,
    DateTime? end,
  }) async {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      leftOuterJoin(
        wallets,
        wallets.id.equalsExp(transactions.walletId),
      ),
    ]);

    query.where(transactions.deletedAt.isNull());
    if (start != null && end != null) {
      query.where(transactions.date.isBetweenValues(start, end));
    }
    query.orderBy([OrderingTerm.desc(transactions.date)]);

    final results = await query.get();
    return results.map((row) {
      final txn = row.readTable(transactions);
      final cat = row.readTableOrNull(categories);
      final wallet = row.readTableOrNull(wallets);
      return ExportTransaction(
        transaction: txn,
        categoryName: cat?.name ?? 'Uncategorized',
        walletName: wallet?.name ?? 'Unknown',
      );
    }).toList();
  }

  Future<Transaction?> findTransactionById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> addTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<bool> updateTransaction(TransactionsCompanion entry) =>
      update(transactions).replace(entry);

  Future<int> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  /// Soft delete a transaction (sets deletedAt and marks for sync)
  Future<void> softDeleteTransaction(String id) async {
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// @deprecated - Use getIncomeTransactions or getExpenseTransactions instead
  Future<List<Transaction>> getTransactionsByType(String type) =>
      (select(transactions)
            ..where((t) => t.type.equals(type))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get all income transactions
  Future<List<Transaction>> getIncomeTransactions() =>
      (select(transactions)
            ..where((t) => t.isIncome.equals(true))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get all expense transactions
  Future<List<Transaction>> getExpenseTransactions() =>
      (select(transactions)
            ..where((t) => t.isIncome.equals(false))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) =>
      (select(transactions)
            ..where((t) => t.categoryId.equals(categoryId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get a single transaction by ID
  Future<Transaction?> getTransactionById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(transactions)
            ..where((t) => t.date.isBetweenValues(start, end))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  Future<List<Transaction>> getTransactionsByWallet(String walletId) =>
      (select(transactions)
            ..where((t) => t.walletId.equals(walletId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get transactions that need to be synced
  Future<List<Transaction>> getPendingSyncTransactions() => (select(
    transactions,
  )..where((t) => t.syncStatus.isBiggerThanValue(0))).get();

  /// Get recurring transaction instances
  Future<List<Transaction>> getRecurringInstances(String recurringConfigId) =>
      (select(transactions)
            ..where((t) => t.recurringConfigId.equals(recurringConfigId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  /// Get upcoming (unpaid future) transactions
  Future<List<Transaction>> getUpcomingTransactions() =>
      (select(transactions)
            ..where((t) => t.isPaid.equals(false))
            ..where((t) => t.skipPaid.equals(false))
            ..where((t) => t.date.isBiggerThanValue(DateTime.now()))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  /// Get overdue (unpaid past) transactions
  Future<List<Transaction>> getOverdueTransactions() =>
      (select(transactions)
            ..where((t) => t.isPaid.equals(false))
            ..where((t) => t.skipPaid.equals(false))
            ..where((t) => t.date.isSmallerThanValue(DateTime.now()))
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  /// Get credit transactions (money lent - they owe you)
  Future<List<Transaction>> getCreditTransactions() =>
      (select(transactions)
            ..where(
              (t) => t.specialType.equals(4),
            ) // TransactionSpecialType.credit index
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get debt transactions (money borrowed - you owe them)
  Future<List<Transaction>> getDebtTransactions() =>
      (select(transactions)
            ..where(
              (t) => t.specialType.equals(5),
            ) // TransactionSpecialType.debt index
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Get all credit and debt transactions
  Future<List<Transaction>> getCreditDebtTransactions() async {
    final query = select(transactions)
      ..where(
        (t) => t.specialType.equals(4) | t.specialType.equals(5),
      ) // credit or debt
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.get();
  }

  /// Get unpaid credit/debt transactions
  Future<List<Transaction>> getUnpaidCreditDebtTransactions() async {
    final query = select(transactions)
      ..where(
        (t) => t.specialType.equals(4) | t.specialType.equals(5),
      ) // credit or debt
      ..where((t) => t.isPaid.equals(false))
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.get();
  }

  /// Get subscription transactions
  Future<List<Transaction>> getSubscriptionTransactions() =>
      (select(transactions)
            ..where(
              (t) => t.specialType.equals(2),
            ) // TransactionSpecialType.subscription
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Mark transaction as paid
  Future<void> markTransactionAsPaid(String id, {DateTime? paymentDate}) async {
    final transaction = await findTransactionById(id);
    if (transaction == null) return;

    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isPaid: const Value(true),
        originalDueDate: Value(transaction.originalDueDate ?? transaction.date),
        date: Value(paymentDate ?? DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark transaction as unpaid
  Future<void> markTransactionAsUnpaid(String id) async {
    final transaction = await findTransactionById(id);
    if (transaction == null) return;

    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isPaid: const Value(false),
        // Restore original due date if available
        date: Value(transaction.originalDueDate ?? transaction.date),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ============================================================
  // Payment Method DAO methods
  // ============================================================
  Future<List<PaymentMethod>> getAllPaymentMethods() =>
      (select(paymentMethods)..where((p) => p.deletedAt.isNull())).get();

  Future<PaymentMethod?> findPaymentMethodById(String id) =>
      (select(paymentMethods)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> addPaymentMethod(PaymentMethodsCompanion entry) =>
      into(paymentMethods).insert(entry);

  Future<bool> updatePaymentMethod(PaymentMethodsCompanion entry) =>
      update(paymentMethods).replace(entry);

  Future<int> deletePaymentMethod(String id) =>
      (delete(paymentMethods)..where((p) => p.id.equals(id))).go();

  Future<List<PaymentMethod>> getDefaultPaymentMethods() =>
      (select(paymentMethods)
            ..where((p) => p.isDefault.equals(true))
            ..where((p) => p.deletedAt.isNull()))
          .get();

  // ============================================================
  // Budget DAO methods
  // ============================================================
  Future<List<Budget>> getAllBudgets() =>
      (select(budgets)..where((b) => b.deletedAt.isNull())).get();

  Future<Budget?> findBudgetById(String id) =>
      (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> addBudget(BudgetsCompanion entry) => into(budgets).insert(entry);

  Future<bool> updateBudget(BudgetsCompanion entry) =>
      update(budgets).replace(entry);

  Future<int> deleteBudget(String id) =>
      (delete(budgets)..where((b) => b.id.equals(id))).go();

  Future<List<Budget>> getActiveBudgets() =>
      (select(budgets)
            ..where((b) => b.startDate.isSmallerThanValue(DateTime.now()))
            ..where(
              (b) =>
                  b.endDate.isNull() |
                  b.endDate.isBiggerThanValue(DateTime.now()),
            )
            ..where((b) => b.isArchived.equals(false))
            ..where((b) => b.deletedAt.isNull()))
          .get();

  Future<List<Budget>> getPinnedBudgets() =>
      (select(budgets)
            ..where((b) => b.isPinned.equals(true))
            ..where((b) => b.deletedAt.isNull()))
          .get();

  // ============================================================
  // Category DAO methods
  // ============================================================
  Future<List<Category>> getAllCategories() =>
      (select(categories)..where((c) => c.deletedAt.isNull())).get();

  Future<Category?> findCategoryById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> addCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<bool> updateCategory(CategoriesCompanion entry) =>
      update(categories).replace(entry);

  Future<int> deleteCategory(String id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  /// @deprecated - Use getIncomeCategories or getExpenseCategories instead
  Future<List<Category>> getCategoriesByType(String type) =>
      (select(categories)
            ..where((c) => c.type.equals(type))
            ..where((c) => c.deletedAt.isNull()))
          .get();

  /// Get income categories
  Future<List<Category>> getIncomeCategories() =>
      (select(categories)
            ..where((c) => c.isIncome.equals(true))
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Get expense categories
  Future<List<Category>> getExpenseCategories() =>
      (select(categories)
            ..where((c) => c.isIncome.equals(false))
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Get main categories (no parent)
  Future<List<Category>> getMainCategories() =>
      (select(categories)
            ..where((c) => c.mainCategoryId.isNull())
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Get subcategories for a main category
  Future<List<Category>> getSubcategories(String mainCategoryId) =>
      (select(categories)
            ..where((c) => c.mainCategoryId.equals(mainCategoryId))
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
          .get();

  /// Ensure system categories exist (Transfer, Balance Correction)
  /// Call this during app initialization
  Future<void> ensureSystemCategoriesExist() async {
    final now = DateTime.now();

    // Create Transfer category if it doesn't exist
    final transferCategory = await findCategoryById(
      SystemCategories.transferCategoryId,
    );
    if (transferCategory == null) {
      await into(categories).insert(
        CategoriesCompanion(
          id: const Value(SystemCategories.transferCategoryId),
          name: const Value('Transfer'),
          iconName: const Value('swap_horiz'),
          color: const Value('#9E9E9E'),
          isIncome: const Value(false), // Treated as expense category
          isDefault: const Value(true),
          orderIndex: const Value(-1), // System categories at the end
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
    }

    // Create Balance Correction category if it doesn't exist
    final correctionCategory = await findCategoryById(
      SystemCategories.balanceCorrectionCategoryId,
    );
    if (correctionCategory == null) {
      await into(categories).insert(
        CategoriesCompanion(
          id: const Value(SystemCategories.balanceCorrectionCategoryId),
          name: const Value('Balance Correction'),
          iconName: const Value('tune'),
          color: const Value('#607D8B'),
          isIncome: const Value(false),
          isDefault: const Value(true),
          orderIndex: const Value(-2),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
    }
  }

  // ============================================================
  // Wallet DAO methods
  // ============================================================
  Future<List<Wallet>> getAllWallets() =>
      (select(wallets)..where((w) => w.deletedAt.isNull())).get();

  Future<Wallet?> findWalletById(String id) =>
      (select(wallets)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<int> addWallet(WalletsCompanion entry) => into(wallets).insert(entry);

  Future<bool> updateWallet(WalletsCompanion entry) =>
      update(wallets).replace(entry);

  Future<int> deleteWallet(String id) =>
      (delete(wallets)..where((w) => w.id.equals(id))).go();

  /// Soft-delete a wallet (sets deletedAt + marks for sync) so the deletion propagates
  /// to the server instead of being a local-only hard delete.
  Future<void> softDeleteWallet(String id) async {
    await (update(wallets)..where((w) => w.id.equals(id))).write(
      WalletsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft-delete every not-already-deleted transaction belonging to a wallet, marking them
  /// for sync. Called when a wallet is deleted so its transactions don't become orphans
  /// that keep skewing dashboard/report totals.
  Future<void> softDeleteTransactionsForWallet(String walletId) async {
    await (update(transactions)
          ..where((t) => t.walletId.equals(walletId) & t.deletedAt.isNull()))
        .write(
      TransactionsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// FIXED: Was incorrectly filtering by balance.equals(0.0)
  Future<List<Wallet>> getDefaultWallets() =>
      (select(wallets)
            ..where((w) => w.isDefault.equals(true))
            ..where((w) => w.deletedAt.isNull()))
          .get();

  /// Update wallet balance (integer minor units / cents)
  Future<void> updateWalletBalance(String walletId, int newBalance) async {
    await (update(wallets)..where((w) => w.id.equals(walletId))).write(
      WalletsCompanion(
        balance: Value(newBalance),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
  }

  // ============================================================
  // User Profile DAO methods
  // ============================================================
  Future<List<UserProfile>> getAllUserProfiles() => select(userProfiles).get();

  Future<UserProfile?> findUserProfileById(String userId) => (select(
    userProfiles,
  )..where((u) => u.userId.equals(userId))).getSingleOrNull();

  Future<int> addUserProfile(UserProfilesCompanion entry) =>
      into(userProfiles).insert(entry);

  Future<bool> updateUserProfile(UserProfilesCompanion entry) =>
      update(userProfiles).replace(entry);

  Future<int> deleteUserProfile(String userId) =>
      (delete(userProfiles)..where((u) => u.userId.equals(userId))).go();

  // ============================================================
  // Recurring Config DAO methods
  // ============================================================
  Future<List<RecurringConfig>> getAllRecurringConfigs() =>
      select(recurringConfigs).get();

  Future<RecurringConfig?> findRecurringConfigById(String id) => (select(
    recurringConfigs,
  )..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<int> addRecurringConfig(RecurringConfigsCompanion entry) =>
      into(recurringConfigs).insert(entry);

  Future<bool> updateRecurringConfig(RecurringConfigsCompanion entry) =>
      update(recurringConfigs).replace(entry);

  Future<int> deleteRecurringConfig(String id) =>
      (delete(recurringConfigs)..where((r) => r.id.equals(id))).go();

  /// Get active recurring configs
  Future<List<RecurringConfig>> getActiveRecurringConfigs() =>
      (select(recurringConfigs)..where((r) => r.isActive.equals(true))).get();

  /// Get recurring configs due for processing
  Future<List<RecurringConfig>> getDueRecurringConfigs() =>
      (select(recurringConfigs)
            ..where((r) => r.isActive.equals(true))
            ..where(
              (r) => r.nextOccurrence.isSmallerOrEqualValue(DateTime.now()),
            ))
          .get();

  /// Update next occurrence after processing
  Future<void> updateNextOccurrence(
    String id,
    DateTime nextOccurrence,
    bool isActive,
  ) async {
    await (update(recurringConfigs)..where((r) => r.id.equals(id))).write(
      RecurringConfigsCompanion(
        nextOccurrence: Value(nextOccurrence),
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
  }

  // ============================================================
  // Objective DAO methods
  // ============================================================
  Future<List<Objective>> getAllObjectives() =>
      (select(objectives)..where((o) => o.deletedAt.isNull())).get();

  Future<Objective?> findObjectiveById(String id) =>
      (select(objectives)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<int> addObjective(ObjectivesCompanion entry) =>
      into(objectives).insert(entry);

  Future<bool> updateObjective(ObjectivesCompanion entry) =>
      update(objectives).replace(entry);

  Future<int> deleteObjective(String id) =>
      (delete(objectives)..where((o) => o.id.equals(id))).go();

  /// Get active (non-archived) objectives
  Future<List<Objective>> getActiveObjectives() =>
      (select(objectives)
            ..where((o) => o.isArchived.equals(false))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  /// Get pinned objectives
  Future<List<Objective>> getPinnedObjectives() =>
      (select(objectives)
            ..where((o) => o.isPinned.equals(true))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  /// Get goals (saving type objectives)
  Future<List<Objective>> getGoals() =>
      (select(objectives)
            ..where((o) => o.type.equals('goal'))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  /// Get loans (debt type objectives)
  Future<List<Objective>> getLoans() =>
      (select(objectives)
            ..where((o) => o.type.equals('loan'))
            ..where((o) => o.deletedAt.isNull()))
          .get();

  // ============================================================
  // Objective Transaction DAO methods
  // ============================================================
  Future<List<ObjectiveTransaction>> getObjectiveTransactions(
    String objectiveId,
  ) => (select(
    objectiveTransactions,
  )..where((ot) => ot.objectiveId.equals(objectiveId))).get();

  Future<int> addObjectiveTransaction(ObjectiveTransactionsCompanion entry) =>
      into(objectiveTransactions).insert(entry);

  Future<int> removeObjectiveTransaction(
    String objectiveId,
    String transactionId,
  ) =>
      (delete(objectiveTransactions)..where(
            (ot) =>
                ot.objectiveId.equals(objectiveId) &
                ot.transactionId.equals(transactionId),
          ))
          .go();

  /// Get total amount contributed to an objective (integer minor units / cents)
  Future<int> getObjectiveProgress(String objectiveId) async {
    final linkedTransactions = await (select(
      objectiveTransactions,
    )..where((ot) => ot.objectiveId.equals(objectiveId))).get();

    int total = 0;
    for (final link in linkedTransactions) {
      final transaction = await findTransactionById(link.transactionId);
      if (transaction != null && transaction.deletedAt == null) {
        total += transaction.amount;
      }
    }
    return total;
  }

  // ============================================================
  // Associated Title DAO methods (Smart Categorization)
  // ============================================================
  Future<List<AssociatedTitle>> getAllAssociatedTitles() =>
      select(associatedTitles).get();

  Future<AssociatedTitle?> findAssociatedTitleById(String id) => (select(
    associatedTitles,
  )..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> addAssociatedTitle(AssociatedTitlesCompanion entry) =>
      into(associatedTitles).insert(entry);

  Future<bool> updateAssociatedTitle(AssociatedTitlesCompanion entry) =>
      update(associatedTitles).replace(entry);

  Future<int> deleteAssociatedTitle(String id) =>
      (delete(associatedTitles)..where((a) => a.id.equals(id))).go();

  /// Find category suggestion by exact title match
  Future<AssociatedTitle?> findExactTitleMatch(String title) =>
      (select(associatedTitles)
            ..where((a) => a.title.equals(title.toLowerCase()))
            ..where((a) => a.isExactMatch.equals(true)))
          .getSingleOrNull();

  /// Find category suggestion by contains match
  Future<List<AssociatedTitle>> findContainsTitleMatches() => (select(
    associatedTitles,
  )..where((a) => a.isExactMatch.equals(false))).get();

  /// Get associated titles for a category
  Future<List<AssociatedTitle>> getAssociatedTitlesForCategory(
    String categoryId,
  ) => (select(
    associatedTitles,
  )..where((a) => a.categoryId.equals(categoryId))).get();

  // ============================================================
  // Sync State DAO methods
  // ============================================================
  Future<List<SyncState>> getAllSyncStates() => select(syncStates).get();

  Future<SyncState?> getSyncStateForTable(String tableName) => (select(
    syncStates,
  )..where((s) => s.syncTableName.equals(tableName))).getSingleOrNull();

  Future<int> addSyncState(SyncStatesCompanion entry) =>
      into(syncStates).insert(entry);

  Future<void> updateSyncState(String tableName, int serverVersion) async {
    final existing = await getSyncStateForTable(tableName);
    if (existing != null) {
      await (update(
        syncStates,
      )..where((s) => s.syncTableName.equals(tableName))).write(
        SyncStatesCompanion(
          lastServerVersion: Value(serverVersion),
          lastSyncAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await addSyncState(
        SyncStatesCompanion(
          syncTableName: Value(tableName),
          lastServerVersion: Value(serverVersion),
          lastSyncAt: Value(DateTime.now()),
        ),
      );
    }
  }

  /// Mark all records in a table as synced
  Future<void> markTableAsSynced(String tableName) async {
    // Update sync status based on table name
    switch (tableName) {
      case 'categories':
        await (update(categories)
              ..where((c) => c.syncStatus.isBiggerThanValue(0)))
            .write(const CategoriesCompanion(syncStatus: Value(0)));
        break;
      case 'wallets':
        await (update(wallets)..where((w) => w.syncStatus.isBiggerThanValue(0)))
            .write(const WalletsCompanion(syncStatus: Value(0)));
        break;
      case 'transactions':
        await (update(transactions)
              ..where((t) => t.syncStatus.isBiggerThanValue(0)))
            .write(const TransactionsCompanion(syncStatus: Value(0)));
        break;
      case 'budgets':
        await (update(budgets)..where((b) => b.syncStatus.isBiggerThanValue(0)))
            .write(const BudgetsCompanion(syncStatus: Value(0)));
        break;
      case 'payment_methods':
        await (update(paymentMethods)
              ..where((p) => p.syncStatus.isBiggerThanValue(0)))
            .write(const PaymentMethodsCompanion(syncStatus: Value(0)));
        break;
      case 'recurring_configs':
        await (update(recurringConfigs)
              ..where((r) => r.syncStatus.isBiggerThanValue(0)))
            .write(const RecurringConfigsCompanion(syncStatus: Value(0)));
        break;
      case 'objectives':
        await (update(objectives)
              ..where((o) => o.syncStatus.isBiggerThanValue(0)))
            .write(const ObjectivesCompanion(syncStatus: Value(0)));
        break;
      case 'associated_titles':
        await (update(associatedTitles)
              ..where((a) => a.syncStatus.isBiggerThanValue(0)))
            .write(const AssociatedTitlesCompanion(syncStatus: Value(0)));
        break;
      case 'exchange_rates':
        await (update(exchangeRates)
              ..where((e) => e.syncStatus.isBiggerThanValue(0)))
            .write(const ExchangeRatesCompanion(syncStatus: Value(0)));
        break;
    }
  }

  // ============================================================
  // Exchange Rate DAO methods
  // ============================================================
  Future<List<ExchangeRate>> getAllExchangeRates() =>
      select(exchangeRates).get();

  Future<ExchangeRate?> findExchangeRateById(String id) =>
      (select(exchangeRates)..where((e) => e.id.equals(id))).getSingleOrNull();

  /// Get exchange rate for a specific currency pair
  Future<ExchangeRate?> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) =>
      (select(exchangeRates)
            ..where((e) => e.fromCurrency.equals(fromCurrency.toUpperCase()))
            ..where((e) => e.toCurrency.equals(toCurrency.toUpperCase())))
          .getSingleOrNull();

  Future<int> addExchangeRate(ExchangeRatesCompanion entry) =>
      into(exchangeRates).insert(entry);

  Future<bool> updateExchangeRate(ExchangeRatesCompanion entry) =>
      update(exchangeRates).replace(entry);

  Future<int> deleteExchangeRate(String id) =>
      (delete(exchangeRates)..where((e) => e.id.equals(id))).go();

  /// Upsert exchange rate (insert or update if exists)
  Future<void> upsertExchangeRate({
    required String fromCurrency,
    required String toCurrency,
    double? apiRate,
    double? customRate,
    bool? useCustomRate,
    DateTime? apiRateFetchedAt,
  }) async {
    final existing = await getExchangeRate(fromCurrency, toCurrency);
    final now = DateTime.now();

    if (existing != null) {
      // Update existing
      await (update(
        exchangeRates,
      )..where((e) => e.id.equals(existing.id))).write(
        ExchangeRatesCompanion(
          apiRate: apiRate != null ? Value(apiRate) : const Value.absent(),
          customRate: customRate != null
              ? Value(customRate)
              : const Value.absent(),
          useCustomRate: useCustomRate != null
              ? Value(useCustomRate)
              : const Value.absent(),
          apiRateFetchedAt: apiRateFetchedAt != null
              ? Value(apiRateFetchedAt)
              : const Value.absent(),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingUpdate),
        ),
      );
    } else {
      // Insert new
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await into(exchangeRates).insert(
        ExchangeRatesCompanion(
          id: Value(id),
          fromCurrency: Value(fromCurrency.toUpperCase()),
          toCurrency: Value(toCurrency.toUpperCase()),
          apiRate: Value(apiRate),
          customRate: Value(customRate),
          useCustomRate: Value(useCustomRate ?? false),
          apiRateFetchedAt: Value(apiRateFetchedAt),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingCreate),
        ),
      );
    }
  }

  /// Get all exchange rates with custom overrides
  Future<List<ExchangeRate>> getCustomExchangeRates() =>
      (select(exchangeRates)..where((e) => e.useCustomRate.equals(true))).get();

  /// Get exchange rates that need to be synced
  Future<List<ExchangeRate>> getPendingSyncExchangeRates() => (select(
    exchangeRates,
  )..where((e) => e.syncStatus.isBiggerThanValue(0))).get();

  /// Clear custom rate and use API rate
  Future<void> clearCustomRate(String fromCurrency, String toCurrency) async {
    final existing = await getExchangeRate(fromCurrency, toCurrency);
    if (existing != null) {
      await (update(
        exchangeRates,
      )..where((e) => e.id.equals(existing.id))).write(
        ExchangeRatesCompanion(
          customRate: const Value(null),
          useCustomRate: const Value(false),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingUpdate),
        ),
      );
    }
  }

  /// Set a custom rate override
  Future<void> setCustomRate(
    String fromCurrency,
    String toCurrency,
    double rate,
  ) async {
    await upsertExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      customRate: rate,
      useCustomRate: true,
    );
  }

  // ============================================================
  // Global Sync Timestamp Methods
  // ============================================================

  /// Get the persisted last-sync timestamp (stored as a '_global' row in SyncStates)
  Future<DateTime?> getLastSyncTimestamp() async {
    final row = await (select(syncStates)
          ..where((s) => s.syncTableName.equals('_global')))
        .getSingleOrNull();
    return row?.lastSyncAt;
  }

  /// Upsert the global last-sync timestamp
  Future<void> setLastSyncTimestamp(DateTime timestamp) async {
    final existing = await (select(syncStates)
          ..where((s) => s.syncTableName.equals('_global')))
        .getSingleOrNull();

    if (existing != null) {
      await (update(syncStates)
            ..where((s) => s.syncTableName.equals('_global')))
          .write(SyncStatesCompanion(
        lastSyncAt: Value(timestamp),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await into(syncStates).insert(SyncStatesCompanion(
        syncTableName: const Value('_global'),
        lastSyncAt: Value(timestamp),
      ));
    }
  }

  // ============================================================
  // Data Management Methods
  // ============================================================

  /// Clear all user data (transactions, categories, wallets, budgets, etc.)
  /// This preserves system categories and resets settings to defaults.
  /// Used for "Clear All Data" in settings.
  Future<void> clearAllData() async {
    // Delete all transactions first (foreign key references)
    await delete(transactions).go();

    // Delete objective transactions (junction table)
    await delete(objectiveTransactions).go();

    // Delete objectives
    await delete(objectives).go();

    // Delete budgets
    await delete(budgets).go();

    // Delete recurring configs
    await delete(recurringConfigs).go();

    // Delete associated titles (smart categorization)
    await delete(associatedTitles).go();

    // Delete all categories (including system categories)
    await delete(categories).go();

    // Delete all wallets
    await delete(wallets).go();

    // Delete all payment methods
    await delete(paymentMethods).go();

    // Delete exchange rates
    await delete(exchangeRates).go();

    // Clear sync states
    await delete(syncStates).go();

    // Reset settings to defaults
    await delete(settings).go();
    await insertSettings(SettingsCompanion.insert());

    // Recreate system categories
    await ensureSystemCategoriesExist();
  }

  /// Clear app cache (sync states only, preserves user data)
  /// Used for "Clear Cache" in settings.
  Future<void> clearCache() async {
    // Clear sync states (forces re-sync)
    await delete(syncStates).go();

    // Reset all sync statuses to pending
    await customStatement('''
      UPDATE transactions SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE categories SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE wallets SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE budgets SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE objectives SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE payment_methods SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE exchange_rates SET sync_status = 1 WHERE sync_status = 0
    ''');
    await customStatement('''
      UPDATE recurring_configs SET sync_status = 1 WHERE sync_status = 0
    ''');
  }

  /// Get database statistics for display in settings
  Future<Map<String, int>> getDatabaseStats() async {
    final transactionCount = await (select(
      transactions,
    )..where((t) => t.deletedAt.isNull())).get().then((list) => list.length);

    final categoryCount = await (select(
      categories,
    )..where((c) => c.deletedAt.isNull())).get().then((list) => list.length);

    final walletCount = await (select(
      wallets,
    )..where((w) => w.deletedAt.isNull())).get().then((list) => list.length);

    final budgetCount = await (select(
      budgets,
    )..where((b) => b.deletedAt.isNull())).get().then((list) => list.length);

    final objectiveCount = await (select(
      objectives,
    )..where((o) => o.deletedAt.isNull())).get().then((list) => list.length);

    return {
      'transactions': transactionCount,
      'categories': categoryCount,
      'wallets': walletCount,
      'budgets': budgetCount,
      'objectives': objectiveCount,
    };
  }
}
