import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/summary_card.dart';
import 'package:the_accountant/features/dashboard/widgets/advanced_chart.dart';
import 'package:the_accountant/shared/widgets/budget_progress.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FinancialOverview extends ConsumerWidget {
  const FinancialOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionProvider);
    final budgetState = ref.watch(budgetProvider);

    // Calculate financial metrics
    final totalIncome = transactionState.transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpenses = transactionState.transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    final netBalance = totalIncome - totalExpenses;

    // Get recent transactions
    final recentTransactions = transactionState.transactions.take(5).toList();

    // Get active budgets
    final now = DateTime.now();
    final activeBudgets = budgetState.budgets
        .where(
          (budget) =>
              budget.startDate.isBefore(now) && budget.endDate.isAfter(now),
        )
        .toList();

    // Prepare chart data
    final expenseData = _prepareExpenseData(transactionState);
    final incomeData = _prepareIncomeData(transactionState);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Balance',
                    amount: netBalance,
                    currency: 'USD',
                    icon: Icons.account_balance_wallet,
                    iconColor: Colors.blue,
                    isPositive: netBalance >= 0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'This Month',
                    amount: totalExpenses,
                    currency: 'USD',
                    icon: Icons.trending_down,
                    iconColor: Colors.red,
                    isPositive: false,
                  ),
                ),
              ],
            ),
          ),

          // Income vs Expenses card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income vs Expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _FinancialItem(
                          title: 'Income',
                          amount: totalIncome,
                          color: Colors.green,
                          icon: Icons.trending_up,
                        ),
                        _FinancialItem(
                          title: 'Expenses',
                          amount: totalExpenses,
                          color: Colors.red,
                          icon: Icons.trending_down,
                        ),
                        _FinancialItem(
                          title: 'Net',
                          amount: netBalance,
                          color: netBalance >= 0 ? Colors.green : Colors.red,
                          icon: netBalance >= 0 ? Icons.add : Icons.remove,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expense distribution chart
          AdvancedChart(
            data: expenseData,
            title: 'Expense Distribution',
            chartType: ChartType.pie,
          ),

          // Income sources chart
          AdvancedChart(
            data: incomeData,
            title: 'Income Sources',
            chartType: ChartType.bar,
          ),

          // Recent transactions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (recentTransactions.isEmpty)
                  const Center(child: Text('No transactions yet'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = recentTransactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: transaction.type == 'income'
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              transaction.type == 'income'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(transaction.category),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy').format(transaction.date),
                          ),
                          trailing: Text(
                            '${transaction.type == 'income' ? '+' : '-'}'
                            '${NumberFormat.currency(symbol: '\$').format(transaction.amount)}',
                            style: TextStyle(
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Active budgets
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Budgets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (activeBudgets.isEmpty)
                  const Center(child: Text('No active budgets'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeBudgets.length,
                    itemBuilder: (context, index) {
                      final budget = activeBudgets[index];
                      // Note: In a real implementation, we would calculate the actual spent amount
                      // from transactions. For now, we're using a simulated value.
                      // final spent = budget.limit * 0.65; // This line was causing the unused variable warning
                      return BudgetProgress(
                        budgetName: budget.name,
                        categoryId: '', // This would be the actual category ID
                        limit: budget.limit,
                        startDate: budget.startDate,
                        endDate: budget.endDate,
                        currency: 'USD',
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _prepareExpenseData(
    TransactionState transactionState,
  ) {
    // For demo purposes, we'll use predefined categories
    final categories = [
      {'name': 'Food & Dining', 'color': Colors.red, 'value': 35.0},
      {'name': 'Transportation', 'color': Colors.blue, 'value': 25.0},
      {'name': 'Entertainment', 'color': Colors.green, 'value': 20.0},
      {'name': 'Shopping', 'color': Colors.orange, 'value': 15.0},
      {'name': 'Utilities', 'color': Colors.purple, 'value': 5.0},
    ];

    return categories.map((category) {
      final percentage = category['value'] as double;
      return {
        'label': category['name'],
        'color': category['color'],
        'value': percentage,
        'percentage': percentage.toInt(),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _prepareIncomeData(
    TransactionState transactionState,
  ) {
    // For demo purposes, we'll use predefined income sources
    final sources = [
      {'name': 'Salary', 'color': Colors.green, 'value': 50.0},
      {'name': 'Freelance', 'color': Colors.blue, 'value': 30.0},
      {'name': 'Investments', 'color': Colors.purple, 'value': 15.0},
      {'name': 'Other', 'color': Colors.grey, 'value': 5.0},
    ];

    return sources.map((source) {
      final value = source['value'] as double;
      return {
        'label': source['name'],
        'color': source['color'],
        'value': value,
        'percentage': value.toInt(),
      };
    }).toList();
  }
}

class _FinancialItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _FinancialItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          NumberFormat.currency(symbol: '\$').format(amount),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
