import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat_provider;
import 'package:the_accountant/data/datasources/local/app_database.dart';

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
  late Animation<double> _slideAnimation;
  late Animation<double> _balanceAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _balanceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _balanceAnimation = CurvedAnimation(
      parent: _balanceAnimationController,
      curve: Curves.easeOutCubic,
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
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show error state
    if (financialData.error != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error loading financial data',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                financialData.error!,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(financialDataProvider.notifier).refreshData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Greeting Section
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(-1, 0),
                child: _buildGreetingSection(),
              ),

              const SizedBox(height: 32),

              // Balance Card
              AnimationUtils.scaleTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.1,
                  endFraction: 0.4,
                ),
                child: _buildBalanceCard(
                  financialData.totalBalance,
                  financialData.monthlyGrowthPercentage,
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.2,
                  endFraction: 0.5,
                ),
                begin: const Offset(1, 0),
                child: _buildQuickActions(),
              ),

              const SizedBox(height: 32),

              // Income/Expense Overview
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.3,
                  endFraction: 0.6,
                ),
                begin: const Offset(0, 1),
                child: _buildIncomeExpenseOverview(
                  financialData.monthlyIncome,
                  financialData.monthlyExpenses,
                ),
              ),

              const SizedBox(height: 24),

              // Spending Chart
              AnimationUtils.fadeTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.4,
                  endFraction: 0.7,
                ),
                child: _buildSpendingChart(),
              ),

              const SizedBox(height: 24),

              // Recent Transactions
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.5,
                  endFraction: 0.8,
                ),
                begin: const Offset(0, 1),
                child: _buildRecentTransactions(
                  financialData.recentTransactions,
                ),
              ),

              const SizedBox(height: 24),

              // Budget Progress
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.6,
                  endFraction: 0.9,
                ),
                begin: const Offset(0, 1),
                child: _buildBudgetProgress(),
              ),

              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      children: [
        AppTheme.gradientContainer(
          gradient: AppTheme.primaryGradient,
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(16),
          child: const Icon(Icons.waving_hand, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_getTimeOfDay()}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Ready to manage your finances?',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
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

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'food & dining':
      case 'food':
      case 'dining':
        return Icons.restaurant;
      case 'transportation':
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      case 'entertainment':
        return Icons.movie;
      case 'salary':
      case 'income':
        return Icons.work;
      case 'freelance':
        return Icons.business_center;
      case 'bills':
      case 'utilities':
        return Icons.home;
      case 'health':
      case 'medical':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }

  Widget _buildBalanceCard(double balance, double growthPercentage) {
    return AppTheme.gradientContainer(
      gradient: AppTheme.primaryGradient,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'Show',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _balanceAnimation,
              builder: (context, child) {
                final animatedBalance = balance * _balanceAnimation.value;
                return Text(
                  '\$${NumberFormat('#,##0.00').format(animatedBalance)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (growthPercentage >= 0 ? Colors.green : Colors.red)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        growthPercentage >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: growthPercentage >= 0
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${growthPercentage >= 0 ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: growthPercentage >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'from last month',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.arrow_upward,
        'label': 'Send',
        'color': const Color(0xFF667eea),
      },
      {
        'icon': Icons.arrow_downward,
        'label': 'Receive',
        'color': const Color(0xFF11998e),
      },
      {
        'icon': Icons.credit_card,
        'label': 'Cards',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'icon': Icons.more_horiz,
        'label': 'More',
        'color': const Color(0xFF4ECDC4),
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: AppTheme.glassmorphicContainer(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: action['color'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIncomeExpenseOverview(double income, double expenses) {
    return Row(
      children: [
        Expanded(
          child: AppTheme.glassmorphicContainer(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Income',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(income)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'This month',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTheme.glassmorphicContainer(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.trending_down,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Expenses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(expenses)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'This month',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingChart() {
    return AppTheme.glassmorphicContainer(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
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
                      gradient: AppTheme.primaryGradient,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF667eea).withValues(alpha: 0.3),
                            const Color(0xFF764ba2).withValues(alpha: 0.1),
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
      ),
    );
  }

  Widget _buildRecentTransactions(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return AppTheme.glassmorphicContainer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add your first transaction to get started',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppTheme.glassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => HapticFeedback.lightImpact(),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: const Color(0xFF667eea),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...transactions.take(5).map((transaction) {
              final categories = ref
                  .read(cat_provider.categoryProvider)
                  .categories;
              final category = categories.firstWhere(
                (c) => c.id == transaction.categoryId,
                orElse: () => cat_provider.Category(
                  id: transaction.categoryId,
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
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(category.name),
                        color: categoryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (transaction.notes?.isNotEmpty ?? false)
                                ? transaction.notes!
                                : category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isIncome ? '+' : '-'}\$${NumberFormat('#,##0.00').format(transaction.amount)}',
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetProgress() {
    final mockBudgets = [
      {
        'name': 'Food & Dining',
        'spent': 850.0,
        'limit': 1200.0,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'name': 'Transportation',
        'spent': 320.0,
        'limit': 500.0,
        'color': const Color(0xFF45B7D1),
      },
      {
        'name': 'Entertainment',
        'spent': 180.0,
        'limit': 300.0,
        'color': const Color(0xFFFFA07A),
      },
    ];

    return AppTheme.glassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budget Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => HapticFeedback.lightImpact(),
                  child: Text(
                    'Manage',
                    style: TextStyle(
                      color: const Color(0xFF667eea),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...mockBudgets.map((budget) {
              final spent = budget['spent'] as double;
              final limit = budget['limit'] as double;
              final percentage = spent / limit;
              final isOverBudget = percentage > 1.0;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budget['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${NumberFormat('#,##0.00').format(spent)} / \$${NumberFormat('#,##0.00').format(limit)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Container(
                          width:
                              MediaQuery.of(context).size.width *
                              (percentage > 1.0 ? 1.0 : percentage) *
                              0.8,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isOverBudget
                                ? Colors.red
                                : (budget['color'] as Color),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isOverBudget
                          ? 'Over budget by \$${NumberFormat('#,##0.00').format(spent - limit)}'
                          : '${((1 - percentage) * 100).toStringAsFixed(0)}% remaining',
                      style: TextStyle(
                        color: isOverBudget
                            ? Colors.red
                            : Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
