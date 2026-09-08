import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

import '../helpers/test_database.dart';

/// Opening a store while something else is writing to it.
///
/// Three isolates open the same file. The app holds one; the WorkManager
/// periodic task opens its own, because a background callback has no Riverpod
/// state to borrow one from; and the notification action handler opens a third.
/// They all have to write to the account's real store, so a lock conflict is
/// not a rare event.
///
/// SQLite's default busy handler does not wait — a writer that finds the
/// database locked fails immediately with `SqliteException(5): database is
/// locked`. With `beforeOpen` re-asserting three dozen triggers and running a
/// repair on every single open, that collision was reachable just by launching
/// the app while a background task happened to be a few milliseconds ahead of
/// it. The user saw a startup error screen with their data perfectly intact
/// behind it.
void main() {
  late Directory dir;
  late File file;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('accountant-locking-');
    file = File('${dir.path}/db.sqlite');
  });

  tearDown(() async {
    if (await file.exists()) await file.delete();
    for (final suffix in const ['-wal', '-shm']) {
      final extra = File('${file.path}$suffix');
      if (await extra.exists()) await extra.delete();
    }
    await dir.delete(recursive: true);
  });

  /// A second connection, standing in for the background isolate.
  Database openCompetingWriter() {
    final other = sqlite3.open(file.path);
    applyStorePragmas(other);
    return other;
  }

  /// Bring the store into existence and let it finish setting itself up.
  Future<void> initialiseStore() async {
    final db = AppDatabase(NativeDatabase(file, setup: applyStorePragmas));
    await db.ensureSystemCategoriesExist();
    await db.close();
  }

  test('a settled store opens with no write lock at all', () async {
    await initialiseStore();

    final competitor = openCompetingWriter();
    // Held for the whole of the open below: a background task mid-write.
    competitor.execute('BEGIN IMMEDIATE;');

    try {
      final db = AppDatabase(
        NativeDatabase.createInBackground(file, setup: applyStorePragmas),
      );
      addTearDown(db.close);

      // Anything at all is enough — the first query is what runs `beforeOpen`.
      await expectLater(db.getAllWallets(), completion(isEmpty));
    } finally {
      competitor.execute('ROLLBACK;');
      competitor.close();
    }
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('a store with repairs to make waits rather than failing', () async {
    await initialiseStore();

    // Give it something that genuinely needs a write on open.
    final seed = AppDatabase(NativeDatabase(file, setup: applyStorePragmas));
    final budget = await seedBudget(seed);
    final category = await seedCategory(seed);
    await seed.customStatement('DROP INDEX idx_category_budget_limits_pair');
    for (final (id, amount, updated) in [
      ('older', 5000, 100),
      ('newer', 8000, 200),
    ]) {
      await seed.customStatement(
        'INSERT INTO category_budget_limits (id, budget_id, category_id, '
        'amount, is_percent, sync_status, created_at, updated_at) '
        'VALUES (?, ?, ?, ?, 0, ?, 1, ?)',
        [id, budget, category, amount, SyncStatus.synced, updated],
      );
    }
    await seed.close();

    final competitor = openCompetingWriter();
    competitor.execute('BEGIN IMMEDIATE;');

    // Released while the opening connection is waiting on it, which is what a
    // real background task does — it finishes.
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 400), () {
        competitor.execute('ROLLBACK;');
      }),
    );

    // In a background isolate, exactly as the app opens it. A synchronous
    // connection would block this isolate while it waited, and the timer above
    // could never fire — the wait has to happen somewhere the app is not.
    final db = AppDatabase(
      NativeDatabase.createInBackground(file, setup: applyStorePragmas),
    );
    addTearDown(() async {
      await db.close();
      competitor.close();
    });

    // Without a busy timeout this throws SqliteException(5) the instant it
    // finds the lock, and the app shows a startup error instead of the ledger.
    await expectLater(db.getAllWallets(), completion(isEmpty));
    expect(
      (await db.getCategoryLimitsForBudget(budget)).single.amount,
      8000,
      reason: 'and it still did the repair it opened to do',
    );
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('the pragmas are applied to every connection the app opens', () async {
    final db = sqlite3.open(file.path);
    addTearDown(db.close);

    applyStorePragmas(db);

    final timeout = db.select('PRAGMA busy_timeout;').first.values.first;
    expect(
      timeout,
      greaterThan(0),
      reason: 'the default is no wait at all, which is what turned an ordinary '
          'lock conflict into a failed launch',
    );
  });
}
