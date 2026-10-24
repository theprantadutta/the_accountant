import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/split/screens/split_bill_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// The split screen: people added by name, the shares worked out as they are
/// added, and the bill recorded as the user's spending plus what each friend
/// owes.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late String bank;
  late String food;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    bank = await seedWallet(db, name: 'Bank', openingBalance: 100000);
    food = await seedCategory(db, name: 'Food');
  });

  tearDown(() async => db.close());

  Future<void> pump(WidgetTester tester) async {
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
          home: SplitBillScreen(
            initialTitle: 'Dinner',
            initialTotal: 9000,
            initialCategoryId: food,
            initialWalletId: bank,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> addPerson(WidgetTester tester, String name) async {
    await tester.ensureVisible(find.byKey(const Key('split_add_person')));
    await tester.tap(find.byKey(const Key('split_add_person')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('split_person_name')), name);
    await tester.pump();
    await tester.tap(find.byKey(const Key('split_person_add')));
    await tester.pumpAndSettle();
  }

  testWidgets('adding people shows their shares, and saving records them', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byKey(const Key('split_summary')), findsNothing);

    await addPerson(tester, 'Alice');
    await addPerson(tester, 'Bob');

    expect(find.byKey(const Key('split_share_me')), findsOneWidget);
    expect(find.byKey(const Key('split_share_Alice')), findsOneWidget);
    expect(find.byKey(const Key('split_share_Bob')), findsOneWidget);
    expect(find.text('Owes you'), findsNWidgets(2));
    await tester.scrollUntilVisible(
      find.byKey(const Key('split_summary')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('split_summary')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('split_save')));
    await tester.tap(find.byKey(const Key('split_save')));
    await tester.pumpAndSettle();

    final lent = await db.getCreditTransactions();
    expect(
      {for (final t in lent) t.title: t.amount},
      {'Alice': 3000, 'Bob': 3000},
    );
    expect((await db.findWalletById(bank))!.balance, 100000 - 9000);
  });
}
