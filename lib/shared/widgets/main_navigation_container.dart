import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/features/dashboard/widgets/responsive_financial_overview.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/ai_assistant/screens/ai_assistant_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/user_profile_screen.dart';
import 'package:the_accountant/features/reports/screens/reports_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/create_first_wallet_screen.dart';

class MainNavigationContainer extends ConsumerStatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  ConsumerState<MainNavigationContainer> createState() =>
      _MainNavigationContainerState();
}

class _MainNavigationContainerState
    extends ConsumerState<MainNavigationContainer>
    with TickerProviderStateMixin {
  late PageController _pageController;

  int _currentIndex = 0;
  bool _isFabVisible = true;

  // Define the screens for each navigation item
  final List<Widget> _screens = [
    const ResponsiveFinancialOverview(), // Home
    const TransactionListScreen(), // Transactions
    const AIAssistantScreen(), // AI Assistant
    const ReportsScreen(), // Reports
    const UserProfileScreen(), // Profile
  ];

  final List<String> _screenTitles = [
    'Dashboard',
    'Transactions',
    'AI Assistant',
    'Reports',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      // Animate to the selected page
      _pageController.animateToPage(
        index,
        duration: AppAnimations.normal,
        curve: AppAnimations.easeOut,
      );

      // Update FAB visibility based on screen
      _updateFabVisibility(index);

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
                                      Navigator.pushNamed(context, '/categories');
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
        Text(
          'Categories',
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

    // Show loading while wallets are being fetched
    if (isLoadingWallets) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show create wallet screen if user has no wallets
    if (!hasWallets) {
      return CreateFirstWalletScreen(
        onWalletCreated: () {
          // Force refresh wallet provider
          ref.invalidate(walletProvider);
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildCustomAppBar(),
        extendBody: true,
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
            _updateFabVisibility(index);
          },
          itemCount: _screens.length,
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
        floatingActionButton: _isFabVisible
            ? NeoFAB(
                icon: Icons.add,
                onPressed: _showAddTransactionModal,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavigationTapped,
          items: NavItems.defaultItems,
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
        NeoIconButton(
          icon: Icons.notifications_outlined,
          onPressed: () {
            HapticFeedback.lightImpact();
            // Handle notifications
          },
          size: 40,
          iconSize: AppSpacing.iconSm,
        ),
        AppSpacing.gapHSm,
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
