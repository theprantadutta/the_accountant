import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Continue without checking?'),
        content: const Text(
          'Your data stays exactly where it is — nothing on this device or in '
          'the cloud will be deleted.\n\n'
          'But if the account does have data saved, anything you add now will '
          'sit alongside it once you restore — you may end up with duplicates '
          'to tidy up.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue offline'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    ref.read(startupFlowProvider.notifier).startOfflineAnyway();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(startupFlowProvider);
    final needsSubscription = flow.needsSubscription;

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    needsSubscription
                        ? Icons.workspace_premium_rounded
                        : Icons.cloud_off_rounded,
                    size: 64,
                    color: AppColors.warning,
                  ),
                  AppSpacing.gapXl,
                  Text(
                    needsSubscription
                        ? 'Your data is waiting in the cloud'
                        : "We couldn't finish loading your account",
                    style: AppTypography.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapMd,
                  Text(
                    flow.reason ??
                        'Something went wrong while checking this account.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapSm,
                  Text(
                    'Nothing has been changed or deleted.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapXxl,
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _retrying ? null : _retry,
                      icon: _retrying
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(_retrying ? 'Checking…' : 'Try again'),
                    ),
                  ),
                  if (needsSubscription) ...[
                    AppSpacing.gapSm,
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _retrying
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const PremiumScreen(),
                                ),
                              ),
                        icon: const Icon(Icons.workspace_premium_rounded),
                        label: const Text('View subscription options'),
                      ),
                    ),
                  ],
                  AppSpacing.gapSm,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _retrying ? null : _startOffline,
                      child: Text(
                        needsSubscription
                            ? 'Use the app without restoring'
                            : 'Continue offline',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
