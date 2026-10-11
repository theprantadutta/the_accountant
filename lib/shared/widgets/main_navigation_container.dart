import 'package:flutter/material.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:the_accountant/core/domain/app_destination.dart';
import 'package:the_accountant/core/providers/deep_link_provider.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/providers/startup_flow_provider.dart';
import 'package:the_accountant/core/providers/walkthrough_provider.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/deep_link_service.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/utils/responsive.dart';
import 'package:the_accountant/features/ai/screens/receipt_scanner_screen.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/features/dashboard/widgets/responsive_financial_overview.dart';
import 'package:the_accountant/features/notifications/providers/notification_history_provider.dart';
import 'package:the_accountant/features/notifications/widgets/notification_permission_primer.dart';
import 'package:the_accountant/features/reports/screens/reports_screen.dart';
import 'package:the_accountant/features/settings/screens/settings_screen.dart';
import 'package:the_accountant/features/startup/screens/startup_recovery_screen.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/walkthrough/walkthrough_service.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/create_first_wallet_screen.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/shared/widgets/sync_status_banner.dart';

/// The signed-in shell: Today, Wallets, the Add pill, Stats and More.
///
/// Activity used to be a tab; it is now pushed from Today. The AI assistant
/// used to be a tab; it is reached from cards on Today and Stats and from
/// More. Neither lost a way in.
class MainNavigationContainer extends ConsumerStatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  ConsumerState<MainNavigationContainer> createState() =>
      _MainNavigationContainerState();
}

class _MainNavigationContainerState
    extends ConsumerState<MainNavigationContainer>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // Walkthrough targets.
  final GlobalKey _balanceKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _navTodayKey = GlobalKey();
  final GlobalKey _navWalletsKey = GlobalKey();
  final GlobalKey _navStatsKey = GlobalKey();

  /// Crossfade plus a 6dp rise on every tab switch.
  late final AnimationController _tabFade = AnimationController(
    vsync: this,
    duration: SunriseMotion.tab,
    value: 1,
  );

  late final List<Widget> _screens = [
    ResponsiveFinancialOverview(
      balanceKey: _balanceKey,
      notificationKey: _notificationKey,
    ),
    const WalletManagementScreen(asTab: true),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  /// Stable English names, for analytics. Event identifiers, not labels.
  static const List<String> _screenTitles = [
    'Dashboard',
    'Wallets',
    'Reports',
    'Settings',
  ];

  /// The tab each destination lives on, for the ones that are tabs.
  static const Map<AppDestination, int> _tabFor = {
    AppDestination.dashboard: 0,
    AppDestination.reports: 2,
    AppDestination.settings: 3,
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
      _select(tab);
      return;
    }

    final screen = switch (link.destination) {
      AppDestination.transactions => const TransactionListScreen(
        standalone: true,
      ),
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
      ref.read(notificationHistoryProvider.notifier).loadUnreadCount();

      // No arbitrary delay: the service waits for the widgets it points at to
      // exist.
      final walkthroughState = ref.read(walkthroughProvider);
      if (!walkthroughState.hasSeenWalkthrough && mounted) _startWalkthrough();

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
  DeepLinkService? _deepLinks;

  @override
  void dispose() {
    _deepLinks?.pending.removeListener(_followPendingLink);
    _tabFade.dispose();
    super.dispose();
  }

  /// Shows the notification priming prompt on the home screen — once, and only
  /// after the first-run walkthrough is done so the two don't overlap.
  Future<void> _maybeShowNotificationPrimer() async {
    const primerShownKey = 'notification_primer_shown';
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs.getBool(primerShownKey) ?? false) return;

    if (!ref.read(walkthroughProvider).hasSeenWalkthrough) return;

    if (await NotificationService().hasPermission()) {
      await prefs.setBool(primerShownKey, true);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    await showNotificationPermissionPrimer(context);
    await prefs.setBool(primerShownKey, true);
  }

  // The startup flow is driven by `AuthWrapper`, which decides whether this
  // container is on screen at all. Driving it from here as well was a loop.

  void _startWalkthrough() {
    WalkthroughService.showDashboardWalkthrough(context, ref, {
      'balance': _balanceKey,
      'add': _addKey,
      'navToday': _navTodayKey,
      'navWallets': _navWalletsKey,
      'navStats': _navStatsKey,
      'notification': _notificationKey,
    });
  }

  /// A returning account with nothing local yet: the same animated intro the
  /// app opens with, so the wait for the cloud copy reads as one launch.
  Widget _buildRestoringScreen() {
    final l10n = L10n.of(context);
    return AuthLoadingScreen(
      key: const ValueKey('restoring'),
      steps: [l10n.sharedWelcomeBack, l10n.sharedRestoringYourDataFromThe],
    );
  }

  void _select(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _tabFade.forward(from: 0);
    AnalyticsService().logScreenView(screenName: _screenTitles[index]);
  }

  void _openAdd() {
    HapticFeedback.mediumImpact();
    showAddTransactionScreen(context);
  }

  List<SunriseTabItem> _tabs(L10n l10n) {
    final unread = ref.watch(unreadNotificationCountProvider);
    return [
      SunriseTabItem(
        icon: Symbols.sunny_rounded,
        label: l10n.navToday,
        key: _navTodayKey,
        badge: unread > 0 && _currentIndex != 0,
      ),
      SunriseTabItem(
        icon: Symbols.account_balance_wallet_rounded,
        label: l10n.navWallets,
        key: _navWalletsKey,
      ),
      SunriseTabItem(
        icon: Symbols.leaderboard_rounded,
        label: l10n.navStats,
        key: _navStatsKey,
      ),
      SunriseTabItem(icon: Symbols.more_horiz_rounded, label: l10n.navMore),
    ];
  }

  Widget _tabBody(Widget content) {
    return AnimatedBuilder(
      animation: _tabFade,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_tabFade.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 6),
            child: child,
          ),
        );
      },
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Replay from More: go back to Today and run the tour here, in place.
    // Rebuilding the route stack for it dropped the auth gate underneath, so
    // signing out afterwards had nowhere to go.
    ref.listen(walkthroughProvider, (previous, next) {
      if ((previous?.hasSeenWalkthrough ?? false) && !next.hasSeenWalkthrough) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        _select(0);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _startWalkthrough();
        });
      }
    });
    final l10n = L10n.of(context);
    final hasWallets = ref.watch(hasWalletsProvider);
    final isLoadingWallets = ref.watch(walletsLoadingProvider);

    // While wallets are being fetched, render the skeleton inside the SAME
    // chrome as the loaded state, so the tab bar persists across the
    // transition and the body simply fills in.
    if (isLoadingWallets) {
      return _chrome(
        l10n,
        const SunriseBackground(
          child: SafeArea(bottom: false, child: ShimmerDashboard()),
        ),
      );
    }

    // No wallets locally. Before assuming this is a brand-new user, wait for the
    // one-time restore sync to finish.
    if (!hasWallets) {
      final flow = ref.watch(startupFlowProvider);

      if (flow.needsUserAttention && !flow.startedOfflineByChoice) {
        return const StartupRecoveryScreen();
      }

      if (!flow.mayOfferFirstWallet) {
        return _buildRestoringScreen();
      }

      return CreateFirstWalletScreen(
        onWalletCreated: () => ref.invalidate(walletProvider),
      );
    }

    final body = Stack(
      children: [
        _tabBody(IndexedStack(index: _currentIndex, children: _screens)),
        // Non-blocking sync indicator, a toast just above the tab bar so it
        // never covers a screen's header.
        Positioned(
          left: 0,
          right: 0,
          bottom:
              (isTablet(context) ? 16 : 90) +
              MediaQuery.paddingOf(context).bottom,
          child: const Center(child: SyncStatusBanner()),
        ),
      ],
    );

    return _chrome(l10n, body);
  }

  /// The shell around a body: tab bar on phones, a rail on tablets.
  Widget _chrome(L10n l10n, Widget body) {
    if (isTablet(context)) {
      final c = context.sunrise;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            SunriseGlass(
              color: c.tabBar,
              border: BorderDirectional(end: BorderSide(color: c.tabBarBorder)),
              child: SafeArea(right: false, child: _buildNavRail(l10n)),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      // The frosted bar floats over content; scrollables pad themselves by
      // SunriseSpace.tabBarClearance so nothing ends up hidden behind it.
      extendBody: true,
      body: body,
      bottomNavigationBar: SunriseTabBar(
        items: _tabs(l10n),
        currentIndex: _currentIndex,
        onTap: _select,
        onAdd: _openAdd,
        addLabel: l10n.navAdd,
        addKey: _addKey,
      ),
    );
  }

  /// Side navigation for tablets: the same four destinations, Add on top.
  Widget _buildNavRail(L10n l10n) {
    final c = context.sunrise;
    final tabs = _tabs(l10n);
    return NavigationRail(
      backgroundColor: Colors.transparent,
      selectedIndex: _currentIndex,
      onDestinationSelected: (i) {
        HapticFeedback.selectionClick();
        _select(i);
      },
      labelType: NavigationRailLabelType.all,
      groupAlignment: -0.7,
      leading: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        child: Pressable(
          key: _addKey,
          onTap: _openAdd,
          haptic: true,
          semanticLabel: l10n.navAdd,
          child: Container(
            width: 52,
            height: 40,
            decoration: BoxDecoration(
              gradient: c.gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: c.selectedShadow,
            ),
            child: const Icon(Symbols.add_rounded, color: Colors.white),
          ),
        ),
      ),
      destinations: [
        for (final t in tabs)
          NavigationRailDestination(
            icon: Icon(t.icon, key: t.key, size: 26),
            selectedIcon: Icon(t.icon, size: 26, fill: 1),
            label: Text(t.label),
          ),
      ],
    );
  }
}
