import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart';

/// Hybrid Sync Service
/// Handles local-first data with optional backend synchronization
class SyncService {
  final ApiService _apiService;
  final AppDatabase _database;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  // Sync state
  SyncOperationState _state = SyncOperationState.idle;
  SyncOperationState get state => _state;

  // Stream controller for sync state updates
  final _stateController = StreamController<SyncOperationState>.broadcast();
  Stream<SyncOperationState> get stateStream => _stateController.stream;

  // Last sync result
  SyncResult? _lastResult;
  SyncResult? get lastResult => _lastResult;

  // Sync order - respects foreign key dependencies
  static const List<String> syncOrder = [
    'categories',
    'wallets',
    'payment_methods',
    'transactions',
    'recurring_configs',
    'budgets',
    'objectives',
    'associated_titles',
  ];

  SyncService({
    required ApiService apiService,
    required AppDatabase database,
  })  : _apiService = apiService,
        _database = database;

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
  Future<SyncResult> syncAll() async {
    if (_state == SyncOperationState.syncing) {
      return SyncResult.failure('Sync already in progress');
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
      // Sync each table in order
      for (final tableName in syncOrder) {
        _logger.d('Syncing table: $tableName');

        // Push local changes
        final pushResult = await _pushChanges(tableName);
        if (pushResult != null) {
          totalPushed += pushResult.accepted.length;
          totalConflicts += pushResult.conflicts.length;

          // Handle ID mappings for new records
          await _applyIdMappings(tableName, pushResult.idMapping);

          // Handle conflicts (last-write-wins by default)
          await _resolveConflicts(tableName, pushResult.conflicts);
        }

        // Pull remote changes
        final pullResult = await _pullChanges(tableName);
        if (pullResult != null) {
          totalPulled += pullResult.changes.length;
          await _applyPulledChanges(tableName, pullResult.changes);
          await _database.updateSyncState(tableName, pullResult.serverVersion);
        }

        // Mark table as synced
        await _database.markTableAsSynced(tableName);
      }

      final duration = DateTime.now().difference(startTime);
      _lastResult = SyncResult.success(
        pushedCount: totalPushed,
        pulledCount: totalPulled,
        conflictCount: totalConflicts,
        duration: duration,
      );

      _setState(SyncOperationState.success);
      _logger.i('Sync completed: pushed=$totalPushed, pulled=$totalPulled, conflicts=$totalConflicts');

      return _lastResult!;
    } catch (e, stack) {
      _logger.e('Sync error: $e', error: e, stackTrace: stack);
      _setState(SyncOperationState.error);
      _lastResult = SyncResult.failure(e.toString());
      return _lastResult!;
    }
  }

  /// Sync a single table
  Future<SyncResult> syncTable(String tableName) async {
    if (!syncOrder.contains(tableName)) {
      return SyncResult.failure('Unknown table: $tableName');
    }

    if (_state == SyncOperationState.syncing) {
      return SyncResult.failure('Sync already in progress');
    }

    _setState(SyncOperationState.syncing);

    if (!await isOnline()) {
      _setState(SyncOperationState.offline);
      return SyncResult.failure('No internet connection');
    }

    try {
      // Push changes
      final pushResult = await _pushChanges(tableName);
      int pushed = 0;
      int conflicts = 0;

      if (pushResult != null) {
        pushed = pushResult.accepted.length;
        conflicts = pushResult.conflicts.length;
        await _applyIdMappings(tableName, pushResult.idMapping);
        await _resolveConflicts(tableName, pushResult.conflicts);
      }

      // Pull changes
      final pullResult = await _pullChanges(tableName);
      int pulled = 0;

      if (pullResult != null) {
        pulled = pullResult.changes.length;
        await _applyPulledChanges(tableName, pullResult.changes);
        await _database.updateSyncState(tableName, pullResult.serverVersion);
      }

      await _database.markTableAsSynced(tableName);

      _setState(SyncOperationState.success);
      return SyncResult.success(
        pushedCount: pushed,
        pulledCount: pulled,
        conflictCount: conflicts,
      );
    } catch (e) {
      _setState(SyncOperationState.error);
      return SyncResult.failure(e.toString());
    }
  }

  /// Push local changes to server
  Future<SyncPushResponse?> _pushChanges(String tableName) async {
    final changes = await _getPendingChanges(tableName);
    if (changes.isEmpty) {
      _logger.d('No pending changes for $tableName');
      return null;
    }

    final syncState = await _database.getSyncStateForTable(tableName);
    final clientVersion = syncState?.lastServerVersion ?? 0;

    final request = SyncPushRequest(
      table: tableName,
      changes: changes,
      clientVersion: clientVersion,
    );

    try {
      final response = await _apiService.post(
        '/sync/push',
        data: request.toJson(),
      );
      return SyncPushResponse.fromJson(response.data);
    } catch (e) {
      _logger.e('Push failed for $tableName: $e');
      rethrow;
    }
  }

  /// Pull changes from server
  Future<SyncPullResponse?> _pullChanges(String tableName) async {
    final syncState = await _database.getSyncStateForTable(tableName);
    final sinceVersion = syncState?.lastServerVersion ?? 0;

    final request = SyncPullRequest(
      table: tableName,
      sinceVersion: sinceVersion,
    );

    try {
      final response = await _apiService.post(
        '/sync/pull',
        data: request.toJson(),
      );
      return SyncPullResponse.fromJson(response.data);
    } catch (e) {
      _logger.e('Pull failed for $tableName: $e');
      rethrow;
    }
  }

  /// Get pending changes for a table
  Future<List<SyncChange>> _getPendingChanges(String tableName) async {
    final changes = <SyncChange>[];

    switch (tableName) {
      case 'categories':
        final records = await (_database.select(_database.categories)
              ..where((c) => c.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _categoryToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'wallets':
        final records = await (_database.select(_database.wallets)
              ..where((w) => w.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _walletToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'transactions':
        final records = await (_database.select(_database.transactions)
              ..where((t) => t.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _transactionToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'budgets':
        final records = await (_database.select(_database.budgets)
              ..where((b) => b.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _budgetToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'objectives':
        final records = await (_database.select(_database.objectives)
              ..where((o) => o.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _objectiveToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'recurring_configs':
        final records = await (_database.select(_database.recurringConfigs)
              ..where((rc) => rc.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _recurringConfigToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'payment_methods':
        final records = await (_database.select(_database.paymentMethods)
              ..where((pm) => pm.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _paymentMethodToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;

      case 'associated_titles':
        final records = await (_database.select(_database.associatedTitles)
              ..where((at) => at.syncStatus.isBiggerThanValue(0)))
            .get();
        for (final r in records) {
          changes.add(SyncChange(
            id: r.id,
            action: _getActionFromStatus(r.syncStatus),
            serverId: r.serverId,
            data: _associatedTitleToMap(r),
            timestamp: r.updatedAt ?? DateTime.now(),
          ));
        }
        break;
    }

    return changes;
  }

  /// Convert sync status to action string
  String _getActionFromStatus(int status) {
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

  /// Apply ID mappings after push (for newly created records)
  Future<void> _applyIdMappings(String tableName, Map<String, String> mappings) async {
    if (mappings.isEmpty) return;

    for (final entry in mappings.entries) {
      final localId = entry.key;
      final serverId = entry.value;

      switch (tableName) {
        case 'categories':
          await (_database.update(_database.categories)
                ..where((c) => c.id.equals(localId)))
              .write(CategoriesCompanion(serverId: Value(serverId)));
          break;
        case 'wallets':
          await (_database.update(_database.wallets)
                ..where((w) => w.id.equals(localId)))
              .write(WalletsCompanion(serverId: Value(serverId)));
          break;
        case 'transactions':
          await (_database.update(_database.transactions)
                ..where((t) => t.id.equals(localId)))
              .write(TransactionsCompanion(serverId: Value(serverId)));
          break;
        case 'budgets':
          await (_database.update(_database.budgets)
                ..where((b) => b.id.equals(localId)))
              .write(BudgetsCompanion(serverId: Value(serverId)));
          break;
        case 'objectives':
          await (_database.update(_database.objectives)
                ..where((o) => o.id.equals(localId)))
              .write(ObjectivesCompanion(serverId: Value(serverId)));
          break;
        case 'recurring_configs':
          await (_database.update(_database.recurringConfigs)
                ..where((r) => r.id.equals(localId)))
              .write(RecurringConfigsCompanion(serverId: Value(serverId)));
          break;
        case 'payment_methods':
          await (_database.update(_database.paymentMethods)
                ..where((p) => p.id.equals(localId)))
              .write(PaymentMethodsCompanion(serverId: Value(serverId)));
          break;
        case 'associated_titles':
          await (_database.update(_database.associatedTitles)
                ..where((a) => a.id.equals(localId)))
              .write(AssociatedTitlesCompanion(serverId: Value(serverId)));
          break;
      }
    }
  }

  /// Resolve conflicts (default: last-write-wins, server wins)
  Future<void> _resolveConflicts(String tableName, List<SyncConflict> conflicts) async {
    if (conflicts.isEmpty) return;

    for (final conflict in conflicts) {
      _logger.w('Conflict in $tableName: ${conflict.conflictType}');

      // Last-write-wins: accept server data
      if (conflict.serverData.isNotEmpty) {
        await _applyPulledChanges(tableName, [conflict.serverData]);
      }
    }
  }

  /// Apply pulled changes to local database
  Future<void> _applyPulledChanges(String tableName, List<Map<String, dynamic>> changes) async {
    for (final data in changes) {
      final serverId = data['id']?.toString();
      if (serverId == null) continue;

      switch (tableName) {
        case 'categories':
          await _upsertCategory(serverId, data);
          break;
        case 'wallets':
          await _upsertWallet(serverId, data);
          break;
        case 'transactions':
          await _upsertTransaction(serverId, data);
          break;
        case 'budgets':
          await _upsertBudget(serverId, data);
          break;
        case 'objectives':
          await _upsertObjective(serverId, data);
          break;
        case 'recurring_configs':
          await _upsertRecurringConfig(serverId, data);
          break;
        case 'payment_methods':
          await _upsertPaymentMethod(serverId, data);
          break;
        case 'associated_titles':
          await _upsertAssociatedTitle(serverId, data);
          break;
      }
    }
  }

  // Upsert methods for each table
  Future<void> _upsertCategory(String serverId, Map<String, dynamic> data) async {
    // Find existing by serverId
    final existing = await (_database.select(_database.categories)
          ..where((c) => c.serverId.equals(serverId)))
        .getSingleOrNull();

    final companion = CategoriesCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      name: Value(data['name'] ?? ''),
      iconName: Value(data['icon_name'] ?? 'category'),
      color: Value(data['color'] ?? '#6366F1'),
      mainCategoryId: Value(data['main_category_id']),
      isIncome: Value(data['is_income'] ?? false),
      orderIndex: Value(data['order_index'] ?? 0),
      syncStatus: const Value(SyncStatus.synced),
      deletedAt: Value(data['deleted_at'] != null
          ? DateTime.parse(data['deleted_at'])
          : null),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.categories)
            ..where((c) => c.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.categories).insert(companion);
    }
  }

  Future<void> _upsertWallet(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.wallets)
          ..where((w) => w.serverId.equals(serverId)))
        .getSingleOrNull();

    final companion = WalletsCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      name: Value(data['name'] ?? ''),
      iconName: Value(data['icon_name'] ?? 'wallet'),
      color: Value(data['color'] ?? '#6366F1'),
      currency: Value(data['currency'] ?? 'USD'),
      balance: Value((data['balance'] as num?)?.toDouble() ?? 0.0),
      isDefault: Value(data['is_default'] ?? false),
      orderIndex: Value(data['order_index'] ?? 0),
      syncStatus: const Value(SyncStatus.synced),
      deletedAt: Value(data['deleted_at'] != null
          ? DateTime.parse(data['deleted_at'])
          : null),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.wallets)
            ..where((w) => w.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.wallets).insert(companion);
    }
  }

  Future<void> _upsertTransaction(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.transactions)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();

    // Resolve foreign key references
    String? walletId = data['wallet_id'];
    String? categoryId = data['category_id'];

    if (walletId != null) {
      final walletServerId = walletId;
      final wallet = await (_database.select(_database.wallets)
            ..where((w) => w.serverId.equals(walletServerId)))
          .getSingleOrNull();
      walletId = wallet?.id ?? walletId;
    }

    if (categoryId != null) {
      final categoryServerId = categoryId;
      final category = await (_database.select(_database.categories)
            ..where((c) => c.serverId.equals(categoryServerId)))
          .getSingleOrNull();
      categoryId = category?.id ?? categoryId;
    }

    final companion = TransactionsCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      amount: Value((data['amount'] as num?)?.toDouble() ?? 0.0),
      title: Value(data['title'] ?? ''),
      notes: Value(data['notes']),
      date: Value(data['date'] != null
          ? DateTime.parse(data['date'])
          : DateTime.now()),
      isIncome: Value(data['is_income'] ?? false),
      transactionType: Value(data['type'] ?? 'regular'),
      walletId: Value(walletId ?? ''),
      categoryId: Value(categoryId),
      syncStatus: const Value(SyncStatus.synced),
      deletedAt: Value(data['deleted_at'] != null
          ? DateTime.parse(data['deleted_at'])
          : null),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.transactions)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.transactions).insert(companion);
    }
  }

  Future<void> _upsertBudget(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.budgets)
          ..where((b) => b.serverId.equals(serverId)))
        .getSingleOrNull();

    final companion = BudgetsCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      name: Value(data['name'] ?? ''),
      amount: Value((data['amount'] as num?)?.toDouble() ?? 0.0),
      period: Value(data['period'] ?? 'monthly'),
      startDate: Value(data['start_date'] != null
          ? DateTime.parse(data['start_date'])
          : DateTime.now()),
      endDate: Value(data['end_date'] != null
          ? DateTime.parse(data['end_date'])
          : null),
      isIncome: Value(data['is_income'] ?? false),
      isPinned: Value(data['is_pinned'] ?? false),
      isArchived: Value(data['is_archived'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      deletedAt: Value(data['deleted_at'] != null
          ? DateTime.parse(data['deleted_at'])
          : null),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.budgets)
            ..where((b) => b.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.budgets).insert(companion);
    }
  }

  Future<void> _upsertObjective(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.objectives)
          ..where((o) => o.serverId.equals(serverId)))
        .getSingleOrNull();

    final companion = ObjectivesCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      name: Value(data['name'] ?? ''),
      iconName: Value(data['icon_name'] ?? 'flag'),
      color: Value(data['color'] ?? '#6366F1'),
      targetAmount: Value((data['target_amount'] as num?)?.toDouble() ?? 0.0),
      type: Value(data['type'] ?? 'goal'),
      startDate: Value(data['start_date'] != null
          ? DateTime.parse(data['start_date'])
          : DateTime.now()),
      endDate: Value(data['end_date'] != null
          ? DateTime.parse(data['end_date'])
          : null),
      isPinned: Value(data['is_pinned'] ?? false),
      isArchived: Value(data['is_archived'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      deletedAt: Value(data['deleted_at'] != null
          ? DateTime.parse(data['deleted_at'])
          : null),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.objectives)
            ..where((o) => o.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.objectives).insert(companion);
    }
  }

  Future<void> _upsertRecurringConfig(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.recurringConfigs)
          ..where((r) => r.serverId.equals(serverId)))
        .getSingleOrNull();

    final companion = RecurringConfigsCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      baseTransactionId: Value(data['base_transaction_id'] ?? ''),
      periodLength: Value(data['period_length'] ?? 1),
      reoccurrence: Value(data['reoccurrence'] ?? 'monthly'),
      startDate: Value(data['start_date'] != null
          ? DateTime.parse(data['start_date'])
          : DateTime.now()),
      endDate: Value(data['end_date'] != null
          ? DateTime.parse(data['end_date'])
          : null),
      nextOccurrence: Value(data['next_occurrence'] != null
          ? DateTime.parse(data['next_occurrence'])
          : DateTime.now()),
      isActive: Value(data['is_active'] ?? true),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.recurringConfigs)
            ..where((r) => r.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.recurringConfigs).insert(companion);
    }
  }

  Future<void> _upsertPaymentMethod(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.paymentMethods)
          ..where((p) => p.serverId.equals(serverId)))
        .getSingleOrNull();

    final companion = PaymentMethodsCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      name: Value(data['name'] ?? ''),
      iconName: Value(data['icon_name'] ?? 'credit_card'),
      type: Value(data['type'] ?? 'card'),
      isDefault: Value(data['is_default'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      deletedAt: Value(data['deleted_at'] != null
          ? DateTime.parse(data['deleted_at'])
          : null),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.paymentMethods)
            ..where((p) => p.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.paymentMethods).insert(companion);
    }
  }

  Future<void> _upsertAssociatedTitle(String serverId, Map<String, dynamic> data) async {
    final existing = await (_database.select(_database.associatedTitles)
          ..where((a) => a.serverId.equals(serverId)))
        .getSingleOrNull();

    // Resolve category reference
    String? categoryId = data['category_id'];
    if (categoryId != null) {
      final categoryServerId = categoryId;
      final category = await (_database.select(_database.categories)
            ..where((c) => c.serverId.equals(categoryServerId)))
          .getSingleOrNull();
      categoryId = category?.id ?? categoryId;
    }

    final companion = AssociatedTitlesCompanion(
      id: Value(existing?.id ?? _uuid.v4()),
      serverId: Value(serverId),
      title: Value(data['title'] ?? ''),
      categoryId: Value(categoryId ?? ''),
      isExactMatch: Value(data['is_exact_match'] ?? false),
      syncStatus: const Value(SyncStatus.synced),
      updatedAt: Value(DateTime.now()),
    );

    if (existing != null) {
      await (_database.update(_database.associatedTitles)
            ..where((a) => a.id.equals(existing.id)))
          .write(companion);
    } else {
      await _database.into(_database.associatedTitles).insert(companion);
    }
  }

  // Conversion methods for push
  Map<String, dynamic> _categoryToMap(Category c) => {
    'name': c.name,
    'icon_name': c.iconName,
    'color': c.color,
    'main_category_id': c.mainCategoryId,
    'is_income': c.isIncome,
    'order_index': c.orderIndex,
    'deleted_at': c.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _walletToMap(Wallet w) => {
    'name': w.name,
    'icon_name': w.iconName,
    'color': w.color,
    'currency': w.currency,
    'balance': w.balance,
    'is_default': w.isDefault,
    'order_index': w.orderIndex,
    'deleted_at': w.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _transactionToMap(Transaction t) => {
    'amount': t.amount,
    'title': t.title,
    'notes': t.notes,
    'date': t.date.toIso8601String(),
    'is_income': t.isIncome,
    'type': t.transactionType,
    'wallet_id': t.walletId,
    'category_id': t.categoryId,
    'payment_method_id': t.paymentMethodId,
    'receipt_image_url': t.receiptImageUrl,
    'deleted_at': t.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _budgetToMap(Budget b) => {
    'name': b.name,
    'amount': b.amount,
    'period': b.period,
    'start_date': b.startDate.toIso8601String(),
    'end_date': b.endDate?.toIso8601String(),
    'wallet_ids': b.walletIds,
    'category_ids': b.categoryIds,
    'is_income': b.isIncome,
    'is_pinned': b.isPinned,
    'is_archived': b.isArchived,
    'deleted_at': b.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _objectiveToMap(Objective o) => {
    'name': o.name,
    'icon_name': o.iconName,
    'color': o.color,
    'target_amount': o.targetAmount,
    'type': o.type,
    'wallet_id': o.walletId,
    'start_date': o.startDate.toIso8601String(),
    'end_date': o.endDate?.toIso8601String(),
    'is_pinned': o.isPinned,
    'is_archived': o.isArchived,
    'deleted_at': o.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _recurringConfigToMap(RecurringConfig r) => {
    'base_transaction_id': r.baseTransactionId,
    'period_length': r.periodLength,
    'reoccurrence': r.reoccurrence,
    'start_date': r.startDate.toIso8601String(),
    'end_date': r.endDate?.toIso8601String(),
    'next_occurrence': r.nextOccurrence.toIso8601String(),
    'is_active': r.isActive,
  };

  Map<String, dynamic> _paymentMethodToMap(PaymentMethod p) => {
    'name': p.name,
    'icon_name': p.iconName,
    'type': p.type,
    'is_default': p.isDefault,
    'deleted_at': p.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _associatedTitleToMap(AssociatedTitle a) => {
    'title': a.title,
    'category_id': a.categoryId,
    'is_exact_match': a.isExactMatch,
  };

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
