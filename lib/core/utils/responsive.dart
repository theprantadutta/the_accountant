import 'package:flutter/widgets.dart';

/// Responsive layout helpers for The Accountant.
///
/// The app is phone-first. On larger screens (iPad, desktop, web) we keep the
/// UI legible by centering content within a comfortable max width rather than
/// stretching every form and card edge-to-edge. These helpers centralize the
/// breakpoints so screens stay consistent.
class Breakpoints {
  Breakpoints._();

  /// A device is treated as a "tablet" (or larger) once its shortest side
  /// reaches this width in logical pixels. 600 is the conventional Material
  /// phone/tablet boundary and matches a 7"+ device.
  static const double tablet = 600;

  /// Maximum width primary page content is allowed to occupy. On phones this is
  /// wider than the screen (so it's a no-op); on tablets it centers content and
  /// prevents the "stretched phone app" look.
  static const double contentMaxWidth = 640;
}

/// Whether the current context is a tablet-sized (or larger) screen.
bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).shortestSide >= Breakpoints.tablet;

/// Centers [child] and caps its width at [maxWidth] (defaults to
/// [Breakpoints.contentMaxWidth]).
///
/// On phones the constraint is wider than the screen, so this passes through
/// unchanged. On tablets/desktop it letterboxes the content to a readable
/// column while any ambient background painted behind it stays full-bleed.
class AdaptiveWidth extends StatelessWidget {
  const AdaptiveWidth({super.key, required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Breakpoints.contentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}
