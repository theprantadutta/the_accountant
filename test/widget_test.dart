// App-launch smoke test.
//
// This used to fail before reaching a single assertion: constructing
// `AnalyticsService` touched `FirebaseAnalytics.instance`, which throws
// `[core/no-app]` when no Firebase app has been initialized, so the whole suite
// could not start. Analytics now resolves Firebase lazily behind a guard and can
// be switched off outright, and the app's other host dependencies (the local
// database, SharedPreferences, the .env config) are injected here rather than
// reached for globally.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_accountant/app/app.dart';
import 'package:the_accountant/core/providers/account_store_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/premium/providers/iap_provider.dart';

import 'helpers/test_database.dart';

/// Free-tier IAP state with no network access.
class _StubIapNotifier extends StateNotifier<IAPState> implements IAPNotifier {
  _StubIapNotifier() : super(const IAPState(isLoading: false));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // No Firebase app in tests; analytics degrades to a no-op.
    AnalyticsService.disabled = true;
    dotenv.loadFromString(envString: 'API_BASE_URL_DEV=http://localhost:8002');
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
    AnalyticsService.disabled = false;
  });

  testWidgets('App launches without Firebase', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
          localStoreManagerProvider.overrideWithValue(LocalStoreManager(prefs)),
          // The IAP notifier calls the subscription-status endpoint from its
          // constructor. A smoke test has no backend, and the in-flight HTTP
          // timer would outlive the test, so the purchase layer is stubbed with
          // a free-tier state.
          iapNotifierProvider.overrideWith((ref) => _StubIapNotifier()),
        ],
        child: const MyApp(),
      ),
    );

    // One frame is enough to prove the widget tree builds; pumpAndSettle would
    // hang on the app's ambient background animation.
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
