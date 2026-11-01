import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/encryption/domain/key_wrapping.dart';

final _dataKey = List<int>.generate(32, (i) => i * 3 % 256);

// Fast parameters for tests; the floor still applies.
const _testParams = KdfParams(memoryKiB: 19456, iterations: 2, parallelism: 1);

void main() {
  test('a passphrase unwraps what it wrapped; another does not', () async {
    final salt = KeyWrapping.newSalt();
    final key = await KeyWrapping.passphraseKey(
      'river cactus 42',
      salt,
      _testParams,
    );

    final wrapped = await KeyWrapping.wrap(_dataKey, key);

    expect(await KeyWrapping.unwrap(wrapped, key), _dataKey);
    final wrong = await KeyWrapping.passphraseKey(
      'river cactus 43',
      salt,
      _testParams,
    );
    expect(await KeyWrapping.unwrap(wrapped, wrong), isNull);
  });

  test('the same passphrase and salt always give the same key', () async {
    final salt = KeyWrapping.newSalt();
    expect(
      await KeyWrapping.passphraseKey('same', salt, _testParams),
      await KeyWrapping.passphraseKey('same', salt, _testParams),
    );
  });

  test('a recovery code is eight groups of four, and unwraps', () async {
    final code = KeyWrapping.newRecoveryCode();
    expect(code, matches(RegExp(r'^([A-Z2-7]{4}-){7}[A-Z2-7]{4}$')));

    final wrapped = await KeyWrapping.wrap(
      _dataKey,
      (await KeyWrapping.recoveryKey(code))!,
    );

    expect(
      await KeyWrapping.unwrap(wrapped, (await KeyWrapping.recoveryKey(code))!),
      _dataKey,
    );
  });

  test('a recovery code typed loosely still works', () async {
    final code = KeyWrapping.newRecoveryCode();
    final wrapped = await KeyWrapping.wrap(
      _dataKey,
      (await KeyWrapping.recoveryKey(code))!,
    );
    final sloppy = ' ${code.toLowerCase().replaceAll('-', ' ')} ';

    expect(
      await KeyWrapping.unwrap(
        wrapped,
        (await KeyWrapping.recoveryKey(sloppy))!,
      ),
      _dataKey,
    );
  });

  test('something that cannot be a recovery code is rejected early', () async {
    expect(await KeyWrapping.recoveryKey('too short'), isNull);
  });

  test('two recovery codes are never the same', () {
    expect(KeyWrapping.newRecoveryCode(), isNot(KeyWrapping.newRecoveryCode()));
  });

  test('parameters round-trip, and weak ones from a server are refused', () {
    expect(KdfParams.decode(KdfParams.standard.encode()).memoryKiB, 65536);
    expect(
      () => KdfParams.decode('{"alg":"argon2id","m":1024,"t":1,"p":1}'),
      throwsFormatException,
    );
    expect(
      () => KdfParams.decode('{"alg":"pbkdf2","m":65536,"t":3,"p":1}'),
      throwsFormatException,
    );
  });

  test('a damaged wrapped key is null, not a crash', () async {
    final key = (await KeyWrapping.recoveryKey(KeyWrapping.newRecoveryCode()))!;
    expect(await KeyWrapping.unwrap('bm90IGEga2V5', key), isNull);
  });
}
