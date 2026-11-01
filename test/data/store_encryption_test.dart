import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/store_encryption.dart';

const _key = '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';

void main() {
  late Directory dir;
  late String path;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('store_enc_');
    path = '${dir.path}/db.sqlite';
  });

  tearDown(() => dir.deleteSync(recursive: true));

  void writePlaintextStore() {
    final db = sqlite3.open(path);
    db.execute('CREATE TABLE t (id INTEGER PRIMARY KEY, title TEXT)');
    db.execute("INSERT INTO t (title) VALUES ('Rickshaw 60')");
    db.close();
  }

  bool fileHasPlaintext(String needle) =>
      String.fromCharCodes(File(path).readAsBytesSync()).contains(needle);

  test('the encrypting SQLite build is the one loaded', () {
    final db = sqlite3.openInMemory();
    addTearDown(db.close);
    expect(() => assertEncryptionActive(db), returnsNormally);
  });

  test('no file yet is left for the app to create encrypted', () {
    expect(prepareStoreFile(path, _key), StorePreparation.fresh);
  });

  test('a plaintext store is converted, keeping every row', () {
    writePlaintextStore();
    expect(fileHasPlaintext('Rickshaw 60'), isTrue);

    expect(prepareStoreFile(path, _key), StorePreparation.migrated);

    expect(fileHasPlaintext('Rickshaw 60'), isFalse);
    expect(File('$path.plaintext.bak').existsSync(), isTrue);
    final db = sqlite3.open(path);
    addTearDown(db.close);
    applyStoreKey(db, _key);
    expect(db.select('SELECT title FROM t').single['title'], 'Rickshaw 60');
  });

  test('the plaintext safety copy goes once the encrypted store opens', () {
    writePlaintextStore();
    prepareStoreFile(path, _key);

    expect(prepareStoreFile(path, _key), StorePreparation.encrypted);
    expect(File('$path.plaintext.bak').existsSync(), isFalse);
  });

  test('a store this key cannot open is set aside, never deleted', () {
    writePlaintextStore();
    prepareStoreFile(path, 'ff' * 32); // encrypted with another phone's key

    expect(prepareStoreFile(path, _key), StorePreparation.setAside);
    expect(File(path).existsSync(), isFalse);
    expect(
      dir.listSync().map((e) => e.path).any((p) => p.contains('unreadable')),
      isTrue,
    );
  });

  test('a background opener never converts a store', () {
    writePlaintextStore();
    expect(
      () => prepareStoreFile(path, _key, mayRepair: false),
      throwsStateError,
    );
    expect(fileHasPlaintext('Rickshaw 60'), isTrue);
  });

  test('the app database runs on an encrypted file', () async {
    final db = AppDatabase(
      NativeDatabase(File(path), setup: (raw) => applyStoreKey(raw, _key)),
    );
    await db.getLocalStoreOwnerUserId(); // forces creation and migrations
    await db.close();

    expect(prepareStoreFile(path, _key), StorePreparation.encrypted);
    expect(() {
      final raw = sqlite3.open(path);
      try {
        raw.select('SELECT count(*) FROM sqlite_master');
      } finally {
        raw.close();
      }
    }, throwsA(isA<SqliteException>()));
  });
}
