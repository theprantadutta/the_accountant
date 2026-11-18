import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';
import '../helpers/localized_app.dart';

/// The add form keeps its extras (repeat, type, loan, split, payment method,
/// budget, goal) folded into one "More options" row, so a plain expense is
/// the amount, a category and the details.
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

  Future<void> pump(
    WidgetTester tester, {
    TransactionSpecialType? specialType,
  }) async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await container.read(walletProvider.notifier).loadWallets();
    await container.read(categoryProvider.notifier).loadCategories();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(
          home: AddTransactionScreen(initialSpecialType: specialType),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  final body = find.byKey(const Key('add_more_options_body'));
  final toggle = find.byKey(const Key('add_more_options'));

  testWidgets('a new expense starts with the extras folded away', (
    tester,
  ) async {
    await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    await pump(tester);

    expect(toggle, findsOneWidget);
    expect(body, findsNothing);
    expect(find.text('Repeat monthly'), findsNothing);
    expect(
      find.text('Repeat, loan, split, payment method, budget, goal'),
      findsOneWidget,
      reason: 'closed, the row says what is inside it',
    );

    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(body, findsOneWidget);
    expect(find.text('Repeat monthly'), findsOneWidget);
  });

  testWidgets('a transaction that uses an option opens with them showing', (
    tester,
  ) async {
    await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    await pump(tester, specialType: TransactionSpecialType.upcoming);

    expect(body, findsOneWidget, reason: 'nothing set is out of sight');
    expect(
      find.descendant(of: toggle, matching: find.text('Upcoming')),
      findsOneWidget,
      reason: 'the row names what is set',
    );
  });
}
