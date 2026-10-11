import 'package:flutter/services.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/account_linking_screen.dart';
import 'package:the_accountant/features/onboarding/providers/onboarding_provider.dart';
import 'package:the_accountant/features/onboarding/screens/post_signup_onboarding_screen.dart';
import 'package:the_accountant/shared/widgets/main_navigation_container.dart';
import 'package:the_accountant/core/services/subscription_expiry_checker.dart';
import 'package:the_accountant/features/budgets/providers/budget_notification_provider.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/providers/intro_legal_provider.dart';
import 'package:the_accountant/features/onboarding/onboarding_screen.dart';
import 'package:the_accountant/features/legal/legal_acceptance_screen.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/screens/lock_screen.dart';
import 'package:the_accountant/core/providers/account_store_provider.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/features/startup/screens/startup_recovery_screen.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper>
    with WidgetsBindingObserver {
  bool _hasCheckedOnboarding = false;
  bool _hasRunStartupChecks = false;
  bool _hasStartedFlow = false;
  bool _isLocked = false;
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Sync premium status when auth state has premium info
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPremiumStatus();
    });
  }

  /// Sync premium status from auth state to premium provider
  void _syncPremiumStatus() {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.subscriptionTier != 'free') {
      final tier = SubscriptionTier.fromString(authState.subscriptionTier);
      ref.read(premiumProvider.notifier).updateSubscription(tier: tier);
      debugPrint(
        'AuthWrapper: Synced premium status - tier: ${tier.displayName}',
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Check biometric lock on resume
      _checkBiometricLockOnResume();
      // When app returns to foreground, check if token needs refresh
      _checkAndRefreshTokenOnResume();
      // Trigger auto-sync on resume
      ref.read(syncNotifierProvider.notifier).triggerAutoSync();
    } else if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
      // Stop periodic sync when app goes to background
      ref.read(syncNotifierProvider.notifier).stopPeriodicSync();
    }
  }

  /// Check if the app should be locked based on biometric settings and timeout
  void _checkBiometricLockOnResume() {
    final settings = ref.read(settingsProvider);
    if (!settings.biometricLockEnabled) return;

    final timeout = settings.autoLockTimeoutMinutes;

    // -1 means "Never"
    if (timeout == -1) return;

    // 0 means "Immediately" — always lock
    if (timeout == 0) {
      setState(() => _isLocked = true);
      return;
    }

    // Check if enough time has elapsed
    if (_pausedAt != null) {
      final elapsed = DateTime.now().difference(_pausedAt!).inMinutes;
      if (elapsed >= timeout) {
        setState(() => _isLocked = true);
      }
    }
  }

  /// Check and refresh token when app resumes from background
  Future<void> _checkAndRefreshTokenOnResume() async {
    debugPrint('AuthWrapper: App resumed - checking token status');

    // Only check if user is authenticated
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) return;

    // Check if token is expiring soon
    final isExpiringSoon = await SecureTokenStorage.isTokenExpiringSoon();
    if (isExpiringSoon) {
      debugPrint(
        'AuthWrapper: Token expiring soon on resume - triggering refresh check',
      );
      // The API service will handle the actual refresh on the next request
      // But we can also proactively trigger a lightweight request to force refresh
      try {
        // Try to get current user - this will trigger token refresh if needed
        await ApiService().getCurrentUser();
        debugPrint('AuthWrapper: Token refresh check completed successfully');
      } catch (e) {
        debugPrint('AuthWrapper: Token refresh check failed: $e');
        // Don't logout here - the API service error handler will handle it
      }
    }
  }

  /// Run startup notification checks (subscription expiry, budget alerts, auto-sync)
  Future<void> _runStartupChecks() async {
    debugPrint('AuthWrapper: Running startup notification checks');

    // Check subscription expiry
    final subscriptionChecker = SubscriptionExpiryChecker();
    await subscriptionChecker.checkOnAppOpen(ref);

    // Trigger budget notification check
    ref.read(budgetNotificationProvider.notifier).checkBudgetsNow();

    // Trigger auto-sync and start periodic sync
    ref.read(syncNotifierProvider.notifier).triggerAutoSync();
    ref.read(syncNotifierProvider.notifier).startPeriodicSync();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final onboardingState = ref.watch(onboardingProvider);

    // Listen for auth state changes to sync premium status
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Sync premium when subscription tier changes
      if (next.isAuthenticated &&
          next.subscriptionTier != previous?.subscriptionTier) {
        _syncPremiumStatus();
      }
      // Lock premium features and stop sync on logout
      if (previous?.isAuthenticated == true && !next.isAuthenticated) {
        ref.read(premiumProvider.notifier).lockPremiumFeatures();
        ref.read(syncNotifierProvider.notifier).stopPeriodicSync();
        debugPrint(
          'AuthWrapper: User logged out - locked premium features, stopped sync',
        );
      }
    });

    final gate = _gate(authState, onboardingState);

    // The intro hands over with a short crossfade and a slight settle, so the
    // splash glow melts into the first real screen instead of cutting to it.
    // Keyed by screen type: consecutive loading states keep one intro alive.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 1.02, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(key: ValueKey(gate.runtimeType), child: gate),
    );
  }

  /// Which screen the app should be on right now.
  Widget _gate(AuthState authState, OnboardingState onboardingState) {
    // Show loading screen while authentication is initializing
    if (authState.isLoading) {
      return const AuthLoadingScreen();
    }

    // Handle account linking flow
    if (authState.requiresLinking) {
      return const AccountLinkingScreen();
    }

    // If user is authenticated
    if (authState.isAuthenticated) {
      // NOTHING account-scoped may run until the open local store belongs to
      // this account. `AccountStoreCoordinator` switches files asynchronously
      // after sign-in, so acting before it settles would read — and write —
      // whichever store happened to be open, in the worst case the previous
      // account's.
      final storeOwner = ref.watch(activeStoreOwnerProvider);
      if (storeOwner != authState.userId) {
        return const AuthLoadingScreen();
      }

      // The startup flow decides whether this account has data to restore. It
      // is the authority on that question; `onboarding_completed` is not, and
      // never was — it defaults to false and was never backfilled, so an
      // account with years of cloud history reports the same value a brand-new
      // one does.
      final flow = ref.watch(startupFlowProvider);
      if (!_hasStartedFlow) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(startupFlowProvider.notifier).evaluate();
          ref.read(onboardingProvider.notifier).checkOnboardingStatus();
          setState(() {
            _hasStartedFlow = true;
            _hasCheckedOnboarding = true;
          });
        });
        return const AuthLoadingScreen();
      }

      // Anything that cannot proceed without the user gets a screen they can
      // act on — a failed lookup, an unconfirmed subscription, a lapsed one.
      // None of these is ever silently treated as "new user", and none of them
      // may render as a loading screen: that is how a returning user ended up
      // watching a spinner that would never resolve.
      if (flow.needsUserAttention && !flow.startedOfflineByChoice) {
        return const StartupRecoveryScreen();
      }

      // Still working out what this account holds.
      if (!flow.isSettled && !flow.startedOfflineByChoice) {
        return const AuthLoadingScreen();
      }

      // Show onboarding loading
      if (onboardingState.isLoading) {
        return const AuthLoadingScreen();
      }

      // Post-signup onboarding creates a wallet, so it is gated on the account
      // being confirmed empty — not merely on a flag that says the user has not
      // seen this screen before.
      if (onboardingState.needsOnboarding && flow.mayOfferFirstWallet) {
        return const PostSignupOnboardingScreen();
      }

      // Run startup notification checks once
      if (!_hasRunStartupChecks) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _runStartupChecks();
          setState(() => _hasRunStartupChecks = true);
        });
      }

      // Show lock screen if biometric lock triggered
      if (_isLocked) {
        return LockScreen(onUnlocked: () => setState(() => _isLocked = false));
      }

      // Show main app
      return const MainNavigationContainer();
    }

    // Reset checks when user logs out
    if (_hasCheckedOnboarding || _hasRunStartupChecks || _hasStartedFlow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _hasCheckedOnboarding = false;
          _hasRunStartupChecks = false;
          _hasStartedFlow = false;
        });
      });
    }

    // If not authenticated, check intro/legal flow
    final introLegalState = ref.watch(introLegalProvider);

    if (!introLegalState.hasSeenIntro) {
      return OnboardingScreen(
        onComplete: () {
          ref.read(introLegalProvider.notifier).markIntroSeen();
        },
      );
    }

    if (!introLegalState.hasAcceptedLegal) {
      return LegalAcceptanceScreen(
        onAccepted: () {
          ref.read(introLegalProvider.notifier).markLegalAccepted();
        },
      );
    }

    return const SignInScreen();
  }
}

/// The Sunrise intro, shown while sign-in and the account store settle.
///
/// Light is splash concept A (white glyph on the sunrise gradient with a soft
/// white glow); dark is concept C (the gradient glyph glowing on ember). It
/// continues the native splash: the glyph rises 24dp and fades in (0-400ms)
/// while its glow grows from 0.6 to 1, then the wordmark fades and slides up
/// 8dp (250-600ms). It never waits on itself: the moment the app is ready the
/// wrapper crossfades away from it.
class AuthLoadingScreen extends StatefulWidget {
  const AuthLoadingScreen({super.key});

  @override
  State<AuthLoadingScreen> createState() => _AuthLoadingScreenState();
}

class _AuthLoadingScreenState extends State<AuthLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..forward();

  late final Animation<double> _glyph = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, 400 / 700, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _word = CurvedAnimation(
    parent: _intro,
    curve: const Interval(250 / 700, 600 / 700, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    final dark = c.isDark;

    final background = dark
        ? BoxDecoration(
            color: c.base,
            gradient: RadialGradient(
              center: const Alignment(0, .9),
              radius: .9,
              colors: [
                c.gradientEnd.withValues(alpha: .22),
                c.base.withValues(alpha: 0),
              ],
            ),
          )
        : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c.headerStart, c.gradientMid, c.gradientEnd],
              stops: const [0, .5, 1],
            ),
          );
    final glowColor = dark ? c.gradientMid : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: dark ? c.base : c.gradientMid,
        body: DecoratedBox(
          decoration: background,
          child: Center(
            child: AnimatedBuilder(
              animation: _intro,
              builder: (context, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 260,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: .6 + .4 * _glyph.value,
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  glowColor.withValues(alpha: dark ? .45 : .35),
                                  glowColor.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _glyph.value,
                          child: Transform.translate(
                            offset: Offset(0, 24 * (1 - _glyph.value)),
                            child: Image.asset(
                              dark
                                  ? 'assets/logo/glyph-gradient-256.png'
                                  : 'assets/logo/glyph-white-256.png',
                              width: 104,
                              height: 104,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: _word.value,
                    child: Transform.translate(
                      offset: Offset(0, 8 * (1 - _word.value)),
                      child: Column(
                        children: [
                          Text(
                            l10n.settingsTheAccountant,
                            style: SunriseType.heroTitle.copyWith(
                              color: dark ? c.ink : c.onFill,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.splashTagline,
                            style: SunriseType.body.copyWith(
                              color: dark
                                  ? c.subtle
                                  : c.onFill.withValues(alpha: .85),
                              fontSize: 16,
                            ),
                          ),
                        ],
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
