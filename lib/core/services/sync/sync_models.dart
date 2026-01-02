// Data models for synchronization operations
// Aligned with backend API: TheAccountant.Application.Features.Sync.DTOs

/// Represents a single change to be synced (matches backend SyncChange)
class SyncChange {
  final String tableName;
  final String entityId;
  final String operation; // 'create', 'update', 'delete'
  final Map<String, dynamic>? data;

  SyncChange({
    required this.tableName,
    required this.entityId,
    required this.operation,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        'tableName': tableName,
        'entityId': entityId,
        'operation': operation,
        'data': data,
      };

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
        tableName: json['tableName'] ?? json['TableName'] ?? '',
        entityId: json['entityId'] ?? json['EntityId'] ?? '',
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

  SyncPushResponse({
    required this.appliedCount,
    required this.conflicts,
  });

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) =>
      SyncPushResponse(
        appliedCount: json['appliedCount'] ?? json['AppliedCount'] ?? 0,
        conflicts: (json['conflicts'] ?? json['Conflicts'] as List?)
                ?.map((c) => SyncConflict.fromJson(c))
                .toList() ??
            [],
      );
}

/// Response from pull operation (matches backend SyncPullResponse)
class SyncPullResponse {
  final Map<String, List<SyncChange>> changes;
  final Map<String, int> currentVersions;

  SyncPullResponse({
    required this.changes,
    required this.currentVersions,
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

    final versionsJson = json['currentVersions'] ??
        json['CurrentVersions'] as Map<String, dynamic>? ??
        {};
    final versions = <String, int>{};
    versionsJson.forEach((key, value) {
      versions[key] = value as int? ?? 0;
    });

    return SyncPullResponse(
      changes: changes,
      currentVersions: versions,
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
        tableName: json['tableName'] ?? json['TableName'] ?? '',
        entityId: json['entityId'] ?? json['EntityId'] ?? '',
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

  factory SyncLogDto.fromJson(Map<String, dynamic> json) => SyncLogDto(
        id: json['id'] ?? json['Id'] ?? '',
        userId: json['userId'] ?? json['UserId'] ?? '',
        tableName: json['tableName'] ?? json['TableName'] ?? '',
        lastSyncAt: json['lastSyncAt'] ?? json['LastSyncAt'] != null
            ? DateTime.parse(json['lastSyncAt'] ?? json['LastSyncAt'])
            : null,
        lastServerVersion:
            json['lastServerVersion'] ?? json['LastServerVersion'] ?? 0,
        createdAt: json['createdAt'] ?? json['CreatedAt'] != null
            ? DateTime.parse(json['createdAt'] ?? json['CreatedAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] ?? json['UpdatedAt'] != null
            ? DateTime.parse(json['updatedAt'] ?? json['UpdatedAt'])
            : DateTime.now(),
      );
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
  }) =>
      SyncResult(
        success: true,
        pushedCount: pushedCount,
        pulledCount: pulledCount,
        conflictCount: conflictCount,
        duration: duration,
      );

  factory SyncResult.failure(String error) => SyncResult(
        success: false,
        error: error,
      );
}

/// Enum for sync operation state (not to be confused with database SyncState table)
enum SyncOperationState {
  idle,
  syncing,
  success,
  error,
  offline,
}

// Note: SyncStatus constants are defined in app_database.dart
// Use those instead: SyncStatus.synced, SyncStatus.pendingCreate, etc.
