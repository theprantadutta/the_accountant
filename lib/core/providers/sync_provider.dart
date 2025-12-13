import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// Provider for the SyncService instance
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final apiService = ApiService();

  final service = SyncService(
    apiService: apiService,
    database: database,
  );

  ref.onDispose(() => service.dispose());

  return service;
});

/// State notifier for sync operations
class SyncNotifier extends Notifier<SyncOperationState> {
  StreamSubscription<SyncOperationState>? _subscription;

  @override
  SyncOperationState build() {
    // Listen to sync service state changes
    final syncService = ref.watch(syncServiceProvider);

    _subscription?.cancel();
    _subscription = syncService.stateStream.listen((newState) {
      state = newState;
    });

    ref.onDispose(() => _subscription?.cancel());

    return syncService.state;
  }

  /// Trigger a full sync
  Future<SyncResult> syncAll() async {
    final syncService = ref.read(syncServiceProvider);
    return await syncService.syncAll();
  }

  /// Sync a specific table
  Future<SyncResult> syncTable(String tableName) async {
    final syncService = ref.read(syncServiceProvider);
    return await syncService.syncTable(tableName);
  }

  /// Check if device is online
  Future<bool> isOnline() async {
    final syncService = ref.read(syncServiceProvider);
    return await syncService.isOnline();
  }

  /// Get server sync status
  Future<SyncStatusResponse?> getServerStatus() async {
    final syncService = ref.read(syncServiceProvider);
    return await syncService.getServerSyncStatus();
  }

  /// Get last sync result
  SyncResult? get lastResult {
    final syncService = ref.read(syncServiceProvider);
    return syncService.lastResult;
  }
}

/// Provider for sync notifier
final syncNotifierProvider =
    NotifierProvider<SyncNotifier, SyncOperationState>(SyncNotifier.new);

/// Provider to track if sync is in progress
final isSyncingProvider = Provider<bool>((ref) {
  final state = ref.watch(syncNotifierProvider);
  return state == SyncOperationState.syncing;
});

/// Provider to check if device is online
final isOnlineProvider = FutureProvider<bool>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return await syncService.isOnline();
});
