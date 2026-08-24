import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show AppDatabase;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';

import '../helpers/test_database.dart';

/// Choosing what a transaction was for.
///
/// One flat list, four tiles to a row. There used to be two lists and a toggle
/// between them, which meant maintaining a category twice to use it on both
/// sides and picking from the wrong one when the toggle disagreed with the
/// form. A category is a label for what something was; whether the money came
/// in or went out is recorded on the transaction.
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = openTestDatabase();
    // Seeded the way the app seeds: the system categories first, then the rest.
    // `getAllCategories` applies no ORDER BY, so rows come back in insertion
    // order and this is what puts Transfer and Balance Correction at the top of
    // the sheet — which is the position that made listing them a problem, and
    // the position the assertions below depend on.
    await db.ensureSystemCategoriesExist();
    await db.ensureDefaultCategories(DefaultCategoryCatalog.all);
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    await container.read(categoryProvider.notifier).loadCategories();
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  /// Whatever the sheet resolves to once it closes.
  Future<Category?>? picked;

  /// Opens the sheet. Awaiting this returns when the sheet is on screen, not
  /// when it closes — [picked] is the future for that.
  Future<void> openPicker(WidgetTester tester) async {
    // A phone-shaped surface. The default 800x600 test window is wider than it
    // is tall, which makes the grid cells enormous and only a row and a half
    // fit — nothing like what a reader of these assertions would picture.
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () {
                    picked = showCategoryPickerSheet(
                      context: context,
                      ref: ref,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('every category is offered, whichever way money went', (
    tester,
  ) async {
    await openPicker(tester);

    expect(find.text('Select category'), findsOneWidget);

    // One list: what used to be the expense side and what used to be the
    // income side, together.
    expect(find.text('Food & Dining'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);

    // And nothing the app keeps for its own bookkeeping. These two are seeded
    // first and the query applies no ordering, so before they were filtered
    // out they were the first two tiles in the sheet.
    expect(find.text('Transfer'), findsNothing);
    expect(find.text('Balance Correction'), findsNothing);

    // Four to a row puts a lot of the catalogue on screen at once.
    expect(find.text('Groceries'), findsOneWidget);

    // The way out, when none of them fit, is the tile after the last category.
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('New'), 300, scrollable: list);
    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('the chosen category is what comes back', (tester) async {
    await openPicker(tester);

    await tester.tap(find.text('Food & Dining'));
    await tester.pumpAndSettle();

    final chosen = await picked!;
    expect(chosen, isNotNull);
    expect(chosen!.name, 'Food & Dining');
    expect(chosen.isIncome, isFalse);
  });

  testWidgets('bookkeeping categories are never offered to the user', (
    tester,
  ) async {
    // They exist in the store — the app writes to them when it moves money
    // between wallets or reconciles a balance — so the assertions below fail
    // for the right reason rather than because nothing was seeded.
    expect(
      container
          .read(categoryProvider)
          .categories
          .where((c) => c.isSystem)
          .map((c) => c.name),
      containsAll(<String>['Transfer', 'Balance Correction']),
    );

    // They were inserted first, so if the picker listed them they would be its
    // first two tiles — always built, never merely scrolled out of view.
    await openPicker(tester);
    expect(find.text('Transfer'), findsNothing);
    expect(find.text('Balance Correction'), findsNothing);

    // Nor anywhere further down the one list everything now lives in.
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('New'), 300, scrollable: list);
    expect(find.text('Transfer'), findsNothing);
    expect(find.text('Balance Correction'), findsNothing);
  });

  testWidgets('the two loan categories can be told apart', (tester) async {
    // Both were called "Loan" and were distinguishable only by which side of
    // the ledger they sat on — precisely the thing that stopped being shown.
    // In one flat list that was two tiles nobody could choose between.
    await openPicker(tester);

    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.text('Money Borrowed'),
      300,
      scrollable: list,
    );

    expect(find.text('Money Lent'), findsOneWidget);
    expect(find.text('Money Borrowed'), findsOneWidget);
    expect(find.text('Loan'), findsNothing);
  });
}
