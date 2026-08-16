import 'dart:async';

import 'package:drift/drift.dart';

/// Suite-wide test configuration. `flutter_test` loads this automatically.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Drift warns whenever more than one AppDatabase instance is constructed,
  // because two instances sharing ONE QueryExecutor can race and corrupt the
  // file. That is not what happens here: the two-device tests deliberately build
  // two databases, each over its own `NativeDatabase.memory()` executor, which
  // are separate SQLite connections with no shared state at all. `assertStoresAreIndependent`
  // in `helpers/test_database.dart` proves that property directly, and the
  // two-device suite asserts it before it starts.
  //
  // The warning is therefore a false positive here, and it is silenced rather
  // than left to imply a race risk that does not exist.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  await testMain();
}
