import 'dart:math' as math;
import 'package:flutter_native_splash/flutter_native_splash.dart';
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

/// White on the intro's sunrise ground, which is the same in both themes.
const _onBrand = Color(0xFFFFFFFF);

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
      // The first real frame has drawn (usually the intro, which matches the
      // native splash pixel for pixel), so the native splash can go.
      FlutterNativeSplash.remove();
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
/// The first frame is the native splash, pixel for pixel: flat sunrise orange
/// with the glyph at the centre (Android 12 cannot draw more than that), so
/// the hand-off is invisible. Then it comes alive: the gradient and a slow
/// turning sunburst fade in behind the glyph, four little money icons orbit
/// it, coins drift up the screen, the wordmark rises, a playful status line
/// steps along a progress bar, and a money tip slides in. It never holds the
/// app: the wrapper crossfades away the moment the real screen is ready.
class AuthLoadingScreen extends StatefulWidget {
  const AuthLoadingScreen({super.key});

  @override
  State<AuthLoadingScreen> createState() => _AuthLoadingScreenState();
}

class _AuthLoadingScreenState extends State<AuthLoadingScreen>
    with TickerProviderStateMixin {
  /// The one-off entrance (0.9s).
  late final AnimationController _intro = AnimationController(
    duration: const Duration(milliseconds: 900),
    vsync: this,
  )..forward();

  /// The ambient loop: rays, orbit, coins, status steps.
  late final AnimationController _loop = AnimationController(
    duration: const Duration(seconds: 8),
    vsync: this,
  )..repeat();

  late final Animation<double> _bg = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, .45, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _orbitIn = CurvedAnimation(
    parent: _intro,
    curve: const Interval(.2, .7, curve: Curves.easeOutBack),
  );
  late final Animation<double> _word = CurvedAnimation(
    parent: _intro,
    curve: const Interval(.3, .7, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _tip = CurvedAnimation(
    parent: _intro,
    curve: const Interval(.55, 1, curve: Curves.easeOutCubic),
  );

  /// One tip per launch.
  late final int _tipIndex = DateTime.now().millisecondsSinceEpoch % 8;

  /// Coins: horizontal position, size and phase, fixed per launch.
  late final List<(double, double, double)> _coins = () {
    final r = math.Random(DateTime.now().day);
    return [
      for (var i = 0; i < 9; i++)
        (r.nextDouble(), 14 + r.nextDouble() * 14, r.nextDouble()),
    ];
  }();

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  String _tipText(L10n l10n) => switch (_tipIndex) {
    0 => l10n.introTip1,
    1 => l10n.introTip2,
    2 => l10n.introTip3,
    3 => l10n.introTip4,
    4 => l10n.introTip5,
    5 => l10n.introTip6,
    6 => l10n.introTip7,
    _ => l10n.introTip8,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final steps = [
      l10n.introStep1,
      l10n.introStep2,
      l10n.introStep3,
      l10n.introStep4,
    ];
    const white = _onBrand;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFF97316),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF97316),
        body: AnimatedBuilder(
          animation: Listenable.merge([_intro, _loop]),
          builder: (context, _) {
            final t = reduceMotion ? 0.0 : _loop.value;
            // Steps advance every 1.4s and stay on the last one.
            final elapsed = (_loop.lastElapsedDuration?.inMilliseconds ?? 0);
            final step = math.min(elapsed ~/ 1400, steps.length - 1);
            final progress = math.min(
              1.0,
              .12 + elapsed / (1400.0 * steps.length),
            );

            return SizedBox.expand(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Android 12+ can only draw a flat ground on its splash,
                  // so the gradient fades in rather than being there at once.
                  Positioned.fill(
                    child: Opacity(
                      opacity: _bg.value,
                      child: Image.asset(
                        'assets/launcher/splash-background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Coins drifting up the screen.
                  for (final (x, size, phase) in _coins)
                    Positioned.fill(
                      child: Opacity(
                        opacity: _bg.value * .55,
                        child: _Coin(
                          x: x,
                          size: size,
                          progress: (t * 1.6 + phase) % 1,
                        ),
                      ),
                    ),

                  // A slowly turning sunburst behind the glyph.
                  Opacity(
                    opacity: _bg.value,
                    child: Transform.rotate(
                      angle: t * 2 * math.pi / 3,
                      child: CustomPaint(
                        size: const Size(420, 420),
                        painter: _RaysPainter(),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: .6 + .4 * _bg.value,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            white.withValues(alpha: .38 * _bg.value),
                            white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Four money icons orbiting the glyph.
                  for (var i = 0; i < 4; i++)
                    _orbiter(
                      i,
                      t,
                      [
                        Symbols.paid_rounded,
                        Symbols.trending_up_rounded,
                        Symbols.savings_rounded,
                        Symbols.auto_awesome_rounded,
                      ][i],
                    ),

                  // Same file, same box, same place as the native splash.
                  Image.asset(
                    'assets/launcher/splash-glyph.png',
                    width: 256,
                    height: 256,
                  ),

                  Transform.translate(
                    offset: Offset(0, 150 + 10 * (1 - _word.value)),
                    child: Opacity(
                      opacity: _word.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.settingsTheAccountant,
                            style: SunriseType.heroTitle.copyWith(
                              color: white,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.splashTagline,
                            style: SunriseType.body.copyWith(
                              color: white.withValues(alpha: .88),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            height: 20,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              reverseDuration: const Duration(milliseconds: 90),
                              transitionBuilder: (child, a) => FadeTransition(
                                opacity: a,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0, .4),
                                    end: Offset.zero,
                                  ).animate(a),
                                  child: child,
                                ),
                              ),
                              child: Text(
                                steps[step],
                                key: ValueKey(step),
                                style: SunriseType.label.copyWith(
                                  color: white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: SizedBox(
                              width: 160,
                              height: 5,
                              child: Stack(
                                children: [
                                  Container(
                                    color: white.withValues(alpha: .25),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: progress,
                                    child: Container(color: white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // The money tip.
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: MediaQuery.paddingOf(context).bottom + 28,
                    child: Opacity(
                      opacity: _tip.value,
                      child: Transform.translate(
                        offset: Offset(0, 24 * (1 - _tip.value)),
                        child: _TipCard(
                          label: l10n.introTipLabel,
                          text: _tipText(l10n),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _orbiter(int i, double t, IconData icon) {
    final angle = 2 * math.pi * (t + i / 4);
    final radius = 112 + 6 * math.sin(2 * math.pi * (t * 2 + i / 4));
    final dx = math.cos(angle) * radius;
    final dy = math.sin(angle) * radius * .72;
    final pop = _orbitIn.value;
    return Transform.translate(
      offset: Offset(dx * pop, dy * pop),
      child: Opacity(
        opacity: pop.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: pop,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _onBrand.withValues(alpha: .22),
              shape: BoxShape.circle,
              border: Border.all(color: _onBrand.withValues(alpha: .45)),
            ),
            child: Icon(icon, color: _onBrand, size: 21, fill: 1),
          ),
        ),
      ),
    );
  }
}

/// A coin rising from the bottom of the screen and fading out near the top.
class _Coin extends StatelessWidget {
  const _Coin({required this.x, required this.size, required this.progress});

  final double x;
  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final y = box.maxHeight * (1.05 - progress * 1.15);
        final sway = math.sin(progress * math.pi * 4) * 10;
        final fade = progress < .15
            ? progress / .15
            : progress > .8
            ? (1 - progress) / .2
            : 1.0;
        return Stack(
          children: [
            Positioned(
              left: x * (box.maxWidth - size) + sway,
              top: y,
              child: Opacity(
                opacity: fade.clamp(0.0, 1.0),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFDE68A),
                    border: Border.all(
                      color: _onBrand.withValues(alpha: .7),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: size * .38,
                    height: size * .38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF59E0B).withValues(alpha: .8),
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

/// Soft sun rays.
class _RaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          _onBrand.withValues(alpha: .22),
          _onBrand.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    const rays = 14;
    for (var i = 0; i < rays; i++) {
      final a = 2 * math.pi * i / rays;
      final path = Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(c.dx + r * math.cos(a - .09), c.dy + r * math.sin(a - .09))
        ..lineTo(c.dx + r * math.cos(a + .09), c.dy + r * math.sin(a + .09))
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_RaysPainter oldDelegate) => false;
}

/// A frosted card holding the launch's money tip.
class _TipCard extends StatelessWidget {
  const _TipCard({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SunriseGlass(
      color: _onBrand.withValues(alpha: .18),
      radius: BorderRadius.circular(SunriseRadius.card),
      blur: 16,
      border: Border.all(color: _onBrand.withValues(alpha: .35)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _onBrand.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Symbols.lightbulb_rounded,
                color: _onBrand,
                fill: 1,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: SunriseType.overline.copyWith(
                      color: _onBrand.withValues(alpha: .85),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    text,
                    style: SunriseType.label.copyWith(
                      color: _onBrand,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
