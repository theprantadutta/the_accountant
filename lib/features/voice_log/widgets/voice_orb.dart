import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

enum VoiceOrbMode { idle, listening, thinking, done }

/// The glowing sunrise orb at the heart of a voice entry.
///
/// Idle it breathes; listening, rings ripple out and the core swells with the
/// voice ([level], 0 to 1); thinking, it spins with sparks circling it. All in
/// the theme's gradient, so it reads as the same app in every theme.
class VoiceOrb extends StatefulWidget {
  const VoiceOrb({
    super.key,
    required this.mode,
    this.level = 0,
    this.size = 200,
    this.icon,
  });

  final VoiceOrbMode mode;
  final double level;
  final double size;

  /// Drawn in the middle of the core: the mic, a check when done.
  final IconData? icon;

  @override
  State<VoiceOrb> createState() => _VoiceOrbState();
}

class _VoiceOrbState extends State<VoiceOrb> with TickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return SizedBox.square(
      dimension: widget.size,
      // Eases the voice level in and out so the core swells, not flickers.
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: widget.level.clamp(0, 1)),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        builder: (context, level, _) => AnimatedBuilder(
          animation: _clock,
          builder: (context, child) => CustomPaint(
            painter: _OrbPainter(
              t: reduceMotion ? 0 : _clock.value,
              level: level,
              mode: widget.mode,
              highlight: c.orbHighlight,
              start: c.gradientStart,
              mid: c.gradientMid,
              end: c.gradientEnd,
              glow: c.glow,
            ),
            child: child,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, a) => ScaleTransition(
                scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
                child: FadeTransition(opacity: a, child: child),
              ),
              child: widget.icon == null
                  ? const SizedBox.shrink()
                  : Icon(
                      widget.icon,
                      key: ValueKey(widget.icon),
                      size: widget.size * .2,
                      color: Colors.white,
                      fill: 1,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter({
    required this.t,
    required this.level,
    required this.mode,
    required this.highlight,
    required this.start,
    required this.mid,
    required this.end,
    required this.glow,
  });

  /// 0..1 over twelve seconds.
  final double t;
  final double level;
  final VoiceOrbMode mode;
  final Color highlight, start, mid, end, glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final tau = math.pi * 2;
    final listening = mode == VoiceOrbMode.listening;
    final thinking = mode == VoiceOrbMode.thinking;

    // Breathing, a slow swell that never stops.
    final breath = math.sin(t * tau * 5) * .5 + .5;
    final core =
        r *
        (.5 +
            .03 * breath +
            (listening ? .1 * level : 0) +
            (mode == VoiceOrbMode.done ? .04 : 0));

    // The halo.
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [
            glow.withValues(alpha: .55 + .25 * level),
            glow.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    // Ripples: three rings drifting outward, louder voice, brighter rings.
    if (listening) {
      for (var i = 0; i < 3; i++) {
        final p = (t * 6 + i / 3) % 1;
        final radius = core + (r - core) * p;
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2 + 3 * level
            ..color = mid.withValues(alpha: (1 - p) * (.25 + .5 * level)),
        );
      }
    }

    // The core: a lit sphere in the theme gradient.
    final coreRect = Rect.fromCircle(center: center, radius: core);
    canvas.drawCircle(
      center,
      core,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.35, -.45),
          radius: 1,
          colors: [highlight, mid, end],
          stops: const [0, .55, 1],
        ).createShader(coreRect),
    );

    // A sheen turning across it, faster while thinking.
    canvas.save();
    canvas.clipPath(Path()..addOval(coreRect));
    final spin = t * tau * (thinking ? 8 : 1.5);
    canvas.drawCircle(
      center,
      core,
      Paint()
        ..blendMode = BlendMode.softLight
        ..shader = SweepGradient(
          transform: GradientRotation(spin),
          colors: [
            Colors.white.withValues(alpha: .0),
            Colors.white.withValues(alpha: .55),
            start.withValues(alpha: .0),
            end.withValues(alpha: .35),
            Colors.white.withValues(alpha: .0),
          ],
        ).createShader(coreRect),
    );
    // A soft highlight, top left.
    canvas.drawCircle(
      center + Offset(-core * .35, -core * .42),
      core * .38,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.white.withValues(alpha: .45),
                Colors.white.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(
                center: center + Offset(-core * .35, -core * .42),
                radius: core * .38,
              ),
            ),
    );
    canvas.restore();

    // Thinking: sparks circling the core.
    if (thinking) {
      for (var i = 0; i < 6; i++) {
        final a = t * tau * 6 + i * tau / 6;
        final orbit = core + (r - core) * .45;
        final pos = center + Offset(math.cos(a), math.sin(a)) * orbit;
        final pulse = (math.sin(t * tau * 18 + i) * .5 + .5);
        canvas.drawCircle(
          pos,
          2.5 + 2.5 * pulse,
          Paint()..color = highlight.withValues(alpha: .5 + .5 * pulse),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) =>
      old.t != t || old.level != level || old.mode != mode;
}
