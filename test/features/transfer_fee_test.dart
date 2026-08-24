import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/services/transfer_service.dart';

import '../helpers/test_database.dart';

/// A transfer that cost something to make.
///
/// Moving money between your own wallets leaves you no worse off, which is why
/// the two legs must be equal and why a transfer is not an expense. A charge for
/// making the move is the opposite — that money is gone — so it is recorded the
/// way every other loss is: an expense, on a real wallet, in a real category.
///
/// Keeping it out of the legs is what lets the pair stay equal, which is the
/// rule both this app and the server enforce on every transfer.
void main() {
  late AppDatabase db;
  late TransferService service;
  late String from;
  late String to;
  late String other;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = TransferService(db);
    from = await seedWallet(db, name: 'PayPal', openingBalance: 100000);
    to = await seedWallet(db, name: 'Bank', openingBalance: 0);
    other = await seedWallet(db, name: 'Everyday', openingBalance: 50000);
  });

  tearDown(() async => db.close());

  Future<List<Transaction>> allLive() async => (await db.getAllTransactions())
      .where((t) => t.deletedAt == null)
      .toList();

  test('a transfer with no fee is still exactly two rows', () async {
    await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
    );

    final rows = await allLive();
    expect(rows, hasLength(2));
    expect(rows.every((t) => t.feeForTransactionId == null), isTrue);
  });

  test('a fee is a third row, and the legs stay equal', () async {
    final (outgoing, incoming) = await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
    );

    final rows = await allLive();
    expect(rows, hasLength(3));

    final legA = rows.firstWhere((t) => t.id == outgoing);
    final legB = rows.firstWhere((t) => t.id == incoming);
    expect(
      legA.amount,
      legB.amount,
      reason: 'the fee must not be taken out of the transfer itself',
    );
    expect(legA.isIncome, isNot(legB.isIncome));

    final fee = rows.firstWhere((t) => t.feeForTransactionId != null);
    expect(fee.amount, 250);
    expect(fee.isIncome, isFalse);
    expect(fee.feeForTransactionId, outgoing);
    expect(
      fee.transactionType,
      TransactionPolicy.regularType,
      reason: 'a charge should count towards spending like any other expense',
    );
  });

  test('the fee is filed under the built-in Fees & Charges category', () async {
    await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
    );

    final fee = (await allLive()).firstWhere(
      (t) => t.feeForTransactionId != null,
    );
    final category = await db.findCategoryById(fee.categoryId!);
    expect(category!.defaultKey, BuiltInCategoryKeys.feesCharges);
  });

  test('the fee defaults to the wallet the money left', () async {
    await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
    );

    final fee = (await allLive()).firstWhere(
      (t) => t.feeForTransactionId != null,
    );
    expect(fee.walletId, from);
  });

  test('the fee can be charged to a third wallet', () async {
    // A provider does not always take its cut from the wallet the money left.
    await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
      feeWalletId: other,
    );

    final fee = (await allLive()).firstWhere(
      (t) => t.feeForTransactionId != null,
    );
    expect(fee.walletId, other);
  });

  test('balances account for the fee as well as the move', () async {
    await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
      feeWalletId: other,
    );

    expect((await db.findWalletById(from))!.balance, 100000 - 50000);
    expect((await db.findWalletById(to))!.balance, 50000);
    expect(
      (await db.findWalletById(other))!.balance,
      50000 - 250,
      reason: 'the charge has to come off the wallet it was billed to',
    );
  });

  test('deleting the transfer takes the fee with it', () async {
    final (outgoing, _) = await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
    );

    await service.deleteTransfer(outgoing);

    expect(
      await allLive(),
      isEmpty,
      reason: 'a charge left behind explains nothing on its own',
    );
    expect((await db.findWalletById(from))!.balance, 100000);
  });

  test('deleting from the receiving leg also removes the fee', () async {
    // Either leg can be the one the user swipes away.
    final (_, incoming) = await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
    );

    await service.deleteTransfer(incoming);

    expect(await allLive(), isEmpty);
  });

  test('a negative fee is refused', () async {
    expect(
      () => service.createTransfer(
        sourceWalletId: from,
        destinationWalletId: to,
        amount: 50000,
        date: DateTime(2026, 6, 1),
        feeAmount: -100,
      ),
      throwsArgumentError,
    );
  });

  test('the transfer still validates as a pair when a fee exists', () async {
    await service.createTransfer(
      sourceWalletId: from,
      destinationWalletId: to,
      amount: 50000,
      date: DateTime(2026, 6, 1),
      feeAmount: 250,
    );

    final issues = await service.validateAllTransfers();
    expect(
      issues,
      isEmpty,
      reason: 'the fee must be invisible to pair validation',
    );
  });

  group('currencies', () {
    test('a transfer between differently held wallets is refused', () async {
      // Both legs of a transfer carry the same figure, because a transfer is one
      // movement of one sum seen from both ends. Across currencies that figure
      // means two different amounts: 50000 out of a dollar wallet and 50000 into
      // a taka wallet invents about nine tenths of the money.
      final taka = await seedWallet(db, name: 'bKash', currency: 'BDT');

      expect(
        () => service.createTransfer(
          sourceWalletId: from,
          destinationWalletId: taka,
          amount: 50000,
          date: DateTime(2026, 6, 1),
        ),
        throwsArgumentError,
      );
    });

    test(
      'nothing is written when a cross-currency transfer is refused',
      () async {
        final taka = await seedWallet(db, name: 'bKash', currency: 'BDT');

        await expectLater(
          service.createTransfer(
            sourceWalletId: from,
            destinationWalletId: taka,
            amount: 50000,
            date: DateTime(2026, 6, 1),
            feeAmount: 250,
          ),
          throwsArgumentError,
        );

        expect(await allLive(), isEmpty);
        expect((await db.findWalletById(from))!.balance, 100000);
        expect((await db.findWalletById(taka))!.balance, 0);
      },
    );

    test('same-currency transfers are unaffected', () async {
      await service.createTransfer(
        sourceWalletId: from,
        destinationWalletId: to,
        amount: 50000,
        date: DateTime(2026, 6, 1),
      );
      expect(await allLive(), hasLength(2));
    });

    test('an edit cannot move a leg into another currency', () async {
      final taka = await seedWallet(db, name: 'bKash', currency: 'BDT');
      final (outgoing, _) = await service.createTransfer(
        sourceWalletId: from,
        destinationWalletId: to,
        amount: 50000,
        date: DateTime(2026, 6, 1),
      );

      await expectLater(
        service.updateTransfer(
          transactionId: outgoing,
          destinationWalletId: taka,
        ),
        throwsArgumentError,
      );

      // The pair is still the pair it was.
      final rows = await allLive();
      expect(rows, hasLength(2));
      expect(rows.map((t) => t.walletId).toSet(), {from, to});
      expect(rows.every((t) => t.amount == 50000), isTrue);
    });

    test('a transfer naming a wallet that does not exist is refused', () async {
      expect(
        () => service.createTransfer(
          sourceWalletId: from,
          destinationWalletId: 'no-such-wallet',
          amount: 50000,
          date: DateTime(2026, 6, 1),
        ),
        throwsArgumentError,
      );
    });
  });
}
