import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/domain/backup_schedule.dart';
import 'package:the_accountant/features/backup/services/drive_backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';

import '../helpers/test_database.dart';

/// Keeping backups in the folder on Drive only this app can see.
///
/// The point of the interval-plus-retained-count pairing is that neither half
/// works alone: an interval on its own fills the account for ever, and a count
/// on its own never runs. These tests hold both, plus the rule that matters
/// most — old copies are only ever removed once a new one has actually landed.

/// Grants access, or refuses to, without a Google account in sight.
class _StubAuthorization implements DriveAuthorization {
  bool granted = true;

  /// Whether asking the user would succeed. An automatic run never asks, so
  /// this stays out of reach unless something passes `interactive: true`.
  bool grantsOnPrompt = false;

  int prompts = 0;

  @override
  Future<Map<String, String>?> headers({bool interactive = false}) async {
    if (granted) return const {'Authorization': 'Bearer token'};
    if (interactive) {
      prompts++;
      if (grantsOnPrompt) {
        granted = true;
        return const {'Authorization': 'Bearer token'};
      }
    }
    return null;
  }
}

/// A Drive that remembers what it was told, so assertions can be about
/// behaviour rather than about which URL was formatted.
class _FakeDrive {
  final Map<String, Map<String, Object?>> files = {};
  final List<http.Request> requests = [];

  int _nextId = 1;
  int? failUploadsWith;
  int? failListWith;

  void seed({
    required String id,
    required DateTime createdAt,
    int schemaVersion = 21,
  }) {
    files[id] = {
      'id': id,
      'name': 'the-accountant-v$schemaVersion-$id.json',
      'size': '10',
      'createdTime': createdAt.toUtc().toIso8601String(),
      'appProperties': {'schemaVersion': '$schemaVersion'},
      'content': '{}',
    };
  }

  http.Client get client => MockClient((request) async {
    requests.add(request);
    final path = request.url.path;

    if (request.method == 'GET' && path.endsWith('/files')) {
      if (failListWith != null) {
        return http.Response('{"error":{"message":"nope"}}', failListWith!);
      }
      final listed = files.values
          .map((f) => {...f}..remove('content'))
          .toList();
      return http.Response(
        jsonEncode({'files': listed}),
        200,
        headers: {'content-type': 'application/json'},
      );
    }

    if (request.method == 'POST' && path.contains('/upload/drive/v3/files')) {
      if (failUploadsWith != null) {
        return http.Response(
          '{"error":{"message":"the disk is full"}}',
          failUploadsWith!,
        );
      }
      final parsed = _parseMultipart(request.body);
      final id = 'file-${_nextId++}';
      files[id] = {
        'id': id,
        'name': parsed.metadata['name'],
        'size': '${parsed.content.length}',
        'createdTime': DateTime.now().toUtc().toIso8601String(),
        'appProperties': parsed.metadata['appProperties'],
        'content': parsed.content,
        'parents': parsed.metadata['parents'],
      };
      return http.Response(
        jsonEncode({...files[id]!}..remove('content')),
        200,
        headers: {'content-type': 'application/json'},
      );
    }

    if (request.method == 'GET' && request.url.query.contains('alt=media')) {
      final id = path.split('/').last;
      final file = files[id];
      if (file == null) return http.Response('{}', 404);
      return http.Response.bytes(utf8.encode('${file['content']}'), 200);
    }

    if (request.method == 'DELETE') {
      final id = path.split('/').last;
      if (files.remove(id) == null) return http.Response('{}', 404);
      return http.Response('', 204);
    }

    return http.Response('{"error":{"message":"unhandled"}}', 400);
  });

  static ({Map<String, Object?> metadata, String content}) _parseMultipart(
    String body,
  ) {
    final parts = body
        .split(RegExp(r'--the-accountant-backup-boundary(--)?(\r\n)?'))
        .where((p) => p.trim().isNotEmpty)
        .toList();
    String payload(String part) =>
        part.split('\r\n\r\n').skip(1).join('\r\n\r\n').trimRight();
    return (
      metadata: jsonDecode(payload(parts[0])) as Map<String, Object?>,
      content: payload(parts[1]),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late _FakeDrive drive;
  late _StubAuthorization auth;
  late DriveBackupService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    drive = _FakeDrive();
    auth = _StubAuthorization();
    service = DriveBackupService(
      database: db,
      client: DriveBackupClient(authorization: auth, httpClient: drive.client),
    );
  });

  tearDown(() => db.close());

  group('taking a backup', () {
    test('it lands in the folder only this app can see', () async {
      await service.backupNow(device: 'Pixel 8');

      expect(drive.files, hasLength(1));
      expect(
        drive.files.values.single['parents'],
        ['appDataFolder'],
        reason:
            'the alternative scope would let this app read every document the '
            'person owns, which is far more than a backup needs',
      );
    });

    test('what went up is a backup that can be read back', () async {
      final wallet = await seedWallet(db, name: 'Everyday');
      await seedTransaction(db, walletId: wallet, amount: 2500);

      await service.backupNow();

      final stored = '${drive.files.values.single['content']}';
      final document = BackupDocument.decode(stored);
      expect(document.tables['transactions'], hasLength(1));
    });

    test('the schema version travels with it', () async {
      await service.backupNow();

      final listed = (await service.list()).single;
      expect(listed.schemaVersion, db.schemaVersion);
    });

    test('the file says which device and schema it came from', () {
      final name = DriveBackupService.fileNameFor(
        schemaVersion: 21,
        device: 'Pixel 8 Pro',
        at: DateTime(2026, 9, 3, 14, 25, 30),
      );

      expect(name, 'the-accountant-v21-pixel-8-pro-20260903-142530.json');
    });

    test('a device with nothing usable in its name still gets a file', () {
      final name = DriveBackupService.fileNameFor(
        schemaVersion: 21,
        device: '///',
        at: DateTime(2026, 9, 3, 14, 25, 30),
      );

      expect(name, 'the-accountant-v21-20260903-142530.json');
    });
  });

  group('keeping only so many', () {
    test('the oldest go once the count is exceeded', () async {
      for (var day = 1; day <= 6; day++) {
        drive.seed(id: 'old-$day', createdAt: DateTime(2026, 1, day));
      }

      final removed = await service.pruneTo(3);

      expect(removed, 3);
      expect(drive.files.keys, ['old-4', 'old-5', 'old-6']);
    });

    test('nothing goes when there is room', () async {
      drive.seed(id: 'a', createdAt: DateTime(2026, 1, 1));

      expect(await service.pruneTo(5), 0);
      expect(drive.files, hasLength(1));
    });

    test('a backup prunes to the retained count after it lands', () async {
      await service.writeSchedule(
        const BackupSchedule(frequency: BackupFrequency.daily, keep: 2),
      );
      for (var day = 1; day <= 3; day++) {
        drive.seed(id: 'old-$day', createdAt: DateTime(2026, 1, day));
      }

      await service.backupNow();

      expect(drive.files, hasLength(2));
      expect(
        drive.files.keys,
        contains('file-1'),
        reason: 'the copy just taken is the one most worth keeping',
      );
    });

    test('a failed upload costs the user nothing they already had', () async {
      await service.writeSchedule(
        const BackupSchedule(frequency: BackupFrequency.daily, keep: 1),
      );
      for (var day = 1; day <= 3; day++) {
        drive.seed(id: 'old-$day', createdAt: DateTime(2026, 1, day));
      }
      drive.failUploadsWith = 500;

      await expectLater(service.backupNow(), throwsA(isA<DriveException>()));

      expect(
        drive.files,
        hasLength(3),
        reason: 'pruning must happen after the new copy lands, never before',
      );
    });
  });

  group('restoring from Drive', () {
    test('the downloaded file becomes this device data', () async {
      final wallet = await seedWallet(db, name: 'Everyday');
      await seedTransaction(db, walletId: wallet, amount: 2500);
      final file = await service.backupNow();

      await db.customStatement('DELETE FROM transactions');
      final summary = await service.restoreFrom(file.id);

      expect(await db.getAllTransactions(), hasLength(1));
      expect(summary.isComplete, isTrue);
    });

    test('a file from a newer build is refused, not half-applied', () async {
      final wallet = await seedWallet(db, name: 'Everyday');
      await seedTransaction(db, walletId: wallet, amount: 2500);
      final file = await service.backupNow();

      // Exactly what a phone still on the old build would download.
      drive.files[file.id]!['content'] = jsonEncode({
        'format_version': BackupDocument.currentFormatVersion,
        'metadata': {
          'schema_version': db.schemaVersion + 5,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
        'tables': {'wallets': []},
      });

      await expectLater(
        service.restoreFrom(file.id),
        throwsA(isA<BackupFormatException>()),
      );
      expect(
        await db.getAllTransactions(),
        hasLength(1),
        reason: 'a refused restore must leave the device exactly as it was',
      );
    });

    test('a file too new to read is flagged before it is downloaded', () async {
      drive.seed(
        id: 'newer',
        createdAt: DateTime(2026, 1, 1),
        schemaVersion: db.schemaVersion + 1,
      );

      final listed = (await service.list()).single;

      expect(service.whyUnrestorable(listed), contains('newer version'));
      expect(
        drive.requests.where((r) => r.url.query.contains('alt=media')),
        isEmpty,
      );
    });

    test('a file this build can read is not flagged', () async {
      drive.seed(id: 'fine', createdAt: DateTime(2026, 1, 1));

      expect(service.whyUnrestorable((await service.list()).single), isNull);
    });
  });

  group('the automatic run', () {
    test('nothing happens before the interval is up', () async {
      await service.writeSchedule(
        BackupSchedule(
          frequency: BackupFrequency.weekly,
          lastBackupAt: DateTime(2026, 1, 1),
        ),
      );

      expect(
        await service.runAutomaticIfDue(now: DateTime(2026, 1, 5)),
        isFalse,
      );
      expect(drive.requests, isEmpty);
    });

    test('it runs once the interval is up', () async {
      await service.writeSchedule(
        BackupSchedule(
          frequency: BackupFrequency.weekly,
          lastBackupAt: DateTime(2026, 1, 1),
        ),
      );

      expect(
        await service.runAutomaticIfDue(now: DateTime(2026, 1, 9)),
        isTrue,
      );
      expect(drive.files, hasLength(1));
    });

    test('turning it on backs up straight away', () async {
      await service.writeSchedule(
        const BackupSchedule(frequency: BackupFrequency.daily),
      );

      expect(await service.runAutomaticIfDue(), isTrue);
    });

    test('"only when I ask" never runs on its own', () async {
      await service.writeSchedule(
        const BackupSchedule(frequency: BackupFrequency.manual),
      );

      expect(await service.runAutomaticIfDue(), isFalse);
      expect(drive.requests, isEmpty);
    });

    test('a lapsed permission is recorded, never prompted for', () async {
      auth.granted = false;
      auth.grantsOnPrompt = true;
      await service.writeSchedule(
        const BackupSchedule(frequency: BackupFrequency.daily),
      );

      expect(await service.runAutomaticIfDue(), isFalse);
      expect(
        auth.prompts,
        0,
        reason:
            'throwing a Google consent screen at somebody who has just opened '
            'their finance app is not a reasonable way to ask',
      );
      expect(
        (await service.readSchedule()).lastFailure,
        contains('not allowed'),
      );
    });

    test('a run that fails does not move the clock forward', () async {
      drive.failUploadsWith = 500;
      await service.writeSchedule(
        BackupSchedule(
          frequency: BackupFrequency.daily,
          lastBackupAt: DateTime(2026, 1, 1),
        ),
      );

      await service.runAutomaticIfDue(now: DateTime(2026, 2, 1));

      final schedule = await service.readSchedule();
      expect(schedule.lastBackupAt, DateTime(2026, 1, 1));
      expect(
        schedule.isDue(DateTime(2026, 2, 1)),
        isTrue,
        reason: 'a failure must leave the next attempt owed, not satisfied',
      );
    });

    test('a successful run clears the last failure', () async {
      await service.writeSchedule(
        const BackupSchedule(
          frequency: BackupFrequency.daily,
          lastFailure: 'something went wrong before',
        ),
      );

      await service.runAutomaticIfDue();

      expect((await service.readSchedule()).lastFailure, isNull);
    });
  });

  group('when Drive says no', () {
    test('a refusal to authorize says the fix is to grant access', () async {
      auth.granted = false;

      await expectLater(
        service.list(),
        throwsA(
          isA<DriveException>().having(
            (e) => e.needsAuthorization,
            'needsAuthorization',
            isTrue,
          ),
        ),
      );
      expect(drive.requests, isEmpty);
    });

    test('a 401 from Drive itself says the same', () async {
      drive.failListWith = 401;

      await expectLater(
        service.list(),
        throwsA(
          isA<DriveException>().having(
            (e) => e.needsAuthorization,
            'needsAuthorization',
            isTrue,
          ),
        ),
      );
    });

    test('another failure carries the reason Drive gave', () async {
      drive.failUploadsWith = 507;

      await expectLater(
        service.backupNow(),
        throwsA(
          isA<DriveException>().having(
            (e) => e.message,
            'message',
            contains('the disk is full'),
          ),
        ),
      );
    });

    test('one stuck file does not stop the rest being pruned', () async {
      for (var day = 1; day <= 4; day++) {
        drive.seed(id: 'old-$day', createdAt: DateTime(2026, 1, day));
      }
      // Gone from under us between the listing and the delete.
      drive.files.remove('old-1');

      expect(await service.pruneTo(2), 1);
      expect(drive.files.keys, ['old-3', 'old-4']);
    });
  });

  group('the schedule itself', () {
    test('it survives being written and read back', () async {
      await service.writeSchedule(
        BackupSchedule(
          frequency: BackupFrequency.monthly,
          keep: 20,
          lastBackupAt: DateTime(2026, 5, 4, 3, 2, 1),
        ),
      );

      final schedule = await service.readSchedule();
      expect(schedule.frequency, BackupFrequency.monthly);
      expect(schedule.keep, 20);
      expect(schedule.lastBackupAt, DateTime(2026, 5, 4, 3, 2, 1));
    });

    test('an unreadable stored frequency falls back to manual', () async {
      SharedPreferences.setMockInitialValues({
        'drive_backup_frequency': 'fortnightly-ish',
      });

      expect(
        (await service.readSchedule()).frequency,
        BackupFrequency.manual,
        reason: 'the safe default is to do nothing without being asked',
      );
    });

    test('the next due time is the last run plus the interval', () {
      const schedule = BackupSchedule(frequency: BackupFrequency.weekly);

      expect(schedule.nextDueAt(), isNull);
      expect(
        schedule.copyWith(lastBackupAt: DateTime(2026, 1, 1)).nextDueAt(),
        DateTime(2026, 1, 8),
      );
    });
  });
}
