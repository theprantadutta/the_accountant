import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';
import 'package:the_accountant/data/models/transaction.dart';
import 'package:the_accountant/data/models/wallet.dart';
import 'package:the_accountant/data/models/budget.dart';
import 'package:the_accountant/data/models/user.dart';
import 'package:the_accountant/data/models/settings.dart';
import 'package:the_accountant/data/models/user_profile.dart';
import 'package:the_accountant/data/models/payment_method.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Categories,
    Wallets,
    Transactions,
    Budgets,
    Settings,
    UserProfiles,
    PaymentMethods,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  // Settings DAO methods
  Future<Setting?> getSettings() => select(settings).getSingleOrNull();
  
  Future<int> insertSettings(SettingsCompanion entry) => into(settings).insert(entry);
  
  Future<bool> updateSettings(SettingsCompanion entry) => update(settings).replace(entry);

  // Transaction DAO methods
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Future<Transaction?> findTransactionById(String id) => 
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> addTransaction(TransactionsCompanion entry) => 
      into(transactions).insert(entry);

  Future<bool> updateTransaction(TransactionsCompanion entry) => 
      update(transactions).replace(entry);

  Future<int> deleteTransaction(String id) => 
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<List<Transaction>> getTransactionsByType(String type) =>
      (select(transactions)..where((t) => t.type.equals(type))).get();

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) =>
      (select(transactions)..where((t) => t.categoryId.equals(categoryId))).get();

  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) =>
      (select(transactions)
        ..where((t) => t.date.isBetweenValues(start, end)))
        .get();

  // Payment Method DAO methods
  Future<List<PaymentMethod>> getAllPaymentMethods() => select(paymentMethods).get();

  Future<PaymentMethod?> findPaymentMethodById(String id) => 
      (select(paymentMethods)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> addPaymentMethod(PaymentMethodsCompanion entry) => 
      into(paymentMethods).insert(entry);

  Future<bool> updatePaymentMethod(PaymentMethodsCompanion entry) => 
      update(paymentMethods).replace(entry);

  Future<int> deletePaymentMethod(String id) => 
      (delete(paymentMethods)..where((p) => p.id.equals(id))).go();

  Future<List<PaymentMethod>> getDefaultPaymentMethods() =>
      (select(paymentMethods)..where((p) => p.isDefault.equals(true))).get();

  // Budget DAO methods
  Future<List<Budget>> getAllBudgets() => select(budgets).get();

  Future<Budget?> findBudgetById(String id) => 
      (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> addBudget(BudgetsCompanion entry) => 
      into(budgets).insert(entry);

  Future<bool> updateBudget(BudgetsCompanion entry) => 
      update(budgets).replace(entry);

  Future<int> deleteBudget(String id) => 
      (delete(budgets)..where((b) => b.id.equals(id))).go();

  Future<List<Budget>> getActiveBudgets() =>
      (select(budgets)
        ..where((b) => b.startDate.isSmallerThanValue(DateTime.now()))
        ..where((b) => b.endDate.isBiggerOrEqualValue(DateTime.now())))
        .get();

  // Category DAO methods
  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<Category?> findCategoryById(String id) => 
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> addCategory(CategoriesCompanion entry) => 
      into(categories).insert(entry);

  Future<bool> updateCategory(CategoriesCompanion entry) => 
      update(categories).replace(entry);

  Future<int> deleteCategory(String id) => 
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future<List<Category>> getCategoriesByType(String type) =>
      (select(categories)..where((c) => c.type.equals(type))).get();

  // Wallet DAO methods
  Future<List<Wallet>> getAllWallets() => select(wallets).get();

  Future<Wallet?> findWalletById(String id) => 
      (select(wallets)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<int> addWallet(WalletsCompanion entry) => 
      into(wallets).insert(entry);

  Future<bool> updateWallet(WalletsCompanion entry) => 
      update(wallets).replace(entry);

  Future<int> deleteWallet(String id) => 
      (delete(wallets)..where((w) => w.id.equals(id))).go();

  Future<List<Wallet>> getDefaultWallets() =>
      (select(wallets)..where((w) => w.balance.equals(0.0))).get();

  // User Profile DAO methods
  Future<List<UserProfile>> getAllUserProfiles() => select(userProfiles).get();

  Future<UserProfile?> findUserProfileById(String userId) => 
      (select(userProfiles)..where((u) => u.userId.equals(userId))).getSingleOrNull();

  Future<int> addUserProfile(UserProfilesCompanion entry) => 
      into(userProfiles).insert(entry);

  Future<bool> updateUserProfile(UserProfilesCompanion entry) => 
      update(userProfiles).replace(entry);

  Future<int> deleteUserProfile(String userId) => 
      (delete(userProfiles)..where((u) => u.userId.equals(userId))).go();

}