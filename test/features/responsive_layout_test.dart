import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/dashboard/widgets/responsive_financial_overview.dart';
import 'package:the_accountant/features/reports/screens/reports_screen.dart';
import 'package:the_accountant/features/settings/screens/settings_screen.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/features/reports/widgets/spending_heatmap.dart';
import 'package:the_accountant/shared/widgets/budget_progress.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart'
    show SettingsRow, Symbols;

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// The main screens fit a small phone, a phone and a tablet, at normal and
/// large text, in English and in Bangla (whose strings run longer): nothing
/// overflows anywhere on them, including further down than the first screen.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late String detailId;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    // Today's greeting and More's account card read the signed-in user, whose
    // API client reads its base URL from the environment.
    dotenv.loadFromString(envString: 'API_BASE_URL_DEV=http://localhost:8002');

    final now = DateTime.now();
    final cash = await seedWallet(db, name: 'Cash', openingBalance: 2500000);
    final bank = await seedWallet(
      db,
      name: 'Dutch-Bangla Bank Joint Savings Account',
      openingBalance: 987654321,
    );
    final groceries = await seedCategory(db, name: 'Groceries and Household');
    detailId = await seedTransaction(
      db,
      walletId: bank,
      categoryId: groceries,
      amount: 12345678,
      title: 'Monthly groceries from the big supermarket across the river',
      date: now,
    );
    await seedTransaction(
      db,
      walletId: cash,
      amount: 98765432,
      title: 'Salary for the month including the festival bonus and arrears',
      date: now,
      isIncome: true,
    );
    await seedTransaction(
      db,
      walletId: cash,
      amount: 5000000,
      title: 'Lent some money to a cousin for his university admission fee',
      date: now,
      specialType: TransactionSpecialType.credit,
    );
    await seedBudget(
      db,
      name: 'Groceries and household essentials for the family',
      amount: 15000000,
      categoryIds: [groceries],
      startDate: DateTime(now.year, now.month),
    );
  });

  tearDown(() async => db.close());

  const sizes = {
    'small phone': Size(320, 640),
    'phone': Size(360, 780),
    'tablet': Size(800, 1280),
  };

  // Each screen, and something that is only there once it has loaded, so a
  // screen stuck on its spinner cannot pass for one that fits.
  final groceries = find.textContaining('Monthly groceries');
  final screens = <String, (Widget Function(), Finder)>{
    'today': (() => const ResponsiveFinancialOverview(), groceries),
    'transactions': (() => const TransactionListScreen(), groceries),
    'filter sheet': (
      () => const TransactionListScreen(),
      find.byType(BottomSheet),
    ),
    'add transaction': (
      () => const AddTransactionScreen(),
      find.byKey(const Key('date_button')),
    ),
    'stats': (() => const ReportsScreen(), find.byType(SpendingHeatmap)),
    'more': (() => const SettingsScreen(), find.byType(SettingsRow)),
    'budgets': (
      () => const BudgetListScreen(),
      find.byType(BudgetProgressCard),
    ),
    'wallets': (
      () => const WalletManagementScreen(),
      find.textContaining('Dutch-Bangla'),
    ),
    'transaction detail': (
      () => TransactionDetailScreen(transactionId: detailId),
      groceries,
    ),
  };

  for (final screen in screens.entries) {
    group(screen.key, () {
      for (final size in sizes.entries) {
        for (final (scale, locale) in [
          (1.0, const Locale('en')),
          (1.3, const Locale('en')),
          (1.3, const Locale('bn')),
        ]) {
          testWidgets('${size.key}, text x$scale, ${locale.languageCode}: '
              'nothing overflows', (tester) async {
            tester.view.physicalSize = size.value * 3;
            tester.view.devicePixelRatio = 3;
            addTearDown(tester.view.reset);

            // Collected rather than left to takeException, which keeps only
            // the first error and drops the widget it came from.
            final errors = <String>[];
            final previous = FlutterError.onError;
            FlutterError.onError = (d) => errors.add(d.toString());
            try {
              final container = ProviderContainer(
                overrides: [
                  databaseProvider.overrideWithValue(db),
                  sharedPreferencesProvider.overrideWithValue(prefs),
                ],
              );
              addTearDown(container.dispose);
              await container.read(walletProvider.notifier).loadWallets();
              await container.read(categoryProvider.notifier).loadCategories();
              await container
                  .read(transactionProvider.notifier)
                  .loadTransactions();
              await container.read(budgetProvider.notifier).loadBudgets();

              await tester.pumpWidget(
                UncontrolledProviderScope(
                  container: container,
                  child: MediaQuery(
                    data: MediaQueryData(
                      size: size.value,
                      textScaler: TextScaler.linear(scale),
                    ),
                    child: localizedApp(
                      locale: locale,
                      // Tabs are drawn inside the shell's Scaffold.
                      home: Scaffold(body: screen.value.$1()),
                    ),
                  ),
                ),
              );
              await _settle(tester);

              if (screen.key == 'filter sheet') {
                await tester.tap(find.byIcon(Symbols.tune_rounded));
                await _settle(tester);
              }
              expect(screen.value.$2, findsWidgets);

              await _scrollThrough(tester);
            } finally {
              FlutterError.onError = previous;
            }

            expect(errors, isEmpty, reason: errors.join('\n\n'));
          });
        }
      }
    });
  }
}

/// Let loads and entrance animations finish without waiting on anything that
/// repeats forever (shimmers, pulsing dots).
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

/// Scroll the tallest vertical list to its end, so rows below the fold are
/// laid out too.
Future<void> _scrollThrough(WidgetTester tester) async {
  final scrollables = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  if (scrollables.evaluate().isEmpty) return;
  final target = scrollables.last;
  for (var i = 0; i < 6; i++) {
    if (target.evaluate().isEmpty) return;
    await tester.drag(target, const Offset(0, -400), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
  }
}
