import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    as ui
    show transactionProvider;
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';

import '../helpers/test_database.dart';

/// Transfers have to show up in the list that shows transactions.
///
/// The transfer service writes its rows straight to the database rather than
/// going through the transaction notifier, so nothing told that notifier its
/// cached list had gone stale. Both legs and any fee were therefore invisible
/// on the Activity screen until the app was restarted — the money had moved,
/// the balances agreed, and there was no record of it anywhere the user looks.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late String from;
  late String to;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    from = await seedWallet(db, name: 'Everyday', openingBalance: 100000);
    to = await seedWallet(db, name: 'Bank', openingBalance: 0);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  /// The ids the Activity screen is currently showing.
  ///
  /// Asserted by id rather than by shape because the list is built from a
  /// view model that flattens a transfer into a plain income row and a plain
  /// expense row — what matters here is only whether the rows reached it.
  Set<String> shownIds() => container
      .read(ui.transactionProvider)
      .transactions
      .map((t) => t.id)
      .toSet();

  /// Ids actually in the database, ignoring tombstones.
  Future<Set<String>> storedIds() async => (await db.getAllTransactions())
      .where((t) => t.deletedAt == null)
      .map((t) => t.id)
      .toSet();

  /// Prime the notifier so it holds a cached list, exactly as it does when the
  /// user is already looking at the Activity screen.
  Future<void> openTheList() =>
      container.read(ui.transactionProvider.notifier).loadTransactions();

  test('a new transfer appears in the transaction list', () async {
    await openTheList();
    expect(shownIds(), isEmpty);

    final created = await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
        );
    expect(created, isTrue);

    // Read the cached state directly — no reload — because that is what the
    // screen renders.
    expect(
      shownIds(),
      await storedIds(),
      reason: 'both legs belong in the list the user is looking at',
    );
    expect(shownIds(), hasLength(2));
  });

  test('the fee charged for a transfer appears alongside it', () async {
    await openTheList();

    await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
          feeAmount: 250,
        );

    expect(shownIds(), hasLength(3));
    expect(shownIds(), await storedIds());

    final fee = (await db.getAllTransactions()).firstWhere(
      (t) => t.feeForTransactionId != null,
    );
    expect(
      shownIds(),
      contains(fee.id),
      reason: 'the charge is money gone; it cannot be invisible',
    );
  });

  test('deleting a transfer removes it from the list', () async {
    await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
          feeAmount: 250,
        );

    // Prime the list *after* the create, so the delete has something to remove
    // from it. Without this the cache starts empty and stays empty, and the
    // assertion below would pass whether or not deleting refreshes anything.
    await openTheList();
    expect(shownIds(), hasLength(3));

    final outgoing = (await db.getAllTransactions()).firstWhere(
      (t) => t.transactionType == 'transfer' && !t.isIncome,
    );

    await container.read(transferProvider.notifier).deleteTransfer(outgoing.id);

    expect(
      shownIds(),
      isEmpty,
      reason: 'a deleted transfer that stays on screen is worse than no list',
    );
  });

  test('editing a transfer updates what the list shows', () async {
    await container
        .read(transferProvider.notifier)
        .createTransfer(
          sourceWalletId: from,
          destinationWalletId: to,
          amount: 10000,
          date: DateTime(2026, 6, 1),
        );

    final outgoing = (await db.getAllTransactions()).firstWhere(
      (t) => t.transactionType == 'transfer' && !t.isIncome,
    );

    await container
        .read(transferProvider.notifier)
        .updateTransfer(transactionId: outgoing.id, amount: 25000);

    final shown = container.read(ui.transactionProvider).transactions;
    expect(shown, hasLength(2));
    expect(
      shown.every((t) => t.amount == 25000),
      isTrue,
      reason: 'the list must show the edited figure, not the one before it',
    );
  });
}
