import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/category_reconciliation_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// A fresh device meeting an account that predates category slugs.
///
/// The account's cloud "Groceries" has `default_key = NULL` — the server-side
/// reconciliation migration could not claim it, because `is_default` did not
/// exist server-side until the migration immediately before, so every
/// pre-existing row reads `false`. A newly installed device seeds its own
/// slugged "Groceries" and pushes it before it has pulled anything.
///
/// The app cannot tell from the data whether the cloud row is the same category
/// or one the user typed themselves, and both wrong answers are bad: silently
/// merging rewrites the category on somebody's real transactions, and silently
/// creating leaves the account with two. So it asks — and until it is answered,
/// nothing is created, nothing is merged, and nothing is retried into a
/// permanent stream of failures.
void main() {
  late FakeSyncServer server;
  late AppDatabase device;
  const userId = 'legacy-user';
  const legacyCategoryId = 'cloud-groceries';

  SyncService syncFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: userId),
  );

  /// Puts the account into exactly the state the applied migrations leave it in:
  /// a live category with a real name, `is_default = false`, and
  /// `default_key = NULL`.
  Future<void> seedLegacyCloudCategory({
    String name = 'Groceries',
    bool isIncome = false,
    int transactionCount = 0,
  }) async {
    final staging = openTestDatabase();
    await staging.claimLocalStore(userId: userId);
    final walletId = await seedWallet(staging, name: 'Cloud wallet');
    await seedCategory(
      staging,
      id: legacyCategoryId,
      name: name,
      isIncome: isIncome,
      // The two facts that define the problem.
      isDefault: false,
      defaultKey: null,
    );
    for (var i = 0; i < transactionCount; i++) {
      await seedTransaction(
        staging,
        walletId: walletId,
        categoryId: legacyCategoryId,
        title: 'Old shop $i',
      );
    }
    await syncFor(staging).syncAll();
    await staging.close();
  }

  /// What a fresh install does: seed the built-in locally, then sync.
  Future<String> seedProvisionalGroceries(AppDatabase db) async {
    final id = await seedCategory(
      db,
      name: 'Groceries',
      isDefault: true,
      defaultKey: 'groceries',
    );
    return id;
  }

  setUp(() async {
    server = FakeSyncServer();
    device = openTestDatabase();
    await device.claimLocalStore(userId: userId);
  });

  tearDown(() async {
    await device.close();
  });

  Future<List<PendingCategoryReconciliation>> questionsOn(AppDatabase db) =>
      CategoryReconciliationService(db).list();

  // ---------------------------------------------------------------- scenario 1
  test(
    'a legacy cloud category is never silently classified, merged, or deleted',
    () async {
      await seedLegacyCloudCategory(transactionCount: 3);

      final provisionalId = await seedProvisionalGroceries(device);
      await syncFor(device).syncAll();

      // The legacy row is untouched: still live, still un-slugged, still holding
      // its transactions.
      final cloud = server
          .recordsIn(userId, 'categories')
          .firstWhere((c) => c['Id'] == legacyCategoryId);
      expect(cloud['DefaultKey'], isNull);
      expect(cloud['IsDefault'], isFalse);
      expect(server.countIn(userId, 'transactions'), 3);

      // And no second "groceries" was created behind the user's back.
      final slugged = server
          .recordsIn(userId, 'categories')
          .where((c) => c['DefaultKey'] == 'groceries');
      expect(slugged, isEmpty);

      // The provisional copy is still here, still a pending create — not
      // downgraded to an update the server has no row for.
      final local = await device.findCategoryById(provisionalId);
      expect(local, isNotNull);
      expect(local!.syncStatus, SyncStatus.pendingCreate);

      // The question is on record, with the history attached so the user can
      // actually tell which category this is.
      final questions = await questionsOn(device);
      expect(questions, hasLength(1));
      expect(questions.single.defaultKey, 'groceries');
      expect(questions.single.isAwaitingUser, isTrue);
      expect(questions.single.candidates.single.id, legacyCategoryId);
      expect(questions.single.candidates.single.transactionCount, 3);
    },
  );

  // ---------------------------------------------------------------- scenario 2
  test('an unresolved question does not fail again on every later sync', () async {
    await seedLegacyCloudCategory();
    await seedProvisionalGroceries(device);

    final first = await syncFor(device).syncAll();
    expect(first.conflicts.where((c) => c.tableName == 'categories'), hasLength(1));

    // Three more syncs: the held-back record is not re-offered, so the user is
    // not shown a permanent stream of failures for a question they have already
    // been asked.
    for (var i = 0; i < 3; i++) {
      final later = await syncFor(device).syncAll();
      expect(
        later.conflicts.where(
          (c) =>
              c.code == SyncConflictCodes.legacyCategoryReconciliationRequired,
        ),
        isEmpty,
        reason: 'sync ${i + 2} should not re-push the blocked category',
      );
    }

    // Still exactly one open question, and still exactly one local copy.
    expect(await questionsOn(device), hasLength(1));
    final groceries = (await device.getAllCategories()).where(
      (c) => c.defaultKey == 'groceries',
    );
    expect(groceries, hasLength(1));
  });

  // ---------------------------------------------------------------- scenario 3
  test(
    'adopting the legacy category keeps its id, history, and subcategories',
    () async {
      await seedLegacyCloudCategory(transactionCount: 2);

      final provisionalId = await seedProvisionalGroceries(device);
      await syncFor(device).syncAll();

      // A subcategory and a learned title the user created against the
      // provisional copy while the question was open.
      final subId = await seedCategory(device, name: 'Fruit');
      await (device.update(
        device.categories,
      )..where((c) => c.id.equals(subId))).write(
        CategoriesCompanion(mainCategoryId: Value(provisionalId)),
      );
      await device
          .into(device.associatedTitles)
          .insert(
            AssociatedTitlesCompanion.insert(
              id: 'title-corner-shop',
              title: 'corner shop',
              categoryId: provisionalId,
            ),
          );

      await CategoryReconciliationService(device).adoptExisting(
        defaultKey: 'groceries',
        candidateId: legacyCategoryId,
      );
      await syncFor(device).syncAll();

      // The legacy row IS the built-in now — same id, so every cloud
      // transaction that already pointed at it still does.
      final cloud = server
          .recordsIn(userId, 'categories')
          .firstWhere((c) => c['Id'] == legacyCategoryId);
      expect(cloud['DefaultKey'], 'groceries');
      expect(cloud['IsDefault'], isTrue);
      expect(server.countIn(userId, 'transactions'), 2);

      // Exactly one category holds the slug, on the server and locally.
      expect(
        server.recordsIn(userId, 'categories').where(
          (c) => c['DefaultKey'] == 'groceries',
        ),
        hasLength(1),
      );
      final local = (await device.getAllCategories())
          .where((c) => c.defaultKey == 'groceries')
          .toList();
      expect(local, hasLength(1));
      expect(local.single.id, legacyCategoryId);

      // The provisional copy is gone, and everything attached to it moved.
      expect(await device.findCategoryById(provisionalId), isNull);
      final sub = await device.findCategoryById(subId);
      expect(sub!.mainCategoryId, legacyCategoryId);
      final titles = await device.select(device.associatedTitles).get();
      expect(titles.single.categoryId, legacyCategoryId);

      // And the question is closed.
      expect(await questionsOn(device), isEmpty);
    },
  );

  // ---------------------------------------------------------------- scenario 4
  test('keeping it custom creates a separate built-in and touches nothing else', () async {
    await seedLegacyCloudCategory(transactionCount: 2);

    final provisionalId = await seedProvisionalGroceries(device);
    await syncFor(device).syncAll();

    await CategoryReconciliationService(
      device,
    ).keepSeparate(defaultKey: 'groceries');
    await syncFor(device).syncAll();

    // The user's own category is exactly as it was.
    final legacy = server
        .recordsIn(userId, 'categories')
        .firstWhere((c) => c['Id'] == legacyCategoryId);
    expect(legacy['DefaultKey'], isNull);
    expect(legacy['IsDefault'], isFalse);
    expect(server.countIn(userId, 'transactions'), 2);

    // The built-in now exists alongside it, under the id this device chose.
    final builtIn = server
        .recordsIn(userId, 'categories')
        .where((c) => c['DefaultKey'] == 'groceries')
        .toList();
    expect(builtIn, hasLength(1));
    expect(builtIn.single['Id'], provisionalId);

    // Two categories named Groceries, which is precisely what the user asked
    // for.
    expect(
      server.recordsIn(userId, 'categories').where(
        (c) => c['Name'] == 'Groceries',
      ),
      hasLength(2),
    );
    expect(await questionsOn(device), isEmpty);
  });

  // ---------------------------------------------------------------- scenario 5
  test(
    'records entered offline against the provisional category survive and sync',
    () async {
      await seedLegacyCloudCategory();

      final provisionalId = await seedProvisionalGroceries(device);
      final walletId = await seedWallet(device, name: 'Phone wallet');
      await syncFor(device).syncAll();

      // The user carries on using the app while the question is open.
      final offlineTxn = await seedTransaction(
        device,
        walletId: walletId,
        categoryId: provisionalId,
        amount: 4200,
        title: 'Offline shop',
      );

      // It is held back rather than rejected — no conflict, and it is still
      // pending, not marked synced against a category the server never got.
      final blockedSync = await syncFor(device).syncAll();
      expect(
        blockedSync.conflicts.where((c) => c.entityId == offlineTxn),
        isEmpty,
      );
      expect(
        server.recordsIn(userId, 'transactions').where(
          (t) => t['Id'] == offlineTxn,
        ),
        isEmpty,
      );
      final held = await device.findTransactionById(offlineTxn);
      expect(held!.syncStatus, SyncStatus.pendingCreate);

      // The user answers, and the transaction goes up — re-pointed at the
      // adopted category, with its amount and title intact.
      await CategoryReconciliationService(device).adoptExisting(
        defaultKey: 'groceries',
        candidateId: legacyCategoryId,
      );
      await syncFor(device).syncAll();

      final uploaded = server
          .recordsIn(userId, 'transactions')
          .firstWhere((t) => t['Id'] == offlineTxn);
      expect(uploaded['CategoryId'], legacyCategoryId);
      expect(uploaded['Amount'], 4200);
      expect(uploaded['Title'], 'Offline shop');

      final settled = await device.findTransactionById(offlineTxn);
      expect(settled!.categoryId, legacyCategoryId);
      expect(settled.syncStatus, SyncStatus.synced);
    },
  );

  // ------------------------------------------------------- scenario 5: budgets
  test(
    'a budget scoped to the provisional category is held, then remapped on adopt',
    () async {
      await seedLegacyCloudCategory(transactionCount: 1);

      final provisionalId = await seedProvisionalGroceries(device);
      final walletId = await seedWallet(device, name: 'Phone wallet');
      await syncFor(device).syncAll();

      // The user sets up a budget against the built-in while the question is
      // open, and files a transaction under it.
      final budgetId = await seedBudget(
        device,
        categoryIds: [provisionalId],
        categoryId: provisionalId,
      );
      final txnId = await seedTransaction(
        device,
        walletId: walletId,
        categoryId: provisionalId,
        amount: 2500,
        title: 'Offline shop',
      );

      // Held, not rejected: the server never sees a budget scoped to a category
      // it does not have.
      final blocked = await syncFor(device).syncAll();
      expect(blocked.conflicts.where((c) => c.entityId == budgetId), isEmpty);
      expect(
        server.recordsIn(userId, 'budgets').where((b) => b['Id'] == budgetId),
        isEmpty,
      );
      final heldBudget = await device.findBudgetById(budgetId);
      expect(heldBudget!.syncStatus, SyncStatus.pendingCreate);

      await CategoryReconciliationService(device).adoptExisting(
        defaultKey: 'groceries',
        candidateId: legacyCategoryId,
      );
      await syncFor(device).syncAll();

      // Both storage locations moved to the adopted id — together.
      final local = await device.findBudgetById(budgetId);
      expect(AppDatabase.decodeIdList(local!.categoryIds), [
        legacyCategoryId,
      ]);
      expect(local.categoryId, legacyCategoryId);
      expect(local.syncStatus, SyncStatus.synced);

      // And what reached the cloud names the adopted category, not the
      // provisional id that exists nowhere.
      final uploaded = server
          .recordsIn(userId, 'budgets')
          .firstWhere((b) => b['Id'] == budgetId);
      expect(jsonDecode(uploaded['CategoryIds'] as String), [legacyCategoryId]);

      // The transaction it is meant to count went up against the same id, so
      // the budget actually counts it.
      final uploadedTxn = server
          .recordsIn(userId, 'transactions')
          .firstWhere((t) => t['Id'] == txnId);
      expect(uploadedTxn['CategoryId'], legacyCategoryId);
      expect(uploadedTxn['Amount'], 2500);
    },
  );

  test('keeping it custom leaves a budget pointed at the new built-in', () async {
    await seedLegacyCloudCategory();

    final provisionalId = await seedProvisionalGroceries(device);
    await syncFor(device).syncAll();

    final budgetId = await seedBudget(
      device,
      categoryIds: [provisionalId],
      categoryId: provisionalId,
    );

    await CategoryReconciliationService(
      device,
    ).keepSeparate(defaultKey: 'groceries');
    await syncFor(device).syncAll();

    // The provisional category became the built-in, so the budget's references
    // are already right and must be left exactly as they are.
    final local = await device.findBudgetById(budgetId);
    expect(AppDatabase.decodeIdList(local!.categoryIds), [provisionalId]);
    expect(local.categoryId, provisionalId);

    final uploaded = server
        .recordsIn(userId, 'budgets')
        .firstWhere((b) => b['Id'] == budgetId);
    expect(jsonDecode(uploaded['CategoryIds'] as String), [provisionalId]);
  });

  test('a budget scoped to both copies collapses to one reference', () async {
    await seedLegacyCloudCategory();

    final provisionalId = await seedProvisionalGroceries(device);
    await syncFor(device).syncAll();

    // The legacy category arrived on the pull, so the user can already scope a
    // budget to both it and the provisional built-in.
    final budgetId = await seedBudget(
      device,
      categoryIds: [legacyCategoryId, provisionalId],
    );

    await CategoryReconciliationService(device).adoptExisting(
      defaultKey: 'groceries',
      candidateId: legacyCategoryId,
    );
    await syncFor(device).syncAll();

    final local = await device.findBudgetById(budgetId);
    expect(
      AppDatabase.decodeIdList(local!.categoryIds),
      [legacyCategoryId],
      reason: 'the two references are the same category now, not a duplicate',
    );
  });

  test('deleting a category drops it from the budgets that scoped to it', () async {
    final keptId = await seedCategory(device, name: 'Transport');
    final doomedId = await seedCategory(device, name: 'Hobbies');
    final budgetId = await seedBudget(
      device,
      categoryIds: [keptId, doomedId],
      categoryId: doomedId,
    );

    await device.softDeleteCategory(doomedId);

    final local = await device.findBudgetById(budgetId);
    expect(AppDatabase.decodeIdList(local!.categoryIds), [keptId]);
    expect(local.categoryId, isNull);
    // Never uploaded, so it must still be a create — not downgraded to an
    // update the server has no row for.
    expect(local.syncStatus, SyncStatus.pendingCreate);
  });

  // ------------------------------------------------------------ scope + safety
  test('a same-named category of the other direction is not a candidate', () async {
    // "Loan" exists as both an expense and an income built-in, so direction is
    // the only thing separating them. An expense "Loan" must never be offered
    // as a candidate for the income one.
    await seedLegacyCloudCategory(name: 'Loan', isIncome: false);

    await seedCategory(
      device,
      name: 'Loan',
      isIncome: true,
      isDefault: true,
      defaultKey: 'loan_income',
    );
    await syncFor(device).syncAll();

    expect(await questionsOn(device), isEmpty);
    expect(
      server.recordsIn(userId, 'categories').where(
        (c) => c['DefaultKey'] == 'loan_income',
      ),
      hasLength(1),
    );
  });

  test('a differently named category is left entirely alone', () async {
    await seedLegacyCloudCategory(name: 'Food shopping');

    await seedProvisionalGroceries(device);
    await syncFor(device).syncAll();

    // No name match, so no question — and the built-in is created normally.
    expect(await questionsOn(device), isEmpty);
    expect(
      server.recordsIn(userId, 'categories').where(
        (c) => c['DefaultKey'] == 'groceries',
      ),
      hasLength(1),
    );
    final untouched = server
        .recordsIn(userId, 'categories')
        .firstWhere((c) => c['Id'] == legacyCategoryId);
    expect(untouched['DefaultKey'], isNull);
  });

  test('a decision that can no longer be applied is asked again, not retried', () async {
    await seedLegacyCloudCategory();
    await seedProvisionalGroceries(device);
    await syncFor(device).syncAll();

    await CategoryReconciliationService(device).adoptExisting(
      defaultKey: 'groceries',
      candidateId: legacyCategoryId,
    );

    // Another device deletes the chosen category before this one syncs.
    server.push(userId, [
      SyncChange(
        tableName: 'categories',
        entityId: legacyCategoryId,
        operation: 'delete',
      ),
    ]);

    await syncFor(device).syncAll();

    final questions = await questionsOn(device);
    expect(questions, hasLength(1));
    expect(
      questions.single.isAwaitingUser,
      isTrue,
      reason: 'the dead choice should be cleared, not retried forever',
    );
    expect(questions.single.resolutionCandidateId, isNull);
  });
}
