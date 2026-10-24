import 'dart:async';
import 'package:drift/drift.dart' show TableUpdate, TableUpdateQuery;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/providers/connectivity_provider.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';

/// Provider for the SyncService instance
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final apiService = ApiService();

  final service = SyncService(
    apiService: apiService,
    database: database,
    ref: ref,
  );

  ref.onDispose(() => service.dispose());

  return service;
});

/// Whether this account syncs with the cloud at all.
///
/// Every automatic trigger asks this first, so a free account never starts a
/// sync only to be turned away by the service — which also left the sync state
/// reading "error" after every app resume. Its own provider so the triggers can
/// be exercised in tests without a real subscription.
final cloudSyncAllowedProvider = Provider<bool>(
  (ref) => ref.watch(premiumProvider).isPremium,
);

/// How long after the last local edit a sync starts.
///
/// Long enough that adding a transaction and then correcting its category is
/// one upload, short enough that the other device has it before anyone goes to
/// look. A provider so tests need not wait it out.
final writeSyncDelayProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 8),
);

/// Counts the automatic sync failures the user should be told about.
///
/// The screen showing the message listens for it to go up. A counter rather
/// than a flag so two failure runs in a row are two events, not one value that
/// never changes.
final syncFailureNoticeProvider =
    NotifierProvider<SyncFailureNoticeNotifier, int>(
      SyncFailureNoticeNotifier.new,
    );

class SyncFailureNoticeNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void raise() => state++;
}

/// Decides which automatic sync failures are worth a word to the user.
///
/// Background syncs used to announce themselves every time ("Syncing…",
/// "Synced"), which is noise when they work, and said nothing at all when they
/// did not, which is the one case the user needs to hear about. Now a run of
/// failures is mentioned once, when it starts; the retries that follow are
/// quiet; and the next success ends the run, so a later failure is news again.
///
/// A sync that never ran — offline, already running, not an account that
/// syncs — is neither: it does not start a run and does not end one.
class SyncFailureStreak {
  bool _reported = false;

  /// Record [result]; returns true when it should be reported.
  bool record(SyncResult result) {
    if (result.success) {
      _reported = false;
      return false;
    }
    if (!result.isRealFailure || _reported) return false;
    _reported = true;
    return true;
  }

  /// A sync the user started and saw the outcome of succeeded.
  void reset() => _reported = false;
}

/// State notifier for sync operations
class SyncNotifier extends Notifier<SyncOperationState> {
  StreamSubscription<SyncOperationState>? _subscription;
  StreamSubscription<Set<TableUpdate>>? _writeSubscription;
  Timer? _periodicSyncTimer;
  Timer? _writeSyncTimer;

  /// Whether the periodic timer should be running while the app is in front.
  ///
  /// Separate from the timer itself because going to the background stops the
  /// timer without changing the intention; coming back has to know whether to
  /// start it again.
  bool _periodicWanted = false;

  bool _wasOnline = true;

  final SyncFailureStreak _failureStreak = SyncFailureStreak();

  /// Pending rows that the last sync offered the server and could not settle:
  /// held back for a question the user has not answered, rejected, or waiting
  /// on a parent. They stay pending, and a write-triggered sync must not keep
  /// retrying them on their own — only new work justifies one.
  Set<String> _unsettledAfterLastSync = const {};

  Duration get _writeSyncDelay => ref.read(writeSyncDelayProvider);

  @override
  SyncOperationState build() {
    // Listen to sync service state changes
    final syncService = ref.watch(syncServiceProvider);
    final database = ref.watch(databaseProvider);

    _subscription?.cancel();
    _subscription = syncService.stateStream.listen((newState) {
      state = newState;
    });

    // Local edits schedule a sync shortly after they stop. Drift reports the
    // tables a write touched; only the ones that sync matter here.
    _writeSubscription?.cancel();
    _writeSubscription = database
        .tableUpdates(const TableUpdateQuery.any())
        .listen(_onLocalWrite);

    // Auto-sync when connectivity transitions from offline to online
    ref.listen<bool>(isOnlineProvider, (previous, next) {
      final wasOffline = previous == false || !_wasOnline;
      _wasOnline = next;
      if (wasOffline && next) {
        debugPrint(
          '[SyncNotifier] Connectivity restored, triggering auto-sync',
        );
        triggerAutoSync(force: true);
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
      _writeSubscription?.cancel();
      _periodicSyncTimer?.cancel();
      _writeSyncTimer?.cancel();
    });

    return syncService.state;
  }

  /// Trigger a full sync
  Future<SyncResult> syncAll() async {
    final syncService = ref.read(syncServiceProvider);
    final database = ref.read(databaseProvider);

    final pendingBefore = await database.pendingRowFingerprints();
    final result = await syncService.syncAll();

    // Any complete sync starts the auto-sync cooldown, not just automatic
    // ones. The startup restore calls this directly, and leaving the clock
    // alone made the post-frame startup checks run a second full push and
    // pull straight after it, which is what kept "Syncing…" up at sign-in.
    if (result.success) {
      _lastAutoSyncAt = DateTime.now();
      _failureStreak.reset();
    }

    // A row pending both before and after, at the same version, was in this
    // sync and is still unsettled. One that appears only afterwards, or at a
    // newer version, is work the sync did not see. A sync that never ran
    // settled nothing and saw nothing, so it leaves the record alone.
    if (result.notRunReason == null) {
      final pendingAfter = await database.pendingRowFingerprints();
      _unsettledAfterLastSync = pendingBefore.intersection(pendingAfter);
    }

    // Refresh whatever this sync actually changed. A partial sync reports
    // success == false (so the user is told about the records that failed),
    // but the records that DID apply are already in the database and the UI
    // must show them.
    //
    // Pushing changes nothing anyone can see — it sends rows the user is
    // already looking at and marks them synced — and a pulled row identical to
    // the local one is not written at all. Only tables something was written
    // to are re-read, which after an ordinary edit is none of them.
    if (result.changedTables.isNotEmpty) {
      _refreshDataProviders(result.changedTables);
    }

    return result;
  }

  /// Hard-mirror restore: replace this device's data with the cloud copy.
  Future<SyncResult> restoreFromCloud() async {
    final syncService = ref.read(syncServiceProvider);
    final result = await syncService.restoreFromCloud();

    // Always refresh — local data was fully replaced.
    if (result.success) {
      _refreshDataProviders(null);
    }

    return result;
  }

  /// Silently reload the data providers that read [tables], or all of them
  /// when [tables] is null. Uses silent mode so no loading indicators flash in
  /// the UI.
  void _refreshDataProviders(Set<String>? tables) {
    bool touched(List<String> names) =>
        tables == null || names.any(tables.contains);

    // Balances move with transactions, so the wallet list follows them.
    if (touched(const ['wallets', 'transactions'])) {
      ref.read(walletProvider.notifier).loadWallets(silent: true);
    }
    if (touched(const ['categories', 'associated_titles'])) {
      ref.read(categoryProvider.notifier).loadCategories(silent: true);
    }
    // Transactions show their category, payment method and schedule.
    if (touched(const [
      'transactions',
      'categories',
      'payment_methods',
      'recurring_configs',
    ])) {
      ref.read(transactionProvider.notifier).loadTransactions(silent: true);
    }
    if (touched(const ['payment_methods'])) {
      ref.read(paymentMethodProvider.notifier).loadPaymentMethods(silent: true);
    }
    // Budget progress is computed from the transactions and categories it
    // counts.
    if (touched(const [
      'budgets',
      'category_budget_limits',
      'transactions',
      'categories',
    ])) {
      ref.read(budgetProvider.notifier).loadBudgets(silent: true);
    }
    if (touched(const [
      'wallets',
      'transactions',
      'categories',
      'objectives',
      'plans',
    ])) {
      ref.read(financialDataProvider.notifier).loadFinancialData(silent: true);
    }
  }

  /// When the last automatic sync finished successfully.
  DateTime? _lastAutoSyncAt;

  /// How soon after a successful automatic sync another one is worth starting.
  ///
  /// Launch fires three of them from places that do not know about each other:
  /// the startup flow's restore step, the first `resumed` lifecycle event, and
  /// the post-frame startup checks. `SyncService` refuses to run two at once,
  /// but that only staggers them — the second waited for the first and then did
  /// the whole push and pull again against a server that had nothing left to
  /// say.
  static const _autoSyncCooldown = Duration(seconds: 30);

  /// Trigger auto-sync silently (catches errors)
  ///
  /// [force] runs one regardless of how recently the last succeeded. For
  /// triggers that carry real news — connectivity coming back, say — rather
  /// than the launch sequence saying the same thing three times.
  Future<void> triggerAutoSync({bool force = false}) async {
    if (!ref.read(cloudSyncAllowedProvider)) return;

    final since = _lastAutoSyncAt;
    if (!force &&
        since != null &&
        DateTime.now().difference(since) < _autoSyncCooldown) {
      debugPrint(
        '[SyncNotifier] Skipping auto-sync; one finished '
        '${DateTime.now().difference(since).inSeconds}s ago',
      );
      return;
    }

    try {
      final result = await syncAll();

      // Nobody asked for this sync, so nothing is shown while it runs or when
      // it works. A failure is mentioned once per run of them; see
      // [SyncFailureStreak].
      if (_failureStreak.record(result)) {
        ref.read(syncFailureNoticeProvider.notifier).raise();
      }

      // Only a sync that actually ran starts the clock (syncAll sets it). One
      // that bounced off the in-progress guard, or failed offline, has said
      // nothing about whether the server is up to date, and must not suppress
      // the next try.
      // Background recurrence generation runs in a WorkManager isolate that
      // cannot sync on its own; it leaves a flag instead. Clear it once a
      // foreground sync has actually pushed, so the generated occurrences are
      // guaranteed to reach the cloud rather than waiting for the user to open
      // the sync screen.
      if (result.success) {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getBool(BackgroundTaskConstants.keyPendingBackgroundSync) ??
            false) {
          await prefs.remove(BackgroundTaskConstants.keyPendingBackgroundSync);
        }
      }
    } catch (e) {
      debugPrint('Auto sync failed: $e');
    }
  }

  /// A write landed in the local database.
  void _onLocalWrite(Set<TableUpdate> updates) {
    if (!updates.any((u) => AppDatabase.syncedTableNames.contains(u.table))) {
      return;
    }
    if (!ref.read(cloudSyncAllowedProvider)) return;
    // Restarted on every write, so a burst of edits is one sync after the last
    // of them rather than one per edit.
    _scheduleWriteSync(_writeSyncDelay);
  }

  void _scheduleWriteSync(Duration delay) {
    _writeSyncTimer?.cancel();
    _writeSyncTimer = Timer(delay, () => _runWriteSync());
  }

  /// The sync a local edit asked for, once the edits have stopped.
  ///
  /// Writes are also what a sync itself produces — applying a pull, marking
  /// rows sent — so most of the time this wakes to find nothing new and goes
  /// back to sleep. That check is what keeps a sync from scheduling the next
  /// one for ever.
  Future<void> _runWriteSync({bool ignoreCooldown = false}) async {
    _writeSyncTimer = null;
    if (!ref.read(cloudSyncAllowedProvider)) return;

    // One already running may or may not have collected these edits; look
    // again once it is done rather than starting a second behind it.
    if (ref.read(syncServiceProvider).isBusy) {
      _scheduleWriteSync(_writeSyncDelay);
      return;
    }

    // Inside the cooldown, wait for it to pass rather than dropping the edit:
    // it still has to reach the cloud, just not straight after the last sync.
    final last = _lastAutoSyncAt;
    if (!ignoreCooldown && last != null) {
      final wait = _autoSyncCooldown - DateTime.now().difference(last);
      if (wait > Duration.zero) {
        _scheduleWriteSync(wait);
        return;
      }
    }

    final pending = await ref.read(databaseProvider).pendingRowFingerprints();
    if (pending.difference(_unsettledAfterLastSync).isEmpty) return;

    await triggerAutoSync(force: true);
  }

  /// The app is going to the background: stop the periodic timer, and send any
  /// edit still waiting out its delay now, while the process is still allowed
  /// to run.
  void onAppPaused() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    if (_writeSyncTimer?.isActive ?? false) {
      _writeSyncTimer!.cancel();
      _runWriteSync(ignoreCooldown: true);
    }
  }

  /// The app is back in front: start the periodic timer again if it was
  /// running before, and catch up.
  void onAppResumed() {
    if (_periodicWanted) _startPeriodicTimer();
    triggerAutoSync();
  }

  /// Whether background processing left local changes that still need pushing.
  Future<bool> hasPendingBackgroundWork() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(BackgroundTaskConstants.keyPendingBackgroundSync) ??
        false;
  }

  /// Start periodic sync timer (every 15 minutes)
  void startPeriodicSync() {
    _periodicWanted = true;
    _startPeriodicTimer();
  }

  void _startPeriodicTimer() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => triggerAutoSync(),
    );
  }

  /// Stop periodic sync for good, until [startPeriodicSync] — on sign-out.
  void stopPeriodicSync() {
    _periodicWanted = false;
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    _writeSyncTimer?.cancel();
    _writeSyncTimer = null;
  }

  /// Whether the periodic timer is currently running.
  @visibleForTesting
  bool get isPeriodicSyncRunning => _periodicSyncTimer?.isActive ?? false;

  /// Whether a write-triggered sync is waiting out its delay.
  @visibleForTesting
  bool get hasScheduledWriteSync => _writeSyncTimer?.isActive ?? false;

  /// Check if device is online
  Future<bool> isOnline() async {
    final syncService = ref.read(syncServiceProvider);
    return await syncService.isOnline();
  }

  /// Get server sync status
  Future<SyncStatusResponse?> getServerStatus() async {
    final syncService = ref.read(syncServiceProvider);
    return await syncService.getServerSyncStatus();
  }

  /// Get last sync result
  SyncResult? get lastResult {
    final syncService = ref.read(syncServiceProvider);
    return syncService.lastResult;
  }
}

/// Provider for sync notifier
final syncNotifierProvider = NotifierProvider<SyncNotifier, SyncOperationState>(
  SyncNotifier.new,
);

/// Provider to track if sync is in progress
final isSyncingProvider = Provider<bool>((ref) {
  final state = ref.watch(syncNotifierProvider);
  return state == SyncOperationState.syncing;
});
