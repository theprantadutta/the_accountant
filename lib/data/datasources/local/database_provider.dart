import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
      );
    }),
  );
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
