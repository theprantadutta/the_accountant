import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// State for onboarding flow
class OnboardingState {
  final bool isLoading;
  final bool needsOnboarding;
  final bool isCompleting;
  final String? error;
  final int currentStep;

  const OnboardingState({
    this.isLoading = true,
    this.needsOnboarding = false,
    this.isCompleting = false,
    this.error,
    this.currentStep = 0,
  });

  OnboardingState copyWith({
    bool? isLoading,
    bool? needsOnboarding,
    bool? isCompleting,
    String? error,
    int? currentStep,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      needsOnboarding: needsOnboarding ?? this.needsOnboarding,
      isCompleting: isCompleting ?? this.isCompleting,
      error: error,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

/// Onboarding state notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final ApiService _apiService;
  final AppDatabase _database;

  OnboardingNotifier(this._apiService, this._database)
      : super(const OnboardingState());

  /// Check if user needs onboarding (first login only)
  Future<void> checkOnboardingStatus() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Fetch user info from backend
      final userInfo = await _apiService.getCurrentUser();
      final onboardingCompleted = userInfo['onboarding_completed'] ?? false;

      state = state.copyWith(
        isLoading: false,
        needsOnboarding: !onboardingCompleted,
      );
    } catch (e) {
      debugPrint('[OnboardingProvider] Error checking onboarding status: $e');
      // If we can't check, assume onboarding not needed
      state = state.copyWith(
        isLoading: false,
        needsOnboarding: false,
        error: 'Failed to check onboarding status',
      );
    }
  }

  /// Move to next step
  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  /// Move to previous step
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding({
    required String defaultCurrency,
    required String walletName,
    String? walletIcon,
    String? walletColor,
    double initialBalance = 0.0,
  }) async {
    state = state.copyWith(isCompleting: true, error: null);

    try {
      // 1. Update user's default currency and mark onboarding as complete
      await _apiService.put('/auth/me', data: {
        'default_currency': defaultCurrency,
        'onboarding_completed': true,
      });

      // 2. Create default wallet locally
      final now = DateTime.now();
      final walletId = now.millisecondsSinceEpoch.toString();

      await _database.addWallet(WalletsCompanion.insert(
        id: walletId,
        name: walletName,
        iconName: Value(walletIcon ?? 'wallet'),
        color: Value(walletColor ?? '#6366F1'),
        currency: Value(defaultCurrency),
        balance: Value(initialBalance),
        isDefault: const Value(true),
        orderIndex: const Value(0),
        syncStatus: const Value(1), // pendingCreate
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      state = state.copyWith(
        isCompleting: false,
        needsOnboarding: false,
      );
    } catch (e) {
      debugPrint('[OnboardingProvider] Error completing onboarding: $e');
      state = state.copyWith(
        isCompleting: false,
        error: 'Failed to complete onboarding: $e',
      );
    }
  }

  /// Skip onboarding (just mark as complete without creating wallet)
  Future<void> skipOnboarding() async {
    state = state.copyWith(isCompleting: true, error: null);

    try {
      await _apiService.put('/auth/me', data: {
        'onboarding_completed': true,
      });

      state = state.copyWith(
        isCompleting: false,
        needsOnboarding: false,
      );
    } catch (e) {
      debugPrint('[OnboardingProvider] Error skipping onboarding: $e');
      state = state.copyWith(
        isCompleting: false,
        error: 'Failed to skip onboarding',
      );
    }
  }
}

/// Onboarding provider
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final apiService = ApiService();
  final database = ref.watch(databaseProvider);
  return OnboardingNotifier(apiService, database);
});
