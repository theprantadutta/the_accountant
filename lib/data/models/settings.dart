import 'package:drift/drift.dart';

class Settings extends Table {
  IntColumn get id => integer().customConstraint('NOT NULL DEFAULT 1')();
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get budgetNotificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  RealColumn get budgetWarningThreshold =>
      real().withDefault(const Constant(80.0))();

  // Regional settings
  TextColumn get dateFormat =>
      text().withDefault(const Constant('MM/dd/yyyy'))();
  TextColumn get numberFormat =>
      text().withDefault(const Constant('comma_dot'))();

  // Security settings
  BoolColumn get biometricLockEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get autoLockTimeoutMinutes =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
