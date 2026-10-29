import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Managing subcategories: taking one out of its parent, putting it in
/// another, refiling a category's transactions, and deleting a parent.
///
/// Subcategories could be made but not managed. A subcategory could never be
/// taken back out of its parent, moving transactions meant editing each one,
/// and deleting a parent left its subcategories inside a category that no
/// longer existed.
void main() {
  late AppDatabase db;
  late String wallet;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    wallet = await seedWallet(db);
  });

  tearDown(() => db.close());

  group('setCategoryParent', () {
    test('moves a subcategory into another parent and back out', () async {
      final food = await seedCategory(db, name: 'Food');
      final transport = await seedCategory(db, name: 'Transport');
      final rickshaw = await seedCategory(
        db,
        name: 'Rickshaw',
        mainCategoryId: food,
        syncStatus: SyncStatus.synced,
      );

      await db.setCategoryParent(rickshaw, transport);
      var row = (await db.findCategoryById(rickshaw))!;
      expect(row.mainCategoryId, transport);
      expect(row.syncStatus, SyncStatus.pendingUpdate);

      await db.setCategoryParent(rickshaw, null);
      row = (await db.findCategoryById(rickshaw))!;
      expect(row.mainCategoryId, isNull);
    });

    test('keeps categories one level deep', () async {
      final food = await seedCategory(db, name: 'Food');
      final lunch = await seedCategory(db, name: 'Lunch', mainCategoryId: food);
      final travel = await seedCategory(db, name: 'Travel');

      // Into a subcategory.
      await expectLater(
        db.setCategoryParent(travel, lunch),
        throwsArgumentError,
      );
      // A parent into anything.
      await expectLater(
        db.setCategoryParent(food, travel),
        throwsArgumentError,
      );
      // Into itself.
      await expectLater(db.setCategoryParent(food, food), throwsArgumentError);
    });

    test('refuses mixing income with spending, and the app own', () async {
      final food = await seedCategory(db, name: 'Food');
      final salary = await seedCategory(db, name: 'Salary', isIncome: true);
      final transfer = await db.requireSystemCategoryId(
        SystemCategoryKeys.transfer,
      );

      await expectLater(
        db.setCategoryParent(salary, food),
        throwsArgumentError,
      );
      await expectLater(
        db.setCategoryParent(food, transfer),
        throwsArgumentError,
      );
      await expectLater(
        db.setCategoryParent(transfer, food),
        throwsArgumentError,
      );
    });
  });

  group('moveCategoryTransactions', () {
    test('refiles live rows and keeps both categories', () async {
      final eatingOut = await seedCategory(db, name: 'Eating out');
      final food = await seedCategory(db, name: 'Food');
      final a = await seedTransaction(
        db,
        walletId: wallet,
        categoryId: eatingOut,
        syncStatus: SyncStatus.synced,
      );
      final b = await seedTransaction(
        db,
        walletId: wallet,
        categoryId: eatingOut,
      );
      final binned = await seedTransaction(
        db,
        walletId: wallet,
        categoryId: eatingOut,
      );
      await (db.update(db.transactions)..where((t) => t.id.equals(binned)))
          .write(TransactionsCompanion(deletedAt: Value(DateTime.now())));

      final moved = await db.moveCategoryTransactions(
        sourceId: eatingOut,
        targetId: food,
      );

      expect(moved, 2);
      expect((await db.findTransactionById(a))!.categoryId, food);
      expect(
        (await db.findTransactionById(a))!.syncStatus,
        SyncStatus.pendingUpdate,
      );
      // Never uploaded, so still a create.
      expect(
        (await db.findTransactionById(b))!.syncStatus,
        SyncStatus.pendingCreate,
      );
      // Restoring it from Recently deleted puts it back where it was.
      expect((await db.findTransactionById(binned))!.categoryId, eatingOut);
      expect((await db.findCategoryById(eatingOut))!.deletedAt, isNull);
    });

    test('refuses income into spending and the app own', () async {
      final food = await seedCategory(db, name: 'Food');
      final salary = await seedCategory(db, name: 'Salary', isIncome: true);
      final correction = await db.requireSystemCategoryId(
        SystemCategoryKeys.balanceCorrection,
      );

      await expectLater(
        db.moveCategoryTransactions(sourceId: food, targetId: salary),
        throwsArgumentError,
      );
      await expectLater(
        db.moveCategoryTransactions(sourceId: correction, targetId: food),
        throwsArgumentError,
      );
    });

    test('counts what each category holds', () async {
      final food = await seedCategory(db, name: 'Food');
      await seedTransaction(db, walletId: wallet, categoryId: food);
      await seedTransaction(db, walletId: wallet, categoryId: food);

      final counts = await db.liveTransactionCountsByCategory();
      expect(counts[food], 2);
    });
  });

  test('deleting a parent lifts its subcategories to the top', () async {
    final food = await seedCategory(db, name: 'Food');
    final lunch = await seedCategory(
      db,
      name: 'Lunch',
      mainCategoryId: food,
      syncStatus: SyncStatus.synced,
    );

    await db.softDeleteCategory(food);

    final row = (await db.findCategoryById(lunch))!;
    expect(row.mainCategoryId, isNull);
    expect(row.deletedAt, isNull);
    expect(row.syncStatus, SyncStatus.pendingUpdate);
  });

  test('a moved subcategory and its refiled rows reach the server', () async {
    final server = FakeSyncServer();
    await db.claimLocalStore(userId: 'u');
    final sync = SyncService(
      database: db,
      transport: FakeSyncTransport(server: server, userId: 'u'),
    );
    final food = await seedCategory(db, name: 'Food');
    final transport = await seedCategory(db, name: 'Transport');
    final rickshaw = await seedCategory(
      db,
      name: 'Rickshaw',
      mainCategoryId: food,
    );
    final txn = await seedTransaction(db, walletId: wallet, categoryId: food);
    expect((await sync.syncAll()).success, isTrue);

    await db.setCategoryParent(rickshaw, transport);
    await db.moveCategoryTransactions(sourceId: food, targetId: rickshaw);
    final result = await sync.syncAll();

    expect(result.success, isTrue, reason: result.userMessage);
    final onServer = server
        .recordsIn('u', 'categories')
        .singleWhere((r) => r['Id'] == rickshaw);
    expect(onServer['MainCategoryId'], transport);
    final row = server
        .recordsIn('u', 'transactions')
        .singleWhere((r) => r['Id'] == txn);
    expect(row['CategoryId'], rickshaw);
  });
}
