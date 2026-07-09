import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_accountant/core/providers/connectivity_provider.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';

/// Provider for the SyncService instance
final syncServiceProvider = Provider<SyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final apiService = ApiService();

  final service = SyncService(
    apiService: apiService,
    database: database,
    ref: ref,
  );

  ref.onDispose(() => service.dispose());

  return service;
});

/// State notifier for sync operations
class SyncNotifier extends Notifier<SyncOperationState> {
  StreamSubscription<SyncOperationState>? _subscription;
  Timer? _periodicSyncTimer;

  bool _wasOnline = true;

  @override
  SyncOperationState build() {
    // Listen to sync service state changes
    final syncService = ref.watch(syncServiceProvider);

    _subscription?.cancel();
    _subscription = syncService.stateStream.listen((newState) {
      state = newState;
    });

    // Auto-sync when connectivity transitions from offline to online
    ref.listen<bool>(isOnlineProvider, (previous, next) {
      final wasOffline = previous == false || !_wasOnline;
      _wasOnline = next;
      if (wasOffline && next) {
        debugPrint(
          '[SyncNotifier] Connectivity restored, triggering auto-sync',
        );
        triggerAutoSync();
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
      _periodicSyncTimer?.cancel();
    });

    return syncService.state;
  }

  /// Trigger a full sync
  Future<SyncResult> syncAll() async {
    final syncService = ref.read(syncServiceProvider);
    final result = await syncService.syncAll();

    // Refresh all data providers so UI reflects pulled changes
    if (result.success && (result.pulledCount > 0 || result.pushedCount > 0)) {
      _refreshDataProviders();
    }

    return result;
  }

  /// Silently reload all data providers after sync changes the database.
  /// Uses silent mode so no loading indicators flash in the UI.
  void _refreshDataProviders() {
    ref.read(walletProvider.notifier).loadWallets(silent: true);
    ref.read(categoryProvider.notifier).loadCategories(silent: true);
    ref.read(transactionProvider.notifier).loadTransactions(silent: true);
    ref.read(paymentMethodProvider.notifier).loadPaymentMethods(silent: true);
    ref.read(budgetProvider.notifier).loadBudgets(silent: true);
    ref.read(financialDataProvider.notifier).loadFinancialData(silent: true);
  }

  /// Trigger auto-sync silently (catches errors)
  Future<void> triggerAutoSync() async {
    try {
      await syncAll();
    } catch (e) {
      debugPrint('Auto sync failed: $e');
    }
  }

  /// Start periodic sync timer (every 15 minutes)
  void startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => triggerAutoSync(),
    );
  }

  /// Stop periodic sync timer
  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
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
final syncNotifierProvider = NotifierProvider<SyncNotifier, SyncOperationState>(
  SyncNotifier.new,
);

/// Provider to track if sync is in progress
final isSyncingProvider = Provider<bool>((ref) {
  final state = ref.watch(syncNotifierProvider);
  return state == SyncOperationState.syncing;
});
