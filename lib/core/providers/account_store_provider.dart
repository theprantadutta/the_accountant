import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_accountant/core/services/background_task_service.dart';
import 'package:the_accountant/core/services/category_initialization_service.dart';
import 'package:the_accountant/core/services/local_id_repair_service.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/local_store_manager.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';

/// Manager for the per-account database files. Overridden in `main()` with an
/// instance built from the already-loaded [SharedPreferences].
final localStoreManagerProvider = Provider<LocalStoreManager>((ref) {
  throw UnimplementedError(
    'localStoreManagerProvider must be overridden in main()',
  );
});

/// Which store file is currently open.
///
/// [databaseProvider] is overridden in `main()` to watch this, so changing it
/// swaps the database *and* rebuilds every provider downstream — which is what
/// guarantees no screen keeps serving the previous account's rows.
final activeStoreFileProvider = StateProvider<String>((ref) {
  return ref.watch(localStoreManagerProvider).activeStoreFile;
});

/// Backend user id the open store belongs to (null while signed out).
final activeStoreOwnerProvider = StateProvider<String?>((ref) {
  return ref.watch(localStoreManagerProvider).activeOwnerUserId;
});

/// Keeps the open local store in step with the authenticated identity.
///
/// Watched once, high in the widget tree. On every identity transition it
/// resolves the correct store file, points [activeStoreFileProvider] at it, and
/// closes the previous one. The transitions it has to get right are:
///
/// * **first login** — the still-unowned legacy store is claimed by that
///   account, so nothing the user recorded before signing up is lost;
/// * **logout** — the session drops to an anonymous store, so the signed-out
///   device no longer displays the owner's finances;
/// * **login as the same user** — their existing store is reopened untouched;
/// * **login as a different user** — that account gets its own file; the first
///   account's rows are neither visible nor pushable;
/// * **expired session / restore** — treated as logout followed by login.
class AccountStoreCoordinator extends Notifier<AccountStoreState> {
  /// Store files this session has already prepared, so a rebuild or a
  /// switch back to a previous account does not redo the work.
  final Set<String> _preparedFiles = <String>{};

  /// Files currently being prepared, so two triggers cannot race into doing it
  /// twice.
  final Set<String> _preparing = <String>{};

  /// Test seam: what this session has finished preparing.
  Set<String> get preparedFiles => Set.unmodifiable(_preparedFiles);

  @override
  AccountStoreState build() {
    final manager = ref.watch(localStoreManagerProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      // Nothing account-scoped may be decided while authentication is still in
      // flight. Preparation used to start from `MyApp.initState()`, which runs
      // before any of this is known — so a persisted store could be seeded and
      // have recurrences generated into it before the session that owns it was
      // confirmed, or rejected.
      if (next.isLoading) return;

      final previousUser = previous?.isAuthenticated == true
          ? previous?.userId
          : null;
      final nextUser = next.isAuthenticated ? next.userId : null;
      final justResolved = previous == null || previous.isLoading;
      if (!justResolved && previousUser == nextUser) return;

      // Fire-and-forget: the UI reacts to activeStoreFileProvider changing.
      unawaited(_switchTo(manager, nextUser, next.userEmail));
    });

    return AccountStoreState(
      storeFile: manager.activeStoreFile,
      ownerUserId: manager.activeOwnerUserId,
    );
  }

  Future<void> _switchTo(
    LocalStoreManager manager,
    String? userId,
    String? email,
  ) async {
    try {
      final targetFile = userId == null
          ? await manager.resolveAnonymousStoreFile()
          : await manager.resolveStoreFileForUser(userId, email: email);

      await manager.setActiveStore(targetFile, ownerUserId: userId);

      if (targetFile != ref.read(activeStoreFileProvider)) {
        ref.read(activeStoreFileProvider.notifier).state = targetFile;
        await _prepareStore(manager.databaseForFile(targetFile), targetFile, userId);
        await manager.closeAllExcept(targetFile);
      } else {
        await _prepareStore(manager.databaseForFile(targetFile), targetFile, userId);
      }
      ref.read(activeStoreOwnerProvider.notifier).state = userId;

      state = AccountStoreState(storeFile: targetFile, ownerUserId: userId);
    } catch (e) {
      debugPrint('[AccountStoreCoordinator] store switch failed: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Prepare whichever store is currently active.
  ///
  /// Driven by authentication resolving, never by app start: the identity that
  /// owns the store has to be known before anything writes to it.
  Future<void> prepareActiveStore() async {
    final manager = ref.read(localStoreManagerProvider);
    final file = ref.read(activeStoreFileProvider);
    await _prepareStore(
      manager.databaseForFile(file),
      file,
      ref.read(activeStoreOwnerProvider),
    );
  }

  /// Seed and catch up a store, once per file per session, and only when the
  /// store demonstrably belongs to the session doing the preparing.
  ///
  /// Recurrence generation is deliberately part of this rather than of app
  /// startup: it writes rows, and writing them into a store before its owner is
  /// known is how background work ends up in the wrong account's database.
  ///
  /// The ownership check is the guard that makes that impossible. A store
  /// claimed by some *other* account is left completely untouched — not seeded,
  /// not caught up, not repaired — because the only thing worse than skipping
  /// this work is doing it to somebody else's records.
  Future<void> _prepareStore(
    AppDatabase database,
    String file,
    String? userId,
  ) async {
    if (_preparedFiles.contains(file) || !_preparing.add(file)) return;
    try {
      await _prepareStoreInner(database, file, userId);
      // Cleared only on a run that got all the way through.
      if (state.error != null) state = state.copyWith(error: null);
    } catch (e, stack) {
      // Deliberately NOT marked prepared. Every step here writes something the
      // account needs — its system categories, a wallet id repair, its overdue
      // recurrences — and a half-done store that the session refuses to touch
      // again is worse than one that has not been touched at all.
      debugPrint('[AccountStoreCoordinator] preparation failed for $file: $e');
      debugPrintStack(stackTrace: stack);
      // The state message carries the failure type only. The exception text can
      // quote SQL, and SQL here quotes the user's own financial records.
      state = state.copyWith(
        error: 'Could not prepare local data (${e.runtimeType}).',
      );
    } finally {
      _preparing.remove(file);
    }
  }

  Future<void> _prepareStoreInner(
    AppDatabase database,
    String file,
    String? userId,
  ) async {
    final owner = await database.getLocalStoreOwnerUserId();
    if (owner != null && owner != userId) {
      debugPrint(
        '[AccountStoreCoordinator] refusing to prepare $file: owned by '
        'another account',
      );
      return;
    }

    // Each step below is allowed to throw, and the throw is the point: the
    // caller records the failure and leaves the file unprepared so the next
    // attempt in this session runs the whole sequence again.
    await _bootstrapStore(database, userId);

    // Finish any wallet re-key the schema-15 migration started. The migration
    // fixed the database; `default_wallet_id` lives in SharedPreferences, which
    // it cannot reach, so the mapping is applied here instead.
    //
    // Ordered before recurrence generation on purpose. Generating rows against
    // a wallet id that is still mid-repair would file them under an id that is
    // about to stop existing.
    await LocalIdRepairService(
      database,
      ref.read(sharedPreferencesProvider),
    ).applyPendingRepairs();

    await BackgroundTaskService.runStartupProcessing(database);

    // Marked prepared only once every step above has actually succeeded.
    _preparedFiles.add(file);
  }

  /// Prepare a store the app has just switched to.
  ///
  /// Seeding the user-facing defaults is **deferred for a signed-in account**
  /// until the first sync has had a chance to bring down whatever categories
  /// that account already has in the cloud. A second device used to seed a
  /// complete set of defaults with fresh random ids, push them, and only then
  /// pull the originals — leaving the account with two of everything, and
  /// another set for every further device.
  ///
  /// The system categories are still created immediately: they are internal
  /// bookkeeping that a transfer needs the moment the user makes one, they are
  /// keyed by slug like the rest, and a duplicate is merged after the pull.
  ///
  /// A signed-out (offline-only) store seeds right away — local-first has to
  /// work with no account at all.
  /// Throws if the store cannot be brought up to a usable state.
  ///
  /// It used to swallow, which read as resilience and behaved as the opposite:
  /// the caller could not tell a seeded store from a failed one, marked it
  /// prepared either way, and never came back. An account could then run the
  /// whole session with no system categories — so the first transfer the user
  /// made had nowhere to put its category.
  Future<void> _bootstrapStore(AppDatabase database, String? userId) async {
    await database.ensureSystemCategoriesExist();
    if (userId == null) {
      await CategoryInitializationService(
        database,
      ).initializeDefaultCategories();
    }
    // For a signed-in account the defaults are filled in by SyncService after
    // the first successful pull (per-slug, so only genuine gaps are created).
  }

  /// Fallback for an account that cannot reach the cloud.
  ///
  /// Free-tier users never sync, and a premium user may be offline
  /// indefinitely; neither can be left with no categories. Call this once a sync
  /// attempt has been made and did not succeed. Seeding is per-slug and the
  /// server deduplicates by slug, so a premature seed is recoverable rather than
  /// permanent duplication.
  Future<void> seedDefaultsWithoutCloud() async {
    final manager = ref.read(localStoreManagerProvider);
    final database = manager.databaseForFile(ref.read(activeStoreFileProvider));
    await CategoryInitializationService(database).initializeDefaultCategories();
  }

  /// Explicit, user-confirmed handover: wipe the currently open store and
  /// detach it from its owner so another account can adopt this device.
  ///
  /// Destructive by design and never invoked automatically — losing an
  /// account's unsynced records must always be the user's decision.
  Future<void> releaseCurrentStoreForHandover() async {
    final manager = ref.read(localStoreManagerProvider);
    final database = manager.databaseForFile(ref.read(activeStoreFileProvider));
    await database.releaseLocalStore();
    await CategoryInitializationService(database).initializeDefaultCategories();
    await database.ensureSystemCategoriesExist();
    ref.read(activeStoreOwnerProvider.notifier).state = null;
    state = state.copyWith(ownerUserId: null);
  }
}

class AccountStoreState {
  final String storeFile;
  final String? ownerUserId;
  final String? error;

  const AccountStoreState({
    required this.storeFile,
    this.ownerUserId,
    this.error,
  });

  AccountStoreState copyWith({
    String? storeFile,
    String? ownerUserId,
    String? error,
  }) => AccountStoreState(
    storeFile: storeFile ?? this.storeFile,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    error: error,
  );
}

final accountStoreCoordinatorProvider =
    NotifierProvider<AccountStoreCoordinator, AccountStoreState>(
      AccountStoreCoordinator.new,
    );

/// `unawaited` without pulling in dart:async at every call site.
void unawaited(Future<void> future) {
  future.catchError((Object e) {
    debugPrint('[AccountStoreCoordinator] $e');
  });
}
