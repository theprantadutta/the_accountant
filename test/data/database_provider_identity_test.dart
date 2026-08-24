import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/category_reconciliation_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// Everything must read the account's database through one provider.
///
/// There used to be two `databaseProvider` definitions in the tree. `main()`
/// overrides one of them; the other quietly called `constructDb()` and handed
/// back a brand-new connection to the legacy `db.sqlite`.
///
/// A service wired to the wrong one therefore did two bad things at once. It
/// opened a second connection to a file the app already had open — which is
/// what drift's "created the database class multiple times" warning was
/// reporting, and what risks the writes racing. And it ignored the per-account
/// store completely, so while a signed-in user was working in
/// `db_<userId>.sqlite`, that service was reading and writing the shared legacy
/// file instead. Per-account isolation exists precisely so that cannot happen.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  test('the reconciliation service uses the overridden database', () async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    // Written through the database the test owns...
    await db.recordCategoryReconciliation(
      defaultKey: 'groceries',
      provisionalCategoryId: 'provisional-1',
      catalogName: 'Groceries',
      catalogIsIncome: false,
      candidatesJson: '[]',
    );

    // ...and read back through the service. If the service resolved a
    // different provider it would open its own connection to the default file
    // and see nothing at all.
    final pending = await container
        .read(categoryReconciliationServiceProvider)
        .list();

    expect(
      pending,
      hasLength(1),
      reason: 'the service must read the same database the app overrode',
    );
    expect(pending.single.defaultKey, 'groceries');
  });
}
