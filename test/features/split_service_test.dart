import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/split/services/split_service.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Splitting a bill with friends.
///
/// The shares have to add up to the bill to the cent, the account has to move
/// by exactly what left it, spending has to count only the user's own part,
/// and what friends owe (or what the user owes) has to be ordinary Lend &
/// borrow entries that settle the usual way.
void main() {
  late AppDatabase db;
  late SplitService splits;
  late String bank;
  late String food;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    splits = SplitService(db);
    bank = await seedWallet(db, name: 'Bank', openingBalance: 1000000);
    food = await seedCategory(db, name: 'Food');
  });

  tearDown(() => db.close());

  Future<int> balance() async => (await db.findWalletById(bank))!.balance;

  Future<List<Transaction>> live() async => (await db.getAllTransactions())
      .where((t) => t.deletedAt == null)
      .toList();

  SplitDraft draft({
    int total = 10000,
    List<String> people = const ['Alice', 'Bob'],
    bool includeMe = true,
    String? paidBy,
    SplitMode mode = SplitMode.equal,
    Map<String?, int> amounts = const {},
    Map<String?, double> percents = const {},
  }) => SplitDraft(
    title: 'Dinner',
    total: total,
    walletId: bank,
    categoryId: food,
    people: people,
    includeMe: includeMe,
    paidBy: paidBy,
    mode: mode,
    amounts: amounts,
    percents: percents,
  );

  Map<String?, int> byPerson(List<SplitShare> s) => {
    for (final x in s) x.person: x.amount,
  };

  group('the shares', () {
    test('split equally, with the spare cents on whoever paid', () {
      expect(byPerson(SplitService.shares(draft())), {
        null: 3334,
        'Alice': 3333,
        'Bob': 3333,
      });
      expect(byPerson(SplitService.shares(draft(paidBy: 'bob'))), {
        null: 3333,
        'Alice': 3333,
        'Bob': 3334,
      }, reason: 'the payer is matched whatever the case');
      final odd = SplitService.shares(draft(total: 10001, people: ['A', 'B']));
      expect(odd.fold<int>(0, (a, s) => a + s.amount), 10001);
    });

    test('when the payer has no share, the spare cents are spread', () {
      final s = SplitService.shares(
        draft(people: ['A', 'B', 'C'], includeMe: false, total: 10000),
      );
      expect(byPerson(s), {'A': 3334, 'B': 3333, 'C': 3333});
      final two = SplitService.shares(
        draft(people: ['A', 'B', 'C'], includeMe: false, total: 10001),
      );
      expect(byPerson(two), {'A': 3334, 'B': 3334, 'C': 3333});
    });

    test('exact amounts must add up to the bill', () {
      final s = SplitService.shares(
        draft(
          mode: SplitMode.exact,
          amounts: {null: 5000, 'alice': 3000, 'Bob': 2000},
        ),
      );
      expect(byPerson(s), {null: 5000, 'Alice': 3000, 'Bob': 2000});
      expect(
        () => SplitService.shares(
          draft(
            mode: SplitMode.exact,
            amounts: {null: 5000, 'Alice': 3000, 'Bob': 1000},
          ),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('90.00, not 100.00'),
          ),
        ),
      );
      expect(
        () => SplitService.shares(
          draft(mode: SplitMode.exact, amounts: {'Alice': 5000, 'Bob': 5000}),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Give your own share.',
          ),
        ),
      );
    });

    test('percentages must make 100, and the rounding lands on the payer', () {
      final s = SplitService.shares(
        draft(
          total: 9999,
          mode: SplitMode.percent,
          percents: {null: 50, 'Alice': 30, 'Bob': 20},
        ),
      );
      // 4999.5 rounds to 5000 and 2999.7 to 3000; 1999.8 to 2000. That is
      // one cent too many, taken back off the payer.
      expect(byPerson(s), {null: 4999, 'Alice': 3000, 'Bob': 2000});
      expect(
        () => SplitService.shares(
          draft(mode: SplitMode.percent, percents: {null: 50, 'Alice': 30}),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('80%, not 100%'),
          ),
        ),
      );
    });

    test('a bill it cannot split is refused with a reason', () {
      expect(() => SplitService.shares(draft(total: 0)), throwsArgumentError);
      expect(
        () => SplitService.shares(draft(people: [' '])),
        throwsArgumentError,
      );
      expect(
        () => SplitService.shares(draft(people: ['Alice', 'alice'])),
        throwsArgumentError,
      );
      expect(
        () => SplitService.shares(draft(paidBy: 'Carol')),
        throwsArgumentError,
      );
      expect(
        () => SplitService.shares(draft(paidBy: 'Bob', includeMe: false)),
        throwsArgumentError,
      );
    });
  });

  group('when I paid', () {
    test('my share is spending and the rest is lent to each person', () async {
      final id = await splits.record(draft());

      expect(
        await balance(),
        1000000 - 10000,
        reason: 'the whole bill left the account',
      );
      final rows = await live();
      expect(
        TransactionPolicy.totalExpense(rows),
        3334,
        reason: 'spending counts only my share',
      );

      final lent = await db.getCreditTransactions();
      expect(
        {for (final t in lent) t.title: t.amount},
        {'Alice': 3333, 'Bob': 3333},
      );
      for (final t in lent) {
        expect(t.isIncome, isFalse);
        expect(t.isPaid, isTrue);
        expect(t.notes, 'Dinner');
        expect(TransactionPolicy.isOutstanding(t), isTrue);
      }

      final parts = await splits.partsOf(id);
      expect(parts, hasLength(3));
      expect(parts.first.title, 'Dinner');
      expect(parts.first.specialType, TransactionSpecialType.none);
      expect(parts.map(SplitService.splitIdOf).toSet(), {id});
    });

    test('leaving myself out lends the whole bill', () async {
      await splits.record(
        draft(people: ['Alice', 'Bob', 'Carol'], includeMe: false),
      );
      expect(await balance(), 1000000 - 10000);
      expect(TransactionPolicy.totalExpense(await live()), 0);
      expect(await db.getCreditTransactions(), hasLength(3));
    });

    test('what friends pay back is settled in Lend & borrow', () async {
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      await splits.record(draft());
      final n = container.read(creditDebtProvider.notifier);
      await n.loadData();
      expect(container.read(creditDebtProvider).unpaidCredit, 6666);

      final alice = (await db.getCreditTransactions()).singleWhere(
        (t) => t.title == 'Alice',
      );
      await n.recordPayment(transactionId: alice.id, paymentAmount: 3333);

      expect(container.read(creditDebtProvider).unpaidCredit, 3333);
      expect(await balance(), 1000000 - 10000 + 3333);
      expect(
        TransactionPolicy.totalIncome(await live()),
        0,
        reason: 'being paid back is not earning',
      );
      expect(TransactionPolicy.totalExpense(await live()), 3334);
    });

    test('a name takes the spelling Lend & borrow already has', () async {
      await seedTransaction(
        db,
        walletId: bank,
        amount: 500,
        title: 'Alice',
        specialType: TransactionSpecialType.credit,
        date: DateTime(2026, 1, 1),
      );
      expect(await splits.knownPeople(), ['Alice']);
      await splits.record(draft(people: ['alice', 'Dan']));
      expect((await db.getCreditTransactions()).map((t) => t.title).toSet(), {
        'Alice',
        'Dan',
      });
      expect((await splits.knownPeople()).toSet(), {'Alice', 'Dan'});
    });

    test('an account that is not there cannot pay', () async {
      await expectLater(
        splits.record(
          SplitDraft(
            title: 'Dinner',
            total: 1000,
            walletId: 'missing',
            categoryId: food,
            people: const ['Alice'],
          ),
        ),
        throwsArgumentError,
      );
      expect(await live(), isEmpty);
    });
  });

  group('when someone else paid', () {
    test('my share is spending once, owed to the payer', () async {
      final id = await splits.record(draft(paidBy: 'Bob'));

      expect(await balance(), 1000000, reason: 'no money left my account yet');
      final rows = await live();
      expect(rows, hasLength(2), reason: 'only my share is my business');
      expect(TransactionPolicy.totalExpense(rows), 3333);
      expect(TransactionPolicy.totalIncome(rows), 0);

      final owed = (await db.getDebtTransactions()).single;
      expect(owed.title, 'Bob');
      expect(owed.amount, 3333);
      expect(owed.isIncome, isTrue);
      expect(owed.notes, 'Dinner');
      expect(await db.getCreditTransactions(), isEmpty);
      expect((await splits.partsOf(id)).map((t) => t.id), contains(owed.id));
    });

    test('paying the payer back settles it and only then moves the '
        'account', () async {
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      await splits.record(draft(paidBy: 'Bob'));
      final n = container.read(creditDebtProvider.notifier);
      await n.loadData();
      expect(container.read(creditDebtProvider).unpaidDebt, 3333);

      final owed = (await db.getDebtTransactions()).single;
      await n.markAsSettled(owed.id);

      expect(container.read(creditDebtProvider).unpaidDebt, 0);
      expect(await balance(), 1000000 - 3333);
      expect(
        TransactionPolicy.totalExpense(await live()),
        3333,
        reason: 'the repayment is not spending it a second time',
      );
    });
  });

  test('the parts of a split reach the server with their link', () async {
    final server = FakeSyncServer();
    await db.claimLocalStore(userId: 'u');
    final sync = SyncService(
      database: db,
      transport: FakeSyncTransport(server: server, userId: 'u'),
    );
    final id = await splits.record(draft());
    await splits.record(draft(paidBy: 'Alice'));

    final result = await sync.syncAll();
    expect(result.success, isTrue, reason: result.userMessage);

    final mine = server
        .recordsIn('u', 'transactions')
        .where((r) => (r['OccurrenceKey'] as String?)?.contains(id) ?? false)
        .toList();
    expect(mine, hasLength(3));
    expect(mine.map((r) => r['SpecialType']).toList()..sort(), [
      TransactionSpecialType.none.index,
      TransactionSpecialType.credit.index,
      TransactionSpecialType.credit.index,
    ]);
    final debt = server
        .recordsIn('u', 'transactions')
        .singleWhere(
          (r) => r['SpecialType'] == TransactionSpecialType.debt.index,
        );
    expect(debt['Title'], 'Alice');
    expect(debt['IsIncome'], isTrue);
  });
}
