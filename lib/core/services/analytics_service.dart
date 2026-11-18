import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Analytics wrapper that degrades to a no-op when Firebase is unavailable.
///
/// `FirebaseAnalytics.instance` throws `[core/no-app]` when no Firebase app has
/// been initialized. Touching it in a field initializer meant merely
/// constructing this singleton blew up — which is why the widget test suite
/// could not even start the app. Every Firebase touchpoint is now resolved
/// lazily behind a guard, so the app (and the tests) run happily without
/// Firebase and analytics simply stops reporting.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;

  AnalyticsService._internal();

  /// Set by tests (and any host without Firebase) to skip analytics entirely.
  static bool disabled = false;

  FirebaseAnalytics? _cachedAnalytics;
  bool _analyticsResolved = false;

  /// The Firebase analytics client, or null when Firebase is not initialized.
  FirebaseAnalytics? get _analytics {
    if (disabled) return null;
    if (_analyticsResolved) return _cachedAnalytics;
    _analyticsResolved = true;
    try {
      final analytics = FirebaseAnalytics.instance;
      // A release build turns collection on in [start], once it knows this
      // is not a test device; switching it on here would undo that.
      if (kDebugMode) analytics.setAnalyticsCollectionEnabled(false);
      _cachedAnalytics = analytics;
    } catch (_) {
      // No Firebase app configured (tests, or a failed init). Stay silent.
      _cachedAnalytics = null;
    }
    return _cachedAnalytics;
  }

  static const _device = MethodChannel('the_accountant/device');
  static const _firstLaunchKey = 'analytics_first_launch_at';
  static const _firstTransactionKey = 'analytics_first_transaction_logged';

  /// Turns collection on, unless this is one of Google's test devices.
  ///
  /// Play's pre-launch robots run every new release on Firebase Test Lab.
  /// One of them (an "IN2025") was 73 of the 131 users in Analytics over 28
  /// days, each opening the app for 14 seconds, which made every rate in the
  /// reports wrong. Android ships with collection off (see the manifest) so
  /// nothing is sent before this check.
  Future<void> start() async {
    if (disabled || kDebugMode) return;
    var testDevice = false;
    if (Platform.isAndroid) {
      try {
        testDevice = await _device.invokeMethod<bool>('isTestLab') ?? false;
      } catch (_) {}
    }
    try {
      await _analytics?.setAnalyticsCollectionEnabled(!testDevice);
    } catch (_) {}
    if (testDevice) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_firstLaunchKey)) {
        await prefs.setInt(
          _firstLaunchKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        // Someone who used the app before this version has had their first
        // transaction already; their next one is not it.
        if (prefs.getBool('has_seen_intro') ?? false) {
          await prefs.setBool(_firstTransactionKey, true);
        }
      }
    } catch (_) {}
  }

  /// Ties later events to an account, by its opaque id (never an email), or
  /// to nobody when [id] is null.
  Future<void> setUser(String? id) async {
    if (kDebugMode) return;
    try {
      await _analytics?.setUserId(id: id);
    } catch (_) {}
  }

  /// A trait to split reports by, such as being Premium or the app language.
  Future<void> setUserProperty(String name, String? value) async {
    if (kDebugMode) return;
    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (_) {}
  }

  Future<void> _logEvent(String name, {Map<String, Object>? parameters}) async {
    if (kDebugMode) return;
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
    } catch (_) {}
  }

  // Auth events
  Future<void> logLogin({required String method}) async {
    if (kDebugMode) return;
    try {
      await _analytics?.logLogin(loginMethod: method);
    } catch (_) {}
  }

  Future<void> logSignUp({required String method}) async {
    if (kDebugMode) return;
    try {
      await _analytics?.logSignUp(signUpMethod: method);
    } catch (_) {}
  }

  Future<void> logLogout() => _logEvent('logout');

  /// A sign-in that did not get through, and why: `cancelled`, `network`,
  /// `token`, `server`, `firebase_<code>`. Most people who open the app never
  /// sign in, and without this there was no telling whether they chose not
  /// to or could not.
  Future<void> logLoginFailed({
    required String method,
    required String reason,
  }) => _logEvent(
    'login_failed',
    parameters: {'method': method, 'reason': reason},
  );

  // Screen views: tabs report themselves, routes come from ScreenTracker.
  Future<void> logScreenView({required String screenName}) async {
    if (kDebugMode) return;
    try {
      // The class too: left out, Android fills in its one activity.
      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenName,
      );
    } catch (_) {}
  }

  // Transaction events
  Future<void> logTransactionCreate() async {
    await _logEvent('transaction_create');
    await _logFirstTransaction();
  }

  /// The first transaction on this install: the moment the app has done its
  /// job once. Carries how long it took, which is the number onboarding is
  /// judged by.
  Future<void> _logFirstTransaction() async {
    if (kDebugMode || disabled) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_firstTransactionKey) ?? false) return;
      await prefs.setBool(_firstTransactionKey, true);
      final since = prefs.getInt(_firstLaunchKey);
      final hours = since == null
          ? -1
          : DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(since))
                .inHours;
      await _logEvent(
        'first_transaction',
        parameters: {'hours_since_install': hours},
      );
    } catch (_) {}
  }

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
      _logEvent(
        'paywall_shown',
        parameters: <String, Object>{
          'source': ?source,
          'feature_name': ?featureName,
        },
      );

  Future<void> logPaywallPurchaseStarted({required String productId}) =>
      _logEvent(
        'paywall_purchase_started',
        parameters: {'product_id': productId},
      );

  Future<void> logPaywallPurchaseCanceled({required String productId}) =>
      _logEvent(
        'paywall_purchase_canceled',
        parameters: {'product_id': productId},
      );

  Future<void> logPaywallPurchaseError({
    required String productId,
    required String stage,
    String? error,
  }) => _logEvent(
    'paywall_purchase_error',
    parameters: {'product_id': productId, 'stage': stage, 'error': ?error},
  );

  Future<void> logPaywallDismissed({String? source}) =>
      _logEvent('paywall_dismissed', parameters: {'source': ?source});

  Future<void> logPaywallIapUnavailable() =>
      _logEvent('paywall_iap_unavailable');

  Future<void> logPaywallProductsEmpty() => _logEvent('paywall_products_empty');

  Future<void> logPremiumPurchase({String? productId}) =>
      _logEvent('premium_purchase', parameters: {'product_id': ?productId});

  Future<void> logPremiumRestore() => _logEvent('premium_restore');

  // AI chat
  Future<void> logAiChatMessage() => _logEvent('ai_chat_message_sent');

  // Theme
  Future<void> logThemeChange() => _logEvent('theme_change');

  // Getting started
  Future<void> logOnboardingComplete() => _logEvent('onboarding_complete');
  Future<void> logTutorialComplete() => _logEvent('tutorial_complete');

  // Ways of adding a transaction other than typing it in
  Future<void> logReceiptScanned({required bool found}) =>
      _logEvent('receipt_scanned', parameters: {'found': found ? 1 : 0});
  Future<void> logVoiceLogUsed() => _logEvent('voice_log_used');
  Future<void> logQuickAddUsed() => _logEvent('ai_quick_add_used');

  // Goals
  Future<void> logObjectiveCreate() => _logEvent('objective_create');

  // Rewarded ads, by what the reward unlocks
  Future<void> logAdRewardEarned({required String reward}) =>
      _logEvent('ad_reward_earned', parameters: {'reward': reward});

  // Data leaving or coming back
  Future<void> logDataExport({required String format}) =>
      _logEvent('data_export', parameters: {'format': format});
  Future<void> logBackupRestored() => _logEvent('backup_restored');

  // Settings worth knowing about
  Future<void> logLanguageChange({required String language}) =>
      _logEvent('language_change', parameters: {'language': language});
}
