import 'dart:convert';

import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_transport.dart';

/// An in-memory stand-in for the backend sync API.
///
/// It mirrors the behaviours the real server is contractually required to have,
/// so a client bug shows up here rather than only in production:
///
/// * changes are stored per user, and a pull only ever returns that user's rows;
/// * pulled buckets are emitted in the shared dependency order, with the order
///   sent explicitly (`entityOrder`);
/// * `transactions.category_id` / `wallet_id` are validated against records the
///   user actually owns AND that are still live, exactly like
///   `ValidateTransactionReferences` — a soft-deleted parent is rejected;
/// * a category's `DefaultKey` is unique per user, so a second device cannot
///   upload a duplicate set of built-in categories;
/// * an `update` for an unknown entity is NotFound rather than an upsert, which
///   is what makes a client's create-vs-update state mistakes visible here;
/// * a transfer pair is only linked once BOTH legs exist and the pair is valid,
///   mirroring the server's two-phase write;
/// * a recurrence `OccurrenceKey` is unique per user, so a second device's copy
///   of the same occurrence is accepted-as-duplicate rather than stored twice;
/// * a batch larger than [maxChangesPerRequest] is rejected outright, like the
///   real `PushChangesCommandValidator`.
class FakeSyncServer {
  /// Matches the backend's PushChangesCommandValidator limit.
  static const int maxChangesPerRequest = 1000;

  /// Enforce the real contract that every `entity_id` is a GUID.
  ///
  /// Off by default because most suites use readable ids like `w-keep`, and
  /// their subject is behaviour rather than binding. It must be ON wherever the
  /// claim is "this payload would be accepted by the real API": the backend
  /// binds `SyncChange.EntityId` as a `Guid`, so a non-GUID id fails model
  /// binding before any handler sees it — and a fake that accepts arbitrary
  /// strings will happily prove a sync works when in production it could never
  /// leave the device.
  final bool strictEntityIds;

  FakeSyncServer({this.strictEntityIds = false});

  static final RegExp _guid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  /// userId -> tableName -> entityId -> record
  final Map<String, Map<String, Map<String, _Record>>> _store = {};

  /// Every push batch size the server has seen, for asserting chunking.
  final List<int> receivedBatchSizes = [];

  /// Number of pull requests served.
  int pullCount = 0;

  /// When set, the named table's payload gets this extra corruption applied on
  /// the next pull — used to inject an invalid remote record.
  Map<String, dynamic> Function(Map<String, dynamic> data)? corruptTransaction;

  DateTime _clock = DateTime.utc(2026, 1, 1);

  DateTime _tick() {
    _clock = _clock.add(const Duration(seconds: 1));
    return _clock;
  }

  Map<String, Map<String, _Record>> _userStore(String userId) =>
      _store.putIfAbsent(userId, () => {});

  Map<String, _Record> _table(String userId, String table) =>
      _userStore(userId).putIfAbsent(table, () => {});

  /// Records currently held for [userId] in [table].
  Iterable<Map<String, dynamic>> recordsIn(String userId, String table) =>
      _table(userId, table).values.where((r) => !r.deleted).map((r) => r.data);

  int countIn(String userId, String table) =>
      _table(userId, table).values.where((r) => !r.deleted).length;

  SyncPushResponse push(String userId, List<SyncChange> changes) {
    receivedBatchSizes.add(changes.length);
    if (changes.length > maxChangesPerRequest) {
      throw StateError(
        'Batch of ${changes.length} exceeds the server limit of '
        '$maxChangesPerRequest changes',
      );
    }

    var applied = 0;
    final conflicts = <SyncConflict>[];
    final resolutions = <SyncCategoryResolutionResult>[];

    for (final change in changes) {
      if (strictEntityIds && !_guid.hasMatch(change.entityId)) {
        // The real API rejects this at model binding, before any record in the
        // batch is considered — so the whole push fails, not just this change.
        throw StateError(
          'entity_id "${change.entityId}" for ${change.tableName} is not a '
          'GUID; the backend binds SyncChange.EntityId as Guid and would '
          'reject this request outright.',
        );
      }

      final table = _table(userId, change.tableName);

      if (change.operation == 'delete') {
        final existing = table[change.entityId];
        if (existing == null) {
          conflicts.add(
            SyncConflict(
              tableName: change.tableName,
              entityId: change.entityId,
              reason: 'Entity not found or access denied',
            ),
          );
          continue;
        }
        existing.deleted = true;
        existing.updatedAt = _tick();
        applied++;
        continue;
      }

      final data = Map<String, dynamic>.from(change.data ?? const {});

      // Built-in categories are gated on the user having said what the
      // account's pre-slug categories actually are.
      if (change.tableName == 'categories' && change.operation == 'create') {
        final gate = _gateLegacyCategory(userId, change, data, resolutions);
        if (gate != null) {
          if (gate.conflict != null) {
            conflicts.add(gate.conflict!);
          } else {
            // Adopted: the existing row gained the slug, and the provisional
            // copy is deliberately not stored.
            applied++;
          }
          continue;
        }
      }

      // An UPDATE for a row the server has never seen is NotFound, exactly as
      // the production handler answers it. Upserting here instead would have
      // hidden the very bug this models: a client that downgrades a
      // never-uploaded record from create to update can never get it to the
      // cloud, because every push asks the server to update something that does
      // not exist.
      if (change.operation == 'update' && !table.containsKey(change.entityId)) {
        conflicts.add(
          SyncConflict(
            tableName: change.tableName,
            entityId: change.entityId,
            reason:
                'Entity ${change.entityId} not found; an update cannot create a '
                'row the server has never seen.',
          ),
        );
        continue;
      }

      final rejection = _validateReferences(
        userId,
        change.entityId,
        change.tableName,
        data,
      );
      if (rejection != null) {
        conflicts.add(
          SyncConflict(
            tableName: change.tableName,
            entityId: change.entityId,
            reason: rejection,
          ),
        );
        continue;
      }

      // Recurrence idempotency: one row per (user, occurrence key).
      final occurrenceKey = data['OccurrenceKey'] as String?;
      if (occurrenceKey != null && occurrenceKey.isNotEmpty) {
        final hasDuplicate = table.entries.any(
          (e) =>
              e.key != change.entityId &&
              !e.value.deleted &&
              e.value.data['OccurrenceKey'] == occurrenceKey,
        );
        if (hasDuplicate) {
          // Accepted-as-duplicate: nothing stored, no conflict raised, so the
          // client marks its row synced and converges on the winning copy.
          applied++;
          continue;
        }
      }

      data['Id'] = change.entityId;
      table[change.entityId] = _Record(
        data: data,
        updatedAt: _tick(),
        createdAt: table[change.entityId]?.createdAt ?? _clock,
      );
      applied++;
    }

    _linkTransferPairs(userId, conflicts);

    return SyncPushResponse(
      appliedCount: applied,
      conflicts: conflicts,
      categoryResolutions: resolutions,
    );
  }

  /// Mirrors the backend's `GateLegacyCategoryCreate`.
  ///
  /// An account that predates category slugs holds rows with no slug at all. A
  /// freshly installed device seeds its own slugged copy and pushes it, and the
  /// server has no way to know whether the existing row is the same category or
  /// one the user made themselves. It refuses to guess: the create is rejected
  /// with the candidates attached, and only an explicit answer unblocks it.
  ///
  /// Returns null to let the ordinary create proceed.
  _GateOutcome? _gateLegacyCategory(
    String userId,
    SyncChange change,
    Map<String, dynamic> data,
    List<SyncCategoryResolutionResult> resolutions,
  ) {
    final key = data['DefaultKey'] as String?;
    if (key == null || key.isEmpty) return null;

    final spec = DefaultCategoryCatalog.byKey[key];
    // Not a built-in this server knows about: an ordinary category, no rules.
    if (spec == null) return null;

    final resolution = change.resolution;
    if (resolution?.kind == CategoryReconciliationKinds.createSeparate) {
      return null;
    }

    if (resolution?.kind == CategoryReconciliationKinds.adoptLegacy) {
      final candidateId = resolution!.candidateId;
      final candidate = candidateId == null
          ? null
          : _table(userId, 'categories')[candidateId];
      if (candidate == null || candidate.deleted) {
        return _GateOutcome(
          conflict: SyncConflict(
            tableName: 'categories',
            entityId: change.entityId,
            reason: "The category chosen for '$key' no longer exists.",
            code: SyncConflictCodes.legacyCategoryCandidateUnavailable,
            details: {'default_key': key, 'candidate_id': candidateId},
          ),
        );
      }
      if (candidate.data['IsIncome'] != spec.isIncome) {
        return _GateOutcome(
          conflict: SyncConflict(
            tableName: 'categories',
            entityId: change.entityId,
            reason:
                "'\${candidate.data['Name']}' is the wrong direction for '\$key'.",
            code: SyncConflictCodes.legacyCategoryCandidateUnavailable,
            details: {'default_key': key, 'candidate_id': candidateId},
          ),
        );
      }

      candidate.data['DefaultKey'] = key;
      candidate.data['IsDefault'] = true;
      candidate.updatedAt = _tick();

      resolutions.add(
        SyncCategoryResolutionResult(
          requestedEntityId: change.entityId,
          resolvedCategoryId: candidateId!,
          defaultKey: key,
          kind: CategoryReconciliationKinds.adoptLegacy,
          name: candidate.data['Name'] as String? ?? spec.name,
          isIncome: candidate.data['IsIncome'] as bool? ?? spec.isIncome,
          iconName: candidate.data['IconName'] as String? ?? spec.iconName,
          color: candidate.data['Color'] as String? ?? spec.colorCode,
          orderIndex: candidate.data['OrderIndex'] as int? ?? spec.orderIndex,
        ),
      );
      return const _GateOutcome();
    }

    final candidates = _table(userId, 'categories').entries
        .where(
          (e) =>
              !e.value.deleted &&
              ((e.value.data['DefaultKey'] as String?) ?? '').isEmpty &&
              e.value.data['Name'] == spec.name &&
              e.value.data['IsIncome'] == spec.isIncome,
        )
        .toList();
    if (candidates.isEmpty) return null;

    return _GateOutcome(
      conflict: SyncConflict(
        tableName: 'categories',
        entityId: change.entityId,
        reason:
            'This account already has \${candidates.length} categor'
            '\${candidates.length == 1 ? "y" : "ies"} that could be the '
            "built-in '\$key'.",
        code: SyncConflictCodes.legacyCategoryReconciliationRequired,
        details: {
          'default_key': key,
          'catalog_name': spec.name,
          'catalog_is_income': spec.isIncome,
          'candidates': [
            for (final c in candidates)
              {
                'id': c.key,
                'name': c.value.data['Name'],
                'is_income': c.value.data['IsIncome'],
                'icon_name': c.value.data['IconName'] ?? 'category',
                'color': c.value.data['Color'] ?? '#6366F1',
                'transaction_count': _table(userId, 'transactions').values
                    .where((t) => !t.deleted && t.data['CategoryId'] == c.key)
                    .length,
              },
          ],
        },
      ),
    );
  }

  String? _validateReferences(
    String userId,
    String entityId,
    String table,
    Map<String, dynamic> data,
  ) {
    /// A parent counts only if the user owns it AND it is not tombstoned. The
    /// server used to accept a soft-deleted parent, which let an offline device
    /// attach a transaction to a wallet or category another device had already
    /// deleted.
    String? live(String ownerTable, String? id, String label) {
      if (id == null) return null;
      final row = _table(userId, ownerTable)[id];
      if (row == null) return '$label $id not found for user';
      if (row.deleted) return '$label $id has been deleted';
      return null;
    }

    switch (table) {
      case 'transactions':
        final walletId = data['WalletId'] as String?;
        if (walletId == null) return 'Transaction has no wallet';
        return live('wallets', walletId, 'Wallet') ??
            live('categories', data['CategoryId'] as String?, 'Category') ??
            live(
              'payment_methods',
              data['PaymentMethodId'] as String?,
              'Payment method',
            ) ??
            live('budgets', data['BudgetId'] as String?, 'Budget') ??
            live('objectives', data['ObjectiveId'] as String?, 'Objective');

      case 'recurring_configs':
        return live(
          'transactions',
          data['BaseTransactionId'] as String?,
          'Base transaction',
        );

      case 'budgets':
        // `CategoryIds` is a JSON array in a text column, not a foreign key, so
        // nothing stops a budget being stored against a category the server has
        // never seen. That does not fail — the budget just silently counts none
        // of the transactions it should — which is exactly why the real handler
        // validates it and why this one has to as well.
        String? checkList(String field, String ownerTable, String label) {
          final raw = data[field];
          if (raw is! String || raw.isEmpty) return null;
          final List<dynamic> decoded;
          try {
            final parsed = jsonDecode(raw);
            if (parsed is! List) return null;
            decoded = parsed;
          } on FormatException {
            return null;
          }
          for (final value in decoded.whereType<String>()) {
            final failure = live(ownerTable, value, label);
            if (failure != null) return failure;
          }
          return null;
        }

        return checkList('CategoryIds', 'categories', 'Budget category') ??
            checkList('WalletIds', 'wallets', 'Budget wallet');

      case 'categories':
        // One built-in per slug per user (ix_categories_user_id_default_key).
        final defaultKey = data['DefaultKey'] as String?;
        if (defaultKey == null || defaultKey.isEmpty) return null;
        final clash = _table(userId, 'categories').entries.where(
          (e) =>
              e.key != entityId &&
              !e.value.deleted &&
              e.value.data['DefaultKey'] == defaultKey,
        );
        if (clash.isNotEmpty) {
          return "Default category '$defaultKey' already exists for this user "
              'as ${clash.first.key}. Merge into it instead of duplicating.';
        }
        return null;

      default:
        return null;
    }
  }

  /// Mirrors the server's second-phase transfer linking: a pair is written only
  /// once both legs are stored and the pair satisfies its invariants.
  void _linkTransferPairs(String userId, List<SyncConflict> conflicts) {
    final table = _table(userId, 'transactions');
    for (final entry in table.entries) {
      final partnerId = entry.value.data['PairedTransactionId'] as String?;
      if (partnerId == null || entry.value.deleted) continue;

      final partner = table[partnerId];
      if (partner == null) {
        conflicts.add(
          SyncConflict(
            tableName: 'transactions',
            entityId: entry.key,
            reason:
                'Transfer partner $partnerId is not present for this user; '
                'the leg was stored but left unlinked.',
          ),
        );
        entry.value.data['PairedTransactionId'] = null;
        continue;
      }
      if (partner.data['Amount'] != entry.value.data['Amount'] ||
          partner.data['IsIncome'] == entry.value.data['IsIncome'] ||
          partner.data['WalletId'] == entry.value.data['WalletId']) {
        conflicts.add(
          SyncConflict(
            tableName: 'transactions',
            entityId: entry.key,
            reason: 'Transfer pair invariants violated.',
          ),
        );
        entry.value.data['PairedTransactionId'] = null;
      }
    }
  }

  SyncPullResponse pull(String userId, DateTime? since) {
    pullCount++;
    final cutoff = since ?? DateTime.utc(1970);
    final changes = <String, List<SyncChange>>{};

    for (final table in SyncEntityOrder.applyOrder) {
      final rows = _table(userId, table).entries
          .where((e) => e.value.updatedAt.isAfter(cutoff))
          .map((e) {
            var payload = e.value.deleted
                ? null
                : Map<String, dynamic>.from(e.value.data);
            if (payload != null &&
                table == 'transactions' &&
                corruptTransaction != null) {
              payload = corruptTransaction!(payload);
            }
            return SyncChange(
              tableName: table,
              entityId: e.key,
              operation: e.value.deleted
                  ? 'delete'
                  : (e.value.createdAt.isAfter(cutoff) ? 'create' : 'update'),
              data: payload,
            );
          })
          .toList();
      if (rows.isNotEmpty) changes[table] = rows;
    }

    return SyncPullResponse(
      changes: changes,
      currentVersions: const {},
      serverTime: _tick(),
      entityOrder: SyncEntityOrder.applyOrder,
    );
  }
}

/// Either a rejection to report, or (with no conflict) an adoption that was
/// applied without storing the pushed row.
class _GateOutcome {
  final SyncConflict? conflict;
  const _GateOutcome({this.conflict});
}

class _Record {
  Map<String, dynamic> data;
  DateTime updatedAt;
  DateTime createdAt;
  bool deleted;

  _Record({
    required this.data,
    required this.updatedAt,
    required this.createdAt,
  }) : deleted = false;
}

/// A [SyncTransport] wired to a [FakeSyncServer] as a specific user.
///
/// The JWT is a real (unsigned) three-part token so the ownership guard's claim
/// parsing is genuinely exercised rather than stubbed out.
class FakeSyncTransport implements SyncTransport {
  final FakeSyncServer server;
  final String userId;
  bool online;
  bool authenticated;

  FakeSyncTransport({
    required this.server,
    required this.userId,
    this.online = true,
    this.authenticated = true,
  });

  @override
  Future<bool> isOnline() async => online;

  @override
  Future<bool> hasToken() async => authenticated;

  @override
  Future<String?> getToken() async =>
      authenticated ? _unsignedJwtFor(userId) : null;

  @override
  Future<SyncPushResponse> push(List<SyncChange> changes) async =>
      server.push(userId, changes);

  @override
  Future<SyncPullResponse> pull(DateTime? since) async =>
      server.pull(userId, since);
}

String _unsignedJwtFor(String userId) {
  String segment(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');

  return '${segment({'alg': 'none'})}.'
      '${segment({'sub': userId})}.signature';
}
