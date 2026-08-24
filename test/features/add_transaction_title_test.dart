import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

import '../helpers/test_database.dart';

/// What has to be filled in before a transaction can be saved.
///
/// An expense needs a title. Without one every row in a month reads as its own
/// category — four things called "Food & Dining" and no way to tell which was
/// the coffee. A transfer does not: the two accounts name it better than any
/// words the user would type, and the title falls back to "Transfer".
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

  /// Open the screen the way the app does: with wallets and categories already
  /// loaded.
  ///
  /// The screen reaches for `wallets.first` while building, which is safe in
  /// the app — the button that opens it does not exist until a wallet does —
  /// but not in a test that pumps it against a cold container.
  Future<void> pump(WidgetTester tester, {Transaction? existing}) async {
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
        child: MaterialApp(
          home: AddTransactionScreen(existingTransaction: existing),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  /// Whether the commit button at the bottom of the form is live.
  bool saveEnabled(WidgetTester tester) {
    final button = tester.widget<NeoButton>(find.byType(NeoButton).last);
    return button.onPressed != null;
  }

  /// Enter an amount through the calculator sheet, the only way the form
  /// accepts one.
  Future<void> enterAmount(WidgetTester tester, String amount) async {
    await tester.tap(find.text('Tap to enter amount'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '0.00'), amount);
    await tester.pump();

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
  }

  testWidgets('a new expense starts unsaveable', (tester) async {
    await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    await pump(tester);

    expect(
      find.text('Save'),
      findsOneWidget,
      reason: 'the expense form is the default',
    );
    expect(saveEnabled(tester), isFalse, reason: 'nothing entered yet');

    await enterAmount(tester, '42.85');
    expect(
      saveEnabled(tester),
      isFalse,
      reason: 'an amount alone does not say what was bought',
    );
  });

  testWidgets('clearing the title of an expense blocks saving it', (
    tester,
  ) async {
    // Editing is the one place where amount, category and wallet are already
    // filled in, which makes the title the only thing under test.
    final walletId = await seedWallet(
      db,
      name: 'Everyday',
      openingBalance: 100000,
    );
    final categoryId = await seedCategory(db, name: 'Groceries');
    final id = await seedTransaction(
      db,
      walletId: walletId,
      categoryId: categoryId,
      amount: 4285,
      title: 'Tesco Metro',
    );
    final existing = (await db.getAllTransactions()).firstWhere(
      (t) => t.id == id,
    );

    await pump(tester, existing: existing);

    expect(
      saveEnabled(tester),
      isTrue,
      reason: 'a complete transaction opens ready to save',
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'What was it for?'),
      '',
    );
    await tester.pump();

    expect(
      saveEnabled(tester),
      isFalse,
      reason: 'an expense with no title is a row you cannot recognise later',
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'What was it for?'),
      'Tesco Express',
    );
    await tester.pump();

    expect(saveEnabled(tester), isTrue);
  });

  testWidgets('the title field is where the cursor starts', (tester) async {
    // The guided flow depends on this: title, then category, then amount.
    await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    await pump(tester);

    final focused = FocusManager.instance.primaryFocus;
    expect(
      focused?.hasPrimaryFocus,
      isTrue,
      reason: 'something must hold focus on open',
    );
    expect(find.text('What was it for?'), findsOneWidget);
  });

  testWidgets('a transfer asks for no title at all', (tester) async {
    await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    await seedWallet(db, name: 'Bank');
    await pump(tester);

    await tester.tap(find.text('Transfer'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('e.g. Move to savings (optional)'),
      findsOneWidget,
      reason: 'the form should say so rather than leaving the user guessing',
    );

    // Two wallets are already chosen by default, so an amount is the only
    // thing still missing. No title is typed anywhere below this line.
    await enterAmount(tester, '100');

    expect(
      saveEnabled(tester),
      isTrue,
      reason: 'a transfer between two named accounts needs no title',
    );
    expect(find.text('Transfer'), findsWidgets);
  });

  group('suggestions from what has been typed before', () {
    /// What the suggestion list is showing, as opposed to what the field holds.
    Finder suggested(String text) => find.descendant(
      of: find.byKey(const ValueKey('title-suggestions')),
      matching: find.text(text),
    );

    /// A transaction already in the history, with a category on it.
    Future<void> seedHistory(String title, String categoryName) async {
      final walletId = await seedWallet(db, name: 'Everyday');
      final categoryId = await seedCategory(db, name: categoryName);
      await seedTransaction(
        db,
        walletId: walletId,
        categoryId: categoryId,
        title: title,
        amount: 250,
      );
    }

    testWidgets('typing part of a past title offers it back', (tester) async {
      await seedHistory('Went to office', 'Transportation');
      await pump(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'What was it for?'),
        'went',
      );
      await tester.pumpAndSettle();

      expect(suggested('Went to office'), findsOneWidget);
      expect(
        suggested('Transportation'),
        findsOneWidget,
        reason: 'the category is half of what tapping this does, so it shows',
      );
    });

    testWidgets('tapping one fills in the title and the category', (
      tester,
    ) async {
      await seedHistory('Went to office', 'Transportation');
      await pump(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'What was it for?'),
        'went',
      );
      await tester.pumpAndSettle();

      await tester.tap(suggested('Went to office'));
      await tester.pumpAndSettle();

      // The title is in the field...
      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.controller?.text, 'Went to office');

      // ...and the category came with it, which is the point: the form is now
      // one figure away from being saveable, without the user choosing a
      // category at all.
      expect(
        find.text('Transportation'),
        findsWidgets,
        reason: 'the category chip in the hero should now name it',
      );
    });

    testWidgets('nothing is offered for a title with no history', (
      tester,
    ) async {
      await seedHistory('Went to office', 'Transportation');
      await pump(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'What was it for?'),
        'zzz',
      );
      await tester.pumpAndSettle();

      expect(suggested('Went to office'), findsNothing);
    });

    testWidgets('a title typed out in full stops suggesting itself', (
      tester,
    ) async {
      // Once the words are all there the suggestion has nothing left to save,
      // and a row that does nothing is a row in the way.
      await seedHistory('Went to office', 'Transportation');
      await pump(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'What was it for?'),
        'Went to office',
      );
      await tester.pumpAndSettle();

      expect(
        suggested('Went to office'),
        findsNothing,
        reason: 'the words are already in the field; there is nothing to save',
      );
    });
  });
}
