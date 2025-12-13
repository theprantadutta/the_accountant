import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for managing objectives (goals and savings tracking)
class ObjectivesService {
  final AppDatabase _database;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  ObjectivesService({required AppDatabase database}) : _database = database;

  /// Create a new objective (goal or loan)
  Future<String> createObjective({
    required String name,
    required double targetAmount,
    required String type, // 'goal' or 'loan'
    required DateTime startDate,
    DateTime? endDate,
    String iconName = 'flag',
    String color = '#6366F1',
    String? walletId,
    bool isPinned = false,
  }) async {
    final id = _uuid.v4();

    final companion = ObjectivesCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      type: Value(type),
      startDate: Value(startDate),
      endDate: Value(endDate),
      iconName: Value(iconName),
      color: Value(color),
      walletId: Value(walletId),
      isPinned: Value(isPinned),
      isArchived: const Value(false),
      syncStatus: const Value(SyncStatus.pendingCreate),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _database.addObjective(companion);
    _logger.i('Created objective: $id ($name)');

    return id;
  }

  /// Update an objective
  Future<void> updateObjective({
    required String objectiveId,
    String? name,
    double? targetAmount,
    DateTime? endDate,
    String? iconName,
    String? color,
    bool? isPinned,
    bool? isArchived,
  }) async {
    final companion = ObjectivesCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      targetAmount: targetAmount != null ? Value(targetAmount) : const Value.absent(),
      endDate: endDate != null ? Value(endDate) : const Value.absent(),
      iconName: iconName != null ? Value(iconName) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      isPinned: isPinned != null ? Value(isPinned) : const Value.absent(),
      isArchived: isArchived != null ? Value(isArchived) : const Value.absent(),
      syncStatus: const Value(SyncStatus.pendingUpdate),
      updatedAt: Value(DateTime.now()),
    );

    await (_database.update(_database.objectives)
          ..where((o) => o.id.equals(objectiveId)))
        .write(companion);

    _logger.i('Updated objective: $objectiveId');
  }

  /// Delete an objective
  Future<void> deleteObjective(String objectiveId) async {
    // First, remove all linked transactions
    final linkedTransactions = await _database.getObjectiveTransactions(objectiveId);
    for (final link in linkedTransactions) {
      await _database.removeObjectiveTransaction(objectiveId, link.transactionId);
    }

    // Then delete the objective (soft delete)
    await (_database.update(_database.objectives)
          ..where((o) => o.id.equals(objectiveId)))
        .write(ObjectivesCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(DateTime.now()),
        ));

    _logger.i('Deleted objective: $objectiveId');
  }

  /// Link a transaction to an objective
  Future<void> linkTransaction(String objectiveId, String transactionId) async {
    final id = _uuid.v4();

    await _database.addObjectiveTransaction(ObjectiveTransactionsCompanion(
      id: Value(id),
      objectiveId: Value(objectiveId),
      transactionId: Value(transactionId),
      createdAt: Value(DateTime.now()),
    ));

    _logger.d('Linked transaction $transactionId to objective $objectiveId');
  }

  /// Unlink a transaction from an objective
  Future<void> unlinkTransaction(String objectiveId, String transactionId) async {
    await _database.removeObjectiveTransaction(objectiveId, transactionId);
    _logger.d('Unlinked transaction $transactionId from objective $objectiveId');
  }

  /// Get objective with full progress details
  Future<ObjectiveWithProgress> getObjectiveWithProgress(String objectiveId) async {
    final objective = await _database.findObjectiveById(objectiveId);
    if (objective == null) {
      throw Exception('Objective not found: $objectiveId');
    }

    return await _calculateProgress(objective);
  }

  /// Get all objectives with progress
  Future<List<ObjectiveWithProgress>> getAllObjectivesWithProgress() async {
    final objectives = await _database.getAllObjectives();
    final result = <ObjectiveWithProgress>[];

    for (final objective in objectives) {
      result.add(await _calculateProgress(objective));
    }

    return result;
  }

  /// Get active (non-archived) objectives with progress
  Future<List<ObjectiveWithProgress>> getActiveObjectivesWithProgress() async {
    final objectives = await _database.getActiveObjectives();
    final result = <ObjectiveWithProgress>[];

    for (final objective in objectives) {
      result.add(await _calculateProgress(objective));
    }

    return result;
  }

  /// Get pinned objectives with progress
  Future<List<ObjectiveWithProgress>> getPinnedObjectivesWithProgress() async {
    final objectives = await _database.getPinnedObjectives();
    final result = <ObjectiveWithProgress>[];

    for (final objective in objectives) {
      result.add(await _calculateProgress(objective));
    }

    return result;
  }

  /// Calculate progress for an objective
  Future<ObjectiveWithProgress> _calculateProgress(Objective objective) async {
    final currentAmount = await _database.getObjectiveProgress(objective.id);
    final progressPercent = objective.targetAmount > 0
        ? (currentAmount / objective.targetAmount * 100).clamp(0.0, 100.0)
        : 0.0;

    // Calculate time-based metrics
    Duration? timeRemaining;
    double? dailyTarget;
    double? projectedCompletion;

    if (objective.endDate != null) {
      final now = DateTime.now();
      timeRemaining = objective.endDate!.difference(now);

      if (timeRemaining.isNegative) {
        timeRemaining = Duration.zero;
      } else {
        // Calculate daily target to reach goal on time
        final remainingAmount = objective.targetAmount - currentAmount;
        final daysRemaining = timeRemaining.inDays;

        if (daysRemaining > 0) {
          dailyTarget = remainingAmount / daysRemaining;
        }
      }
    }

    // Calculate projected completion date based on average contribution
    final linkedTransactions = await _database.getObjectiveTransactions(objective.id);
    if (linkedTransactions.isNotEmpty && currentAmount > 0) {
      // Calculate average contribution per day
      final startDate = objective.startDate;
      final daysSinceStart = DateTime.now().difference(startDate).inDays;

      if (daysSinceStart > 0) {
        final averagePerDay = currentAmount / daysSinceStart;
        if (averagePerDay > 0) {
          final remainingAmount = objective.targetAmount - currentAmount;
          final daysToComplete = remainingAmount / averagePerDay;
          projectedCompletion = daysToComplete;
        }
      }
    }

    // Get linked transactions
    final transactions = <Transaction>[];
    for (final link in linkedTransactions) {
      final transaction = await _database.findTransactionById(link.transactionId);
      if (transaction != null && transaction.deletedAt == null) {
        transactions.add(transaction);
      }
    }

    return ObjectiveWithProgress(
      objective: objective,
      currentAmount: currentAmount,
      progressPercent: progressPercent,
      timeRemaining: timeRemaining,
      dailyTarget: dailyTarget,
      projectedCompletionDays: projectedCompletion,
      linkedTransactions: transactions,
    );
  }

  /// Archive an objective
  Future<void> archiveObjective(String objectiveId) async {
    await updateObjective(objectiveId: objectiveId, isArchived: true);
    _logger.i('Archived objective: $objectiveId');
  }

  /// Unarchive an objective
  Future<void> unarchiveObjective(String objectiveId) async {
    await updateObjective(objectiveId: objectiveId, isArchived: false);
    _logger.i('Unarchived objective: $objectiveId');
  }

  /// Pin/unpin an objective
  Future<void> togglePinned(String objectiveId) async {
    final objective = await _database.findObjectiveById(objectiveId);
    if (objective != null) {
      await updateObjective(objectiveId: objectiveId, isPinned: !objective.isPinned);
    }
  }

  /// Get goals (saving type)
  Future<List<ObjectiveWithProgress>> getGoalsWithProgress() async {
    final goals = await _database.getGoals();
    final result = <ObjectiveWithProgress>[];

    for (final goal in goals) {
      result.add(await _calculateProgress(goal));
    }

    return result;
  }

  /// Get loans (debt type)
  Future<List<ObjectiveWithProgress>> getLoansWithProgress() async {
    final loans = await _database.getLoans();
    final result = <ObjectiveWithProgress>[];

    for (final loan in loans) {
      result.add(await _calculateProgress(loan));
    }

    return result;
  }
}

/// Objective with calculated progress information
class ObjectiveWithProgress {
  final Objective objective;
  final double currentAmount;
  final double progressPercent;
  final Duration? timeRemaining;
  final double? dailyTarget;
  final double? projectedCompletionDays;
  final List<Transaction> linkedTransactions;

  ObjectiveWithProgress({
    required this.objective,
    required this.currentAmount,
    required this.progressPercent,
    this.timeRemaining,
    this.dailyTarget,
    this.projectedCompletionDays,
    this.linkedTransactions = const [],
  });

  // Convenience getters
  String get name => objective.name;
  double get targetAmount => objective.targetAmount;
  String get type => objective.type;
  bool get isGoal => objective.type == 'goal';
  bool get isLoan => objective.type == 'loan';
  bool get isPinned => objective.isPinned;
  bool get isArchived => objective.isArchived;
  bool get isComplete => progressPercent >= 100;

  double get remainingAmount => targetAmount - currentAmount;

  String get progressText {
    if (isComplete) {
      return 'Completed!';
    }
    return '${progressPercent.toStringAsFixed(0)}% complete';
  }

  String? get timeRemainingText {
    if (timeRemaining == null) return null;
    if (timeRemaining!.isNegative || timeRemaining == Duration.zero) {
      return 'Overdue';
    }

    final days = timeRemaining!.inDays;
    if (days == 0) return 'Due today';
    if (days == 1) return '1 day left';
    if (days < 7) return '$days days left';
    if (days < 30) return '${(days / 7).ceil()} weeks left';
    if (days < 365) return '${(days / 30).ceil()} months left';
    return '${(days / 365).toStringAsFixed(1)} years left';
  }

  String? get dailyTargetText {
    if (dailyTarget == null || dailyTarget! <= 0) return null;
    return '\$${dailyTarget!.toStringAsFixed(2)}/day needed';
  }
}
