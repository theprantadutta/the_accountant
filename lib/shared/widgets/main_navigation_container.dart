import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:the_accountant/shared/widgets/add_transaction_fab.dart';
import 'package:the_accountant/features/dashboard/widgets/responsive_financial_overview.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/ai_assistant/screens/ai_assistant_screen.dart';
import 'package:the_accountant/features/authentication/presentation/screens/user_profile_screen.dart';

// We'll create this reports screen
import 'package:the_accountant/features/reports/screens/reports_screen.dart';

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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        AppTheme.gradientContainer(
                          gradient: AppTheme.primaryGradient,
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(16),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Transaction',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Record your income or expense',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
        'icon': Icons.shopping_cart,
        'title': 'Shopping',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'icon': Icons.restaurant,
        'title': 'Food & Dining',
        'color': const Color(0xFF4ECDC4),
      },
      {
        'icon': Icons.local_gas_station,
        'title': 'Fuel',
        'color': const Color(0xFF45B7D1),
      },
      {
        'icon': Icons.home,
        'title': 'Bills & Utilities',
        'color': const Color(0xFF96CEB4),
      },
      {
        'icon': Icons.movie,
        'title': 'Entertainment',
        'color': const Color(0xFFFFA07A),
      },
      {
        'icon': Icons.business_center,
        'title': 'Work Income',
        'color': const Color(0xFF98D8C8),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: quickOptions.length,
          itemBuilder: (context, index) {
            final option = quickOptions[index];
            return GestureDetector(
              onTap: () {
                // Navigate to add transaction with pre-filled category
                Navigator.pop(context);
                // TODO: Navigate to AddTransactionScreen with category
              },
              child: AppTheme.glassmorphicContainer(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: option['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          option['icon'] as IconData,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
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
            ? AddTransactionFab(
                onPressed: _showAddTransactionModal,
                isExtended: true,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          AppTheme.gradientContainer(
            gradient: AppTheme.primaryGradient,
            width: 32,
            height: 32,
            borderRadius: BorderRadius.circular(8),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _screenTitles[_currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The Accountant',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // Handle notifications
            HapticFeedback.lightImpact();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
