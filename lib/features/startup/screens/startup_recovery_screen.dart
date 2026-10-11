import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_background.dart';
import 'package:the_accountant/features/premium/screens/premium_screen.dart';

/// Shown when the app could not establish what this account holds.
///
/// The screen this replaces was "Create your first wallet", reached by a
/// three-second timeout. For a returning user on a slow network that was not
/// merely wrong, it was dangerous: it invited them to start over on top of data
/// the app had simply failed to look for, and any wallet they created that way
/// landed alongside their real one.
///
/// So an unresolved state gets its own screen, which says what is unknown,
/// promises nothing about the data, and makes the only two honest options
/// explicit — try again, or continue offline having been told what that means.
class StartupRecoveryScreen extends ConsumerStatefulWidget {
  const StartupRecoveryScreen({super.key});

  @override
  ConsumerState<StartupRecoveryScreen> createState() =>
      _StartupRecoveryScreenState();
}

class _StartupRecoveryScreenState extends ConsumerState<StartupRecoveryScreen> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    try {
      await ref.read(startupFlowProvider.notifier).retry();
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  Future<void> _startOffline() async {
    final confirmed = await showSunriseConfirm(
      context: context,
      title: L10n.of(context).startupContinueWithoutChecking,
      message:
          'Your data stays exactly where it is — nothing on this device or in '
          'the cloud will be deleted.\n\n'
          'But if the account does have data saved, anything you add now will '
          'sit alongside it once you restore — you may end up with duplicates '
          'to tidy up.',
      confirmLabel: L10n.of(context).startupContinueOffline,
      cancelLabel: L10n.of(context).actionCancel,
      icon: Symbols.cloud_off_rounded,
    );
    if (!confirmed) return;
    ref.read(startupFlowProvider.notifier).startOfflineAnyway();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(startupFlowProvider);
    final needsSubscription = flow.needsSubscription;
    final c = context.sunrise;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SunriseSpace.screenX),
              child: SunriseContentWidth(
                child: SunriseCard(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
                  child: Column(
                    children: [
                      IconTile(
                        icon: needsSubscription
                            ? Symbols.workspace_premium_rounded
                            : Symbols.cloud_off_rounded,
                        color: c.accent,
                        size: 72,
                        iconSize: 36,
                        radius: 24,
                        fill: 1,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        needsSubscription
                            ? 'Your data is waiting in the cloud'
                            : "We couldn't finish loading your account",
                        style: SunriseType.pushTitle.copyWith(color: c.ink),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        flow.reason ??
                            'Something went wrong while checking this account.',
                        style: SunriseType.body.copyWith(color: c.body),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        L10n.of(context).startupNothingHasBeenChangedOr,
                        style: SunriseType.caption.copyWith(color: c.muted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      SunriseButton(
                        label: _retrying ? 'Checking…' : 'Try again',
                        icon: Symbols.refresh_rounded,
                        loading: _retrying,
                        onPressed: _retrying ? null : _retry,
                      ),
                      if (needsSubscription) ...[
                        const SizedBox(height: 10),
                        SunriseButton(
                          style: SunriseButtonStyle.secondary,
                          label: L10n.of(
                            context,
                          ).startupViewSubscriptionOptions,
                          icon: Symbols.workspace_premium_rounded,
                          onPressed: _retrying
                              ? null
                              : () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const PremiumScreen(),
                                  ),
                                ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      SunriseButton(
                        style: SunriseButtonStyle.ghost,
                        label: needsSubscription
                            ? 'Use the app without restoring'
                            : 'Continue offline',
                        onPressed: _retrying ? null : _startOffline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
