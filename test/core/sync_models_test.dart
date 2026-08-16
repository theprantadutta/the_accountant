import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';

SyncChange change(String table, String id, [String op = 'create']) =>
    SyncChange(tableName: table, entityId: id, operation: op, data: {'Id': id});

void main() {
  group('dependency order', () {
    test('parents come before the children that reference them', () {
      const order = SyncEntityOrder.applyOrder;
      expect(order.indexOf('wallets'), lessThan(order.indexOf('transactions')));
      expect(
        order.indexOf('categories'),
        lessThan(order.indexOf('transactions')),
      );
      expect(
        order.indexOf('payment_methods'),
        lessThan(order.indexOf('transactions')),
      );
      expect(
        order.indexOf('transactions'),
        lessThan(order.indexOf('recurring_configs')),
      );
    });

    test('deletes are the exact reverse', () {
      expect(
        SyncEntityOrder.deleteOrder,
        SyncEntityOrder.applyOrder.reversed.toList(),
      );
    });

    test('unknown tables sort last so they cannot precede a parent', () {
      expect(
        SyncEntityOrder.indexOf('something_new'),
        SyncEntityOrder.applyOrder.length,
      );
    });
  });

  group('SyncPullResponse.orderedChanges', () {
    test('reorders a payload that lists children first', () {
      // This is exactly the shape the server used to send: transactions first.
      final response = SyncPullResponse(
        changes: {
          'transactions': [change('transactions', 't1')],
          'recurring_configs': [change('recurring_configs', 'r1')],
          'wallets': [change('wallets', 'w1')],
          'categories': [change('categories', 'c1')],
          'payment_methods': [change('payment_methods', 'p1')],
        },
        currentVersions: const {},
      );

      final tables = response.orderedChanges.map((e) => e.table).toList();
      expect(
        tables.indexOf('wallets'),
        lessThan(tables.indexOf('transactions')),
      );
      expect(
        tables.indexOf('categories'),
        lessThan(tables.indexOf('transactions')),
      );
      expect(
        tables.indexOf('payment_methods'),
        lessThan(tables.indexOf('transactions')),
      );
      expect(
        tables.indexOf('transactions'),
        lessThan(tables.indexOf('recurring_configs')),
      );
    });

    test('every upsert runs before any delete', () {
      final response = SyncPullResponse(
        changes: {
          'transactions': [
            change('transactions', 'del', 'delete'),
            change('transactions', 'new'),
          ],
          'wallets': [change('wallets', 'w1')],
        },
        currentVersions: const {},
      );

      final ops = response.orderedChanges
          .map((e) => e.change.operation)
          .toList();
      expect(ops.last, 'delete');
      expect(ops.where((o) => o == 'delete'), hasLength(1));
    });

    test('deletes run children-first so a parent is never orphaned', () {
      final response = SyncPullResponse(
        changes: {
          'wallets': [change('wallets', 'w1', 'delete')],
          'transactions': [change('transactions', 't1', 'delete')],
          'recurring_configs': [change('recurring_configs', 'r1', 'delete')],
        },
        currentVersions: const {},
      );

      final tables = response.orderedChanges.map((e) => e.table).toList();
      expect(tables, ['recurring_configs', 'transactions', 'wallets']);
    });

    test('an unrecognised table is applied last, never ahead of a parent', () {
      final response = SyncPullResponse(
        changes: {
          'future_entity': [change('future_entity', 'x1')],
          'wallets': [change('wallets', 'w1')],
        },
        currentVersions: const {},
      );

      final tables = response.orderedChanges.map((e) => e.table).toList();
      expect(tables.last, 'future_entity');
    });

    test('falls back to the client order when the server sends none', () {
      final response = SyncPullResponse.fromJson({
        'changes': {
          'transactions': [
            {
              'table_name': 'transactions',
              'entity_id': 't1',
              'operation': 'create',
            },
          ],
          'wallets': [
            {'table_name': 'wallets', 'entity_id': 'w1', 'operation': 'create'},
          ],
        },
        'current_versions': <String, dynamic>{},
      });

      expect(response.entityOrder, SyncEntityOrder.applyOrder);
      expect(response.orderedChanges.first.table, 'wallets');
    });

    test('honours an explicit server-supplied order', () {
      final response = SyncPullResponse.fromJson({
        'changes': {
          'transactions': [
            {
              'table_name': 'transactions',
              'entity_id': 't1',
              'operation': 'create',
            },
          ],
          'wallets': [
            {'table_name': 'wallets', 'entity_id': 'w1', 'operation': 'create'},
          ],
        },
        'current_versions': <String, dynamic>{},
        'entity_order': ['wallets', 'transactions'],
      });

      expect(response.entityOrder, ['wallets', 'transactions']);
      expect(response.orderedChanges.map((e) => e.table).toList(), [
        'wallets',
        'transactions',
      ]);
    });

    test('totalChanges counts every bucket', () {
      final response = SyncPullResponse(
        changes: {
          'wallets': [change('wallets', 'w1'), change('wallets', 'w2')],
          'transactions': [change('transactions', 't1')],
        },
        currentVersions: const {},
      );
      expect(response.totalChanges, 3);
    });
  });

  group('SyncResult', () {
    test('a clean sync may advance the cursor', () {
      final result = SyncResult.success(pulledCount: 3);
      expect(result.success, isTrue);
      expect(result.canAdvanceCursor, isTrue);
      expect(result.isPartial, isFalse);
      expect(result.userMessage, isNull);
    });

    test('a partial sync is NOT a success and blocks the cursor', () {
      final result = SyncResult.partial(
        pulledCount: 2,
        applyFailures: const [
          SyncApplyFailure(
            tableName: 'transactions',
            entityId: 't-bad',
            reason: 'wallet w-missing is not available locally',
            isMissingParent: true,
          ),
        ],
      );

      expect(result.success, isFalse);
      expect(result.isPartial, isTrue);
      expect(result.canAdvanceCursor, isFalse);
      expect(result.userMessage, contains('t-bad'));
      expect(result.userMessage, contains('retried'));
    });

    test('a transport failure reports its error', () {
      final result = SyncResult.failure('No internet connection');
      expect(result.success, isFalse);
      expect(result.userMessage, 'No internet connection');
    });

    test('multiple failures are summarised, not dumped', () {
      final result = SyncResult.partial(
        applyFailures: List.generate(
          4,
          (i) => SyncApplyFailure(
            tableName: 'transactions',
            entityId: 't$i',
            reason: 'nope',
          ),
        ),
      );
      expect(result.userMessage, contains('and 3 more'));
    });
  });
}
