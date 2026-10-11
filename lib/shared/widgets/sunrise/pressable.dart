import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';

/// Scales its child to 0.97 while pressed (120ms), the Sunrise press feedback.
///
/// Use it instead of an ink ripple on cards, tiles and buttons. A null [onTap]
/// and [onLongPress] make it inert, with no feedback.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.haptic = false,
    this.scale = .97,
    this.semanticLabel,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Fire a light haptic on tap.
  final bool haptic;
  final double scale;

  /// Announced as a button when set.
  final String? semanticLabel;
  final HitTestBehavior behavior;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  void _set(bool down) {
    if (_down == down || !mounted) return;
    setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedScale(
      scale: _down ? widget.scale : 1,
      duration: SunriseMotion.press,
      curve: Curves.easeOut,
      child: widget.child,
    );
    if (!_enabled) return child;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: widget.behavior,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap == null
            ? null
            : () {
                if (widget.haptic) HapticFeedback.lightImpact();
                widget.onTap!();
              },
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                _set(false);
                HapticFeedback.selectionClick();
                widget.onLongPress!();
              },
        child: child,
      ),
    );
  }
}
