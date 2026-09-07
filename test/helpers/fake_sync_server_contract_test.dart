import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';

import 'fake_sync_server.dart';

/// What the fake promises, case by case, against what the real handler does.
///
/// Almost every sync test in this suite runs against [FakeSyncServer], so the
/// fake is the standard those tests actually measure against. It has twice
/// drifted from the server it stands in for: once applying nothing on a create
/// for a row it already held, after the handler had learned to apply content —
/// which hid a defect in the upgrade path — and once applying content for every
/// table after the handler had learned to do it only for transactions, which
/// let a test certify a replay-with-changes the server would ignore. Both times
/// a green client suite was evidence of nothing, and both times a reviewer
/// found it rather than a test.
///
/// Each case below is mirrored, under the same name, in the backend's
/// `PushContractTests`. Neither file proves the other right; a shared fixture
/// driving both would, and this is not one. What it does give is two documents
/// that disagree visibly and by name when one side changes and the other does
/// not — which is exactly what was missing.
void main() {
  late FakeSyncServer server;
  const userId = 'contract-user';
  const walletId = 'wallet-1';
  const transactionId = 'txn-1';

  SyncChange wallet(String name, DateTime updatedAt, {String operation = 'create'}) =>
      SyncChange(
        tableName: 'wallets',
        entityId: walletId,
        operation: operation,
        data: {
          'Name': name,
          'Currency': 'USD',
          'UpdatedAt': updatedAt.toIso8601String(),
        },
      );

  SyncChange transaction(
    int amount,
    DateTime updatedAt, {
    String operation = 'create',
  }) => SyncChange(
    tableName: 'transactions',
    entityId: transactionId,
    operation: operation,
    data: {
      'WalletId': walletId,
      'Amount': amount,
      'Title': 'Transaction',
      'Date': DateTime.utc(2026, 5).toIso8601String(),
      'IsPaid': true,
      'UpdatedAt': updatedAt.toIso8601String(),
    },
  );

  setUp(() {
    server = FakeSyncServer();
    server.push(userId, [wallet('Original', DateTime.utc(2025))]);
  });

  test('create for an existing transaction applies newer content', () {
    server.push(userId, [transaction(1000, DateTime.utc(2026))]);

    final result = server.push(userId, [transaction(2500, DateTime.utc(2027))]);

    expect(result.conflicts, isEmpty);
    expect(server.recordData(userId, 'transactions', transactionId)!['Amount'], 2500);
  });

  test('stale create for an existing transaction is acknowledged not conflicted', () {
    server.push(userId, [transaction(1000, DateTime.utc(2027))]);

    final result = server.push(userId, [transaction(2500, DateTime.utc(2020))]);

    // A create is idempotent by contract: answering a retry with a conflict
    // would leave that row pending on the device for ever.
    expect(result.conflicts, isEmpty);
    expect(result.appliedCount, 1);
    expect(server.recordData(userId, 'transactions', transactionId)!['Amount'], 1000);
  });

  test('create for an existing wallet is inert', () {
    final result = server.push(userId, [
      wallet('Later create', DateTime.utc(2030)),
    ]);

    // Only transactions apply content on a create for a row already held;
    // restoring one is pushed as a create and can carry an edit. Nothing else
    // has that need.
    expect(result.conflicts, isEmpty);
    expect(server.recordData(userId, 'wallets', walletId)!['Name'], 'Original');
  });

  test('stale update is a conflict', () {
    server.push(userId, [transaction(1000, DateTime.utc(2027))]);

    final result = server.push(userId, [
      transaction(2500, DateTime.utc(2020), operation: 'update'),
    ]);

    expect(result.conflicts, hasLength(1));
    expect(server.recordData(userId, 'transactions', transactionId)!['Amount'], 1000);
  });

  test('delete for a row the server does not hold is acknowledged', () {
    final result = server.push(userId, [
      SyncChange(
        tableName: 'transactions',
        entityId: 'never-seen',
        operation: 'delete',
      ),
    ]);

    expect(result.conflicts, isEmpty);
    expect(result.appliedCount, 1);
  });

  test('newer create lifts a tombstone', () {
    server.push(userId, [transaction(1000, DateTime.utc(2026))]);
    server.push(userId, [
      SyncChange(
        tableName: 'transactions',
        entityId: transactionId,
        operation: 'delete',
      ),
    ]);
    expect(server.isTombstoned(userId, 'transactions', transactionId), isTrue);

    server.push(userId, [transaction(1000, DateTime.utc(2027))]);

    expect(server.isTombstoned(userId, 'transactions', transactionId), isFalse);
  });
}
