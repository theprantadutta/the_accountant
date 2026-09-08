import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';

import 'fake_sync_server.dart';

/// Runs `test/contracts/push-contract.json` against [FakeSyncServer].
///
/// Almost every sync test in this suite measures against the fake rather than
/// against the server it stands in for, and the fake drifted from it four
/// separate times: applying nothing on a create for a row it already held after
/// the handler had learned to apply content; applying content for every table
/// after the handler had learned to do it only for transactions; conflicting on
/// a stale create where the handler acknowledges; and conflicting on a delete
/// for a row it does not hold. Every one was found by a person reading both
/// implementations, never by a test, and each time a fully green suite here
/// meant nothing at all.
///
/// The same file — byte for byte — is run against the real handler by the
/// backend's `PushContractFixtureTests`. A copy lives in each repository
/// because they are separate repositories, and [_expectedVersion] is what keeps
/// the copies honest: changing the contract means bumping the version in the
/// JSON, which fails this test until the constant is raised here, and fails the
/// backend until its copy and its constant are updated too.
///
/// What this does and does not give: the two suites now agree by construction
/// on every case in the file. Nothing outside those cases is checked, and a
/// behaviour neither side has thought to write down is still unguarded.
void main() {
  /// The contract version this suite has been updated for.
  const expectedVersion = 1;

  final fixture = File('test/contracts/push-contract.json');

  Map<String, dynamic> load() =>
      jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;

  test('the fixture is where both suites expect it', () {
    expect(
      fixture.existsSync(),
      isTrue,
      reason: 'the backend runs the same file from contracts/push-contract.json',
    );
  });

  test('the fixture is the version this suite was written for', () {
    // Bumping the version in the JSON is what forces the backend's copy to be
    // updated too. If this fails, the contract changed and this side has not
    // caught up.
    expect(load()['version'], expectedVersion);
  });

  test('every case holds against the fake', () {
    final cases = (load()['cases'] as List).cast<Map<String, dynamic>>();
    expect(cases, isNotEmpty);

    for (final testCase in cases) {
      final name = testCase['name'] as String;
      final server = FakeSyncServer();
      const userId = 'contract-user';

      SyncChange toChange(Map<String, dynamic> raw) => SyncChange(
        tableName: raw['table'] as String,
        entityId: raw['id'] as String,
        operation: raw['operation'] as String,
        data: (raw['data'] as Map?)?.cast<String, dynamic>(),
      );

      // Set-up goes through the same push path, so the fixture needs no
      // separate seeding language and both runners establish state identically.
      for (final given in (testCase['given'] as List).cast<Map<String, dynamic>>()) {
        final setup = server.push(userId, [toChange(given)]);
        expect(setup.conflicts, isEmpty, reason: '[$name] setup push conflicted');
      }

      final push = testCase['push'] as Map<String, dynamic>;
      final result = server.push(userId, [toChange(push)]);
      final expected = testCase['expect'] as Map<String, dynamic>;

      expect(
        result.conflicts.length,
        expected['conflicts'],
        reason: '[$name] conflict count',
      );
      expect(
        result.appliedCount,
        expected['applied'],
        reason: '[$name] applied count',
      );

      final table = push['table'] as String;
      final id = push['id'] as String;

      if (expected['deleted'] case final bool wantDeleted) {
        expect(
          server.isTombstoned(userId, table, id),
          wantDeleted,
          reason: '[$name] tombstone state',
        );
      }

      if (expected['stored'] case final Map<String, dynamic> wantStored) {
        final stored = server.recordData(userId, table, id);
        expect(stored, isNotNull, reason: '[$name] nothing stored to check');
        for (final entry in wantStored.entries) {
          expect(
            stored![entry.key].toString(),
            entry.value.toString(),
            reason: '[$name] stored ${entry.key}',
          );
        }
      }
    }
  });
}
