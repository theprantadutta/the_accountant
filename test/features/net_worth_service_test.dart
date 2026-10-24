import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/networth/services/net_worth_service.dart';
import 'package:uuid/uuid.dart';

import '../helpers/test_database.dart';

/// Net worth: everything the user has, less everything they owe.
///
/// Accounts, deposits, holdings and assets at their balances; money lent
/// still owed back added; money borrowed still owed taken off, so a loan and
/// its repayment never move the figure. The month-end history is rebuilt
/// from the records and has to land on today's figure.
void main() {
  late AppDatabase db;
  late WalletBalanceService balances;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    balances = WalletBalanceService(db);
  });

  tearDown(() => db.close());

  Future<void> setType(String id, WalletType type) =>
      (db.update(db.wallets)..where((w) => w.id.equals(id))).write(
        WalletsCompanion(walletType: Value(type)),
      );

  Future<void> openedOn(String id, DateTime when) =>
      (db.update(db.wallets)..where((w) => w.id.equals(id))).write(
        WalletsCompanion(createdAt: Value(when)),
      );

  /// A repayment of [loanId], as Lend & borrow records one.
  Future<void> repay(
    String loanId, {
    required String walletId,
    required int amount,
    required bool isIncome,
    required DateTime date,
  }) async {
    final now = DateTime.now();
    await db.addTransaction(
      TransactionsCompanion(
        id: Value(const Uuid().v4()),
        amount: Value(amount),
        title: const Value('Repaid'),
        date: Value(date),
        isIncome: Value(isIncome),
        walletId: Value(walletId),
        settlesTransactionId: Value(loanId),
        isPaid: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    final loan = (await db.findTransactionById(loanId))!;
    await (db.update(db.transactions)..where((t) => t.id.equals(loanId))).write(
      TransactionsCompanion(paidAmount: Value(loan.paidAmount + amount)),
    );
  }

  group('what it is made of', () {
    late String bank;

    setUp(() async {
      bank = await seedWallet(db, name: 'Bank', openingBalance: 1000000);
      final card = await seedWallet(db, name: 'Card', openingBalance: -200000);
      await setType(card, WalletType.creditCard);
      final dps = await seedWallet(db, name: 'DPS', openingBalance: 300000);
      await setType(dps, WalletType.deposit);

      final investments = InvestmentService(db);
      final fund = await investments.create(
        const InvestmentDraft(
          name: 'Growth Fund',
          kind: InvestmentKind.fund,
          currency: 'USD',
        ),
      );
      await investments.buy(
        fund,
        fromWalletId: bank,
        amount: 100000,
        units: 10,
      );

      await AssetService(db).create(
        name: 'Plot',
        kind: AssetKind.land,
        currency: 'USD',
        value: 5000000,
      );

      // Lent 40,000 and had 15,000 back; borrowed 60,000.
      final lent = await seedTransaction(
        db,
        walletId: bank,
        amount: 40000,
        specialType: TransactionSpecialType.credit,
      );
      await repay(
        lent,
        walletId: bank,
        amount: 15000,
        isIncome: true,
        date: DateTime.now(),
      );
      await seedTransaction(
        db,
        walletId: bank,
        amount: 60000,
        isIncome: true,
        specialType: TransactionSpecialType.debt,
      );
      await balances.updateWalletBalance(bank);
    });

    test('every line, with cards left out by default', () async {
      final s = await NetWorthService(
        db,
      ).summary('USD', includeCreditCards: false);

      // 10,000 − 1,000 into the fund − 400 lent + 150 back + 600 borrowed.
      expect(s[NetWorthPart.cash], 1000000 - 100000 - 40000 + 15000 + 60000);
      expect(s[NetWorthPart.cards], 0);
      expect(s[NetWorthPart.deposits], 300000);
      expect(s[NetWorthPart.investments], 100000);
      expect(s[NetWorthPart.assets], 5000000);
      expect(s[NetWorthPart.lent], 25000);
      expect(s[NetWorthPart.borrowed], -60000);
      // The loans cancel against the cash they moved: 10,000 at the bank,
      // 3,000 in the DPS and 50,000 of land.
      expect(s.total, 1000000 + 300000 + 5000000);
      expect(s.accounts, s.total - 25000 + 60000);
      expect(s.includesCards, isFalse);
    });

    test(
      'a card counts as what is owed when the user includes cards',
      () async {
        final s = await NetWorthService(
          db,
        ).summary('USD', includeCreditCards: true);
        expect(s[NetWorthPart.cards], -200000);
        expect(s.total, 1000000 + 300000 + 5000000 - 200000);
      },
    );

    test('a loan made from a left-out account stays out with it', () async {
      final joint = await seedWallet(db, name: 'Joint', openingBalance: 90000);
      await (db.update(db.wallets)..where((w) => w.id.equals(joint))).write(
        const WalletsCompanion(excludeFromTotal: Value(true)),
      );
      await seedTransaction(
        db,
        walletId: joint,
        amount: 30000,
        specialType: TransactionSpecialType.credit,
      );
      await balances.updateWalletBalance(joint);

      final s = await NetWorthService(
        db,
      ).summary('USD', includeCreditCards: false);
      expect(s[NetWorthPart.lent], 25000);
      expect(s.total, 1000000 + 300000 + 5000000);
    });
  });

  test(
    'accounts in another currency are converted at the user\'s rate',
    () async {
      await seedWallet(db, name: 'Bank', openingBalance: 100000);
      final euros = await seedWallet(
        db,
        name: 'Euro account',
        openingBalance: 50000,
        currency: 'EUR',
      );
      final service = CurrencyService(db);
      await service.setCustomRate('EUR', 'USD', 1.1);
      await seedTransaction(
        db,
        walletId: euros,
        amount: 10000,
        specialType: TransactionSpecialType.credit,
      );
      await balances.updateWalletBalance(euros);

      final s = await NetWorthService(
        db,
        service,
      ).summary('USD', includeCreditCards: false);
      expect(s[NetWorthPart.cash], 100000 + 44000);
      expect(s[NetWorthPart.lent], 11000);
      expect(s.total, 100000 + 55000);

      final history = await NetWorthService(
        db,
        service,
      ).history('USD', includeCreditCards: false, months: 2);
      expect(history.last.value, s.total);
    },
  );

  group('month-end history', () {
    final now = DateTime(2026, 10, 15);

    test('is rebuilt from the records, loans included', () async {
      final bank = await seedWallet(db, name: 'Bank', openingBalance: 100000);
      await openedOn(bank, DateTime(2026, 5, 10));
      await seedTransaction(
        db,
        walletId: bank,
        amount: 50000,
        isIncome: true,
        date: DateTime(2026, 6, 5),
      );
      await seedTransaction(
        db,
        walletId: bank,
        amount: 20000,
        date: DateTime(2026, 7, 20),
      );
      // Lent in August, partly back in September: net worth stays put.
      final lent = await seedTransaction(
        db,
        walletId: bank,
        amount: 30000,
        specialType: TransactionSpecialType.credit,
        date: DateTime(2026, 8, 3),
      );
      await repay(
        lent,
        walletId: bank,
        amount: 10000,
        isIncome: true,
        date: DateTime(2026, 9, 10),
      );
      // Borrowed in September: neither richer nor poorer.
      await seedTransaction(
        db,
        walletId: bank,
        amount: 40000,
        isIncome: true,
        specialType: TransactionSpecialType.debt,
        date: DateTime(2026, 9, 20),
      );
      // A second account, opened in mid-August.
      final savings = await seedWallet(
        db,
        name: 'Savings',
        openingBalance: 70000,
      );
      await openedOn(savings, DateTime(2026, 8, 15));
      await balances.updateWalletBalance(bank);

      final history = await NetWorthService(
        db,
      ).history('USD', includeCreditCards: false, months: 6, now: now);

      expect(
        [for (final p in history) p.month],
        [
          DateTime(2026, 5),
          DateTime(2026, 6),
          DateTime(2026, 7),
          DateTime(2026, 8),
          DateTime(2026, 9),
          DateTime(2026, 10),
        ],
      );
      expect(
        [for (final p in history) p.value],
        [100000, 150000, 130000, 200000, 200000, 200000],
      );
      final today = await NetWorthService(
        db,
      ).summary('USD', includeCreditCards: false);
      expect(history.last.value, today.total);

      // A year back starts before anything existed, at nothing.
      final year = await NetWorthService(
        db,
      ).history('USD', includeCreditCards: false, months: 12, now: now);
      expect(year, hasLength(12));
      expect(year.first.month, DateTime(2025, 11));
      expect(year.take(6).every((p) => p.value == 0), isTrue);

      // All of it starts at the first month anything was recorded.
      final all = await NetWorthService(
        db,
      ).history('USD', includeCreditCards: false, now: now);
      expect(all.first.month, DateTime(2026, 5));
      expect(all, hasLength(6));
    });

    test('an account counts from its first row when that is earlier', () async {
      final cash = await seedWallet(db, name: 'Cash', openingBalance: 5000);
      await openedOn(cash, DateTime(2026, 10, 1));
      // Typed in from an old notebook, dated before the account was added.
      await seedTransaction(
        db,
        walletId: cash,
        amount: 1000,
        date: DateTime(2026, 8, 10),
      );
      await balances.updateWalletBalance(cash);

      final history = await NetWorthService(
        db,
      ).history('USD', includeCreditCards: false, months: 4, now: now);
      expect([for (final p in history) p.value], [0, 4000, 4000, 4000]);
    });

    test('a sold asset shows in the months it was owned', () async {
      final bank = await seedWallet(db, name: 'Bank', openingBalance: 100000);
      await openedOn(bank, DateTime(2026, 1, 1));
      final car = await seedWallet(db, name: 'Car', openingBalance: 0);
      await setType(car, WalletType.asset);
      await openedOn(car, DateTime(2026, 7, 1));
      // Bought in July for 60,000, sold in September for 50,000, closed.
      Future<void> transfer(
        String from,
        String to,
        int amount,
        DateTime d,
      ) async {
        await seedTransaction(
          db,
          walletId: from,
          amount: amount,
          transactionType: 'transfer',
          date: d,
        );
        await seedTransaction(
          db,
          walletId: to,
          amount: amount,
          isIncome: true,
          transactionType: 'transfer',
          date: d,
        );
      }

      await transfer(bank, car, 60000, DateTime(2026, 7, 5));
      await seedTransaction(
        db,
        walletId: car,
        amount: 10000,
        transactionType: 'adjustment',
        date: DateTime(2026, 9, 1),
      );
      await transfer(car, bank, 50000, DateTime(2026, 9, 1));
      await (db.update(db.wallets)..where((w) => w.id.equals(car))).write(
        const WalletsCompanion(isArchived: Value(true)),
      );
      await balances.updateWalletBalance(bank);
      await balances.updateWalletBalance(car);

      final history = await NetWorthService(
        db,
      ).history('USD', includeCreditCards: false, months: 4, now: now);
      expect(
        [for (final p in history) p.value],
        [
          100000, // July: 40,000 in the bank and the car at 60,000
          100000,
          90000, // sold for 10,000 less than it cost
          90000,
        ],
      );
    });
  });
}
