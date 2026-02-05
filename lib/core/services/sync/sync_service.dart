import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:drift/drift.dart';

/// Hybrid Sync Service
/// Handles local-first data with optional backend synchronization
/// Aligned with backend API endpoints:
/// - GET /sync/status
/// - GET /sync/pull?since={datetime}
/// - POST /sync/push
class SyncService {
  final ApiService _apiService;
  final AppDatabase _database;
  final Ref? _ref;
  final Logger _logger = Logger();

  // Sync state
  SyncOperationState _state = SyncOperationState.idle;
  SyncOperationState get state => _state;

  // Stream controller for sync state updates
  final _stateController = StreamController<SyncOperationState>.broadcast();
  Stream<SyncOperationState> get stateStream => _stateController.stream;

  // Last sync result
  SyncResult? _lastResult;
  SyncResult? get lastResult => _lastResult;

  // Last sync timestamp
  DateTime? _lastSyncAt;

  SyncService({
    required ApiService apiService,
    required AppDatabase database,
    Ref? ref,
  })  : _apiService = apiService,
        _database = database,
        _ref = ref;

  /// Check if device is online
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Full sync operation - pushes local changes, pulls remote changes
  /// Requires Premium subscription
  Future<SyncResult> syncAll() async {
    if (_state == SyncOperationState.syncing) {
      return SyncResult.failure('Sync already in progress');
    }

    // Check premium status - sync is a premium feature
    if (_ref != null) {
      final premiumState = _ref.read(premiumProvider);
      if (!premiumState.isPremium) {
        _setState(SyncOperationState.error);
        return SyncResult.failure('Cloud sync requires Premium subscription');
      }
    }

    final startTime = DateTime.now();
    _setState(SyncOperationState.syncing);

    // Check connectivity
    if (!await isOnline()) {
      _setState(SyncOperationState.offline);
      return SyncResult.failure('No internet connection');
    }

    // Check authentication
    if (!await _apiService.hasToken()) {
      _setState(SyncOperationState.error);
      return SyncResult.failure('Not authenticated');
    }

    int totalPushed = 0;
    int totalPulled = 0;
    int totalConflicts = 0;

    try {
      // Step 1: Push all local changes
      final pushResult = await _pushAllChanges();
      if (pushResult != null) {
        totalPushed = pushResult.appliedCount;
        totalConflicts = pushResult.conflicts.length;

        // Mark pushed records as synced
        await _markPushedRecordsAsSynced();
      }

      // Step 2: Pull all remote changes
      final pullResult = await _pullAllChanges();
      if (pullResult != null) {
        // Apply changes for each table
        for (final entry in pullResult.changes.entries) {
          final tableName = entry.key;
          final changes = entry.value;
          totalPulled += changes.length;

          for (final change in changes) {
            await _applyPulledChange(tableName, change);
          }
        }

        // Update last sync timestamp
        _lastSyncAt = DateTime.now();
      }

      final duration = DateTime.now().difference(startTime);
      _lastResult = SyncResult.success(
        pushedCount: totalPushed,
        pulledCount: totalPulled,
        conflictCount: totalConflicts,
        duration: duration,
      );

      _setState(SyncOperationState.success);
      _logger.i(
          'Sync completed: pushed=$totalPushed, pulled=$totalPulled, conflicts=$totalConflicts');

      return _lastResult!;
    } catch (e, stack) {
      _logger.e('Sync error: $e', error: e, stackTrace: stack);
      _setState(SyncOperationState.error);
      _lastResult = SyncResult.failure(e.toString());
      return _lastResult!;
    }
  }

  /// Push all pending local changes to server
  Future<SyncPushResponse?> _pushAllChanges() async {
    final allChanges = <SyncChange>[];

    // Collect pending changes from all tables
    allChanges.addAll(await _getPendingTransactionChanges());
    allChanges.addAll(await _getPendingWalletChanges());
    allChanges.addAll(await _getPendingCategoryChanges());
    allChanges.addAll(await _getPendingBudgetChanges());
    allChanges.addAll(await _getPendingObjectiveChanges());
    allChanges.addAll(await _getPendingPaymentMethodChanges());

    if (allChanges.isEmpty) {
      _logger.d('No pending changes to push');
      return null;
    }

    _logger.d('Pushing ${allChanges.length} changes');

    try {
      final response = await _apiService.post(
        '/sync/push',
        data: SyncPushRequest(changes: allChanges).toJson(),
      );
      return SyncPushResponse.fromJson(response.data);
    } catch (e) {
      _logger.e('Push failed: $e');
      rethrow;
    }
  }

  /// Pull all changes from server since last sync
  Future<SyncPullResponse?> _pullAllChanges() async {
    try {
      final queryParams = <String, dynamic>{};
      if (_lastSyncAt != null) {
        queryParams['since'] = _lastSyncAt!.toUtc().toIso8601String();
      }

      final response = await _apiService.get(
        '/sync/pull',
        queryParameters: queryParams,
      );
      return SyncPullResponse.fromJson(response.data);
    } catch (e) {
      _logger.e('Pull failed: $e');
      rethrow;
    }
  }

  // ==================== GET PENDING CHANGES ====================

  Future<List<SyncChange>> _getPendingTransactionChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(_database.transactions)
          ..where((t) => t.syncStatus.isBiggerThanValue(0)))
        .get();

    for (final r in records) {
      changes.add(SyncChange(
        tableName: 'transactions',
        entityId: r.id,
        operation: _getOperationFromStatus(r.syncStatus),
        data: _transactionToMap(r),
      ));
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingWalletChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(_database.wallets)
          ..where((w) => w.syncStatus.isBiggerThanValue(0)))
        .get();

    for (final r in records) {
      changes.add(SyncChange(
        tableName: 'wallets',
        entityId: r.id,
        operation: _getOperationFromStatus(r.syncStatus),
        data: _walletToMap(r),
      ));
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingCategoryChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(_database.categories)
          ..where((c) => c.syncStatus.isBiggerThanValue(0)))
        .get();

    for (final r in records) {
      changes.add(SyncChange(
        tableName: 'categories',
        entityId: r.id,
        operation: _getOperationFromStatus(r.syncStatus),
        data: _categoryToMap(r),
      ));
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingBudgetChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(_database.budgets)
          ..where((b) => b.syncStatus.isBiggerThanValue(0)))
        .get();

    for (final r in records) {
      changes.add(SyncChange(
        tableName: 'budgets',
        entityId: r.id,
        operation: _getOperationFromStatus(r.syncStatus),
        data: _budgetToMap(r),
      ));
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingObjectiveChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(_database.objectives)
          ..where((o) => o.syncStatus.isBiggerThanValue(0)))
        .get();

    for (final r in records) {
      changes.add(SyncChange(
        tableName: 'objectives',
        entityId: r.id,
        operation: _getOperationFromStatus(r.syncStatus),
        data: _objectiveToMap(r),
      ));
    }
    return changes;
  }

  Future<List<SyncChange>> _getPendingPaymentMethodChanges() async {
    final changes = <SyncChange>[];
    final records = await (_database.select(_database.paymentMethods)
          ..where((p) => p.syncStatus.isBiggerThanValue(0)))
        .get();

    for (final r in records) {
      changes.add(SyncChange(
        tableName: 'payment_methods',
        entityId: r.id,
        operation: _getOperationFromStatus(r.syncStatus),
        data: _paymentMethodToMap(r),
      ));
    }
    return changes;
  }

  // ==================== APPLY PULLED CHANGES ====================

  Future<void> _applyPulledChange(String tableName, SyncChange change) async {
    if (change.data == null && change.operation != 'delete') return;

    switch (tableName) {
      case 'transactions':
        await _applyTransactionChange(change);
        break;
      case 'wallets':
        await _applyWalletChange(change);
        break;
      case 'categories':
        await _applyCategoryChange(change);
        break;
      case 'budgets':
        await _applyBudgetChange(change);
        break;
      case 'objectives':
        await _applyObjectiveChange(change);
        break;
      case 'payment_methods':
        await _applyPaymentMethodChange(change);
        break;
    }
  }

  Future<void> _applyTransactionChange(SyncChange change) async {
    final data = change.data;
    if (change.operation == 'delete') {
      await (_database.update(_database.transactions)
            ..where((t) => t.id.equals(change.entityId)))
          .write(TransactionsCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(SyncStatus.synced),
          ));
      return;
    }

    if (data == null) return;

    // Check if record exists
    final existing = await (_database.select(_database.transactions)
          ..where((t) => t.id.equals(change.entityId)))
        .getSingleOrNull();

    final companion = TransactionsCompanion(
      id: Value(change.entityId),
      amount: Value((data['Amount'] as num?)?.toDouble() ?? 0.0),
      title: Value(data['Title'] ?? ''),
      notes: Value(data['Notes']),
      date: Value(data['Date'] != null
          ? DateTime.parse(data['Date'])
          : DateTime.now()),
      isIncome: Value(data['IsIncome'] ?? false),
      transactionType: Value(_parseTransactionType(data['Type'])),
      specialType: Value(data['SpecialType'] ?? 0),
      walletId: Value(data['WalletId'] ?? ''),
      categoryId: Value(data['CategoryId']),
      paymentMethodId: Value(data['PaymentMethodId']),
      isPaid: Value(data['IsPaid'] ?? true),
      paidAmount: Value((data['PaidAmount'] as num?)?.toDouble() ?? 0.0),
      budgetId: Value(data['BudgetId']),
      objectiveId: Value(data['ObjectiveId']),
      receiptImageUrl: Value(data['ReceiptImageUrl']),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.transactions)
            ..where((t) => t.id.equals(change.entityId)))
          .write(companion);
    } else {
      await _database.into(_database.transactions).insert(companion);
    }
  }

  Future<void> _applyWalletChange(SyncChange change) async {
    final data = change.data;
    if (change.operation == 'delete') {
      await (_database.update(_database.wallets)
            ..where((w) => w.id.equals(change.entityId)))
          .write(WalletsCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(SyncStatus.synced),
          ));
      return;
    }

    if (data == null) return;

    final existing = await (_database.select(_database.wallets)
          ..where((w) => w.id.equals(change.entityId)))
        .getSingleOrNull();

    final companion = WalletsCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['Icon'] ?? data['IconName'] ?? 'wallet'),
      color: Value(data['Color'] ?? '#6366F1'),
      currency: Value(data['Currency'] ?? 'USD'),
      balance: Value((data['Balance'] as num?)?.toDouble() ?? 0.0),
      isDefault: Value(data['IsDefault'] ?? false),
      walletType: Value(data['WalletType'] ?? 0),
      creditLimit: Value((data['CreditLimit'] as num?)?.toDouble()),
      billingCycleDay: Value(data['BillingCycleDay'] as int?),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.wallets)
            ..where((w) => w.id.equals(change.entityId)))
          .write(companion);
    } else {
      await _database.into(_database.wallets).insert(companion);
    }
  }

  Future<void> _applyCategoryChange(SyncChange change) async {
    final data = change.data;
    if (change.operation == 'delete') {
      await (_database.update(_database.categories)
            ..where((c) => c.id.equals(change.entityId)))
          .write(CategoriesCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(SyncStatus.synced),
          ));
      return;
    }

    if (data == null) return;

    final existing = await (_database.select(_database.categories)
          ..where((c) => c.id.equals(change.entityId)))
        .getSingleOrNull();

    final companion = CategoriesCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['Icon'] ?? 'category'),
      color: Value(data['Color'] ?? '#6366F1'),
      isIncome: Value(data['IsIncome'] ?? false),
      mainCategoryId: Value(data['ParentCategoryId']),
      orderIndex: Value(data['OrderIndex'] ?? 0),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.categories)
            ..where((c) => c.id.equals(change.entityId)))
          .write(companion);
    } else {
      await _database.into(_database.categories).insert(companion);
    }
  }

  Future<void> _applyBudgetChange(SyncChange change) async {
    final data = change.data;
    if (change.operation == 'delete') {
      await (_database.update(_database.budgets)
            ..where((b) => b.id.equals(change.entityId)))
          .write(BudgetsCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(SyncStatus.synced),
          ));
      return;
    }

    if (data == null) return;

    final existing = await (_database.select(_database.budgets)
          ..where((b) => b.id.equals(change.entityId)))
        .getSingleOrNull();

    final companion = BudgetsCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      amount: Value((data['Amount'] as num?)?.toDouble() ?? 0.0),
      period: Value(_parseBudgetPeriod(data['Period'])),
      startDate: Value(data['StartDate'] != null
          ? DateTime.parse(data['StartDate'])
          : DateTime.now()),
      endDate: Value(
          data['EndDate'] != null ? DateTime.parse(data['EndDate']) : null),
      walletIds: Value(data['WalletIds']),
      categoryIds: Value(data['CategoryIds']),
      isIncome: Value(data['IsIncome'] ?? false),
      isPinned: Value(data['IsPinned'] ?? false),
      isArchived: Value(data['IsArchived'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.budgets)
            ..where((b) => b.id.equals(change.entityId)))
          .write(companion);
    } else {
      await _database.into(_database.budgets).insert(companion);
    }
  }

  Future<void> _applyObjectiveChange(SyncChange change) async {
    final data = change.data;
    if (change.operation == 'delete') {
      await (_database.update(_database.objectives)
            ..where((o) => o.id.equals(change.entityId)))
          .write(ObjectivesCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(SyncStatus.synced),
          ));
      return;
    }

    if (data == null) return;

    final existing = await (_database.select(_database.objectives)
          ..where((o) => o.id.equals(change.entityId)))
        .getSingleOrNull();

    final companion = ObjectivesCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['Icon'] ?? 'flag'),
      color: Value(data['Color'] ?? '#6366F1'),
      targetAmount: Value((data['TargetAmount'] as num?)?.toDouble() ?? 0.0),
      type: Value(_parseObjectiveType(data['Type'])),
      walletId: Value(data['WalletId']),
      startDate: Value(data['StartDate'] != null
          ? DateTime.parse(data['StartDate'])
          : DateTime.now()),
      endDate: Value(
          data['EndDate'] != null ? DateTime.parse(data['EndDate']) : null),
      isPinned: Value(data['IsPinned'] ?? false),
      isArchived: Value(data['IsArchived'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.objectives)
            ..where((o) => o.id.equals(change.entityId)))
          .write(companion);
    } else {
      await _database.into(_database.objectives).insert(companion);
    }
  }

  Future<void> _applyPaymentMethodChange(SyncChange change) async {
    final data = change.data;
    if (change.operation == 'delete') {
      await (_database.update(_database.paymentMethods)
            ..where((p) => p.id.equals(change.entityId)))
          .write(PaymentMethodsCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(SyncStatus.synced),
          ));
      return;
    }

    if (data == null) return;

    final existing = await (_database.select(_database.paymentMethods)
          ..where((p) => p.id.equals(change.entityId)))
        .getSingleOrNull();

    final companion = PaymentMethodsCompanion(
      id: Value(change.entityId),
      name: Value(data['Name'] ?? ''),
      iconName: Value(data['Icon'] ?? 'credit_card'),
      isDefault: Value(data['IsDefault'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.paymentMethods)
            ..where((p) => p.id.equals(change.entityId)))
          .write(companion);
    } else {
      await _database.into(_database.paymentMethods).insert(companion);
    }
  }

  // ==================== CONVERSION HELPERS ====================

  String _getOperationFromStatus(int status) {
    switch (status) {
      case SyncStatus.pendingCreate:
        return 'create';
      case SyncStatus.pendingUpdate:
        return 'update';
      case SyncStatus.pendingDelete:
        return 'delete';
      default:
        return 'update';
    }
  }

  String _parseTransactionType(dynamic type) {
    if (type is int) {
      switch (type) {
        case 0:
          return 'regular';
        case 1:
          return 'transfer';
        case 2:
          return 'recurringInstance';
        default:
          return 'regular';
      }
    }
    return type?.toString() ?? 'regular';
  }

  String _parseBudgetPeriod(dynamic period) {
    if (period is int) {
      switch (period) {
        case 0:
          return 'daily';
        case 1:
          return 'weekly';
        case 2:
          return 'biweekly';
        case 3:
          return 'monthly';
        case 4:
          return 'yearly';
        case 5:
          return 'custom';
        default:
          return 'monthly';
      }
    }
    return period?.toString() ?? 'monthly';
  }

  String _parseObjectiveType(dynamic type) {
    if (type is int) {
      switch (type) {
        case 0:
          return 'goal';
        case 1:
          return 'loan';
        default:
          return 'goal';
      }
    }
    return type?.toString() ?? 'goal';
  }

  // ==================== MAP CONVERSIONS FOR PUSH ====================

  Map<String, dynamic> _transactionToMap(Transaction t) => {
        'WalletId': t.walletId,
        'CategoryId': t.categoryId,
        'PaymentMethodId': t.paymentMethodId,
        'Amount': t.amount,
        'Title': t.title,
        'Notes': t.notes,
        'Date': t.date.toUtc().toIso8601String(),
        'IsIncome': t.isIncome,
        'Type': _transactionTypeToInt(t.transactionType),
        'SpecialType': t.specialType,
        'IsPaid': t.isPaid,
        'OriginalDueDate': t.originalDueDate?.toUtc().toIso8601String(),
        'SkipPaid': t.skipPaid,
        'PaidAmount': t.paidAmount,
        'PairedTransactionId': t.pairedTransactionId,
        'RecurringConfigId': t.recurringConfigId,
        'BudgetId': t.budgetId,
        'ObjectiveId': t.objectiveId,
        'ReceiptImageUrl': t.receiptImageUrl,
      };

  Map<String, dynamic> _walletToMap(Wallet w) => {
        'Name': w.name,
        'Balance': w.balance,
        'Currency': w.currency,
        'Color': w.color,
        'IconName': w.iconName,
        'IsDefault': w.isDefault,
        'WalletType': w.walletType.index,
        'CreditLimit': w.creditLimit,
        'BillingCycleDay': w.billingCycleDay,
      };

  Map<String, dynamic> _categoryToMap(Category c) => {
        'Name': c.name,
        'Color': c.color,
        'IconName': c.iconName,
        'IsIncome': c.isIncome,
        'MainCategoryId': c.mainCategoryId,
        'OrderIndex': c.orderIndex,
      };

  Map<String, dynamic> _budgetToMap(Budget b) => {
        'Name': b.name,
        'Amount': b.amount,
        'StartDate': b.startDate.toUtc().toIso8601String(),
        'EndDate': b.endDate?.toUtc().toIso8601String(),
        'Period': _budgetPeriodToInt(b.period),
        'WalletIds': b.walletIds,
        'CategoryIds': b.categoryIds,
        'IsIncome': b.isIncome,
        'IsPinned': b.isPinned,
        'IsArchived': b.isArchived,
      };

  Map<String, dynamic> _objectiveToMap(Objective o) => {
        'Name': o.name,
        'TargetAmount': o.targetAmount,
        'WalletId': o.walletId,
        'IconName': o.iconName,
        'Color': o.color,
        'Type': _objectiveTypeToInt(o.type),
        'StartDate': o.startDate.toUtc().toIso8601String(),
        'EndDate': o.endDate?.toUtc().toIso8601String(),
        'IsPinned': o.isPinned,
        'IsArchived': o.isArchived,
      };

  Map<String, dynamic> _paymentMethodToMap(PaymentMethod p) => {
        'Name': p.name,
        'IconName': p.iconName,
        'IsDefault': p.isDefault,
      };

  int _transactionTypeToInt(String type) {
    switch (type.toLowerCase()) {
      case 'transfer':
        return 1;
      case 'recurringinstance':
        return 2;
      default:
        return 0;
    }
  }

  int _budgetPeriodToInt(String period) {
    switch (period.toLowerCase()) {
      case 'daily':
        return 0;
      case 'weekly':
        return 1;
      case 'biweekly':
        return 2;
      case 'monthly':
        return 3;
      case 'yearly':
        return 4;
      case 'custom':
        return 5;
      default:
        return 3;
    }
  }

  int _objectiveTypeToInt(String type) {
    switch (type.toLowerCase()) {
      case 'loan':
        return 1;
      default:
        return 0;
    }
  }

  /// Mark all pending records as synced after successful push
  Future<void> _markPushedRecordsAsSynced() async {
    await (_database.update(_database.transactions)
          ..where((t) => t.syncStatus.isBiggerThanValue(0)))
        .write(const TransactionsCompanion(syncStatus: Value(SyncStatus.synced)));

    await (_database.update(_database.wallets)
          ..where((w) => w.syncStatus.isBiggerThanValue(0)))
        .write(const WalletsCompanion(syncStatus: Value(SyncStatus.synced)));

    await (_database.update(_database.categories)
          ..where((c) => c.syncStatus.isBiggerThanValue(0)))
        .write(const CategoriesCompanion(syncStatus: Value(SyncStatus.synced)));

    await (_database.update(_database.budgets)
          ..where((b) => b.syncStatus.isBiggerThanValue(0)))
        .write(const BudgetsCompanion(syncStatus: Value(SyncStatus.synced)));

    await (_database.update(_database.objectives)
          ..where((o) => o.syncStatus.isBiggerThanValue(0)))
        .write(const ObjectivesCompanion(syncStatus: Value(SyncStatus.synced)));

    await (_database.update(_database.paymentMethods)
          ..where((p) => p.syncStatus.isBiggerThanValue(0)))
        .write(const PaymentMethodsCompanion(syncStatus: Value(SyncStatus.synced)));
  }

  /// Update sync state
  void _setState(SyncOperationState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  /// Get sync status from server
  Future<SyncStatusResponse?> getServerSyncStatus() async {
    if (!await isOnline()) return null;

    try {
      final response = await _apiService.get('/sync/status');
      return SyncStatusResponse.fromJson(response.data);
    } catch (e) {
      _logger.e('Failed to get sync status: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _stateController.close();
  }
}
