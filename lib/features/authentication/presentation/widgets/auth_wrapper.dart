import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/account_linking_screen.dart';
import 'package:the_accountant/features/onboarding/providers/onboarding_provider.dart';
import 'package:the_accountant/features/onboarding/screens/post_signup_onboarding_screen.dart';
import 'package:the_accountant/shared/widgets/main_navigation_container.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/services/subscription_expiry_checker.dart';
import 'package:the_accountant/features/budgets/providers/budget_notification_provider.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper>
    with WidgetsBindingObserver {
  bool _hasCheckedOnboarding = false;
  bool _hasRunStartupChecks = false;

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
      // When app returns to foreground, check if token needs refresh
      _checkAndRefreshTokenOnResume();
      // Trigger auto-sync on resume
      ref.read(syncNotifierProvider.notifier).triggerAutoSync();
    } else if (state == AppLifecycleState.paused) {
      // Stop periodic sync when app goes to background
      ref.read(syncNotifierProvider.notifier).stopPeriodicSync();
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
      // Check onboarding status once after authentication
      if (!_hasCheckedOnboarding) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(onboardingProvider.notifier).checkOnboardingStatus();
          setState(() => _hasCheckedOnboarding = true);
        });
        return const AuthLoadingScreen();
      }

      // Show onboarding loading
      if (onboardingState.isLoading) {
        return const AuthLoadingScreen();
      }

      // Show post-signup onboarding if needed
      if (onboardingState.needsOnboarding) {
        return const PostSignupOnboardingScreen();
      }

      // Run startup notification checks once
      if (!_hasRunStartupChecks) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _runStartupChecks();
          setState(() => _hasRunStartupChecks = true);
        });
      }

      // Show main app
      return const MainNavigationContainer();
    }

    // Reset checks when user logs out
    if (_hasCheckedOnboarding || _hasRunStartupChecks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _hasCheckedOnboarding = false;
          _hasRunStartupChecks = false;
        });
      });
    }

    // If not authenticated, show sign in screen
    return const SignInScreen();
  }
}

class AuthLoadingScreen extends StatefulWidget {
  const AuthLoadingScreen({super.key});

  @override
  State<AuthLoadingScreen> createState() => _AuthLoadingScreenState();
}

class _AuthLoadingScreenState extends State<AuthLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated App Logo
              AnimatedBuilder(
                animation: Listenable.merge([
                  _pulseAnimation,
                  _rotationAnimation,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: AppTheme.gradientContainer(
                        gradient: AppTheme.primaryGradient,
                        width: 120,
                        height: 120,
                        borderRadius: BorderRadius.circular(40),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // App Name
              const Text(
                'The Accountant',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Loading Text
              Text(
                'Initializing your financial journey...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Loading Indicator
              AppTheme.glassmorphicContainer(
                width: 200,
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Loading dots animation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final delay = index * 0.3;
                      final animationValue =
                          (_pulseController.value + delay) % 1.0;
                      final opacity = (animationValue < 0.5)
                          ? animationValue * 2
                          : (1.0 - animationValue) * 2;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: opacity),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
