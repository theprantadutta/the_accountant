import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/reports/providers/reports_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedTimeFrame = 0; // 0: Week, 1: Month, 2: Year
  int _selectedReportType = 0; // 0: Expenses, 1: Income, 2: Categories

  final List<String> _timeFrames = ['Week', 'Month', 'Year'];
  final List<String> _reportTypes = ['Expenses', 'Income', 'Categories'];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'food & dining':
      case 'food':
        return const Color(0xFF667eea);
      case 'transportation':
      case 'transport':
        return const Color(0xFF11998e);
      case 'shopping':
        return const Color(0xFFFF6B6B);
      case 'entertainment':
        return const Color(0xFFFFE66D);
      case 'bills':
      case 'utilities':
        return const Color(0xFF4ECDC4);
      case 'salary':
      case 'income':
        return const Color(0xFF98D8C8);
      case 'freelance':
        return const Color(0xFFDDA0DD);
      default:
        return const Color(0xFF999999);
    }
  }

  @override
  Widget build(BuildContext context) {
    final financialData = ref.watch(financialDataProvider);
    final transactionState = ref.watch(transactionProvider);
    final budgetState = ref.watch(budgetProvider);
    final categoryState = ref.watch(categoryProvider);
    final reportsState = ref.watch(reportsProvider);

    // Show loading state
    if (financialData.isLoading ||
        transactionState.isLoading ||
        budgetState.isLoading ||
        categoryState.isLoading ||
        reportsState.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
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

              // Time Frame Selector
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(-1, 0),
                child: _buildTimeFrameSelector(),
              ),

              const SizedBox(height: 24),

              // Report Type Selector
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(1, 0),
                child: _buildReportTypeSelector(),
              ),

              const SizedBox(height: 32),

              // Main Chart
              AnimationUtils.fadeTransition(
                animation: _fadeAnimation,
                child: _buildMainChart(),
              ),

              const SizedBox(height: 32),

              // Summary Cards
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.2,
                  endFraction: 0.6,
                ),
                begin: const Offset(0, 1),
                child: _buildSummaryCards(),
              ),

              const SizedBox(height: 24),

              // Category Breakdown
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.4,
                  endFraction: 0.8,
                ),
                begin: const Offset(0, 1),
                child: _buildCategoryBreakdown(),
              ),

              const SizedBox(height: 24),

              // Budget vs Actual
              AnimationUtils.slideTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.6,
                  endFraction: 1.0,
                ),
                begin: const Offset(0, 1),
                child: _buildBudgetComparison(),
              ),

              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    final premiumState = ref.watch(premiumProvider);
    final isPremium = premiumState.isPremium;

    return AppTheme.glassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: List.generate(_timeFrames.length, (index) {
            final isSelected = _selectedTimeFrame == index;
            // Month (1) and Year (2) are premium-only
            final isPremiumTimeframe = index > 0;
            final isLocked = isPremiumTimeframe && !isPremium;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isLocked) {
                    // Show upgrade prompt
                    _showAdvancedReportsUpgradeDialog();
                    return;
                  }
                  setState(() {
                    _selectedTimeFrame = index;
                  });
                  // Refresh reports data for new timeframe
                  ref.read(reportsProvider.notifier).refreshForTimeframe(index);
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.primaryGradient : null,
                    borderRadius: BorderRadius.circular(12),
                    color: isLocked ? Colors.white.withValues(alpha: 0.05) : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _timeFrames[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isLocked
                              ? Colors.white38
                              : (isSelected ? Colors.white : Colors.white70),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.lock,
                          size: 12,
                          color: Colors.white38,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showAdvancedReportsUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'Advanced Reports',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'Monthly and yearly reports are available with Premium.\n\n'
          'Upgrade to unlock detailed financial insights, trends, and export capabilities.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/premium');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _reportTypes.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedReportType == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedReportType = index;
              });
              HapticFeedback.lightImpact();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.secondaryGradient : null,
                color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                _reportTypes[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainChart() {
    return AppTheme.glassmorphicContainer(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_reportTypes[_selectedReportType]} Overview',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _timeFrames[_selectedTimeFrame],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedReportType == 2
                  ? _buildPieChart()
                  : _buildLineChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final reportsState = ref.watch(reportsProvider);
    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);
    final spots = reportsState.toLineChartSpots();
    final labels = reportsState.getDayLabels();
    final maxY = reportsState.getMaxY();

    // If no data, show empty state
    if (spots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              color: Colors.white.withValues(alpha: 0.5),
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'No spending data for this period',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Calculate appropriate interval for Y axis
    final yInterval = maxY > 0 ? (maxY / 5).ceilToDouble() : 1000.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  labels[index],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: yInterval,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value >= 1000) {
                  return Text(
                    '$currencySymbol${(value / 1000).toStringAsFixed(1)}k',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  );
                }
                return Text(
                  '$currencySymbol${value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 50,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: AppTheme.primaryGradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: const Color(0xFF667eea),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.3),
                  const Color(0xFF764ba2).withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final reportsState = ref.watch(reportsProvider);
    final sections = reportsState.toPieChartSections();

    // If no data, show empty state
    if (sections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              color: Colors.white.withValues(alpha: 0.5),
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'No category spending data',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch events
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: sections,
      ),
    );
  }

  Widget _buildSummaryCards() {
    final financialData = ref.watch(financialDataProvider);
    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);
    final netSavings =
        financialData.monthlyIncome - financialData.monthlyExpenses;
    final growthPercentage = financialData.monthlyGrowthPercentage;

    final summaryData = [
      {
        'title': 'Total Spent',
        'amount':
            '$currencySymbol${NumberFormat('#,##0.00').format(financialData.monthlyExpenses)}',
        'change':
            '${growthPercentage >= 0 ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%',
        'color': const Color(0xFFFF6B6B),
        'icon': Icons.trending_down,
        'isPositive': false,
      },
      {
        'title': 'Total Earned',
        'amount':
            '$currencySymbol${NumberFormat('#,##0.00').format(financialData.monthlyIncome)}',
        'change':
            '${growthPercentage >= 0 ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%',
        'color': const Color(0xFF4ECDC4),
        'icon': Icons.trending_up,
        'isPositive': true,
      },
      {
        'title': 'Net Savings',
        'amount': '$currencySymbol${NumberFormat('#,##0.00').format(netSavings)}',
        'change':
            '${growthPercentage >= 0 ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%',
        'color': const Color(0xFF45B7D1),
        'icon': Icons.savings,
        'isPositive': netSavings >= 0,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Summary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: summaryData.map((data) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppTheme.glassmorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              data['icon'] as IconData,
                              color: data['color'] as Color,
                              size: 20,
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (data['isPositive'] as bool)
                                      ? Colors.green.withValues(alpha: 0.2)
                                      : Colors.red.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data['change'] as String,
                                  style: TextStyle(
                                    color: (data['isPositive'] as bool)
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data['title'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['amount'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    final financialData = ref.watch(financialDataProvider);
    final currencySymbol = CurrencyInfo.getSymbol(ref.watch(defaultCurrencyProvider));
    final categorySpending = financialData.categorySpending;
    final totalSpending = categorySpending.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    // Convert to list and sort by amount
    final categories =
        categorySpending.entries.map((entry) {
          final percentage = totalSpending > 0
              ? (entry.value / totalSpending * 100).round()
              : 0;
          return {
            'name': entry.key,
            'amount': '$currencySymbol${NumberFormat('#,##0.00').format(entry.value)}',
            'percentage': percentage,
            'color': _getCategoryColor(entry.key),
          };
        }).toList()..sort(
          (a, b) => (b['percentage'] as int).compareTo(a['percentage'] as int),
        );

    // If no data, show empty state
    if (categories.isEmpty) {
      return AppTheme.glassmorphicContainer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Breakdown',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No spending data available',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
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
            const Text(
              'Category Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...categories.map((category) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: category['color'] as Color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  category['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category['amount'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (category['percentage'] as int) / 100,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        category['color'] as Color,
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

  Widget _buildBudgetComparison() {
    final reportsState = ref.watch(reportsProvider);
    final currencySymbol = CurrencyInfo.getSymbol(ref.watch(defaultCurrencyProvider));
    final budgets = reportsState.budgetComparison;

    // If no budgets, show empty state
    if (budgets.isEmpty) {
      return AppTheme.glassmorphicContainer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Budget vs Actual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No active budgets',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a budget to track your spending',
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
            const Text(
              'Budget vs Actual',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...budgets.map((budget) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            budget.budgetName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '$currencySymbol${budget.spent.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: budget.isOverBudget ? Colors.red : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / $currencySymbol${budget.budgetLimit.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final progressWidth = constraints.maxWidth *
                            (budget.percentage > 1.0 ? 1.0 : budget.percentage);
                        return Stack(
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
                              width: progressWidth,
                              height: 6,
                              decoration: BoxDecoration(
                                color: budget.isOverBudget
                                    ? Colors.red
                                    : budget.color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      budget.isOverBudget
                          ? 'Over budget by $currencySymbol${(budget.spent - budget.budgetLimit).toStringAsFixed(0)}'
                          : '${((1 - budget.percentage) * 100).toStringAsFixed(0)}% remaining',
                      style: TextStyle(
                        color: budget.isOverBudget
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
