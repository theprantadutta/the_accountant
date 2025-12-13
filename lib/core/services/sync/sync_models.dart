// Data models for synchronization operations

/// Represents a single change to be synced
class SyncChange {
  final String id;
  final String action; // 'create', 'update', 'delete'
  final String? serverId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  SyncChange({
    required this.id,
    required this.action,
    this.serverId,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'action': action,
    'server_id': serverId,
    'data': data,
  };

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
    id: json['id'],
    action: json['action'],
    serverId: json['server_id'],
    data: json['data'] ?? {},
    timestamp: DateTime.now(),
  );
}

/// Request to push local changes to server
class SyncPushRequest {
  final String table;
  final List<SyncChange> changes;
  final int clientVersion;

  SyncPushRequest({
    required this.table,
    required this.changes,
    required this.clientVersion,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'changes': changes.map((c) => c.toJson()).toList(),
    'client_version': clientVersion,
  };
}

/// Response from push operation
class SyncPushResponse {
  final int serverVersion;
  final List<String> accepted;
  final List<SyncConflict> conflicts;
  final Map<String, String> idMapping;

  SyncPushResponse({
    required this.serverVersion,
    required this.accepted,
    required this.conflicts,
    required this.idMapping,
  });

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) => SyncPushResponse(
    serverVersion: json['server_version'] ?? 0,
    accepted: List<String>.from(json['accepted'] ?? []),
    conflicts: (json['conflicts'] as List?)
        ?.map((c) => SyncConflict.fromJson(c))
        .toList() ?? [],
    idMapping: Map<String, String>.from(json['id_mapping'] ?? {}),
  );
}

/// Request to pull changes from server
class SyncPullRequest {
  final String table;
  final int sinceVersion;

  SyncPullRequest({
    required this.table,
    required this.sinceVersion,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'since_version': sinceVersion,
  };
}

/// Response from pull operation
class SyncPullResponse {
  final List<Map<String, dynamic>> changes;
  final int serverVersion;
  final bool hasMore;

  SyncPullResponse({
    required this.changes,
    required this.serverVersion,
    required this.hasMore,
  });

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) => SyncPullResponse(
    changes: List<Map<String, dynamic>>.from(json['changes'] ?? []),
    serverVersion: json['server_version'] ?? 0,
    hasMore: json['has_more'] ?? false,
  );
}

/// Represents a sync conflict
class SyncConflict {
  final String clientId;
  final String? serverId;
  final Map<String, dynamic> clientData;
  final Map<String, dynamic> serverData;
  final String conflictType;

  SyncConflict({
    required this.clientId,
    this.serverId,
    required this.clientData,
    required this.serverData,
    required this.conflictType,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) => SyncConflict(
    clientId: json['client_id'],
    serverId: json['server_id'],
    clientData: Map<String, dynamic>.from(json['client_data'] ?? {}),
    serverData: Map<String, dynamic>.from(json['server_data'] ?? {}),
    conflictType: json['conflict_type'] ?? 'unknown',
  );
}

/// Sync status for a table
class TableSyncStatus {
  final String tableName;
  final int version;
  final int count;
  final DateTime? lastSync;

  TableSyncStatus({
    required this.tableName,
    required this.version,
    required this.count,
    this.lastSync,
  });

  factory TableSyncStatus.fromJson(String name, Map<String, dynamic> json) => TableSyncStatus(
    tableName: name,
    version: json['version'] ?? 0,
    count: json['count'] ?? 0,
    lastSync: json['last_sync'] != null ? DateTime.parse(json['last_sync']) : null,
  );
}

/// Overall sync status response
class SyncStatusResponse {
  final Map<String, TableSyncStatus> tables;

  SyncStatusResponse({required this.tables});

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) {
    final tablesJson = json['tables'] as Map<String, dynamic>? ?? {};
    final tables = <String, TableSyncStatus>{};

    tablesJson.forEach((key, value) {
      tables[key] = TableSyncStatus.fromJson(key, value);
    });

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
