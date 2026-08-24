import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// Offering back a title the user has typed before.
///
/// The point of the feature is to reach something entered months ago, so the
/// search runs against the database rather than a cached list of recent titles:
/// filtering the last twenty would answer for the handful of things a person
/// repeats constantly and quietly fail for everything else.
void main() {
  late AppDatabase db;
  late String wallet;
  late String food;
  late String transport;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    food = await seedCategory(db, name: 'Food & Dining');
    transport = await seedCategory(db, name: 'Transportation');
  });

  tearDown(() async => db.close());

  Future<void> spend(
    String title, {
    String? categoryId,
    DateTime? on,
    String type = 'regular',
    String? feeFor,
  }) async {
    await seedTransaction(
      db,
      walletId: wallet,
      categoryId: categoryId,
      title: title,
      date: on ?? DateTime(2026, 6, 1),
      transactionType: type,
    );
    if (feeFor != null) {
      // seedTransaction has no fee link; set it directly.
      await db.customStatement(
        'UPDATE transactions SET fee_for_transaction_id = ? WHERE title = ?',
        [feeFor, title],
      );
    }
  }

  test('a past title is found from the start of a word', () async {
    await spend('Went to office', categoryId: transport);

    final hits = await db.searchTitleUsages('went');
    expect(hits.map((h) => h.title), ['Went to office']);
    expect(hits.single.categoryId, transport);
  });

  test('matching is case-insensitive and can start mid-title', () async {
    await spend('Went to office', categoryId: transport);

    expect((await db.searchTitleUsages('OFFICE')).single.title,
        'Went to office');
    expect((await db.searchTitleUsages('to off')).single.title,
        'Went to office');
  });

  test('a title far outside the recent handful is still reachable', () async {
    // The old implementation kept the twenty most-used titles in memory and
    // searched those. Anything rarer was invisible, which is the case this
    // pins: one lunch a year ago, behind thirty other things.
    for (var i = 0; i < 30; i++) {
      await spend('Coffee $i', categoryId: food);
    }
    await spend('Went to office', categoryId: transport);

    final hits = await db.searchTitleUsages('went');
    expect(hits.map((h) => h.title), ['Went to office']);
  });

  test('the same title used repeatedly is offered before rarer ones', () async {
    await spend('Lunch at Dishoom', categoryId: food, on: DateTime(2026, 1, 1));
    await spend('Lunch at Dishoom', categoryId: food, on: DateTime(2026, 2, 1));
    await spend('Lunch at Dishoom', categoryId: food, on: DateTime(2026, 3, 1));
    await spend('Lunch alone', categoryId: food, on: DateTime(2026, 4, 1));

    final hits = await db.searchTitleUsages('lunch');
    expect(hits.first.title, 'Lunch at Dishoom');
    expect(hits.first.useCount, 3);
    expect(hits.last.title, 'Lunch alone');
  });

  test('one entry per title, not one per transaction', () async {
    await spend('Coffee', categoryId: food, on: DateTime(2026, 1, 1));
    await spend('Coffee', categoryId: food, on: DateTime(2026, 2, 1));

    expect(await db.searchTitleUsages('coffee'), hasLength(1));
  });

  test('the category offered is the one most recently used', () async {
    // People re-file things. The suggestion should follow the latest decision,
    // not the first one.
    await spend('Corner shop', categoryId: food, on: DateTime(2026, 1, 1));
    await spend('Corner shop', categoryId: transport, on: DateTime(2026, 5, 1));

    expect((await db.searchTitleUsages('corner')).single.categoryId, transport);
  });

  test('transfers are never offered as titles', () async {
    // Both legs are titled by the app, and the category they carry is the one
    // the app keeps for its own bookkeeping — filing a purchase under it would
    // quietly corrupt the totals.
    await spend('Transfer', type: 'transfer');

    expect(await db.searchTitleUsages('trans'), isEmpty);
  });

  test('a transfer fee is not offered either', () async {
    await spend('Fee: Transfer', categoryId: food, feeFor: 'some-transfer-id');

    expect(await db.searchTitleUsages('fee'), isEmpty);
  });

  test('deleted transactions are forgotten', () async {
    await spend('Cancelled thing', categoryId: food);
    await db.customStatement(
      "UPDATE transactions SET deleted_at = 1 WHERE title = 'Cancelled thing'",
    );

    expect(await db.searchTitleUsages('cancelled'), isEmpty);
  });

  test('an empty query asks for nothing', () async {
    await spend('Went to office', categoryId: transport);

    expect(await db.searchTitleUsages(''), isEmpty);
    expect(await db.searchTitleUsages('   '), isEmpty);
  });

  test('a wildcard typed by the user is matched literally', () async {
    // '%' means "anything" to LIKE. Typed into a search box it means a percent
    // sign, and treating it as a wildcard would return the user's whole history.
    await spend('Went to office', categoryId: transport);
    await spend('50% off sale', categoryId: food);

    final hits = await db.searchTitleUsages('%');
    expect(hits.map((h) => h.title), ['50% off sale']);
  });

  test('results are capped', () async {
    for (var i = 0; i < 20; i++) {
      await spend('Coffee $i', categoryId: food);
    }

    expect((await db.searchTitleUsages('coffee', limit: 5)), hasLength(5));
  });
}
