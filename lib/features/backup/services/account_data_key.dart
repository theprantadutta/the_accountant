import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

/// The signed-in account's data key: what backups are sealed with.
///
/// Issued by the server once per account and then cached on the device, so a
/// backup made on one phone opens on any other phone signed in to the same
/// account, and taking or restoring a backup works offline after the first
/// fetch. Deliberately separate from the store key, which never leaves this
/// device.
class AccountDataKey {
  const AccountDataKey();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(),
  );

  static String _slot(String userId) => 'account_data_key_v1_$userId';

  /// The current account's key, fetched from the server the first time.
  ///
  /// Throws [AccountDataKeyUnavailable] when nobody is signed in, or the key is
  /// not cached yet and the server cannot be reached.
  Future<List<int>> read() async {
    final userId = await SecureTokenStorage.getUserId();
    if (userId == null || userId.isEmpty) {
      throw const AccountDataKeyUnavailable(
        'Sign in to make or restore a backup — backups are encrypted with your '
        'account.',
      );
    }

    final cached = await _storage.read(key: _slot(userId));
    if (cached != null && cached.isNotEmpty) return base64Decode(cached);

    final String key;
    try {
      final response = await ApiService().get('/encryption/key');
      key = (response.data as Map)['key'] as String;
    } catch (_) {
      throw const AccountDataKeyUnavailable(
        'Connect to the internet once so your backups can be encrypted, then '
        'try again.',
      );
    }
    final bytes = base64Decode(key);
    if (bytes.length != 32) {
      throw const AccountDataKeyUnavailable(
        'The server sent an unusable encryption key. Try again later.',
      );
    }
    await _storage.write(key: _slot(userId), value: key);
    return bytes;
  }
}

class AccountDataKeyUnavailable implements Exception {
  const AccountDataKeyUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}
