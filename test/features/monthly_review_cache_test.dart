import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/ai/services/monthly_review_cache.dart';

import '../helpers/test_database.dart';

/// A monthly review is written once and shown again until the transactions
/// change, so opening the screen never spends an AI call by itself.
void main() {
  late AppDatabase db;
  late String cash;
  final month = DateTime(2026, 10);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    cash = await seedWallet(db, name: 'Cash');
    await seedTransaction(db, walletId: cash, amount: 5000, title: 'Tea');
  });

  tearDown(() => db.close());

  Future<String> fp({String language = 'en'}) => MonthlyReviewCache.fingerprint(
    db,
    month: month,
    language: language,
    currency: 'BDT',
  );

  test('none until one is written', () async {
    expect(await MonthlyReviewCache.read(month, await fp()), isNull);
  });

  test('up to date while nothing changes', () async {
    await MonthlyReviewCache.save(month, await fp(), 'A calm month.');

    final saved = await MonthlyReviewCache.read(month, await fp());
    expect(saved!.text, 'A calm month.');
    expect(saved.upToDate, isTrue);
  });

  test('a new transaction makes it out of date', () async {
    await MonthlyReviewCache.save(month, await fp(), 'A calm month.');
    await seedTransaction(db, walletId: cash, amount: 9000, title: 'Lunch');

    final saved = await MonthlyReviewCache.read(month, await fp());
    expect(saved!.upToDate, isFalse);
    expect(saved.text, 'A calm month.', reason: 'still shown, marked old');
  });

  test('so does a change of language', () async {
    await MonthlyReviewCache.save(month, await fp(), 'A calm month.');

    final saved = await MonthlyReviewCache.read(
      month,
      await fp(language: 'bn'),
    );
    expect(saved!.upToDate, isFalse);
  });

  test('each month keeps its own', () async {
    await MonthlyReviewCache.save(month, await fp(), 'October.');
    expect(
      await MonthlyReviewCache.read(DateTime(2026, 9), await fp()),
      isNull,
    );
  });
}
