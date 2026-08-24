import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/account_store_provider.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/account_bootstrap_service.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// A bootstrap service the test scripts directly.
///
/// [next] is what the server will say. Null means the request failed — the case
/// that must produce "unknown", never "empty".
class _ScriptedBootstrap implements AccountBootstrapService {
  AccountBootstrap? next;
  int calls = 0;

  /// Fires as a lookup starts, so a test can make something happen *during* one.
  void Function(int calls)? onCall;

  _ScriptedBootstrap(this.next);

  @override
  Future<AccountBootstrap?> fetch({Duration timeout = const Duration()}) async {
    // Captured before the hook runs: the hook is how a test arranges for the
    // NEXT lookup to answer differently, and it must not change this one.
    final answer = next;
    calls++;
    onCall?.call(calls);
    return answer;
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

/// A database whose store preparation can be made to fail on demand.
class _PreparableDatabase extends AppDatabase {
  _PreparableDatabase(super.e);

  /// Fails the first bootstrap attempt, then lets the retry through.
  bool failPreparationOnce = false;

  @override
  Future<void> ensureSystemCategoriesExist() {
    if (failPreparationOnce) {
      failPreparationOnce = false;
      throw StateError('store preparation failed');
    }
    return super.ensureSystemCategoriesExist();
  }
}

/// A sync notifier that runs the real service against the fake server.
///
/// Overriding [build] is the point: the production notifier subscribes to
/// connectivity, which needs platform channels this suite has no reason to
/// stand up. The behaviour under test is what the controller does with the
/// result, not how the notifier watches the network.
class _TestSyncNotifier extends SyncNotifier {
  _TestSyncNotifier(this._service);

  final SyncService _service;

  @override
  SyncOperationState build() => SyncOperationState.idle;

  @override
  Future<SyncResult> syncAll() => _service.syncAll();
}

/// The startup decision, from signed-in to something the UI can act on.
///
/// The rule every case here defends: the create-first-wallet screen is only
/// reachable on positive evidence that the account is empty. Everything else —
/// a slow entitlement, an offline device, a failed request — is "unknown", and
/// unknown must never route a returning user into starting over on top of data
/// that was simply never fetched.
/// Lets the controller's fire-and-forget retry run to completion.
Future<void> _settle(ProviderContainer container) async {
  for (var i = 0; i < 100; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (container.read(startupFlowProvider).isSettled) return;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const userId = 'user-1';

  late _PreparableDatabase db;
  late SharedPreferences prefs;
  late FakeSyncServer server;
  late _ScriptedBootstrap bootstrap;
  late ProviderContainer container;

  /// The entitlement, mutable *inside* the container.
  ///
  /// The previous version of the late-entitlement test built a second container
  /// and called it a retry. That proved only that a fresh controller reaches the
  /// right conclusion — not that the running one notices anything. Driving a
  /// provider the real controller listens to is what actually exercises
  /// production behaviour.
  final entitlementOverride = StateProvider<EntitlementStatus>(
    (ref) => EntitlementStatus.unknown,
  );

  /// Builds a container with the startup flow's dependencies scripted.
  ///
  /// `premium` and `signedIn` are plain values so a test can state the world it
  /// wants without standing up authentication or in-app purchases.
  ProviderContainer buildContainer({
    EntitlementStatus entitlement = EntitlementStatus.unknown,
    String? signedInAs = userId,
    String? storeOwner = userId,
  }) {
    final c = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        localStoreManagerProvider.overrideWithValue(
          _FixedStoreManager(prefs, db),
        ),
        sharedPreferencesProvider.overrideWithValue(prefs),
        activeStoreFileProvider.overrideWith((ref) => 'db_test.sqlite'),
        authenticatedUserIdProvider.overrideWithValue(signedInAs),
        entitlementStatusProvider.overrideWith(
          (ref) => ref.watch(entitlementOverride),
        ),
        activeStoreOwnerProvider.overrideWith((ref) => storeOwner),
        accountBootstrapServiceProvider.overrideWithValue(bootstrap),
        syncNotifierProvider.overrideWith(
          () => _TestSyncNotifier(
            SyncService(
              database: db,
              transport: FakeSyncTransport(server: server, userId: userId),
            ),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.read(entitlementOverride.notifier).state = entitlement;
    return c;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = _PreparableDatabase(NativeDatabase.memory());
    await db.claimLocalStore(userId: userId);
    server = FakeSyncServer();
    bootstrap = _ScriptedBootstrap(null);
  });

  tearDown(() async => db.close());

  /// Puts a wallet in the cloud for [userId], as a previous device would have.
  Future<void> seedCloudWallet() async {
    final staging = openTestDatabase();
    await staging.claimLocalStore(userId: userId);
    await seedWallet(staging, name: 'Cloud wallet');
    await SyncService(
      database: staging,
      transport: FakeSyncTransport(server: server, userId: userId),
    ).syncAll();
    await staging.close();
  }

  // ------------------------------------------------------------- scenario 1
  test('a confirmed-empty account may be offered onboarding', () async {
    bootstrap.next = const AccountBootstrap(
      onboardingCompleted: false,
      hasFinancialData: false,
      liveWalletCount: 0,
    );
    container = buildContainer();

    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.phase, StartupPhase.confirmedEmpty);
    expect(flow.mayOfferFirstWallet, isTrue);
  });

  // ------------------------------------------------------------- scenario 2
  test(
    'a returning premium user restores and never sees first-wallet',
    () async {
      await seedCloudWallet();
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: true,
        hasFinancialData: true,
        liveWalletCount: 1,
      );
      container = buildContainer(entitlement: EntitlementStatus.premium);

      await container.read(startupFlowProvider.notifier).evaluate();

      final flow = container.read(startupFlowProvider);
      expect(flow.phase, StartupPhase.restored);
      expect(
        flow.mayOfferFirstWallet,
        isFalse,
        reason: 'a restored account must never be offered a first wallet',
      );
      expect((await db.getAllWallets()), isNotEmpty);
    },
  );

  // ------------------------------------------------------------- scenario 3
  test('onboarding_completed = false with cloud data still restores', () async {
    // The exact production shape: the flag was never backfilled, so an
    // established account reports the same value a brand-new one does.
    await seedCloudWallet();
    bootstrap.next = const AccountBootstrap(
      onboardingCompleted: false,
      hasFinancialData: true,
      liveWalletCount: 1,
    );
    container = buildContainer(entitlement: EntitlementStatus.premium);

    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.phase, StartupPhase.restored);
    expect(
      flow.mayOfferFirstWallet,
      isFalse,
      reason:
          'the stale flag must not route an established account to '
          'onboarding',
    );
  });

  // ------------------------------------------------------------- scenario 4
  test(
    'an entitlement arriving late triggers a retry in the same controller',
    () async {
      await seedCloudWallet();
      // The realistic shape: the account has data, and at this moment neither the
      // device nor the backend can vouch for the subscription — a receipt still
      // propagating, or a backend that does not report entitlement at all.
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: true,
        hasFinancialData: true,
        liveWalletCount: 1,
        describesEntitlement: false,
      );

      // Entitlement not yet established. The old code showed create-first-wallet
      // here, permanently, after a three-second wait.
      container = buildContainer();
      // Keep the controller alive so its listener is actually subscribed — this
      // is the thing under test.
      container.listen(startupFlowProvider, (_, _) {}, fireImmediately: true);
      await container.read(startupFlowProvider.notifier).evaluate();

      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.checkingEntitlement,
      );
      expect(
        container.read(startupFlowProvider).mayOfferFirstWallet,
        isFalse,
        reason:
            'an unconfirmed entitlement is not evidence of an empty account',
      );

      // The entitlement lands, well after the old window. No new container and no
      // manual re-evaluate: the running controller must notice on its own.
      container.read(entitlementOverride.notifier).state =
          EntitlementStatus.premium;

      await _settle(container);

      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.restored,
        reason: 'the listener must have re-run the flow without being asked',
      );
    },
  );

  test(
    'a confirmed non-premium account with cloud data is actionable',
    () async {
      // The state that used to hang forever: the backend says there is data and
      // says the subscription is not active. Waiting cannot resolve that, so the
      // user has to be told and given somewhere to go.
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: true,
        hasFinancialData: true,
        liveWalletCount: 4,
        isPremium: false,
      );
      container = buildContainer(entitlement: EntitlementStatus.notPremium);

      await container.read(startupFlowProvider.notifier).evaluate();

      final flow = container.read(startupFlowProvider);
      expect(flow.phase, StartupPhase.entitlementRequired);
      expect(flow.needsUserAttention, isTrue);
      expect(flow.needsSubscription, isTrue);
      expect(
        flow.mayOfferFirstWallet,
        isFalse,
        reason: 'a lapsed subscription must never lead to starting over',
      );
      expect(flow.reason, contains('subscription'));
    },
  );

  test('an unknown entitlement is never mistaken for a lapsed one', () async {
    // The server could not be reached at all, so nothing is confirmed. Being
    // unreachable must never turn into "your subscription has lapsed" — that
    // accuses the user of something the app has no evidence for.
    bootstrap.next = null;
    container = buildContainer();

    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.phase, StartupPhase.offline);
    expect(flow.needsSubscription, isFalse);
    expect(
      flow.isFinal,
      isFalse,
      reason: 'nothing was confirmed, so a later check must still be able to',
    );
  });

  test('the backend confirming premium is enough on its own', () async {
    // The device has no local entitlement yet, but /auth/me says the account is
    // premium. That is confirmation, and the restore should proceed.
    await seedCloudWallet();
    bootstrap.next = const AccountBootstrap(
      onboardingCompleted: true,
      hasFinancialData: true,
      liveWalletCount: 1,
      isPremium: true,
    );
    container = buildContainer();

    await container.read(startupFlowProvider.notifier).evaluate();

    expect(container.read(startupFlowProvider).phase, StartupPhase.restored);
  });

  // ------------------------------------------------------------- scenario 5
  test('an unreachable server is never reported as an empty account', () async {
    // The app is usable offline, so this no longer stops and asks. What it must
    // still not do is claim to know something: `confirmedEmpty` is positive
    // evidence that the account holds nothing, and an unanswered request is not
    // evidence of anything.
    bootstrap.next = null; // request failed / offline
    container = buildContainer(entitlement: EntitlementStatus.premium);

    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.phase, StartupPhase.offline);
    expect(flow.phase, isNot(StartupPhase.confirmedEmpty));
    expect(
      flow.account,
      isNull,
      reason: 'nothing came back, so nothing may be recorded as having',
    );
    expect(flow.reason, isNotNull);
  });

  test('retry after the server comes back settles the account', () async {
    bootstrap.next = null;
    container = buildContainer();
    await container.read(startupFlowProvider.notifier).evaluate();
    expect(container.read(startupFlowProvider).phase, StartupPhase.offline);

    bootstrap.next = const AccountBootstrap(
      onboardingCompleted: false,
      hasFinancialData: false,
      liveWalletCount: 0,
    );
    await container.read(startupFlowProvider.notifier).retry();

    expect(
      container.read(startupFlowProvider).phase,
      StartupPhase.confirmedEmpty,
    );
  });

  test('working offline needs no permission from the user', () async {
    // This used to require an explicit tap before the app would let anyone in
    // without a server. Offline is not an exceptional mode to be opted into —
    // the records live on the device, and a phone with no signal is an ordinary
    // way to use this.
    bootstrap.next = null;
    container = buildContainer();
    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.mayOfferFirstWallet, isTrue);
    expect(
      flow.startedOfflineByChoice,
      isFalse,
      reason: 'nobody had to choose it, so nothing should say they did',
    );
  });

  test('choosing to start offline still works', () async {
    // The explicit path is still there for the states that do stop and ask.
    bootstrap.next = null;
    container = buildContainer();
    await container.read(startupFlowProvider.notifier).evaluate();

    container.read(startupFlowProvider.notifier).startOfflineAnyway();

    final flow = container.read(startupFlowProvider);
    expect(flow.startedOfflineByChoice, isTrue);
    expect(flow.mayOfferFirstWallet, isTrue);
  });

  // ------------------------------------------------------------- scenario 6
  test('nothing proceeds until the store belongs to this account', () async {
    bootstrap.next = const AccountBootstrap(
      onboardingCompleted: false,
      hasFinancialData: false,
      liveWalletCount: 0,
    );
    // The store still belongs to whoever was signed in before.
    container = buildContainer(storeOwner: 'someone-else');

    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.phase, StartupPhase.unavailable);
    expect(
      bootstrap.calls,
      0,
      reason: 'the account must not even be queried against the wrong store',
    );
    expect(flow.mayOfferFirstWallet, isFalse);
  });

  test('local wallets settle the question without a server call', () async {
    await seedWallet(db, name: 'Offline wallet');
    container = buildContainer();

    await container.read(startupFlowProvider.notifier).evaluate();

    expect(container.read(startupFlowProvider).phase, StartupPhase.restored);
    expect(
      bootstrap.calls,
      0,
      reason: 'existing local data needs no round trip to interpret',
    );
  });

  test('a signed-out container stays at the start', () async {
    container = buildContainer(signedInAs: null);

    await container.read(startupFlowProvider.notifier).evaluate();

    expect(
      container.read(startupFlowProvider).phase,
      StartupPhase.checkingIdentity,
    );
    expect(container.read(startupFlowProvider).mayOfferFirstWallet, isFalse);
  });

  test('cloud data that fails to arrive is unavailable, not empty', () async {
    // The server says there is data; the restore brings none down. That is a
    // contradiction, and the one thing it is definitely not is an empty account.
    bootstrap.next = const AccountBootstrap(
      onboardingCompleted: true,
      hasFinancialData: true,
      liveWalletCount: 3,
    );
    container = buildContainer(entitlement: EntitlementStatus.premium);

    await container.read(startupFlowProvider.notifier).evaluate();

    final flow = container.read(startupFlowProvider);
    expect(flow.phase, StartupPhase.unavailable);
    expect(flow.mayOfferFirstWallet, isFalse);
  });

  group('store preparation is part of startup', () {
    // Preparation writes the things the account needs before anything can be
    // read out of it meaningfully. Running it here rather than only in tests is
    // what makes the recovery screen's "Try again" actually retry it — and what
    // stops a store that failed to set up from being read as an empty account.

    test('a preparation failure lands on recovery, never onboarding', () async {
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      container = buildContainer();
      db.failPreparationOnce = true;

      await container.read(startupFlowProvider.notifier).evaluate();

      final flow = container.read(startupFlowProvider);
      expect(flow.phase, StartupPhase.unavailable);
      expect(flow.needsUserAttention, isTrue);
      expect(
        flow.mayOfferFirstWallet,
        isFalse,
        reason: 'a store that failed to set up is not an empty account',
      );
      expect(
        bootstrap.calls,
        0,
        reason:
            'the account is not worth asking about until its store is ready',
      );
    });

    test('pressing retry re-runs preparation and then continues', () async {
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      container = buildContainer();
      db.failPreparationOnce = true;

      await container.read(startupFlowProvider.notifier).evaluate();
      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.unavailable,
      );

      // Exactly what the recovery screen's button does.
      await container.read(startupFlowProvider.notifier).retry();

      final flow = container.read(startupFlowProvider);
      expect(flow.phase, StartupPhase.confirmedEmpty);
      expect(flow.mayOfferFirstWallet, isTrue);
      expect(
        await db.getAllCategories(),
        isNotEmpty,
        reason: 'the retry must have actually re-run preparation',
      );
    });
  });

  group('queued retries survive an unavailable result', () {
    // `unavailable` settles the screen but not the question: connectivity or an
    // entitlement arriving a moment later can still answer it. Counting it as
    // final meant a trigger that landed mid-lookup was thrown away, and the user
    // sat on a recovery screen that had already stopped trying.

    test(
      'a trigger arriving during a failing lookup runs a second lookup',
      () async {
        // First lookup fails; the second — prompted by the queued trigger — works.
        bootstrap.next = null;
        bootstrap.onCall = (calls) {
          if (calls == 1) {
            // Arrives while the first lookup is still in flight.
            container.read(startupFlowProvider.notifier).evaluate();
            bootstrap.next = const AccountBootstrap(
              onboardingCompleted: false,
              hasFinancialData: false,
              liveWalletCount: 0,
            );
          }
        };
        container = buildContainer();

        await container.read(startupFlowProvider.notifier).evaluate();

        expect(
          bootstrap.calls,
          2,
          reason:
              'the queued retry must not be discarded by an unavailable result',
        );
        expect(
          container.read(startupFlowProvider).phase,
          StartupPhase.confirmedEmpty,
        );
      },
    );

    test('a final state stops the loop', () async {
      // The mirror image: once the answer is real, a queued trigger must not
      // send it round again.
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      bootstrap.onCall = (calls) {
        if (calls == 1) container.read(startupFlowProvider.notifier).evaluate();
      };
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();

      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.confirmedEmpty,
      );
      expect(bootstrap.calls, 1);
    });
  });

  group('the first-wallet gate', () {
    test('a returning user with cloud data never reaches it', () async {
      await seedCloudWallet();
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: true,
        liveWalletCount: 2,
        isPremium: true,
      );
      container = buildContainer(entitlement: EntitlementStatus.premium);

      await container.read(startupFlowProvider.notifier).evaluate();

      final flow = container.read(startupFlowProvider);
      expect(flow.phase, StartupPhase.restored);
      expect(flow.mayOfferFirstWallet, isFalse);
    });

    test('a genuinely empty user still reaches it', () async {
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();

      final flow = container.read(startupFlowProvider);
      expect(flow.phase, StartupPhase.confirmedEmpty);
      expect(
        flow.mayOfferFirstWallet,
        isTrue,
        reason: 'a confirmed-empty account must not be blocked from starting',
      );
    });
  });

  group('startup never blocks the widget tree or hangs', () {
    // Both symptoms of the same defect. A listener registered in the
    // controller's `build()` can fire during the widget build that created it;
    // the pass it kicked off then mutated `state` from inside that build,
    // Riverpod asserted, and the aborted pass left the phase at
    // `checkingIdentity` — which renders as a loading screen forever.

    testWidgets('evaluating from inside a build does not modify providers', (
      tester,
    ) async {
      // The reported crash, reproduced: a widget build reaches the controller,
      // which mutates `state` before yielding. Riverpod asserts, the pass dies
      // half-done, and the phase never leaves `checkingIdentity`.
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      final c = buildContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: Consumer(
            builder: (context, ref, _) {
              ref.read(startupFlowProvider.notifier).evaluate();
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        tester.takeException(),
        isNull,
        reason: 'startup must not modify a provider while the tree is building',
      );

      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        c.read(startupFlowProvider).phase,
        StartupPhase.confirmedEmpty,
        reason:
            'the flow must reach the RIGHT answer. Without the deferral it '
            'still lands somewhere — the fail-safe catches the assertion and '
            'reports `unavailable` — so only the correct terminal state '
            'distinguishes a working startup from a rescued one',
      );
    });

    test('a failure mid-evaluation ends somewhere actionable', () async {
      // The store cannot be prepared and the failure escapes as an exception
      // rather than a recorded error.
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      bootstrap.onCall = (_) => throw StateError('lookup exploded');
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();

      final flow = container.read(startupFlowProvider);
      expect(
        flow.phase,
        StartupPhase.unavailable,
        reason:
            'an unhandled failure must not leave the app on a splash '
            'screen with nothing to press',
      );
      expect(flow.needsUserAttention, isTrue);
      expect(flow.mayOfferFirstWallet, isFalse);
    });

    test('the flow recovers after an exception', () async {
      bootstrap.onCall = (calls) {
        if (calls == 1) throw StateError('lookup exploded');
      };
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();
      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.unavailable,
      );

      await container.read(startupFlowProvider.notifier).retry();

      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.confirmedEmpty,
        reason: 'a thrown pass must not poison the controller for the session',
      );
    });
  });

  group('a settled flow is never sent back to a loading screen', () {
    // The loop this prevents: `AuthWrapper` only renders the app shell while the
    // flow is settled, so any transient phase unmounts it — and the shell's own
    // `initState` used to start the next evaluation. Dashboard, splash,
    // dashboard, about three times a second, hammering the API with it.

    test('re-evaluating after restore never leaves a settled phase', () async {
      await seedCloudWallet();
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: true,
        hasFinancialData: true,
        liveWalletCount: 1,
        isPremium: true,
      );
      container = buildContainer(entitlement: EntitlementStatus.premium);

      await container.read(startupFlowProvider.notifier).evaluate();
      expect(container.read(startupFlowProvider).phase, StartupPhase.restored);

      // Watch every emission across a second run.
      final seen = <StartupPhase>[];
      container.listen(
        startupFlowProvider,
        (_, next) => seen.add(next.phase),
        fireImmediately: false,
      );

      await container.read(startupFlowProvider.notifier).evaluate();

      expect(
        seen.where((p) => p != StartupPhase.restored),
        isEmpty,
        reason:
            'every non-settled emission here unmounts the app shell, and '
            'remounting it starts another evaluation: $seen',
      );
      expect(container.read(startupFlowProvider).phase, StartupPhase.restored);
    });

    test('a retry cannot eject someone already in the app', () async {
      await seedCloudWallet();
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: true,
        hasFinancialData: true,
        liveWalletCount: 1,
        isPremium: true,
      );
      container = buildContainer(entitlement: EntitlementStatus.premium);
      await container.read(startupFlowProvider.notifier).evaluate();
      expect(container.read(startupFlowProvider).phase, StartupPhase.restored);

      // The network drops and a retry fires.
      bootstrap.next = null;
      await container.read(startupFlowProvider.notifier).retry();

      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.restored,
        reason:
            'a failed background re-check must not throw the user out of '
            'an app they are already using',
      );
    });

    test('a confirmed-empty account can still become restored', () async {
      // The guard blocks transient phases, not genuine progress.
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: false,
        hasFinancialData: false,
        liveWalletCount: 0,
      );
      container = buildContainer();
      await container.read(startupFlowProvider.notifier).evaluate();
      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.confirmedEmpty,
      );

      // The user creates a wallet; the next pass should notice.
      await seedWallet(db, name: 'First wallet');
      await container.read(startupFlowProvider.notifier).evaluate();

      expect(container.read(startupFlowProvider).phase, StartupPhase.restored);
    });
  });

  group('offline is a normal way to use the app', () {
    test('an unreachable account does not hold the app hostage', () async {
      // Everything here is recorded on the device first; the network carries it
      // to other devices, it is not what makes the app work. Someone with no
      // signal owns their records as much as anyone else, and a server being
      // down — or a laptop running the dev backend being shut — must not lock
      // them out.
      bootstrap = _ScriptedBootstrap(null); // the fetch fails
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();
      final state = container.read(startupFlowProvider);

      expect(state.phase, StartupPhase.offline);
      expect(
        state.needsUserAttention,
        isFalse,
        reason: 'there is nothing for the user to decide here',
      );
      expect(
        state.isSettled,
        isTrue,
        reason: 'the app can be shown; it is not still deciding',
      );
      expect(
        state.mayOfferFirstWallet,
        isTrue,
        reason: 'a first wallet is how someone starts using it offline',
      );
    });

    test('being offline is not mistaken for a settled answer', () async {
      // The account question was deferred, not answered. A later check that
      // does reach the server has to be able to improve on it.
      bootstrap = _ScriptedBootstrap(null);
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();
      expect(container.read(startupFlowProvider).phase, StartupPhase.offline);
      expect(
        container.read(startupFlowProvider).isFinal,
        isFalse,
        reason: 'final would mean no later answer could replace it',
      );
    });

    test('local data settles it without asking the server at all', () async {
      // The common case for a returning user with no signal: the answer is
      // already on the device, so nothing should be waiting on a network call.
      await seedWallet(db, name: 'Everyday');
      bootstrap = _ScriptedBootstrap(null);
      container = buildContainer();

      await container.read(startupFlowProvider.notifier).evaluate();

      expect(container.read(startupFlowProvider).phase, StartupPhase.restored);
      expect(
        bootstrap.calls,
        0,
        reason: 'the server was never needed, so it was never asked',
      );
    });

    test('reaching the server later still restores what is up there', () async {
      // Offline first, then a successful check finds cloud data.
      bootstrap = _ScriptedBootstrap(null);
      container = buildContainer(entitlement: EntitlementStatus.premium);

      await container.read(startupFlowProvider.notifier).evaluate();
      expect(container.read(startupFlowProvider).phase, StartupPhase.offline);

      // The network comes back and the account turns out to hold data.
      await seedCloudWallet();
      bootstrap.next = const AccountBootstrap(
        onboardingCompleted: true,
        hasFinancialData: true,
        liveWalletCount: 1,
        isPremium: true,
        subscriptionTier: 'premium',
        describesEntitlement: true,
      );

      await container.read(startupFlowProvider.notifier).evaluate();

      expect(
        container.read(startupFlowProvider).phase,
        StartupPhase.restored,
        reason: 'offline was a deferral, not a verdict',
      );
    });
  });
}
