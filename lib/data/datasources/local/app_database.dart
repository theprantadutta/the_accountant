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

part 'app_database.g.dart';

/// Sync status values
class SyncStatus {
  static const int synced = 0;
  static const int pendingCreate = 1;
  static const int pendingUpdate = 2;
  static const int pendingDelete = 3;
  static const int conflict = 4;
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Create new tables
            await m.createTable(recurringConfigs);
            await m.createTable(objectives);
            await m.createTable(objectiveTransactions);
            await m.createTable(associatedTitles);
            await m.createTable(syncStates);

            // Add new columns to categories
            await m.addColumn(categories, categories.iconName);
            await m.addColumn(categories, categories.color);
            await m.addColumn(categories, categories.mainCategoryId);
            await m.addColumn(categories, categories.isIncome);
            await m.addColumn(categories, categories.orderIndex);
            await m.addColumn(categories, categories.serverId);
            await m.addColumn(categories, categories.syncStatus);
            await m.addColumn(categories, categories.createdAt);
            await m.addColumn(categories, categories.updatedAt);
            await m.addColumn(categories, categories.deletedAt);

            // Add new columns to wallets
            await m.addColumn(wallets, wallets.iconName);
            await m.addColumn(wallets, wallets.color);
            await m.addColumn(wallets, wallets.isDefault);
            await m.addColumn(wallets, wallets.orderIndex);
            await m.addColumn(wallets, wallets.serverId);
            await m.addColumn(wallets, wallets.syncStatus);
            await m.addColumn(wallets, wallets.createdAt);
            await m.addColumn(wallets, wallets.updatedAt);
            await m.addColumn(wallets, wallets.deletedAt);

            // Add new columns to transactions
            await m.addColumn(transactions, transactions.title);
            await m.addColumn(transactions, transactions.isIncome);
            await m.addColumn(transactions, transactions.transactionType);
            await m.addColumn(transactions, transactions.paymentMethodId);
            await m.addColumn(transactions, transactions.pairedTransactionId);
            await m.addColumn(transactions, transactions.recurringConfigId);
            await m.addColumn(transactions, transactions.receiptImageUrl);
            await m.addColumn(transactions, transactions.serverId);
            await m.addColumn(transactions, transactions.syncStatus);
            await m.addColumn(transactions, transactions.deletedAt);

            // Add new columns to budgets
            await m.addColumn(budgets, budgets.amount);
            await m.addColumn(budgets, budgets.walletIds);
            await m.addColumn(budgets, budgets.categoryIds);
            await m.addColumn(budgets, budgets.isIncome);
            await m.addColumn(budgets, budgets.isPinned);
            await m.addColumn(budgets, budgets.isArchived);
            await m.addColumn(budgets, budgets.serverId);
            await m.addColumn(budgets, budgets.syncStatus);
            await m.addColumn(budgets, budgets.deletedAt);

            // Add new columns to payment_methods
            await m.addColumn(paymentMethods, paymentMethods.iconName);
            await m.addColumn(paymentMethods, paymentMethods.serverId);
            await m.addColumn(paymentMethods, paymentMethods.syncStatus);
            await m.addColumn(paymentMethods, paymentMethods.deletedAt);
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
  Future<List<Transaction>> getAllTransactions() => (select(transactions)
        ..where((t) => t.deletedAt.isNull()))
      .get();

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

  Future<List<Transaction>> getTransactionsByType(String type) =>
      (select(transactions)
            ..where((t) => t.type.equals(type))
            ..where((t) => t.deletedAt.isNull()))
          .get();

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) =>
      (select(transactions)
            ..where((t) => t.categoryId.equals(categoryId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

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
  Future<List<Transaction>> getPendingSyncTransactions() =>
      (select(transactions)..where((t) => t.syncStatus.isBiggerThanValue(0)))
          .get();

  /// Get recurring transaction instances
  Future<List<Transaction>> getRecurringInstances(String recurringConfigId) =>
      (select(transactions)
            ..where((t) => t.recurringConfigId.equals(recurringConfigId))
            ..where((t) => t.deletedAt.isNull()))
          .get();

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

  Future<List<Budget>> getActiveBudgets() => (select(budgets)
        ..where((b) => b.startDate.isSmallerThanValue(DateTime.now()))
        ..where(
            (b) => b.endDate.isNull() | b.endDate.isBiggerThanValue(DateTime.now()))
        ..where((b) => b.isArchived.equals(false))
        ..where((b) => b.deletedAt.isNull()))
      .get();

  Future<List<Budget>> getPinnedBudgets() => (select(budgets)
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

  Future<List<Category>> getCategoriesByType(String type) =>
      (select(categories)
            ..where((c) => c.type.equals(type))
            ..where((c) => c.deletedAt.isNull()))
          .get();

  /// Get income categories
  Future<List<Category>> getIncomeCategories() => (select(categories)
        ..where((c) => c.isIncome.equals(true))
        ..where((c) => c.deletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
      .get();

  /// Get expense categories
  Future<List<Category>> getExpenseCategories() => (select(categories)
        ..where((c) => c.isIncome.equals(false))
        ..where((c) => c.deletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
      .get();

  /// Get main categories (no parent)
  Future<List<Category>> getMainCategories() => (select(categories)
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

  /// FIXED: Was incorrectly filtering by balance.equals(0.0)
  Future<List<Wallet>> getDefaultWallets() => (select(wallets)
        ..where((w) => w.isDefault.equals(true))
        ..where((w) => w.deletedAt.isNull()))
      .get();

  /// Update wallet balance
  Future<void> updateWalletBalance(String walletId, double newBalance) async {
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

  Future<UserProfile?> findUserProfileById(String userId) =>
      (select(userProfiles)..where((u) => u.userId.equals(userId)))
          .getSingleOrNull();

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

  Future<RecurringConfig?> findRecurringConfigById(String id) =>
      (select(recurringConfigs)..where((r) => r.id.equals(id)))
          .getSingleOrNull();

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
            ..where((r) => r.nextOccurrence.isSmallerOrEqualValue(DateTime.now())))
          .get();

  /// Update next occurrence after processing
  Future<void> updateNextOccurrence(
      String id, DateTime nextOccurrence, bool isActive) async {
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
  Future<List<Objective>> getActiveObjectives() => (select(objectives)
        ..where((o) => o.isArchived.equals(false))
        ..where((o) => o.deletedAt.isNull()))
      .get();

  /// Get pinned objectives
  Future<List<Objective>> getPinnedObjectives() => (select(objectives)
        ..where((o) => o.isPinned.equals(true))
        ..where((o) => o.deletedAt.isNull()))
      .get();

  /// Get goals (saving type objectives)
  Future<List<Objective>> getGoals() => (select(objectives)
        ..where((o) => o.type.equals('goal'))
        ..where((o) => o.deletedAt.isNull()))
      .get();

  /// Get loans (debt type objectives)
  Future<List<Objective>> getLoans() => (select(objectives)
        ..where((o) => o.type.equals('loan'))
        ..where((o) => o.deletedAt.isNull()))
      .get();

  // ============================================================
  // Objective Transaction DAO methods
  // ============================================================
  Future<List<ObjectiveTransaction>> getObjectiveTransactions(
          String objectiveId) =>
      (select(objectiveTransactions)
            ..where((ot) => ot.objectiveId.equals(objectiveId)))
          .get();

  Future<int> addObjectiveTransaction(ObjectiveTransactionsCompanion entry) =>
      into(objectiveTransactions).insert(entry);

  Future<int> removeObjectiveTransaction(
          String objectiveId, String transactionId) =>
      (delete(objectiveTransactions)
            ..where((ot) =>
                ot.objectiveId.equals(objectiveId) &
                ot.transactionId.equals(transactionId)))
          .go();

  /// Get total amount contributed to an objective
  Future<double> getObjectiveProgress(String objectiveId) async {
    final linkedTransactions = await (select(objectiveTransactions)
          ..where((ot) => ot.objectiveId.equals(objectiveId)))
        .get();

    double total = 0;
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

  Future<AssociatedTitle?> findAssociatedTitleById(String id) =>
      (select(associatedTitles)..where((a) => a.id.equals(id)))
          .getSingleOrNull();

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
  Future<List<AssociatedTitle>> findContainsTitleMatches() =>
      (select(associatedTitles)..where((a) => a.isExactMatch.equals(false)))
          .get();

  /// Get associated titles for a category
  Future<List<AssociatedTitle>> getAssociatedTitlesForCategory(
          String categoryId) =>
      (select(associatedTitles)
            ..where((a) => a.categoryId.equals(categoryId)))
          .get();

  // ============================================================
  // Sync State DAO methods
  // ============================================================
  Future<List<SyncState>> getAllSyncStates() => select(syncStates).get();

  Future<SyncState?> getSyncStateForTable(String tableName) =>
      (select(syncStates)..where((s) => s.syncTableName.equals(tableName)))
          .getSingleOrNull();

  Future<int> addSyncState(SyncStatesCompanion entry) =>
      into(syncStates).insert(entry);

  Future<void> updateSyncState(String tableName, int serverVersion) async {
    final existing = await getSyncStateForTable(tableName);
    if (existing != null) {
      await (update(syncStates)..where((s) => s.syncTableName.equals(tableName)))
          .write(
        SyncStatesCompanion(
          lastServerVersion: Value(serverVersion),
          lastSyncAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await addSyncState(SyncStatesCompanion(
        syncTableName: Value(tableName),
        lastServerVersion: Value(serverVersion),
        lastSyncAt: Value(DateTime.now()),
      ));
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
    }
  }
}
