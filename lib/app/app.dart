import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/responsive.dart';
import 'package:the_accountant/features/onboarding/screens/post_signup_onboarding_screen.dart';
import 'package:the_accountant/features/premium/providers/premium_sync_provider.dart';
import 'package:the_accountant/features/premium/screens/premium_screen.dart';
import 'package:the_accountant/features/support/screens/support_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/user_profile_screen.dart';
import 'package:the_accountant/features/categories/screens/category_management_screen.dart';
import 'package:the_accountant/features/settings/screens/exchange_rates_screen.dart';
import 'package:the_accountant/features/settings/screens/profile_edit_screen.dart';
import 'package:the_accountant/features/settings/screens/privacy_security_screen.dart';
import 'package:the_accountant/features/settings/screens/notifications_screen.dart';
import 'package:the_accountant/features/settings/screens/regional_settings_screen.dart';
import 'package:the_accountant/shared/widgets/main_navigation_container.dart';
import 'package:the_accountant/shared/widgets/app_background.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_wrapper.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // Stable key so the single ambient background keeps the same State (and its
  // running animation) across MyApp rebuilds — it never re-initialises.
  final GlobalKey _backgroundKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Check for Play Store updates after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForAppUpdate();
    });
  }

  /// Check Google Play for an available update and install it. Prefers the
  /// immediate update flow (blocking) and falls back to the flexible flow
  /// (background download + restart) when immediate is not allowed.
  ///
  /// Silently fails — update-check errors must not block the user. Throws a
  /// PlatformException on iOS, which the try/catch absorbs.
  Future<void> _checkForAppUpdate() async {
    if (!mounted) return;

    try {
      debugPrint('Checking for app update...');
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      debugPrint('Update availability: ${updateInfo.updateAvailability}');
      debugPrint(
        'Immediate update allowed: ${updateInfo.immediateUpdateAllowed}',
      );
      debugPrint(
        'Flexible update allowed: ${updateInfo.flexibleUpdateAllowed}',
      );

      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
        debugPrint('No update available.');
        return;
      }

      if (updateInfo.immediateUpdateAllowed) {
        debugPrint('Starting immediate update flow.');
        await InAppUpdate.performImmediateUpdate();
        debugPrint('Immediate update completed.');
      } else if (updateInfo.flexibleUpdateAllowed) {
        debugPrint('Immediate update not allowed, falling back to flexible.');
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
        debugPrint('Flexible update completed.');
      }
    } catch (e) {
      debugPrint('Error checking for app update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme changes
    final themeState = ref.watch(themeProvider);
    final currentTheme = AppTheme.getCurrentTheme(themeState.currentTheme);

    // Activate IAP → Premium state bridge (needs to be alive for app lifetime)
    ref.watch(premiumIapSyncProvider);

    return MaterialApp(
      title: 'The Accountant',
      theme: currentTheme,
      darkTheme: currentTheme,
      themeMode: ThemeMode.dark,
      navigatorObservers: [AnalyticsService().observer],
      // One ambient gradient background painted behind every screen. Scaffolds
      // are transparent (see AppTheme) so this shows through app-wide. On large
      // screens (iPad/desktop) content is centered within a readable max width
      // via [AdaptiveWidth] while the gradient stays full-bleed behind it.
      builder: (context, child) => AppBackground(
        key: _backgroundKey,
        child: AdaptiveWidth(child: child ?? const SizedBox.shrink()),
      ),
      home: const AuthWrapper(),
      routes: {
        '/post-signup-onboarding': (context) =>
            const PostSignupOnboardingScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/dashboard': (context) => const MainNavigationContainer(),
        '/categories': (context) => const CategoryManagementScreen(),
        '/exchange-rates': (context) => const ExchangeRatesScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/support': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String?;
          return SupportScreen(userId: args ?? 'default_user');
        },
        '/settings/profile': (context) => const ProfileEditScreen(),
        '/settings/privacy-security': (context) =>
            const PrivacySecurityScreen(),
        '/settings/notifications': (context) => const NotificationsScreen(),
        '/settings/regional': (context) => const RegionalSettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
