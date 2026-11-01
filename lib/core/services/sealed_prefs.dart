import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/store_encryption.dart';

/// SharedPreferences values that hold financial details, encrypted.
///
/// A few things live in preferences rather than the store — the notification
/// inbox, because a background isolate writes it; the zakat items; the cached
/// monthly review — and preferences are a plain XML/plist file. Those values
/// are sealed with AES-256-GCM under a key derived from the device's store key,
/// so they are exactly as readable as the store itself and no more.
///
/// A value written before this existed is plain text; reading one returns it
/// and immediately writes it back sealed, so old values do not linger.
class SealedPrefs {
  const SealedPrefs._();

  static const String _marker = 'sealed:v1:';

  static final AesGcm _cipher = AesGcm.with256bits();
  static SecretKey? _key;

  /// Read [key], decrypting it; null when absent or unreadable.
  static Future<String?> getString(SharedPreferences prefs, String key) async {
    final raw = prefs.getString(key);
    if (raw == null) return null;
    if (!raw.startsWith(_marker)) {
      await setString(prefs, key, raw);
      return raw;
    }
    try {
      final data = base64Decode(raw.substring(_marker.length));
      final box = SecretBox.fromConcatenation(
        data,
        nonceLength: _cipher.nonceLength,
        macLength: _cipher.macAlgorithm.macLength,
      );
      return utf8.decode(
        await _cipher.decrypt(
          box,
          secretKey: await _secretKey(),
          aad: utf8.encode(key),
        ),
      );
    } catch (_) {
      // Sealed under a key this device no longer has. The values here are
      // caches and conveniences, so starting again beats failing the screen.
      return null;
    }
  }

  /// Write [value] under [key], encrypted.
  static Future<void> setString(
    SharedPreferences prefs,
    String key,
    String value,
  ) async {
    final box = await _cipher.encrypt(
      utf8.encode(value),
      secretKey: await _secretKey(),
      // Binds the value to its name, so one sealed value cannot be moved under
      // another key and read as if it belonged there.
      aad: utf8.encode(key),
    );
    await prefs.setString(key, '$_marker${base64Encode(box.concatenation())}');
  }

  /// The finished key is cached, not the pending derivation: a Future started
  /// in one zone (a widget test's fake clock, say) never completes in another,
  /// and every later caller would wait on it for ever. Two callers racing here
  /// both derive the same key, which costs a few microseconds.
  static Future<SecretKey> _secretKey() async => _key ??= await _derive();

  static Future<SecretKey> _derive() async {
    final storeKeyHex = await readOrCreateStoreKey();
    final storeKey = [
      for (var i = 0; i < storeKeyHex.length; i += 2)
        int.parse(storeKeyHex.substring(i, i + 2), radix: 16),
    ];
    // A separate key, not the store key reused: the store key is SQLite's
    // passphrase, and one secret should not do two jobs.
    return Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
      secretKey: SecretKey(storeKey),
      info: utf8.encode('the-accountant/prefs/v1'),
    );
  }
}
