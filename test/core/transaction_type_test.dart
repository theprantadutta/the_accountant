import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionType;

import '../helpers/test_database.dart';

/// The storage string, the wire integer, and the domain policy must agree about
/// what a transfer and a generated occurrence look like. They had drifted apart:
/// an occurrence was stored `recurring_instance`, serialized by a lookup that
/// only matched `recurringinstance` (so it left as *Regular*), and parsed back as
/// `recurringInstance` — a third spelling matching neither.
void main() {
  group('canonical representations', () {
    test('storage values match the Drift column convention', () {
      expect(TransactionType.regular.storageValue, 'regular');
      expect(TransactionType.transfer.storageValue, 'transfer');
      expect(
        TransactionType.recurringInstance.storageValue,
        'recurring_instance',
      );
    });

    test('wire values match the backend enum ordinals', () {
      expect(TransactionType.regular.wireValue, 0);
      expect(TransactionType.transfer.wireValue, 1);
      expect(TransactionType.recurringInstance.wireValue, 2);
    });

    test('the policy constants come from the enum', () {
      expect(
        TransactionPolicy.transferType,
        TransactionType.transfer.storageValue,
      );
      expect(
        TransactionPolicy.recurringInstanceType,
        TransactionType.recurringInstance.storageValue,
      );
    });
  });

  group('round trips', () {
    test('storage -> wire -> storage is lossless for every type', () {
      for (final type in TransactionType.values) {
        final wire = TransactionType.fromStorage(type.storageValue).wireValue;
        expect(
          TransactionType.fromWire(wire).storageValue,
          type.storageValue,
          reason: '${type.name} must survive a sync round trip',
        );
      }
    });

    test('a recurring instance does not degrade to regular', () {
      // The exact failure the old string lookup produced.
      final wire = TransactionType.fromStorage('recurring_instance').wireValue;
      expect(wire, 2, reason: 'must not serialize as Regular (0)');
      expect(TransactionType.fromWire(wire), TransactionType.recurringInstance);
    });

    test('historical spellings still parse correctly', () {
      // Rows written by older builds must still be classified properly, even
      // before the schema-13 normalisation runs.
      for (final legacy in ['recurringInstance', 'recurringinstance']) {
        expect(
          TransactionType.fromStorage(legacy),
          TransactionType.recurringInstance,
          reason: '$legacy came from a previous build',
        );
      }
    });

    test('unknown values fall back to regular rather than throwing', () {
      expect(TransactionType.fromStorage('nonsense'), TransactionType.regular);
      expect(TransactionType.fromWire(99), TransactionType.regular);
      expect(TransactionType.fromWire(null), TransactionType.regular);
    });

    test('a numeric wire value that is not an int still parses', () {
      expect(TransactionType.fromWire(1.0), TransactionType.transfer);
    });
  });

  group('policy classification', () {
    test('recognises a generated occurrence', () {
      final row = buildTransaction(transactionType: 'recurring_instance');
      expect(TransactionPolicy.isRecurringInstance(row), isTrue);
      expect(TransactionPolicy.isTransfer(row), isFalse);
      expect(TransactionPolicy.kindOf(row), TransactionType.recurringInstance);
    });

    test('a generated occurrence still counts in analytics', () {
      // It is a real expense — only transfers are excluded.
      final row = buildTransaction(
        transactionType: 'recurring_instance',
        amount: 1500,
      );
      expect(TransactionPolicy.countsAsExpense(row), isTrue);
      expect(TransactionPolicy.totalExpense([row]), 1500);
    });

    test('recognises a transfer leg', () {
      final row = buildTransaction(transactionType: 'transfer');
      expect(TransactionPolicy.isTransfer(row), isTrue);
      expect(TransactionPolicy.isRecurringInstance(row), isFalse);
    });
  });
}
