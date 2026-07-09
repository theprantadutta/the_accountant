// Data models for synchronization operations
// Aligned with backend API: TheAccountant.Application.Features.Sync.DTOs

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

  SyncChange({
    required this.tableName,
    required this.entityId,
    required this.operation,
    this.data,
    this.sourceUpdatedAt,
  });

  Map<String, dynamic> toJson() => {
    'table_name': tableName,
    'entity_id': entityId,
    'operation': operation,
    'data': data,
  };

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
    tableName:
        json['table_name'] ?? json['tableName'] ?? json['TableName'] ?? '',
    entityId: json['entity_id'] ?? json['entityId'] ?? json['EntityId'] ?? '',
    operation: json['operation'] ?? json['Operation'] ?? '',
    data: json['data'] ?? json['Data'],
  );
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

  SyncPushResponse({required this.appliedCount, required this.conflicts});

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    final conflictsList = json['conflicts'] ?? json['Conflicts'];
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
    );
  }
}

/// Response from pull operation (matches backend SyncPullResponse)
class SyncPullResponse {
  final Map<String, List<SyncChange>> changes;
  final Map<String, int> currentVersions;

  /// Server clock at the start of this pull; used as the `since` cursor for the next pull.
  final DateTime? serverTime;

  SyncPullResponse({
    required this.changes,
    required this.currentVersions,
    this.serverTime,
  });

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

    return SyncPullResponse(
      changes: changes,
      currentVersions: versions,
      serverTime: serverTime,
    );
  }
}

/// Represents a sync conflict (matches backend SyncConflict)
class SyncConflict {
  final String tableName;
  final String entityId;
  final String reason;

  SyncConflict({
    required this.tableName,
    required this.entityId,
    required this.reason,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) => SyncConflict(
    tableName:
        json['table_name'] ?? json['tableName'] ?? json['TableName'] ?? '',
    entityId: json['entity_id'] ?? json['entityId'] ?? json['EntityId'] ?? '',
    reason: json['reason'] ?? json['Reason'] ?? '',
  );
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

  SyncResult({
    required this.success,
    this.error,
    this.pushedCount = 0,
    this.pulledCount = 0,
    this.conflictCount = 0,
    this.duration = Duration.zero,
  });

  factory SyncResult.success({
    int pushedCount = 0,
    int pulledCount = 0,
    int conflictCount = 0,
    Duration duration = Duration.zero,
  }) => SyncResult(
    success: true,
    pushedCount: pushedCount,
    pulledCount: pulledCount,
    conflictCount: conflictCount,
    duration: duration,
  );

  factory SyncResult.failure(String error) =>
      SyncResult(success: false, error: error);
}

/// Enum for sync operation state (not to be confused with database SyncState table)
enum SyncOperationState { idle, syncing, success, error, offline }

// Note: SyncStatus constants are defined in app_database.dart
// Use those instead: SyncStatus.synced, SyncStatus.pendingCreate, etc.
