import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Rules that file a transaction by what it is called.
///
/// The table, the matching and the backend endpoints all existed, and nothing
/// let anyone see or change a rule — so the app could learn "Tesco means
/// Groceries" and there was no way to correct it when it learned wrong. They
/// were device-local too, so a reinstall threw away everything the user had
/// taught it.
void main() {
  late AppDatabase db;
  late String food;
  late String travel;

  setUp(() async {
    db = openTestDatabase();
    food = await seedCategory(db, name: 'Groceries');
    travel = await seedCategory(db, name: 'Travel');
  });

  tearDown(() => db.close());

  test('a rule is stored and read back', () async {
    await db.setAssociatedTitle(title: 'Tesco', categoryId: food);

    final rules = await db.getAllAssociatedTitles();
    expect(rules, hasLength(1));
    expect(rules.single.title, 'Tesco');
    expect(rules.single.categoryId, food);
    expect(
      rules.single.isExactMatch,
      isFalse,
      reason:
          'titles carry noise — a card reference, a branch — so a rule that '
          'only fires on an exact repeat would almost never fire',
    );
  });

  test(
    'teaching the same title twice corrects it rather than duplicating',
    () async {
      await db.setAssociatedTitle(title: 'Tesco', categoryId: food);
      await db.setAssociatedTitle(title: 'Tesco', categoryId: travel);

      final rules = await db.getAllAssociatedTitles();
      expect(rules, hasLength(1));
      expect(
        rules.single.categoryId,
        travel,
        reason:
            'the second answer is a correction, not a contradiction to keep',
      );
    },
  );

  test('matching ignores case when correcting a rule', () async {
    await db.setAssociatedTitle(title: 'Tesco', categoryId: food);
    await db.setAssociatedTitle(title: 'TESCO', categoryId: travel);

    expect(await db.getAllAssociatedTitles(), hasLength(1));
  });

  test('a blank title is not a rule', () async {
    await db.setAssociatedTitle(title: '   ', categoryId: food);
    expect(await db.getAllAssociatedTitles(), isEmpty);
  });

  test('deleting leaves a tombstone rather than removing the row', () async {
    await db.setAssociatedTitle(title: 'Tesco', categoryId: food);
    final rule = (await db.getAllAssociatedTitles()).single;

    await db.deleteAssociatedTitle(rule.id);

    expect(await db.getAllAssociatedTitles(), isEmpty);
    final row = await db.findAssociatedTitleById(rule.id);
    expect(
      row!.deletedAt,
      isNotNull,
      reason:
          'hard-deleting gives the other devices no way to learn the rule is '
          'gone, so it would come straight back on the next pull',
    );
    expect(row.syncStatus, SyncStatus.pendingDelete);
  });

  test('a deleted rule stops matching', () async {
    await db.setAssociatedTitle(
      title: 'Tesco',
      categoryId: food,
      isExactMatch: true,
    );
    final rule = (await db.getAllAssociatedTitles()).single;
    await db.deleteAssociatedTitle(rule.id);

    expect(await db.findExactTitleMatch('tesco'), isNull);
    expect(await db.findContainsTitleMatches(), isEmpty);
  });

  group('reaching another device', () {
    late FakeSyncServer server;
    const user = 'user-a';

    setUp(() async {
      server = FakeSyncServer();
      await db.claimLocalStore(userId: user);
    });

    test('a rule travels, and so does deleting it', () async {
      final other = openTestDatabase();
      addTearDown(other.close);
      await other.claimLocalStore(userId: user);

      await db.setAssociatedTitle(title: 'Tesco', categoryId: food);

      final pushed = await SyncService(
        database: db,
        transport: FakeSyncTransport(server: server, userId: user),
      ).syncAll();
      expect(pushed.conflicts, isEmpty);

      final pulled = await SyncService(
        database: other,
        transport: FakeSyncTransport(server: server, userId: user),
      ).syncAll();
      expect(pulled.applyFailures, isEmpty);

      final landed = await other.getAllAssociatedTitles();
      expect(
        landed,
        hasLength(1),
        reason:
            'someone who has taught the app how they shop should not lose it '
            'on a reinstall',
      );
      expect(landed.single.title, 'Tesco');
      expect(landed.single.categoryId, food);
    });
  });
}
