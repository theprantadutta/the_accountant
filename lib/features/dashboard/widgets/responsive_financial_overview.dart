import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat_provider;
import 'package:the_accountant/features/reports/providers/reports_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/stat_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
// import 'package:the_accountant/features/transactions/screens/upcoming_transactions_screen.dart';
// import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
// import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/credit_debt/screens/credit_debt_screen.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/subscriptions/screens/subscription_dashboard_screen.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/features/dashboard/widgets/wallet_cards_section.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_type_screen.dart';

class ResponsiveFinancialOverview extends ConsumerStatefulWidget {
  const ResponsiveFinancialOverview({super.key});

  @override
  ConsumerState<ResponsiveFinancialOverview> createState() =>
      _ResponsiveFinancialOverviewState();
}

class _ResponsiveFinancialOverviewState
    extends ConsumerState<ResponsiveFinancialOverview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: AppAnimations.long,
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final financialData = ref.watch(financialDataProvider);

    // Show loading state with shimmer
    if (financialData.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: ShimmerDashboard()),
      );
    }

    // Show error state
    if (financialData.error != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: GlassCard(
            padding: AppSpacing.paddingXl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: AppSpacing.iconXxl,
                ),
                AppSpacing.gapLg,
                Text(
                  'Error loading financial data',
                  style: AppTypography.titleMedium,
                ),
                AppSpacing.gapSm,
                Text(
                  financialData.error!,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapLg,
                ElevatedButton(
                  onPressed: () =>
                      ref.read(financialDataProvider.notifier).refreshData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(financialDataProvider.notifier).refreshData();
          },
          color: AppColors.primaryAccent,
          backgroundColor: AppColors.primarySurface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.paddingScreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.gapLg,

                // Greeting Section
                _buildAnimatedSection(0.0, 0.3, _buildGreetingSection()),

                AppSpacing.gapXxl,

                // Wallet Cards Section (horizontal scrollable accounts)
                _buildAnimatedSection(0.1, 0.4, const WalletCardsSection()),

                AppSpacing.gapXl,

                // Quick Stats Row
                _buildAnimatedSection(
                  0.2,
                  0.5,
                  _buildQuickStats(
                    financialData.monthlyIncome,
                    financialData.monthlyExpenses,
                  ),
                ),

                AppSpacing.gapXl,

                // Quick Links
                _buildAnimatedSection(0.3, 0.6, _buildQuickLinks()),

                AppSpacing.gapXl,

                // Spending Chart
                _buildAnimatedSection(0.4, 0.7, _buildSpendingChart()),

                AppSpacing.gapXl,

                // Recent Transactions
                _buildAnimatedSection(
                  0.5,
                  0.8,
                  _buildRecentTransactions(financialData.recentTransactions),
                ),

                AppSpacing.gapXl,

                // Budget Progress
                _buildAnimatedSection(0.6, 0.9, _buildBudgetProgress()),

                SizedBox(height: AppSpacing.lg), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(double start, double end, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(start, end, curve: AppAnimations.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: AppAnimations.easeOut),
        ),
        child: child,
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.waving_hand_rounded,
            color: AppColors.textPrimary,
            size: AppSpacing.iconMd,
          ),
        ),
        AppSpacing.gapHLg,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_getTimeOfDay()}!',
                style: AppTypography.headlineLarge,
              ),
              AppSpacing.gapXs,
              Text(
                'Ready to manage your finances?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildQuickLinks() {
    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);

    final creditDebtState = ref.watch(creditDebtProvider);
    final netBalance = creditDebtState.netBalance;

    final subState = ref.watch(subscriptionDashboardProvider);
    final monthlySubs = subState.totalMonthlyCost;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Credit & Debt',
            value: netBalance.abs(),
            prefix: '${netBalance >= 0 ? '+' : '-'}$currencySymbol',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.neonCyan,
            accentColor: AppColors.neonCyan,
            variant: GlassCardVariant.cyan,
            trend: netBalance >= 0 ? TrendDirection.up : TrendDirection.down,
            trendValue: netBalance >= 0 ? 'Net credit' : 'Net debt',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreditDebtScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: 'Subscriptions',
            value: monthlySubs,
            prefix: currencySymbol,
            icon: Icons.subscriptions_rounded,
            iconColor: AppColors.neonPurple,
            accentColor: AppColors.neonPurple,
            variant: GlassCardVariant.purple,
            trend: TrendDirection.down,
            trendValue: 'Monthly',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionDashboardScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(double income, double expenses) {
    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Income',
            value: income,
            prefix: currencySymbol,
            icon: Icons.trending_up_rounded,
            iconColor: AppColors.success,
            accentColor: AppColors.success,
            trend: TrendDirection.up,
            trendValue: 'This month',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const TransactionTypeScreen(transactionType: 'income'),
                ),
              );
            },
          ),
        ),
        AppSpacing.gapHMd,
        Expanded(
          child: StatCard(
            label: 'Expenses',
            value: expenses,
            prefix: currencySymbol,
            icon: Icons.trending_down_rounded,
            iconColor: AppColors.error,
            accentColor: AppColors.error,
            trend: TrendDirection.down,
            trendValue: 'This month',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const TransactionTypeScreen(transactionType: 'expense'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildQuickActions() {
  //   final actions = [
  //     {
  //       'icon': Icons.add_rounded,
  //       'label': 'Add',
  //       'color': AppColors.primaryAccent,
  //       'route': 'add',
  //     },
  //     {
  //       'icon': Icons.schedule_rounded,
  //       'label': 'Upcoming',
  //       'color': AppColors.warning,
  //       'route': 'upcoming',
  //     },
  //     {
  //       'icon': Icons.account_balance_wallet_rounded,
  //       'label': 'Lend/Borrow',
  //       'color': AppColors.neonCyan,
  //       'route': 'credit_debt',
  //     },
  //     {
  //       'icon': Icons.savings_rounded,
  //       'label': 'Goals',
  //       'color': AppColors.success,
  //       'route': 'goals',
  //     },
  //     {
  //       'icon': Icons.swap_horiz_rounded,
  //       'label': 'Transfer',
  //       'color': AppColors.neonPurple,
  //       'route': 'transfer',
  //     },
  //   ];

  //   return SizedBox(
  //     height: 100,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: actions.length,
  //       itemBuilder: (context, index) {
  //         final action = actions[index];
  //         final color = action['color'] as Color;
  //         return Container(
  //           margin: EdgeInsets.only(right: AppSpacing.md),
  //           child: GlassCard(
  //             width: 80,
  //             onTap: () {
  //               HapticFeedback.lightImpact();
  //               _handleQuickAction(action['route'] as String?);
  //             },
  //             padding: AppSpacing.paddingSm,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   width: 40,
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     color: color.withValues(alpha: 0.15),
  //                     borderRadius: AppSpacing.borderRadiusMd,
  //                   ),
  //                   child: Icon(
  //                     action['icon'] as IconData,
  //                     color: color,
  //                     size: AppSpacing.iconSm,
  //                   ),
  //                 ),
  //                 AppSpacing.gapXs,
  //                 Text(
  //                   action['label'] as String,
  //                   style: AppTypography.labelSmall,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // void _handleQuickAction(String? route) {
  //   switch (route) {
  //     case 'add':
  //       showAddTransactionScreen(context);
  //       break;
  //     case 'upcoming':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const UpcomingTransactionsScreen(),
  //         ),
  //       );
  //       break;
  //     case 'credit_debt':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const CreditDebtScreen(),
  //         ),
  //       );
  //       break;
  //     case 'goals':
  //       // Navigate to budgets for now (goals/objectives screen coming soon)
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const BudgetListScreen(),
  //         ),
  //       );
  //       break;
  //     case 'transfer':
  //       showAddTransactionScreen(
  //         context,
  //         initialType: TransactionTypeSelection.transfer,
  //       );
  //       break;
  //   }
  // }

  Widget _buildSpendingChart() {
    final reportsState = ref.watch(reportsProvider);
    final spots = reportsState.toLineChartSpots();
    final maxY = reportsState.getMaxY();

    return GlassCard(
      variant: GlassCardVariant.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spending Overview', style: AppTypography.titleMedium),
          AppSpacing.gapLg,
          SizedBox(
            height: 180,
            child: spots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart,
                          color: AppColors.textMuted,
                          size: 40,
                        ),
                        AppSpacing.gapSm,
                        Text(
                          'No spending data yet',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppColors.glassBorder,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          gradient: AppColors.primaryGradient,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: index == spots.length - 1 ? 5 : 0,
                                color: AppColors.primaryAccent,
                                strokeWidth: 2,
                                strokeColor: AppColors.textPrimary,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryAccent.withValues(alpha: 0.3),
                                AppColors.primaryAccent.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'food & dining':
      case 'food':
      case 'dining':
        return Icons.restaurant_rounded;
      case 'transportation':
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_cart_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'salary':
      case 'income':
        return Icons.work_rounded;
      case 'freelance':
        return Icons.business_center_rounded;
      case 'bills':
      case 'utilities':
        return Icons.home_rounded;
      case 'health':
      case 'medical':
        return Icons.local_hospital_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'travel':
        return Icons.flight_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Widget _buildRecentTransactions(List<Transaction> transactions) {
    return GlassCard(
      variant: GlassCardVariant.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions', style: AppTypography.titleMedium),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionListScreen(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,
          if (transactions.isEmpty)
            Center(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: AppColors.textMuted,
                      size: AppSpacing.iconXxl,
                    ),
                    AppSpacing.gapMd,
                    Text(
                      'No transactions yet',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.gapXs,
                    Text(
                      'Add your first transaction to get started',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...transactions.take(5).map((transaction) {
              final categories = ref
                  .read(cat_provider.categoryProvider)
                  .categories;
              final category = categories.firstWhere(
                (c) => c.id == transaction.categoryId,
                orElse: () => cat_provider.Category(
                  id: transaction.categoryId ?? '',
                  name: 'Unknown',
                  colorCode: '#999999',
                  type: transaction.type,
                  isDefault: false,
                ),
              );

              final isIncome = transaction.isIncome;
              final categoryColor = Color(
                int.parse(category.colorCode.replaceFirst('#', '0xFF')),
              );
              final walletCurrency = ref.watch(
                walletCurrencyProvider(transaction.walletId),
              );
              final useDecimals = ref.watch(
                walletDecimalProvider(transaction.walletId),
              );
              final currencySymbol = CurrencyInfo.getSymbol(walletCurrency);
              final formatter = useDecimals
                  ? NumberFormat('#,##0.00')
                  : NumberFormat('#,##0');
              final displayAmount = useDecimals
                  ? transaction.amount
                  : transaction.amount.round();

              return Container(
                margin: EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: Icon(
                        _getCategoryIcon(category.name),
                        color: categoryColor,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                    AppSpacing.gapHMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (transaction.notes?.isNotEmpty ?? false)
                                ? transaction.notes!
                                : category.name,
                            style: AppTypography.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            category.name,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isIncome ? '+' : '-'}$currencySymbol${formatter.format(displayAmount)}',
                      style: AppTypography.monoSmall.copyWith(
                        color: isIncome ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBudgetProgress() {
    final items = ref.watch(budgetProgressDetailsProvider);
    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);
    final formatter = useDecimals
        ? NumberFormat('#,##0.00')
        : NumberFormat('#,##0');

    return GlassCard(
      variant: GlassCardVariant.success,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budget Progress', style: AppTypography.titleMedium),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BudgetListScreen(),
                    ),
                  );
                },
                child: Text(
                  'Manage',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,
          if (items.isEmpty)
            Text(
              'No active budgets',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            )
          else
            ...items.map((item) {
              final spent = item.spent;
              final limit = item.limit;
              final percentage = limit <= 0 ? 0.0 : spent / limit;
              final isOverBudget = percentage > 1.0;
              final barColor = Color(
                int.parse(item.colorCode.replaceFirst('#', '0xFF')),
              );

              return Container(
                margin: EdgeInsets.only(bottom: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.budgetName, style: AppTypography.titleSmall),
                        Text(
                          '$currencySymbol${formatter.format(useDecimals ? spent : spent.round())} / $currencySymbol${formatter.format(useDecimals ? limit : limit.round())}',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapSm,
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.glassWhite,
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                        ),
                        AnimatedContainer(
                          duration: AppAnimations.slow,
                          width:
                              MediaQuery.of(context).size.width *
                              0.75 *
                              (percentage.clamp(0.0, 1.0)),
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: isOverBudget
                                ? LinearGradient(
                                    colors: [
                                      AppColors.error,
                                      AppColors.error.withValues(alpha: 0.7),
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      barColor,
                                      barColor.withValues(alpha: 0.7),
                                    ],
                                  ),
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapXs,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isOverBudget ? 'Over budget' : 'Within budget',
                          style: AppTypography.labelSmall.copyWith(
                            color: isOverBudget
                                ? AppColors.error
                                : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          '${(percentage * 100).clamp(0.0, 999.9).toStringAsFixed(0)}%',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
