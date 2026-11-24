import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';
import '../helpers/localized_app.dart';

/// Editing what a schedule produced — this month's salary, or a subscription
/// charged a little more than usual — changes that one entry. It used to set
/// up a second schedule from it, so the next month came in twice.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async => db.close());

  testWidgets('saving an edited occurrence leaves the schedules as they were', (
    tester,
  ) async {
    late Transaction occurrence;
    await tester.runAsync(() async {
      final walletId = await seedWallet(db, name: 'Bank', currency: 'BDT');
      final categoryId = await seedCategory(db, name: 'Salary', isIncome: true);
      final baseId = await seedTransaction(
        db,
        walletId: walletId,
        categoryId: categoryId,
        amount: 4690700,
        isIncome: true,
        title: 'Monthly Salary',
        specialType: TransactionSpecialType.repetitive,
        date: DateTime.now().subtract(const Duration(days: 40)),
      );
      final now = DateTime.now();
      await db.addRecurringConfig(
        RecurringConfigsCompanion(
          id: const Value('salary'),
          baseTransactionId: Value(baseId),
          periodLength: const Value(1),
          reoccurrence: const Value('monthly'),
          startDate: Value(now.subtract(const Duration(days: 10))),
          nextOccurrence: Value(now.subtract(const Duration(days: 10))),
          isActive: const Value(true),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingCreate),
        ),
      );
      await RecurringService(database: db).processRecurringTransactions();
      occurrence = (await db.getRecurringInstances('salary')).single;
    });
    expect(occurrence.occurrenceKey, isNotNull);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await tester.runAsync(() async {
      await container.read(walletProvider.notifier).loadWallets();
      await container.read(categoryProvider.notifier).loadCategories();
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(
          home: AddTransactionScreen(existingTransaction: occurrence),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Update'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump();

    late List<RecurringConfig> configs;
    late Transaction after;
    await tester.runAsync(() async {
      configs = await db.getAllRecurringConfigsIncludingTombstones();
      after = (await db.getTransactionById(occurrence.id))!;
    });
    expect(configs.map((c) => c.id), ['salary'], reason: 'no second schedule');
    expect(after.transactionType, TransactionPolicy.recurringInstanceType);
  });
}
