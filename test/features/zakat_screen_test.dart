import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';
import 'package:the_accountant/features/zakat/screens/zakat_screen.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// The Zakat screen shows the answer and lets each line be switched off.
void main() {
  late AppDatabase db;
  late String cash;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    cash = await seedWallet(db, name: 'Cash', openingBalance: 20000000);
    await ZakatSettingsStore.save(
      const ZakatSettings(silverPricePerGram: 15000),
    );
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester, {Locale? locale}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: localizedApp(
          home: const ZakatScreen(),
          locale: locale ?? const Locale('en'),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('shows what is due, and a line can be switched off', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byKey(const Key('zakat_due')), findsOneWidget);
    expect(find.text('Pay zakat'), findsOneWidget);

    final line = find.byKey(Key('zakat_line_w:$cash'));
    await tester.scrollUntilVisible(line, 200);
    await tester.tap(
      find.descendant(of: line, matching: find.byType(SunriseToggle)),
    );
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
    final saved = await tester.runAsync(ZakatSettingsStore.load);
    expect(saved!.switches, {'w:$cash': false});
  });

  testWidgets('draws in Bangla', (tester) async {
    await pump(tester, locale: const Locale('bn'));
    expect(find.text('যাকাত দিন'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
