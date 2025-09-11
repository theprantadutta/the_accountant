import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

AppDatabase constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    return AppDatabase(
      LazyDatabase(() async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'db.sqlite'));
        return NativeDatabase.createInBackground(
          file,
          logStatements: logStatements,
        );
      }),
    );
  } else if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    return AppDatabase(
      LazyDatabase(() async {
        final file = File('db.sqlite');
        return NativeDatabase.createInBackground(
          file,
          logStatements: logStatements,
        );
      }),
    );
  }
  // Fallback for other platforms
  return AppDatabase(
    LazyDatabase(() async {
      final file = File('db.sqlite');
      return NativeDatabase.createInBackground(
        file,
        logStatements: logStatements,
      );
    }),
  );
}

final databaseProvider = Provider<AppDatabase>((ref) {
  return constructDb();
});
