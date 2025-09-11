import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
// import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
// import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    // final transactionState = ref.watch(transactionProvider);
    // final budgetState = ref.watch(budgetProvider);

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
    return AppTheme.glassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: List.generate(_timeFrames.length, (index) {
            final isSelected = _selectedTimeFrame == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeFrame = index;
                  });
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.primaryGradient : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _timeFrames[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
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
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000,
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
                const style = TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                );
                String label;
                switch (value.toInt()) {
                  case 0:
                    label = 'Mon';
                    break;
                  case 1:
                    label = 'Tue';
                    break;
                  case 2:
                    label = 'Wed';
                    break;
                  case 3:
                    label = 'Thu';
                    break;
                  case 4:
                    label = 'Fri';
                    break;
                  case 5:
                    label = 'Sat';
                    break;
                  case 6:
                    label = 'Sun';
                    break;
                  default:
                    label = '';
                    break;
                }
                return Text(label, style: style);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1000,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '\$${(value / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 5000,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3000),
              FlSpot(1, 1500),
              FlSpot(2, 2800),
              FlSpot(3, 2200),
              FlSpot(4, 3500),
              FlSpot(5, 1800),
              FlSpot(6, 2600),
            ],
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
        sections: [
          PieChartSectionData(
            color: const Color(0xFF667eea),
            value: 35,
            title: 'Food\n35%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFF11998e),
            value: 25,
            title: 'Transport\n25%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFFFF6B6B),
            value: 20,
            title: 'Shopping\n20%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFF4ECDC4),
            value: 15,
            title: 'Bills\n15%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: const Color(0xFFFFE66D),
            value: 5,
            title: 'Other\n5%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final summaryData = [
      {
        'title': 'Total Spent',
        'amount': '\$3,245.00',
        'change': '-12.3%',
        'color': const Color(0xFFFF6B6B),
        'icon': Icons.trending_down,
        'isPositive': false,
      },
      {
        'title': 'Total Earned',
        'amount': '\$5,420.00',
        'change': '+8.7%',
        'color': const Color(0xFF4ECDC4),
        'icon': Icons.trending_up,
        'isPositive': true,
      },
      {
        'title': 'Net Savings',
        'amount': '\$2,175.00',
        'change': '+15.2%',
        'color': const Color(0xFF45B7D1),
        'icon': Icons.savings,
        'isPositive': true,
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
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
    final categories = [
      {
        'name': 'Food & Dining',
        'amount': '\$1,245.00',
        'percentage': 35,
        'color': const Color(0xFF667eea),
      },
      {
        'name': 'Transportation',
        'amount': '\$892.00',
        'percentage': 25,
        'color': const Color(0xFF11998e),
      },
      {
        'name': 'Shopping',
        'amount': '\$710.00',
        'percentage': 20,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'name': 'Bills & Utilities',
        'amount': '\$534.00',
        'percentage': 15,
        'color': const Color(0xFF4ECDC4),
      },
      {
        'name': 'Entertainment',
        'amount': '\$178.00',
        'percentage': 5,
        'color': const Color(0xFFFFE66D),
      },
    ];

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
                        Row(
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
                            Text(
                              category['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
    final budgets = [
      {
        'name': 'Food Budget',
        'budget': 1500.0,
        'spent': 1245.0,
        'color': const Color(0xFF667eea),
      },
      {
        'name': 'Transport Budget',
        'budget': 800.0,
        'spent': 892.0,
        'color': const Color(0xFF11998e),
      },
      {
        'name': 'Shopping Budget',
        'budget': 600.0,
        'spent': 710.0,
        'color': const Color(0xFFFF6B6B),
      },
    ];

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
              final percentage =
                  (budget['spent'] as double) / (budget['budget'] as double);
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
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${(budget['spent'] as double).toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isOverBudget ? Colors.red : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / \$${(budget['budget'] as double).toStringAsFixed(0)}',
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
                              0.7, // Approximate available width
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
                    const SizedBox(height: 4),
                    Text(
                      isOverBudget
                          ? 'Over budget by \$${((budget['spent'] as double) - (budget['budget'] as double)).toStringAsFixed(0)}'
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
