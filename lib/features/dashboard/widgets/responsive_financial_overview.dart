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
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/stat_card.dart';

class ResponsiveFinancialOverview extends ConsumerStatefulWidget {
  const ResponsiveFinancialOverview({super.key});

  @override
  ConsumerState<ResponsiveFinancialOverview> createState() =>
      _ResponsiveFinancialOverviewState();
}

class _ResponsiveFinancialOverviewState
    extends ConsumerState<ResponsiveFinancialOverview>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _balanceAnimationController;
  late Animation<double> _balanceAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: AppAnimations.long,
      vsync: this,
    );

    _balanceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _balanceAnimation = CurvedAnimation(
      parent: _balanceAnimationController,
      curve: AppAnimations.easeOut,
    );

    _animationController.forward();
    _balanceAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _balanceAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final financialData = ref.watch(financialDataProvider);

    // Show loading state
    if (financialData.isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryAccent,
          ),
        ),
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
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.gapLg,

              // Greeting Section
              _buildAnimatedSection(0.0, 0.3, _buildGreetingSection()),

              AppSpacing.gapXxl,

              // Balance Card
              _buildAnimatedSection(
                0.1,
                0.4,
                _buildBalanceCard(
                  financialData.totalBalance,
                  financialData.monthlyGrowthPercentage,
                ),
              ),

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

              // Quick Actions
              _buildAnimatedSection(0.3, 0.6, _buildQuickActions()),

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

              SizedBox(height: AppSpacing.huge + 40), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(double start, double end, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(start, end, curve: AppAnimations.easeOut),
      )),
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

  Widget _buildBalanceCard(double balance, double growthPercentage) {
    return AccentGlassCard(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_rounded,
                        color: AppColors.textPrimary,
                        size: AppSpacing.iconXs,
                      ),
                      AppSpacing.gapHXs,
                      Text(
                        'Show',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapMd,
            AnimatedBuilder(
              animation: _balanceAnimation,
              builder: (context, child) {
                final animatedBalance = balance * _balanceAnimation.value;
                return Text(
                  '\$${NumberFormat('#,##0.00').format(animatedBalance)}',
                  style: AppTypography.monoLarge.copyWith(
                    fontSize: 40,
                  ),
                );
              },
            ),
            AppSpacing.gapMd,
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (growthPercentage >= 0
                            ? AppColors.success
                            : AppColors.error)
                        .withValues(alpha: 0.15),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        growthPercentage >= 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: growthPercentage >= 0
                            ? AppColors.success
                            : AppColors.error,
                        size: AppSpacing.iconXs,
                      ),
                      AppSpacing.gapHXs,
                      Text(
                        '${growthPercentage >= 0 ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%',
                        style: AppTypography.labelSmall.copyWith(
                          color: growthPercentage >= 0
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapHSm,
                Text(
                  'from last month',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(double income, double expenses) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Income',
            value: income,
            prefix: '\$',
            icon: Icons.trending_up_rounded,
            iconColor: AppColors.success,
            accentColor: AppColors.success,
            trend: TrendDirection.up,
            trendValue: 'This month',
          ),
        ),
        AppSpacing.gapHMd,
        Expanded(
          child: StatCard(
            label: 'Expenses',
            value: expenses,
            prefix: '\$',
            icon: Icons.trending_down_rounded,
            iconColor: AppColors.error,
            accentColor: AppColors.error,
            trend: TrendDirection.down,
            trendValue: 'This month',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.add_rounded,
        'label': 'Add',
        'color': AppColors.primaryAccent,
      },
      {
        'icon': Icons.swap_horiz_rounded,
        'label': 'Transfer',
        'color': AppColors.neonCyan,
      },
      {
        'icon': Icons.receipt_long_rounded,
        'label': 'Bills',
        'color': AppColors.neonPurple,
      },
      {
        'icon': Icons.savings_rounded,
        'label': 'Goals',
        'color': AppColors.success,
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          final color = action['color'] as Color;
          return Container(
            margin: EdgeInsets.only(right: AppSpacing.md),
            child: GlassCard(
              width: 80,
              onTap: () => HapticFeedback.lightImpact(),
              padding: AppSpacing.paddingSm,
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
                      action['icon'] as IconData,
                      color: color,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    action['label'] as String,
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpendingChart() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Overview',
            style: AppTypography.titleMedium,
          ),
          AppSpacing.gapLg,
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.glassBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 1.5),
                      FlSpot(2, 4),
                      FlSpot(3, 3.1),
                      FlSpot(4, 4.8),
                      FlSpot(5, 3.5),
                      FlSpot(6, 5),
                    ],
                    isCurved: true,
                    gradient: AppColors.primaryGradient,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: index == 6 ? 5 : 0,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: AppTypography.titleMedium,
              ),
              GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
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
              final categories =
                  ref.read(cat_provider.categoryProvider).categories;
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

              final isIncome = transaction.type == 'income';
              final categoryColor = Color(
                int.parse(category.colorCode.replaceFirst('#', '0xFF')),
              );

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
                      '${isIncome ? '+' : '-'}\$${NumberFormat('#,##0.00').format(transaction.amount)}',
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

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Progress',
                style: AppTypography.titleMedium,
              ),
              GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
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
                        Text(
                          item.budgetName,
                          style: AppTypography.titleSmall,
                        ),
                        Text(
                          '\$${NumberFormat('#,##0').format(spent)} / \$${NumberFormat('#,##0').format(limit)}',
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
                          width: MediaQuery.of(context).size.width *
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
