import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/premium/screens/premium_screen.dart';

/// Helpers for launching the paywall and gating premium features.
class PaywallUtils {
  PaywallUtils._();

  /// Show the paywall as a modal route. [featureName] is shown as context to
  /// the user (e.g. "You tried to use AI Chat, which is Premium").
  static Future<bool?> showPaywall(
    BuildContext context, {
    String? featureName,
    String? customTitle,
    String? customDescription,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PremiumScreen(
          triggerFeatureName: featureName,
          customTitle: customTitle,
          customDescription: customDescription,
        ),
      ),
    );
  }

  /// Returns true if the user is premium; otherwise opens the paywall and
  /// resolves to whatever the paywall returns (true if upgraded, else false).
  static Future<bool> ensurePremium(
    BuildContext context,
    WidgetRef ref, {
    String? featureName,
  }) async {
    final isPremium = ref.read(premiumProvider).isPremium;
    if (isPremium) return true;

    final result = await showPaywall(context, featureName: featureName);
    // Re-read after the paywall closes — purchase flow may have upgraded us.
    return result == true || ref.read(premiumProvider).isPremium;
  }
}
