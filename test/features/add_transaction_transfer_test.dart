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
import '../helpers/localized_app.dart';

/// The transfer half of the add-transaction form.
///
/// These assertions are about what the form *offers*, which is a different
/// question from what the service accepts.
///
/// The form used to filter both account pickers down to a single currency,
/// which was right while `TransferService` refused a crossing outright. It has
/// not been right since: each leg carries its own currency's amount, what the
/// other side received, and the rate between them, and the server accepts the
/// pair. The filters stayed, so a supported feature was unreachable — and the
/// tests below passed the whole time, pinning the old behaviour in place.
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
        child: localizedApp(
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

    testWidgets('two wallets in different currencies can transfer', (
      tester,
    ) async {
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'bKash', currency: 'BDT');
      await pump(tester);

      expect(
        typeChip('Transfer'),
        findsOneWidget,
        reason: 'the service and the server both accept this pair; hiding it '
            'made a supported feature unreachable',
      );
    });

    testWidgets('one wallet still cannot transfer to itself', (tester) async {
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await pump(tester);

      expect(typeChip('Transfer'), findsNothing);
    });

    testWidgets('a wallet in another currency is offered as a destination', (
      tester,
    ) async {
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'Bank', currency: 'USD');
      await seedWallet(db, name: 'bKash', currency: 'BDT');
      await pump(tester);
      await chooseTransfer(tester);

      expect(find.text('Everyday (USD)'), findsWidgets);
      expect(find.text('Bank (USD)'), findsWidgets);
      expect(
        find.text('bKash (BDT)'),
        findsWidgets,
        reason: 'a taka account is a perfectly good destination for dollars '
            'now, at a rate the transfer records',
      );
    });
  });

  /// A crossing needs one more figure than a transfer within a currency.
  ///
  /// Both legs of a same-currency transfer carry the same number, so asking
  /// twice would only invite them to disagree. Across currencies they cannot,
  /// and the honest number is what actually landed — a bank's rate and its
  /// charges are not the mid-market figure.
  group('what landed on the other side', () {
    testWidgets('is asked for when the two accounts differ', (tester) async {
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'bKash', currency: 'BDT');
      await pump(tester);
      await chooseTransfer(tester);

      expect(find.text('Amount received'), findsOneWidget);
    });

    testWidgets('is not asked for within one currency', (tester) async {
      await seedWallet(db, name: 'Everyday', currency: 'USD');
      await seedWallet(db, name: 'Bank', currency: 'USD');
      await pump(tester);
      await chooseTransfer(tester);

      expect(
        find.text('Amount received'),
        findsNothing,
        reason: 'one movement of one sum, seen from both ends',
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
