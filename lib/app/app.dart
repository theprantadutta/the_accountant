import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/session_timeout_provider.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/features/onboarding/onboarding_screen.dart';
import 'package:the_accountant/features/premium/screens/premium_screen.dart';
import 'package:the_accountant/features/support/screens/support_screen.dart';
import 'package:the_accountant/shared/widgets/main_navigation_container.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize session timeout service
    ref.listen(sessionTimeoutProvider, (_, _) {});

    // Watch theme changes
    final themeState = ref.watch(themeProvider);
    final currentTheme = AppTheme.getCurrentTheme(themeState.currentTheme);

    return MaterialApp(
      title: 'The Accountant',
      theme: currentTheme,
      darkTheme: currentTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const MainNavigationContainer(),
        '/premium': (context) => const PremiumScreen(),
        '/support': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String?;
          return SupportScreen(userId: args ?? 'default_user');
        },
      },
      debugShowCheckedModeBanner: false,
      navigatorObservers: [SessionTimeoutNavigatorObserver(ref)],
    );
  }
}

class SessionTimeoutNavigatorObserver extends NavigatorObserver {
  final WidgetRef ref;

  SessionTimeoutNavigatorObserver(this.ref);

  @override
  void didPush(Route route, Route? previousRoute) {
    ref.read(sessionTimeoutProvider.notifier).handleUserActivity();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    ref.read(sessionTimeoutProvider.notifier).handleUserActivity();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    ref.read(sessionTimeoutProvider.notifier).handleUserActivity();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    ref.read(sessionTimeoutProvider.notifier).handleUserActivity();
  }
}
