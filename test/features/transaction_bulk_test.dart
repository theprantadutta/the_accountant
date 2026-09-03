import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';

import '../helpers/test_database.dart';

/// Acting on several transactions at once.
///
/// The interesting cases are the ones a naive loop gets wrong. A transfer is
/// one thing stored as two rows, so deleting a leg has to take its partner and
/// duplicating one would make half a transfer. Moving a leg to another account
/// would leave a transfer that goes nowhere.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late TransactionNotifier notifier;
  late String walletA;
  late String walletB;
  late String food;
  late String travel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    notifier = container.read(transactionProvider.notifier);

    walletA = await seedWallet(db, name: 'Everyday', openingBalance: 1000000);
    walletB = await seedWallet(db, name: 'Savings', openingBalance: 1000000);
    food = await seedCategory(db, name: 'Food');
    travel = await seedCategory(db, name: 'Travel');
  });

  tearDown(() async {
    // Deleting fires dashboard and report refreshes that outlive the call.
    // Disposing the container while those are still in flight makes them fail
    // on a Ref that is already gone, which reads as a test failure rather than
    // the teardown race it is.
    await pumpEventQueue();
    container.dispose();
    await db.close();
  });

  Future<List<String>> seedThree() async => [
    for (var i = 0; i < 3; i++)
      await seedTransaction(
        db,
        walletId: walletA,
        categoryId: food,
        amount: 1000 * (i + 1),
        date: DateTime(2026, 1, i + 1),
        title: 'Row $i',
      ),
  ];

  group('deleting', () {
    test('removes every selected row', () async {
      final ids = await seedThree();

      final removed = await notifier.deleteMany(ids);

      expect(removed, 3);
      for (final id in ids) {
        expect((await db.findTransactionById(id))?.deletedAt, isNotNull);
      }
    });

    test('a transfer leg takes its partner with it', () async {
      await TransferService(db).createTransfer(
        sourceWalletId: walletA,
        destinationWalletId: walletB,
        amount: 5000,
        date: DateTime(2026, 1, 5),
      );

      final legs = await db.getAllTransactions();
      final transfers = legs.where((t) => t.transactionType == 'transfer');
      expect(transfers, hasLength(2));

      await notifier.deleteMany([transfers.first.id]);

      final after = await db.getAllTransactions();
      expect(
        after.where((t) => t.transactionType == 'transfer'),
        isEmpty,
        reason:
            'leaving one leg behind gives an orphan row and a wrong balance on '
            'the partner account',
      );
    });

    test('one bad id does not abandon the rest', () async {
      final ids = await seedThree();

      final removed = await notifier.deleteMany([...ids, 'does-not-exist']);

      expect(removed, 3, reason: 'an id that is not there deletes nothing');
      for (final id in ids) {
        expect((await db.findTransactionById(id))?.deletedAt, isNotNull);
      }
    });
  });

  group('re-filing', () {
    test('moves every selected row to a category', () async {
      final ids = await seedThree();

      final changed = await notifier.setCategoryForMany(ids, travel);

      expect(changed, 3);
      for (final id in ids) {
        expect((await db.findTransactionById(id))!.categoryId, travel);
      }
    });

    test('moves rows to another account', () async {
      final ids = await seedThree();

      await notifier.setWalletForMany(ids, walletB);

      for (final id in ids) {
        expect((await db.findTransactionById(id))!.walletId, walletB);
      }
    });

    test('leaves transfer legs where they are', () async {
      await TransferService(db).createTransfer(
        sourceWalletId: walletA,
        destinationWalletId: walletB,
        amount: 5000,
        date: DateTime(2026, 1, 5),
      );
      final leg = (await db.getAllTransactions()).firstWhere(
        (t) => t.transactionType == 'transfer',
      );

      final changed = await notifier.setWalletForMany([leg.id], walletB);

      expect(changed, 0);
      expect(
        (await db.findTransactionById(leg.id))!.walletId,
        leg.walletId,
        reason:
            'moving one leg onto the account the other is already on makes a '
            'transfer that goes nowhere',
      );
    });

    test('re-dates every selected row', () async {
      final ids = await seedThree();
      final when = DateTime(2026, 6, 30);

      await notifier.setDateForMany(ids, when);

      for (final id in ids) {
        expect((await db.findTransactionById(id))!.date.day, 30);
      }
    });
  });

  group('marking paid', () {
    test('settles a backlog of unpaid rows', () async {
      final unpaid = [
        for (var i = 0; i < 2; i++)
          await seedTransaction(
            db,
            walletId: walletA,
            categoryId: food,
            amount: 2000,
            date: DateTime(2026, 1, i + 1),
            isPaid: false,
            specialType: TransactionSpecialType.upcoming,
          ),
      ];

      final changed = await notifier.markManyPaid(unpaid);

      expect(changed, 2);
      for (final id in unpaid) {
        expect((await db.findTransactionById(id))!.isPaid, isTrue);
      }
    });

    test('leaves rows that were already paid alone', () async {
      final ids = await seedThree();
      final before = (await db.findTransactionById(ids.first))!.date;

      final changed = await notifier.markManyPaid(ids);

      expect(changed, 0);
      expect(
        (await db.findTransactionById(ids.first))!.date,
        before,
        reason: 'marking a paid row paid again should not re-date it',
      );
    });
  });

  group('duplicating', () {
    test('copies the row without its links', () async {
      final id = await seedTransaction(
        db,
        walletId: walletA,
        categoryId: food,
        amount: 4200,
        date: DateTime(2026, 1, 4),
        title: 'Coffee',
      );

      final copyId = await notifier.duplicateTransaction(id);

      expect(copyId, isNotNull);
      final copy = await db.findTransactionById(copyId!);
      expect(copy!.title, 'Coffee');
      expect(copy.amount, 4200);
      expect(copy.walletId, walletA);
      expect(
        copy.occurrenceKey,
        isNull,
        reason:
            'an occurrence key is unique per recurrence, so copying it would '
            'collide with the row it was copied from',
      );
      expect(copy.pairedTransactionId, isNull);
      expect(copy.paidAmount, 0);
    });

    test('can be re-dated as it is copied', () async {
      final id = await seedTransaction(
        db,
        walletId: walletA,
        categoryId: food,
        amount: 1000,
        date: DateTime(2026, 1, 4),
      );

      final copyId = await notifier.duplicateTransaction(
        id,
        date: DateTime(2026, 2, 9),
      );

      expect((await db.findTransactionById(copyId!))!.date.month, 2);
    });

    test('refuses to copy half a transfer', () async {
      await TransferService(db).createTransfer(
        sourceWalletId: walletA,
        destinationWalletId: walletB,
        amount: 5000,
        date: DateTime(2026, 1, 5),
      );
      final leg = (await db.getAllTransactions()).firstWhere(
        (t) => t.transactionType == 'transfer',
      );

      expect(
        await notifier.duplicateTransaction(leg.id),
        isNull,
        reason: 'half a transfer is not a transaction anyone meant to create',
      );
    });

    test('copies several at once', () async {
      final ids = await seedThree();

      final made = await notifier.duplicateMany(ids);

      expect(made, 3);
      final live = (await db.getAllTransactions())
          .where((t) => t.deletedAt == null)
          .toList();
      expect(live, hasLength(6));
    });
  });
}
