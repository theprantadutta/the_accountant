import 'package:drift/drift.dart';

class Settings extends Table {
  IntColumn get id =>
      integer().customConstraint('NOT NULL PRIMARY KEY DEFAULT 1')();
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get budgetNotificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  RealColumn get budgetWarningThreshold =>
      real().withDefault(const Constant(80.0))();

  @override
  Set<Column> get primaryKey => {id};
}
