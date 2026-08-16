import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_accountant/core/services/category_initialization_service.dart';
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
  @override
  AccountStoreState build() {
    final manager = ref.watch(localStoreManagerProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      final previousUser = previous?.isAuthenticated == true
          ? previous?.userId
          : null;
      final nextUser = next.isAuthenticated ? next.userId : null;
      if (previousUser == nextUser) return;
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
        await _bootstrapStore(manager.databaseForFile(targetFile), userId);
        await manager.closeAllExcept(targetFile);
      }
      ref.read(activeStoreOwnerProvider.notifier).state = userId;

      state = AccountStoreState(storeFile: targetFile, ownerUserId: userId);
    } catch (e) {
      debugPrint('[AccountStoreCoordinator] store switch failed: $e');
      state = state.copyWith(error: e.toString());
    }
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
  Future<void> _bootstrapStore(AppDatabase database, String? userId) async {
    try {
      await database.ensureSystemCategoriesExist();
      if (userId == null) {
        await CategoryInitializationService(
          database,
        ).initializeDefaultCategories();
      }
      // For a signed-in account the defaults are filled in by SyncService after
      // the first successful pull (per-slug, so only genuine gaps are created).
    } catch (e) {
      debugPrint('[AccountStoreCoordinator] bootstrap failed: $e');
    }
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
