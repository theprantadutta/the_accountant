import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/payment_service.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

class PaymentState {
  final bool isAvailable;
  final bool isPremiumUnlocked;
  final String? productName;
  final String? productPrice;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  PaymentState({
    this.isAvailable = false,
    this.isPremiumUnlocked = false,
    this.productName,
    this.productPrice,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  PaymentState copyWith({
    bool? isAvailable,
    bool? isPremiumUnlocked,
    String? productName,
    String? productPrice,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return PaymentState(
      isAvailable: isAvailable ?? this.isAvailable,
      isPremiumUnlocked: isPremiumUnlocked ?? this.isPremiumUnlocked,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref _ref;
  PaymentService? _paymentService;

  PaymentNotifier(this._ref) : super(PaymentState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      _paymentService = PaymentService(
        onPurchaseSuccess: _handlePurchaseSuccess,
        onPurchaseError: _handlePurchaseError,
      );

      // Wait a bit for the service to initialize
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        isAvailable: _paymentService?.isAvailable ?? false,
        isPremiumUnlocked: _paymentService?.isPremiumUnlocked ?? false,
        productName: _paymentService?.premiumProduct?.title,
        productPrice: _paymentService?.premiumProduct?.price,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _handlePurchaseSuccess(String message) {
    state = state.copyWith(
      isPremiumUnlocked: true,
      successMessage: message,
      errorMessage: null,
    );
    
    // Unlock premium features
    _ref.read(premiumProvider.notifier).unlockPremiumFeatures();
  }

  void _handlePurchaseError(String error) {
    state = state.copyWith(
      errorMessage: error,
      successMessage: null,
    );
  }

  Future<void> purchasePremiumFeatures() async {
    if (_paymentService == null) {
      state = state.copyWith(errorMessage: 'Payment service not initialized');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

    try {
      await _paymentService!.purchasePremiumFeatures();
      // The purchase result will be handled by the payment service callbacks
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> restorePurchases() async {
    if (_paymentService == null) {
      state = state.copyWith(errorMessage: 'Payment service not initialized');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

    try {
      await _paymentService!.restorePurchases();
      // The restore result will be handled by the payment service callbacks
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _paymentService?.dispose();
    super.dispose();
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref);
});