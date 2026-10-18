import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai_assistant/models/ai_quota.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// The shared AI client.
final aiApiProvider = Provider<AiApi>((ref) => AiApi());

/// This month's AI allowance.
///
/// The server is the authority; this holds its last answer so screens can say
/// "3 free requests left this month" without asking each time. Refresh after any AI
/// call or ad. Premium is unlimited and never needs to ask.
class AiQuotaNotifier extends StateNotifier<AiQuota> {
  AiQuotaNotifier(this._ref) : super(AiQuota.initial) {
    refresh();
  }

  final Ref _ref;

  bool get _isPremium => _ref.read(premiumProvider).isPremium;

  Future<void> refresh() async {
    if (_isPremium) {
      state = AiQuota.premium;
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

  /// Waits for a rewarded ad's reward to land.
  ///
  /// The reward is paid by AdMob calling the server, not by the app, so it
  /// arrives a moment after the ad closes. Polls until the server's count of
  /// ads moves past [adsBefore], or gives up after about fifteen seconds.
  Future<bool> waitForReward(int adsBefore) async {
    for (var i = 0; i < 8; i++) {
      await Future<void>.delayed(Duration(milliseconds: i == 0 ? 1200 : 1800));
      try {
        final latest = await _ref.read(aiApiProvider).quota();
        state = latest;
        if (latest.adsWatched > adsBefore) return true;
      } catch (_) {
        // Try again; a dropped request is not a lost reward.
      }
    }
    return false;
  }

  /// Applies an allowance the server sent back with another answer.
  void apply(AiQuota? quota) {
    if (quota != null) state = quota;
  }

  /// Counts one call locally so the screen updates before the next refresh.
  void spendOne() {
    if (state.unlimited) return;
    final left = (state.remaining ?? 0) - 1;
    state = state.copyWith(used: state.used + 1, remaining: left < 0 ? 0 : left);
  }
}

final aiQuotaProvider = StateNotifierProvider<AiQuotaNotifier, AiQuota>((ref) {
  // Becoming (or ceasing to be) Premium changes the allowance completely.
  ref.watch(premiumProvider.select((s) => s.isPremium));
  return AiQuotaNotifier(ref);
});
