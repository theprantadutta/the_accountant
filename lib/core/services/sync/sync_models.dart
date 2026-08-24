// Data models for synchronization operations
// Aligned with backend API: TheAccountant.Application.Features.Sync.DTOs

/// The order in which synchronized entity tables must be applied.
///
/// Children can only be written once their parents exist: a transaction has
/// foreign keys to a wallet, a category, and a payment method; a recurring
/// config points at its base transaction. The server previously emitted
/// `transactions` first and the client applied whatever order the JSON map
/// happened to iterate in, so on a clean device (or immediately after a cloud
/// restore) every transaction referenced parents that had not been written yet.
///
/// Both ends now agree on this list, and it is exercised by tests on both sides
/// so the two cannot drift apart.
class SyncEntityOrder {
  const SyncEntityOrder._();

  /// Parents first, then children. Applies to creates and updates.
  static const List<String> applyOrder = [
    'wallets',
    'categories',
    'payment_methods',
    'budgets',
    'objectives',
    'transactions',
    'recurring_configs',
  ];

  /// Deletes go the other way, so a parent is never removed while a child still
  /// references it.
  static List<String> get deleteOrder => applyOrder.reversed.toList();

  /// Position of [tableName] in the dependency order; unknown tables sort last
  /// so an unrecognised entity can never jump ahead of a parent it may need.
  static int indexOf(String tableName) {
    final index = applyOrder.indexOf(tableName);
    return index < 0 ? applyOrder.length : index;
  }
}

/// A pulled change that could not be applied locally.
///
/// Retained (rather than logged and forgotten) so the sync can report an honest
/// partial result, keep its cursor where it is, and re-fetch the record next
/// time instead of silently dropping the user's data.
class SyncApplyFailure {
  final String tableName;
  final String entityId;
  final String reason;

  /// True when the record failed only because a parent it references was not
  /// available — the case that is expected to succeed on retry once the parent
  /// arrives.
  final bool isMissingParent;

  const SyncApplyFailure({
    required this.tableName,
    required this.entityId,
    required this.reason,
    this.isMissingParent = false,
  });

  @override
  String toString() => '$tableName/$entityId: $reason';
}

/// Represents a single change to be synced (matches backend SyncChange)
class SyncChange {
  final String tableName;
  final String entityId;
  final String operation; // 'create', 'update', 'delete'
  final Map<String, dynamic>? data;

  /// Transient, client-only: the row's `updatedAt` at the moment this change was
  /// collected for push. Used for compare-and-set when marking the record synced,
  /// so an edit made while the push was in flight isn't silently cleared. NOT sent
  /// to the server (excluded from [toJson]).
  final DateTime? sourceUpdatedAt;

  /// A decision the user made about a question the server asked earlier.
  ///
  /// Only ever set by an explicit user action. The server refuses to guess at
  /// these on its own, and the client never synthesises one.
  final SyncChangeResolution? resolution;

  SyncChange({
    required this.tableName,
    required this.entityId,
    required this.operation,
    this.data,
    this.sourceUpdatedAt,
    this.resolution,
  });

  SyncChange withResolution(SyncChangeResolution? value) => SyncChange(
    tableName: tableName,
    entityId: entityId,
    operation: operation,
    data: data,
    sourceUpdatedAt: sourceUpdatedAt,
    resolution: value,
  );

  Map<String, dynamic> toJson() => {
    'table_name': tableName,
    'entity_id': entityId,
    'operation': operation,
    'data': data,
    if (resolution != null) 'resolution': resolution!.toJson(),
  };

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
    tableName:
        json['table_name'] ?? json['tableName'] ?? json['TableName'] ?? '',
    entityId: json['entity_id'] ?? json['entityId'] ?? json['EntityId'] ?? '',
    operation: json['operation'] ?? json['Operation'] ?? '',
    data: json['data'] ?? json['Data'],
  );
}

/// The user's answer to a reconciliation question, sent alongside the change it
/// unblocks.
class SyncChangeResolution {
  /// One of [CategoryReconciliationKinds].
  final String kind;

  /// The candidate the user picked, for an adopt answer.
  final String? candidateId;

  const SyncChangeResolution({required this.kind, this.candidateId});

  Map<String, dynamic> toJson() => {
    'kind': kind,
    if (candidateId != null) 'candidate_id': candidateId,
  };
}

/// The two things a user can decide about a pre-slug category that might be a
/// built-in. Mirrors `SyncResolutionKinds` on the server.
class CategoryReconciliationKinds {
  /// "Yes, that existing category IS this built-in." The existing row keeps its
  /// id and history and gains the slug; the provisional copy is folded into it.
  static const String adoptLegacy = 'adopt_legacy_category';

  /// "No, leave it alone." The existing category stays a plain custom category
  /// and the built-in is created separately alongside it.
  static const String createSeparate = 'create_separate_category';
}

/// Request to push local changes to server (matches backend PushChangesCommand)
class SyncPushRequest {
  final List<SyncChange> changes;

  SyncPushRequest({required this.changes});

  Map<String, dynamic> toJson() => {
    'changes': changes.map((c) => c.toJson()).toList(),
  };
}

/// Response from push operation (matches backend SyncPushResponse)
class SyncPushResponse {
  final int appliedCount;
  final List<SyncConflict> conflicts;

  /// What the server did with any user-confirmed resolutions in this push.
  ///
  /// Reported explicitly rather than left to be inferred from the next pull, so
  /// the client can settle its local state in the same round trip — and so a
  /// device that is about to go offline still ends up consistent.
  final List<SyncCategoryResolutionResult> categoryResolutions;

  SyncPushResponse({
    required this.appliedCount,
    required this.conflicts,
    this.categoryResolutions = const [],
  });

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    final conflictsList = json['conflicts'] ?? json['Conflicts'];
    final resolutionsList =
        json['category_resolutions'] ??
        json['categoryResolutions'] ??
        json['CategoryResolutions'];
    return SyncPushResponse(
      appliedCount:
          json['applied_count'] ??
          json['appliedCount'] ??
          json['AppliedCount'] ??
          0,
      conflicts:
          (conflictsList as List?)
              ?.map((c) => SyncConflict.fromJson(c as Map<String, dynamic>))
              .toList() ??
          <SyncConflict>[],
      categoryResolutions:
          (resolutionsList as List?)
              ?.map(
                (r) => SyncCategoryResolutionResult.fromJson(
                  r as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <SyncCategoryResolutionResult>[],
    );
  }
}

/// What became of a category the client asked the server to resolve.
class SyncCategoryResolutionResult {
  /// The provisional category this device pushed.
  final String requestedEntityId;

  /// The category that now owns the slug — the adopted row, or the new one.
  final String resolvedCategoryId;
  final String defaultKey;

  /// One of [CategoryReconciliationKinds].
  final String kind;
  final String name;
  final bool isIncome;
  final String iconName;
  final String color;
  final int orderIndex;

  const SyncCategoryResolutionResult({
    required this.requestedEntityId,
    required this.resolvedCategoryId,
    required this.defaultKey,
    required this.kind,
    required this.name,
    required this.isIncome,
    required this.iconName,
    required this.color,
    required this.orderIndex,
  });

  static T? _pick<T>(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null) return v as T;
    }
    return null;
  }

  factory SyncCategoryResolutionResult.fromJson(
    Map<String, dynamic> json,
  ) => SyncCategoryResolutionResult(
    requestedEntityId:
        _pick<String>(json, [
          'requested_entity_id',
          'requestedEntityId',
          'RequestedEntityId',
        ]) ??
        '',
    resolvedCategoryId:
        _pick<String>(json, [
          'resolved_category_id',
          'resolvedCategoryId',
          'ResolvedCategoryId',
        ]) ??
        '',
    defaultKey:
        _pick<String>(json, ['default_key', 'defaultKey', 'DefaultKey']) ?? '',
    kind: _pick<String>(json, ['kind', 'Kind']) ?? '',
    name: _pick<String>(json, ['name', 'Name']) ?? '',
    isIncome: _pick<bool>(json, ['is_income', 'isIncome', 'IsIncome']) ?? false,
    iconName:
        _pick<String>(json, ['icon_name', 'iconName', 'IconName']) ??
        'category',
    color: _pick<String>(json, ['color', 'Color']) ?? '#6366F1',
    orderIndex:
        _pick<int>(json, ['order_index', 'orderIndex', 'OrderIndex']) ?? 0,
  );
}

/// Response from pull operation (matches backend SyncPullResponse)
class SyncPullResponse {
  final Map<String, List<SyncChange>> changes;
  final Map<String, int> currentVersions;

  /// Server clock at the start of this pull; used as the `since` cursor for the next pull.
  final DateTime? serverTime;

  /// Table names in the order the server intends them to be applied.
  ///
  /// Sent explicitly (`entity_order`) rather than inferred from JSON map
  /// insertion order, which is not part of the JSON contract and silently
  /// reordered children ahead of their parents. Falls back to the client's own
  /// [SyncEntityOrder.applyOrder] when talking to an older server.
  final List<String> entityOrder;

  SyncPullResponse({
    required this.changes,
    required this.currentVersions,
    this.serverTime,
    List<String>? entityOrder,
  }) : entityOrder = (entityOrder == null || entityOrder.isEmpty)
           ? SyncEntityOrder.applyOrder
           : entityOrder;

  /// Every change flattened into dependency order: all non-delete operations
  /// parents-first, then all deletes children-first.
  List<({String table, SyncChange change})> get orderedChanges {
    final upserts = <({String table, SyncChange change})>[];
    final deletes = <({String table, SyncChange change})>[];

    void classify(String table, SyncChange change) {
      if (change.operation == 'delete') {
        deletes.add((table: table, change: change));
      } else {
        upserts.add((table: table, change: change));
      }
    }

    for (final table in entityOrder) {
      for (final change in changes[table] ?? const <SyncChange>[]) {
        classify(table, change);
      }
    }
    // Any table the server sent that isn't in the agreed order still gets
    // applied — last, so it can never precede a parent it might depend on.
    for (final entry in changes.entries) {
      if (entityOrder.contains(entry.key)) continue;
      for (final change in entry.value) {
        classify(entry.key, change);
      }
    }

    // Deletes run in reverse dependency order.
    deletes.sort(
      (a, b) =>
          SyncEntityOrder.indexOf(b.table) - SyncEntityOrder.indexOf(a.table),
    );

    return [...upserts, ...deletes];
  }

  /// Total number of changes in this batch.
  int get totalChanges =>
      changes.values.fold<int>(0, (sum, list) => sum + list.length);

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    final changesJson =
        json['changes'] ?? json['Changes'] as Map<String, dynamic>? ?? {};
    final changes = <String, List<SyncChange>>{};

    changesJson.forEach((tableName, changesList) {
      if (changesList is List) {
        changes[tableName] = changesList
            .map((c) => SyncChange.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    });

    final versionsJson =
        json['current_versions'] ??
        json['currentVersions'] ??
        json['CurrentVersions'] as Map<String, dynamic>? ??
        {};
    final versions = <String, int>{};
    versionsJson.forEach((key, value) {
      versions[key] = value as int? ?? 0;
    });

    final serverTimeRaw =
        json['server_time'] ?? json['serverTime'] ?? json['ServerTime'];
    final serverTime = serverTimeRaw is String
        ? DateTime.tryParse(serverTimeRaw)?.toUtc()
        : null;

    final orderRaw =
        json['entity_order'] ?? json['entityOrder'] ?? json['EntityOrder'];
    final entityOrder = orderRaw is List
        ? orderRaw.map((e) => e.toString()).toList()
        : null;

    return SyncPullResponse(
      changes: changes,
      currentVersions: versions,
      serverTime: serverTime,
      entityOrder: entityOrder,
    );
  }
}

/// Represents a sync conflict (matches backend SyncConflict)
class SyncConflict {
  final String tableName;
  final String entityId;

  /// Prose, for logs and diagnostics. Never branch on this.
  final String reason;

  /// Stable machine-readable classification — see [SyncConflictCodes].
  ///
  /// Behaviour keys off this and only this. Matching on [reason] would make the
  /// client's control flow depend on the server's wording, so a harmless
  /// rephrasing on the backend would silently change what the app does.
  final String? code;

  /// Code-specific structured payload.
  final Map<String, dynamic>? details;

  SyncConflict({
    required this.tableName,
    required this.entityId,
    required this.reason,
    this.code,
    this.details,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] ?? json['Details'];
    return SyncConflict(
      tableName:
          json['table_name'] ?? json['tableName'] ?? json['TableName'] ?? '',
      entityId: json['entity_id'] ?? json['entityId'] ?? json['EntityId'] ?? '',
      reason: json['reason'] ?? json['Reason'] ?? '',
      code: json['code'] ?? json['Code'],
      details: rawDetails is Map ? rawDetails.cast<String, dynamic>() : null,
    );
  }
}

/// Conflict codes the server can return. Mirrors `SyncConflictCodes`.
class SyncConflictCodes {
  /// A built-in category could not be created because the account still holds
  /// pre-slug categories that might already be it. Only the user can say.
  static const String legacyCategoryReconciliationRequired =
      'legacy_category_reconciliation_required';

  /// The category the user chose can no longer be adopted; ask again.
  static const String legacyCategoryCandidateUnavailable =
      'legacy_category_candidate_unavailable';

  static const String duplicateDefaultCategory = 'duplicate_default_category';
  static const String invalidReference = 'invalid_reference';
  static const String staleVersion = 'stale_version';
  static const String invalidTransferPair = 'invalid_transfer_pair';
  static const String transferPartnerMissing = 'transfer_partner_missing';
}

/// One pre-slug category the server is offering as a possible built-in.
class LegacyCategoryCandidate {
  final String id;
  final String name;
  final bool isIncome;
  final String iconName;
  final String color;

  /// How much history is attached. This is the number that actually lets a user
  /// tell the category they have been using for years from an empty duplicate.
  final int transactionCount;

  const LegacyCategoryCandidate({
    required this.id,
    required this.name,
    required this.isIncome,
    required this.iconName,
    required this.color,
    required this.transactionCount,
  });

  static T? _pick<T>(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null) return v as T;
    }
    return null;
  }

  factory LegacyCategoryCandidate.fromJson(Map<String, dynamic> json) =>
      LegacyCategoryCandidate(
        id: _pick<String>(json, ['id', 'Id']) ?? '',
        name: _pick<String>(json, ['name', 'Name']) ?? '',
        isIncome:
            _pick<bool>(json, ['is_income', 'isIncome', 'IsIncome']) ?? false,
        iconName:
            _pick<String>(json, ['icon_name', 'iconName', 'IconName']) ??
            'category',
        color: _pick<String>(json, ['color', 'Color']) ?? '#6366F1',
        transactionCount:
            _pick<int>(json, [
              'transaction_count',
              'transactionCount',
              'TransactionCount',
            ]) ??
            0,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'is_income': isIncome,
    'icon_name': iconName,
    'color': color,
    'transaction_count': transactionCount,
  };
}

/// The payload of a [SyncConflictCodes.legacyCategoryReconciliationRequired].
class LegacyCategoryReconciliationDetails {
  final String defaultKey;
  final String catalogName;
  final bool catalogIsIncome;
  final List<LegacyCategoryCandidate> candidates;

  const LegacyCategoryReconciliationDetails({
    required this.defaultKey,
    required this.catalogName,
    required this.catalogIsIncome,
    required this.candidates,
  });

  static LegacyCategoryReconciliationDetails? tryParse(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return null;
    final key = json['default_key'] ?? json['defaultKey'] ?? json['DefaultKey'];
    if (key is! String || key.isEmpty) return null;
    final rawCandidates =
        json['candidates'] ?? json['Candidates'] ?? const <dynamic>[];
    return LegacyCategoryReconciliationDetails(
      defaultKey: key,
      catalogName:
          json['catalog_name'] ??
          json['catalogName'] ??
          json['CatalogName'] ??
          key,
      catalogIsIncome:
          json['catalog_is_income'] ??
          json['catalogIsIncome'] ??
          json['CatalogIsIncome'] ??
          false,
      candidates: (rawCandidates as List)
          .whereType<Map>()
          .map(
            (c) => LegacyCategoryCandidate.fromJson(c.cast<String, dynamic>()),
          )
          .toList(),
    );
  }
}

/// Sync status for a table (matches backend SyncLogDto)
class SyncLogDto {
  final String id;
  final String userId;
  final String tableName;
  final DateTime? lastSyncAt;
  final int lastServerVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  SyncLogDto({
    required this.id,
    required this.userId,
    required this.tableName,
    this.lastSyncAt,
    required this.lastServerVersion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SyncLogDto.fromJson(Map<String, dynamic> json) {
    final lastSyncAtRaw =
        json['last_sync_at'] ?? json['lastSyncAt'] ?? json['LastSyncAt'];
    final createdAtRaw =
        json['created_at'] ?? json['createdAt'] ?? json['CreatedAt'];
    final updatedAtRaw =
        json['updated_at'] ?? json['updatedAt'] ?? json['UpdatedAt'];
    return SyncLogDto(
      id: json['id'] ?? json['Id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? json['UserId'] ?? '',
      tableName:
          json['table_name'] ?? json['tableName'] ?? json['TableName'] ?? '',
      lastSyncAt: lastSyncAtRaw != null ? DateTime.parse(lastSyncAtRaw) : null,
      lastServerVersion:
          json['last_server_version'] ??
          json['lastServerVersion'] ??
          json['LastServerVersion'] ??
          0,
      createdAt: createdAtRaw != null
          ? DateTime.parse(createdAtRaw)
          : DateTime.now(),
      updatedAt: updatedAtRaw != null
          ? DateTime.parse(updatedAtRaw)
          : DateTime.now(),
    );
  }
}

/// Overall sync status response (matches backend SyncStatusResponse)
class SyncStatusResponse {
  final List<SyncLogDto> tables;

  SyncStatusResponse({required this.tables});

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) {
    final tablesJson = json['tables'] ?? json['Tables'] as List? ?? [];
    final tables = tablesJson
        .map((t) => SyncLogDto.fromJson(t as Map<String, dynamic>))
        .toList();
    return SyncStatusResponse(tables: tables);
  }
}

/// Sync operation result
class SyncResult {
  final bool success;
  final String? error;
  final int pushedCount;
  final int pulledCount;
  final int conflictCount;
  final Duration duration;

  /// Server-reported rejections of pushed records.
  final List<SyncConflict> conflicts;

  /// Records the server sent that could not be applied locally.
  ///
  /// A non-empty list means the sync did NOT fully succeed: the cursor is left
  /// where it was so these records are fetched again next time. Surfacing them
  /// is what stops a data error from being reported to the user as a clean sync.
  final List<SyncApplyFailure> applyFailures;

  SyncResult({
    required this.success,
    this.error,
    this.pushedCount = 0,
    this.pulledCount = 0,
    this.conflictCount = 0,
    this.duration = Duration.zero,
    this.conflicts = const [],
    this.applyFailures = const [],
  });

  /// True when some changes applied but at least one could not.
  bool get isPartial => applyFailures.isNotEmpty;

  /// Whether the durable cursor may be advanced after this result.
  bool get canAdvanceCursor => applyFailures.isEmpty;

  /// One-line, user-facing description of what went wrong, if anything.
  String? get userMessage {
    if (error != null) return error;
    if (applyFailures.isEmpty) return null;
    final first = applyFailures.first;
    final more = applyFailures.length - 1;
    final suffix = more > 0 ? ' (and $more more)' : '';
    return 'Some cloud records could not be saved on this device: '
        '${first.tableName} ${first.entityId} — ${first.reason}$suffix. '
        'They will be retried on the next sync.';
  }

  factory SyncResult.success({
    int pushedCount = 0,
    int pulledCount = 0,
    int conflictCount = 0,
    Duration duration = Duration.zero,
    List<SyncConflict> conflicts = const [],
  }) => SyncResult(
    success: true,
    pushedCount: pushedCount,
    pulledCount: pulledCount,
    conflictCount: conflictCount,
    duration: duration,
    conflicts: conflicts,
  );

  /// Some changes applied, at least one did not. Reported as NOT successful so
  /// callers — and the UI — cannot mistake it for a clean sync.
  factory SyncResult.partial({
    int pushedCount = 0,
    int pulledCount = 0,
    int conflictCount = 0,
    Duration duration = Duration.zero,
    List<SyncConflict> conflicts = const [],
    required List<SyncApplyFailure> applyFailures,
  }) => SyncResult(
    success: false,
    pushedCount: pushedCount,
    pulledCount: pulledCount,
    conflictCount: conflictCount,
    duration: duration,
    conflicts: conflicts,
    applyFailures: applyFailures,
  );

  factory SyncResult.failure(String error) =>
      SyncResult(success: false, error: error);
}

/// Enum for sync operation state (not to be confused with database SyncState table)
enum SyncOperationState { idle, syncing, success, error, offline }

// Note: SyncStatus constants are defined in app_database.dart
// Use those instead: SyncStatus.synced, SyncStatus.pendingCreate, etc.
