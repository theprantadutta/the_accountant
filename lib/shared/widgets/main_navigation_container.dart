import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
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
import 'package:the_accountant/features/notifications/providers/notification_history_provider.dart';
import 'package:the_accountant/features/notifications/screens/notification_inbox_screen.dart';
import 'package:the_accountant/core/providers/walkthrough_provider.dart';
import 'package:the_accountant/features/walkthrough/walkthrough_service.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
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
  bool _restoring = false;
  bool _restoreAttempted = false;

  // Walkthrough keys
  final GlobalKey _balanceKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _navHomeKey = GlobalKey();
  final GlobalKey _navActivityKey = GlobalKey();
  final GlobalKey _navAIKey = GlobalKey();

  // Define the screens for each navigation item
  final List<Widget> _screens = [
    const ResponsiveFinancialOverview(), // Home
    const TransactionListScreen(), // Transactions
    const AIAssistantScreenGated(), // AI Assistant (Premium)
    const ReportsScreen(), // Reports
    const SettingsScreen(), // Settings
  ];

  final List<String> _screenTitles = [
    'Dashboard',
    'Transactions',
    'AI Assistant',
    'Reports',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pull existing server data before deciding this is a brand-new user.
      _maybeRestoreData();

      // Load unread notification count
      ref.read(notificationHistoryProvider.notifier).loadUnreadCount();

      // Trigger walkthrough for new users
      final walkthroughState = ref.read(walkthroughProvider);
      if (!walkthroughState.hasSeenWalkthrough) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            WalkthroughService.showDashboardWalkthrough(context, ref, {
              'balance': _balanceKey,
              'fab': _fabKey,
              'notification': _notificationKey,
              'navHome': _navHomeKey,
              'navActivity': _navActivityKey,
              'navAI': _navAIKey,
            });
          }
        });
      }
    });
  }

  /// When the local database is empty, attempt a one-time "restore" sync so a
  /// user who reinstalled the app (or logged in on a new device) pulls their
  /// existing data down from the server before we'd ever show the
  /// create-first-wallet screen. For genuinely new / free / offline users this
  /// resolves quickly and falls through to that screen.
  Future<void> _maybeRestoreData() async {
    // 1. Wait for the initial local wallet load to settle (~5s cap).
    var ticks = 0;
    while (mounted && ref.read(walletsLoadingProvider) && ticks++ < 100) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    if (!mounted) return;

    // 2. Already have local data → nothing to restore.
    if (ref.read(hasWalletsProvider)) {
      setState(() => _restoreAttempted = true);
      return;
    }

    // 3. Empty local DB → show a restoring state while we try to pull server data.
    setState(() => _restoring = true);

    // Cloud sync is premium-only, and on a fresh install premium status arrives
    // from the backend a beat after login. Give it a short window (~3s) to
    // resolve so a premium (synced) user isn't mistaken for a brand-new one.
    ticks = 0;
    while (mounted && !ref.read(premiumProvider).isPremium && ticks++ < 60) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (mounted && ref.read(premiumProvider).isPremium) {
      // Kick off a restore sync. This is a no-op if one is already running
      // (e.g. triggered by AuthWrapper); the wait loop below covers that case.
      try {
        await ref.read(syncNotifierProvider.notifier).syncAll();
      } catch (_) {
        // Ignore — fall through to the create-first-wallet screen.
      }

      // Wait for any in-flight sync to finish so pulled wallets are applied
      // before we decide what to render (~20s cap).
      ticks = 0;
      while (mounted &&
          ref.read(syncNotifierProvider) == SyncOperationState.syncing &&
          ticks++ < 400) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    if (!mounted) return;
    setState(() {
      _restoring = false;
      _restoreAttempted = true;
    });
  }

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
                const AuthBrandHeader(
                  icon: Icons.cloud_download_rounded,
                  title: 'Welcome back',
                  subtitle: 'Restoring your data from the cloud…',
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
                                    'Quick Add',
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
                                      'Manage',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Record your income or expense',
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
        Text('Categories', style: AppTypography.titleMedium),
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

    // Show loading while wallets are being fetched
    if (isLoadingWallets) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // No wallets locally. Before assuming this is a brand-new user, wait for the
    // one-time restore sync to finish — a reinstalled/existing user pulls their
    // data down first and lands on the dashboard, never on create-first-wallet.
    if (!hasWallets) {
      if (_restoring || !_restoreAttempted) {
        return _buildRestoringScreen();
      }
      return CreateFirstWalletScreen(
        onWalletCreated: () {
          // Force refresh wallet provider
          ref.invalidate(walletProvider);
        },
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildCustomAppBar(),
        extendBody: false,
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: _screens.asMap().entries.map((entry) {
                if (entry.key == 0) {
                  return KeyedSubtree(key: _balanceKey, child: entry.value);
                }
                return entry.value;
              }).toList(),
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
        ),
        floatingActionButton: _isFabVisible
            ? NeoFAB(
                key: _fabKey,
                icon: Icons.add,
                onPressed: _showAddTransactionModal,
              )
            : null,
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
      ),
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
                _screenTitles[_currentIndex],
                style: AppTypography.titleLarge,
              ),
              Text(
                'The Accountant',
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
