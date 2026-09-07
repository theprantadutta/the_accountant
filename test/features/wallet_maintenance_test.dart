import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';
import 'package:the_accountant/features/wallets/services/wallet_maintenance_service.dart';

import '../helpers/test_database.dart';

/// Correcting a balance, and folding one account into another.
///
/// Neither existed. A balance that had drifted from the bank's could only be
/// fixed by hunting the missing transaction, and an account created by mistake
/// could only be deleted — which took its history with it.
void main() {
  late AppDatabase db;
  late WalletMaintenanceService service;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = WalletMaintenanceService(db);
  });

  tearDown(() => db.close());

  group('correcting a balance', () {
    test('a shortfall is recorded as money that left', () async {
      final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);

      await service.correctBalance(walletId: id, actualBalance: 45000);

      expect((await db.findWalletById(id))!.balance, 45000);
      final rows = await db.getAllTransactions();
      expect(rows, hasLength(1));
      expect(rows.single.amount, 5000);
      expect(rows.single.isIncome, isFalse);
    });

    test('a surplus is recorded as money that arrived', () async {
      final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);

      await service.correctBalance(walletId: id, actualBalance: 56000);

      expect((await db.findWalletById(id))!.balance, 56000);
      expect((await db.getAllTransactions()).single.isIncome, isTrue);
    });

    test('the correction is a transaction, not an overwrite', () async {
      final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);

      await service.correctBalance(walletId: id, actualBalance: 45000);
      // A full recalculation is what would silently undo a direct overwrite.
      await WalletBalanceService(db).recalculateAllWalletBalancesLocal();

      expect(
        (await db.findWalletById(id))!.balance,
        45000,
        reason:
            'a balance here is the sum of what happened, so a fix that is not '
            'itself something that happened does not survive',
      );
    });

    test('it is filed under the built-in correction category', () async {
      final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);

      await service.correctBalance(walletId: id, actualBalance: 45000);

      final expected = await db.requireSystemCategoryId(
        SystemCategoryKeys.balanceCorrection,
      );
      expect((await db.getAllTransactions()).single.categoryId, expected);
    });

    test('nothing is written when the balance already matches', () async {
      final id = await seedWallet(db, name: 'Everyday', openingBalance: 50000);

      expect(
        await service.correctBalance(walletId: id, actualBalance: 50000),
        isNull,
      );
      expect(await db.getAllTransactions(), isEmpty);
    });
  });

  group('merging one account into another', () {
    test('the transactions move across', () async {
      final from = await seedWallet(db, name: 'Old', openingBalance: 0);
      final to = await seedWallet(db, name: 'New', openingBalance: 0);
      final txn = await seedTransaction(db, walletId: from, amount: 2500);

      final moved = await service.mergeInto(sourceId: from, destinationId: to);

      expect(moved.moved, 1);
      expect((await db.findTransactionById(txn))!.walletId, to);
    });

    test(
      'the destination ends up holding what the two held between them',
      () async {
        final from = await seedWallet(db, name: 'Old', openingBalance: 30000);
        final to = await seedWallet(db, name: 'New', openingBalance: 20000);

        await service.mergeInto(sourceId: from, destinationId: to);

        expect((await db.findWalletById(to))!.balance, 50000);
      },
    );

    test('the source is closed rather than deleted', () async {
      final from = await seedWallet(db, name: 'Old', openingBalance: 10000);
      final to = await seedWallet(db, name: 'New');
      final txn = await seedTransaction(db, walletId: from, amount: 2500);

      await service.mergeInto(sourceId: from, destinationId: to);

      final source = await db.findWalletById(from);
      expect(source, isNotNull);
      expect(source!.isArchived, isTrue);
      expect(
        (await db.findTransactionById(txn))!.deletedAt,
        isNull,
        reason:
            'deleting the source would take the rows that had just been moved',
      );
    });

    test('the source stops holding a balance of its own', () async {
      final from = await seedWallet(db, name: 'Old', openingBalance: 30000);
      final to = await seedWallet(db, name: 'New', openingBalance: 0);

      await service.mergeInto(sourceId: from, destinationId: to);

      expect(
        (await db.findWalletById(from))!.balance,
        0,
        reason: 'otherwise the same money is counted in two places',
      );
    });

    /// Transfers are pairs, and moving each row on its own broke them.
    ///
    /// A transfer between the two accounts being merged ended with both legs
    /// on one wallet, which is not a transfer and which the server refuses —
    /// the wallet edits synced, the transaction edits did not, and the two
    /// copies disagreed from then on. A converted leg of a cross-currency
    /// transfer left its partner still describing the old figure.
    group('transfers', () {
      test('one between the two accounts is removed, not doubled up', () async {
        final from = await seedWallet(db, name: 'Old', openingBalance: 30000);
        final to = await seedWallet(db, name: 'New', openingBalance: 20000);
        final (out, into) = await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 5000,
          date: DateTime(2026, 3, 1),
        );

        final result = await service.mergeInto(
          sourceId: from,
          destinationId: to,
        );

        expect(result.transfersRemoved, 1);
        expect((await db.findTransactionById(out))!.deletedAt, isNotNull);
        expect((await db.findTransactionById(into))!.deletedAt, isNotNull);
        expect(
          result.moved,
          0,
          reason: 'the collapsed leg is deleted, not moved',
        );
        expect(
          (await db.findWalletById(to))!.balance,
          50000,
          reason: 'the two legs cancelled out within one account already, so '
              'removing them moves no money',
        );
      });

      test('the fee for a removed transfer is kept, not refunded', () async {
        final from = await seedWallet(db, name: 'Old', openingBalance: 30000);
        final to = await seedWallet(db, name: 'New', openingBalance: 20000);
        final (out, _) = await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 5000,
          date: DateTime(2026, 3, 1),
          feeAmount: 100,
          feeWalletId: from,
        );
        final fee = await db.findFeeForTransfer(out);

        await service.mergeInto(sourceId: from, destinationId: to);

        final kept = (await db.findTransactionById(fee!.id))!;
        expect(
          kept.deletedAt,
          isNull,
          reason: 'the two legs offset each other inside one account and the '
              'fee does not: it is money that left and did not come back. '
              'Deleting it with them handed the user their fee back',
        );
        expect(kept.walletId, to);
        expect(
          kept.feeForTransactionId,
          isNull,
          reason: 'detached, so nothing takes it down with a transfer that no '
              'longer exists — the server cascades on this link too',
        );
        expect(
          (await db.findWalletById(to))!.balance,
          50000 - 100,
          reason: 'the combined balance is what it was before the merge',
        );
      });

      test('one to a third account keeps its partner', () async {
        final from = await seedWallet(db, name: 'Old', openingBalance: 30000);
        final to = await seedWallet(db, name: 'New', openingBalance: 0);
        final third = await seedWallet(db, name: 'Other', openingBalance: 0);
        final (out, into) = await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: third,
          amount: 5000,
          date: DateTime(2026, 3, 1),
        );

        final result = await service.mergeInto(
          sourceId: from,
          destinationId: to,
        );

        expect(result.transfersRemoved, 0);
        final moved = await db.findTransactionById(out);
        final partner = await db.findTransactionById(into);
        expect(moved!.walletId, to);
        expect(partner!.walletId, third);
        expect(TransferIntegrity.validatePair(moved, partner), isEmpty);
      });

      test('a converted leg and its partner still agree on the crossing',
          () async {
        final from = await seedWallet(
          db,
          name: 'Old',
          currency: 'USD',
          openingBalance: 100000,
        );
        final to = await seedWallet(
          db,
          name: 'New',
          currency: 'EUR',
          openingBalance: 0,
        );
        final third = await seedWallet(
          db,
          name: 'Other',
          currency: 'GBP',
          openingBalance: 0,
        );
        await db.setCustomRate('USD', 'EUR', 0.5);
        final (out, into) = await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: third,
          amount: 10000,
          date: DateTime(2026, 3, 1),
          receivedAmount: 8000,
        );

        await service.mergeInto(sourceId: from, destinationId: to);

        final moved = (await db.findTransactionById(out))!;
        final partner = (await db.findTransactionById(into))!;
        expect(moved.amount, 5000, reason: 'converted into euros at 0.5');
        expect(
          partner.counterAmount,
          5000,
          reason: 'the partner still said 10000 crossed, which is no longer '
              'what the row beside it says',
        );
        expect(moved.counterAmount, partner.amount);
        expect(moved.fxRate, closeTo(8000 / 5000, 1e-9));
        expect(moved.fxRate, partner.fxRate);
      });

      test('a crossing that stops crossing carries one figure again', () async {
        final from = await seedWallet(
          db,
          name: 'Old',
          currency: 'USD',
          openingBalance: 100000,
        );
        final to = await seedWallet(
          db,
          name: 'New',
          currency: 'EUR',
          openingBalance: 0,
        );
        final third = await seedWallet(
          db,
          name: 'Other',
          currency: 'EUR',
          openingBalance: 0,
        );
        await db.setCustomRate('USD', 'EUR', 0.5);
        final (out, into) = await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: third,
          amount: 10000,
          date: DateTime(2026, 3, 1),
          receivedAmount: 8000,
        );

        await service.mergeInto(sourceId: from, destinationId: to);

        final moved = (await db.findTransactionById(out))!;
        final partner = (await db.findTransactionById(into))!;
        expect(
          moved.amount,
          8000,
          reason: 'both legs are in euros now, so the transfer carries the '
              'figure the untouched account actually saw',
        );
        expect(moved.amount, partner.amount);
        expect(moved.fxRate, isNull);
        expect(moved.counterAmount, isNull);
        expect(partner.fxRate, isNull);
        expect(partner.counterAmount, isNull);
        expect(TransferIntegrity.validatePair(moved, partner), isEmpty);
      });
    });

    /// A merge restates every amount at one rate. Normalising the transfers
    /// inside it must not create or destroy value while doing so.
    group('what the accounts are worth between them', () {
      /// The two accounts' combined value, expressed in [inCurrency].
      Future<int> combined(
        String a,
        String b, {
        required double aRate,
      }) async {
        final one = (await db.findWalletById(a))!.balance;
        final two = (await db.findWalletById(b))!.balance;
        return (one * aRate).round() + two;
      }

      test('a cross-currency transfer between them keeps the total', () async {
        final from = await seedWallet(
          db,
          name: 'Old',
          currency: 'USD',
          openingBalance: 20000,
        );
        final to = await seedWallet(db, name: 'New', currency: 'EUR');
        await db.setCustomRate('USD', 'EUR', 0.8);
        await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          receivedAmount: 9000,
          date: DateTime(2026, 3, 1),
        );
        final before = await combined(from, to, aRate: 0.8);

        await service.mergeInto(sourceId: from, destinationId: to);

        expect(
          (await db.findWalletById(to))!.balance,
          before,
          reason: 'a hundred dollars that arrived as ninety euros is not the '
              'same as a hundred dollars converted at the merge rate. Deleting '
              'both legs dropped the difference silently — ten euros the user '
              'really had',
        );
      });

      test('the difference is recorded, not written onto the balance', () async {
        final from = await seedWallet(
          db,
          name: 'Old',
          currency: 'USD',
          openingBalance: 20000,
        );
        final to = await seedWallet(db, name: 'New', currency: 'EUR');
        await db.setCustomRate('USD', 'EUR', 0.8);
        await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          receivedAmount: 9000,
          date: DateTime(2026, 3, 1),
        );

        await service.mergeInto(sourceId: from, destinationId: to);

        expect(
          (await db.findWalletById(to))!.balance,
          await WalletBalanceService(db).calculateWalletBalance(to),
          reason: 'a balance is the sum of what happened; an adjustment written '
              'straight onto it would be undone by the next recalculation',
        );
        final adjustment = (await db.getAllTransactions()).where(
          (t) => t.title == 'Merge adjustment',
        );
        expect(adjustment, hasLength(1));
        expect(adjustment.single.amount, 1000);
        expect(adjustment.single.isIncome, isTrue);
      });

      test('a same-currency transfer between them needs no adjustment', () async {
        final from = await seedWallet(db, name: 'Old', openingBalance: 30000);
        final to = await seedWallet(db, name: 'New', openingBalance: 20000);
        await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 5000,
          date: DateTime(2026, 3, 1),
        );

        await service.mergeInto(sourceId: from, destinationId: to);

        expect((await db.findWalletById(to))!.balance, 50000);
        expect(
          (await db.getAllTransactions()).where(
            (t) => t.title == 'Merge adjustment',
          ),
          isEmpty,
          reason: 'the two legs really do cancel within one currency',
        );
      });

      test('a leg that stops crossing keeps the total too', () async {
        final from = await seedWallet(
          db,
          name: 'Old',
          currency: 'USD',
          openingBalance: 20000,
        );
        final to = await seedWallet(db, name: 'New', currency: 'EUR');
        final third = await seedWallet(db, name: 'Other', currency: 'EUR');
        await db.setCustomRate('USD', 'EUR', 0.8);
        await TransferService(db).createTransfer(
          sourceWalletId: from,
          destinationWalletId: third,
          amount: 10000,
          receivedAmount: 9000,
          date: DateTime(2026, 3, 1),
        );
        final before =
            await combined(from, to, aRate: 0.8) +
            (await db.findWalletById(third))!.balance;

        await service.mergeInto(sourceId: from, destinationId: to);

        final after =
            (await db.findWalletById(to))!.balance +
            (await db.findWalletById(third))!.balance;
        expect(
          after,
          before,
          reason: 'the moved leg takes the untouched account\'s figure, which '
              'is a different number from the one it was converted to',
        );
      });
    });

    /// Two currencies can sit at parity. Deciding on the multiplier rather than
    /// on the currencies meant a merge at 1:1 skipped the repair entirely.
    test('a merge at parity still writes the crossing metadata', () async {
      final from = await seedWallet(
        db,
        name: 'Old',
        currency: 'USD',
        openingBalance: 20000,
      );
      final to = await seedWallet(db, name: 'New', currency: 'EUR');
      final third = await seedWallet(db, name: 'Other', currency: 'USD');
      await db.setCustomRate('USD', 'EUR', 1);
      final (out, _) = await TransferService(db).createTransfer(
        sourceWalletId: from,
        destinationWalletId: third,
        amount: 10000,
        date: DateTime(2026, 3, 1),
      );

      await service.mergeInto(sourceId: from, destinationId: to);

      final leg = (await db.findTransactionById(out))!;
      expect(
        leg.counterAmount,
        10000,
        reason: 'the leg is euros and its partner is dollars now, and the '
            'server refuses a crossing that carries neither a rate nor a '
            'counter amount',
      );
      expect(leg.fxRate, 1);
    });

    test('merging an account into itself is refused', () async {
      final id = await seedWallet(db, name: 'Everyday');

      expect(
        () => service.mergeInto(sourceId: id, destinationId: id),
        throwsArgumentError,
      );
    });

    test('merging into an account that does not exist is refused', () async {
      final id = await seedWallet(db, name: 'Everyday');

      expect(
        () => service.mergeInto(sourceId: id, destinationId: 'nowhere'),
        throwsArgumentError,
      );
    });
  });
}
