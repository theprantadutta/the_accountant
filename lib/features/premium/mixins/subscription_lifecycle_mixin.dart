import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/billing_config.dart';
import '../providers/iap_provider.dart';

/// Mixin that refreshes subscription status when the app resumes from background.
///
/// This catches webhook-driven changes (grace periods, renewals, revocations)
/// that occurred while the app was in the background.
///
/// Usage:
/// ```dart
/// class _MyScreenState extends ConsumerState<MyScreen>
///     with WidgetsBindingObserver, SubscriptionLifecycleMixin {
///   // Your code here
/// }
/// ```
mixin SubscriptionLifecycleMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, WidgetsBindingObserver {
  DateTime? _lastSubscriptionRefresh;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  Future<void> _onAppResumed() async {
    if (_isRefreshing) return;

    // Throttle refreshes
    if (_lastSubscriptionRefresh != null) {
      final elapsed = DateTime.now().difference(_lastSubscriptionRefresh!);
      if (elapsed < BillingConfig.refreshInterval) return;
    }

    _isRefreshing = true;
    _lastSubscriptionRefresh = DateTime.now();

    try {
      await ref.read(iapNotifierProvider.notifier).refresh();
    } catch (e) {
      debugPrint('Failed to refresh subscription status: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  /// Manually trigger a subscription refresh, respecting the throttle interval.
  Future<bool> refreshSubscriptionIfNeeded() async {
    if (_isRefreshing) return false;

    if (_lastSubscriptionRefresh != null) {
      final elapsed = DateTime.now().difference(_lastSubscriptionRefresh!);
      if (elapsed < BillingConfig.refreshInterval) return false;
    }

    _isRefreshing = true;
    _lastSubscriptionRefresh = DateTime.now();

    try {
      await ref.read(iapNotifierProvider.notifier).refresh();
      return true;
    } catch (e) {
      debugPrint('Failed to refresh subscription status: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }
}
