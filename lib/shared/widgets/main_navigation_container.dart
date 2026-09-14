import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/ai/screens/receipt_scanner_screen.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/core/providers/deep_link_provider.dart';
import 'package:the_accountant/core/services/deep_link_service.dart';
import 'package:the_accountant/core/domain/app_destination.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/sync_status_banner.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/features/dashboard/widgets/responsive_financial_overview.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/ai_assistant/screens/ai_assistant_screen.dart'
    show AIAssistantScreenGated;
import 'package:the_accountant/features/settings/screens/settings_screen.dart';
import 'package:the_accountant/features/reports/screens/reports_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/create_first_wallet_screen.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/features/startup/screens/startup_recovery_screen.dart';
import 'package:the_accountant/features/notifications/providers/notification_history_provider.dart';
import 'package:the_accountant/features/notifications/screens/notification_inbox_screen.dart';
import 'package:the_accountant/core/providers/walkthrough_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/utils/responsive.dart';
import 'package:the_accountant/features/notifications/widgets/notification_permission_primer.dart';
import 'package:the_accountant/features/walkthrough/walkthrough_service.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_background.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_brand_header.dart';

class MainNavigationContainer extends ConsumerStatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  ConsumerState<MainNavigationContainer> createState() =>
      _MainNavigationContainerState();
}

class _MainNavigationContainerState
    extends ConsumerState<MainNavigationContainer> {
  int _currentIndex = 0;
  bool _isFabVisible = true;

  // Reinstall/restore gate: when the local DB is empty we first try to pull the
  // user's existing data from the server before assuming they're a brand-new
  // user and showing the "create your first wallet" screen.

  // Walkthrough keys
  final GlobalKey _balanceKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _navHomeKey = GlobalKey();
  final GlobalKey _navActivityKey = GlobalKey();
  final GlobalKey _navAIKey = GlobalKey();

  // Define the screens for each navigation item.
  //
  // `late` so the home screen can be handed the walkthrough key: a plain field
  // initialiser cannot reach another instance field.
  late final List<Widget> _screens = [
    ResponsiveFinancialOverview(balanceKey: _balanceKey), // Home
    const TransactionListScreen(), // Transactions
    const AIAssistantScreenGated(), // AI Assistant (Premium)
    const ReportsScreen(), // Reports
    const SettingsScreen(), // Settings
  ];

  /// Stable English names, for analytics.
  ///
  /// These are event identifiers, not labels: translating them would split one
  /// screen's history across as many names as the app has languages.
  final List<String> _screenTitles = [
    'Dashboard',
    'Transactions',
    'AI Assistant',
    'Reports',
    'Settings',
  ];

  /// What the app bar actually shows.
  List<String> _localizedTitles(L10n l10n) => [
    l10n.navDashboard,
    l10n.navTransactions,
    l10n.navAiAssistant,
    l10n.navReports,
    l10n.navSettings,
  ];

  /// The tab each destination lives on, for the ones that are tabs.
  static const Map<AppDestination, int> _tabFor = {
    AppDestination.dashboard: 0,
    AppDestination.transactions: 1,
    AppDestination.reports: 3,
    AppDestination.settings: 4,
  };

  /// Act on a link that has been waiting for somewhere safe to go.
  ///
  /// This runs only from the main shell, which the auth wrapper reaches only
  /// once the account is signed in, its store is bound and the startup flow has
  /// settled. That is the enforcement of the rule that a link may name a place
  /// but never get past the sign-in wall to it.
  void _followPendingLink() {
    final service = ref.read(deepLinkServiceProvider);
    final link = service.take();
    if (link == null || !mounted) return;

    final tab = _tabFor[link.destination];
    if (tab != null) {
      setState(() => _currentIndex = tab);
      return;
    }

    final screen = switch (link.destination) {
      AppDestination.addExpense => const AddTransactionScreen(),
      AppDestination.addIncome => const AddTransactionScreen(
        initialType: TransactionTypeSelection.income,
      ),
      AppDestination.addTransfer => const AddTransactionScreen(
        initialType: TransactionTypeSelection.transfer,
      ),
      AppDestination.budgets => const BudgetListScreen(),
      // Gated by the screen itself, so a link cannot buy anybody premium.
      AppDestination.scanReceipt => const ReceiptScannerScreenGated(),
      AppDestination.transactionDetail =>
        link.entityId == null
            ? null
            : TransactionDetailScreen(transactionId: link.entityId!),
      _ => null,
    };
    if (screen == null) return;

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pull existing server data before deciding this is a brand-new user.

      // Load unread notification count
      ref.read(notificationHistoryProvider.notifier).loadUnreadCount();

      // Trigger walkthrough for new users.
      //
      // No arbitrary delay: the service waits for the widgets it points at to
      // exist. Guessing at half a second meant racing the dashboard's first
      // layout, and losing that race threw the walkthrough away for good.
      final walkthroughState = ref.read(walkthroughProvider);
      if (!walkthroughState.hasSeenWalkthrough && mounted) {
        WalkthroughService.showDashboardWalkthrough(context, ref, {
          'balance': _balanceKey,
          'fab': _fabKey,
          'notification': _notificationKey,
          'navHome': _navHomeKey,
          'navActivity': _navActivityKey,
          'navAI': _navAIKey,
        });
      }

      // Ask about notifications with an in-app priming prompt (never the bare
      // iOS dialog on launch).
      _maybeShowNotificationPrimer();

      // A link that arrived before there was anywhere safe to send it — a cold
      // start from a launcher shortcut is exactly that — has been waiting.
      final links = ref.read(deepLinkServiceProvider);
      _deepLinks = links;
      links.pending.addListener(_followPendingLink);
      _followPendingLink();

      // Registered from here rather than from the app widget, which sits above
      // the MaterialApp and so cannot read the localisations these labels need.
      final l10n = L10n.of(context);
      links.registerShortcuts([
        ShortcutItem(
          type: DeepLinkParser.shortcutAddExpense,
          localizedTitle: l10n.shortcutAddExpense,
          icon: 'ic_shortcut_expense',
        ),
        ShortcutItem(
          type: DeepLinkParser.shortcutAddIncome,
          localizedTitle: l10n.shortcutAddIncome,
          icon: 'ic_shortcut_income',
        ),
        ShortcutItem(
          type: DeepLinkParser.shortcutScanReceipt,
          localizedTitle: l10n.shortcutScanReceipt,
          icon: 'ic_shortcut_scan',
        ),
        ShortcutItem(
          type: DeepLinkParser.shortcutTransactions,
          localizedTitle: l10n.shortcutTransactions,
          icon: 'ic_shortcut_list',
        ),
      ]);
    });
  }

  /// The service this widget's pending-link listener is attached to.
  ///
  /// Held rather than looked up again in [dispose], where `ref` cannot be used:
  /// Riverpod throws a plain `StateError` there, in release as well as debug,
  /// so tearing this shell down — signing out is the ordinary way — crashed the
  /// app outright rather than merely warning.
  ///
  /// Keeping the instance is also the only way to be sure the listener comes
  /// off the same object it went on. Re-reading the provider could hand back a
  /// different one, and the old listener would simply stay attached.
  DeepLinkService? _deepLinks;

  @override
  void dispose() {
    _deepLinks?.pending.removeListener(_followPendingLink);
    super.dispose();
  }

  /// Shows the notification priming prompt on the home screen — once, and only
  /// after the first-run walkthrough is done so the two don't overlap. Tapping
  /// "Enable" there is what triggers the real OS permission dialog.
  Future<void> _maybeShowNotificationPrimer() async {
    const primerShownKey = 'notification_primer_shown';
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs.getBool(primerShownKey) ?? false) return;

    // Don't compete with the first-run walkthrough; the primer shows next visit.
    if (!ref.read(walkthroughProvider).hasSeenWalkthrough) return;

    // Already authorized (e.g. a returning user) → nothing to ask.
    if (await NotificationService().hasPermission()) {
      await prefs.setBool(primerShownKey, true);
      return;
    }

    // Let the dashboard settle before prompting.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    await showNotificationPermissionPrimer(context);
    await prefs.setBool(primerShownKey, true);
  }

  /// When the local database is empty, attempt a one-time "restore" sync so a
  /// user who reinstalled the app (or logged in on a new device) pulls their
  /// existing data down from the server before we'd ever show the
  /// create-first-wallet screen. For genuinely new / free / offline users this
  /// resolves quickly and falls through to that screen.
  // The startup flow is driven by `AuthWrapper`, which is the widget that
  // decides whether this container is on screen at all. Driving it from here as
  // well was a loop: this container's `initState` started an evaluation, the
  // evaluation's first transient phase made `AuthWrapper` swap the container
  // out for the splash screen, and remounting it started the next evaluation.
  // Roughly three a second, both on the device and against the API.

  Widget _buildRestoringScreen() {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.paddingScreen,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthBrandHeader(
                  icon: Icons.cloud_download_rounded,
                  title: L10n.of(context).sharedWelcomeBack,
                  subtitle: L10n.of(context).sharedRestoringYourDataFromThe,
                ),
                AppSpacing.gapXxxl,
                SizedBox(
                  width: 200,
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
      ),
    );
  }

  void _onNavigationTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      // Update FAB visibility based on screen
      _updateFabVisibility(index);

      AnalyticsService().logScreenView(screenName: _screenTitles[index]);
      HapticFeedback.lightImpact();
    }
  }

  void _updateFabVisibility(int index) {
    bool shouldShowFab =
        index == 0 || index == 1; // Show FAB on Home and Transactions

    if (shouldShowFab != _isFabVisible) {
      setState(() {
        _isFabVisible = shouldShowFab;
      });
    }
  }

  void _showAddTransactionModal() {
    HapticFeedback.mediumImpact();
    // Use the new full-screen Cashew-style transaction creation
    showAddTransactionScreen(context);
  }

  // Legacy method for backward compatibility - kept for reference
  // ignore: unused_element
  void _showAddTransactionModalLegacy() {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXxl),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.glassBorder,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.gapLg,
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: AppSpacing.borderRadiusLg,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.textPrimary,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        AppSpacing.gapHLg,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    L10n.of(context).sharedQuickAdd,
                                    style: AppTypography.headlineMedium,
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        '/categories',
                                      );
                                    },
                                    icon: Icon(
                                      Icons.settings_outlined,
                                      color: AppColors.textMuted,
                                      size: AppSpacing.iconXs,
                                    ),
                                    label: Text(
                                      L10n.of(context).dashManage,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                L10n.of(
                                  context,
                                ).sharedRecordYourIncomeOrExpense,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapXxl,
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildQuickAddOptions(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddOptions() {
    final quickOptions = [
      {
        'icon': Icons.shopping_cart_outlined,
        'title': 'Shopping',
        'color': AppColors.neonPink,
        'type': 'expense',
        'categoryName': 'Shopping',
      },
      {
        'icon': Icons.restaurant_outlined,
        'title': 'Food & Dining',
        'color': AppColors.neonCyan,
        'type': 'expense',
        'categoryName': 'Food & Dining',
      },
      {
        'icon': Icons.local_gas_station_outlined,
        'title': 'Fuel',
        'color': AppColors.info,
        'type': 'expense',
        'categoryName': 'Transportation',
      },
      {
        'icon': Icons.home_outlined,
        'title': 'Bills & Utilities',
        'color': AppColors.success,
        'type': 'expense',
        'categoryName': 'Bills & Utilities',
      },
      {
        'icon': Icons.movie_outlined,
        'title': 'Entertainment',
        'color': AppColors.warning,
        'type': 'expense',
        'categoryName': 'Entertainment',
      },
      {
        'icon': Icons.work_outline,
        'title': 'Work Income',
        'color': AppColors.success,
        'type': 'income',
        'categoryName': 'Salary',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context).settingsCategories,
          style: AppTypography.titleMedium,
        ),
        AppSpacing.gapLg,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.4,
          ),
          itemCount: quickOptions.length,
          itemBuilder: (context, index) {
            final option = quickOptions[index];
            final color = option['color'] as Color;
            return GlassCard(
              onTap: () {
                Navigator.pop(context);
                _navigateToAddTransaction(
                  option['type'] as String,
                  option['categoryName'] as String,
                );
              },
              padding: AppSpacing.paddingMd,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Icon(
                      option['icon'] as IconData,
                      color: color,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    option['title'] as String,
                    style: AppTypography.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasWallets = ref.watch(hasWalletsProvider);
    final isLoadingWallets = ref.watch(walletsLoadingProvider);

    // While wallets are being fetched, render the skeleton inside the SAME
    // dashboard chrome (app bar + bottom nav) as the loaded state. Because the
    // top-level structure matches, the nav persists across the transition and
    // the body simply fills in — so it reads as one continuous "dashboard
    // loading" instead of a separate blank skeleton screen first.
    if (isLoadingWallets) {
      return Container(
        decoration: const BoxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildCustomAppBar(),
          body: const SafeArea(child: ShimmerDashboard()),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavigationTapped,
            items: NavItems.defaultItems,
            itemKeys: const [null, null, null, null, null],
          ),
        ),
      );
    }

    // No wallets locally. Before assuming this is a brand-new user, wait for the
    // one-time restore sync to finish — a reinstalled/existing user pulls their
    // data down first and lands on the dashboard, never on create-first-wallet.
    if (!hasWallets) {
      final flow = ref.watch(startupFlowProvider);

      // Unresolved or blocked state gets the recovery screen, never the
      // first-wallet one.
      if (flow.needsUserAttention && !flow.startedOfflineByChoice) {
        return const StartupRecoveryScreen();
      }

      // Only a confirmed-empty account — or the user's own warned choice to
      // start offline — opens the create-first-wallet path.
      if (!flow.mayOfferFirstWallet) {
        return _buildRestoringScreen();
      }

      return CreateFirstWalletScreen(
        onWalletCreated: () {
          // Force refresh wallet provider
          ref.invalidate(walletProvider);
        },
      );
    }

    final body = Stack(
      children: [
        IndexedStack(
          index: _currentIndex,
          // The walkthrough key is attached to the account cards inside the
          // home screen, not around the screen itself — wrapping the whole
          // thing made the spotlight cover the display and pushed the tooltip,
          // with its Next and Skip buttons, off the bottom of it.
          children: _screens,
        ),
        // Non-blocking background-sync indicator, floating at the top.
        Positioned(
          top: AppSpacing.sm,
          left: 0,
          right: 0,
          child: const Align(
            alignment: Alignment.topCenter,
            child: SyncStatusBanner(),
          ),
        ),
      ],
    );

    final fab = _isFabVisible
        ? NeoFAB(
            key: _fabKey,
            icon: Icons.add,
            onPressed: _showAddTransactionModal,
          )
        : null;

    // Tablet / large screens: a side navigation rail instead of a bottom bar,
    // with the content held to a readable max width in the remaining space.
    if (isTablet(context)) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildCustomAppBar(),
        body: SafeArea(
          child: Row(
            children: [
              _buildNavRail(),
              VerticalDivider(width: 1, color: AppColors.glassBorder),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: fab,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }

    // Phone: bottom navigation bar.
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildCustomAppBar(),
      extendBody: false,
      body: body,
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTapped,
        items: NavItems.defaultItems,
        itemKeys: [
          _navHomeKey,
          _navActivityKey,
          _navAIKey,
          null, // Reports
          null, // Settings
        ],
      ),
    );
  }

  /// Left navigation rail used on tablet / large screens in place of the
  /// bottom bar.
  Widget _buildNavRail() {
    return NavigationRail(
      backgroundColor: Colors.transparent,
      selectedIndex: _currentIndex,
      onDestinationSelected: _onNavigationTapped,
      labelType: NavigationRailLabelType.all,
      groupAlignment: -0.75,
      indicatorColor: AppColors.primaryAccent.withValues(alpha: 0.18),
      selectedIconTheme: IconThemeData(color: AppColors.primaryAccent),
      unselectedIconTheme: IconThemeData(color: AppColors.textMuted),
      selectedLabelTextStyle: AppTypography.labelSmall.copyWith(
        color: AppColors.primaryAccent,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: AppTypography.labelSmall.copyWith(
        color: AppColors.textMuted,
      ),
      destinations: [
        for (final item in NavItems.defaultItems)
          NavigationRailDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.activeIcon),
            label: Text(NavItems.labelFor(item, L10n.of(context))),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.textPrimary,
              size: AppSpacing.iconSm,
            ),
          ),
          AppSpacing.gapHMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizedTitles(L10n.of(context))[_currentIndex],
                style: AppTypography.titleLarge,
              ),
              Text(
                L10n.of(context).settingsTheAccountant,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        KeyedSubtree(key: _notificationKey, child: _buildNotificationButton()),
        AppSpacing.gapHSm,
      ],
    );
  }

  Widget _buildNotificationButton() {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Stack(
      children: [
        NeoIconButton(
          icon: Icons.notifications_outlined,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationInboxScreen(),
              ),
            );
          },
          size: 40,
          iconSize: AppSpacing.iconSm,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(unreadCount > 9 ? 4 : 6),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToAddTransaction(String transactionType, String categoryName) {
    // Use the new Cashew-style transaction screen
    showAddTransactionScreen(
      context,
      initialType: transactionType == 'income'
          ? TransactionTypeSelection.income
          : TransactionTypeSelection.expense,
    );
  }
}
