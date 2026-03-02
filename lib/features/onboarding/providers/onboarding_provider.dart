import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;

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
  /// Uses cache-first approach: returns instantly from cache, refreshes from network in background.
  Future<void> checkOnboardingStatus() async {
    state = state.copyWith(isLoading: true, error: null);

    // Try cache first for instant response
    try {
      final cachedInfo = await _apiService.getCachedUserInfo();
      if (cachedInfo != null) {
        final cachedOnboardingCompleted =
            cachedInfo['onboarding_completed'] ?? false;
        debugPrint(
          '[OnboardingProvider] Using cached onboarding status: $cachedOnboardingCompleted',
        );
        state = state.copyWith(
          isLoading: false,
          needsOnboarding: !cachedOnboardingCompleted,
        );

        // Refresh from network in background (don't block UI)
        _refreshOnboardingStatusInBackground();
        return;
      }
    } catch (_) {
      // Ignore cache errors, fall through to network
    }

    // No cache available (brand-new user) - must hit network
    try {
      final userInfo = await _apiService.getCurrentUser();
      final onboardingCompleted = userInfo['onboarding_completed'] ?? false;

      state = state.copyWith(
        isLoading: false,
        needsOnboarding: !onboardingCompleted,
      );
    } catch (e) {
      debugPrint('[OnboardingProvider] Error checking onboarding status: $e');

      // No cache and no network - assume onboarding not needed (for existing users)
      state = state.copyWith(
        isLoading: false,
        needsOnboarding: false,
        error: 'Failed to check onboarding status',
      );
    }
  }

  /// Refresh onboarding status from network without blocking UI
  Future<void> _refreshOnboardingStatusInBackground() async {
    try {
      final userInfo = await _apiService.getCurrentUser(
        timeout: const Duration(seconds: 5),
      );
      final onboardingCompleted = userInfo['onboarding_completed'] ?? false;
      final needsOnboarding = !onboardingCompleted;

      // Only update state if it changed
      if (state.needsOnboarding != needsOnboarding) {
        debugPrint(
          '[OnboardingProvider] Background refresh updated onboarding status: $needsOnboarding',
        );
        state = state.copyWith(needsOnboarding: needsOnboarding);
      }
    } catch (e) {
      debugPrint(
        '[OnboardingProvider] Background refresh failed (keeping cached state): $e',
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
    WalletType walletType = WalletType.cash,
    double? creditLimit,
    int? billingCycleDay,
  }) async {
    state = state.copyWith(isCompleting: true, error: null);

    try {
      // 1. Update user's default currency and mark onboarding as complete
      await _apiService.put(
        '/auth/me',
        data: {
          'default_currency': defaultCurrency,
          'onboarding_completed': true,
        },
      );

      // 2. Create default wallet locally
      final now = DateTime.now();
      final walletId = now.millisecondsSinceEpoch.toString();

      await _database.addWallet(
        WalletsCompanion.insert(
          id: walletId,
          name: walletName,
          iconName: Value(walletIcon ?? 'wallet'),
          color: Value(walletColor ?? '#6366F1'),
          currency: Value(defaultCurrency),
          balance: Value(initialBalance),
          isDefault: const Value(true),
          walletType: Value(walletType),
          creditLimit: Value(creditLimit),
          billingCycleDay: Value(billingCycleDay),
          orderIndex: const Value(0),
          syncStatus: const Value(1), // pendingCreate
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      state = state.copyWith(isCompleting: false, needsOnboarding: false);
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
      await _apiService.put('/auth/me', data: {'onboarding_completed': true});

      state = state.copyWith(isCompleting: false, needsOnboarding: false);
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
