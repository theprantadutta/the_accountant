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

  // Premium events
  Future<void> logPremiumPurchase() => _logEvent('premium_purchase');
  Future<void> logPremiumRestore() => _logEvent('premium_restore');

  // AI chat
  Future<void> logAiChatMessage() => _logEvent('ai_chat_message_sent');

  // Theme
  Future<void> logThemeChange() => _logEvent('theme_change');
}
