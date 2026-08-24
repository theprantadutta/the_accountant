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

  group('renames', () {
    test('a renamed built-in is still found by the name it used to have', () {
      // The schema-13 migration identifies rows by the name sitting in the
      // user's own database, which was written before any later rename. If the
      // matcher read the current display name instead, every store that had not
      // yet upgraded would have these two categories stranded without a slug —
      // and a category with no slug cannot be matched across devices.
      final lent = DefaultCategoryCatalog.byKey['loan_expense']!;
      final borrowed = DefaultCategoryCatalog.byKey['loan_income']!;

      expect(lent.name, 'Money Lent');
      expect(borrowed.name, 'Money Borrowed');
      expect(lent.nameAtSchema13, 'Loan');
      expect(borrowed.nameAtSchema13, 'Loan');

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

    test('the new names are not what a pre-slug row would be called', () {
      // Nothing in an old store is called "Money Lent", so the matcher must not
      // claim one — otherwise a user's own category by that name would be
      // adopted as a built-in.
      expect(
        DefaultCategoryCatalog.keyForLegacyDefault(
          name: 'Money Lent',
          isIncome: false,
        ),
        isNull,
      );
    });

    test('no two built-ins share a display name', () {
      // The picker shows one flat list, so a duplicate name is two rows the
      // user cannot tell apart.
      final names = DefaultCategoryCatalog.all
          .where((s) => !s.isSystem)
          .map((s) => s.name)
          .toList();
      expect(names.toSet().length, names.length, reason: names.toString());
    });
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
