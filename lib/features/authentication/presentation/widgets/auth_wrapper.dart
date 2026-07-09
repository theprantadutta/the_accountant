import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/account_linking_screen.dart';
import 'package:the_accountant/features/onboarding/providers/onboarding_provider.dart';
import 'package:the_accountant/features/onboarding/screens/post_signup_onboarding_screen.dart';
import 'package:the_accountant/shared/widgets/main_navigation_container.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_background.dart';
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

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper>
    with WidgetsBindingObserver {
  bool _hasCheckedOnboarding = false;
  bool _hasRunStartupChecks = false;
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

      // Show lock screen if biometric lock triggered
      if (_isLocked) {
        return LockScreen(onUnlocked: () => setState(() => _isLocked = false));
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

class AuthLoadingScreen extends StatefulWidget {
  const AuthLoadingScreen({super.key});

  @override
  State<AuthLoadingScreen> createState() => _AuthLoadingScreenState();
}

class _AuthLoadingScreenState extends State<AuthLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    duration: const Duration(milliseconds: 1600),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _pulseAnimation = Tween<double>(
    begin: 0.94,
    end: 1.06,
  ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing, glowing app logo
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGlow.withValues(alpha: 0.5),
                        blurRadius: 36,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 48,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              AppSpacing.gapXxl,

              Text('The Accountant', style: AppTypography.displaySmall),

              AppSpacing.gapSm,

              Text(
                'Initializing your financial journey...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              AppSpacing.gapXxxl,

              // Loading Indicator
              SizedBox(
                width: 180,
                child: ClipRRect(
                  borderRadius: AppSpacing.borderRadiusFull,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: AppColors.glassWhite,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
