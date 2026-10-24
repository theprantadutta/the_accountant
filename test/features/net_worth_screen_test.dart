import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/networth/screens/net_worth_screen.dart';
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// The net worth screen shows the figure the home card shows, each line it
/// is made of, and the user's assets with what can be done to them.
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

  testWidgets('shows the total, its lines and the assets', (tester) async {
    late String plot;
    await tester.runAsync(() async {
      final bank = await seedWallet(db, name: 'Bank', openingBalance: 100000);
      await seedTransaction(
        db,
        walletId: bank,
        amount: 20000,
        specialType: TransactionSpecialType.credit,
      );
      plot = await AssetService(db).create(
        name: 'Plot in Savar',
        kind: AssetKind.land,
        currency: 'USD',
        value: 500000,
      );
    });

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await tester.runAsync(
      () => container.read(walletProvider.notifier).loadWallets(),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(home: const NetWorthScreen()),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }

    // The bank's stored balance is the opening one here; the 200 lent is
    // still the user's, so it is added.
    expect(
      tester.widget<Text>(find.byKey(const Key('net_worth_total'))).data,
      contains('6,200'),
    );
    expect(find.byKey(const Key('net_worth_part_lent')), findsOneWidget);
    expect(find.byKey(const Key('net_worth_part_assets')), findsOneWidget);
    expect(find.byKey(const Key('net_worth_part_borrowed')), findsNothing);

    await tester.scrollUntilVisible(find.byKey(Key('asset_$plot')), 200);
    await tester.tap(find.byKey(Key('asset_$plot')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('asset_update_value')), findsOneWidget);
    expect(find.byKey(const Key('asset_sell')), findsOneWidget);
    // Worth something, so it cannot simply be removed.
    expect(find.byKey(const Key('asset_delete')), findsNothing);
  });
}
