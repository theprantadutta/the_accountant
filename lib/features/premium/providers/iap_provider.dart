import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/premium/services/iap_service.dart';

/// Provider for the IAPService instance
final iapServiceProvider = Provider<IAPService>((ref) {
  final apiService = ApiService();
  final service = IAPService(apiService: apiService);

  // Initialize on first access
  service.initialize();

  ref.onDispose(() => service.dispose());

  return service;
});

/// State for IAP
class IAPState {
  final bool isLoading;
  final bool isPremium;
  final String? currentTier;
  final DateTime? expiresAt;
  final List<PremiumProduct> products;
  final String? error;
  final PurchaseStatus? lastPurchaseStatus;
  final DateTime? gracePeriodEndsAt;
  final bool isInGracePeriod;

  /// True once `isPremium`/`currentTier` reflect a real backend answer (not the
  /// default startup values and not a failed-request fallback). The sync bridge
  /// only reconciles the persisted premium cache when this is true.
  final bool backendConfirmed;

  const IAPState({
    this.isLoading = false,
    this.isPremium = false,
    this.currentTier,
    this.expiresAt,
    this.products = const [],
    this.error,
    this.lastPurchaseStatus,
    this.gracePeriodEndsAt,
    this.isInGracePeriod = false,
    this.backendConfirmed = false,
  });

  IAPState copyWith({
    bool? isLoading,
    bool? isPremium,
    String? currentTier,
    DateTime? expiresAt,
    List<PremiumProduct>? products,
    String? error,
    PurchaseStatus? lastPurchaseStatus,
    DateTime? gracePeriodEndsAt,
    bool? isInGracePeriod,
    bool? backendConfirmed,
  }) {
    return IAPState(
      isLoading: isLoading ?? this.isLoading,
      isPremium: isPremium ?? this.isPremium,
      currentTier: currentTier ?? this.currentTier,
      expiresAt: expiresAt ?? this.expiresAt,
      products: products ?? this.products,
      error: error,
      lastPurchaseStatus: lastPurchaseStatus ?? this.lastPurchaseStatus,
      gracePeriodEndsAt: gracePeriodEndsAt ?? this.gracePeriodEndsAt,
      isInGracePeriod: isInGracePeriod ?? this.isInGracePeriod,
      backendConfirmed: backendConfirmed ?? this.backendConfirmed,
    );
  }
}

/// Notifier for IAP operations
class IAPNotifier extends StateNotifier<IAPState> {
  final Ref _ref;
  IAPService? _service;

  IAPNotifier(this._ref) : super(const IAPState(isLoading: true)) {
    _service = _ref.read(iapServiceProvider);

    // Set up callbacks
    _service?.onPurchaseUpdate = _onPurchaseUpdate;
    _service?.onSubscriptionUpdate = _onSubscriptionUpdate;

    // Load initial state
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      // Check subscription status
      final status = await _service?.checkSubscriptionStatus();

      // Get products
      final productDetails = _service?.products ?? [];
      final products = productDetails.map((p) => PremiumProduct(p)).toList();

      // Request failed (or returned an unconfirmed fallback): don't overwrite
      // the premium fields — leave whatever we had and mark it unconfirmed so
      // the sync bridge won't downgrade a cached-premium user off a blip.
      if (status == null || !status.confirmed) {
        state = state.copyWith(
          isLoading: false,
          products: products,
          backendConfirmed: false,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isPremium: status.isPremium,
        currentTier: status.tier,
        expiresAt: status.expiresAt,
        products: products,
        gracePeriodEndsAt: status.gracePeriodEndsAt,
        isInGracePeriod: status.isInGracePeriod,
        backendConfirmed: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        backendConfirmed: false,
      );
    }
  }

  void _onPurchaseUpdate(PurchaseStatus status, String? error) {
    state = state.copyWith(
      isLoading: status == PurchaseStatus.pending,
      lastPurchaseStatus: status,
      error: error,
    );

    // Refresh state after purchase
    if (status == PurchaseStatus.purchased ||
        status == PurchaseStatus.restored) {
      _loadState();
    }
  }

  void _onSubscriptionUpdate(
    bool isPremium,
    String? tier,
    DateTime? expiresAt,
  ) {
    state = state.copyWith(
      isPremium: isPremium,
      currentTier: tier,
      expiresAt: expiresAt,
    );
  }

  /// Purchase a product
  Future<bool> purchase(String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    final success = await _service?.purchase(productId) ?? false;

    if (!success) {
      state = state.copyWith(isLoading: false);
    }

    return success;
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);
    await _service?.restorePurchases();
    await _loadState();
  }

  /// Refresh subscription status
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadState();
  }

  /// Load products
  Future<void> loadProducts() async {
    await _service?.loadProducts();
    final productDetails = _service?.products ?? [];
    state = state.copyWith(
      products: productDetails.map((p) => PremiumProduct(p)).toList(),
    );
  }
}

/// Provider for IAP notifier
final iapNotifierProvider = StateNotifierProvider<IAPNotifier, IAPState>((ref) {
  return IAPNotifier(ref);
});

/// Provider for premium status check
final isPremiumProvider = Provider<bool>((ref) {
  final iapState = ref.watch(iapNotifierProvider);
  return iapState.isPremium;
});

/// Provider for subscription status
final subscriptionStatusProvider = FutureProvider<SubscriptionStatus>((
  ref,
) async {
  final service = ref.watch(iapServiceProvider);
  return await service.checkSubscriptionStatus();
});

/// Provider for available products
final premiumProductsProvider = Provider<List<PremiumProduct>>((ref) {
  final iapState = ref.watch(iapNotifierProvider);
  return iapState.products;
});

/// Provider to check if IAP is available
final iapAvailableProvider = Provider<bool>((ref) {
  final service = ref.watch(iapServiceProvider);
  return service.isAvailable;
});
