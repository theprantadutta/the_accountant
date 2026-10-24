import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/providers/deep_link_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/providers/account_store_provider.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/domain/regional_preferences.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/features/onboarding/screens/post_signup_onboarding_screen.dart';
import 'package:the_accountant/features/premium/providers/premium_sync_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/premium/screens/premium_screen.dart';
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
      _startDeepLinks();
      // Account-scoped preparation is deliberately NOT started here. This runs
      // before authentication has resolved, so the active store is whatever was
      // persisted last — possibly an account whose session is about to be
      // rejected, or replaced by a different one. `AccountStoreCoordinator`
      // starts it from the auth state instead, once the owner is known.
    });
  }

  /// Route tapped notifications through the deep link service.
  ///
  /// It holds a tap until the app is signed in and on screen. The launcher
  /// shortcuts are registered from the shell instead: this widget sits above
  /// the MaterialApp, so `L10n.of(context)` is null here, and reading it to
  /// label them crashed the app on every launch.
  Future<void> _startDeepLinks() async {
    NotificationService().onOpen = ref.read(deepLinkServiceProvider).offer;
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
    // The palette has to be in place before anything below builds, because the
    // whole app reads its colours from AppColors rather than from the
    // ThemeData — see AppPalette for why. Assigning here, in the build that
    // also produces the ThemeData, is what keeps the two agreeing.
    //
    // MediaQuery rather than PlatformDispatcher so that a change to the phone's
    // own light/dark setting rebuilds this widget, and with it the tree.
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    AppColors.usePalette(themeState.paletteFor(platformBrightness));

    // Same bargain as the palette, for the same reason: these reach several
    // hundred formatting call sites that already thread two arguments, and
    // threading three more through all of them would be pure noise. One
    // writer, here, on the build that reads them.
    final settings = ref.watch(settingsProvider);
    RegionalPreferences.apply(
      symbol: settings.symbolPosition,
      time: settings.timeFormat,
      weekStart: settings.firstDayOfWeek,
    );

    // Light and dark are both built in the chosen accent; MaterialApp picks
    // one from themeMode and animates between them through SunriseColors.lerp.
    final lightTheme = AppTheme.themeFor(
      themeState.colorsFor(Brightness.light),
    );
    final darkTheme = AppTheme.themeFor(themeState.colorsFor(Brightness.dark));

    // Activate IAP → Premium state bridge (needs to be alive for app lifetime)
    ref.watch(premiumIapSyncProvider);

    // Keeps the open local database bound to the authenticated account. Must be
    // alive for the app's lifetime: it is what swaps the store (and rebuilds
    // every data provider) the moment the signed-in identity changes, so one
    // account can never see or upload another account's local records.
    ref.watch(accountStoreCoordinatorProvider);

    return MaterialApp(
      title: 'The Accountant',
      locale: ref.watch(localeProvider),
      supportedLocales: L10n.supportedLocales,
      localeListResolutionCallback: AppLanguages.resolve,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // material_ui declares its OWN MaterialLocalizations — a different Dart
        // type from the one in package:flutter/material.dart — and
        // flutter_localizations cannot satisfy it. This app is still written
        // against package:flutter/material.dart, but shimmer 4 pulls material_ui
        // in transitively, so anything of its that asks for localizations throws
        // at runtime without these. Both sets coexist; material_ui ships the
        // same 80 locales, so this costs no coverage.
        ...material_ui.GlobalMaterialLocalizations.delegates,
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeState.themeMode,
      themeAnimationDuration: SunriseMotion.theme,
      themeAnimationCurve: Curves.easeOut,
      navigatorObservers: [AnalyticsService().observer],
      // The short Sunrise wash behind every route. Scaffolds are transparent,
      // so screens that have not painted their own wash still sit on Sunrise;
      // tab roots paint the tall wash over it.
      //
      // The status bar follows the app's theme, not the phone's. Only AppBar
      // screens declared a style, so on the Sunrise screens the bar kept
      // whatever came last — the splash's white icons — and some phones
      // (ColorOS in system dark mode among them) left those white icons on
      // a light app. Declared here once, for every route; a screen with its
      // own look (the splash, the add form's hero) still overrides it.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            Theme.of(context).appBarTheme.systemOverlayStyle ??
            SystemUiOverlayStyle.dark,
        child: AppBackground(
          key: _backgroundKey,
          child: child ?? const SizedBox.shrink(),
        ),
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
