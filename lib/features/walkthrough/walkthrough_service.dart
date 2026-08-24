import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/providers/walkthrough_provider.dart';
import 'package:the_accountant/features/walkthrough/widgets/walkthrough_tooltip.dart';

class WalkthroughService {
  static Future<void> showDashboardWalkthrough(
    BuildContext context,
    WidgetRef ref,
    Map<String, GlobalKey> keys,
  ) async {
    final steps = <_WalkthroughStep>[
      _WalkthroughStep(
        key: keys['balance']!,
        align: ContentAlign.bottom,
        icon: Icons.account_balance_wallet_rounded,
        title: 'Your Financial Overview',
        description:
            'See your total balance, income, and expenses at a glance. Swipe wallet cards to switch accounts.',
      ),
      _WalkthroughStep(
        key: keys['fab']!,
        align: ContentAlign.top,
        icon: Icons.add_circle_outline,
        title: 'Add Transactions',
        description: 'Tap here to quickly record a new income or expense.',
      ),
      _WalkthroughStep(
        key: keys['navHome']!,
        align: ContentAlign.top,
        icon: Icons.home_rounded,
        title: 'Home Dashboard',
        description:
            'Your home base with spending charts, recent transactions, and summaries.',
      ),
      _WalkthroughStep(
        key: keys['navActivity']!,
        align: ContentAlign.top,
        icon: Icons.receipt_long_rounded,
        title: 'Transaction Activity',
        description: 'Browse, search, and filter all your transactions here.',
      ),
      _WalkthroughStep(
        key: keys['navAI']!,
        align: ContentAlign.top,
        icon: Icons.auto_awesome,
        title: 'AI Assistant',
        description:
            'Get spending insights, scan receipts, or ask financial questions.',
      ),
      _WalkthroughStep(
        key: keys['notification']!,
        align: ContentAlign.bottom,
        icon: Icons.notifications_rounded,
        title: 'Stay Informed',
        description: "Budget alerts and reminders appear here. You're all set!",
      ),
    ];

    // Wait for the things being pointed at to exist.
    //
    // `tutorial_coach_mark` resolves a target through `key.currentContext`, and
    // when that is null it throws, catches its own exception, and quietly ends
    // the entire tutorial — which used to call `onFinish` and mark the
    // walkthrough as seen. A first run where the dashboard was still laying out
    // therefore burned the walkthrough permanently: the user saw a flash of the
    // first step, or nothing, and never got it again.
    if (!await _targetsReady(steps.map((step) => step.key).toList())) return;
    if (!context.mounted) return;

    // Whether the user did anything at all. `onFinish` fires both when someone
    // reaches the end and when a target could not be found, and those two must
    // not be recorded the same way.
    var userAdvanced = false;

    late TutorialCoachMark tutorialCoachMark;

    final targets = List.generate(steps.length, (index) {
      final step = steps[index];
      final isLast = index == steps.length - 1;

      return TargetFocus(
        identify: step.title,
        keyTarget: step.key,
        // A rectangle that hugs the widget, not a circle drawn around it. The
        // default circle has to be wide enough to contain a full-width card
        // corner to corner, so it swallowed most of the screen and pointed at
        // nothing in particular.
        shape: ShapeLightFocus.RRect,
        radius: 16,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: step.align,
            builder: (context, controller) {
              return WalkthroughTooltip(
                icon: step.icon,
                title: step.title,
                description: step.description,
                currentStep: index,
                totalSteps: steps.length,
                isLastStep: isLast,
                onSkip: () {
                  userAdvanced = true;
                  tutorialCoachMark.skip();
                },
                onNext: () {
                  userAdvanced = true;
                  controller.next();
                },
              );
            },
          ),
        ],
      );
    });

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: AppColors.primaryDark,
      opacityShadow: 0.85,
      hideSkip: true,
      onFinish: () {
        // Only when the user actually went through it. Reached without a single
        // tap, this is the library giving up on a target it could not find, and
        // treating that as "seen" is what made the failure permanent.
        if (userAdvanced) {
          ref.read(walkthroughProvider.notifier).markWalkthroughSeen();
        }
      },
      onSkip: () {
        ref.read(walkthroughProvider.notifier).markWalkthroughSeen();
        return true;
      },
    );

    tutorialCoachMark.show(context: context);
  }
}

/// Waits until every target is mounted, or gives up.
///
/// Giving up is deliberately silent and changes nothing: the walkthrough is
/// simply not shown this time, and is still waiting on the next launch. That is
/// far better than showing it against a half-built screen, which is how it got
/// thrown away in the first place.
Future<bool> _targetsReady(
  List<GlobalKey> keys, {
  Duration limit = const Duration(seconds: 6),
  Duration interval = const Duration(milliseconds: 100),
}) async {
  var waited = Duration.zero;
  while (waited < limit) {
    if (keys.every((key) => key.currentContext != null)) return true;
    await Future<void>.delayed(interval);
    waited += interval;
  }
  return false;
}

class _WalkthroughStep {
  final GlobalKey key;
  final ContentAlign align;
  final IconData icon;
  final String title;
  final String description;

  const _WalkthroughStep({
    required this.key,
    required this.align,
    required this.icon,
    required this.title,
    required this.description,
  });
}
