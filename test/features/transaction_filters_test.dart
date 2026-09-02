import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/transactions/domain/transaction_filters.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    show Transaction;

/// Narrowing a long list down to the one row someone is looking for.
///
/// The list offered a direction and a single category, and searched by plain
/// substring. Someone hunting a payment types the amount or the month far more
/// often than part of a shop's name, and neither of those found anything.
void main() {
  Transaction txn({
    String id = 't1',
    int amount = 1000,
    String type = 'expense',
    String category = 'Food',
    String categoryId = 'cat-food',
    String walletId = 'w1',
    DateTime? date,
    String title = 'Lunch',
    String notes = '',
    String transactionType = 'regular',
    bool isPaid = true,
    bool skipPaid = false,
    TransactionSpecialType specialType = TransactionSpecialType.none,
  }) => Transaction(
    id: id,
    amount: amount,
    type: type,
    category: category,
    categoryId: categoryId,
    walletId: walletId,
    date: date ?? DateTime(2026, 3, 15),
    title: title,
    notes: notes,
    paymentMethod: '',
    transactionType: transactionType,
    isPaid: isPaid,
    skipPaid: skipPaid,
    specialType: specialType,
  );

  group('transfers', () {
    final transfer = txn(transactionType: 'transfer');

    test('are hidden by default', () {
      expect(
        TransactionFilters.none.matches(transfer),
        isFalse,
        reason:
            'a transfer is neither income nor spending, so it answers neither '
            'side of what this list is for',
      );
    });

    test('can be shown when asked for', () {
      const filters = TransactionFilters(transfers: TransferFilter.show);
      expect(filters.matches(transfer), isTrue);
      expect(filters.matches(txn()), isTrue);
    });

    test('can be the only thing shown', () {
      const filters = TransactionFilters(transfers: TransferFilter.only);
      expect(filters.matches(transfer), isTrue);
      expect(
        filters.matches(txn()),
        isFalse,
        reason:
            'a list that can never show transfers makes them impossible to '
            'find or correct',
      );
    });
  });

  group('categories', () {
    test('choosing a parent includes what is filed inside it', () {
      const filters = TransactionFilters(categoryIds: {'cat-food'});
      final sandwich = txn(categoryId: 'cat-sandwich');

      expect(
        filters.matches(
          sandwich,
          familyOf: (id) => id == 'cat-food'
              ? {'cat-food', 'cat-sandwich'}
              : {id},
        ),
        isTrue,
        reason:
            'picking Food and seeing no lunches, because they were filed under '
            'Sandwiches, reads as a broken filter',
      );
    });

    test('an unrelated category is excluded', () {
      const filters = TransactionFilters(categoryIds: {'cat-food'});
      expect(filters.matches(txn(categoryId: 'cat-travel')), isFalse);
    });
  });

  group('paid state', () {
    test('unpaid finds what has not happened yet', () {
      const filters = TransactionFilters(paid: PaidFilter.unpaid);
      expect(filters.matches(txn(isPaid: false)), isTrue);
      expect(filters.matches(txn()), isFalse);
    });

    test('skipped is its own state, not merely unpaid', () {
      const skipped = PaidFilter.skipped;
      const unpaid = PaidFilter.unpaid;
      final row = txn(isPaid: false, skipPaid: true);

      expect(TransactionFilters(paid: skipped).matches(row), isTrue);
      expect(
        TransactionFilters(paid: unpaid).matches(row),
        isFalse,
        reason:
            'deciding not to pay something is a different answer from not '
            'having paid it yet',
      );
    });
  });

  group('amount and date bounds', () {
    test('the range is inclusive at both ends', () {
      const filters = TransactionFilters(minAmount: 1000, maxAmount: 2000);
      expect(filters.matches(txn(amount: 1000)), isTrue);
      expect(filters.matches(txn(amount: 2000)), isTrue);
      expect(filters.matches(txn(amount: 999)), isFalse);
      expect(filters.matches(txn(amount: 2001)), isFalse);
    });

    test('an end date includes the whole of that day', () {
      final filters = TransactionFilters(to: DateTime(2026, 3, 15));
      expect(
        filters.matches(txn(date: DateTime(2026, 3, 15, 18, 30))),
        isTrue,
        reason:
            'someone picking "to the 15th" means the 15th, not everything '
            'before midnight that morning',
      );
      expect(filters.matches(txn(date: DateTime(2026, 3, 16))), isFalse);
    });
  });

  group('counting what is narrowed', () {
    test('an untouched filter set reads as inactive', () {
      expect(TransactionFilters.none.hasActiveFilters, isFalse);
      expect(TransactionFilters.none.activeCount, 0);
    });

    test('search alone does not light up the filter button', () {
      const filters = TransactionFilters(query: 'lunch');
      expect(
        filters.hasActiveFilters,
        isFalse,
        reason: 'the search box already shows what it is doing',
      );
    });

    test('a bound pair counts once, not twice', () {
      const filters = TransactionFilters(minAmount: 100, maxAmount: 900);
      expect(filters.activeCount, 1);
    });

    test('clearing keeps the search text', () {
      const filters = TransactionFilters(
        query: 'lunch',
        direction: DirectionFilter.income,
      );
      final cleared = filters.cleared();
      expect(cleared.query, 'lunch');
      expect(cleared.hasActiveFilters, isFalse);
    });
  });

  group('reading the search box', () {
    test('an amount is recognised and matched fuzzily', () {
      const filters = TransactionFilters(query: '37.40');
      expect(filters.matches(txn(amount: 3740, title: 'Anything')), isTrue);
      expect(filters.matches(txn(amount: 9900, title: 'Anything')), isFalse);
    });

    test('a month name finds that month', () {
      const filters = TransactionFilters(query: 'march');
      expect(filters.matches(txn(date: DateTime(2026, 3, 2))), isTrue);
      expect(filters.matches(txn(date: DateTime(2026, 4, 2))), isFalse);
    });

    test('a month and year together narrow to both', () {
      const filters = TransactionFilters(query: 'march 2025');
      expect(filters.matches(txn(date: DateTime(2025, 3, 2))), isTrue);
      expect(filters.matches(txn(date: DateTime(2026, 3, 2))), isFalse);
    });

    test('three letters are enough for a month', () {
      expect(SearchQuery.parse('mar').month, 3);
      expect(SearchQuery.parse('sep').month, 9);
    });

    test('words still match the title, notes and category', () {
      expect(
        const TransactionFilters(query: 'lunch').matches(txn(title: 'Lunch')),
        isTrue,
      );
      expect(
        const TransactionFilters(query: 'food').matches(txn(category: 'Food')),
        isTrue,
      );
      expect(
        const TransactionFilters(
          query: 'birthday',
        ).matches(txn(notes: 'For her birthday')),
        isTrue,
      );
    });

    test('a four digit number is read as a year, not an amount', () {
      final parsed = SearchQuery.parse('2026');
      expect(parsed.year, 2026);
      expect(
        parsed.amountCents,
        isNull,
        reason: 'searching 2026 almost always means the year',
      );
    });
  });
}
