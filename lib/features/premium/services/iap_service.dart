import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:logger/logger.dart';

import 'package:the_accountant/core/services/api_service.dart';

/// Product IDs for premium subscriptions
class PremiumProductIds {
  static const String monthly = 'premium_monthly';
  static const String yearly = 'premium_yearly';
  static const String lifetime = 'premium_lifetime';

  static const Set<String> all = {monthly, yearly, lifetime};
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

  IAPService({required ApiService apiService}) : _apiService = apiService;

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
      final valid = data['valid'] == true;

      if (valid) {
        // Update subscription status
        onSubscriptionUpdate?.call(
          true,
          data['subscription_tier'],
          data['expires_at'] != null
              ? DateTime.parse(data['expires_at'])
              : null,
        );
        _logger.i('Purchase verified successfully');
      } else {
        _logger.w('Purchase verification failed: ${data['message']}');
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

      // Calculate days remaining if expiresAt is present
      int? daysRemaining;
      DateTime? expiresAt;
      if (data['expiresAt'] != null) {
        expiresAt = DateTime.parse(data['expiresAt']);
        daysRemaining = expiresAt.difference(DateTime.now()).inDays;
        if (daysRemaining < 0) daysRemaining = 0;
      }

      // Map backend tier to product ID
      String? tier;
      final backendTier = data['tier']?.toString();
      if (backendTier != null) {
        switch (backendTier) {
          case 'Monthly':
            tier = PremiumProductIds.monthly;
            break;
          case 'Yearly':
            tier = PremiumProductIds.yearly;
            break;
          case 'Lifetime':
            tier = PremiumProductIds.lifetime;
            break;
        }
      }

      return SubscriptionStatus(
        isPremium: data['isPremium'] == true,
        tier: tier,
        expiresAt: expiresAt,
        daysRemaining: daysRemaining,
      );
    } catch (e) {
      _logger.e('Error checking subscription status: $e');
      return SubscriptionStatus(isPremium: false);
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

  SubscriptionStatus({
    required this.isPremium,
    this.tier,
    this.expiresAt,
    this.daysRemaining,
  });

  bool get isLifetime => tier == PremiumProductIds.lifetime;
  bool get isExpiringSoon => daysRemaining != null && daysRemaining! <= 7;

  String get tierDisplayName {
    switch (tier) {
      case PremiumProductIds.monthly:
        return 'Premium Monthly';
      case PremiumProductIds.yearly:
        return 'Premium Yearly';
      case PremiumProductIds.lifetime:
        return 'Premium Lifetime';
      default:
        return 'Free';
    }
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
    switch (id) {
      case PremiumProductIds.monthly:
        return 'Monthly';
      case PremiumProductIds.yearly:
        return 'Yearly';
      case PremiumProductIds.lifetime:
        return 'Lifetime';
      default:
        return title;
    }
  }

  String? get savings {
    // Calculate savings compared to monthly
    // This would require comparing prices
    if (id == PremiumProductIds.yearly) {
      return 'Save ~40%';
    } else if (id == PremiumProductIds.lifetime) {
      return 'Best Value';
    }
    return null;
  }

  bool get isRecommended => id == PremiumProductIds.yearly;
}
