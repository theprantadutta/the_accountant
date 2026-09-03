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

  /// Where the currency symbol goes: `before` (¤1.00) or `after` (1,00 €).
  ///
  /// Defaults to before, which is what every amount in the app did when there
  /// was no choice. Roughly half of Europe writes it the other way round.
  TextColumn get symbolPosition =>
      text().withDefault(const Constant('before'))();

  /// `system`, `12` or `24`.
  ///
  /// System means whatever the phone is set to, which is what most people
  /// expect and nobody had a way to get before.
  TextColumn get timeFormat => text().withDefault(const Constant('system'))();

  /// 0 to follow the phone, otherwise 1 (Monday) through 7 (Sunday), matching
  /// [DateTime.monday] and friends.
  IntColumn get firstDayOfWeek => integer().withDefault(const Constant(0))();

  // Security settings
  BoolColumn get biometricLockEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get autoLockTimeoutMinutes =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
