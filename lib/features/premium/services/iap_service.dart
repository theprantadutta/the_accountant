import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:logger/logger.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/premium/constants/product_ids.dart';

/// Product IDs for premium subscriptions (delegates to TheAccountantProducts)
class PremiumProductIds {
  static String get monthly => TheAccountantProducts.monthly;
  static String get yearly => TheAccountantProducts.yearly;
  static String get lifetime => TheAccountantProducts.lifetime;

  static Set<String> get all => TheAccountantProducts.allProductIds;
}

/// IAP Service for handling in-app purchases
/// Supports Google Play Billing and App Store
class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final ApiService _apiService;
  final Logger _logger = Logger();

  // Stream subscriptions
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Product details cache
  final Map<String, ProductDetails> _products = {};

  // Callbacks
  Function(PurchaseStatus status, String? error)? onPurchaseUpdate;
  Function(bool isPremium, String? tier, DateTime? expiresAt)?
  onSubscriptionUpdate;

  // State
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  IAPService({required this._apiService});

  /// Initialize the IAP service
  Future<void> initialize() async {
    // Check if IAP is available
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      _logger.w('IAP is not available on this device');
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) => _logger.e('IAP stream error: $error'),
    );

    // Load products
    await loadProducts();

    _logger.i('IAP service initialized');
  }

  /// Load available products from the store
  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    try {
      final response = await _iap.queryProductDetails(PremiumProductIds.all);

      if (response.error != null) {
        _logger.e('Error loading products: ${response.error}');
        return;
      }

      if (response.notFoundIDs.isNotEmpty) {
        _logger.w('Products not found: ${response.notFoundIDs}');
      }

      _products.clear();
      for (final product in response.productDetails) {
        _products[product.id] = product;
        _logger.d('Loaded product: ${product.id} - ${product.price}');
      }

      _logger.i('Loaded ${_products.length} products');
    } catch (e, stack) {
      _logger.e('Error loading products: $e', error: e, stackTrace: stack);
    }
  }

  /// Get available products
  List<ProductDetails> get products => _products.values.toList();

  /// Get a specific product
  ProductDetails? getProduct(String productId) => _products[productId];

  /// Purchase a product
  Future<bool> purchase(String productId) async {
    if (!_isAvailable) {
      _logger.w('IAP not available');
      onPurchaseUpdate?.call(PurchaseStatus.error, 'IAP not available');
      return false;
    }

    final product = _products[productId];
    if (product == null) {
      _logger.w('Product not found: $productId');
      onPurchaseUpdate?.call(PurchaseStatus.error, 'Product not found');
      return false;
    }

    try {
      final purchaseParam = PurchaseParam(productDetails: product);

      // For subscriptions (monthly/yearly), use buyNonConsumable
      // For lifetime, also use buyNonConsumable
      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        _logger.w('Purchase request failed');
        onPurchaseUpdate?.call(PurchaseStatus.error, 'Purchase request failed');
      }

      return success;
    } catch (e) {
      _logger.e('Purchase error: $e');
      onPurchaseUpdate?.call(PurchaseStatus.error, e.toString());
      return false;
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      _logger.w('IAP not available');
      return;
    }

    try {
      await _iap.restorePurchases();
      _logger.i('Restore purchases initiated');
    } catch (e) {
      _logger.e('Restore error: $e');
      onPurchaseUpdate?.call(
        PurchaseStatus.error,
        'Failed to restore purchases',
      );
    }
  }

  /// Handle purchase updates from the store
  Future<void> _onPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      _logger.d(
        'Purchase update: ${purchaseDetails.productID} - ${purchaseDetails.status}',
      );

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          onPurchaseUpdate?.call(PurchaseStatus.pending, null);
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Verify with backend
          final verified = await _verifyPurchase(purchaseDetails);
          if (verified) {
            onPurchaseUpdate?.call(purchaseDetails.status, null);
          } else {
            onPurchaseUpdate?.call(PurchaseStatus.error, 'Verification failed');
          }

          // Complete the purchase
          if (purchaseDetails.pendingCompletePurchase) {
            await _iap.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.error:
          onPurchaseUpdate?.call(
            PurchaseStatus.error,
            purchaseDetails.error?.message ?? 'Purchase failed',
          );

          // Complete to clear the queue
          if (purchaseDetails.pendingCompletePurchase) {
            await _iap.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.canceled:
          onPurchaseUpdate?.call(PurchaseStatus.canceled, null);
          break;
      }
    }
  }

  /// Verify purchase with backend
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final platform = Platform.isAndroid ? 'android' : 'ios';

      String? purchaseToken;
      String? orderId;

      // Get platform-specific data
      if (Platform.isAndroid && purchaseDetails is GooglePlayPurchaseDetails) {
        purchaseToken = purchaseDetails.billingClientPurchase.purchaseToken;
        orderId = purchaseDetails.billingClientPurchase.orderId;
      } else if (Platform.isIOS) {
        // For iOS, we send the receipt data
        purchaseToken = purchaseDetails.verificationData.serverVerificationData;
      }

      if (purchaseToken == null) {
        _logger.e('No purchase token available');
        return false;
      }

      // Call backend to verify
      final response = await _apiService.post(
        '/iap/verify',
        data: {
          'platform': platform,
          'product_id': purchaseDetails.productID,
          'purchase_token': purchaseToken,
          'order_id': orderId,
        },
      );

      final data = response.data;
      final valid = data['success'] == true;

      if (valid) {
        // Update subscription status
        onSubscriptionUpdate?.call(
          true,
          _mapTierToProductId(data['new_tier']?.toString()),
          data['expires_at'] != null
              ? DateTime.parse(data['expires_at'])
              : null,
        );
        _logger.i('Purchase verified successfully');
      } else {
        _logger.w('Purchase verification failed: ${data['error']}');
      }

      return valid;
    } catch (e, stack) {
      _logger.e('Verification error: $e', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Check current subscription status from backend
  Future<SubscriptionStatus> checkSubscriptionStatus() async {
    try {
      final response = await _apiService.get('/iap/subscription-status');
      final data = response.data;

      // Calculate days remaining if expires_at is present
      int? daysRemaining;
      DateTime? expiresAt;
      if (data['expires_at'] != null) {
        expiresAt = DateTime.parse(data['expires_at']);
        daysRemaining = expiresAt.difference(DateTime.now()).inDays;
        if (daysRemaining < 0) daysRemaining = 0;
      }

      // Parse grace period
      DateTime? gracePeriodEndsAt;
      if (data['grace_period_ends_at'] != null) {
        gracePeriodEndsAt = DateTime.parse(data['grace_period_ends_at']);
      }
      final isInGracePeriod = data['is_in_grace_period'] == true;

      return SubscriptionStatus(
        isPremium: data['is_premium'] == true,
        tier: _mapTierToProductId(data['tier']?.toString()),
        expiresAt: expiresAt,
        daysRemaining: daysRemaining,
        gracePeriodEndsAt: gracePeriodEndsAt,
        isInGracePeriod: isInGracePeriod,
      );
    } catch (e) {
      _logger.e('Error checking subscription status: $e');
      // Unconfirmed: the request failed, so this is a fallback, not a real
      // "you're free" answer. `confirmed: false` tells the sync bridge to keep
      // whatever premium state is already cached instead of downgrading.
      return SubscriptionStatus(isPremium: false, confirmed: false);
    }
  }

  /// Map backend SubscriptionTier enum (serialized as snake_case) to a platform-aware product ID.
  /// Tolerates both snake_case (current) and PascalCase (legacy) for defensive parsing.
  String? _mapTierToProductId(String? backendTier) {
    if (backendTier == null) return null;
    switch (backendTier) {
      case 'premium_monthly':
      case 'PremiumMonthly':
        return PremiumProductIds.monthly;
      case 'premium_yearly':
      case 'PremiumYearly':
        return PremiumProductIds.yearly;
      case 'premium_lifetime':
      case 'PremiumLifetime':
        return PremiumProductIds.lifetime;
      default:
        return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}

/// Subscription status from backend
class SubscriptionStatus {
  final bool isPremium;
  final String? tier;
  final DateTime? expiresAt;
  final int? daysRemaining;
  final DateTime? gracePeriodEndsAt;
  final bool isInGracePeriod;

  /// True when this status reflects a real answer from the backend. False when
  /// the request failed and the values are just a safe fallback — callers must
  /// NOT downgrade a cached-premium user off an unconfirmed result.
  final bool confirmed;

  SubscriptionStatus({
    required this.isPremium,
    this.tier,
    this.expiresAt,
    this.daysRemaining,
    this.gracePeriodEndsAt,
    this.isInGracePeriod = false,
    this.confirmed = true,
  });

  bool get isLifetime =>
      tier != null && tier!.toLowerCase().contains('lifetime');
  bool get isExpiringSoon => daysRemaining != null && daysRemaining! <= 7;

  String get tierDisplayName {
    if (tier == null) return 'Free';
    return TheAccountantProducts.getTierDisplayName(tier!);
  }
}

/// Product info for display
class PremiumProduct {
  final ProductDetails details;

  PremiumProduct(this.details);

  String get id => details.id;
  String get title => details.title;
  String get description => details.description;
  String get price => details.price;

  String get displayTitle {
    final lower = id.toLowerCase();
    if (lower.contains('monthly')) return 'Monthly';
    if (lower.contains('yearly')) return 'Yearly';
    if (lower.contains('lifetime')) return 'Lifetime';
    return title;
  }

  String? get savings => TheAccountantProducts.getSavingsText(id);

  bool get isRecommended => id.toLowerCase().contains('yearly');
}
