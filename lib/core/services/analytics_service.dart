import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;

  AnalyticsService._internal() {
    _analytics.setAnalyticsCollectionEnabled(!kDebugMode);
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  late final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> _logEvent(String name, {Map<String, Object>? parameters}) async {
    if (kDebugMode) return;
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (_) {}
  }

  // Auth events
  Future<void> logLogin({required String method}) async {
    if (kDebugMode) return;
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (_) {}
  }

  Future<void> logSignUp({required String method}) async {
    if (kDebugMode) return;
    try {
      await _analytics.logSignUp(signUpMethod: method);
    } catch (_) {}
  }

  Future<void> logLogout() => _logEvent('logout');

  // Screen views (manual, for bottom nav tabs)
  Future<void> logScreenView({required String screenName}) async {
    if (kDebugMode) return;
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (_) {}
  }

  // Transaction events
  Future<void> logTransactionCreate() => _logEvent('transaction_create');
  Future<void> logTransactionUpdate() => _logEvent('transaction_update');
  Future<void> logTransactionDelete() => _logEvent('transaction_delete');

  // Wallet events
  Future<void> logWalletCreate() => _logEvent('wallet_create');
  Future<void> logWalletDelete() => _logEvent('wallet_delete');

  // Budget events
  Future<void> logBudgetCreate() => _logEvent('budget_create');
  Future<void> logBudgetDelete() => _logEvent('budget_delete');

  // Credit/debt events
  Future<void> logCreditDebtSettled() => _logEvent('credit_debt_settled');
  Future<void> logCreditDebtPayment() => _logEvent('credit_debt_payment');

  // Premium events — full funnel so we can see where users drop off:
  //   paywall_shown -> paywall_purchase_started -> premium_purchase
  //                                               \-> paywall_purchase_canceled
  //                                               \-> paywall_purchase_error
  //   paywall_dismissed (closed without purchase)
  //   paywall_iap_unavailable / paywall_products_empty (dead-end states)
  Future<void> logPaywallShown({String? source, String? featureName}) =>
      _logEvent('paywall_shown', parameters: <String, Object>{
        'source': ?source,
        'feature_name': ?featureName,
      });

  Future<void> logPaywallPurchaseStarted({required String productId}) =>
      _logEvent('paywall_purchase_started',
          parameters: {'product_id': productId});

  Future<void> logPaywallPurchaseCanceled({required String productId}) =>
      _logEvent('paywall_purchase_canceled',
          parameters: {'product_id': productId});

  Future<void> logPaywallPurchaseError({
    required String productId,
    required String stage,
    String? error,
  }) =>
      _logEvent('paywall_purchase_error', parameters: {
        'product_id': productId,
        'stage': stage,
        'error': ?error,
      });

  Future<void> logPaywallDismissed({String? source}) =>
      _logEvent('paywall_dismissed',
          parameters: {'source': ?source});

  Future<void> logPaywallIapUnavailable() =>
      _logEvent('paywall_iap_unavailable');

  Future<void> logPaywallProductsEmpty() => _logEvent('paywall_products_empty');

  Future<void> logPremiumPurchase({String? productId}) =>
      _logEvent('premium_purchase',
          parameters: {'product_id': ?productId});

  Future<void> logPremiumRestore() => _logEvent('premium_restore');

  // AI chat
  Future<void> logAiChatMessage() => _logEvent('ai_chat_message_sent');

  // Theme
  Future<void> logThemeChange() => _logEvent('theme_change');
}
