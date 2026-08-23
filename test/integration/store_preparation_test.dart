import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/account_store_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:drift/native.dart';

/// A database that can be made to fail one specific preparation step.
///
/// Each failure is armed once, so the first attempt fails and a retry in the
/// same session can succeed — which is the behaviour under test.
class _FlakyDatabase extends AppDatabase {
  _FlakyDatabase(super.e);

  bool failBootstrapOnce = false;
  bool failIdRepairOnce = false;

  /// Set when recurrence catch-up actually started.
  bool startupProcessingRan = false;

  @override
  Future<void> ensureSystemCategoriesExist() {
    if (failBootstrapOnce) {
      failBootstrapOnce = false;
      throw StateError('bootstrap failed');
    }
    return super.ensureSystemCategoriesExist();
  }

  @override
  Future<List<LocalIdRepair>> unsettledIdRepairs() {
    if (failIdRepairOnce) {
      failIdRepairOnce = false;
      throw StateError('id repair failed');
    }
    return super.unsettledIdRepairs();
  }

  @override
  Future<List<RecurringConfig>> getDueRecurringConfigs() {
    // The first thing recurrence catch-up asks for, so it doubles as the probe
    // for whether that step was reached at all.
    startupProcessingRan = true;
    return super.getDueRecurringConfigs();
  }
}

/// A manager that always hands back the one in-memory database under test.
class _FixedStoreManager extends LocalStoreManager {
  _FixedStoreManager(super.prefs, this._db);

  final AppDatabase _db;

  @override
  AppDatabase databaseForFile(String fileName) => _db;

  @override
  AppDatabase get activeDatabase => _db;
}

/// Which store account-scoped startup work is allowed to touch.
///
/// This used to run from `MyApp.initState()`, before authentication had
/// resolved — so the persisted store from the last session could be seeded and
/// have recurrences generated into it before anyone knew whether that session
/// was still valid, or whose it was. The per-account file layout limited the
/// blast radius, but writing into an account's database because it happened to
/// be the one left open is not something to leave to luck.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FlakyDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = _FlakyDatabase(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  ProviderContainer buildContainer({required String? sessionUser}) {
    final container = ProviderContainer(
      overrides: [
        localStoreManagerProvider.overrideWithValue(
          _FixedStoreManager(prefs, db),
        ),
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        activeStoreFileProvider.overrideWith((ref) => 'db_test.sqlite'),
        activeStoreOwnerProvider.overrideWith((ref) => sessionUser),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('a store owned by another account is never prepared', () async {
    // The store on disk belongs to someone else — a previous session that has
    // not been switched away from yet.
    await db.claimLocalStore(userId: 'previous-user');

    final container = buildContainer(sessionUser: 'current-user');
    await container
        .read(accountStoreCoordinatorProvider.notifier)
        .prepareActiveStore();

    expect(
      await db.getAllCategories(),
      isEmpty,
      reason: 'no categories may be seeded into another account\'s store',
    );
    expect(
      container.read(accountStoreCoordinatorProvider.notifier).preparedFiles,
      isEmpty,
      reason: 'a refused preparation must not be recorded as done',
    );
  });

  test('the signed-in account\'s own store is prepared', () async {
    await db.claimLocalStore(userId: 'current-user');

    final container = buildContainer(sessionUser: 'current-user');
    await container
        .read(accountStoreCoordinatorProvider.notifier)
        .prepareActiveStore();

    // System categories are created immediately for any store the session owns;
    // the user-facing defaults wait for the first cloud pull.
    expect(await db.getAllCategories(), isNotEmpty);
    expect(
      container.read(accountStoreCoordinatorProvider.notifier).preparedFiles,
      contains('db_test.sqlite'),
    );
  });

  test('an unclaimed store is prepared as the offline store', () async {
    // Never signed in: local-first has to work with no account at all.
    final container = buildContainer(sessionUser: null);
    await container
        .read(accountStoreCoordinatorProvider.notifier)
        .prepareActiveStore();

    expect(await db.getAllCategories(), isNotEmpty);
  });

  test('preparation runs once per store', () async {
    await db.claimLocalStore(userId: 'current-user');
    final container = buildContainer(sessionUser: 'current-user');
    final coordinator = container.read(
      accountStoreCoordinatorProvider.notifier,
    );

    await coordinator.prepareActiveStore();
    final afterFirst = (await db.getAllCategories()).length;
    await coordinator.prepareActiveStore();

    expect((await db.getAllCategories()).length, afterFirst);
  });

  test('a refused preparation stays retryable in the same session', () async {
    // Refused because the store belonged to someone else...
    await db.claimLocalStore(userId: 'previous-user');
    final container = buildContainer(sessionUser: 'previous-user');
    final coordinator = container.read(
      accountStoreCoordinatorProvider.notifier,
    );

    // ...and this session does own it, so it must go through. The point is that
    // an earlier refusal did not mark the file done and lock it out for good.
    await coordinator.prepareActiveStore();

    expect(coordinator.preparedFiles, contains('db_test.sqlite'));
    expect(await db.getAllCategories(), isNotEmpty);
  });

  group('a failed preparation is retryable', () {
    // The rule: every step here writes something the account needs, so a
    // half-prepared store must never be recorded as done. Marking it done was
    // the bug — the session would refuse to touch it again, and an account
    // could run for its whole lifetime with no system categories, meaning the
    // first transfer the user made had nowhere to file its category.

    test('a bootstrap failure leaves the file unprepared', () async {
      await db.claimLocalStore(userId: 'current-user');
      final container = buildContainer(sessionUser: 'current-user');
      final coordinator = container.read(
        accountStoreCoordinatorProvider.notifier,
      );

      db.failBootstrapOnce = true;
      await coordinator.prepareActiveStore();

      expect(coordinator.preparedFiles, isEmpty);
      expect(
        db.startupProcessingRan,
        isFalse,
        reason: 'recurrence generation must not run on a store that failed to '
            'bootstrap',
      );
      expect(
        container.read(accountStoreCoordinatorProvider).error,
        isNotNull,
        reason: 'the failure must be surfaced, not swallowed',
      );
    });

    test('a second attempt after a bootstrap failure succeeds', () async {
      await db.claimLocalStore(userId: 'current-user');
      final container = buildContainer(sessionUser: 'current-user');
      final coordinator = container.read(
        accountStoreCoordinatorProvider.notifier,
      );

      db.failBootstrapOnce = true;
      await coordinator.prepareActiveStore();
      expect(coordinator.preparedFiles, isEmpty);

      await coordinator.prepareActiveStore();

      expect(coordinator.preparedFiles, contains('db_test.sqlite'));
      expect(await db.getAllCategories(), isNotEmpty);
      expect(db.startupProcessingRan, isTrue);
      expect(
        container.read(accountStoreCoordinatorProvider).error,
        isNull,
        reason: 'a successful run must clear the previous failure',
      );
    });

    test('an id-repair failure leaves the file unprepared', () async {
      await db.claimLocalStore(userId: 'current-user');
      final container = buildContainer(sessionUser: 'current-user');
      final coordinator = container.read(
        accountStoreCoordinatorProvider.notifier,
      );

      db.failIdRepairOnce = true;
      await coordinator.prepareActiveStore();

      expect(coordinator.preparedFiles, isEmpty);
      expect(
        db.startupProcessingRan,
        isFalse,
        reason: 'recurrence rows must not be generated against wallet ids that '
            'are still mid-repair',
      );
      expect(
        container.read(accountStoreCoordinatorProvider).error,
        isNotNull,
      );
    });

    test('a second attempt after an id-repair failure succeeds', () async {
      await db.claimLocalStore(userId: 'current-user');
      final container = buildContainer(sessionUser: 'current-user');
      final coordinator = container.read(
        accountStoreCoordinatorProvider.notifier,
      );

      db.failIdRepairOnce = true;
      await coordinator.prepareActiveStore();
      expect(coordinator.preparedFiles, isEmpty);

      await coordinator.prepareActiveStore();

      expect(coordinator.preparedFiles, contains('db_test.sqlite'));
      expect(db.startupProcessingRan, isTrue);
      expect(container.read(accountStoreCoordinatorProvider).error, isNull);
    });

    test('a refused store is still never mutated after a failure', () async {
      // The ownership guard has to survive the new error path: a failure
      // elsewhere must not become an excuse to write into someone else's store.
      await db.claimLocalStore(userId: 'previous-user');
      final container = buildContainer(sessionUser: 'current-user');
      final coordinator = container.read(
        accountStoreCoordinatorProvider.notifier,
      );

      await coordinator.prepareActiveStore();
      await coordinator.prepareActiveStore();

      expect(await db.getAllCategories(), isEmpty);
      expect(db.startupProcessingRan, isFalse);
      expect(coordinator.preparedFiles, isEmpty);
    });

    test('a successful preparation still runs only once', () async {
      await db.claimLocalStore(userId: 'current-user');
      final container = buildContainer(sessionUser: 'current-user');
      final coordinator = container.read(
        accountStoreCoordinatorProvider.notifier,
      );

      await coordinator.prepareActiveStore();
      final afterFirst = (await db.getAllCategories()).length;
      db.startupProcessingRan = false;

      await coordinator.prepareActiveStore();

      expect((await db.getAllCategories()).length, afterFirst);
      expect(
        db.startupProcessingRan,
        isFalse,
        reason: 'a prepared store must not be prepared again',
      );
    });
  });

}
