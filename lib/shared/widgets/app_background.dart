import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// Ambient gradient background used app-wide (and on the auth screens).
///
/// Renders the app's base [AppColors.backgroundGradient] with a few large,
/// softly-glowing colour orbs. The orbs use radial gradients that fade to full
/// transparency, so they read as diffuse neon light rather than hard shapes —
/// giving every screen the same depth as the auth flow without the cost of a
/// live [BackdropFilter].
///
/// Placed once behind the whole app (via `MaterialApp.builder`), so screens just
/// keep their scaffolds transparent and this shows through. When [animate] is
/// true the orbs slowly drift; pass false for a calmer static backdrop.
class AppBackground extends StatefulWidget {
  const AppBackground({super.key, required this.child, this.animate = true});

  final Widget child;
  final bool animate;

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Desynchronised drivers so the orbs never move in lockstep.
    final forward = _controller;
    final reverse = ReverseAnimation(_controller);
    final eased = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: ClipRect(
        child: Stack(
          children: [
            _orb(
              color: AppColors.primaryGlow,
              size: 360,
              from: const Alignment(-1.1, -1.0),
              to: const Alignment(-0.5, -0.55),
              animation: forward,
              opacity: 0.38,
            ),
            _orb(
              color: AppColors.neonCyan,
              size: 300,
              from: const Alignment(1.2, -0.5),
              to: const Alignment(0.7, 0.05),
              animation: eased,
              opacity: 0.26,
            ),
            _orb(
              color: AppColors.neonPurple,
              size: 340,
              from: const Alignment(1.1, 1.1),
              to: const Alignment(0.4, 0.7),
              animation: reverse,
              opacity: 0.30,
            ),
            // Isolate content repaints from the animated background layer.
            RepaintBoundary(child: widget.child),
          ],
        ),
      ),
    );
  }

  Widget _orb({
    required Color color,
    required double size,
    required Alignment from,
    required Alignment to,
    required Animation<double> animation,
    required double opacity,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment.lerp(from, to, animation.value)!,
          child: child,
        );
      },
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
