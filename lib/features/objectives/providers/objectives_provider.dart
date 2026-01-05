import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/objectives/services/objectives_service.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

part 'objectives_provider.g.dart';

/// Provider for the ObjectivesService instance
@riverpod
ObjectivesService objectivesService(Ref ref) {
  final database = ref.watch(databaseProvider);
  return ObjectivesService(database: database);
}

/// Provider for all objectives with progress
@riverpod
Future<List<ObjectiveWithProgress>> allObjectives(Ref ref) async {
  final service = ref.watch(objectivesServiceProvider);
  return await service.getAllObjectivesWithProgress();
}

/// Provider for active objectives with progress
@riverpod
Future<List<ObjectiveWithProgress>> activeObjectives(Ref ref) async {
  final service = ref.watch(objectivesServiceProvider);
  return await service.getActiveObjectivesWithProgress();
}

/// Provider for pinned objectives with progress
@riverpod
Future<List<ObjectiveWithProgress>> pinnedObjectives(Ref ref) async {
  final service = ref.watch(objectivesServiceProvider);
  return await service.getPinnedObjectivesWithProgress();
}

/// Provider for goals only
@riverpod
Future<List<ObjectiveWithProgress>> goals(Ref ref) async {
  final service = ref.watch(objectivesServiceProvider);
  return await service.getGoalsWithProgress();
}

/// Provider for loans only
@riverpod
Future<List<ObjectiveWithProgress>> loans(Ref ref) async {
  final service = ref.watch(objectivesServiceProvider);
  return await service.getLoansWithProgress();
}

/// Notifier for managing objectives
@riverpod
class ObjectivesNotifier extends _$ObjectivesNotifier {
  @override
  Future<List<ObjectiveWithProgress>> build() async {
    final service = ref.watch(objectivesServiceProvider);
    return await service.getActiveObjectivesWithProgress();
  }

  /// Create a new objective
  Future<String> createObjective({
    required String name,
    required double targetAmount,
    required String type,
    required DateTime startDate,
    DateTime? endDate,
    String iconName = 'flag',
    String color = '#6366F1',
    String? walletId,
    bool isPinned = false,
  }) async {
    // Check premium limit for active objectives
    final premiumState = ref.read(premiumProvider);
    if (!premiumState.isPremium) {
      final currentObjectives = await ref.read(activeObjectivesProvider.future);
      if (currentObjectives.length >= FreeTierLimits.maxActiveObjectives) {
        throw PremiumLimitException(
          entityType: 'objective',
          currentCount: currentObjectives.length,
          limit: FreeTierLimits.maxActiveObjectives,
        );
      }
    }

    final service = ref.read(objectivesServiceProvider);

    final id = await service.createObjective(
      name: name,
      targetAmount: targetAmount,
      type: type,
      startDate: startDate,
      endDate: endDate,
      iconName: iconName,
      color: color,
      walletId: walletId,
      isPinned: isPinned,
    );

    ref.invalidateSelf();
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
    final service = ref.read(objectivesServiceProvider);

    await service.updateObjective(
      objectiveId: objectiveId,
      name: name,
      targetAmount: targetAmount,
      endDate: endDate,
      iconName: iconName,
      color: color,
      isPinned: isPinned,
      isArchived: isArchived,
    );

    ref.invalidateSelf();
  }

  /// Delete an objective
  Future<void> deleteObjective(String objectiveId) async {
    final service = ref.read(objectivesServiceProvider);
    await service.deleteObjective(objectiveId);
    ref.invalidateSelf();
  }

  /// Link a transaction to an objective
  Future<void> linkTransaction(String objectiveId, String transactionId) async {
    final service = ref.read(objectivesServiceProvider);
    await service.linkTransaction(objectiveId, transactionId);
    ref.invalidateSelf();
  }

  /// Unlink a transaction from an objective
  Future<void> unlinkTransaction(String objectiveId, String transactionId) async {
    final service = ref.read(objectivesServiceProvider);
    await service.unlinkTransaction(objectiveId, transactionId);
    ref.invalidateSelf();
  }

  /// Archive an objective
  Future<void> archiveObjective(String objectiveId) async {
    final service = ref.read(objectivesServiceProvider);
    await service.archiveObjective(objectiveId);
    ref.invalidateSelf();
  }

  /// Unarchive an objective
  Future<void> unarchiveObjective(String objectiveId) async {
    final service = ref.read(objectivesServiceProvider);
    await service.unarchiveObjective(objectiveId);
    ref.invalidateSelf();
  }

  /// Toggle pinned status
  Future<void> togglePinned(String objectiveId) async {
    final service = ref.read(objectivesServiceProvider);
    await service.togglePinned(objectiveId);
    ref.invalidateSelf();
  }
}

/// Provider for a single objective with progress
@riverpod
Future<ObjectiveWithProgress?> objectiveDetail(
  Ref ref,
  String objectiveId,
) async {
  final service = ref.watch(objectivesServiceProvider);
  try {
    return await service.getObjectiveWithProgress(objectiveId);
  } catch (_) {
    return null;
  }
}

/// Provider for total savings progress (all goals combined)
@riverpod
Future<TotalSavingsProgress> totalSavingsProgress(Ref ref) async {
  final goals = await ref.watch(goalsProvider.future);

  double totalTarget = 0;
  double totalCurrent = 0;

  for (final goal in goals) {
    totalTarget += goal.targetAmount;
    totalCurrent += goal.currentAmount;
  }

  final progressPercent = totalTarget > 0
      ? (totalCurrent / totalTarget * 100).clamp(0.0, 100.0)
      : 0.0;

  return TotalSavingsProgress(
    totalTarget: totalTarget,
    totalCurrent: totalCurrent,
    progressPercent: progressPercent,
    goalCount: goals.length,
    completedCount: goals.where((g) => g.isComplete).length,
  );
}

/// Total savings progress summary
class TotalSavingsProgress {
  final double totalTarget;
  final double totalCurrent;
  final double progressPercent;
  final int goalCount;
  final int completedCount;

  TotalSavingsProgress({
    required this.totalTarget,
    required this.totalCurrent,
    required this.progressPercent,
    required this.goalCount,
    required this.completedCount,
  });

  double get remainingAmount => totalTarget - totalCurrent;
  int get activeCount => goalCount - completedCount;
}
