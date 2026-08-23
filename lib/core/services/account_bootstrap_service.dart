import 'package:flutter/foundation.dart';
import 'package:the_accountant/core/services/api_service.dart';

/// What the server says about the authenticated account, at this moment.
///
/// [hasFinancialData] and [liveWalletCount] are computed server-side from the
/// account's live rows. They are the only trustworthy answer to "is this a new
/// account?" — `onboardingCompleted` defaults to false and was never
/// backfilled, so an account with years of history still reports false.
@immutable
class AccountBootstrap {
  final bool onboardingCompleted;
  final bool hasFinancialData;
  final int liveWalletCount;

  /// The backend's own view of the entitlement.
  ///
  /// This is what turns "not premium as far as this device knows" into
  /// "confirmed not premium". A local `false` is ambiguous — it is equally the
  /// answer before anything has loaded — and treating that ambiguity as a
  /// verdict is what left users stuck on a loading screen with no way out.
  final bool isPremium;
  final String? subscriptionTier;

  /// Whether the response actually carried entitlement information.
  ///
  /// An older backend does not send it, and its absence parses as `false` —
  /// which would read as "confirmed lapsed" and put the user in front of an
  /// upgrade prompt they do not need. When this is false the entitlement stays
  /// unknown and the flow keeps retrying instead of concluding anything.
  final bool describesEntitlement;

  const AccountBootstrap({
    required this.onboardingCompleted,
    required this.hasFinancialData,
    required this.liveWalletCount,
    this.isPremium = false,
    this.subscriptionTier,
    this.describesEntitlement = true,
  });

  factory AccountBootstrap.fromJson(Map<String, dynamic> json) {
    T? pick<T>(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is T) return v;
      }
      return null;
    }

    return AccountBootstrap(
      onboardingCompleted:
          pick<bool>(['onboarding_completed', 'onboardingCompleted']) ?? false,
      hasFinancialData:
          pick<bool>(['has_financial_data', 'hasFinancialData']) ?? false,
      liveWalletCount:
          pick<int>(['live_wallet_count', 'liveWalletCount']) ?? 0,
      isPremium: pick<bool>(['is_premium', 'isPremium']) ?? false,
      subscriptionTier:
          pick<String>(['subscription_tier', 'subscriptionTier']),
      describesEntitlement:
          json.containsKey('is_premium') || json.containsKey('isPremium'),
    );
  }

  /// Whether a response actually carried the server-derived history fields.
  ///
  /// An older backend will not send them, and their absence is indistinguishable
  /// from `false` once parsed. Treating "missing" as "empty account" is exactly
  /// the mistake this whole signal exists to prevent, so callers check this
  /// before trusting [hasFinancialData].
  static bool describesHistory(Map<String, dynamic> json) =>
      json.containsKey('has_financial_data') ||
      json.containsKey('hasFinancialData');
}

/// Reads the authenticated account's bootstrap state from the server.
///
/// Deliberately never falls back to the cached `/auth/me` payload for the
/// history question. The cache can predate this release entirely, and a stale
/// "no data" is precisely the answer that sends an established user into
/// first-wallet creation. A failure here is reported as a failure — the caller
/// is expected to treat "unknown" as its own state, not as "empty".
class AccountBootstrapService {
  final ApiService _api;

  AccountBootstrapService({ApiService? api}) : _api = api ?? ApiService();

  /// Returns null when the account state could not be established.
  Future<AccountBootstrap?> fetch({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    try {
      final json = await _api.getCurrentUser(timeout: timeout);
      if (!AccountBootstrap.describesHistory(json)) {
        debugPrint(
          '[AccountBootstrap] server did not report account history; '
          'treating account state as unknown',
        );
        return null;
      }
      return AccountBootstrap.fromJson(json);
    } catch (e) {
      debugPrint('[AccountBootstrap] fetch failed: $e');
      return null;
    }
  }
}
