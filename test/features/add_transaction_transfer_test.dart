import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase, Transaction;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

import '../helpers/test_database.dart';

/// The transfer half of the add-transaction form.
///
/// These assertions are about what the form *offers*, which is a different
/// question from what the service accepts. `TransferService` refuses a transfer
/// between wallets counting in different currencies; the form's job is to never
/// put the user in front of that refusal in the first place.
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

  Future<void> pump(WidgetTester tester, {Transaction? existing}) async {
    // Deliberately the default test surface rather than a phone-shaped one.
    // Widget tests draw with a placeholder font whose glyphs are all one width,
    // so text measures differently than on a device: at phone width the date
    // picker's row overflows by three pixels here and not at all in the app.
    // A wider surface keeps that artifact out of assertions that are about
    // which wallets appear, not about layout.

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
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// The type chip, told apart from the save button — which is also labelled
  /// "Transfer" once the form is in transfer mode.
  Finder typeChip(String label) => find.descendant(
    of: find.byKey(const ValueKey('transaction-type-selector')),
    matching: find.text(label),
  );

  Future<void> chooseTransfer(WidgetTester tester) async {
    await tester.tap(typeChip('Transfer'));
    await tester.pump(const Duration(milliseconds: 400));
  }

  bool saveEnabled(WidgetTester tester) =>
      tester.widget<NeoButton>(find.byType(NeoButton).last).onPressed != null;

  group('which wallets a transfer may use', () {
    testWidgets('two wallets in one currency can transfer', (tester) async {
      await seedWallet(db, name: 'Everyday', openingBalance: 100000);
      await seedWallet(db, name: 'Bank');
      await pump(tester);

      expect(typeChip('Transfer'), findsOneWidget);
    });

    testWidgets('a lone wallet in its currency is not offered', (tester) async {
      // Two wallets, but nothing to transfer between: each is alone in its own
      // currency, so neither has a valid destination.
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'bKash', currency: 'BDT');
      await pump(tester);

      expect(
        typeChip('Transfer'),
        findsNothing,
        reason: 'offering it would lead only to a refusal',
      );
    });

    testWidgets('the destination list holds only the source currency', (
      tester,
    ) async {
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'Bank', currency: 'USD');
      await seedWallet(db, name: 'bKash', currency: 'BDT');
      await pump(tester);
      await chooseTransfer(tester);

      // "From" defaults to the first wallet, which is in USD.
      expect(find.text('Everyday (USD)'), findsWidgets);
      expect(find.text('Bank (USD)'), findsWidgets);
      expect(
        find.text('bKash (BDT)'),
        findsNothing,
        reason: 'a taka wallet is not a destination for dollars',
      );
    });

    testWidgets('a third wallet in another currency cannot be reached', (
      tester,
    ) async {
      // The one that matters: the form must not let the two ends disagree,
      // because both legs of a transfer carry the same figure.
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'Bank', currency: 'USD');
      await seedWallet(db, name: 'bKash', currency: 'BDT');
      await seedWallet(db, name: 'Nagad', currency: 'BDT');
      await pump(tester);
      await chooseTransfer(tester);

      // Both currencies have a partner, so both appear as sources...
      expect(find.text('bKash (BDT)'), findsWidgets);
      // ...but the destinations on offer are only the ones in USD, which is
      // what the source is.
      final labels = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .whereType<String>()
          .where((d) => d.contains('(BDT)'))
          .toList();
      expect(
        labels.length,
        lessThan(4),
        reason: 'BDT wallets should appear as sources only, not destinations',
      );
    });
  });

  group('editing a transfer', () {
    /// A saved transfer, as the list screen would hand one back for editing.
    Future<Transaction> seedTransfer() async {
      final from = await seedWallet(
        db,
        name: 'Everyday',
        openingBalance: 100000,
      );
      final to = await seedWallet(db, name: 'Bank');
      // Both ids up front, so each leg can name the other as it is written:
      // a transfer is only a transfer while the pairing is reciprocal.
      const outgoing = 'txn-outgoing';
      const incoming = 'txn-incoming';
      await seedTransaction(
        db,
        id: outgoing,
        walletId: from,
        amount: 10000,
        isIncome: false,
        transactionType: 'transfer',
        title: 'Transfer',
        pairedTransactionId: incoming,
      );
      await seedTransaction(
        db,
        id: incoming,
        walletId: to,
        amount: 10000,
        isIncome: true,
        transactionType: 'transfer',
        title: 'Transfer',
        pairedTransactionId: outgoing,
      );
      return (await db.getAllTransactions()).firstWhere(
        (t) => t.id == outgoing,
      );
    }

    testWidgets('says it is a transfer, and will not be talked out of it', (
      tester,
    ) async {
      // Editing used to show Expense and Income with neither selected, because
      // Transfer was hidden whenever editing. Tapping either turned the form
      // into a regular-transaction UI while the save still went through the
      // transfer path — the screen said one thing and did another.
      final existing = await seedTransfer();
      await pump(tester, existing: existing);

      expect(typeChip('Transfer'), findsOneWidget);
      expect(find.text('Expense'), findsNothing);
      expect(find.text('Income'), findsNothing);
    });

    testWidgets('the transfer chip cannot be tapped away', (tester) async {
      final existing = await seedTransfer();
      await pump(tester, existing: existing);

      await tester.tap(typeChip('Transfer'));
      await tester.pump(const Duration(milliseconds: 400));

      // Still a transfer, and still the only thing on offer.
      expect(typeChip('Transfer'), findsOneWidget);
      expect(find.text('Expense'), findsNothing);
      expect(
        saveEnabled(tester),
        isTrue,
        reason: 'a complete transfer opens ready to save',
      );
    });
  });
}
