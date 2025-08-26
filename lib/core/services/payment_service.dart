import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:the_accountant/core/utils/env_service.dart';

class PaymentService {
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;
  
  ProductDetails? _premiumProduct;
  ProductDetails? get premiumProduct => _premiumProduct;
  
  bool _isPremiumUnlocked = false;
  bool get isPremiumUnlocked => _isPremiumUnlocked;
  
  final Function(String) _onPurchaseSuccess;
  final Function(String) _onPurchaseError;
  
  PaymentService({
    required Function(String) onPurchaseSuccess,
    required Function(String) onPurchaseError,
  })  : _onPurchaseSuccess = onPurchaseSuccess,
        _onPurchaseError = onPurchaseError {
    _initialize();
  }
  
  Future<void> _initialize() async {
    // Check if in-app purchases are available
    _isAvailable = await _inAppPurchase.isAvailable();
    
    if (!_isAvailable) {
      debugPrint('In-app purchases are not available');
      return;
    }
    
    // Listen to purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );
    
    // Load product details
    await _loadProductDetails();
  }
  
  Future<void> _loadProductDetails() async {
    if (!_isAvailable) return;
    
    try {
      // Get product details
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(
        {EnvService.premiumProductId}, // Use product ID from environment
      );
      
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Product not found: ${response.notFoundIDs}');
        return;
      }
      
      if (response.productDetails.isNotEmpty) {
        _premiumProduct = response.productDetails.firstWhere(
          (product) => product.id == EnvService.premiumProductId,
          orElse: () => response.productDetails.first,
        );
      }
    } catch (e) {
      debugPrint('Error loading product details: $e');
    }
  }
  
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID == EnvService.premiumProductId) {
        _handlePremiumPurchase(purchaseDetails);
      }
    }
  }
  
  void _handlePremiumPurchase(PurchaseDetails purchaseDetails) {
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        // Purchase is pending, wait for confirmation
        debugPrint('Purchase is pending');
        break;
        
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        // Purchase successful
        _isPremiumUnlocked = true;
        _onPurchaseSuccess('Premium features unlocked successfully!');
        
        // Complete the purchase
        _completePurchase(purchaseDetails);
        break;
        
      case PurchaseStatus.error:
        // Purchase failed
        _onPurchaseError(
          purchaseDetails.error?.message ?? 'Purchase failed',
        );
        break;
        
      case PurchaseStatus.canceled:
        // Purchase was canceled
        _onPurchaseError('Purchase was canceled');
        break;
    }
  }
  
  void _completePurchase(PurchaseDetails purchaseDetails) {
    // Complete the purchase to acknowledge it
    _inAppPurchase.completePurchase(purchaseDetails);
  }
  
  Future<void> purchasePremiumFeatures() async {
    if (!_isAvailable) {
      _onPurchaseError('In-app purchases are not available');
      return;
    }
    
    if (_premiumProduct == null) {
      _onPurchaseError('Premium product not available');
      return;
    }
    
    try {
      // Create purchase param
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _premiumProduct!,
      );
      
      // Attempt to buy the product
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _onPurchaseError('Failed to initiate purchase: $e');
    }
  }
  
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      _onPurchaseError('In-app purchases are not available');
      return;
    }
    
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _onPurchaseError('Failed to restore purchases: $e');
    }
  }
  
  void dispose() {
    _subscription?.cancel();
  }
}