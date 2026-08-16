import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// Decides *which* SQLite file the app is allowed to open, and for whom.
///
/// The local database used to be a single anonymous `db.sqlite`. Signing out
/// cleared only the auth tokens, so the next account on the same device saw the
/// previous account's wallets, transactions, and — worse — could push that
/// account's still-pending rows under its own credentials. Scoping the store to
/// a backend user id fixes both halves of that: a different account gets a
/// different file, and every sync verifies the open file's recorded owner
/// against the authenticated user before sending anything.
///
/// File layout:
///
/// | Session                                   | File                      |
/// |-------------------------------------------|---------------------------|
/// | Never signed in (legacy / offline-only)    | `db.sqlite`               |
/// | First account to sign in on a legacy store | `db.sqlite` (claimed)     |
/// | Any other account                          | `db_<userId>.sqlite`      |
/// | Signed out, when `db.sqlite` is claimed    | `db_anonymous.sqlite`     |
///
/// Claiming the legacy file rather than abandoning it is what preserves the
/// work of a user who used the app offline before ever creating an account.
class LocalStoreManager {
  LocalStoreManager(this._prefs);

  final SharedPreferences _prefs;

  /// prefs key -> file name that account's store lives in.
  static const String _storeFileKeyPrefix = 'local_store_file_';

  /// Which store the app should open on next launch (also read by the
  /// WorkManager background isolate, which cannot see Riverpod state).
  static const String _activeStoreFileKey = 'local_store_active_file';

  /// User id whose session is currently active, or null when signed out.
  static const String _activeOwnerKey = 'local_store_active_owner';

  /// The original, pre-multi-account database file.
  static const String legacyStoreFile = 'db.sqlite';

  /// Store used while nobody is signed in and the legacy file already belongs
  /// to somebody.
  static const String anonymousStoreFile = 'db_anonymous.sqlite';

  final Map<String, AppDatabase> _open = {};

  /// File name the app should currently be using, as recorded on disk.
  String get activeStoreFile =>
      _prefs.getString(_activeStoreFileKey) ?? legacyStoreFile;

  /// Backend user id of the currently active session, or null when signed out.
  String? get activeOwnerUserId => _prefs.getString(_activeOwnerKey);

  /// Open (or reuse) the database behind [fileName].
  AppDatabase databaseForFile(String fileName) =>
      _open.putIfAbsent(fileName, () => constructDbForFile(fileName));

  /// The database for the currently active store.
  AppDatabase get activeDatabase => databaseForFile(activeStoreFile);

  /// Resolve which file account [userId] should use, claiming the legacy store
  /// when it is still unowned.
  ///
  /// Returns the file name. The caller is responsible for actually switching to
  /// it, so this stays a pure decision + bookkeeping step.
  Future<String> resolveStoreFileForUser(String userId, {String? email}) async {
    final remembered = _prefs.getString('$_storeFileKeyPrefix$userId');
    if (remembered != null) return remembered;

    // Is the legacy store still unclaimed? If so this account adopts it, which
    // keeps everything the user recorded before signing up.
    final legacyDb = databaseForFile(legacyStoreFile);
    final legacyOwner = await legacyDb.getLocalStoreOwnerUserId();
    if (legacyOwner == null) {
      await legacyDb.claimLocalStore(userId: userId, email: email);
      await _prefs.setString('$_storeFileKeyPrefix$userId', legacyStoreFile);
      return legacyStoreFile;
    }
    if (legacyOwner == userId) {
      await _prefs.setString('$_storeFileKeyPrefix$userId', legacyStoreFile);
      return legacyStoreFile;
    }

    // Somebody else owns the legacy store: this account gets its own file.
    final fileName = 'db_${_sanitize(userId)}.sqlite';
    final db = databaseForFile(fileName);
    final owner = await db.getLocalStoreOwnerUserId();
    if (owner == null) {
      await db.claimLocalStore(userId: userId, email: email);
    } else if (owner != userId) {
      // Should be impossible (the name is derived from the id), but never open
      // a store that claims a different owner.
      throw StateError(
        'Local store $fileName is owned by $owner, not $userId. '
        'Refusing to open it.',
      );
    }
    await _prefs.setString('$_storeFileKeyPrefix$userId', fileName);
    return fileName;
  }

  /// The file a signed-out session should use.
  ///
  /// Once the legacy store belongs to an account, a signed-out session must NOT
  /// fall back to it — that is exactly the leak this class exists to close.
  Future<String> resolveAnonymousStoreFile() async {
    final legacyOwner = await databaseForFile(
      legacyStoreFile,
    ).getLocalStoreOwnerUserId();
    return legacyOwner == null ? legacyStoreFile : anonymousStoreFile;
  }

  /// Record which store is active so the next launch and the background isolate
  /// agree with the running app.
  Future<void> setActiveStore(String fileName, {String? ownerUserId}) async {
    await _prefs.setString(_activeStoreFileKey, fileName);
    if (ownerUserId == null) {
      await _prefs.remove(_activeOwnerKey);
    } else {
      await _prefs.setString(_activeOwnerKey, ownerUserId);
    }
  }

  /// Close and forget every database except [keepFile].
  ///
  /// Called after a switch so the previous account's file is not left open with
  /// live connections that could still be written to.
  Future<void> closeAllExcept(String keepFile) async {
    final toClose = _open.keys.where((k) => k != keepFile).toList();
    for (final key in toClose) {
      final db = _open.remove(key);
      await db?.close();
    }
  }

  /// Delete the on-disk file for [userId]'s store. Used by an explicit
  /// "remove this account's local data" action; never called implicitly.
  Future<void> deleteStoreForUser(String userId) async {
    final fileName = _prefs.getString('$_storeFileKeyPrefix$userId');
    if (fileName == null) return;
    final db = _open.remove(fileName);
    await db?.close();
    final file = File(await resolveStorePath(fileName));
    if (file.existsSync()) await file.delete();
    await _prefs.remove('$_storeFileKeyPrefix$userId');
  }

  static String _sanitize(String userId) =>
      userId.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
}
