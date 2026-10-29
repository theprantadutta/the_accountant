import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/categories/screens/category_management_screen.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// The categories screen opens on the top level; a category with
/// subcategories opens onto them, and they onto theirs.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late String food;
  late String outside;
  late String coffee;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = openTestDatabase();
    food = await seedCategory(db, name: 'Food');
    outside = await seedCategory(db, name: 'Eating out', mainCategoryId: food);
    coffee = await seedCategory(db, name: 'Coffee', mainCategoryId: outside);
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    await container.read(categoryProvider.notifier).loadCategories();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(home: const CategoryManagementScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> open(WidgetTester tester, String id) async {
    await tester.tap(find.byKey(Key('category_expand_$id')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('only the top level at first', (tester) async {
    await pump(tester);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Eating out'), findsNothing);
    expect(find.byKey(Key('category_expand_$food')), findsOneWidget);
  });

  testWidgets('each level opens onto the next, and closes', (tester) async {
    await pump(tester);

    await open(tester, food);
    expect(find.text('Eating out'), findsOneWidget);
    expect(find.text('Coffee'), findsNothing);

    await open(tester, outside);
    expect(find.text('Coffee'), findsOneWidget);
    expect(find.byKey(Key('category_expand_$coffee')), findsNothing);

    await open(tester, food);
    expect(find.text('Eating out'), findsNothing);
    expect(find.text('Coffee'), findsNothing);
  });
}
