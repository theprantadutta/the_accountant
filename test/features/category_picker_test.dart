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
/// The picker used to be a three-column grid of tiles — the only screen in the
/// app that presented a list of things that way, and the reason longer names
/// like "Balance Correction" wrapped onto two lines. It is now a list of rows,
/// the same shape as every other list here.
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
  Future<void> openPicker(WidgetTester tester, {bool isIncome = false}) async {
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
                      isIncome: isIncome,
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

  testWidgets('expense categories are listed as rows', (tester) async {
    await openPicker(tester);

    expect(find.text('Select category'), findsOneWidget);
    expect(find.text('Food & Dining'), findsOneWidget);

    // Nothing income-side while the expense chip is the one selected.
    expect(find.text('Salary'), findsNothing);

    // And nothing the app keeps for its own bookkeeping. These two sort first,
    // so before they were filtered out they were the two most prominent
    // choices in the sheet.
    expect(find.text('Transfer'), findsNothing);
    expect(find.text('Balance Correction'), findsNothing);

    final list = find.byType(Scrollable).last;

    // The rest of the catalogue is below the fold — a scrolling list, not a
    // fixed grid that has to shrink its tiles to fit everything at once.
    await tester.scrollUntilVisible(
      find.text('Groceries'),
      300,
      scrollable: list,
    );
    expect(find.text('Groceries'), findsOneWidget);

    // And the way out, when none of them fit, is the last row.
    await tester.scrollUntilVisible(
      find.text('New category'),
      300,
      scrollable: list,
    );
    expect(find.text('New category'), findsOneWidget);
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
    // first two rows — always built, never merely scrolled out of view.
    await openPicker(tester);
    expect(find.text('Transfer'), findsNothing);
    expect(find.text('Balance Correction'), findsNothing);

    // Dismiss before reopening: tapping through an open sheet's barrier hits
    // nothing, and the assertions below would then be checking the first
    // sheet all over again.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Select category'), findsNothing);

    await openPicker(tester, isIncome: true);
    expect(
      find.text('Salary'),
      findsOneWidget,
      reason: 'the income sheet really is the one open now',
    );
    expect(find.text('Transfer'), findsNothing);
    expect(find.text('Balance Correction'), findsNothing);
  });

  testWidgets('switching to income swaps the list', (tester) async {
    await openPicker(tester);

    expect(find.text('Food & Dining'), findsOneWidget);

    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    expect(
      find.text('Food & Dining'),
      findsNothing,
      reason: 'the expense list should be gone, not merged with income',
    );
    expect(find.text('Salary'), findsOneWidget);
  });
}
