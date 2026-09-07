import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// Naming rules: "anything called Tesco is Groceries".
///
/// They were stored, edited, listed and synced, and nothing ever read one. The
/// add-transaction form suggested categories from transaction history alone, so
/// a rule the user wrote could not change anything the app did — which is the
/// whole of what a rule is for.
void main() {
  late AppDatabase db;
  late String groceries;
  late String fuel;

  setUp(() async {
    db = openTestDatabase();
    groceries = await seedCategory(db, name: 'Groceries');
    fuel = await seedCategory(db, name: 'Fuel');
  });

  tearDown(() => db.close());

  group('what a rule files a title under', () {
    test('an exact rule matches its own title', () async {
      await db.setAssociatedTitle(
        title: 'Tesco',
        categoryId: groceries,
        isExactMatch: true,
      );

      expect(await db.categoryForTitle('Tesco'), groceries);
    });

    test('matching ignores case and surrounding space', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);

      expect(await db.categoryForTitle('  tesco '), groceries);
    });

    test('a containing rule matches a longer title', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);

      expect(await db.categoryForTitle('Tesco Express Holborn'), groceries);
    });

    test('an exact rule does not match a longer title', () async {
      await db.setAssociatedTitle(
        title: 'Tesco',
        categoryId: groceries,
        isExactMatch: true,
      );

      expect(await db.categoryForTitle('Tesco Express'), isNull);
    });

    test('the more specific rule wins', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);
      await db.setAssociatedTitle(title: 'Tesco Petrol', categoryId: fuel);

      expect(
        await db.categoryForTitle('Tesco Petrol Station'),
        fuel,
        reason: 'both rules match, and the longer one is the more deliberate '
            'statement of what the user meant',
      );
    });

    test('a title nothing matches gets nothing', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);

      expect(await db.categoryForTitle('Corner shop'), isNull);
    });

    test('a deleted rule stops applying', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);
      final rule = (await db.getAllAssociatedTitles()).single;

      await db.deleteAssociatedTitle(rule.id);

      expect(await db.categoryForTitle('Tesco'), isNull);
    });
  });

  group('editing a rule', () {
    test('renaming it changes the rule rather than adding one', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);
      final rule = (await db.getAllAssociatedTitles()).single;

      await db.setAssociatedTitle(
        id: rule.id,
        title: 'Tesco Express',
        categoryId: groceries,
      );

      final rules = await db.getAllAssociatedTitles();
      expect(
        rules,
        hasLength(1),
        reason: 'upserting on the title matched nothing once the title was '
            'what had changed, so the old rule stayed behind contradicting '
            'the new one and the edit looked like it had not saved',
      );
      expect(rules.single.title, 'Tesco Express');
      expect(rules.single.id, rule.id);
    });

    test('teaching the app the same title twice is a correction', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);

      await db.setAssociatedTitle(title: 'tesco', categoryId: fuel);

      final rules = await db.getAllAssociatedTitles();
      expect(rules, hasLength(1));
      expect(rules.single.categoryId, fuel);
    });

    test('an edited rule is marked for pushing', () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: groceries);
      await db.customStatement('UPDATE associated_titles SET sync_status = ?', [
        SyncStatus.synced,
      ]);
      final rule = (await db.getAllAssociatedTitles()).single;

      await db.setAssociatedTitle(
        id: rule.id,
        title: 'Tesco Express',
        categoryId: groceries,
      );

      expect(
        (await db.getAllAssociatedTitles()).single.syncStatus,
        SyncStatus.pendingUpdate,
      );
    });
  });
}
