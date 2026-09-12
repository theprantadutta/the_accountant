import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase, Wallet;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';
import '../helpers/localized_app.dart';

/// The add-transaction form when there is no account it may write to.
///
/// Archiving is not deleting: the accounts screen still lists a closed account
/// and its history still adds up, so `hasWalletsProvider` — which counts every
/// row — stays true and the app keeps showing the dashboard rather than the
/// create-first-account screen. But `selectableWalletsProvider` leaves archived
/// accounts out, which is the whole point of archiving, so somebody who has
/// closed all of their accounts reaches this form with an empty list.
///
/// It used to pick the selected chip with
/// `wallets.firstWhere(..., orElse: () => wallets.first)`, and `first` on an
/// empty list throws `Bad state: No element` — a crash, inside `build`, on the
/// screen the button the whole app is arranged around leads to. Production
/// reported it three times from one user.
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

  Future<ProviderContainer> loadedContainer() async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await container.read(walletProvider.notifier).loadWallets();
    await container.read(categoryProvider.notifier).loadCategories();
    return container;
  }

  Future<void> pump(WidgetTester tester, ProviderContainer container) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(home: const AddTransactionScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  const emptyState = 'No account to record this against';

  testWidgets('every account archived: the form says so instead of crashing', (
    tester,
  ) async {
    final id = await seedWallet(db, name: 'Everyday');

    final container = await loadedContainer();
    await container.read(walletProvider.notifier).setArchived(id, true);
    await container.read(walletProvider.notifier).loadWallets();

    // The premise of the test, stated rather than assumed: the account is still
    // there, and is no longer one the form may choose.
    expect(container.read(hasWalletsProvider), isTrue);
    expect(container.read(selectableWalletsProvider), isEmpty);

    await pump(tester, container);

    expect(tester.takeException(), isNull);
    expect(find.text(emptyState), findsOneWidget);
  });

  testWidgets('no accounts at all: the form says so instead of crashing', (
    tester,
  ) async {
    await pump(tester, await loadedContainer());

    expect(tester.takeException(), isNull);
    expect(find.text(emptyState), findsOneWidget);
  });

  testWidgets('still loading: a wait, not a dead end', (tester) async {
    // The other way an empty list reaches this screen, and the likelier one:
    // it is open before the accounts have been read back. That happens on a
    // cold start from a home-screen shortcut, which lands here directly
    // instead of passing the navigation container's wallet gate. An account
    // exists — it just is not in memory yet — so saying there is none would be
    // wrong, and offering a button to go and make one doubly so.
    final slow = SlowWalletDatabase(NativeDatabase.memory());
    addTearDown(slow.close);
    await slow.ensureSystemCategoriesExist();
    await seedWallet(slow, name: 'Everyday');

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(slow),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await container.read(categoryProvider.notifier).loadCategories();
    container.read(walletProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(home: const AddTransactionScreen()),
      ),
    );
    await tester.pump();

    expect(container.read(walletsLoadingProvider), isTrue);
    expect(tester.takeException(), isNull);
    expect(find.text(emptyState), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // And once they arrive, the form is there.
    slow.release();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Everyday (USD)'), findsOneWidget);
  });

  testWidgets('one live account still gets the ordinary form', (tester) async {
    await seedWallet(db, name: 'Everyday');

    await pump(tester, await loadedContainer());

    expect(tester.takeException(), isNull);
    expect(find.text(emptyState), findsNothing);
    expect(find.text('Everyday (USD)'), findsOneWidget);
  });
}

/// An [AppDatabase] that holds the wallet read open until told to let go.
///
/// The point is to hold the screen in the one frame the production crash came
/// out of: mounted, with the accounts not back yet.
class SlowWalletDatabase extends AppDatabase {
  SlowWalletDatabase(super.e);

  final _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<List<Wallet>> getAllWallets() async {
    await _gate.future;
    return super.getAllWallets();
  }
}
