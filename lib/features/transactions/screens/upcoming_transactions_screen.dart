import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/providers/upcoming_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat_provider;
import 'package:the_accountant/shared/widgets/glass_card.dart';

class UpcomingTransactionsScreen extends ConsumerStatefulWidget {
  const UpcomingTransactionsScreen({super.key});

  @override
  ConsumerState<UpcomingTransactionsScreen> createState() =>
      _UpcomingTransactionsScreenState();
}

class _UpcomingTransactionsScreenState
    extends ConsumerState<UpcomingTransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(upcomingProvider);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Upcoming & Overdue', style: AppTypography.headlineSmall),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryAccent,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 8),
                    Text('Upcoming (${state.upcomingTransactions.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text('Overdue (${state.overdueTransactions.length})'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionList(
                    state.upcomingTransactions,
                    isOverdue: false,
                  ),
                  _buildTransactionList(
                    state.overdueTransactions,
                    isOverdue: true,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTransactionList(
    List<Transaction> transactions, {
    required bool isOverdue,
  }) {
    if (transactions.isEmpty) {
      return _buildEmptyState(isOverdue);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(upcomingProvider.notifier).refresh(),
      child: ListView.builder(
        padding: AppSpacing.paddingScreen,
        itemCount: transactions.length + 1, // +1 for summary card
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSummaryCard(transactions, isOverdue);
          }
          return _buildTransactionCard(transactions[index - 1], isOverdue);
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isOverdue) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOverdue ? Icons.check_circle_outline : Icons.event_available,
            size: 80,
            color: AppColors.textMuted,
          ),
          AppSpacing.gapLg,
          Text(
            isOverdue ? 'No overdue transactions' : 'No upcoming transactions',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            isOverdue
                ? 'All your payments are up to date!'
                : 'You have no pending payments scheduled',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<Transaction> transactions, bool isOverdue) {
    final total = transactions.fold(0.0, (sum, t) => sum + t.amount);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: AppSpacing.paddingLg,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: isOverdue
                    ? LinearGradient(
                        colors: [
                          AppColors.error,
                          AppColors.error.withValues(alpha: 0.7),
                        ],
                      )
                    : AppColors.primaryGradient,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                isOverdue ? Icons.warning_amber : Icons.schedule,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            AppSpacing.gapHLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOverdue ? 'Total Overdue' : 'Total Upcoming',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    currencyFormat.format(total),
                    style: AppTypography.headlineMedium.copyWith(
                      color: isOverdue
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${transactions.length} items',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, bool isOverdue) {
    final categoryState = ref.watch(cat_provider.categoryProvider);
    final category = categoryState.categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => cat_provider.Category(
        id: '',
        name: 'Uncategorized',
        colorCode: '#999999',
        type: 'expense',
        isDefault: false,
      ),
    );

    final dateFormat = DateFormat('MMM d, yyyy');
    final walletCurrency = ref.watch(
      walletCurrencyProvider(transaction.walletId),
    );
    final currencyFormat = NumberFormat.currency(
      symbol: CurrencyInfo.getSymbol(walletCurrency),
    );

    final daysUntilDue = transaction.date.difference(DateTime.now()).inDays;
    final isToday = daysUntilDue == 0;
    final isTomorrow = daysUntilDue == 1;

    String dueDateText;
    Color dueDateColor;

    if (isOverdue) {
      final daysOverdue = DateTime.now().difference(transaction.date).inDays;
      dueDateText = daysOverdue == 1
          ? '1 day overdue'
          : '$daysOverdue days overdue';
      dueDateColor = AppColors.error;
    } else if (isToday) {
      dueDateText = 'Due today';
      dueDateColor = AppColors.warning;
    } else if (isTomorrow) {
      dueDateText = 'Due tomorrow';
      dueDateColor = AppColors.info;
    } else {
      dueDateText = 'Due in $daysUntilDue days';
      dueDateColor = AppColors.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: AppSpacing.paddingMd,
        child: Column(
          children: [
            Row(
              children: [
                // Category icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _parseColor(
                      category.colorCode,
                    ).withValues(alpha: 0.2),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    _getCategoryIcon(category.name),
                    color: _parseColor(category.colorCode),
                    size: 22,
                  ),
                ),
                AppSpacing.gapHMd,
                // Transaction info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title.isNotEmpty
                            ? transaction.title
                            : category.name,
                        style: AppTypography.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppSpacing.gapXs,
                      Row(
                        children: [
                          Icon(
                            isOverdue ? Icons.error_outline : Icons.schedule,
                            size: 14,
                            color: dueDateColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dueDateText,
                            style: AppTypography.labelSmall.copyWith(
                              color: dueDateColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateFormat.format(transaction.date),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Amount
                Text(
                  currencyFormat.format(transaction.amount),
                  style: AppTypography.titleMedium.copyWith(
                    color: transaction.isIncome
                        ? AppColors.success
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AppSpacing.gapMd,
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _skipTransaction(transaction);
                    },
                    icon: const Icon(Icons.skip_next, size: 18),
                    label: const Text('Skip'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _markAsPaid(transaction);
                    },
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Mark as Paid'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _markAsPaid(Transaction transaction) async {
    await ref.read(upcomingProvider.notifier).markAsPaid(transaction.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marked "${transaction.title}" as paid'),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () {
              ref.read(upcomingProvider.notifier).markAsUnpaid(transaction.id);
            },
          ),
        ),
      );
    }
  }

  void _skipTransaction(Transaction transaction) async {
    await ref.read(upcomingProvider.notifier).skipTransaction(transaction.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Skipped "${transaction.title}"'),
          backgroundColor: AppColors.textMuted,
        ),
      );
    }
  }

  Color _parseColor(String colorCode) {
    try {
      final hex = colorCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFF667eea);
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('food') ||
        name.contains('restaurant') ||
        name.contains('dining')) {
      return Icons.restaurant;
    } else if (name.contains('transport') ||
        name.contains('car') ||
        name.contains('gas')) {
      return Icons.directions_car;
    } else if (name.contains('shopping') || name.contains('shop')) {
      return Icons.shopping_bag;
    } else if (name.contains('entertainment') || name.contains('movie')) {
      return Icons.movie;
    } else if (name.contains('health') || name.contains('medical')) {
      return Icons.local_hospital;
    } else if (name.contains('bill') || name.contains('utility')) {
      return Icons.receipt_long;
    } else if (name.contains('subscription')) {
      return Icons.subscriptions;
    } else if (name.contains('rent') || name.contains('home')) {
      return Icons.home;
    } else if (name.contains('salary') || name.contains('income')) {
      return Icons.attach_money;
    }
    return Icons.category;
  }
}
