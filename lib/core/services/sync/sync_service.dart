import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/category_initialization_service.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_transport.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType, TransactionType;
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:drift/drift.dart';

/// Thrown to roll back a cloud restore when any record in the server payload
/// cannot be applied. Rolling back is the whole point: a restore that clears the
/// local database and then drops part of the cloud copy would destroy data while
/// reporting success.
class SyncRestoreAbortedException implements Exception {
  final List<SyncApplyFailure> failures;
  SyncRestoreAbortedException(this.failures);

  @override
  String toString() =>
      'Cloud restore aborted; local data left unchanged. Failures: $failures';
}

/// Hybrid Sync Service
/// Handles local-first data with optional backend synchronization
/// Aligned with backend API endpoints:
/// - GET /sync/status
/// - GET /sync/pull?since={datetime}
/// - POST /sync/push
class SyncService {
  /// Network access, injectable so the whole protocol can be driven against an
  /// in-memory server in tests.
  final SyncTransport _transport;
  final AppDatabase _database;
  final Ref? _ref;
  final Logger _logger = Logger();

  // Sync state
  SyncOperationState _state = SyncOperationState.idle;
  SyncOperationState get state => _state;

  // Stream controller for sync state updates
  final _stateController = StreamController<SyncOperationState>.broadcast();
  Stream<SyncOperationState> get stateStream => _stateController.stream;

  // Last sync result
  SyncResult? _lastResult;
  SyncResult? get lastResult => _lastResult;

  // Last sync timestamp
  DateTime? _lastSyncAt;
  bool _lastSyncLoaded = false;

  // Synchronous re-entrancy guard for syncAll (set before any await).
  bool _syncInProgress = false;

  SyncService({
    ApiService? apiService,
    required AppDatabase database,
    Ref? ref,
    SyncTransport? transport,
  }) : _transport = transport ?? ApiSyncTransport(apiService ?? ApiService()),
       // `_transport` is derived rather than assigned straight from a
       // parameter, so this constructor cannot use initialising formals for the
       // remaining fields either.
       // ignore: prefer_initializing_formals
       _database = database,
       // ignore: prefer_initializing_formals
       _ref = ref;

  /// Check if device is online
  Future<bool> isOnline() => _transport.isOnline();

  /// Full sync operation - pushes local changes, pulls remote changes
  /// Requires Premium subscription
  Future<SyncResult> syncAll() async {
    // Synchronous guard set BEFORE any await, so overlapping triggers (app-resume,
    // connectivity-restored, the periodic timer) cannot start two syncs concurrently and
    // double-push the same pending set.
    if (_syncInProgress) {
      return SyncResult.failure('Sync already in progress');
    }
    _syncInProgress = true;
    try {
      return await _runSync();
    } finally {
      _syncInProgress = false;
    }
  }

  /// Hard-mirror restore: replace ALL local data with the cloud copy (Premium).
  ///
  /// Fetches the full server dataset FIRST (into memory); only once that
  /// succeeds does it wipe local and apply the server data — so a mid-restore
  /// network failure can never leave the app empty. This intentionally discards
  /// any local-only changes that haven't been pushed to the cloud.
  Future<SyncResult> restoreFromCloud() async {
    if (_syncInProgress) {
      return SyncResult.failure('Sync already in progress');
    }
    _syncInProgress = true;
    try {
      return await _runRestore();
    } finally {
      _syncInProgress = false;
    }
  }

  Future<SyncResult> _runRestore() async {
    // Premium gate — cloud sync/restore is a premium feature.
    if (_ref != null) {
      final premiumState = _ref.read(premiumProvider);
      if (!premiumState.isPremium) {
        _setState(SyncOperationState.error);
        return SyncResult.failure('Cloud sync requires Premium subscription');
      }
    }

    _setState(SyncOperationState.syncing);

    if (!await isOnline()) {
      _setState(SyncOperationState.offline);
      return SyncResult.failure('No internet connection');
    }
    if (!await _transport.hasToken()) {
      _setState(SyncOperationState.error);
      return SyncResult.failure('Not authenticated');
    }

    final ownershipError = await _assertStoreOwnership();
    if (ownershipError != null) {
      _setState(SyncOperationState.error);
      return SyncResult.failure(ownershipError);
    }

    try {
      // Force a FULL pull (server omits `since` and returns everything) by
      // clearing the cursor.
      _lastSyncAt = null;
      _lastSyncLoaded = true;

      // Fetch everything from the server FIRST, before touching local data.
      final pull = await _pullAllChanges();
      if (pull == null) {
        _setState(SyncOperationState.error);
        return SyncResult.failure(
          'Could not fetch your cloud data. Local data is unchanged.',
        );
      }

      // Wipe-and-replace runs inside ONE database transaction, and any record
      // that cannot be applied aborts it. That is what makes a restore
      // all-or-nothing: previously the local data was cleared first and bad
      // records were merely logged, so a restore could destroy a good local
      // database, drop part of the cloud copy, and still report success.
      var restored = 0;
      List<SyncApplyFailure> failures = const [];
      await _database.transaction(() async {
        // Do NOT re-seed system categories here: fresh local ids would collide
        // with the account's own copies arriving in this very payload.
        await _database.clearAllData(reseedSystemCategories: false);
        final outcome = await _applyOrderedChanges(pull);
        restored = outcome.applied;
        failures = outcome.failures;
        if (failures.isNotEmpty) {
          throw SyncRestoreAbortedException(failures);
        }
        // Fill any system category the cloud snapshot did not contain.
        await _database.ensureSystemCategoriesExist();

        // Recompute wallet balances from the freshly-restored transactions.
        await WalletBalanceService(
          _database,
        ).recalculateAllWalletBalancesLocal();
      });

      // Advance the cursor so subsequent normal syncs are deltas again.
      _lastSyncAt = pull.serverTime ?? DateTime.now();
      await _saveLastSyncTimestamp(_lastSyncAt!);

      _setState(SyncOperationState.success);
      _logger.i('Restore from cloud complete: restored=$restored records');
      _lastResult = SyncResult.success(
        pushedCount: 0,
        pulledCount: restored,
        conflictCount: 0,
        duration: Duration.zero,
      );
      return _lastResult!;
    } on SyncRestoreAbortedException catch (e) {
      // The transaction rolled back, so the local database is exactly as it was
      // before the restore started.
      _logger.e('Restore aborted, local data left untouched: ${e.failures}');
      _setState(SyncOperationState.error);
      _lastResult = SyncResult.partial(
        applyFailures: e.failures,
        pulledCount: 0,
      );
      return _lastResult!;
    } catch (e, stack) {
      _logger.e('Restore from cloud error: $e', error: e, stackTrace: stack);
      _setState(SyncOperationState.error);
      _lastResult = SyncResult.failure(e.toString());
      return _lastResult!;
    }
  }

  Future<SyncResult> _runSync() async {
    // Check premium status - sync is a premium feature
    if (_ref != null) {
      final premiumState = _ref.read(premiumProvider);
      if (!premiumState.isPremium) {
        _setState(SyncOperationState.error);
        return SyncResult.failure('Cloud sync requires Premium subscription');
      }
    }

    // Load persisted timestamp on first sync
    if (!_lastSyncLoaded) {
      await _loadLastSyncTimestamp();
    }

    final startTime = DateTime.now();
    _setState(SyncOperationState.syncing);

    // Check connectivity
    if (!await isOnline()) {
      _setState(SyncOperationState.offline);
      return SyncResult.failure('No internet connection');
    }

    // Check authentication
    if (!await _transport.hasToken()) {
      _setState(SyncOperationState.error);
      return SyncResult.failure('Not authenticated');
    }

    // Refuse to sync a store that belongs to a different account. This is the
    // last line of defence behind the per-account database files: even if a
    // store were somehow left open across an account switch, its pending rows
    // can never be uploaded under the new user's credentials.
    final ownershipError = await _assertStoreOwnership();
    if (ownershipError != null) {
      _setState(SyncOperationState.error);
      return SyncResult.failure(ownershipError);
    }

    int totalPushed = 0;
    int totalPulled = 0;
    final conflicts = <SyncConflict>[];
    final applyFailures = <SyncApplyFailure>[];

    try {
      // Step 1: Push all local changes (chunked; see [_pushAllChanges]).
      final push = await _pushAllChanges();
      totalPushed = push.appliedCount;
      conflicts.addAll(push.conflicts);

      // Step 2: Pull all remote changes
      final pullResult = await _pullAllChanges();
      if (pullResult != null) {
        totalPulled = pullResult.totalChanges;

        // Apply the whole batch in dependency order inside one database
        // transaction. Parents (wallets, categories, payment methods) land
        // before the transactions that reference them, and deletes run in
        // reverse order so a parent is never removed out from under a child.
        final outcome = await _database.transaction(() async {
          final result = await _applyOrderedChanges(pullResult);
          if (result.applied > 0) {
            // Balance is a last-write-wins scalar on the server and can be
            // stale across devices, so we never trust the pulled value — we
            // derive it and persist it WITHOUT a pending flag (no re-push, no
            // ping-pong).
            await WalletBalanceService(
              _database,
            ).recalculateAllWalletBalancesLocal();
          }
          return result;
        });
        applyFailures.addAll(outcome.failures);

        // Reconcile transfer pairs where one leg was deleted on another device,
        // so a half-transfer can never sit in the ledger skewing one wallet's
        // balance. Skipped when anything failed to apply: mid-failure the local
        // picture is incomplete, and acting on it could tombstone a leg whose
        // partner simply hasn't landed yet.
        if (applyFailures.isEmpty) {
          await TransferService(_database).reconcileTransferPairs();

          // Collapse duplicate built-in categories. A device that seeded its own
          // defaults before it had seen the account's cloud data now holds both
          // its copy and the canonical one; they share a `defaultKey`, which is
          // proof they are the same built-in, so the merge is safe. Without this
          // every new device left the account with another full set of defaults.
          final merged = await _database.mergeDuplicateDefaultCategories();
          if (merged > 0) {
            _logger.i('Merged $merged duplicate default categories');
          }

          // A brand-new device whose account had no cloud categories still needs
          // its built-ins; seeding is per-slug, so this only fills genuine gaps.
          await CategoryInitializationService(
            _database,
          ).initializeDefaultCategories();
        }

        if (applyFailures.isEmpty) {
          // Advance the cursor using the SERVER's timestamp (falling back to
          // local time only if absent), so client clock skew can't skip
          // server-side changes on the next pull.
          _lastSyncAt = pullResult.serverTime ?? DateTime.now();
          await _saveLastSyncTimestamp(_lastSyncAt!);
        } else {
          // Leave the cursor exactly where it was. The unapplied records are
          // returned by the next pull and retried; advancing here is what used
          // to make a rejected transaction disappear from the device forever.
          _logger.w(
            'Sync applied with ${applyFailures.length} failure(s); cursor NOT '
            'advanced so they will be retried: $applyFailures',
          );
        }
      }

      final duration = DateTime.now().difference(startTime);

      if (applyFailures.isNotEmpty) {
        _lastResult = SyncResult.partial(
          pushedCount: totalPushed,
          pulledCount: totalPulled - applyFailures.length,
          conflictCount: conflicts.length,
          duration: duration,
          conflicts: conflicts,
          applyFailures: applyFailures,
        );
        _setState(SyncOperationState.error);
        return _lastResult!;
      }

      _lastResult = SyncResult.success(
        pushedCount: totalPushed,
        pulledCount: totalPulled,
        conflictCount: conflicts.length,
        duration: duration,
        conflicts: conflicts,
      );

      _setState(SyncOperationState.success);
      _logger.i(
        'Sync completed: pushed=$totalPushed, pulled=$totalPulled, '
        'conflicts=${conflicts.length}',
      );

      return _lastResult!;
    } catch (e, stack) {
      _logger.e('Sync error: $e', error: e, stackTrace: stack);
      _setState(SyncOperationState.error);
      _lastResult = SyncResult.failure(e.toString());
      return _lastResult!;
    }
  }

  /// Verify the open local store belongs to the authenticated user.
  ///
  /// Returns null when the sync may proceed, or a user-facing message when it
  /// must not.
  Future<String?> _assertStoreOwnership() async {
    final jwtUserId = await _authenticatedUserId();
    if (jwtUserId == null || jwtUserId.isEmpty) {
      return 'Could not determine the signed-in account; sync cancelled.';
    }

    final owner = await _database.getLocalStoreOwnerUserId();
    if (owner == null) {
      // A store that has never been claimed is this account's to adopt (the
      // offline-first user who has just signed up).
      await _database.claimLocalStore(userId: jwtUserId);
      return null;
    }
    if (owner != jwtUserId) {
      return 'This device\'s data belongs to a different account. '
          'Sign in as that account, or clear the local data, before syncing.';
    }
    return null;
  }

  /// User id of the account the current access token was issued to.
  ///
  /// Read from the JWT itself rather than from cached preferences, because the
  /// token is what the server will authorize the push against — using anything
  /// else could let a stale cached id vouch for the wrong account.
  Future<String?> _authenticatedUserId() async {
    final token = await _transport.getToken();
    final fromToken = token == null ? null : _userIdFromJwt(token);
    if (fromToken != null && fromToken.isNotEmpty) return fromToken;
    try {
      return await SecureTokenStorage.getUserId();
    } catch (_) {
      // Secure storage needs a platform channel; absent in unit tests.
      return null;
    }
  }

  static String? _userIdFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      payload = payload.padRight((payload.length + 3) ~/ 4 * 4, '=');
      final decoded =
          jsonDecode(utf8.decode(base64.decode(payload)))
              as Map<String, dynamic>;
      for (final claim in const [
        'sub',
        'nameid',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier',
        'userId',
        'user_id',
      ]) {
        final value = decoded[claim];
        if (value is String && value.isNotEmpty) return value;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Load persisted last sync timestamp from DB
  Future<void> _loadLastSyncTimestamp() async {
    _lastSyncAt = await _database.getLastSyncTimestamp();
    _lastSyncLoaded = true;
    _logger.d('Loaded persisted lastSyncAt: $_lastSyncAt');
  }

  /// Save last sync timestamp to DB
  Future<void> _saveLastSyncTimestamp(DateTime timestamp) async {
    await _database.setLastSyncTimestamp(timestamp);
  }

  /// Maximum changes per push request.
  ///
  /// The backend validator rejects a batch larger than 1,000 outright, so an
  /// import or a long offline period used to make *every* subsequent sync fail
  /// as a whole. Chunking below that limit means a large backlog drains over
  /// several requests instead of deadlocking. Kept well under the cap so a
  /// future limit change doesn't immediately re-break it.
  static const int maxChangesPerPush = 400;

  /// Push all pending local changes to the server, in dependency order, in
  /// chunks small enough for the server to accept.
  ///
  /// Only records the server actually acknowledged are marked synced; anything
  /// it rejected is left pending so the pull can bring the authoritative server
  /// copy instead of the local edit being silently discarded. If a chunk fails
  /// outright, earlier chunks keep their acknowledged state and the error
  /// propagates — a later chunk can never mark an unsent record as synced.
  Future<({int appliedCount, List<SyncConflict> conflicts})>
  _pushAllChanges() async {
    var pass = await _pushPendingChanges();

    // Settling a reconciliation releases records that were held back — the
    // transactions the user entered offline against a provisional category, and
    // its subcategories — but only after this pass had already collected its
    // batch. Run once more so answering the question and seeing your data
    // upload are the same sync, rather than "answer, sync, sync again".
    //
    // At most one extra pass: the second cannot settle anything new, because a
    // resolution is only ever created by the user.
    if (pass.resolutionsApplied == 0) {
      return (appliedCount: pass.appliedCount, conflicts: pass.conflicts);
    }

    final second = await _pushPendingChanges();
    return (
      appliedCount: pass.appliedCount + second.appliedCount,
      conflicts: [...pass.conflicts, ...second.conflicts],
    );
  }

  Future<
    ({int appliedCount, List<SyncConflict> conflicts, int resolutionsApplied})
  >
  _pushPendingChanges() async {
    // Collect pending changes grouped by table, then flatten in the shared
    // dependency order so a chunk boundary can never place a child ahead of the
    // parent it needs.
    final byTable = <String, List<SyncChange>>{
      'wallets': await _getPendingWalletChanges(),
      'categories': await _getPendingCategoryChanges(),
      'payment_methods': await _getPendingPaymentMethodChanges(),
      'budgets': await _getPendingBudgetChanges(),
      'objectives': await _getPendingObjectiveChanges(),
      'transactions': await _getPendingTransactionChanges(),
      'recurring_configs': await _getPendingRecurringConfigChanges(),
    };

    final allChanges = <SyncChange>[];
    for (final table in SyncEntityOrder.applyOrder) {
      allChanges.addAll(byTable[table] ?? const []);
    }

    if (allChanges.isEmpty) {
      _logger.d('No pending changes to push');
      return (
        appliedCount: 0,
        conflicts: <SyncConflict>[],
        resolutionsApplied: 0,
      );
    }

    _logger.d(
      'Pushing ${allChanges.length} changes in chunks of $maxChangesPerPush',
    );

    var appliedCount = 0;
    var resolutionsApplied = 0;
    final conflicts = <SyncConflict>[];

    for (var start = 0; start < allChanges.length; start += maxChangesPerPush) {
      final end = (start + maxChangesPerPush).clamp(0, allChanges.length);
      final chunk = allChanges.sublist(start, end);

      final SyncPushResponse response;
      try {
        response = await _transport.push(chunk);
      } catch (e) {
        _logger.e('Push chunk ${start ~/ maxChangesPerPush} failed: $e');
        rethrow;
      }

      appliedCount += response.appliedCount;
      conflicts.addAll(response.conflicts);

      // Record any new reconciliation questions BEFORE anything else, so the
      // next collection already holds the affected records back.
      await _recordReconciliationConflicts(response.conflicts);

      // Apply confirmed resolutions BEFORE marking anything synced. An adopted
      // provisional category is folded into the row that won, and folding only
      // deletes it outright while it is still `pendingCreate` — mark it synced
      // first and it would instead be tombstoned and pushed as a delete for an
      // id the server never had.
      final resolvedProvisionalIds = await _applyCategoryResolutions(
        response.categoryResolutions,
      );
      resolutionsApplied += response.categoryResolutions.length;

      final conflictKeys = response.conflicts
          .map((c) => '${c.tableName}:${c.entityId}')
          .toSet();
      final accepted = chunk
          .where((c) => !conflictKeys.contains('${c.tableName}:${c.entityId}'))
          .toList();

      // An accepted change that carried a resolution has done its job; the
      // question is settled and the row can go. (Adoption is reported back
      // explicitly and cleared above; "create it separately" simply succeeds.)
      for (final change in accepted) {
        if (change.tableName != 'categories' || change.resolution == null) {
          continue;
        }
        final key = _categoryDefaultKeyOf(change);
        if (key == null) continue;
        if (await _database.findCategoryReconciliation(key) != null) {
          await _database.clearCategoryReconciliation(key);
          resolutionsApplied++;
        }
      }

      await _markChangesSynced(
        accepted
            .where(
              (c) =>
                  c.tableName != 'categories' ||
                  !resolvedProvisionalIds.contains(c.entityId),
            )
            .toList(),
      );
    }

    return (
      appliedCount: appliedCount,
      conflicts: conflicts,
      resolutionsApplied: resolutionsApplied,
    );
  }

  /// Apply a pulled batch in dependency order, collecting per-record failures.
  ///
  /// Returns how many records were applied and which ones were not. A record is
  /// rejected *before* it is written when a parent it references is missing, so
  /// the failure carries an actionable reason instead of surfacing later as an
  /// orphaned row that silently breaks joins and balances.
  Future<({int applied, List<SyncApplyFailure> failures})> _applyOrderedChanges(
    SyncPullResponse pull,
  ) async {
    var applied = 0;
    final failures = <SyncApplyFailure>[];

    for (final entry in pull.orderedChanges) {
      final table = entry.table;
      final change = entry.change;
      try {
        final missingParent = await _missingParentFor(table, change);
        if (missingParent != null) {
          failures.add(
            SyncApplyFailure(
              tableName: table,
              entityId: change.entityId,
              reason: missingParent,
              isMissingParent: true,
            ),
          );
          continue;
        }
        await _applyPulledChange(table, change);
        applied++;
      } catch (e, s) {
        _logger.w(
          'Failed to apply $table record ${change.entityId}: $e',
          error: e,
          stackTrace: s,
        );
        failures.add(
          SyncApplyFailure(
            tableName: table,
            entityId: change.entityId,
            reason: e.toString(),
          ),
        );
      }
    }

    return (applied: applied, failures: failures);
  }

  /// Describe the first missing parent for [change], or null when every
  /// referenced record is present locally.
  ///
  /// SQLite foreign-key enforcement is intentionally left off (legacy installs
  /// can contain rows referencing hard-deleted parents, and switching it on
  /// globally would turn those into hard write failures during ordinary use).
  /// Checking explicitly here gives the same protection where it matters, with
  /// a diagnostic the user and the logs can act on.
  Future<String?> _missingParentFor(String table, SyncChange change) async {
    if (change.operation == 'delete' || change.data == null) return null;
    final data = _normalizeKeys(change.data!);

    switch (table) {
      case 'transactions':
        final walletId = data['WalletId'] as String?;
        if (walletId == null || walletId.isEmpty) {
          return 'transaction has no wallet reference';
        }
        final wallet = await _liveWallet(walletId);
        if (wallet != null) return wallet;

        final category = await _liveCategory(data['CategoryId'] as String?);
        if (category != null) return category;

        final paymentMethod = await _livePaymentMethod(
          data['PaymentMethodId'] as String?,
        );
        if (paymentMethod != null) return paymentMethod;

        final budget = await _liveBudget(data['BudgetId'] as String?);
        if (budget != null) return budget;

        final objective = await _liveObjective(data['ObjectiveId'] as String?);
        if (objective != null) return objective;

        // RecurringConfigId and PairedTransactionId are deliberately NOT checked
        // here. Both are cyclic: a recurring config points back at its base
        // transaction, and the two legs of a transfer point at each other, so
        // one side of each pair is necessarily unresolvable at the moment the
        // other is applied. Recurring configs are applied after transactions in
        // the dependency order, and transfer pairs are reconciled after the
        // batch commits (`TransferService.reconcileTransferPairs`), which is
        // where a genuinely orphaned leg is caught.
        return null;

      case 'recurring_configs':
        final baseId = data['BaseTransactionId'] as String?;
        if (baseId == null || baseId.isEmpty) {
          return 'recurring config has no base transaction';
        }
        final base = await _database.findTransactionById(baseId);
        if (base == null) {
          return 'base transaction $baseId is not available locally';
        }
        if (base.deletedAt != null) {
          return 'base transaction $baseId has been deleted';
        }
        return null;

      case 'objectives':
        return _liveWallet(data['WalletId'] as String?);

      case 'budgets':
        return null;

      default:
        return null;
    }
  }

  // Parent lookups used by [_missingParentFor]. Each returns null when the
  // reference is acceptable, or a reason when it is not.
  //
  // Every one of these distinguishes "no such row" from "row exists but is
  // tombstoned". The plain `findXById` helpers return soft-deleted rows, so
  // using them as proof of validity let a transaction attach itself to a wallet
  // or category another device had already deleted — the record then existed
  // locally but could never be displayed.

  Future<String?> _liveWallet(String? id) async {
    if (id == null || id.isEmpty) return null;
    final row = await _database.findWalletById(id);
    if (row == null) return 'wallet $id is not available locally';
    if (row.deletedAt != null) return 'wallet $id has been deleted';
    return null;
  }

  Future<String?> _liveCategory(String? id) async {
    if (id == null || id.isEmpty) return null;
    final row = await _database.findCategoryById(id);
    if (row == null) return 'category $id is not available locally';
    if (row.deletedAt != null) return 'category $id has been deleted';
    return null;
  }

  Future<String?> _livePaymentMethod(String? id) async {
    if (id == null || id.isEmpty) return null;
    final row = await _database.findPaymentMethodById(id);
    if (row == null) return 'payment method $id is not available locally';
    if (row.deletedAt != null) return 'payment method $id has been deleted';
    return null;
  }

  Future<String?> _liveBudget(String? id) async {
    if (id == null || id.isEmpty) return null;
    final row = await _database.findBudgetById(id);
    if (row == null) return 'budget $id is not available locally';
    if (row.deletedAt != null) return 'budget $id has been deleted';
    return null;
  }

  Future<String?> _liveObjective(String? id) async {
    if (id == null || id.isEmpty) return null;
    final row = await _database.findObjectiveById(id);
    if (row == null) return 'objective $id is not available locally';
    if (row.deletedAt != null) return 'objective $id has been deleted';
    return null;
  }

  /// Pull all changes from server since last sync
  Future<SyncPullResponse?> _pullAllChanges() async {
    try {
      return await _transport.pull(_lastSyncAt);
    } catch (e) {
      _logger.e('Pull failed: $e');
      rethrow;
    }
  }

  static String? _categoryDefaultKeyOf(SyncChange change) {
    final value = change.data?['DefaultKey'] ?? change.data?['default_key'];
    return value is String && value.isNotEmpty ? value : null;
  }

  /// Turns "this account may already have that category" rejections into a
  /// question the user can actually answer.
  ///
  /// Nothing is decided here. The candidates the server offered are stored
  /// verbatim — so the question survives going offline — and the provisional
  /// category is held back from further pushes until the user chooses.
  Future<void> _recordReconciliationConflicts(
    List<SyncConflict> conflicts,
  ) async {
    for (final conflict in conflicts) {
      if (conflict.code !=
          SyncConflictCodes.legacyCategoryReconciliationRequired) {
        continue;
      }
      final details = LegacyCategoryReconciliationDetails.tryParse(
        conflict.details,
      );
      if (details == null) {
        _logger.w(
          'Reconciliation conflict for ${conflict.entityId} had no usable '
          'details; leaving the category pending.',
        );
        continue;
      }

      await _database.recordCategoryReconciliation(
        defaultKey: details.defaultKey,
        provisionalCategoryId: conflict.entityId,
        catalogName: details.catalogName,
        catalogIsIncome: details.catalogIsIncome,
        candidatesJson: jsonEncode(
          details.candidates.map((c) => c.toJson()).toList(),
        ),
      );
      _logger.i(
        'Built-in category "${details.defaultKey}" needs the user to confirm '
        'whether ${details.candidates.length} existing categor'
        '${details.candidates.length == 1 ? "y is" : "ies are"} already it.',
      );
    }

    // A decision the server could not act on any more — the chosen category was
    // deleted or claimed in the meantime. Drop the stale answer so the question
    // is asked again with a fresh list, instead of retrying a dead choice.
    for (final conflict in conflicts) {
      if (conflict.code !=
          SyncConflictCodes.legacyCategoryCandidateUnavailable) {
        continue;
      }
      final key =
          conflict.details?['default_key'] ??
          conflict.details?['DefaultKey'] ??
          conflict.details?['defaultKey'];
      if (key is! String || key.isEmpty) continue;
      final existing = await _database.findCategoryReconciliation(key);
      if (existing == null) continue;
      // Reopened rather than deleted: the provisional category still must not
      // be pushed, and the user still owes an answer — just a different one.
      await _database.reopenCategoryReconciliation(key);
      _logger.w(
        'Resolution for "$key" could no longer be applied '
        '(${conflict.reason}); asking again.',
      );
    }
  }

  /// Settles local state after the server acted on a user's decision.
  ///
  /// Returns the provisional category ids that no longer exist locally, so the
  /// caller does not try to mark them synced.
  Future<Set<String>> _applyCategoryResolutions(
    List<SyncCategoryResolutionResult> resolutions,
  ) async {
    final absorbed = <String>{};
    for (final resolution in resolutions) {
      if (resolution.kind != CategoryReconciliationKinds.adoptLegacy) {
        await _database.clearCategoryReconciliation(resolution.defaultKey);
        continue;
      }

      // Free the slug before handing it over: the local unique index allows
      // exactly one holder, and right now that is the provisional copy.
      await _database.releaseDefaultKey(resolution.requestedEntityId);

      // The adopted row is the survivor. Make sure it exists here first — this
      // device may never have pulled it — then fold the provisional copy into
      // it. Folding carries the transactions, subcategories, and learned titles
      // across without disturbing their pending state, which is what lets
      // records entered offline against the provisional category sync normally
      // from here on.
      await _database.materializeAdoptedCategory(
        id: resolution.resolvedCategoryId,
        defaultKey: resolution.defaultKey,
        name: resolution.name,
        isIncome: resolution.isIncome,
        iconName: resolution.iconName,
        colorCode: resolution.color,
        orderIndex: resolution.orderIndex,
      );
      await _database.absorbDuplicateDefaultCategory(
        loserId: resolution.requestedEntityId,
        survivorId: resolution.resolvedCategoryId,
      );
      await _database.clearCategoryReconciliation(resolution.defaultKey);
      absorbed.add(resolution.requestedEntityId);

      _logger.i(
        'Adopted existing category ${resolution.resolvedCategoryId} as '
        '"${resolution.defaultKey}"; folded in local '
        '${resolution.requestedEntityId}.',
      );
    }
    return absorbed;
  }

  // ==================== GET PENDING CHANGES ====================

  Future<List<SyncChange>> _getPendingTransactionChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.transactions,
    )..where((t) => t.syncStatus.isBiggerThanValue(0))).get();

    // Anything filed against a category the server has not accepted yet has to
    // wait with it. These are real records the user entered offline, so they are
    // held — never dropped, never downgraded — and go up untouched once the
    // category question is answered and the category exists server-side.
    final blocked = await _database.unsettledProvisionalCategoryIds();

    for (final r in records) {
      if (blocked.contains(r.categoryId)) continue;
      changes.add(
        SyncChange(
          tableName: 'transactions',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _transactionToMap(r),
        ),
      );
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingWalletChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.wallets,
    )..where((w) => w.syncStatus.isBiggerThanValue(0))).get();

    for (final r in records) {
      changes.add(
        SyncChange(
          tableName: 'wallets',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _walletToMap(r),
        ),
      );
    }
    return changes;
  }

  /// Pending category changes, minus the ones the server is still waiting on the
  /// user to explain.
  ///
  /// A provisional built-in whose reconciliation question is unanswered is held
  /// back entirely: re-pushing it produces the same rejection on every sync, and
  /// a permanent stream of conflicts is indistinguishable to the user from the
  /// app being broken. The record keeps its `pendingCreate` status while it
  /// waits, so answering the question uploads it intact rather than resurrecting
  /// it as an update the server has no row for.
  ///
  /// Once answered, the decision rides along with the change as an explicit
  /// resolution — the one thing that lets the server act on it.
  Future<List<SyncChange>> _getPendingCategoryChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.categories,
    )..where((c) => c.syncStatus.isBiggerThanValue(0))).get();

    final reconciliations = await _database.allCategoryReconciliations();
    final byProvisionalId = {
      for (final r in reconciliations) r.provisionalCategoryId: r,
    };
    // The provisional category itself is released as soon as the user answers,
    // because pushing it is how the answer gets to the server.
    final unanswered = reconciliations
        .where((r) => r.resolutionKind == null)
        .map((r) => r.provisionalCategoryId)
        .toSet();
    // Anything REFERENCING it stays held until the answer has actually been
    // applied. If the user adopted an existing category, the provisional id is
    // one the server will never store, so a child pushed with that reference
    // would be accepted pointing at nothing — and the next pull would hand the
    // stale reference straight back, undoing the merge.
    final unsettled = reconciliations
        .map((r) => r.provisionalCategoryId)
        .toSet();

    for (final r in records) {
      if (unanswered.contains(r.id)) continue;
      if (r.mainCategoryId != null && unsettled.contains(r.mainCategoryId)) {
        continue;
      }

      final pending = byProvisionalId[r.id];
      changes.add(
        SyncChange(
          tableName: 'categories',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _categoryToMap(r),
          resolution: pending?.resolutionKind == null
              ? null
              : SyncChangeResolution(
                  kind: pending!.resolutionKind!,
                  candidateId: pending.resolutionCandidateId,
                ),
        ),
      );
    }
    return changes;
  }

  /// Pending budget changes, minus any scoped to a category whose fate is not
  /// settled.
  ///
  /// A budget names its categories in `categoryIds` (and the older single
  /// `categoryId`), neither of which is a foreign key — so the server would
  /// happily store a budget pointing at a provisional category it never
  /// received. If the user then adopted an existing category, the budget would
  /// be left permanently scoped to an id that exists nowhere: no error, no
  /// conflict, just a budget that counts none of the transactions it should and
  /// reports progress and alerts that are wrong.
  Future<List<SyncChange>> _getPendingBudgetChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.budgets,
    )..where((b) => b.syncStatus.isBiggerThanValue(0))).get();

    final unsettled = await _database.unsettledProvisionalCategoryIds();

    for (final r in records) {
      if (unsettled.isNotEmpty &&
          AppDatabase.budgetCategoryReferences(r).any(unsettled.contains)) {
        continue;
      }
      changes.add(
        SyncChange(
          tableName: 'budgets',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _budgetToMap(r),
        ),
      );
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingObjectiveChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.objectives,
    )..where((o) => o.syncStatus.isBiggerThanValue(0))).get();

    for (final r in records) {
      changes.add(
        SyncChange(
          tableName: 'objectives',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _objectiveToMap(r),
        ),
      );
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingPaymentMethodChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.paymentMethods,
    )..where((p) => p.syncStatus.isBiggerThanValue(0))).get();

    for (final r in records) {
      changes.add(
        SyncChange(
          tableName: 'payment_methods',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _paymentMethodToMap(r),
        ),
      );
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingRecurringConfigChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(
      _database.recurringConfigs,
    )..where((r) => r.syncStatus.isBiggerThanValue(0))).get();

    for (final r in records) {
      changes.add(
        SyncChange(
          tableName: 'recurring_configs',
          entityId: r.id,
          operation: _getOperationFromStatus(r.syncStatus),
          sourceUpdatedAt: r.updatedAt,
          data: _recurringConfigToMap(r),
        ),
      );
    }
    return changes;
  }

  // ==================== APPLY PULLED CHANGES ====================

  Future<void> _applyPulledChange(String tableName, SyncChange change) async {
    if (change.data == null && change.operation != 'delete') return;

    switch (tableName) {
      case 'transactions':
        await _applyTransactionChange(change);
        break;
      case 'wallets':
        await _applyWalletChange(change);
        break;
      case 'categories':
        await _applyCategoryChange(change);
        break;
      case 'budgets':
        await _applyBudgetChange(change);
        break;
      case 'objectives':
        await _applyObjectiveChange(change);
        break;
      case 'payment_methods':
        await _applyPaymentMethodChange(change);
        break;
      case 'recurring_configs':
        await _applyRecurringConfigChange(change);
        break;
    }
  }

  Future<void> _applyTransactionChange(SyncChange change) async {
    final rawData = change.data;
    if (change.operation == 'delete') {
      await (_database.update(
        _database.transactions,
      )..where((t) => t.id.equals(change.entityId))).write(
        TransactionsCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    // Check if record exists
    final existing = await (_database.select(
      _database.transactions,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();

    final companion = TransactionsCompanion(
      id: Value(change.entityId),
      amount: Value((data['Amount'] as num?)?.toInt() ?? 0),
      title: Value(data['Title'] ?? ''),
      notes: Value(data['Notes']),
      date: Value(
        data['Date'] != null ? DateTime.parse(data['Date']) : DateTime.now(),
      ),
      isIncome: Value(data['IsIncome'] ?? false),
      transactionType: Value(_parseTransactionType(data['Type'])),
      // specialType is an enum column — convert the incoming int index back to
      // the enum (passing a raw int would fail Drift's enum write path).
      specialType: Value(_parseSpecialType(data['SpecialType'])),
      walletId: Value(data['WalletId'] ?? ''),
      categoryId: Value(data['CategoryId']),
      paymentMethodId: Value(data['PaymentMethodId']),
      isPaid: Value(data['IsPaid'] ?? true),
      paidAmount: Value((data['PaidAmount'] as num?)?.toInt() ?? 0),
      originalDueDate: Value(
        data['OriginalDueDate'] != null
            ? DateTime.parse(data['OriginalDueDate'])
            : null,
      ),
      skipPaid: Value(data['SkipPaid'] ?? false),
      pairedTransactionId: Value(data['PairedTransactionId']),
      feeForTransactionId: Value(data['FeeForTransactionId']),
      recurringConfigId: Value(data['RecurringConfigId']),
      occurrenceKey: Value(data['OccurrenceKey'] as String?),
      budgetId: Value(data['BudgetId']),
      objectiveId: Value(data['ObjectiveId']),
      receiptImageUrl: Value(data['ReceiptImageUrl']),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.transactions,
      )..where((t) => t.id.equals(change.entityId))).write(companion);
      return;
    }

    // Two offline devices can generate the same recurrence occurrence with
    // different local ids. They agree on the deterministic occurrence key, so
    // when the server's copy arrives we drop the local duplicate and adopt the
    // server row — converging on exactly one occurrence instead of hitting the
    // unique index or ending up with two identical transactions.
    final occurrenceKey = data['OccurrenceKey'] as String?;
    if (occurrenceKey != null && occurrenceKey.isNotEmpty) {
      final duplicate = await (_database.select(
        _database.transactions,
      )..where((t) => t.occurrenceKey.equals(occurrenceKey))).getSingleOrNull();
      if (duplicate != null && duplicate.id != change.entityId) {
        _logger.i(
          'Replacing locally generated occurrence ${duplicate.id} with '
          'server copy ${change.entityId} ($occurrenceKey)',
        );
        await (_database.delete(
          _database.transactions,
        )..where((t) => t.id.equals(duplicate.id))).go();
      }
    }

    await _database.into(_database.transactions).insert(companion);
  }

  Future<void> _applyWalletChange(SyncChange change) async {
    final rawData = change.data;
    if (change.operation == 'delete') {
      await (_database.update(
        _database.wallets,
      )..where((w) => w.id.equals(change.entityId))).write(
        WalletsCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      // A wallet deleted on another device leaves the same stale budget scoping
      // behind as one deleted here, so it is pruned the same way.
      await _database.pruneWalletFromBudgets(change.entityId);
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    final existing = await (_database.select(
      _database.wallets,
    )..where((w) => w.id.equals(change.entityId))).getSingleOrNull();

    final companion = WalletsCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['Icon'] ?? data['IconName'] ?? 'wallet'),
      color: Value(data['Color'] ?? '#6366F1'),
      currency: Value(data['Currency'] ?? 'USD'),
      balance: Value((data['Balance'] as num?)?.toInt() ?? 0),
      openingBalance: Value((data['OpeningBalance'] as num?)?.toInt() ?? 0),
      isDefault: Value(data['IsDefault'] ?? false),
      walletType: Value(_parseWalletType(data['WalletType'])),
      creditLimit: Value((data['CreditLimit'] as num?)?.toInt()),
      billingCycleDay: Value(data['BillingCycleDay'] as int?),
      orderIndex: Value((data['OrderIndex'] as num?)?.toInt() ?? 0),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.wallets,
      )..where((w) => w.id.equals(change.entityId))).write(companion);
    } else {
      await _database.into(_database.wallets).insert(companion);
    }
  }

  Future<void> _applyCategoryChange(SyncChange change) async {
    final rawData = change.data;
    if (change.operation == 'delete') {
      await (_database.update(
        _database.categories,
      )..where((c) => c.id.equals(change.entityId))).write(
        CategoriesCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      // A category deleted on another device leaves the same stale budget
      // scoping behind as one deleted here, so it is pruned the same way.
      await _database.pruneCategoryFromBudgets(change.entityId);
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    final existing = await (_database.select(
      _database.categories,
    )..where((c) => c.id.equals(change.entityId))).getSingleOrNull();

    final companion = CategoriesCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      // Push writes 'IconName'/'MainCategoryId'; read those first (fall back to the old keys).
      iconName: Value(data['IconName'] ?? data['Icon'] ?? 'category'),
      color: Value(data['Color'] ?? '#6366F1'),
      isIncome: Value(data['IsIncome'] ?? false),
      mainCategoryId: Value(data['MainCategoryId'] ?? data['ParentCategoryId']),
      orderIndex: Value(data['OrderIndex'] ?? 0),
      // Without these two a restore turned every built-in into an ordinary
      // category: the defaults lost their delete protection and their
      // cross-device identity.
      isDefault: Value(data['IsDefault'] ?? false),
      defaultKey: Value(data['DefaultKey'] as String?),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.categories,
      )..where((c) => c.id.equals(change.entityId))).write(companion);
      return;
    }

    // This device may already hold its own provisional copy of the same built-in
    // category — it seeds defaults locally before it has ever seen the account's
    // cloud data. The two share a `defaultKey`, which is proof they are the same
    // built-in, so the local copy is folded into the incoming canonical one:
    // its transactions are re-pointed and it is removed. Without this the unique
    // index on `default_key` rejects the canonical row and the whole pull fails.
    final defaultKey = data['DefaultKey'] as String?;
    if (defaultKey != null && defaultKey.isNotEmpty) {
      final localDuplicate = await _database.findCategoryByDefaultKey(
        defaultKey,
      );
      if (localDuplicate != null && localDuplicate.id != change.entityId) {
        _logger.i(
          'Folding local default category ${localDuplicate.id} into the '
          "account's copy ${change.entityId} ($defaultKey)",
        );
        await _database.absorbDuplicateDefaultCategory(
          loserId: localDuplicate.id,
          survivorId: change.entityId,
        );
      }
    }

    await _database.into(_database.categories).insert(companion);
  }

  Future<void> _applyBudgetChange(SyncChange change) async {
    final rawData = change.data;
    if (change.operation == 'delete') {
      await (_database.update(
        _database.budgets,
      )..where((b) => b.id.equals(change.entityId))).write(
        BudgetsCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    final existing = await (_database.select(
      _database.budgets,
    )..where((b) => b.id.equals(change.entityId))).getSingleOrNull();

    final companion = BudgetsCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      amount: Value((data['Amount'] as num?)?.toInt() ?? 0),
      period: Value(_parseBudgetPeriod(data['Period'])),
      startDate: Value(
        data['StartDate'] != null
            ? DateTime.parse(data['StartDate'])
            : DateTime.now(),
      ),
      endDate: Value(
        data['EndDate'] != null ? DateTime.parse(data['EndDate']) : null,
      ),
      walletIds: Value(data['WalletIds']),
      categoryIds: Value(data['CategoryIds']),
      isIncome: Value(data['IsIncome'] ?? false),
      isPinned: Value(data['IsPinned'] ?? false),
      isArchived: Value(data['IsArchived'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.budgets,
      )..where((b) => b.id.equals(change.entityId))).write(companion);
    } else {
      await _database.into(_database.budgets).insert(companion);
    }
  }

  Future<void> _applyObjectiveChange(SyncChange change) async {
    final rawData = change.data;
    if (change.operation == 'delete') {
      await (_database.update(
        _database.objectives,
      )..where((o) => o.id.equals(change.entityId))).write(
        ObjectivesCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    final existing = await (_database.select(
      _database.objectives,
    )..where((o) => o.id.equals(change.entityId))).getSingleOrNull();

    final companion = ObjectivesCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['IconName'] ?? data['Icon'] ?? 'flag'),
      color: Value(data['Color'] ?? '#6366F1'),
      targetAmount: Value((data['TargetAmount'] as num?)?.toInt() ?? 0),
      type: Value(_parseObjectiveType(data['Type'])),
      walletId: Value(data['WalletId']),
      startDate: Value(
        data['StartDate'] != null
            ? DateTime.parse(data['StartDate'])
            : DateTime.now(),
      ),
      endDate: Value(
        data['EndDate'] != null ? DateTime.parse(data['EndDate']) : null,
      ),
      isPinned: Value(data['IsPinned'] ?? false),
      isArchived: Value(data['IsArchived'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.objectives,
      )..where((o) => o.id.equals(change.entityId))).write(companion);
    } else {
      await _database.into(_database.objectives).insert(companion);
    }
  }

  Future<void> _applyPaymentMethodChange(SyncChange change) async {
    final rawData = change.data;
    if (change.operation == 'delete') {
      await (_database.update(
        _database.paymentMethods,
      )..where((p) => p.id.equals(change.entityId))).write(
        PaymentMethodsCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    final existing = await (_database.select(
      _database.paymentMethods,
    )..where((p) => p.id.equals(change.entityId))).getSingleOrNull();

    final companion = PaymentMethodsCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['IconName'] ?? data['Icon'] ?? 'credit_card'),
      isDefault: Value(data['IsDefault'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.paymentMethods,
      )..where((p) => p.id.equals(change.entityId))).write(companion);
    } else {
      await _database.into(_database.paymentMethods).insert(companion);
    }
  }

  Future<void> _applyRecurringConfigChange(SyncChange change) async {
    final rawData = change.data;
    // RecurringConfig has no deletedAt - uses isActive flag
    if (change.operation == 'delete') {
      await (_database.update(
        _database.recurringConfigs,
      )..where((r) => r.id.equals(change.entityId))).write(
        RecurringConfigsCompanion(
          isActive: const Value(false),
          syncStatus: const Value(SyncStatus.synced),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return;
    }

    if (rawData == null) return;
    final data = _normalizeKeys(rawData);

    final existing = await (_database.select(
      _database.recurringConfigs,
    )..where((r) => r.id.equals(change.entityId))).getSingleOrNull();

    final companion = RecurringConfigsCompanion(
      id: Value(change.entityId),
      baseTransactionId: Value(data['BaseTransactionId'] ?? ''),
      periodLength: Value(data['PeriodLength'] ?? 1),
      reoccurrence: Value(_parseReoccurrence(data['Reoccurrence'])),
      startDate: Value(
        data['StartDate'] != null
            ? DateTime.parse(data['StartDate'])
            : DateTime.now(),
      ),
      endDate: Value(
        data['EndDate'] != null ? DateTime.parse(data['EndDate']) : null,
      ),
      nextOccurrence: Value(
        data['NextOccurrence'] != null
            ? DateTime.parse(data['NextOccurrence'])
            : DateTime.now(),
      ),
      isActive: Value(data['IsActive'] ?? true),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(
        _database.recurringConfigs,
      )..where((r) => r.id.equals(change.entityId))).write(companion);
    } else {
      await _database.into(_database.recurringConfigs).insert(companion);
    }
  }

  // ==================== CONVERSION HELPERS ====================

  /// Normalize data map keys from snake_case to PascalCase.
  /// The backend serializes with JsonNamingPolicy.SnakeCaseLower,
  /// so pull data arrives as snake_case. This converts to PascalCase
  /// to match what the apply methods expect.
  Map<String, dynamic> _normalizeKeys(Map<String, dynamic> data) {
    return data.map((key, value) {
      final pascalKey = key
          .split('_')
          .map(
            (part) => part.isEmpty
                ? ''
                : '${part[0].toUpperCase()}${part.substring(1)}',
          )
          .join();
      return MapEntry(pascalKey, value);
    });
  }

  String _getOperationFromStatus(int status) {
    switch (status) {
      case SyncStatus.pendingCreate:
        return 'create';
      case SyncStatus.pendingUpdate:
        return 'update';
      case SyncStatus.pendingDelete:
        return 'delete';
      default:
        return 'update';
    }
  }

  TransactionSpecialType _parseSpecialType(dynamic value) {
    final index = (value as num?)?.toInt() ?? 0;
    if (index >= 0 && index < TransactionSpecialType.values.length) {
      return TransactionSpecialType.values[index];
    }
    return TransactionSpecialType.none;
  }

  /// Wire value -> the exact string stored in the `transaction_type` column.
  ///
  /// Both directions go through [TransactionType] so the column, the API, and
  /// [TransactionPolicy] cannot disagree. They previously did: a generated
  /// occurrence was stored as `recurring_instance`, serialized by a lookup that
  /// only matched `recurringinstance` (so it left as *Regular*), and parsed back
  /// as `recurringInstance` — a third spelling matching neither.
  String _parseTransactionType(dynamic type) =>
      TransactionType.fromWire(type).storageValue;

  String _parseBudgetPeriod(dynamic period) {
    if (period is int) {
      switch (period) {
        case 0:
          return 'daily';
        case 1:
          return 'weekly';
        case 2:
          return 'biweekly';
        case 3:
          return 'monthly';
        case 4:
          return 'yearly';
        case 5:
          return 'custom';
        default:
          return 'monthly';
      }
    }
    return period?.toString() ?? 'monthly';
  }

  String _parseObjectiveType(dynamic type) {
    if (type is int) {
      switch (type) {
        case 0:
          return 'goal';
        case 1:
          return 'loan';
        default:
          return 'goal';
      }
    }
    return type?.toString() ?? 'goal';
  }

  String _parseReoccurrence(dynamic reoccurrence) {
    if (reoccurrence is int) {
      switch (reoccurrence) {
        case 0:
          return 'daily';
        case 1:
          return 'weekly';
        case 2:
          return 'monthly';
        case 3:
          return 'yearly';
        default:
          return 'monthly';
      }
    }
    return reoccurrence?.toString() ?? 'monthly';
  }

  /// Safely coerce a server-supplied wallet type (int / numeric string) into a valid
  /// [WalletType], clamping out-of-range values instead of throwing a RangeError.
  WalletType _parseWalletType(dynamic value) {
    int index;
    if (value is int) {
      index = value;
    } else {
      index = int.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (index < 0 || index >= WalletType.values.length) index = 0;
    return WalletType.values[index];
  }

  int _reoccurrenceToInt(String reoccurrence) {
    switch (reoccurrence.toLowerCase()) {
      case 'daily':
        return 0;
      case 'weekly':
        return 1;
      case 'monthly':
        return 2;
      case 'yearly':
        return 3;
      default:
        return 2;
    }
  }

  // ==================== MAP CONVERSIONS FOR PUSH ====================

  Map<String, dynamic> _transactionToMap(Transaction t) => {
    'WalletId': t.walletId,
    'CategoryId': t.categoryId,
    'PaymentMethodId': t.paymentMethodId,
    'Amount': t.amount,
    'Title': t.title,
    'Notes': t.notes,
    'Date': t.date.toUtc().toIso8601String(),
    'IsIncome': t.isIncome,
    'Type': _transactionTypeToInt(t.transactionType),
    // specialType is a Dart enum (EnumIndexConverter) — send its int index so the
    // JSON body can actually be encoded. Sending the raw enum breaks jsonEncode.
    'SpecialType': t.specialType?.index ?? 0,
    'IsPaid': t.isPaid,
    'OriginalDueDate': t.originalDueDate?.toUtc().toIso8601String(),
    'SkipPaid': t.skipPaid,
    'PaidAmount': t.paidAmount,
    'PairedTransactionId': t.pairedTransactionId,
    'FeeForTransactionId': t.feeForTransactionId,
    'RecurringConfigId': t.recurringConfigId,
    // Deterministic key for a generated recurrence occurrence. The server has a
    // matching uniqueness constraint, so two offline devices that generated the
    // same occurrence converge on one row instead of uploading duplicates.
    'OccurrenceKey': t.occurrenceKey,
    'BudgetId': t.budgetId,
    'ObjectiveId': t.objectiveId,
    'ReceiptImageUrl': t.receiptImageUrl,
    'UpdatedAt': t.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _walletToMap(Wallet w) => {
    'Name': w.name,
    'Balance': w.balance,
    'OpeningBalance': w.openingBalance,
    'Currency': w.currency,
    'Color': w.color,
    'IconName': w.iconName,
    'IsDefault': w.isDefault,
    'WalletType': w.walletType.index,
    'CreditLimit': w.creditLimit,
    'BillingCycleDay': w.billingCycleDay,
    'OrderIndex': w.orderIndex,
    'UpdatedAt': w.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _categoryToMap(Category c) => {
    'Name': c.name,
    'Color': c.color,
    'IconName': c.iconName,
    'IsIncome': c.isIncome,
    'MainCategoryId': c.mainCategoryId,
    'OrderIndex': c.orderIndex,
    // Round-tripped so a restored device still protects its built-ins from
    // deletion, and so the server can enforce one built-in per slug per user.
    'IsDefault': c.isDefault,
    'DefaultKey': c.defaultKey,
    'UpdatedAt': c.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _budgetToMap(Budget b) => {
    'Name': b.name,
    'Amount': b.amount,
    'StartDate': b.startDate.toUtc().toIso8601String(),
    'EndDate': b.endDate?.toUtc().toIso8601String(),
    'Period': _budgetPeriodToInt(b.period),
    'WalletIds': b.walletIds,
    'CategoryIds': b.categoryIds,
    'IsIncome': b.isIncome,
    'IsPinned': b.isPinned,
    'IsArchived': b.isArchived,
    'UpdatedAt': b.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _objectiveToMap(Objective o) => {
    'Name': o.name,
    'TargetAmount': o.targetAmount,
    'WalletId': o.walletId,
    'IconName': o.iconName,
    'Color': o.color,
    'Type': _objectiveTypeToInt(o.type),
    'StartDate': o.startDate.toUtc().toIso8601String(),
    'EndDate': o.endDate?.toUtc().toIso8601String(),
    'IsPinned': o.isPinned,
    'IsArchived': o.isArchived,
    'UpdatedAt': o.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _paymentMethodToMap(PaymentMethod p) => {
    'Name': p.name,
    'IconName': p.iconName,
    'IsDefault': p.isDefault,
    'UpdatedAt': p.updatedAt.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _recurringConfigToMap(RecurringConfig r) => {
    'BaseTransactionId': r.baseTransactionId,
    'PeriodLength': r.periodLength,
    'Reoccurrence': _reoccurrenceToInt(r.reoccurrence),
    'StartDate': r.startDate.toUtc().toIso8601String(),
    'EndDate': r.endDate?.toUtc().toIso8601String(),
    'NextOccurrence': r.nextOccurrence.toUtc().toIso8601String(),
    'IsActive': r.isActive,
    'UpdatedAt': r.updatedAt.toUtc().toIso8601String(),
  };

  int _transactionTypeToInt(String type) =>
      TransactionType.fromStorage(type).wireValue;

  int _budgetPeriodToInt(String period) {
    switch (period.toLowerCase()) {
      case 'daily':
        return 0;
      case 'weekly':
        return 1;
      case 'biweekly':
        return 2;
      case 'monthly':
        return 3;
      case 'yearly':
        return 4;
      case 'custom':
        return 5;
      default:
        return 3;
    }
  }

  int _objectiveTypeToInt(String type) {
    switch (type.toLowerCase()) {
      case 'loan':
        return 1;
      default:
        return 0;
    }
  }

  /// Mark exactly the accepted pushed records as synced. For accepted deletes the local
  /// (already soft-deleted) row is hard-deleted so tombstones don't accumulate forever.
  /// Records NOT in [applied] (i.e. server conflicts) are intentionally left pending.
  Future<void> _markChangesSynced(List<SyncChange> applied) async {
    for (final c in applied) {
      if (c.operation == 'delete') {
        await _hardDeleteLocal(c.tableName, c.entityId);
      } else {
        // Compare-and-set: only clear the pending flag if the row hasn't been
        // edited since it was collected for push. If the user edited it while the
        // push was in flight, `updatedAt` changed, the guard misses, and the row
        // stays pending to be re-pushed next sync — so the in-flight edit isn't
        // silently lost. When no source timestamp is available we fall back to an
        // unconditional clear (prior behaviour) to avoid ever getting stuck.
        await _setRecordSynced(
          c.tableName,
          c.entityId,
          expected: c.sourceUpdatedAt,
        );
      }
    }
  }

  Future<void> _setRecordSynced(
    String table,
    String id, {
    DateTime? expected,
  }) async {
    switch (table) {
      case 'transactions':
        await (_database.update(_database.transactions)..where(
              (t) => expected == null
                  ? t.id.equals(id)
                  : t.id.equals(id) & t.updatedAt.equals(expected),
            ))
            .write(
              const TransactionsCompanion(syncStatus: Value(SyncStatus.synced)),
            );
        break;
      case 'wallets':
        await (_database.update(_database.wallets)..where(
              (w) => expected == null
                  ? w.id.equals(id)
                  : w.id.equals(id) & w.updatedAt.equals(expected),
            ))
            .write(
              const WalletsCompanion(syncStatus: Value(SyncStatus.synced)),
            );
        break;
      case 'categories':
        await (_database.update(_database.categories)..where(
              (c) => expected == null
                  ? c.id.equals(id)
                  : c.id.equals(id) & c.updatedAt.equals(expected),
            ))
            .write(
              const CategoriesCompanion(syncStatus: Value(SyncStatus.synced)),
            );
        break;
      case 'budgets':
        await (_database.update(_database.budgets)..where(
              (b) => expected == null
                  ? b.id.equals(id)
                  : b.id.equals(id) & b.updatedAt.equals(expected),
            ))
            .write(
              const BudgetsCompanion(syncStatus: Value(SyncStatus.synced)),
            );
        break;
      case 'objectives':
        await (_database.update(_database.objectives)..where(
              (o) => expected == null
                  ? o.id.equals(id)
                  : o.id.equals(id) & o.updatedAt.equals(expected),
            ))
            .write(
              const ObjectivesCompanion(syncStatus: Value(SyncStatus.synced)),
            );
        break;
      case 'payment_methods':
        await (_database.update(_database.paymentMethods)..where(
              (p) => expected == null
                  ? p.id.equals(id)
                  : p.id.equals(id) & p.updatedAt.equals(expected),
            ))
            .write(
              const PaymentMethodsCompanion(
                syncStatus: Value(SyncStatus.synced),
              ),
            );
        break;
      case 'recurring_configs':
        await (_database.update(_database.recurringConfigs)..where(
              (r) => expected == null
                  ? r.id.equals(id)
                  : r.id.equals(id) & r.updatedAt.equals(expected),
            ))
            .write(
              const RecurringConfigsCompanion(
                syncStatus: Value(SyncStatus.synced),
              ),
            );
        break;
    }
  }

  Future<void> _hardDeleteLocal(String table, String id) async {
    // Only remove the local tombstone if the row is still pending-delete. If the
    // user resurrected/edited it while the delete push was in flight, its status
    // changed and we leave it alone to re-sync (so the resurrect isn't lost).
    const pendingDelete = SyncStatus.pendingDelete;
    switch (table) {
      case 'transactions':
        await (_database.delete(_database.transactions)..where(
              (t) => t.id.equals(id) & t.syncStatus.equals(pendingDelete),
            ))
            .go();
        break;
      case 'wallets':
        await (_database.delete(_database.wallets)..where(
              (w) => w.id.equals(id) & w.syncStatus.equals(pendingDelete),
            ))
            .go();
        break;
      case 'categories':
        await (_database.delete(_database.categories)..where(
              (c) => c.id.equals(id) & c.syncStatus.equals(pendingDelete),
            ))
            .go();
        break;
      case 'budgets':
        await (_database.delete(_database.budgets)..where(
              (b) => b.id.equals(id) & b.syncStatus.equals(pendingDelete),
            ))
            .go();
        break;
      case 'objectives':
        await (_database.delete(_database.objectives)..where(
              (o) => o.id.equals(id) & o.syncStatus.equals(pendingDelete),
            ))
            .go();
        break;
      case 'payment_methods':
        await (_database.delete(_database.paymentMethods)..where(
              (p) => p.id.equals(id) & p.syncStatus.equals(pendingDelete),
            ))
            .go();
        break;
      case 'recurring_configs':
        // Recurring configs have no soft-delete column; the server keeps the row inactive,
        // so we just clear the pending flag rather than removing it locally.
        await _setRecordSynced(table, id);
        break;
    }
  }

  /// Update sync state
  void _setState(SyncOperationState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  /// Get sync status from server
  Future<SyncStatusResponse?> getServerSyncStatus() async {
    if (!await isOnline()) return null;

    try {
      final response = await ApiService().get('/sync/status');
      return SyncStatusResponse.fromJson(response.data);
    } catch (e) {
      _logger.e('Failed to get sync status: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _stateController.close();
  }
}
