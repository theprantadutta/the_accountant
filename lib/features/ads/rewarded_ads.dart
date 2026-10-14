import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

/// What a rewarded ad buys. The [wire] name is what the server understands.
enum RewardKind {
  /// One more AI request today (chat, summary, receipt, quick add).
  aiCall('ai_call'),

  /// Premium themes for 24 hours.
  themeTrial('theme_trial'),

  /// One PDF report export.
  pdfExport('pdf_export');

  const RewardKind(this.wire);
  final String wire;
}

/// The two rewarded ad units, per platform.
///
/// Debug builds use Google's published test units: showing real ads while
/// developing is against AdMob policy and can get the account limited.
abstract final class AdUnits {
  static bool get _ios => !kIsWeb && Platform.isIOS;

  static String get rewarded {
    if (!kReleaseMode) {
      return _ios
          ? 'ca-app-pub-3940256099942544/1712485313'
          : 'ca-app-pub-3940256099942544/5224354917';
    }
    return _ios
        ? 'ca-app-pub-9242904787767394/3565835676'
        : 'ca-app-pub-9242904787767394/1649109618';
  }

  static String get rewardedInterstitial {
    if (!kReleaseMode) {
      return _ios
          ? 'ca-app-pub-3940256099942544/6978759866'
          : 'ca-app-pub-3940256099942544/5354046379';
    }
    return _ios
        ? 'ca-app-pub-9242904787767394/1638510482'
        : 'ca-app-pub-9242904787767394/7978714246';
  }
}

/// How an ad attempt ended.
enum AdOutcome {
  /// Watched to the end: the reward is owed.
  earned,

  /// Closed before the reward.
  skipped,

  /// No ad could be loaded or shown (no fill, offline, consent refused).
  unavailable,
}

class AdResult {
  final AdOutcome outcome;
  final String? adUnitId;
  const AdResult(this.outcome, [this.adUnitId]);
}

/// Loads and shows rewarded ads, and only when asked.
///
/// The app never shows an ad on its own: every call here follows the user
/// tapping a button and confirming they want to watch one. Nothing is
/// preloaded and the SDK is not even started until the first such request,
/// so Premium users and anyone who never asks never load it.
///
/// Small rewards (an AI request) try the rewarded unit first; bigger ones (a
/// theme trial, a PDF) try the rewarded-interstitial unit first. Either falls
/// back to the other when it has nothing to show.
class RewardedAds {
  RewardedAds._();
  static final instance = RewardedAds._();

  final _log = Logger();
  Future<bool>? _ready;

  /// Gathers consent where the law requires it, then starts the SDK. Resolves
  /// to false when ads may not be requested (consent declined or unavailable).
  Future<bool> _ensureReady() => _ready ??= _prepare().then((ok) {
    if (!ok) _ready = null; // Let a later attempt ask again.
    return ok;
  });

  Future<bool> _prepare() async {
    final consent = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
        if (!consent.isCompleted) consent.complete();
      },
      (error) {
        _log.w('Consent info update failed: ${error.message}');
        if (!consent.isCompleted) consent.complete();
      },
    );
    await consent.future;

    if (!await ConsentInformation.instance.canRequestAds()) return false;
    await MobileAds.instance.initialize();
    return true;
  }

  /// Shows one rewarded ad for [kind]. The reward is the SDK's own
  /// onUserEarnedReward, as in Snake Classic: there is no server-side
  /// verification callback.
  Future<AdResult> show(RewardKind kind) async {
    if (!await _ensureReady()) return const AdResult(AdOutcome.unavailable);

    final interstitialFirst = kind != RewardKind.aiCall;
    final order = interstitialFirst
        ? [_showInterstitial, _showRewarded]
        : [_showRewarded, _showInterstitial];

    for (final attempt in order) {
      final result = await attempt();
      if (result.outcome != AdOutcome.unavailable) return result;
    }
    return const AdResult(AdOutcome.unavailable);
  }

  Future<AdResult> _showRewarded() async {
    final unit = AdUnits.rewarded;
    final loaded = Completer<RewardedAd?>();
    await RewardedAd.load(
      adUnitId: unit,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: loaded.complete,
        onAdFailedToLoad: (error) {
          _log.w('Rewarded ad failed to load: ${error.message}');
          loaded.complete(null);
        },
      ),
    );
    final ad = await loaded.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => null,
    );
    if (ad == null) return const AdResult(AdOutcome.unavailable);

    final done = Completer<AdResult>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        done.complete(
          AdResult(earned ? AdOutcome.earned : AdOutcome.skipped, unit),
        );
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        done.complete(AdResult(AdOutcome.unavailable, unit));
      },
    );
    await ad.show(onUserEarnedReward: (_, _) => earned = true);
    return done.future;
  }

  Future<AdResult> _showInterstitial() async {
    final unit = AdUnits.rewardedInterstitial;
    final loaded = Completer<RewardedInterstitialAd?>();
    await RewardedInterstitialAd.load(
      adUnitId: unit,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: loaded.complete,
        onAdFailedToLoad: (error) {
          _log.w('Rewarded interstitial failed to load: ${error.message}');
          loaded.complete(null);
        },
      ),
    );
    final ad = await loaded.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => null,
    );
    if (ad == null) return const AdResult(AdOutcome.unavailable);

    final done = Completer<AdResult>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        done.complete(
          AdResult(earned ? AdOutcome.earned : AdOutcome.skipped, unit),
        );
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        done.complete(AdResult(AdOutcome.unavailable, unit));
      },
    );
    await ad.show(onUserEarnedReward: (_, _) => earned = true);
    return done.future;
  }

  /// The "Privacy options" entry in settings, where the law requires one.
  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  Future<void> showPrivacyOptions() =>
      ConsentForm.showPrivacyOptionsForm((_) {});
}
