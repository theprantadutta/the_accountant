import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Service for managing objectives (goals and savings tracking)
class ObjectivesService {
  final AppDatabase _database;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  ObjectivesService({required this._database});

  /// Create a new objective (goal or loan)
  Future<String> createObjective({
    required String name,
    required int targetAmount, // integer minor units / cents
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

  /// Sentinel meaning "leave the end date unchanged".
  ///
  /// A plain nullable parameter cannot tell "don't touch it" apart from "clear
  /// it", which is why removing a goal's deadline used to silently do nothing.
  static const Object keepEndDate = Object();

  /// Update an objective.
  ///
  /// [endDate] is tri-state: omit to keep, pass a [DateTime] to set, pass null
  /// to clear (an open-ended goal).
  Future<void> updateObjective({
    required String objectiveId,
    String? name,
    int? targetAmount, // integer minor units / cents
    Object? endDate = keepEndDate,
    String? iconName,
    String? color,
    bool? isPinned,
    bool? isArchived,
  }) async {
    final companion = ObjectivesCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      targetAmount: targetAmount != null
          ? Value(targetAmount)
          : const Value.absent(),
      endDate: identical(endDate, keepEndDate)
          ? const Value.absent()
          : Value(endDate as DateTime?),
      iconName: iconName != null ? Value(iconName) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      isPinned: isPinned != null ? Value(isPinned) : const Value.absent(),
      isArchived: isArchived != null ? Value(isArchived) : const Value.absent(),
      syncStatus: const Value(SyncStatus.pendingUpdate),
      updatedAt: Value(DateTime.now()),
    );

    await (_database.update(
      _database.objectives,
    )..where((o) => o.id.equals(objectiveId))).write(companion);

    _logger.i('Updated objective: $objectiveId');
  }

  /// Delete an objective.
  ///
  /// Detaching the transactions and tombstoning the objective happen in one
  /// database transaction, so a deleted goal can never leave transactions
  /// pointing at a row that no longer exists.
  Future<void> deleteObjective(String objectiveId) async {
    await _database.transaction(() async {
      // Clear the assignment on every transaction (sync-aware, so other devices
      // see the detachment too).
      await _database.unlinkAllTransactionsFromObjective(objectiveId);

      await (_database.update(
        _database.objectives,
      )..where((o) => o.id.equals(objectiveId))).write(
        ObjectivesCompanion(
          deletedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingDelete),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });

    _logger.i('Deleted objective: $objectiveId');
  }

  /// Assign a transaction to an objective.
  ///
  /// Membership is stored on `transactions.objectiveId` — the single,
  /// synchronized source of truth. The old junction table was local-only, so a
  /// link made on one device never reached another and progress silently
  /// disagreed between them.
  Future<void> linkTransaction(String objectiveId, String transactionId) async {
    await _database.linkTransactionToObjective(objectiveId, transactionId);
    _logger.d('Linked transaction $transactionId to objective $objectiveId');
  }

  /// Remove a transaction's objective assignment.
  Future<void> unlinkTransaction(
    String objectiveId,
    String transactionId,
  ) async {
    await _database.unlinkTransactionFromObjective(objectiveId, transactionId);
    _logger.d(
      'Unlinked transaction $transactionId from objective $objectiveId',
    );
  }

  /// Get objective with full progress details
  Future<ObjectiveWithProgress> getObjectiveWithProgress(
    String objectiveId,
  ) async {
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
    final transactions = await _database.getTransactionsForObjective(
      objective.id,
    );
    if (transactions.isNotEmpty && currentAmount > 0) {
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
      await updateObjective(
        objectiveId: objectiveId,
        isPinned: !objective.isPinned,
      );
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
  final int currentAmount; // integer minor units / cents
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
  int get targetAmount => objective.targetAmount; // integer minor units / cents
  String get type => objective.type;
  bool get isGoal => objective.type == 'goal';
  bool get isLoan => objective.type == 'loan';
  bool get isPinned => objective.isPinned;
  bool get isArchived => objective.isArchived;
  bool get isComplete => progressPercent >= 100;

  int get remainingAmount =>
      targetAmount - currentAmount; // integer minor units / cents

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

  /// How often money is put toward a goal.
  ///
  /// Only the cadences someone actually saves on. Nobody funds a holiday daily.
  static const List<InstallmentCadence> cadences = InstallmentCadence.values;

  /// A plan for finishing this goal: how many payments of what size.
  ///
  /// Two questions, one answer. Given a deadline, it works out the payment;
  /// given a payment the user can manage, [planForPayment] works out when they
  /// will arrive. A target on its own tells someone nothing about whether it is
  /// achievable, which is the thing they want to know before starting.
  ///
  /// Null when there is nothing left to save, or no deadline to work back from.
  InstallmentPlan? planForDeadline(InstallmentCadence cadence) {
    final remaining = remainingAmount;
    if (remaining <= 0) return null;

    final days = timeRemaining?.inDays;
    if (days == null || days <= 0) return null;

    final payments = (days / cadence.days).ceil();
    if (payments <= 0) return null;

    return InstallmentPlan(
      cadence: cadence,
      payments: payments,
      // Rounded up, so the last payment is never short of the target.
      amountCents: (remaining / payments).ceil(),
    );
  }

  /// The same plan read the other way: how long [amountCents] a period takes.
  ///
  /// Null when the payment is not positive, or the goal is already reached.
  InstallmentPlan? planForPayment(InstallmentCadence cadence, int amountCents) {
    final remaining = remainingAmount;
    if (remaining <= 0 || amountCents <= 0) return null;

    return InstallmentPlan(
      cadence: cadence,
      payments: (remaining / amountCents).ceil(),
      amountCents: amountCents,
    );
  }

  /// Cents that need to go in each day to arrive on time, or null when there
  /// is no deadline, no shortfall, or no time left.
  ///
  /// Deliberately a number rather than a string: this class has no idea which
  /// currency the user keeps, and the version that built the text itself
  /// hard-coded a dollar sign onto every account in the world.
  int? get dailyTargetCents =>
      (dailyTarget == null || dailyTarget! <= 0) ? null : dailyTarget!.round();
}

/// How often a goal is paid into.
enum InstallmentCadence {
  weekly('Weekly', 7),
  fortnightly('Fortnightly', 14),
  monthly('Monthly', 30);

  const InstallmentCadence(this.label, this.days);

  final String label;

  /// Approximate length in days. A month is taken as 30, which is close enough
  /// for "roughly this much, roughly this often" and avoids a plan that shifts
  /// depending on which month it is read in.
  final int days;
}

/// A way of reaching a goal: [payments] payments of [amountCents], [cadence].
class InstallmentPlan {
  final InstallmentCadence cadence;
  final int payments;
  final int amountCents;

  const InstallmentPlan({
    required this.cadence,
    required this.payments,
    required this.amountCents,
  });

  /// Roughly when the last payment lands, counting from today.
  DateTime get finishesAround =>
      DateTime.now().add(Duration(days: payments * cadence.days));
}
