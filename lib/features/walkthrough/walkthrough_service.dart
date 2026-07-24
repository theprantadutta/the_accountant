import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/providers/walkthrough_provider.dart';
import 'package:the_accountant/features/walkthrough/widgets/walkthrough_tooltip.dart';

class WalkthroughService {
  static void showDashboardWalkthrough(
    BuildContext context,
    WidgetRef ref,
    Map<String, GlobalKey> keys,
  ) {
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

    late TutorialCoachMark tutorialCoachMark;

    final targets = List.generate(steps.length, (index) {
      final step = steps[index];
      final isLast = index == steps.length - 1;

      return TargetFocus(
        identify: step.title,
        keyTarget: step.key,
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
                onSkip: () => tutorialCoachMark.skip(),
                onNext: () => controller.next(),
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
        ref.read(walkthroughProvider.notifier).markWalkthroughSeen();
      },
      onSkip: () {
        ref.read(walkthroughProvider.notifier).markWalkthroughSeen();
        return true;
      },
    );

    tutorialCoachMark.show(context: context);
  }
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
