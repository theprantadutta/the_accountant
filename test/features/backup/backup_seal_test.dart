import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/domain/backup_seal.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';
import 'package:the_accountant/features/backup/services/backup_codec.dart';
import 'package:the_accountant/features/encryption/domain/key_wrapping.dart';

final _key = List<int>.generate(32, (i) => i);
final _otherKey = List<int>.generate(32, (i) => 255 - i);

BackupDocument _document() => BackupDocument(
  metadata: BackupMetadata(
    schemaVersion: 31,
    createdAt: DateTime.utc(2026, 11, 1),
    ownerEmail: 'someone@example.com',
  ),
  tables: {
    'transactions': [
      {'id': 't1', 'title': 'Rickshaw', 'amount': 6000},
    ],
  },
);

void main() {
  test('a sealed backup gives back exactly what went in', () async {
    final plain = _document().encode();

    final sealed = await BackupSeal.seal(plain, _key);

    expect(await BackupSeal.open(sealed, _key), plain);
  });

  test('nothing in the file can be read without the key', () async {
    final sealed = await BackupSeal.seal(_document().encode(), _key);

    expect(sealed, isNot(contains('Rickshaw')));
    expect(sealed, isNot(contains('someone@example.com')));
    expect(BackupSeal.isSealed(sealed), isTrue);
  });

  test('two seals of the same backup never look alike', () async {
    final plain = _document().encode();
    expect(
      await BackupSeal.seal(plain, _key),
      isNot(await BackupSeal.seal(plain, _key)),
    );
  });

  test("another account's key is refused with a readable reason", () async {
    final sealed = await BackupSeal.seal(_document().encode(), _key);

    expect(
      () => BackupSeal.open(sealed, _otherKey),
      throwsA(
        isA<BackupFormatException>().having(
          (e) => e.message,
          'message',
          contains('different account'),
        ),
      ),
    );
  });

  test('a changed byte is caught, not restored', () async {
    final sealed = await BackupSeal.seal(_document().encode(), _key);
    final i = sealed.indexOf('"data":"') + 12;
    final flipped = sealed.replaceRange(i, i + 1, sealed[i] == 'A' ? 'B' : 'A');

    expect(
      () => BackupSeal.open(flipped, _key),
      throwsA(isA<BackupFormatException>()),
    );
  });

  test('a backup from a newer app is refused', () async {
    final sealed = (await BackupSeal.seal(
      _document().encode(),
      _key,
    )).replaceFirst('"version":1', '"version":99');

    expect(
      () => BackupSeal.open(sealed, _key),
      throwsA(isA<BackupFormatException>()),
    );
  });

  group('the codec', () {
    final codec = BackupCodec(key: () async => _key);

    test('writes sealed backups and reads them back', () async {
      final file = await codec.encode(_document());

      expect(BackupSeal.isSealed(file), isTrue);
      final back = await codec.decode(file);
      expect(back.tables['transactions']!.single['title'], 'Rickshaw');
    });

    test('still restores the plain backups older versions wrote', () async {
      final back = await codec.decode(_document().encode());

      expect(back.metadata.ownerEmail, 'someone@example.com');
    });

    test('never asks for the key to read a plain backup', () async {
      final keyless = BackupCodec(key: () async => throw StateError('no key'));

      expect(await keyless.decode(_document().encode()), isA<BackupDocument>());
    });
  });

  group('a backup from a protected account', () {
    const passphrase = 'correct horse battery staple';
    const fast = KdfParams(memoryKiB: 19456, iterations: 2, parallelism: 1);
    late String recoveryCode;
    late BackupLocks locks;

    setUpAll(() async {
      final salt = KeyWrapping.newSalt();
      recoveryCode = KeyWrapping.newRecoveryCode();
      locks = BackupLocks(
        wrappedKey: await KeyWrapping.wrap(
          _key,
          await KeyWrapping.passphraseKey(passphrase, salt, fast),
        ),
        wrappedKeyRecovery: await KeyWrapping.wrap(
          _key,
          (await KeyWrapping.recoveryKey(recoveryCode))!,
        ),
        kdfSalt: base64Encode(salt),
        kdfParams: fast.encode(),
      );
    });

    Future<String> sealedFile() => BackupCodec(
      key: () async => _key,
      locks: () async => locks,
    ).encode(_document());

    /// A phone that cannot get the key: our server unreachable, never cached.
    final offline = BackupCodec(
      key: () async =>
          throw const AccountDataKeyUnavailable('offline', unreachable: true),
      locks: () async => null,
    );

    test('carries the locked key, never the key itself', () async {
      final file = await sealedFile();

      expect(BackupSeal.locksOf(file), isNotNull);
      expect(file, isNot(contains(base64Encode(_key))));
    });

    test('offline, it asks for the passphrase instead of failing', () async {
      final file = await sealedFile();

      expect(() => offline.decode(file), throwsA(isA<BackupNeedsSecret>()));
    });

    test('opens with the passphrase, with no server at all', () async {
      final file = await sealedFile();

      final back = await offline.decodeWithSecret(file, passphrase);
      expect(back.tables['transactions']!.single['title'], 'Rickshaw');
    });

    test('opens with the recovery code too', () async {
      final file = await sealedFile();

      final back = await offline.decodeWithSecret(
        file,
        recoveryCode,
        isRecoveryCode: true,
      );
      expect(back.metadata.ownerEmail, 'someone@example.com');
    });

    test('a wrong passphrase is refused, not mistaken for damage', () async {
      final file = await sealedFile();

      expect(
        () => offline.decodeWithSecret(file, 'not the passphrase'),
        throwsA(isA<BackupWrongSecret>()),
      );
    });

    test("another account's key asks for the passphrase too", () async {
      final file = await sealedFile();
      final other = BackupCodec(
        key: () async => _otherKey,
        locks: () async => null,
      );

      expect(() => other.decode(file), throwsA(isA<BackupNeedsSecret>()));
    });

    test('without a passphrase on the account, nothing changes', () async {
      final file = await BackupCodec(
        key: () async => _key,
        locks: () async => null,
      ).encode(_document());

      expect(BackupSeal.locksOf(file), isNull);
      expect(
        () => offline.decode(file),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e is BackupNeedsSecret,
            'asks for a secret',
            isFalse,
          ),
        ),
      );
    });
  });
}
