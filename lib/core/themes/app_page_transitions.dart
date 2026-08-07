import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// Route animations for every theme in the app, default and premium alike, so
/// navigation feels identical whichever palette is active.
///
/// Every platform gets the same builder: the stock per-platform ones all
/// misbehave over transparent scaffolds. See
/// [FadeThroughPageTransitionsBuilder].
const PageTransitionsTheme appPageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
    TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
    TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
    TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
    TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
    TargetPlatform.fuchsia: FadeThroughPageTransitionsBuilder(),
  },
);

/// Route transitions built for an app whose scaffolds are transparent.
///
/// Every screen sits over one shared [AppBackground] gradient, so a route is
/// see-through. That rules out the stock builders: [FadeUpwardsPageTransitionsBuilder]
/// and [CupertinoPageTransitionsBuilder] animate only the arriving route and
/// leave the departing one fully opaque underneath, so the old screen shows
/// straight through the new one for the whole transition — read as a "flash"
/// of the previous screen. [ZoomPageTransitionsBuilder] avoids that only by
/// snapshotting each route onto an opaque surface, which hides the shared
/// gradient instead.
///
/// The fix is a Material 3 fade-through: the two routes never share the screen.
/// The departing route fades out over the first [_switchPoint] of the timeline,
/// then the arriving route fades in over the rest while scaling up slightly.
/// The handoff lands on the ambient background, which never moves — so the
/// screen dissolves and re-forms in place instead of double-exposing.
class FadeThroughPageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeThroughPageTransitionsBuilder();

  @override
  Duration get transitionDuration => AppAnimations.normal;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// A [PageRoute] that plays the same fade-through as the app theme.
///
/// Use for one-off pushes that need a custom builder (a non-const page, an
/// argument-carrying screen) so they match theme-driven navigation instead of
/// re-introducing an overlapping fade.
class FadeThroughPageRoute<T> extends PageRouteBuilder<T> {
  FadeThroughPageRoute({required this.builder, super.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionDuration: AppAnimations.normal,
        reverseTransitionDuration: AppAnimations.normal,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      );

  final WidgetBuilder builder;
}

/// Cross-fades two routes without ever showing both at once.
///
/// [animation] drives this route arriving; [secondaryAnimation] drives it being
/// covered by the next one. Handling both is the point — a builder that ignores
/// [secondaryAnimation] leaves the covered route painting at full opacity.
class FadeThroughTransition extends StatelessWidget {
  FadeThroughTransition({
    super.key,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required this.child,
  }) : _enterOpacity = animation.drive(_enterOpacityTween),
       _enterScale = animation.drive(_enterScaleTween),
       _exitOpacity = secondaryAnimation.drive(_exitOpacityTween);

  /// Fraction of the timeline spent clearing the old route before the new one
  /// starts appearing. Below ~0.25 the two overlap perceptibly again.
  static const double _switchPoint = 0.3;

  /// How small the arriving route starts. Subtle on purpose: enough to read as
  /// forward motion, not so much that the layout visibly resizes.
  static const double _enterScaleFrom = 0.94;

  static final Animatable<double> _enterOpacityTween = CurveTween(
    curve: const Interval(_switchPoint, 1.0, curve: Curves.easeOut),
  );

  static final Animatable<double> _enterScaleTween =
      Tween<double>(begin: _enterScaleFrom, end: 1.0).chain(
        CurveTween(curve: const Interval(_switchPoint, 1.0, curve: Curves.easeOutCubic)),
      );

  // Inverted so the covered route is at full opacity when secondaryAnimation is
  // 0 and gone by the time it reaches _switchPoint.
  static final Animatable<double> _exitOpacityTween =
      Tween<double>(begin: 1.0, end: 0.0).chain(
        CurveTween(curve: const Interval(0.0, _switchPoint, curve: Curves.easeIn)),
      );

  final Animation<double> _enterOpacity;
  final Animation<double> _enterScale;
  final Animation<double> _exitOpacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _exitOpacity,
      child: FadeTransition(
        opacity: _enterOpacity,
        child: ScaleTransition(scale: _enterScale, child: child),
      ),
    );
  }
}
