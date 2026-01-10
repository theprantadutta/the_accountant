// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objectives_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the ObjectivesService instance

@ProviderFor(objectivesService)
final objectivesServiceProvider = ObjectivesServiceProvider._();

/// Provider for the ObjectivesService instance

final class ObjectivesServiceProvider
    extends
        $FunctionalProvider<
          ObjectivesService,
          ObjectivesService,
          ObjectivesService
        >
    with $Provider<ObjectivesService> {
  /// Provider for the ObjectivesService instance
  ObjectivesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'objectivesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$objectivesServiceHash();

  @$internal
  @override
  $ProviderElement<ObjectivesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ObjectivesService create(Ref ref) {
    return objectivesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObjectivesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObjectivesService>(value),
    );
  }
}

String _$objectivesServiceHash() => r'7101e4e4dfc2073a25064dbfe6eb5b7ea46c8f40';

/// Provider for all objectives with progress

@ProviderFor(allObjectives)
final allObjectivesProvider = AllObjectivesProvider._();

/// Provider for all objectives with progress

final class AllObjectivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ObjectiveWithProgress>>,
          List<ObjectiveWithProgress>,
          FutureOr<List<ObjectiveWithProgress>>
        >
    with
        $FutureModifier<List<ObjectiveWithProgress>>,
        $FutureProvider<List<ObjectiveWithProgress>> {
  /// Provider for all objectives with progress
  AllObjectivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allObjectivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allObjectivesHash();

  @$internal
  @override
  $FutureProviderElement<List<ObjectiveWithProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ObjectiveWithProgress>> create(Ref ref) {
    return allObjectives(ref);
  }
}

String _$allObjectivesHash() => r'16a23ced5db7f7a8cde57b0494f623476133ba93';

/// Provider for active objectives with progress

@ProviderFor(activeObjectives)
final activeObjectivesProvider = ActiveObjectivesProvider._();

/// Provider for active objectives with progress

final class ActiveObjectivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ObjectiveWithProgress>>,
          List<ObjectiveWithProgress>,
          FutureOr<List<ObjectiveWithProgress>>
        >
    with
        $FutureModifier<List<ObjectiveWithProgress>>,
        $FutureProvider<List<ObjectiveWithProgress>> {
  /// Provider for active objectives with progress
  ActiveObjectivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeObjectivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeObjectivesHash();

  @$internal
  @override
  $FutureProviderElement<List<ObjectiveWithProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ObjectiveWithProgress>> create(Ref ref) {
    return activeObjectives(ref);
  }
}

String _$activeObjectivesHash() => r'618878d0d9b19086bcff5362ea76d2edbf6546f7';

/// Provider for pinned objectives with progress

@ProviderFor(pinnedObjectives)
final pinnedObjectivesProvider = PinnedObjectivesProvider._();

/// Provider for pinned objectives with progress

final class PinnedObjectivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ObjectiveWithProgress>>,
          List<ObjectiveWithProgress>,
          FutureOr<List<ObjectiveWithProgress>>
        >
    with
        $FutureModifier<List<ObjectiveWithProgress>>,
        $FutureProvider<List<ObjectiveWithProgress>> {
  /// Provider for pinned objectives with progress
  PinnedObjectivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinnedObjectivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinnedObjectivesHash();

  @$internal
  @override
  $FutureProviderElement<List<ObjectiveWithProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ObjectiveWithProgress>> create(Ref ref) {
    return pinnedObjectives(ref);
  }
}

String _$pinnedObjectivesHash() => r'075094064415251e3e4c66be955bad03e8606dfc';

/// Provider for goals only

@ProviderFor(goals)
final goalsProvider = GoalsProvider._();

/// Provider for goals only

final class GoalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ObjectiveWithProgress>>,
          List<ObjectiveWithProgress>,
          FutureOr<List<ObjectiveWithProgress>>
        >
    with
        $FutureModifier<List<ObjectiveWithProgress>>,
        $FutureProvider<List<ObjectiveWithProgress>> {
  /// Provider for goals only
  GoalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsHash();

  @$internal
  @override
  $FutureProviderElement<List<ObjectiveWithProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ObjectiveWithProgress>> create(Ref ref) {
    return goals(ref);
  }
}

String _$goalsHash() => r'bfe4943fe76f293439559964d769bfb457fc9790';

/// Provider for loans only

@ProviderFor(loans)
final loansProvider = LoansProvider._();

/// Provider for loans only

final class LoansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ObjectiveWithProgress>>,
          List<ObjectiveWithProgress>,
          FutureOr<List<ObjectiveWithProgress>>
        >
    with
        $FutureModifier<List<ObjectiveWithProgress>>,
        $FutureProvider<List<ObjectiveWithProgress>> {
  /// Provider for loans only
  LoansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loansHash();

  @$internal
  @override
  $FutureProviderElement<List<ObjectiveWithProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ObjectiveWithProgress>> create(Ref ref) {
    return loans(ref);
  }
}

String _$loansHash() => r'5b1e97daae90e06507892dcbc868c58cba30ff19';

/// Notifier for managing objectives

@ProviderFor(ObjectivesNotifier)
final objectivesProvider = ObjectivesNotifierProvider._();

/// Notifier for managing objectives
final class ObjectivesNotifierProvider
    extends
        $AsyncNotifierProvider<
          ObjectivesNotifier,
          List<ObjectiveWithProgress>
        > {
  /// Notifier for managing objectives
  ObjectivesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'objectivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$objectivesNotifierHash();

  @$internal
  @override
  ObjectivesNotifier create() => ObjectivesNotifier();
}

String _$objectivesNotifierHash() =>
    r'983559d7f9954dad7864e599cfccb40d88299638';

/// Notifier for managing objectives

abstract class _$ObjectivesNotifier
    extends $AsyncNotifier<List<ObjectiveWithProgress>> {
  FutureOr<List<ObjectiveWithProgress>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ObjectiveWithProgress>>,
              List<ObjectiveWithProgress>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ObjectiveWithProgress>>,
                List<ObjectiveWithProgress>
              >,
              AsyncValue<List<ObjectiveWithProgress>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for a single objective with progress

@ProviderFor(objectiveDetail)
final objectiveDetailProvider = ObjectiveDetailFamily._();

/// Provider for a single objective with progress

final class ObjectiveDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ObjectiveWithProgress?>,
          ObjectiveWithProgress?,
          FutureOr<ObjectiveWithProgress?>
        >
    with
        $FutureModifier<ObjectiveWithProgress?>,
        $FutureProvider<ObjectiveWithProgress?> {
  /// Provider for a single objective with progress
  ObjectiveDetailProvider._({
    required ObjectiveDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'objectiveDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$objectiveDetailHash();

  @override
  String toString() {
    return r'objectiveDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ObjectiveWithProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ObjectiveWithProgress?> create(Ref ref) {
    final argument = this.argument as String;
    return objectiveDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ObjectiveDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$objectiveDetailHash() => r'3f8ff6b4590180e54d2e687e5beba2c24f4723ef';

/// Provider for a single objective with progress

final class ObjectiveDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ObjectiveWithProgress?>, String> {
  ObjectiveDetailFamily._()
    : super(
        retry: null,
        name: r'objectiveDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single objective with progress

  ObjectiveDetailProvider call(String objectiveId) =>
      ObjectiveDetailProvider._(argument: objectiveId, from: this);

  @override
  String toString() => r'objectiveDetailProvider';
}

/// Provider for total savings progress (all goals combined)

@ProviderFor(totalSavingsProgress)
final totalSavingsProgressProvider = TotalSavingsProgressProvider._();

/// Provider for total savings progress (all goals combined)

final class TotalSavingsProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<TotalSavingsProgress>,
          TotalSavingsProgress,
          FutureOr<TotalSavingsProgress>
        >
    with
        $FutureModifier<TotalSavingsProgress>,
        $FutureProvider<TotalSavingsProgress> {
  /// Provider for total savings progress (all goals combined)
  TotalSavingsProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalSavingsProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalSavingsProgressHash();

  @$internal
  @override
  $FutureProviderElement<TotalSavingsProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TotalSavingsProgress> create(Ref ref) {
    return totalSavingsProgress(ref);
  }
}

String _$totalSavingsProgressHash() =>
    r'b33f46d4eadbe08cd5a7c16527788f45e0107db3';
