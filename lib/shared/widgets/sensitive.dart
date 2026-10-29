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

/// A line of words with balances or totals in it, where only the figures
/// hide: "Paid ৳4,000 of ৳12,000" keeps "Paid" and "of", which say what the
/// figures are.
///
/// While amounts are shown it is the plain line, so a screen reader reads it
/// as one sentence rather than in pieces around each figure.
class SensitiveText extends ConsumerWidget {
  const SensitiveText(
    this.text, {
    super.key,
    required this.amounts,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;

  /// The figures in [text], each exactly as it appears there.
  final List<String> amounts;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (amounts.isEmpty || !ref.watch(amountsHiddenProvider)) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }
    final ranges = <(int, int)>[];
    for (final amount in amounts) {
      var at = amount.isEmpty ? -1 : text.indexOf(amount);
      while (at >= 0 &&
          ranges.any((r) => at < r.$2 && at + amount.length > r.$1)) {
        at = text.indexOf(amount, at + 1);
      }
      // A translation that writes the figure differently: hide the whole
      // line rather than risk showing it.
      if (at < 0) {
        return Sensitive(
          child: Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          ),
        );
      }
      ranges.add((at, at + amount.length));
    }
    ranges.sort((a, b) => a.$1.compareTo(b.$1));

    final spans = <InlineSpan>[];
    var from = 0;
    for (final (start, end) in ranges) {
      if (start > from) spans.add(TextSpan(text: text.substring(from, start)));
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Sensitive(
            child: Text(
              text.substring(start, end),
              style: style,
              maxLines: 1,
              // The span already scales its widget with the text around it.
              textScaler: TextScaler.noScaling,
            ),
          ),
        ),
      );
      from = end;
    }
    if (from < text.length) spans.add(TextSpan(text: text.substring(from)));
    return Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
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
