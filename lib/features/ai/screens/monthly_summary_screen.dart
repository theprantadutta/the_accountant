import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai/providers/monthly_summary_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/premium/widgets/premium_gate.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/shared/widgets/summary_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/core/utils/date_utils.dart';

/// Gated monthly summary that requires premium subscription
class MonthlySummaryScreenGated extends ConsumerWidget {
  final DateTime month;

  const MonthlySummaryScreenGated({super.key, required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumGate(
      featureId: PremiumFeatureIds.aiInsights,
      featureName: 'AI Insights',
      featureDescription:
          'Get AI-powered monthly financial summaries with spending analysis, trends, and personalized recommendations.',
      featureIcon: Icons.insights,
      child: MonthlySummaryScreen(month: month),
    );
  }
}

class MonthlySummaryScreen extends ConsumerStatefulWidget {
  final DateTime month;

  const MonthlySummaryScreen({super.key, required this.month});

  @override
  ConsumerState<MonthlySummaryScreen> createState() =>
      _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends ConsumerState<MonthlySummaryScreen> {
  @override
  void initState() {
    super.initState();
    _loadMonthlySummary();
  }

  void _loadMonthlySummary() {
    final transactions = ref.read(transactionProvider).transactions;
    ref
        .read(monthlySummaryProvider.notifier)
        .generateSummary(transactions: transactions, month: widget.month);
  }

  @override
  Widget build(BuildContext context) {
    final monthlySummaryState = ref.watch(monthlySummaryProvider);
    // Remove unused variable: final transactionState = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${CustomDateUtils.formatMonthYear(widget.month)} Summary',
        ), // Use CustomDateUtils
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadMonthlySummary();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Processing indicator
              if (monthlySummaryState.isLoading) ...[
                const ShimmerCard(height: 120),
                const SizedBox(height: 16),
                const ShimmerCard(height: 180),
                const SizedBox(height: 16),
                const ShimmerCard(height: 180),
              ],

              // Error message
              if (monthlySummaryState.errorMessage != null) ...[
                Card(
                  color: Colors.red.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      monthlySummaryState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Summary content
              if (monthlySummaryState.summary != null) ...[
                // Financial overview cards
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Income',
                        amount: monthlySummaryState.summary!.totalIncome,
                        currency: '\$',
                        icon: Icons.trending_up,
                        iconColor: Colors.green,
                        isPositive: true,
                        numberFormat: ref.watch(numberFormatSettingProvider),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: 'Expenses',
                        amount: monthlySummaryState.summary!.totalExpenses,
                        currency: '\$',
                        icon: Icons.trending_down,
                        iconColor: Colors.red,
                        isPositive: false,
                        numberFormat: ref.watch(numberFormatSettingProvider),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SummaryCard(
                  title: 'Net Savings',
                  amount: monthlySummaryState.summary!.netSavings,
                  currency: '\$',
                  icon: Icons.account_balance_wallet,
                  iconColor: monthlySummaryState.summary!.netSavings >= 0
                      ? Colors.green
                      : Colors.red,
                  isPositive: monthlySummaryState.summary!.netSavings >= 0,
                  numberFormat: ref.watch(numberFormatSettingProvider),
                ),
                const SizedBox(height: 16),

                // Spending trend
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spending Trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getTrendDescription(
                            monthlySummaryState.summary!.spendingTrend,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // AI Insights
                if (monthlySummaryState.aiInsights != null) ...[
                  Card(
                    color: Colors.blue.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Insights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            monthlySummaryState.aiInsights!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Top spending categories
                if (monthlySummaryState.summary!.topCategories.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top Spending Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: monthlySummaryState
                                .summary!
                                .topCategories
                                .length,
                            itemBuilder: (context, index) {
                              final category = monthlySummaryState
                                  .summary!
                                  .topCategories[index];
                              return ListTile(
                                title: Text(category.categoryId),
                                trailing: Text(
                                  '\$${category.amount.toStringAsFixed(2)}',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],

              const Spacer(),

              // Generate report button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: monthlySummaryState.isLoading
                      ? null
                      : _loadMonthlySummary,
                  child: const Text('Refresh Summary'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTrendDescription(String trend) {
    switch (trend) {
      case 'increased':
        return 'Your spending increased compared to last month';
      case 'decreased':
        return 'Your spending decreased compared to last month';
      case 'stable':
      default:
        return 'Your spending remained stable compared to last month';
    }
  }
}
