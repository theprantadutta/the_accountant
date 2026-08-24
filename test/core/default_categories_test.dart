import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';

/// Slugs are the permanent cross-device identity of a built-in category.
///
/// Renaming one orphans every row that already carries it and re-creates the
/// category as a duplicate on the next sync — for every user, silently. This
/// golden list exists so that can only ever happen deliberately.
const _pinnedSlugs = <String>[
  // Expenses
  'food_dining',
  'transportation',
  'shopping',
  'entertainment',
  'bills_utilities',
  'healthcare',
  'education',
  'travel',
  'groceries',
  'rent',
  'insurance',
  'personal_care',
  'subscriptions',
  'gifts_donations',
  'loan_expense',
  'loan_payment',
  'other_expenses',
  'fees_charges',
  // Income
  'salary',
  'freelance',
  'business',
  'investment',
  'rental_income',
  'bonus',
  'gift_received',
  'refund',
  'loan_income',
  'loan_received',
  'other_income',
  // System
  'transfer',
  'balance_correction',
];

void main() {
  test('the built-in slugs are exactly the pinned set', () {
    expect(
      DefaultCategoryCatalog.all.map((s) => s.key).toList(),
      _pinnedSlugs,
      reason:
          'changing or reordering a slug breaks the identity of an existing '
          "category for every user. Add new entries at the end; don't rename.",
    );
  });

  test('slugs are unique', () {
    final keys = DefaultCategoryCatalog.all.map((s) => s.key).toList();
    expect(keys.toSet(), hasLength(keys.length));
  });

  test('byKey covers every entry', () {
    expect(
      DefaultCategoryCatalog.byKey.keys.toSet(),
      DefaultCategoryCatalog.all.map((s) => s.key).toSet(),
    );
  });

  test('the system slugs are part of the catalogue', () {
    for (final key in SystemCategoryKeys.all) {
      final spec = DefaultCategoryCatalog.byKey[key];
      expect(spec, isNotNull, reason: '$key must be resolvable');
      expect(spec!.isSystem, isTrue);
    }
  });

  group('legacy name matching', () {
    test('resolves a pre-slug default by name and direction', () {
      expect(
        DefaultCategoryCatalog.keyForLegacyDefault(
          name: 'Food & Dining',
          isIncome: false,
        ),
        'food_dining',
      );
    });

    test('the two "Loan" built-ins are told apart by direction', () {
      // Both are called "Loan"; only the direction distinguishes them, which is
      // why the migration matches on both.
      expect(
        DefaultCategoryCatalog.keyForLegacyDefault(
          name: 'Loan',
          isIncome: false,
        ),
        'loan_expense',
      );
      expect(
        DefaultCategoryCatalog.keyForLegacyDefault(
          name: 'Loan',
          isIncome: true,
        ),
        'loan_income',
      );
    });

    test('an unrecognised name resolves to nothing', () {
      expect(
        DefaultCategoryCatalog.keyForLegacyDefault(
          name: 'Something the user invented',
          isIncome: false,
        ),
        isNull,
        reason:
            'guessing here would claim a user category as a built-in and merge '
            'it away',
      );
    });

    test('a name that matches only in the other direction is not claimed', () {
      expect(
        DefaultCategoryCatalog.keyForLegacyDefault(
          name: 'Salary',
          isIncome: false,
        ),
        isNull,
      );
    });
  });
}
