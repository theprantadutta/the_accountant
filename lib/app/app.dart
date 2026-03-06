import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/features/onboarding/screens/post_signup_onboarding_screen.dart';
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
import 'package:the_accountant/features/authentication/presentation/widgets/auth_wrapper.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme changes
    final themeState = ref.watch(themeProvider);
    final currentTheme = AppTheme.getCurrentTheme(themeState.currentTheme);

    return MaterialApp(
      title: 'The Accountant',
      theme: currentTheme,
      darkTheme: currentTheme,
      themeMode: ThemeMode.dark,
      navigatorObservers: [AnalyticsService().observer],
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
