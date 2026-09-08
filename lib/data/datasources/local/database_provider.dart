import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Default database file name (the pre-multi-account store).
const String kDefaultDatabaseFile = 'db.sqlite';

/// Absolute path of the store file [fileName] on this platform.
///
/// Mobile keeps databases in the app documents directory; desktop uses the
/// working directory, matching the app's previous behaviour.
Future<String> resolveStorePath(String fileName) async {
  if (Platform.isIOS || Platform.isAndroid) {
    final dbFolder = await getApplicationDocumentsDirectory();
    return p.join(dbFolder.path, fileName);
  }
  return fileName;
}

/// Open the database stored in [fileName].
///
/// The file name is a parameter (rather than a constant) so the app can hold a
/// *separate* database per authenticated account — see [LocalStoreManager].
AppDatabase constructDbForFile(String fileName, {bool logStatements = false}) {
  return AppDatabase(
    LazyDatabase(() async {
      final path = await resolveStorePath(fileName);
      return NativeDatabase.createInBackground(
        File(path),
        logStatements: logStatements,
        setup: applyStorePragmas,
      );
    }),
  );
}

/// Settings every connection to a store needs, whichever isolate opened it.
///
/// **Three isolates open the same file.** The app holds one; the WorkManager
/// periodic task opens its own, because a background callback has no Riverpod
/// state to borrow one from; and the notification action handler opens a third.
/// That is by design — they must all write to the account's real store — but it
/// means an ordinary SQLite lock conflict is not a rare event, it is a Tuesday.
///
/// SQLite's default busy handler does not wait at all: a writer that finds the
/// database locked fails immediately with `SqliteException(5): database is
/// locked`. With three writers and no timeout, the app could fail to open
/// simply because a background task happened to be a few milliseconds ahead of
/// it — which is exactly what a user saw, as a startup error screen with their
/// data perfectly intact behind it.
///
/// Five seconds is far longer than any write here takes (the background work is
/// a handful of statements) and far shorter than a user would wait before
/// deciding the app has hung.
void applyStorePragmas(CommonDatabase database) {
  database.execute('PRAGMA busy_timeout = 5000;');
}

AppDatabase constructDb({bool logStatements = false}) =>
    constructDbForFile(kDefaultDatabaseFile, logStatements: logStatements);

/// The database for the account whose session is currently active.
///
/// Overridden at startup in `main()` with the store resolved from the persisted
/// session, and re-pointed by [AccountStoreCoordinator] whenever the
/// authenticated identity changes — which tears down and rebuilds every
/// provider that watches it, so no screen can keep serving the previous
/// account's rows.
final databaseProvider = Provider<AppDatabase>((ref) {
  return constructDb();
});
