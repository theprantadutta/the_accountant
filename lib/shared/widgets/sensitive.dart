import 'dart:ui' show ImageFilter, TileMode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/privacy_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// A balance or total that hides while amounts are hidden.
///
/// Blurred rather than swapped for dots, so it keeps its size and the layout
/// does not jump when it is shown; and kept out of what a screen reader says.
/// Tapping it shows every amount, unless the user turned that off, in which
/// case the tap goes to whatever is underneath as usual.
///
/// Wrap balances and totals with it. A single transaction's amount is left
/// visible, so the lists stay usable with amounts hidden.
class Sensitive extends ConsumerWidget {
  const Sensitive({super.key, required this.child});

  final Widget child;

  /// Enough to make large figures unreadable without turning small ones
  /// into a smear that no longer reads as a number at all.
  static const double _sigma = 7;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacy = ref.watch(privacyProvider);
    final hidden = privacy.hideAmounts;

    final shown = TweenAnimationBuilder<double>(
      tween: Tween(end: hidden ? _sigma : 0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: child,
      builder: (context, sigma, child) => sigma < .1
          ? child!
          : ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: sigma,
                sigmaY: sigma,
                tileMode: TileMode.decal,
              ),
              child: child,
            ),
    );
    if (!hidden) return shown;

    final l10n = L10n.of(context);
    final masked = Semantics(
      label: l10n.amountHidden,
      button: privacy.tapToReveal,
      excludeSemantics: true,
      child: shown,
    );
    if (!privacy.tapToReveal) return masked;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(privacyProvider.notifier).setHidden(false);
      },
      child: masked,
    );
  }
}

/// The eye that shows or hides every balance and total.
class PrivacyEyeButton extends ConsumerWidget {
  const PrivacyEyeButton({super.key, required this.builder});

  /// Draws the button with the right icon and label, so each header can use
  /// its own button style.
  final Widget Function(IconData icon, String tooltip, VoidCallback onTap)
  builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final hidden = ref.watch(amountsHiddenProvider);
    return builder(
      hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
      hidden ? l10n.privacyShowAmounts : l10n.privacyHideAmounts,
      () {
        HapticFeedback.selectionClick();
        ref.read(privacyProvider.notifier).toggle();
      },
    );
  }
}
