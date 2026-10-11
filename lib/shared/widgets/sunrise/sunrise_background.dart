import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';

/// The warm wash at the top of every screen.
///
/// [tall] is for tab roots, short for pushed screens. It fills its parent and
/// paints the base colour below the wash, so a screen never shows through to
/// whatever is behind it.
class SunriseBackground extends StatelessWidget {
  const SunriseBackground({super.key, required this.child, this.tall = true});

  final Widget child;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.base,
        gradient: tall ? c.washTall : c.washShort,
      ),
      child: child,
    );
  }
}

/// A frosted panel: blurred backdrop under a translucent fill.
class SunriseGlass extends StatelessWidget {
  const SunriseGlass({
    super.key,
    required this.child,
    this.color,
    this.radius = BorderRadius.zero,
    this.blur = 20,
    this.border,
  });

  final Widget child;

  /// Defaults to the token `glass` fill.
  final Color? color;
  final BorderRadius radius;
  final double blur;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? context.sunrise.glass,
            borderRadius: radius,
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}
