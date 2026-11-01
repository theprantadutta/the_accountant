import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';
import 'package:the_accountant/features/encryption/domain/key_wrapping.dart';

/// The signed-in account's data key: what backups (and, from 5.0, synced data)
/// are sealed with.
///
/// Issued by the server once per account and cached on the device, so sealed
/// data made on one phone opens on any other phone signed in to the same
/// account, and works offline after the first fetch.
///
/// With passphrase protection the server holds only wrapped copies. A device
/// that already has the key cached carries on as before; one that does not —
/// a new phone, a reinstall — must be unlocked with the passphrase or the
/// recovery code before anything sealed can be read.
class AccountDataKey {
  const AccountDataKey({
    KeyServer server = const ApiKeyServer(),
    Future<String?> Function()? currentUserId,
    KdfParams kdfParams = KdfParams.standard,
  }) : // A named parameter cannot be a private initializing formal.
       // ignore: prefer_initializing_formals
       _server = server,
       _currentUserId = currentUserId ?? SecureTokenStorage.getUserId,
       // ignore: prefer_initializing_formals
       _kdfParams = kdfParams;

  final KeyServer _server;
  final Future<String?> Function() _currentUserId;

  /// Parameters for wrapping under a new passphrase. Unlocking always uses
  /// whatever the server says the wrap was made with.
  final KdfParams _kdfParams;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(),
  );

  static String _slot(String userId) => 'account_data_key_v1_$userId';

  /// The current account's key.
  ///
  /// Throws [AccountDataKeyLocked] when the account is protected and this
  /// device has not been unlocked, and [AccountDataKeyUnavailable] when nobody
  /// is signed in or the key is not cached and the server cannot be reached.
  Future<List<int>> read() async {
    final userId = await _requireUser();
    final cached = await _storage.read(key: _slot(userId));
    if (cached != null && cached.isNotEmpty) return base64Decode(cached);

    final state = await _fetch();
    if (state.protected) throw const AccountDataKeyLocked();
    final bytes = base64Decode(state.key!);
    if (bytes.length != 32) {
      throw const AccountDataKeyUnavailable(
        'The server sent an unusable encryption key. Try again later.',
      );
    }
    await _remember(userId, bytes);
    return bytes;
  }

  /// Whether the account is protected and whether this device holds the key.
  Future<KeyStatus> status() async {
    final userId = await _requireUser();
    final unlocked =
        (await _storage.read(key: _slot(userId)))?.isNotEmpty ?? false;
    final state = await _fetch();
    return KeyStatus(
      protected: state.protected,
      unlockedHere: unlocked || !state.protected,
    );
  }

  /// Unlock this device with the passphrase. False when it is wrong.
  Future<bool> unlockWithPassphrase(String passphrase) async {
    final userId = await _requireUser();
    final state = await _fetch();
    if (!state.protected) return true;
    final wrapping = await KeyWrapping.passphraseKey(
      passphrase,
      base64Decode(state.kdfSalt!),
      KdfParams.decode(state.kdfParams!),
    );
    final key = await KeyWrapping.unwrap(state.wrappedKey!, wrapping);
    if (key == null) return false;
    await _remember(userId, key);
    return true;
  }

  /// Unlock this device with the recovery code. False when it is wrong.
  Future<bool> unlockWithRecoveryCode(String code) async {
    final userId = await _requireUser();
    final state = await _fetch();
    if (!state.protected) return true;
    final wrapping = await KeyWrapping.recoveryKey(code);
    if (wrapping == null) return false;
    final key = await KeyWrapping.unwrap(state.wrappedKeyRecovery!, wrapping);
    if (key == null) return false;
    await _remember(userId, key);
    return true;
  }

  /// Turn protection on with [passphrase]; returns the new recovery code,
  /// which the user must keep.
  Future<String> enableProtection(String passphrase) async {
    final key = await read();
    final recoveryCode = KeyWrapping.newRecoveryCode();
    await _publish(
      key: key,
      passphrase: passphrase,
      recoveryCode: recoveryCode,
    );
    return recoveryCode;
  }

  /// Replace the passphrase; the recovery code stays the same.
  Future<void> changePassphrase(String passphrase) async {
    final key = await read();
    final state = await _fetch();
    await _publish(
      key: key,
      passphrase: passphrase,
      keepRecoveryWrap: state.wrappedKeyRecovery,
    );
  }

  /// Issue a new recovery code (the old one stops working); the passphrase
  /// stays the same.
  Future<String> newRecoveryCode() async {
    final key = await read();
    final state = await _fetch();
    final code = KeyWrapping.newRecoveryCode();
    final recoveryWrap = await KeyWrapping.wrap(
      key,
      (await KeyWrapping.recoveryKey(code))!,
    );
    await _verify(recoveryWrap, (await KeyWrapping.recoveryKey(code))!, key);
    await _server.setPassphrase(
      wrappedKey: state.wrappedKey!,
      wrappedKeyRecovery: recoveryWrap,
      kdfSalt: state.kdfSalt!,
      kdfParams: state.kdfParams!,
    );
    return code;
  }

  /// Turn protection off: the server holds the key again.
  Future<void> disableProtection() async {
    final key = await read();
    await _server.removePassphrase(base64Encode(key));
  }

  Future<void> _publish({
    required List<int> key,
    required String passphrase,
    String? recoveryCode,
    String? keepRecoveryWrap,
  }) async {
    final salt = KeyWrapping.newSalt();
    final params = _kdfParams;
    final passKey = await KeyWrapping.passphraseKey(passphrase, salt, params);
    final passWrap = await KeyWrapping.wrap(key, passKey);
    // Never send a wrap that has not been proven to open: a bad one would lock
    // the user out of their own data the moment the plain key is dropped.
    await _verify(passWrap, passKey, key);

    var recoveryWrap = keepRecoveryWrap;
    if (recoveryCode != null) {
      final recoveryKey = (await KeyWrapping.recoveryKey(recoveryCode))!;
      recoveryWrap = await KeyWrapping.wrap(key, recoveryKey);
      await _verify(recoveryWrap, recoveryKey, key);
    }

    await _server.setPassphrase(
      wrappedKey: passWrap,
      wrappedKeyRecovery: recoveryWrap!,
      kdfSalt: base64Encode(salt),
      kdfParams: params.encode(),
    );
  }

  static Future<void> _verify(
    String wrapped,
    List<int> wrapping,
    List<int> key,
  ) async {
    final back = await KeyWrapping.unwrap(wrapped, wrapping);
    if (back == null || base64Encode(back) != base64Encode(key)) {
      throw StateError('A wrapped key failed to open; nothing was changed.');
    }
  }

  Future<void> _remember(String userId, List<int> key) =>
      _storage.write(key: _slot(userId), value: base64Encode(key));

  Future<String> _requireUser() async {
    final userId = await _currentUserId();
    if (userId == null || userId.isEmpty) {
      throw const AccountDataKeyUnavailable(
        'Sign in to make or restore a backup — backups are encrypted with your '
        'account.',
      );
    }
    return userId;
  }

  Future<ServerKeyState> _fetch() async {
    try {
      return await _server.fetch();
    } catch (_) {
      throw const AccountDataKeyUnavailable(
        'Connect to the internet once so your data can be encrypted, then try '
        'again.',
      );
    }
  }
}

/// Where the account key lives on the server.
abstract class KeyServer {
  Future<ServerKeyState> fetch();

  Future<void> setPassphrase({
    required String wrappedKey,
    required String wrappedKeyRecovery,
    required String kdfSalt,
    required String kdfParams,
  });

  Future<void> removePassphrase(String key);
}

class ApiKeyServer implements KeyServer {
  const ApiKeyServer();

  @override
  Future<ServerKeyState> fetch() async {
    final response = await ApiService().get('/encryption/key');
    return ServerKeyState.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<void> setPassphrase({
    required String wrappedKey,
    required String wrappedKeyRecovery,
    required String kdfSalt,
    required String kdfParams,
  }) async {
    await ApiService().post(
      '/encryption/passphrase',
      data: {
        'wrappedKey': wrappedKey,
        'wrappedKeyRecovery': wrappedKeyRecovery,
        'kdfSalt': kdfSalt,
        'kdfParams': kdfParams,
      },
    );
  }

  @override
  Future<void> removePassphrase(String key) async {
    await ApiService().post(
      '/encryption/passphrase/remove',
      data: {'key': key},
    );
  }
}

/// What the server holds for the account.
class ServerKeyState {
  const ServerKeyState({
    this.key,
    this.protected = false,
    this.wrappedKey,
    this.wrappedKeyRecovery,
    this.kdfSalt,
    this.kdfParams,
  });

  factory ServerKeyState.fromJson(Map<String, dynamic> json) => ServerKeyState(
    key: json['key'] as String?,
    protected: json['protected'] as bool? ?? false,
    wrappedKey: json['wrappedKey'] as String?,
    wrappedKeyRecovery: json['wrappedKeyRecovery'] as String?,
    kdfSalt: json['kdfSalt'] as String?,
    kdfParams: json['kdfParams'] as String?,
  );

  final String? key;
  final bool protected;
  final String? wrappedKey;
  final String? wrappedKeyRecovery;
  final String? kdfSalt;
  final String? kdfParams;
}

class KeyStatus {
  const KeyStatus({required this.protected, required this.unlockedHere});

  /// The user opted in to passphrase protection.
  final bool protected;

  /// This device holds the key (always true for an unprotected account).
  final bool unlockedHere;
}

class AccountDataKeyUnavailable implements Exception {
  const AccountDataKeyUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The account is passphrase-protected and this device has not been unlocked.
class AccountDataKeyLocked implements Exception {
  const AccountDataKeyLocked();

  @override
  String toString() =>
      'Your data is protected with a passphrase. Unlock it on this device '
      'first.';
}
