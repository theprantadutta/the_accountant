import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';

import '../helpers/test_database.dart';

/// Create a config whose next occurrence is already due.
Future<String> seedDueConfig(
  AppDatabase db, {
  required String baseTransactionId,
  required DateTime nextOccurrence,
  String reoccurrence = 'monthly',
  int periodLength = 1,
  DateTime? endDate,
}) async {
  final id = 'config-${DateTime.now().microsecondsSinceEpoch}';
  final now = DateTime.now();
  await db.addRecurringConfig(
    RecurringConfigsCompanion(
      id: Value(id),
      baseTransactionId: Value(baseTransactionId),
      periodLength: Value(periodLength),
      reoccurrence: Value(reoccurrence),
      startDate: Value(nextOccurrence),
      endDate: Value(endDate),
      nextOccurrence: Value(nextOccurrence),
      isActive: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value(SyncStatus.pendingCreate),
    ),
  );
  return id;
}

/// Simulate the server acknowledging this config, the way a successful push does.
Future<void> markConfigSynced(AppDatabase db, String configId) async {
  await (db.update(
    db.recurringConfigs,
  )..where((r) => r.id.equals(configId))).write(
    const RecurringConfigsCompanion(syncStatus: Value(SyncStatus.synced)),
  );
}

void main() {
  group('occurrence keys', () {
    test('are deterministic across devices and time zones', () {
      final a = RecurringService.occurrenceKeyFor(
        'cfg-1',
        DateTime.utc(2026, 5, 17, 6),
      );
      final b = RecurringService.occurrenceKeyFor(
        'cfg-1',
        DateTime.utc(2026, 5, 17, 6).toLocal(),
      );
      expect(a, b);
      expect(a, 'cfg-1@2026-05-17');
    });

    test('differ per config and per scheduled day', () {
      expect(
        RecurringService.occurrenceKeyFor('a', DateTime.utc(2026, 5, 17)),
        isNot(
          RecurringService.occurrenceKeyFor('b', DateTime.utc(2026, 5, 17)),
        ),
      );
      expect(
        RecurringService.occurrenceKeyFor('a', DateTime.utc(2026, 5, 17)),
        isNot(
          RecurringService.occurrenceKeyFor('a', DateTime.utc(2026, 5, 18)),
        ),
      );
    });
  });

  group('generation', () {
    late AppDatabase db;
    late RecurringService service;
    late String walletId;
    late String baseId;

    setUp(() async {
      db = openTestDatabase();
      service = RecurringService(database: db);
      walletId = await seedWallet(db, openingBalance: 100000);
      baseId = await seedTransaction(
        db,
        walletId: walletId,
        amount: 1500,
        title: 'Streaming',
      );
    });

    tearDown(() => db.close());

    test('creates one instance per due date and advances the cursor', () async {
      final configId = await seedDueConfig(
        db,
        baseTransactionId: baseId,
        nextOccurrence: DateTime.now().subtract(const Duration(days: 65)),
      );

      final processed = await service.processRecurringTransactions();

      expect(processed, greaterThanOrEqualTo(2));
      final instances = await db.getRecurringInstances(configId);
      expect(instances, hasLength(processed));
      // Every generated row carries a deterministic key.
      expect(instances.every((t) => t.occurrenceKey != null), isTrue);
      // Keys are unique.
      expect(
        instances.map((t) => t.occurrenceKey).toSet(),
        hasLength(instances.length),
      );

      final config = await db.findRecurringConfigById(configId);
      expect(config!.nextOccurrence.isAfter(DateTime.now()), isTrue);
    });

    test('re-processing does not duplicate occurrences', () async {
      final configId = await seedDueConfig(
        db,
        baseTransactionId: baseId,
        nextOccurrence: DateTime.now().subtract(const Duration(days: 40)),
      );

      await service.processRecurringTransactions();
      final firstCount = (await db.getRecurringInstances(configId)).length;

      // Rewind the cursor the way an interrupted run or a stale pull would.
      await db.updateNextOccurrence(
        configId,
        DateTime.now().subtract(const Duration(days: 40)),
        true,
      );
      await service.processRecurringTransactions();

      expect(await db.getRecurringInstances(configId), hasLength(firstCount));
    });

    test(
      'a duplicate from another device is rejected by the unique key',
      () async {
        final configId = await seedDueConfig(
          db,
          baseTransactionId: baseId,
          nextOccurrence: DateTime.now().subtract(const Duration(days: 5)),
        );
        await service.processRecurringTransactions();

        final existing = (await db.getRecurringInstances(configId)).first;

        // Device B generated the SAME occurrence with its own row id.
        await expectLater(
          seedTransaction(
            db,
            walletId: walletId,
            recurringConfigId: configId,
            occurrenceKey: existing.occurrenceKey,
          ),
          throwsA(anything),
          reason:
              'the unique index must reject a second copy of one occurrence',
        );
      },
    );

    test('the generated balance effect matches a full recomputation', () async {
      await seedDueConfig(
        db,
        baseTransactionId: baseId,
        nextOccurrence: DateTime.now().subtract(const Duration(days: 70)),
      );

      await service.processRecurringTransactions();

      final stored = (await db.findWalletById(walletId))!.balance;
      final recomputed = await WalletBalanceService(
        db,
      ).calculateWalletBalance(walletId);
      expect(stored, recomputed);
    });

    test('stops at the end date and deactivates the config', () async {
      final configId = await seedDueConfig(
        db,
        baseTransactionId: baseId,
        reoccurrence: 'daily',
        nextOccurrence: DateTime.now().subtract(const Duration(days: 3)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      await service.processRecurringTransactions();

      final config = await db.findRecurringConfigById(configId);
      expect(config!.isActive, isFalse);
    });
  });

  group('cancellation', () {
    late AppDatabase db;
    late RecurringService service;

    setUp(() async {
      db = openTestDatabase();
      service = RecurringService(database: db);
    });
    tearDown(() => db.close());

    test('is a syncable tombstone, not a local hard delete', () async {
      final walletId = await seedWallet(db);
      final baseId = await seedTransaction(db, walletId: walletId);
      final configId = await seedDueConfig(
        db,
        baseTransactionId: baseId,
        nextOccurrence: DateTime.now().add(const Duration(days: 30)),
      );
      // Pretend it has already been pushed once.
      await markConfigSynced(db, configId);

      await service.deleteRecurringConfig(configId);

      final config = await db.findRecurringConfigById(configId);
      expect(
        config,
        isNotNull,
        reason: 'the row must survive so the deletion can be pushed',
      );
      expect(config!.isActive, isFalse);
      expect(config.syncStatus, SyncStatus.pendingDelete);
    });

    test('cancelling stops further generation', () async {
      final walletId = await seedWallet(db);
      final baseId = await seedTransaction(db, walletId: walletId);
      final configId = await seedDueConfig(
        db,
        baseTransactionId: baseId,
        nextOccurrence: DateTime.now().subtract(const Duration(days: 10)),
      );

      await service.deleteRecurringConfig(configId);
      final processed = await service.processRecurringTransactions();

      expect(processed, 0);
      expect(await db.getRecurringInstances(configId), isEmpty);
    });

    test(
      'the tombstone is only purged after the server acknowledges',
      () async {
        final walletId = await seedWallet(db);
        final baseId = await seedTransaction(db, walletId: walletId);
        final configId = await seedDueConfig(
          db,
          baseTransactionId: baseId,
          nextOccurrence: DateTime.now().add(const Duration(days: 1)),
        );
        await service.deleteRecurringConfig(configId);

        // Not yet acknowledged: purging must be a no-op.
        await service.purgeAcknowledgedCancellation(configId);
        expect(await db.findRecurringConfigById(configId), isNotNull);

        // Acknowledged by the server.
        await markConfigSynced(db, configId);
        await service.purgeAcknowledgedCancellation(configId);
        expect(await db.findRecurringConfigById(configId), isNull);
      },
    );
  });

  group('end date tri-state', () {
    late AppDatabase db;
    late RecurringService service;

    setUp(
      () => {db = openTestDatabase(), service = RecurringService(database: db)},
    );
    tearDown(() => db.close());

    test('omitting keeps, null clears, a value sets', () async {
      final walletId = await seedWallet(db);
      final baseId = await seedTransaction(db, walletId: walletId);
      final end = DateTime(2027, 1, 1);
      final configId = await seedDueConfig(
        db,
        baseTransactionId: baseId,
        nextOccurrence: DateTime.now().add(const Duration(days: 1)),
        endDate: end,
      );

      // Omitted -> unchanged.
      await service.updateRecurringConfig(configId: configId, periodLength: 2);
      expect((await db.findRecurringConfigById(configId))!.endDate, end);

      // Explicit null -> cleared (repeat forever).
      await service.updateRecurringConfig(configId: configId, endDate: null);
      expect((await db.findRecurringConfigById(configId))!.endDate, isNull);

      // Explicit value -> set.
      final newEnd = DateTime(2028, 6, 30);
      await service.updateRecurringConfig(configId: configId, endDate: newEnd);
      expect((await db.findRecurringConfigById(configId))!.endDate, newEnd);
    });
  });
}
