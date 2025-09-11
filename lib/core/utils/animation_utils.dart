import 'package:flutter/material.dart';

class AnimationUtils {
  /// Create a fade transition animation
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Create a slide transition animation
  static Widget slideTransition({
    required Animation<double> animation,
    required Widget child,
    Offset? begin,
    Offset? end,
  }) {
    begin ??= const Offset(1, 0);
    end ??= Offset.zero;

    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(animation),
      child: child,
    );
  }

  /// Create a scale transition animation
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
    double? begin,
    double? end,
  }) {
    begin ??= 0.0;
    end ??= 1.0;

    return ScaleTransition(
      scale: Tween<double>(begin: begin, end: end).animate(animation),
      child: child,
    );
  }

  /// Create a rotation transition animation
  static Widget rotationTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return RotationTransition(turns: animation, child: child);
  }

  /// Create a size transition animation
  static Widget sizeTransition({
    required Animation<double> animation,
    required Widget child,
    Axis axis = Axis.vertical,
  }) {
    return SizeTransition(axis: axis, sizeFactor: animation, child: child);
  }

  /// Create a custom curved animation
  static Animation<double> createCurvedAnimation({
    required AnimationController controller,
    Curve curve = Curves.easeInOut,
  }) {
    return CurvedAnimation(parent: controller, curve: curve);
  }

  /// Create a page transition animation
  static PageRouteBuilder<T> createPageTransition<T>({
    required Widget Function(BuildContext, Animation<double>, Animation<double>)
    pageBuilder,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: pageBuilder,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return FadeTransition(opacity: curvedAnimation, child: child);
      },
      transitionDuration: duration,
    );
  }

  /// Create a staggered animation
  static Animation<double> createStaggeredAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    double startFraction = 0.0,
    double endFraction = 1.0,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startFraction, endFraction, curve: Curves.easeInOut),
      ),
    );
  }
}
