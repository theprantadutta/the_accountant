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
    // The whole catalogue, not just the two internal system categories —
    // `ensureSystemCategoriesExist` alone seeds only Transfer and Balance
    // Correction, which is not what a user's picker looks like.
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
