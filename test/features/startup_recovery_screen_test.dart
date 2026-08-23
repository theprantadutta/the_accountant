import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/features/startup/screens/startup_recovery_screen.dart';
import 'package:the_accountant/features/wallets/screens/create_first_wallet_screen.dart';

/// A controller pinned to one state.
class _PinnedFlow extends StartupFlowController {
  _PinnedFlow(this._state);

  final StartupFlowState _state;

  @override
  StartupFlowState build() => _state;
}

/// What the user is actually shown when startup cannot proceed.
///
/// The screen these replace was "Create your first wallet", reached by a
/// three-second timeout — so the assertion that matters most in every case here
/// is the negative one: that screen must not be anywhere near these states.
void main() {
  Future<void> pumpAt(WidgetTester tester, StartupFlowState state) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupFlowProvider.overrideWith(() => _PinnedFlow(state)),
        ],
        child: const MaterialApp(home: StartupRecoveryScreen()),
      ),
    );
    await tester.pump();
  }

  testWidgets('an unavailable account offers retry and never a first wallet', (
    tester,
  ) async {
    await pumpAt(
      tester,
      const StartupFlowState(
        phase: StartupPhase.unavailable,
        reason: 'We could not check whether this account has data to restore.',
      ),
    );

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Continue offline'), findsOneWidget);
    expect(find.textContaining('could not check'), findsOneWidget);
    expect(find.text('Nothing has been changed or deleted.'), findsOneWidget);

    // The prohibited screen.
    expect(find.byType(CreateFirstWalletScreen), findsNothing);
    // And no upgrade prompt: nothing has been confirmed about the subscription.
    expect(find.text('View subscription options'), findsNothing);
  });

  testWidgets('a lapsed subscription is explained and actionable', (
    tester,
  ) async {
    await pumpAt(
      tester,
      const StartupFlowState(
        phase: StartupPhase.entitlementRequired,
        reason: 'Restoring it needs an active subscription.',
      ),
    );

    expect(find.text('Your data is waiting in the cloud'), findsOneWidget);
    expect(find.text('View subscription options'), findsOneWidget);
    expect(
      find.text('Try again'),
      findsOneWidget,
      reason: 'a stale entitlement can resolve itself; retry must stay',
    );
    expect(find.text('Use the app without restoring'), findsOneWidget);
    expect(find.byType(CreateFirstWalletScreen), findsNothing);
  });

  testWidgets('an unconfirmed subscription does not prompt to upgrade', (
    tester,
  ) async {
    await pumpAt(
      tester,
      const StartupFlowState(
        phase: StartupPhase.checkingEntitlement,
        reason: 'We are still confirming your subscription.',
      ),
    );

    expect(find.text('Try again'), findsOneWidget);
    expect(
      find.text('View subscription options'),
      findsNothing,
      reason: 'nothing is confirmed yet, so nothing should be sold',
    );
    expect(find.byType(CreateFirstWalletScreen), findsNothing);
  });

  testWidgets('continuing offline is confirmed, never automatic', (
    tester,
  ) async {
    await pumpAt(
      tester,
      const StartupFlowState(phase: StartupPhase.unavailable),
    );

    await tester.tap(find.text('Continue offline'));
    // Not pumpAndSettle: the animated background never stops, so settling would
    // wait forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // A dialog, not an immediate switch: the consequence has to be stated.
    expect(find.text('Continue without checking?'), findsOneWidget);
    expect(find.textContaining('nothing on this device'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
