// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the RecurringService instance

@ProviderFor(recurringService)
final recurringServiceProvider = RecurringServiceProvider._();

/// Provider for the RecurringService instance

final class RecurringServiceProvider
    extends
        $FunctionalProvider<
          RecurringService,
          RecurringService,
          RecurringService
        >
    with $Provider<RecurringService> {
  /// Provider for the RecurringService instance
  RecurringServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringServiceHash();

  @$internal
  @override
  $ProviderElement<RecurringService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecurringService create(Ref ref) {
    return recurringService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurringService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecurringService>(value),
    );
  }
}

String _$recurringServiceHash() => r'625f8f08ca9592063bd8b34737b1f45dcf2167ab';

/// Provider for all recurring configurations with their base transactions

@ProviderFor(allRecurringConfigs)
final allRecurringConfigsProvider = AllRecurringConfigsProvider._();

/// Provider for all recurring configurations with their base transactions

final class AllRecurringConfigsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringConfigWithTransaction>>,
          List<RecurringConfigWithTransaction>,
          FutureOr<List<RecurringConfigWithTransaction>>
        >
    with
        $FutureModifier<List<RecurringConfigWithTransaction>>,
        $FutureProvider<List<RecurringConfigWithTransaction>> {
  /// Provider for all recurring configurations with their base transactions
  AllRecurringConfigsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allRecurringConfigsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allRecurringConfigsHash();

  @$internal
  @override
  $FutureProviderElement<List<RecurringConfigWithTransaction>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecurringConfigWithTransaction>> create(Ref ref) {
    return allRecurringConfigs(ref);
  }
}

String _$allRecurringConfigsHash() =>
    r'a4165d3e1e27579420c4e84b33319f47d14c0e20';

/// Provider for active recurring configurations

@ProviderFor(activeRecurringConfigs)
final activeRecurringConfigsProvider = ActiveRecurringConfigsProvider._();

/// Provider for active recurring configurations

final class ActiveRecurringConfigsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringConfigWithTransaction>>,
          List<RecurringConfigWithTransaction>,
          FutureOr<List<RecurringConfigWithTransaction>>
        >
    with
        $FutureModifier<List<RecurringConfigWithTransaction>>,
        $FutureProvider<List<RecurringConfigWithTransaction>> {
  /// Provider for active recurring configurations
  ActiveRecurringConfigsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeRecurringConfigsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRecurringConfigsHash();

  @$internal
  @override
  $FutureProviderElement<List<RecurringConfigWithTransaction>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecurringConfigWithTransaction>> create(Ref ref) {
    return activeRecurringConfigs(ref);
  }
}

String _$activeRecurringConfigsHash() =>
    r'1f08cd124eafc8ceefc22727ef4e4cfe2d002d4c';

/// Notifier for managing recurring transactions

@ProviderFor(RecurringNotifier)
final recurringProvider = RecurringNotifierProvider._();

/// Notifier for managing recurring transactions
final class RecurringNotifierProvider
    extends
        $AsyncNotifierProvider<
          RecurringNotifier,
          List<RecurringConfigWithTransaction>
        > {
  /// Notifier for managing recurring transactions
  RecurringNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringNotifierHash();

  @$internal
  @override
  RecurringNotifier create() => RecurringNotifier();
}

String _$recurringNotifierHash() => r'cc679b75aadb403e8b344b420de65eed737e913d';

/// Notifier for managing recurring transactions

abstract class _$RecurringNotifier
    extends $AsyncNotifier<List<RecurringConfigWithTransaction>> {
  FutureOr<List<RecurringConfigWithTransaction>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<RecurringConfigWithTransaction>>,
              List<RecurringConfigWithTransaction>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RecurringConfigWithTransaction>>,
                List<RecurringConfigWithTransaction>
              >,
              AsyncValue<List<RecurringConfigWithTransaction>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider for upcoming recurring transactions (next 30 days)

@ProviderFor(upcomingRecurringTransactions)
final upcomingRecurringTransactionsProvider =
    UpcomingRecurringTransactionsProvider._();

/// Provider for upcoming recurring transactions (next 30 days)

final class UpcomingRecurringTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UpcomingRecurring>>,
          List<UpcomingRecurring>,
          FutureOr<List<UpcomingRecurring>>
        >
    with
        $FutureModifier<List<UpcomingRecurring>>,
        $FutureProvider<List<UpcomingRecurring>> {
  /// Provider for upcoming recurring transactions (next 30 days)
  UpcomingRecurringTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingRecurringTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingRecurringTransactionsHash();

  @$internal
  @override
  $FutureProviderElement<List<UpcomingRecurring>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UpcomingRecurring>> create(Ref ref) {
    return upcomingRecurringTransactions(ref);
  }
}

String _$upcomingRecurringTransactionsHash() =>
    r'96e87523f45d98057436a80d8354e2d93f470d8e';
