import 'package:the_accountant/l10n/app_l10n.dart';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';

/// Wrapping the account data key under a passphrase and a recovery code.
///
/// The data key itself never changes; protection only changes who can unwrap
/// it. The server stores the two wrapped copies, the salt and the parameters —
/// none of which reveal the key without the passphrase or the recovery code.
class KeyWrapping {
  const KeyWrapping._();

  /// The associated data every wrap is bound to, so a wrapped blob cannot be
  /// passed off as anything else.
  static final List<int> _aad = utf8.encode('the-accountant/data-key/v1');
  static final AesGcm _cipher = AesGcm.with256bits();

  /// Wrap [dataKey] (32 bytes) under [wrappingKey] (32 bytes); base64 of
  /// nonce, ciphertext and tag.
  static Future<String> wrap(List<int> dataKey, List<int> wrappingKey) async {
    final box = await _cipher.encrypt(
      dataKey,
      secretKey: SecretKey(wrappingKey),
      aad: _aad,
    );
    return base64Encode(box.concatenation());
  }

  /// Unwrap; null when [wrappingKey] is the wrong one (a mistyped passphrase or
  /// recovery code) or the blob is damaged.
  static Future<List<int>?> unwrap(
    String wrapped,
    List<int> wrappingKey,
  ) async {
    try {
      final box = SecretBox.fromConcatenation(
        base64Decode(wrapped),
        nonceLength: _cipher.nonceLength,
        macLength: _cipher.macAlgorithm.macLength,
      );
      final key = await _cipher.decrypt(
        box,
        secretKey: SecretKey(wrappingKey),
        aad: _aad,
      );
      return key.length == 32 ? key : null;
    } catch (_) {
      return null;
    }
  }

  /// A fresh random salt for the passphrase key.
  static List<int> newSalt() => _randomBytes(16);

  /// Derive the passphrase wrapping key. Slow on purpose, so it runs on a
  /// background isolate rather than freezing the screen.
  static Future<List<int>> passphraseKey(
    String passphrase,
    List<int> salt,
    KdfParams params,
  ) {
    params.ensureStrongEnough();
    final pass = utf8.encode(passphrase.trim());
    final memory = params.memoryKiB;
    final iterations = params.iterations;
    final parallelism = params.parallelism;
    return Isolate.run(() async {
      final kdf = DartArgon2id(
        parallelism: parallelism,
        memory: memory,
        iterations: iterations,
        hashLength: 32,
      );
      final key = await kdf.deriveKey(secretKey: SecretKey(pass), nonce: salt);
      return key.extractBytes();
    });
  }

  // ------------------------------------------------------------ recovery code

  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  /// A new recovery code: 160 random bits as eight groups of four, e.g.
  /// `K7QM-2XRA-...`. Base32, so there is no 0/O or 1/I to confuse.
  static String newRecoveryCode() {
    final bytes = _randomBytes(20);
    var bits = 0;
    var value = 0;
    final out = StringBuffer();
    for (final b in bytes) {
      value = (value << 8) | b;
      bits += 8;
      while (bits >= 5) {
        out.write(_alphabet[(value >> (bits - 5)) & 31]);
        bits -= 5;
      }
    }
    final raw = out.toString();
    return [
      for (var i = 0; i < raw.length; i += 4) raw.substring(i, i + 4),
    ].join('-');
  }

  /// The recovery code as typed, reduced to its letters and digits; null when
  /// it cannot be a recovery code at all.
  static String? normalizeRecoveryCode(String typed) {
    final cleaned = typed
        .toUpperCase()
        .replaceAll(RegExp(r'[\s-]'), '')
        .replaceAll('0', 'O')
        .replaceAll('1', 'I')
        .replaceAll('8', 'B');
    if (cleaned.length != 32) return null;
    if (cleaned.split('').any((c) => !_alphabet.contains(c))) return null;
    return cleaned;
  }

  /// The wrapping key for a recovery code. The code already carries 160 random
  /// bits, so a fast derivation is enough; it is the passphrase that needs the
  /// slow one.
  static Future<List<int>?> recoveryKey(String typed) async {
    final code = normalizeRecoveryCode(typed);
    if (code == null) return null;
    final key = await Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
      secretKey: SecretKey(utf8.encode(code)),
      info: utf8.encode('the-accountant/recovery/v1'),
    );
    return key.extractBytes();
  }

  static List<int> _randomBytes(int n) {
    final rng = Random.secure();
    return List<int>.generate(n, (_) => rng.nextInt(256));
  }
}

/// Argon2id parameters, stored on the server next to the wrapped key.
class KdfParams {
  const KdfParams({
    required this.memoryKiB,
    required this.iterations,
    required this.parallelism,
  });

  /// What new protection uses: 64 MiB, three passes, one lane.
  static const KdfParams standard = KdfParams(
    memoryKiB: 65536,
    iterations: 3,
    parallelism: 1,
  );

  /// The weakest this app will ever use — OWASP's floor for Argon2id. Read back
  /// from the server, anything weaker is refused, so a tampered server cannot
  /// talk the app into a guessable key.
  static const int _minMemoryKiB = 19456;
  static const int _minIterations = 2;

  final int memoryKiB;
  final int iterations;
  final int parallelism;

  void ensureStrongEnough() {
    if (memoryKiB < _minMemoryKiB ||
        iterations < _minIterations ||
        parallelism < 1 ||
        memoryKiB > 1048576 ||
        iterations > 20 ||
        parallelism > 8) {
      throw FormatException(appL10n.ppErrKdfParams);
    }
  }

  String encode() => jsonEncode({
    'alg': 'argon2id',
    'v': 19,
    'm': memoryKiB,
    't': iterations,
    'p': parallelism,
  });

  static KdfParams decode(String json) {
    final raw = jsonDecode(json);
    if (raw is! Map || raw['alg'] != 'argon2id') {
      throw FormatException(appL10n.ppErrKdfAlgorithm);
    }
    final params = KdfParams(
      memoryKiB: raw['m'] as int,
      iterations: raw['t'] as int,
      parallelism: raw['p'] as int,
    );
    params.ensureStrongEnough();
    return params;
  }
}
