import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
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

    // Onboarding finished while the server was unreachable: that answer is
    // known here, and must not be overwritten by the server's older "not
    // done yet" before it has been told.
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_pendingKey) != null) {
      state = state.copyWith(isLoading: false, needsOnboarding: false);
      unawaited(_flushPending());
      return;
    }

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
      // Short: with our server down a new user should not watch a spinner
      // for a full connect timeout before the app opens.
      final userInfo = await _apiService.getCurrentUser(
        timeout: const Duration(seconds: 8),
      );
      final onboardingCompleted = userInfo['onboarding_completed'] ?? false;

      state = state.copyWith(
        isLoading: false,
        needsOnboarding: !onboardingCompleted,
      );
    } catch (e) {
      debugPrint('[OnboardingProvider] Error checking onboarding status: $e');

      // No cache and no network. Whether onboarding is offered is not decided
      // here any more: the startup flow only allows it for an account the
      // server confirmed empty, or once the user chose to start on this device
      // with the account unreachable. In that second case the welcome steps
      // are what they need, not an empty app.
      state = state.copyWith(isLoading: false, needsOnboarding: true);
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

  /// Profile changes onboarding made that the server has not received.
  static const String _pendingKey = 'onboarding_pending_profile_v1';

  /// Sends [data] to the profile, or keeps it to send later.
  Future<void> _tellServer(Map<String, dynamic> data) async {
    try {
      await _apiService.put('/auth/me', data: data);
    } catch (e) {
      debugPrint(
        '[OnboardingProvider] Saved for later, server unreachable: $e',
      );
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_pendingKey);
      final pending = raw == null
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(jsonDecode(raw) as Map);
      pending.addAll(data);
      await prefs.setString(_pendingKey, jsonEncode(pending));
    }
  }

  /// Sends what onboarding saved for later. True when nothing is left.
  Future<bool> _flushPending() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pendingKey);
    if (raw == null) return true;
    try {
      await _apiService.put(
        '/auth/me',
        data: jsonDecode(raw) as Map<String, dynamic>,
      );
      await prefs.remove(_pendingKey);
      return true;
    } catch (_) {
      return false;
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
      // The wallet is made on the device first. Telling the server came first
      // before, so with the server unreachable the user was stuck on this
      // screen, unable to create anything at all.
      //
      // Create default wallet locally
      final now = DateTime.now();
      // A UUID, not a timestamp. `SyncChange.EntityId` is a `Guid` server-side,
      // so a millisecond string cannot bind at all — and because a push is one
      // request, that single wallet rejects the entire batch. The user's first
      // wallet and everything filed against it would stay pending forever, with
      // nothing on screen to explain why.
      final walletId = const Uuid().v4();

      await _database.addWallet(
        WalletsCompanion.insert(
          id: walletId,
          name: walletName,
          iconName: Value(walletIcon ?? 'wallet'),
          color: Value(walletColor ?? '#6366F1'),
          currency: Value(defaultCurrency),
          // UI provides major-unit dollars; store integer cents.
          balance: Value((initialBalance * 100).round()),
          openingBalance: Value((initialBalance * 100).round()),
          isDefault: const Value(true),
          walletType: Value(walletType),
          creditLimit: Value(
            creditLimit == null ? null : (creditLimit * 100).round(),
          ),
          billingCycleDay: Value(billingCycleDay),
          orderIndex: const Value(0),
          syncStatus: const Value(1), // pendingCreate
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Then the server: the default currency and that onboarding is done.
      // Sent later if it cannot be reached now.
      await _tellServer({
        'default_currency': defaultCurrency,
        'onboarding_completed': true,
      });

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
      await _tellServer({'onboarding_completed': true});

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
