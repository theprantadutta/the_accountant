import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';
import 'package:the_accountant/features/encryption/domain/key_wrapping.dart';

const _fast = KdfParams(memoryKiB: 19456, iterations: 2, parallelism: 1);

/// The server, as the app sees it: holds a plain key until protection is on,
/// then only the wrapped copies.
class _FakeServer implements KeyServer {
  _FakeServer() : plainKey = base64Encode(List<int>.generate(32, (i) => i));

  String? plainKey;
  String? wrappedKey;
  String? wrappedKeyRecovery;
  String? kdfSalt;
  String? kdfParams;
  bool offline = false;

  bool get protected => wrappedKey != null;

  @override
  Future<ServerKeyState> fetch() async {
    if (offline) throw Exception('offline');
    return protected
        ? ServerKeyState(
            protected: true,
            wrappedKey: wrappedKey,
            wrappedKeyRecovery: wrappedKeyRecovery,
            kdfSalt: kdfSalt,
            kdfParams: kdfParams,
          )
        : ServerKeyState(key: plainKey);
  }

  @override
  Future<void> setPassphrase({
    required String wrappedKey,
    required String wrappedKeyRecovery,
    required String kdfSalt,
    required String kdfParams,
  }) async {
    this.wrappedKey = wrappedKey;
    this.wrappedKeyRecovery = wrappedKeyRecovery;
    this.kdfSalt = kdfSalt;
    this.kdfParams = kdfParams;
    plainKey = null;
  }

  @override
  Future<void> removePassphrase(String key) async {
    plainKey = key;
    wrappedKey = wrappedKeyRecovery = kdfSalt = kdfParams = null;
  }
}

void main() {
  late _FakeServer server;

  AccountDataKey keys() => AccountDataKey(
    server: server,
    currentUserId: () async => 'user-1',
    kdfParams: _fast,
  );

  /// A second phone: same account, nothing cached.
  void switchToNewPhone() => FlutterSecureStorage.setMockInitialValues({});

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    server = _FakeServer();
  });

  test('an unprotected account just hands out its key', () async {
    expect(await keys().read(), base64Decode(server.plainKey!));
  });

  test(
    'turning protection on keeps the same key, and this phone keeps working',
    () async {
      final before = await keys().read();

      final code = await keys().enableProtection('long enough passphrase');

      expect(code, matches(RegExp(r'^([A-Z2-7]{4}-){7}[A-Z2-7]{4}$')));
      expect(server.plainKey, isNull);
      expect(await keys().read(), before);
    },
  );

  test('a new phone is locked until the passphrase is given', () async {
    final key = await keys().read();
    await keys().enableProtection('long enough passphrase');
    switchToNewPhone();

    expect(() => keys().read(), throwsA(isA<AccountDataKeyLocked>()));
    expect((await keys().status()).unlockedHere, isFalse);

    expect(await keys().unlockWithPassphrase('wrong passphrase'), isFalse);
    expect(await keys().unlockWithPassphrase('long enough passphrase'), isTrue);
    expect(await keys().read(), key);
  });

  test('the recovery code unlocks a new phone too', () async {
    final key = await keys().read();
    final code = await keys().enableProtection('forgotten later');
    switchToNewPhone();

    expect(
      await keys().unlockWithRecoveryCode(
        'AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA',
      ),
      isFalse,
    );
    expect(await keys().unlockWithRecoveryCode(code), isTrue);
    expect(await keys().read(), key);
  });

  test(
    'a changed passphrase works and the old one stops, recovery unchanged',
    () async {
      await keys().read();
      final code = await keys().enableProtection('first passphrase');
      await keys().changePassphrase('second passphrase');
      switchToNewPhone();

      expect(await keys().unlockWithPassphrase('first passphrase'), isFalse);
      expect(await keys().unlockWithPassphrase('second passphrase'), isTrue);
      switchToNewPhone();
      expect(await keys().unlockWithRecoveryCode(code), isTrue);
    },
  );

  test(
    'a new recovery code replaces the old one, passphrase unchanged',
    () async {
      await keys().read();
      final oldCode = await keys().enableProtection('the passphrase');
      final newCode = await keys().newRecoveryCode();
      switchToNewPhone();

      expect(await keys().unlockWithRecoveryCode(oldCode), isFalse);
      expect(await keys().unlockWithRecoveryCode(newCode), isTrue);
      switchToNewPhone();
      expect(await keys().unlockWithPassphrase('the passphrase'), isTrue);
    },
  );

  test('turning protection off gives the server the same key back', () async {
    final key = await keys().read();
    await keys().enableProtection('the passphrase');

    await keys().disableProtection();

    expect(base64Decode(server.plainKey!), key);
    switchToNewPhone();
    expect(await keys().read(), key);
  });

  test('an unlocked phone keeps working offline', () async {
    final key = await keys().read();
    await keys().enableProtection('the passphrase');
    server.offline = true;

    expect(await keys().read(), key);
  });

  test('a locked phone that is offline says so instead of guessing', () async {
    await keys().read();
    await keys().enableProtection('the passphrase');
    switchToNewPhone();
    server.offline = true;

    expect(() => keys().read(), throwsA(isA<AccountDataKeyUnavailable>()));
  });

  test('backups made offline still carry the locked key', () async {
    await keys().read();
    await keys().enableProtection('correct horse battery staple');

    server.offline = true;
    final locks = await keys().backupLocks();

    expect(locks, isNotNull);
    expect(locks!.wrappedKey, server.wrappedKey);
    expect(
      await locks.openWithPassphrase('correct horse battery staple'),
      isNotNull,
    );
  });

  test('an account without a passphrase puts no locks in backups', () async {
    await keys().read();
    expect(await keys().backupLocks(), isNull);
  });

  test('turning protection off stops backups carrying the old locks', () async {
    final key = await keys().read();
    await keys().enableProtection('correct horse battery staple');
    expect(await keys().backupLocks(), isNotNull);

    await server.removePassphrase(base64Encode(key));
    expect(await keys().backupLocks(), isNull);
  });
}
