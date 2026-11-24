import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/transactions/providers/upcoming_provider.dart';

import '../helpers/test_database.dart';

/// A repeating payment is written on its day, so until then it was nowhere on
/// Upcoming: a DPS due in three days, or rent due today, simply did not show.
/// Upcoming now lists each running schedule's next payment.
void main() {
  late AppDatabase db;
  late String walletId;

  setUp(() async {
    db = openTestDatabase();
    SharedPreferences.setMockInitialValues({});
    walletId = await seedWallet(db, name: 'Brac Bank', currency: 'BDT');
  });

  tearDown(() async => db.close());

  Future<void> schedule(
    String id,
    String title, {
    required Duration fromToday,
    bool autoPay = true,
    bool isActive = true,
  }) async {
    final baseId = await seedTransaction(
      db,
      walletId: walletId,
      amount: 500000,
      title: title,
    );
    final now = DateTime.now();
    final next = DateTime(now.year, now.month, now.day, 12).add(fromToday);
    await db.addRecurringConfig(
      RecurringConfigsCompanion(
        id: Value(id),
        baseTransactionId: Value(baseId),
        periodLength: const Value(1),
        reoccurrence: const Value('monthly'),
        startDate: Value(next),
        nextOccurrence: Value(next),
        isActive: Value(isActive),
        autoPay: Value(autoPay),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );
  }

  Future<UpcomingState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    container.read(upcomingProvider);
    await container.read(upcomingProvider.notifier).loadData();
    return container.read(upcomingProvider);
  }

  test(
    'a schedule due soon is upcoming, with its amount and how it repeats',
    () async {
      await schedule(
        'dps',
        'My Monthly DPS',
        fromToday: const Duration(days: 3),
        autoPay: false,
      );

      final state = await load();

      expect(state.scheduled.map((p) => p.title), ['My Monthly DPS']);
      final dps = state.scheduled.single;
      expect(dps.amount, 500000);
      expect(dps.walletId, walletId);
      expect(dps.autoPay, isFalse);
      expect(dps.frequencyText, 'Monthly');
      expect(state.hasPendingItems, isTrue);
    },
  );

  test(
    'soonest first; beyond a month, paused or ended ones are left out',
    () async {
      await schedule('rent', 'Rent', fromToday: const Duration(days: 10));
      await schedule('dps', 'DPS', fromToday: Duration.zero);
      await schedule(
        'far',
        'Yearly insurance',
        fromToday: const Duration(days: 40),
      );
      await schedule(
        'paused',
        'Paused gym',
        fromToday: const Duration(days: 2),
        isActive: false,
      );

      final state = await load();

      expect(state.scheduled.map((p) => p.title), ['DPS', 'Rent']);
      expect(state.scheduledOverdue, isEmpty);
    },
  );

  test('a day that passed unrecorded counts as overdue', () async {
    await schedule('late', 'Internet', fromToday: const Duration(days: -2));

    final state = await load();

    expect(state.scheduled, isEmpty);
    expect(state.scheduledOverdue.map((p) => p.title), ['Internet']);
  });
}
