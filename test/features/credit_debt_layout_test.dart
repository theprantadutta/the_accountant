import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/credit_debt/screens/credit_debt_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// The loan list fits on a small phone, with large text, in Bangla and on a
/// tablet: nothing overflows, and the actions stay on one line.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    final cash = await seedWallet(db, name: 'Cash');
    await seedTransaction(
      db,
      walletId: cash,
      amount: 10000000,
      title: 'Got Some Money From Vasker Sir for the office',
      date: DateTime(2025, 9, 22),
      isIncome: true,
      specialType: TransactionSpecialType.debt,
    );
    await seedTransaction(
      db,
      walletId: cash,
      amount: 20000,
      title: 'Lent Some Money to Office Cleaner',
      date: DateTime(2026, 9, 29),
      specialType: TransactionSpecialType.credit,
    );
  });

  tearDown(() async => db.close());

  const sizes = {
    'small phone': Size(320, 640),
    'phone': Size(360, 780),
    'tablet': Size(800, 1280),
  };

  for (final entry in sizes.entries) {
    for (final (scale, locale) in [
      (1.0, const Locale('en')),
      (1.3, const Locale('en')),
      (1.3, const Locale('bn')),
    ]) {
      testWidgets(
        '${entry.key}, text x$scale, ${locale.languageCode}: nothing overflows',
        (tester) async {
          tester.view.physicalSize = entry.value * 3;
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);

          final container = ProviderContainer(
            overrides: [
              databaseProvider.overrideWithValue(db),
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
          );
          addTearDown(container.dispose);
          await container.read(walletProvider.notifier).loadWallets();

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MediaQuery(
                data: MediaQueryData(
                  size: entry.value,
                  textScaler: TextScaler.linear(scale),
                ),
                child: localizedApp(
                  locale: locale,
                  home: const CreditDebtScreen(),
                ),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 600));

          expect(tester.takeException(), isNull);
          expect(find.byIcon(Icons.payments_outlined), findsWidgets);
        },
      );
    }
  }
}
