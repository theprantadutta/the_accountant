import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/account_store_provider.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/account_bootstrap_service.dart';
import 'package:the_accountant/core/services/connectivity_service.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Where startup has got to.
///
/// The distinction that matters is between [confirmedEmpty] and [unavailable].
/// The old code had no such distinction: it waited about three seconds for a
/// premium entitlement and, if none arrived, showed "create your first wallet".
/// A slow network, fresh secure storage, or a backend hiccup therefore looked
/// exactly like a brand-new account — and that screen invites the user to start
/// over on top of data which was never restored.
///
/// So a timeout now produces [unavailable], which offers a retry. Only positive
/// evidence — the server saying this account holds nothing — produces
/// [confirmedEmpty].
enum StartupPhase {
  /// Waiting for the local store to be bound to the authenticated account.
  checkingIdentity,

  /// Asking the server what this account holds.
  checkingAccount,

  /// The account has cloud data but the entitlement that permits sync has not
  /// been confirmed either way yet. Retryable.
  checkingEntitlement,

  /// The account has cloud data and the backend has confirmed the entitlement
  /// is NOT active. The data is safe and still there; restoring it needs a
  /// subscription. This is a destination, not a wait — it must never render as
  /// an indefinite loading screen.
  entitlementRequired,

  /// A restore sync is in flight.
  restoring,

  /// Local data is present. Go to the dashboard.
  restored,

  /// The server confirmed this account holds nothing. Onboarding is safe.
  confirmedEmpty,

  /// State could not be established. Offer retry; never assume "new user".
  unavailable,
}

@immutable
class StartupFlowState {
  final StartupPhase phase;

  /// Why the flow is [StartupPhase.unavailable], for the recovery screen.
  final String? reason;

  /// The server's answer, once obtained.
  final AccountBootstrap? account;

  /// Set when the user explicitly chose to continue without a resolved account
  /// state, having been warned.
  final bool startedOfflineByChoice;

  const StartupFlowState({
    this.phase = StartupPhase.checkingIdentity,
    this.reason,
    this.account,
    this.startedOfflineByChoice = false,
  });

  StartupFlowState copyWith({
    StartupPhase? phase,
    String? reason,
    AccountBootstrap? account,
    bool? startedOfflineByChoice,
  }) => StartupFlowState(
    phase: phase ?? this.phase,
    reason: reason,
    account: account ?? this.account,
    startedOfflineByChoice:
        startedOfflineByChoice ?? this.startedOfflineByChoice,
  );

  /// Whether the create-first-wallet / post-signup onboarding path is safe.
  ///
  /// Deliberately the only place that question is answered, and deliberately
  /// narrow: nothing but a confirmed-empty account, or the user's own warned
  /// decision to start offline, opens that door.
  bool get mayOfferFirstWallet =>
      phase == StartupPhase.confirmedEmpty || startedOfflineByChoice;

  bool get isSettled =>
      phase == StartupPhase.restored ||
      phase == StartupPhase.confirmedEmpty ||
      phase == StartupPhase.unavailable;

  /// States no later event can improve on.
  ///
  /// Deliberately narrower than [isSettled]. `unavailable` settles the *screen*
  /// — there is something to show and something to press — but it does not
  /// settle the question, because connectivity or an entitlement arriving a
  /// moment later can still answer it. Treating the two as the same thing is
  /// how a retry that arrived mid-lookup got thrown away.
  bool get isFinal =>
      phase == StartupPhase.restored || phase == StartupPhase.confirmedEmpty;

  /// States that must show the user something they can act on.
  ///
  /// Everything here is a dead end without input — a failed lookup, an
  /// unconfirmed subscription, a lapsed one. Rendering a loading screen for any
  /// of them leaves the user staring at a spinner forever, which is exactly the
  /// failure this replaced.
  bool get needsUserAttention =>
      phase == StartupPhase.unavailable ||
      phase == StartupPhase.checkingEntitlement ||
      phase == StartupPhase.entitlementRequired;

  /// Whether to offer the subscription flow rather than just a retry.
  bool get needsSubscription => phase == StartupPhase.entitlementRequired;
}

final accountBootstrapServiceProvider = Provider<AccountBootstrapService>(
  (ref) => AccountBootstrapService(),
);

/// The signed-in account id, or null.
///
/// A narrow view of [authProvider] so the startup flow depends on the one fact
/// it needs rather than the whole auth surface — which also means a test can
/// state "signed in as X" without standing up authentication.
final authenticatedUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  return auth.isAuthenticated ? auth.userId : null;
});

/// What is actually known about the subscription.
///
/// A boolean cannot express this. `isPremium == false` means both "confirmed
/// free" and "nothing has loaded yet", and collapsing those is what left a
/// returning user with cloud data waiting on a screen that never changed: the
/// flow could not tell whether to keep waiting or to say something.
enum EntitlementStatus {
  /// Not established yet. Keep retrying; say so; never conclude anything.
  unknown,

  /// Confirmed active.
  premium,

  /// Confirmed inactive by the backend — free, expired, or lapsed.
  notPremium,
}

/// The entitlement as this device currently knows it.
///
/// Only ever reports [EntitlementStatus.premium] or [EntitlementStatus.unknown]:
/// a local negative is not confirmation of anything. The upgrade from `unknown`
/// to [EntitlementStatus.notPremium] comes from the backend, in
/// [AccountBootstrap.isPremium] — see `_resolveEntitlement`.
final entitlementStatusProvider = Provider<EntitlementStatus>((ref) {
  final premium = ref.watch(premiumProvider);
  if (premium.isPremium) return EntitlementStatus.premium;
  return EntitlementStatus.unknown;
});

/// Whether this device already holds wallets, read from the database.
///
/// Deliberately the database and not `hasWalletsProvider`: the UI provider is
/// false until something loads it, and "nothing has loaded yet" must never be
/// mistaken for "this account is empty" — that mistake is the entire bug this
/// controller exists to fix.
Future<bool> _hasLocalWallets(Ref ref) async {
  final db = ref.read(databaseProvider);
  final wallets = await db.getAllWallets();
  return wallets.isNotEmpty;
}

/// Drives startup from "signed in" to a state the UI can act on.
///
/// Runs at most one attempt at a time, and re-attempts whenever something that
/// could change the answer arrives: a verified entitlement, connectivity, or the
/// user pressing retry. That replaces the previous fixed three-second window,
/// which gave up permanently on the first miss.
class StartupFlowController extends Notifier<StartupFlowState> {
  StreamSubscription<bool>? _connectivitySub;
  bool _running = false;

  /// A trigger that arrived while a pass was already in flight.
  ///
  /// Entitlements and connectivity land at arbitrary moments, very often
  /// *during* the pass that is waiting on them. Dropping those would put the
  /// flow back exactly where it started: stuck until some later, unrelated
  /// event happened to arrive.
  bool _rerunRequested = false;

  @override
  StartupFlowState build() {
    // Both listeners hand their work to the next event-loop turn.
    //
    // A listener registered here can fire during the very build that created
    // this controller — `AuthWrapper` watches it, and reading a provider inside
    // the callback flushes others, which fires them too. Touching `state` at
    // that moment is modifying a provider while the widget tree is building:
    // Riverpod asserts, the pass is aborted mid-flight, and the phase never
    // leaves `checkingIdentity` — which the user sees as a splash screen that
    // never becomes the dashboard.
    ref.listen<EntitlementStatus>(entitlementStatusProvider, (previous, next) {
      // An entitlement arriving late is the single most common reason the old
      // timeout misfired, so it is the most important retry trigger.
      if (previous != next && next != EntitlementStatus.unknown) {
        _afterBuild(() => _retryIfUnsettled('entitlement now $next'));
      }
    });

    ref.listen<String?>(authenticatedUserIdProvider, (previous, next) {
      if (previous == next) return;
      _afterBuild(() {
        state = const StartupFlowState();
        _running = false;
        if (next != null) unawaited(evaluate());
      });
    });

    _connectivitySub = ConnectivityService().onConnectivityChanged.listen((
      online,
    ) {
      if (online) _retryIfUnsettled('connectivity restored');
    });

    ref.onDispose(() {
      _connectivitySub?.cancel();
    });

    return const StartupFlowState();
  }

  /// Runs [action] once the current build has finished.
  static void _afterBuild(void Function() action) {
    Future<void>(action);
  }

  void _retryIfUnsettled(String why) {
    final phase = state.phase;
    if (phase == StartupPhase.restored ||
        phase == StartupPhase.confirmedEmpty) {
      return;
    }
    debugPrint('[StartupFlow] retrying: $why');
    unawaited(evaluate());
  }

  /// User-initiated retry from the recovery screen.
  Future<void> retry() {
    _enterPhase(StartupPhase.checkingIdentity);
    return evaluate();
  }

  /// The user chose to continue with the account state unresolved.
  ///
  /// Recorded explicitly so it is always a decision someone made and was warned
  /// about, never something the app inferred from a timeout.
  void startOfflineAnyway() {
    state = state.copyWith(startedOfflineByChoice: true);
  }

  /// Runs the flow to its next settled point.
  Future<void> evaluate() async {
    if (_running) {
      _rerunRequested = true;
      return;
    }
    _running = true;
    try {
      // Yield before touching `state`. `evaluate()` is reachable synchronously
      // from a provider listener, and a listener can run inside a widget build
      // — where mutating a provider is an error. One turn of the event loop is
      // enough to be safely outside it.
      await Future<void>.delayed(Duration.zero);

      do {
        _rerunRequested = false;
        await _evaluate();
      } while (_rerunRequested && !state.isFinal);
    } catch (e, stack) {
      // Startup must always end somewhere the user can act. An unhandled
      // failure here used to leave the phase wherever it stopped, and every
      // non-settled phase renders as a loading screen — so a single throw meant
      // a splash screen that never resolved and offered nothing to press.
      debugPrint('[StartupFlow] evaluation failed: $e');
      debugPrintStack(stackTrace: stack);
      _enterPhase(StartupPhase.unavailable, reason: 'Something went wrong while starting up. Your data is safe on this '
            'device.',
      );
    } finally {
      _running = false;
    }
  }

  /// Moves the flow to [phase], refusing to undo a conclusion already reached.
  ///
  /// Once startup has settled, the user is *in* the app. Re-running the flow —
  /// a retry, a late entitlement, a reconnect — must not put a loading screen
  /// back over the top of the dashboard they are already using. It did, and the
  /// result was a loop: `AuthWrapper` renders the app shell only while the flow
  /// is settled, so a transient phase unmounted the shell, and the shell's own
  /// `initState` kicked off the next evaluation. Roughly three round trips a
  /// second, seen as the dashboard and the splash screen alternating.
  ///
  /// A final state can still be replaced by another final state — restoring
  /// data legitimately turns "confirmed empty" into "restored".
  void _enterPhase(StartupPhase phase, {String? reason}) {
    final target = StartupFlowState(
      phase: phase,
      reason: reason,
      account: state.account,
      startedOfflineByChoice: state.startedOfflineByChoice,
    );
    if (state.isFinal && !target.isFinal) return;
    state = target;
  }

  Future<void> _evaluate() async {
    final userId = ref.read(authenticatedUserIdProvider);
    if (userId == null) {
      state = const StartupFlowState();
      return;
    }

    // 1. The store must belong to this account before anything reads or writes
    // it. Acting earlier would run onboarding or a restore against whichever
    // file happened to be open — in the worst case the previous account's.
    _enterPhase(StartupPhase.checkingIdentity);
    if (!await _awaitStoreOwner(userId)) {
      _enterPhase(StartupPhase.unavailable, reason: 'Could not open the local data for this account.',
      );
      return;
    }

    // 2. Bring the store itself up to scratch before reading anything out of
    // it. Seeding system categories, finishing a wallet re-key, and catching up
    // recurrences all WRITE, so they have to happen after the owner is known —
    // and they have to happen before the wallet check, because a store that
    // failed to prepare can look empty for reasons that have nothing to do with
    // the account being new.
    await ref.read(accountStoreCoordinatorProvider.notifier).prepareActiveStore();
    final storeError = ref.read(accountStoreCoordinatorProvider).error;
    if (storeError != null) {
      _enterPhase(StartupPhase.unavailable, reason: 'We could not finish setting up this account on this device. '
            'Nothing has been deleted.',
      );
      return;
    }

    // 3. Local data settles it outright — no server round trip needed.
    if (await _hasLocalWallets(ref)) {
      await _reloadWallets();
      _enterPhase(StartupPhase.restored);
      return;
    }

    // 4. Ask the server what the account holds. A failure here is "unknown",
    // never "empty".
    _enterPhase(StartupPhase.checkingAccount);
    final account = await ref.read(accountBootstrapServiceProvider).fetch();
    if (account == null) {
      _enterPhase(StartupPhase.unavailable, reason: 'We could not check whether this account has data to restore. '
            'Your existing data is safe.',
      );
      return;
    }
    state = state.copyWith(account: account);

    if (!account.hasFinancialData) {
      // Positive evidence of an empty account: the only thing that opens the
      // first-wallet path.
      _enterPhase(StartupPhase.confirmedEmpty);
      return;
    }

    // 5. There IS cloud data. It can only come down over sync, which is
    // premium-only — so the entitlement decides what happens next. Neither
    // answer is evidence of a new account, and neither may reach onboarding.
    final entitlement = _resolveEntitlement(account);
    if (entitlement == EntitlementStatus.notPremium) {
      _enterPhase(StartupPhase.entitlementRequired, reason: 'This account has data saved in the cloud. Restoring it needs an '
            'active subscription. Nothing has been deleted.',
      );
      return;
    }
    if (entitlement == EntitlementStatus.unknown) {
      _enterPhase(StartupPhase.checkingEntitlement, reason: 'This account has data in the cloud. We are still confirming your '
            'subscription so it can be restored.',
      );
      return;
    }

    // 6. Restore.
    _enterPhase(StartupPhase.restoring);
    try {
      await ref.read(syncNotifierProvider.notifier).syncAll();
    } catch (e) {
      _enterPhase(StartupPhase.unavailable, reason: 'Restore failed: $e',
      );
      return;
    }

    if (await _hasLocalWallets(ref)) {
      await _reloadWallets();
      _enterPhase(StartupPhase.restored);
      return;
    }

    // The server said there was data and the restore brought none down. That is
    // a contradiction, not an empty account — do not offer to start over.
    _enterPhase(StartupPhase.unavailable, reason: 'This account has data in the cloud but it could not be restored yet.',
    );
  }

  /// Combines what the device knows with what the backend says.
  ///
  /// The device can only ever confirm a positive (an IAP receipt it has
  /// verified). A negative has to come from the server, which is the difference
  /// between "still loading" and "your subscription has lapsed" — and therefore
  /// the difference between a spinner and a screen the user can act on.
  EntitlementStatus _resolveEntitlement(AccountBootstrap account) {
    final local = ref.read(entitlementStatusProvider);
    if (local == EntitlementStatus.premium) return EntitlementStatus.premium;
    if (local == EntitlementStatus.notPremium) {
      return EntitlementStatus.notPremium;
    }
    // A backend that does not report the entitlement leaves it genuinely
    // unknown. Reading the default `false` as "lapsed" would show an upgrade
    // prompt to someone whose subscription is perfectly fine.
    if (!account.describesEntitlement) return EntitlementStatus.unknown;
    return account.isPremium
        ? EntitlementStatus.premium
        : EntitlementStatus.notPremium;
  }

  /// Waits (bounded) for the account store switch to finish.
  Future<bool> _awaitStoreOwner(String? userId) async {
    if (userId == null) return false;
    for (var i = 0; i < 200; i++) {
      if (ref.read(activeStoreOwnerProvider) == userId) return true;
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
    return ref.read(activeStoreOwnerProvider) == userId;
  }

  Future<void> _reloadWallets() async {
    try {
      await ref.read(walletProvider.notifier).loadWallets(silent: true);
    } catch (e) {
      debugPrint('[StartupFlow] wallet reload failed: $e');
    }
  }
}

final startupFlowProvider =
    NotifierProvider<StartupFlowController, StartupFlowState>(
      StartupFlowController.new,
    );
