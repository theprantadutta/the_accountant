import 'package:flutter/material.dart';

/// Animation constants and utilities for The Accountant app
/// Consistent timing and curves across the app
class AppAnimations {
  AppAnimations._();

  // ============================================
  // DURATIONS
  // ============================================

  /// 100ms - Instant feedback (button press)
  static const Duration instant = Duration(milliseconds: 100);

  /// 150ms - Quick micro-interaction
  static const Duration quick = Duration(milliseconds: 150);

  /// 200ms - Fast transitions (hover, focus)
  static const Duration fast = Duration(milliseconds: 200);

  /// 300ms - Normal transitions (page, modal)
  static const Duration normal = Duration(milliseconds: 300);

  /// 400ms - Medium transitions
  static const Duration medium = Duration(milliseconds: 400);

  /// 500ms - Slow transitions (complex animations)
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms - Dramatic/emphasis animations
  static const Duration dramatic = Duration(milliseconds: 800);

  /// 1000ms - Long animations (loading, intro)
  static const Duration long = Duration(milliseconds: 1000);

  /// 1500ms - Very long (page intro sequences)
  static const Duration veryLong = Duration(milliseconds: 1500);

  // ============================================
  // CURVES - Standard
  // ============================================

  /// Default ease out - decelerating
  static const Curve easeOut = Curves.easeOutCubic;

  /// Default ease in - accelerating
  static const Curve easeIn = Curves.easeInCubic;

  /// Ease in and out - smooth both ends
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Linear - constant speed
  static const Curve linear = Curves.linear;

  // ============================================
  // CURVES - Special
  // ============================================

  /// Bounce effect - playful ending
  static const Curve bounce = Curves.elasticOut;

  /// Spring effect - snappy
  static const Curve spring = Curves.easeOutBack;

  /// Overshoot - goes past target then settles
  static const Curve overshoot = Curves.easeOutBack;

  /// Decelerate - quick start, slow end
  static const Curve decelerate = Curves.decelerate;

  /// Fast out, slow in (Material emphasized)
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  // ============================================
  // SCALE VALUES
  // ============================================

  /// Scale when pressed (buttons, cards)
  static const double pressedScale = 0.95;

  /// Scale when tapped (quick feedback)
  static const double tappedScale = 0.97;

  /// Scale when hovered (desktop)
  static const double hoverScale = 1.02;

  /// Scale for entrance animations
  static const double enterScale = 0.8;

  // ============================================
  // OFFSET VALUES
  // ============================================

  /// Slide in from bottom offset
  static const Offset slideFromBottom = Offset(0, 0.3);

  /// Slide in from top offset
  static const Offset slideFromTop = Offset(0, -0.3);

  /// Slide in from right offset
  static const Offset slideFromRight = Offset(0.3, 0);

  /// Slide in from left offset
  static const Offset slideFromLeft = Offset(-0.3, 0);

  // ============================================
  // STAGGER DELAYS
  // ============================================

  /// Delay between staggered items (list animations)
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Longer stagger for emphasis
  static const Duration staggerDelayLong = Duration(milliseconds: 100);

  /// Quick stagger for dense lists
  static const Duration staggerDelayQuick = Duration(milliseconds: 30);

  // ============================================
  // PAGE TRANSITIONS
  // ============================================

  /// Fade transition
  static Widget fadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: easeOut),
      child: child,
    );
  }

  /// Slide up transition
  static Widget slideUpTransition(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: slideFromBottom,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Scale fade transition
  static Widget scaleFadeTransition(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: enterScale,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: easeOut)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Create a curved animation
  static CurvedAnimation curved(
    Animation<double> parent, {
    Curve curve = easeOut,
  }) {
    return CurvedAnimation(parent: parent, curve: curve);
  }

  /// Create an interval animation (for staggering)
  static CurvedAnimation interval(
    Animation<double> parent,
    double begin,
    double end, {
    Curve curve = easeOut,
  }) {
    return CurvedAnimation(
      parent: parent,
      curve: Interval(begin, end, curve: curve),
    );
  }

  /// Create stagger animation for index
  static CurvedAnimation stagger(
    Animation<double> parent,
    int index, {
    int itemCount = 10,
    Curve curve = easeOut,
  }) {
    final begin = index / (itemCount + 1);
    final end = (index + 1) / (itemCount + 1);
    return interval(parent, begin, end.clamp(0.0, 1.0), curve: curve);
  }

  // ============================================
  // TWEEN FACTORIES
  // ============================================

  /// Fade tween (0 -> 1)
  static Tween<double> get fadeTween => Tween<double>(begin: 0.0, end: 1.0);

  /// Scale tween (pressedScale -> 1)
  static Tween<double> get pressTween =>
      Tween<double>(begin: pressedScale, end: 1.0);

  /// Scale tween (enterScale -> 1)
  static Tween<double> get enterTween =>
      Tween<double>(begin: enterScale, end: 1.0);

  /// Slide from bottom tween
  static Tween<Offset> get slideUpTween =>
      Tween<Offset>(begin: slideFromBottom, end: Offset.zero);

  /// Slide from right tween
  static Tween<Offset> get slideLeftTween =>
      Tween<Offset>(begin: slideFromRight, end: Offset.zero);
}

/// Extension for easier animation controller creation
extension AnimationControllerExtension on TickerProvider {
  /// Create an animation controller with app defaults
  AnimationController createController({
    Duration duration = AppAnimations.normal,
  }) {
    return AnimationController(vsync: this, duration: duration);
  }
}
