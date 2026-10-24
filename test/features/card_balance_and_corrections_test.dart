import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    as ui;
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// A card tracked as the credit left on it, and a limit rise recorded as
/// income, both read as money the user had: a card counting down from its
/// limit showed 95,310 "on the card" while 254,000 was owed, and the net worth
/// and the coach both counted it as savings.
///
/// The fix is to say what things are rather than rewrite history: an account
/// can become a card, its balance is read the way its owner kept it, the
/// change is recorded as a correction, and a row that was neither earned nor
/// spent can be marked as one.
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<Transaction> row(String id) async =>
      (await db.findTransactionById(id))!;

  group('marking a row as a balance correction', () {
    test(
      'keeps the money where it is and stops it counting as income',
      () async {
        final wallet = await seedWallet(db, name: 'Card');
        final salary = await seedCategory(db, name: 'Card costs');
        final id = await seedTransaction(
          db,
          walletId: wallet,
          categoryId: salary,
          amount: 20004800,
          isIncome: true,
          title: 'Got New Credit',
          syncStatus: SyncStatus.synced,
        );
        final before = await row(id);
        expect(TransactionPolicy.totalIncome([before]), 20004800);

        final done = await container
            .read(ui.transactionProvider.notifier)
            .markAsCorrection(id);

        final after = await row(id);
        expect(done, isTrue);
        expect(TransactionPolicy.isAdjustment(after), isTrue);
        expect(TransactionPolicy.totalIncome([after]), 0);
        expect(
          TransactionPolicy.walletBalanceEffect(after),
          TransactionPolicy.walletBalanceEffect(before),
        );
        expect(after.amount, before.amount);
        expect(after.syncStatus, SyncStatus.pendingUpdate);
        expect(
          after.categoryId,
          await db.requireSystemCategoryId(
            SystemCategoryKeys.balanceCorrection,
          ),
        );
      },
    );

    test('is not offered for loans, transfers or corrections', () async {
      final wallet = await seedWallet(db);
      final correction = await db.requireSystemCategoryId(
        SystemCategoryKeys.balanceCorrection,
      );
      Future<Transaction> seeded({
        String type = 'regular',
        TransactionSpecialType special = TransactionSpecialType.none,
      }) async => row(
        await seedTransaction(
          db,
          walletId: wallet,
          transactionType: type,
          specialType: special,
          // What makes a row a correction is where it is filed.
          categoryId: type == 'adjustment' ? correction : null,
        ),
      );

      expect(
        ui.TransactionNotifier.canMarkAsCorrection(await seeded()),
        isTrue,
      );
      expect(
        ui.TransactionNotifier.canMarkAsCorrection(
          await seeded(special: TransactionSpecialType.debt),
        ),
        isFalse,
      );
      expect(
        ui.TransactionNotifier.canMarkAsCorrection(
          await seeded(type: 'transfer'),
        ),
        isFalse,
      );
      expect(
        ui.TransactionNotifier.canMarkAsCorrection(
          await seeded(type: 'adjustment'),
        ),
        isFalse,
      );
    });
  });

  group('saving an edited account', () {
    test('records a new balance as a correction, not an overwrite', () async {
      final id = await seedWallet(db, name: 'SCB', openingBalance: 9531048);
      await container.read(walletProvider.notifier).loadWallets();
      final wallet = (await db.findWalletById(id))!;

      await container
          .read(walletProvider.notifier)
          .saveEdits(
            wallet: wallet,
            name: 'SCB',
            currency: wallet.currency,
            iconName: wallet.iconName,
            color: wallet.color,
            isDefault: false,
            useDecimals: true,
            walletType: WalletType.creditCard,
            creditLimit: 34930000,
            billingCycleDay: null,
            balance: -25398952,
          );

      final saved = (await db.findWalletById(id))!;
      expect(saved.walletType, WalletType.creditCard);
      expect(saved.creditLimit, 34930000);
      expect(saved.balance, -25398952);

      final corrections = (await db.getAllTransactions())
          .where((t) => t.walletId == id)
          .toList();
      expect(corrections, hasLength(1));
      expect(TransactionPolicy.isAdjustment(corrections.single), isTrue);
      expect(corrections.single.amount, 34930000);
      expect(TransactionPolicy.countsInAnalytics(corrections.single), isFalse);
    });

    test('leaves the history alone when the balance is unchanged', () async {
      final id = await seedWallet(db, openingBalance: 5000);
      final wallet = (await db.findWalletById(id))!;

      await container
          .read(walletProvider.notifier)
          .saveEdits(
            wallet: wallet,
            name: 'Renamed',
            currency: wallet.currency,
            iconName: wallet.iconName,
            color: wallet.color,
            isDefault: false,
            useDecimals: true,
            walletType: WalletType.bankAccount,
            creditLimit: null,
            billingCycleDay: null,
            balance: 5000,
          );

      expect((await db.findWalletById(id))!.name, 'Renamed');
      expect(
        (await db.getAllTransactions()).where((t) => t.walletId == id),
        isEmpty,
      );
    });
  });

  group('turning an account into a card', () {
    Future<int?> submitAsCard(
      WidgetTester tester, {
      required String meaning,
    }) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.reset);

      int? submitted;
      var called = false;
      final balance = TextEditingController(text: '95310.48');
      await tester.pumpWidget(
        ProviderScope(
          child: localizedApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AddWalletForm(
                  formKey: GlobalKey<FormState>(),
                  nameController: TextEditingController(text: 'SCB'),
                  balanceController: balance,
                  initialCurrency: 'BDT',
                  initialWalletType: WalletType.bankAccount,
                  isEditing: true,
                  onSubmit:
                      ({
                        required String currency,
                        required String icon,
                        required String color,
                        required bool isDefault,
                        required bool useDecimals,
                        required WalletType walletType,
                        required double? creditLimit,
                        required int? billingCycleDay,
                        required int? paymentDueDay,
                        required int dueReminderDays,
                        required int? balance,
                      }) {
                        called = true;
                        submitted = balance;
                      },
                  onCancel: () {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.ensureVisible(find.text('Credit Card'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Credit Card'));
      await tester.pumpAndSettle();

      // Nothing is shown as owed until the balance has been explained, and
      // the question names the amount the way the app writes money.
      expect(balance.text, isEmpty);
      expect(find.text('What is ৳95,310.48 on this card?'), findsOneWidget);
      await tester.enterText(
        find.descendant(
          of: find.widgetWithText(NeoTextField, 'Credit Limit'),
          matching: find.byType(TextFormField),
        ),
        '349300',
      );
      await tester.pumpAndSettle();

      // Saving before saying what the balance was is refused.
      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(called, isFalse);
      expect(find.textContaining('Choose what this amount is'), findsOneWidget);

      await tester.tap(find.text(meaning));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(called, isTrue);
      return submitted;
    }

    testWidgets('credit left on the card is read against the limit', (
      tester,
    ) async {
      // 349,300 limit with 95,310.48 left: 253,989.52 owed.
      expect(
        await submitAsCard(tester, meaning: 'Credit I have left'),
        -25398952,
      );
    });

    testWidgets('a balance that was what is owed stays the debt', (
      tester,
    ) async {
      expect(await submitAsCard(tester, meaning: 'What I owe'), -9531048);
    });
  });
}
