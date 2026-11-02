import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/encryption/domain/key_wrapping.dart';

/// The encrypted wrapper around a backup.
///
/// A backup is every financial record the user holds, and it leaves the phone:
/// into Google Drive, a downloads folder, a chat thread. So the JSON is sealed
/// with AES-256-GCM under the account's data key before it is written anywhere,
/// and the file says nothing about its contents beyond what it is.
///
/// ```json
/// { "format": "the-accountant-encrypted-backup", "version": 1,
///   "cipher": "AES-256-GCM", "nonce": "<base64>", "data": "<base64>" }
/// ```
///
/// `data` is the ciphertext followed by the 16-byte tag. The format tag is bound
/// in as associated data, so the header cannot be swapped onto other contents.
/// Backups written before this existed are plain JSON and still restore.
///
/// For an account with passphrase protection the header also carries
/// `unlock`: the account key wrapped under the passphrase and under the
/// recovery code, with the salt and key-derivation settings — the same locked
/// copies the server holds. With those, the backup opens with the passphrase
/// or recovery code alone, on any phone, without our server. They reveal
/// nothing without one of the two secrets. Older apps ignore the field, so
/// the version is unchanged.
class BackupSeal {
  const BackupSeal._();

  static const String formatTag = 'the-accountant-encrypted-backup';
  static const int currentVersion = 1;
  static const String _cipherName = 'AES-256-GCM';

  static final AesGcm _cipher = AesGcm.with256bits();

  /// Encrypt [plaintext] (an encoded [BackupDocument]) under [key].
  ///
  /// [locks], when the account has them, let the file be opened later with
  /// the passphrase or recovery code instead of the server.
  static Future<String> seal(
    String plaintext,
    List<int> key, {
    BackupLocks? locks,
  }) async {
    _checkKey(key);
    final box = await _cipher.encrypt(
      utf8.encode(plaintext),
      secretKey: SecretKey(key),
      aad: utf8.encode(formatTag),
    );
    return jsonEncode({
      'format': formatTag,
      'version': currentVersion,
      'cipher': _cipherName,
      'nonce': base64Encode(box.nonce),
      'data': base64Encode([...box.cipherText, ...box.mac.bytes]),
      'unlock': ?locks?.toJson(),
    });
  }

  /// The locked key copies a sealed backup carries, or null.
  static BackupLocks? locksOf(String source) {
    try {
      final raw = jsonDecode(source);
      if (raw is! Map || raw['format'] != formatTag) return null;
      final unlock = raw['unlock'];
      return unlock is Map ? BackupLocks.fromJson(unlock) : null;
    } on FormatException {
      return null;
    }
  }

  /// Whether [source] is a sealed backup rather than a plain one.
  static bool isSealed(String source) {
    // Cheap check first: a plain backup is a large document, and parsing it
    // twice just to learn it is not sealed would be wasteful.
    if (!source.contains(formatTag)) return false;
    try {
      final raw = jsonDecode(source);
      return raw is Map && raw['format'] == formatTag;
    } on FormatException {
      return false;
    }
  }

  /// Decrypt a sealed backup back to its JSON.
  ///
  /// Throws [BackupFormatException] with a message fit to show the user when
  /// the file is damaged, from a newer app, or sealed under another key — which
  /// in practice means another account.
  static Future<String> open(String source, List<int> key) async {
    _checkKey(key);
    final Object? raw;
    try {
      raw = jsonDecode(source);
    } on FormatException {
      throw const BackupFormatException('This backup file is damaged.');
    }
    if (raw is! Map || raw['format'] != formatTag) {
      throw const BackupFormatException(
        'This file is not a backup from The Accountant.',
      );
    }
    final version = raw['version'];
    if (version is! int || version > currentVersion) {
      throw const BackupFormatException(
        'This backup was written by a newer version of the app. Update The '
        'Accountant and try again.',
      );
    }

    final List<int> nonce;
    final List<int> data;
    try {
      nonce = base64Decode(raw['nonce'] as String);
      data = base64Decode(raw['data'] as String);
    } catch (_) {
      throw const BackupFormatException('This backup file is damaged.');
    }
    const tagLength = 16;
    if (data.length < tagLength) {
      throw const BackupFormatException('This backup file is damaged.');
    }

    try {
      final clear = await _cipher.decrypt(
        SecretBox(
          data.sublist(0, data.length - tagLength),
          nonce: nonce,
          mac: Mac(data.sublist(data.length - tagLength)),
        ),
        secretKey: SecretKey(key),
        aad: utf8.encode(formatTag),
      );
      return utf8.decode(clear);
    } on SecretBoxAuthenticationError {
      throw const BackupWrongKey();
    }
  }

  static void _checkKey(List<int> key) {
    if (key.length != 32) {
      throw ArgumentError.value(key.length, 'key', 'must be 32 bytes');
    }
  }
}

/// The key a sealed backup was opened with is not the one it was made with.
class BackupWrongKey extends BackupFormatException {
  const BackupWrongKey()
    : super(
        'This backup belongs to a different account, or the file has been '
        'changed. Sign in with the account that made it to restore it.',
      );
}

/// The account key, locked under the passphrase and under the recovery code.
///
/// What the server keeps for a protected account, carried in a backup so the
/// file does not depend on the server to be opened.
class BackupLocks {
  const BackupLocks({
    required this.wrappedKey,
    required this.wrappedKeyRecovery,
    required this.kdfSalt,
    required this.kdfParams,
  });

  factory BackupLocks.fromJson(Map<dynamic, dynamic> json) => BackupLocks(
    wrappedKey: json['wrappedKey'] as String,
    wrappedKeyRecovery: json['wrappedKeyRecovery'] as String,
    kdfSalt: json['kdfSalt'] as String,
    kdfParams: json['kdfParams'] as String,
  );

  final String wrappedKey;
  final String wrappedKeyRecovery;
  final String kdfSalt;
  final String kdfParams;

  Map<String, String> toJson() => {
    'wrappedKey': wrappedKey,
    'wrappedKeyRecovery': wrappedKeyRecovery,
    'kdfSalt': kdfSalt,
    'kdfParams': kdfParams,
  };

  /// The key, or null when [passphrase] is wrong.
  Future<List<int>?> openWithPassphrase(String passphrase) async {
    try {
      final wrapping = await KeyWrapping.passphraseKey(
        passphrase,
        base64Decode(kdfSalt),
        KdfParams.decode(kdfParams),
      );
      return await KeyWrapping.unwrap(wrappedKey, wrapping);
    } on FormatException {
      return null;
    }
  }

  /// The key, or null when [code] is wrong.
  Future<List<int>?> openWithRecoveryCode(String code) async {
    final wrapping = await KeyWrapping.recoveryKey(code);
    if (wrapping == null) return null;
    return KeyWrapping.unwrap(wrappedKeyRecovery, wrapping);
  }
}
