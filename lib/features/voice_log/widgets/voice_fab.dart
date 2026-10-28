import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/voice_log/providers/voice_fab_provider.dart';
import 'package:the_accountant/features/voice_log/widgets/voice_log_sheet.dart';
import 'package:the_accountant/features/voice_log/widgets/voice_orb.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The floating mic: a small glowing orb over Today that opens a voice entry.
///
/// It can be dragged anywhere and settles against the nearer edge, where it
/// stays next time. A long press offers to hide it. Lays itself out over the
/// whole body, so it goes in a [Stack] above the tabs.
class VoiceFab extends ConsumerStatefulWidget {
  const VoiceFab({super.key, required this.visible});

  /// False on the other tabs: it shrinks away rather than vanishing.
  final bool visible;

  static const double size = 84;

  @override
  ConsumerState<VoiceFab> createState() => _VoiceFabState();
}

class _VoiceFabState extends ConsumerState<VoiceFab> {
  /// Where a finger has it, while dragging. Null when it rests on an edge.
  Offset? _drag;

  /// The halo is drawn inside the orb's box, so the box can sit past the edge.
  static const double _edge = -6;

  Future<void> _offerToHide() async {
    HapticFeedback.mediumImpact();
    final l10n = L10n.of(context);
    final hide = await showSunriseConfirm(
      context: context,
      title: l10n.voiceFabHideTitle,
      message: l10n.voiceFabHideBody,
      confirmLabel: l10n.voiceFabHide,
      icon: Symbols.mic_off_rounded,
    );
    if (hide) await ref.read(voiceFabProvider.notifier).setEnabled(false);
  }

  @override
  Widget build(BuildContext context) {
    final fab = ref.watch(voiceFabProvider);
    final media = MediaQuery.of(context);
    const size = VoiceFab.size;

    return LayoutBuilder(
      builder: (context, box) {
        // Below Today's header, above the tab bar. The shell extends its body
        // under the bar, so the bar is already in the bottom padding; the
        // halo may overlap it a little, the orb itself never.
        final top = media.padding.top + 72;
        final bottom = box.maxHeight - size - media.padding.bottom + 10;
        final span = math.max(0.0, bottom - top);
        final restLeft = fab.onLeft ? _edge : box.maxWidth - size - _edge;
        final restTop = top + span * fab.height;
        final at = _drag ?? Offset(restLeft, restTop);

        return Stack(
          children: [
            AnimatedPositioned(
              duration: _drag == null
                  ? const Duration(milliseconds: 420)
                  : Duration.zero,
              curve: Curves.easeOutBack,
              left: at.dx,
              top: at.dy,
              child: IgnorePointer(
                ignoring: !widget.visible,
                child: AnimatedScale(
                  scale: widget.visible ? 1 : 0,
                  duration: const Duration(milliseconds: 320),
                  curve: widget.visible ? Curves.easeOutBack : Curves.easeIn,
                  child: GestureDetector(
                    onPanStart: (_) => setState(() => _drag = at),
                    onPanUpdate: (d) => setState(
                      () => _drag = Offset(
                        (_drag!.dx + d.delta.dx).clamp(
                          _edge,
                          box.maxWidth - size - _edge,
                        ),
                        (_drag!.dy + d.delta.dy).clamp(top, bottom),
                      ),
                    ),
                    onPanEnd: (_) {
                      final dropped = _drag!;
                      final onLeft = dropped.dx + size / 2 < box.maxWidth / 2;
                      HapticFeedback.selectionClick();
                      ref
                          .read(voiceFabProvider.notifier)
                          .moveTo(
                            onLeft: onLeft,
                            height: span == 0 ? 0 : (dropped.dy - top) / span,
                          );
                      setState(() => _drag = null);
                    },
                    onLongPress: _offerToHide,
                    child: Semantics(
                      button: true,
                      label: L10n.of(context).voiceButton,
                      child: Pressable(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          startVoiceLog(context, ref);
                        },
                        child: const VoiceOrb(
                          mode: VoiceOrbMode.idle,
                          size: size,
                          icon: Symbols.mic_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Asks, once, whether the user wants the floating mic. Yes turns it on; any
/// other answer, dismissing included, leaves it off and is not asked again.
Future<void> askAboutVoiceFab(BuildContext context, WidgetRef ref) async {
  final notifier = ref.read(voiceFabProvider.notifier);
  final yes = await showSunriseSheet<bool>(
    context: context,
    builder: (ctx) {
      final c = ctx.sunrise;
      final l10n = L10n.of(ctx);
      return SunriseBottomSheet(
        actions: [
          SunriseButton(
            key: const Key('voice_fab_yes'),
            label: l10n.voiceFabAskYes,
            icon: Symbols.mic_rounded,
            height: 54,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
          SunriseButton.secondary(
            key: const Key('voice_fab_no'),
            label: l10n.voiceFabAskNo,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TodayPreview(),
            const SizedBox(height: 20),
            Text(
              l10n.voiceFabAskTitle,
              style: SunriseType.section.copyWith(color: c.ink, fontSize: 21),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.voiceFabAskBody,
              style: SunriseType.body.copyWith(color: c.body, height: 1.45),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Symbols.tune_rounded, size: 16, color: c.muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.voiceFabAskLater,
                    style: SunriseType.label.copyWith(
                      color: c.muted,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
  await notifier.setEnabled(yes ?? false);
}

/// A sketch of Today with the orb floating on it, so the question shows what
/// the answer looks like.
class _TodayPreview extends StatelessWidget {
  const _TodayPreview();

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    Widget bar(double width, {double height = 10, double alpha = .12}) =>
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: c.ink.withValues(alpha: alpha),
            borderRadius: BorderRadius.circular(height),
          ),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 184,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c.washTop, c.washMid, c.base],
          ),
          border: Border.all(color: c.tabBarBorder),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      bar(84, height: 12, alpha: .2),
                      const Spacer(),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: c.orbGradient,
                        ),
                      ),
                      const SizedBox(width: 8),
                      bar(22, height: 22, alpha: .08),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: c.gradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final w in const [150.0, 110.0]) ...[
                    Row(
                      children: [
                        bar(22, height: 22, alpha: .08),
                        const SizedBox(width: 10),
                        bar(w),
                      ],
                    ),
                    const SizedBox(height: 9),
                  ],
                ],
              ),
            ),
            const Positioned(
              right: 4,
              bottom: 2,
              child: VoiceOrb(
                mode: VoiceOrbMode.listening,
                level: .45,
                size: 92,
                icon: Symbols.mic_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
