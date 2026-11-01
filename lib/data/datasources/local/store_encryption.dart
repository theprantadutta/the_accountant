import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';

/// At-rest encryption for the local stores.
///
/// The native library is SQLite3MultipleCiphers, selected by the `hooks:` block
/// in pubspec.yaml, which understands `PRAGMA key` and `PRAGMA rekey`. Every
/// store file on the device is encrypted with one random 256-bit key kept in the
/// platform keystore — never derived from anything the user types, so the
/// WorkManager task and the notification actions can open the store with nobody
/// there to unlock it.
///
/// What this protects: the file copied off the phone, out of a device backup, or
/// read by another app on a rooted device. What it does not: someone holding the
/// unlocked phone — that is the app lock's job.
///
/// Stores written before this existed are plaintext. The app converts them on
/// first launch without risking a row: copy, encrypt the copy, verify it, and
/// only then swap, keeping the original as `.plaintext.bak` until a later launch
/// opens the encrypted file cleanly.

/// Versioned so the slot can be rotated later without colliding.
const String _storeKeySlot = 'store_at_rest_key_v1';

const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(),
  // Not `..._this_device`: an encrypted iCloud backup restores the key along
  // with the file it opens, so a restored phone can still read its store.
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  wOptions: WindowsOptions(),
);

/// The device's store key, created on first use.
///
/// A key is generated only when the keystore cleanly reports there is none. A
/// read that *fails* is rethrown rather than treated as "no key": minting a new
/// key over a keystore hiccup would orphan every store encrypted with the old
/// one.
Future<String> readOrCreateStoreKey() async {
  final existing = await _secureStorage.read(key: _storeKeySlot);
  if (existing != null && existing.isNotEmpty) return existing;

  final rng = Random.secure();
  final hex = List<int>.generate(
    32,
    (_) => rng.nextInt(256),
  ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  await _secureStorage.write(key: _storeKeySlot, value: hex);
  return hex;
}

/// `PRAGMA key` for [keyHex]; must be the first statement on a connection.
///
/// Passed as a quoted passphrase so SQLite3MultipleCiphers applies its own key
/// derivation, and always the same string so every isolate derives the same key.
void applyStoreKey(CommonDatabase db, String keyHex) {
  ensureEncryptingSqlite();
  db.execute("PRAGMA key = '$keyHex';");
}

bool _encryptingSqliteVerified = false;

/// Refuse to run on plain SQLite; checked once per isolate.
///
/// Asked of an in-memory database rather than the store: once a key is set on a
/// file it does not open, every statement on it fails, including this one.
void ensureEncryptingSqlite() {
  if (_encryptingSqliteVerified) return;
  final probe = sqlite3.openInMemory();
  try {
    assertEncryptionActive(probe);
  } finally {
    probe.close();
  }
  _encryptingSqliteVerified = true;
}

/// Throws unless [db] runs on SQLite3MultipleCiphers.
///
/// If the ordinary library were loaded instead, `PRAGMA key` would be silently
/// ignored and every write would land in plaintext while the app believed
/// otherwise. `sqlite3mc_version()` exists only in SQLite3MultipleCiphers, so its
/// absence proves the wrong library is in use.
void assertEncryptionActive(CommonDatabase db) {
  String? version;
  try {
    final rows = db.select('SELECT sqlite3mc_version() AS v;');
    version = rows.isEmpty ? null : rows.first['v'] as String?;
  } catch (_) {
    version = null;
  }
  if (version == null || version.isEmpty) {
    throw StateError(
      'SQLite3MultipleCiphers is not loaded; refusing to open the store '
      'unencrypted.',
    );
  }
}

/// What [prepareStoreFile] found and did.
enum StorePreparation {
  /// No file yet; it will be created encrypted.
  fresh,

  /// Already encrypted with this device's key.
  encrypted,

  /// Was plaintext and has just been converted.
  migrated,

  /// Neither plaintext nor openable with this key — typically a store copied
  /// to a new phone without the keystore entry. Moved aside, untouched, so the
  /// account can start clean and sync back down.
  setAside,
}

/// Make sure the store at [path] is encrypted with [keyHex] before it is opened.
///
/// Only the app itself may convert or set aside a file ([mayRepair]). The
/// background isolates pass false: two isolates racing through copy-and-swap on
/// the same file is how data gets lost, so a background task that finds a store
/// it cannot open simply throws and lets its caller skip the run.
StorePreparation prepareStoreFile(
  String path,
  String keyHex, {
  bool mayRepair = true,
}) {
  final file = File(path);
  if (!file.existsSync()) return StorePreparation.fresh;

  if (_opensWithKey(path, keyHex)) {
    // Proven readable on a launch after the conversion, so the plaintext safety
    // net has done its job and must not linger.
    _deleteQuietly('$path.plaintext.bak');
    return StorePreparation.encrypted;
  }

  if (!mayRepair) {
    throw StateError('Store $path is not readable with the device key yet.');
  }

  final plainObjects = _plaintextSchemaCount(path);
  if (plainObjects == null) {
    final aside = '$path.unreadable-${DateTime.now().millisecondsSinceEpoch}';
    file.renameSync(aside);
    debugPrint('[Store] $path could not be opened; kept as $aside.');
    return StorePreparation.setAside;
  }

  _encryptCopyAndSwap(file, keyHex, plainObjects);
  return StorePreparation.migrated;
}

void _encryptCopyAndSwap(File file, String keyHex, int plainObjects) {
  final path = file.path;
  final tmpPath = '$path.enc.tmp';
  _deleteQuietly(tmpPath);
  file.copySync(tmpPath);

  final copy = sqlite3.open(tmpPath);
  try {
    // rekey refuses WAL databases; the stores use the default rollback journal,
    // but say so explicitly rather than depend on it.
    copy.execute('PRAGMA journal_mode = DELETE;');
    copy.execute("PRAGMA rekey = '$keyHex';");
  } finally {
    copy.close();
  }

  final encryptedObjects = _encryptedSchemaCount(tmpPath, keyHex);
  if (encryptedObjects == null || encryptedObjects < plainObjects) {
    _deleteQuietly(tmpPath);
    throw StateError(
      'Encrypted copy of $path failed verification '
      '($plainObjects -> $encryptedObjects objects); original left untouched.',
    );
  }

  final bak = '$path.plaintext.bak';
  _deleteQuietly(bak);
  file.renameSync(bak);
  File(tmpPath).renameSync(path);
  // A leftover rollback journal belongs to the plaintext file and would be
  // replayed against the encrypted one.
  _deleteQuietly('$path-journal');
  debugPrint('[Store] $path converted to encrypted storage.');
}

bool _opensWithKey(String path, String keyHex) =>
    _encryptedSchemaCount(path, keyHex) != null;

int? _encryptedSchemaCount(String path, String keyHex) {
  try {
    final db = sqlite3.open(path);
    try {
      applyStoreKey(db, keyHex);
      return db.select('SELECT count(*) AS c FROM sqlite_master;').first['c']
          as int;
    } finally {
      db.close();
    }
  } on StateError {
    rethrow; // wrong library loaded: never fall through to "plaintext"
  } catch (_) {
    return null;
  }
}

int? _plaintextSchemaCount(String path) {
  try {
    final db = sqlite3.open(path);
    try {
      return db.select('SELECT count(*) AS c FROM sqlite_master;').first['c']
          as int;
    } finally {
      db.close();
    }
  } catch (_) {
    return null;
  }
}

void _deleteQuietly(String path) {
  try {
    final f = File(path);
    if (f.existsSync()) f.deleteSync();
  } catch (_) {
    // A stray temp file is untidy, not unsafe.
  }
}
