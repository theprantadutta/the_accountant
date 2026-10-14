import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai_assistant/models/ai_quota.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// The shared AI client.
final aiApiProvider = Provider<AiApi>((ref) => AiApi());

/// Today's AI allowance.
///
/// The server is the authority; this holds its last answer so screens can say
/// "1 free request left today" without asking each time. Refresh after any AI
/// call or ad. Premium is unlimited and never needs to ask.
class AiQuotaNotifier extends StateNotifier<AiQuota> {
  AiQuotaNotifier(this._ref) : super(AiQuota.initial) {
    refresh();
  }

  final Ref _ref;

  static const _unlimited = AiQuota(
    unlimited: true,
    freeDaily: 2,
    used: 0,
    adCredits: 0,
    remaining: null,
    adsWatched: 0,
    maxAdsPerDay: 10,
    canWatchAd: false,
  );

  bool get _isPremium => _ref.read(premiumProvider).isPremium;

  Future<void> refresh() async {
    if (_isPremium) {
      state = _unlimited;
      return;
    }
    try {
      state = await _ref.read(aiApiProvider).quota();
      // A theme trial bought on another install, or before a restart.
      final trial = state.themeTrialEndsAt;
      if (trial != null && state.themeTrialActive) {
        await _ref.read(themeProvider.notifier).startTrial(trial);
      }
    } catch (_) {
      // Keep the last known allowance; the server still enforces the real one.
    }
  }

  /// Applies an allowance the server sent back with another answer.
  void apply(AiQuota? quota) {
    if (quota != null) state = quota;
  }

  /// Counts one call locally so the screen updates before the next refresh.
  void spendOne() {
    if (state.unlimited) return;
    final left = (state.remaining ?? 0) - 1;
    state = AiQuota(
      unlimited: false,
      freeDaily: state.freeDaily,
      used: state.used + 1,
      adCredits: state.adCredits,
      remaining: left < 0 ? 0 : left,
      adsWatched: state.adsWatched,
      maxAdsPerDay: state.maxAdsPerDay,
      canWatchAd: state.canWatchAd,
      resetsAt: state.resetsAt,
      themeTrialEndsAt: state.themeTrialEndsAt,
      pdfExportCredits: state.pdfExportCredits,
    );
  }
}

final aiQuotaProvider = StateNotifierProvider<AiQuotaNotifier, AiQuota>((ref) {
  // Becoming (or ceasing to be) Premium changes the allowance completely.
  ref.watch(premiumProvider.select((s) => s.isPremium));
  return AiQuotaNotifier(ref);
});
