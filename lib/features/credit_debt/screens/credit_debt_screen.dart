import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

class CreditDebtScreen extends ConsumerStatefulWidget {
  const CreditDebtScreen({super.key});

  @override
  ConsumerState<CreditDebtScreen> createState() => _CreditDebtScreenState();
}

class _CreditDebtScreenState extends ConsumerState<CreditDebtScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showOnlyUnpaid = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(creditDebtProvider);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Credit & Debt', style: AppTypography.headlineSmall),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Filter toggle
            IconButton(
              icon: Icon(
                _showOnlyUnpaid ? Icons.filter_alt : Icons.filter_alt_outlined,
                color: _showOnlyUnpaid
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _showOnlyUnpaid = !_showOnlyUnpaid;
                });
              },
              tooltip: _showOnlyUnpaid ? 'Show all' : 'Show unpaid only',
            ),
          ],
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
                    Icon(Icons.list_alt, size: 18),
                    const SizedBox(width: 8),
                    const Text('All'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Text('Credit (${state.creditTransactions.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text('Debt (${state.debtTransactions.length})'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Summary card
                  _buildSummaryCard(state),
                  // Transaction list
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTransactionList(
                          _showOnlyUnpaid
                              ? state.unpaidTransactions
                              : state.allTransactions,
                        ),
                        _buildTransactionList(
                          _showOnlyUnpaid
                              ? state.creditTransactions
                                    .where((t) => !t.isPaid)
                                    .toList()
                              : state.creditTransactions,
                          isCredit: true,
                        ),
                        _buildTransactionList(
                          _showOnlyUnpaid
                              ? state.debtTransactions
                                    .where((t) => !t.isPaid)
                                    .toList()
                              : state.debtTransactions,
                          isCredit: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryCard(CreditDebtState state) {
    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);
    final currencyFormat = AppNumberFormatter.currency(currencySymbol, ref.watch(numberFormatSettingProvider));
    final netBalance = state.netBalance;
    final isPositive = netBalance >= 0;
    final overdueCount = state.overdueCount;

    return Padding(
      padding: AppSpacing.paddingScreen.copyWith(bottom: 0),
      child: GlassCard(
        padding: AppSpacing.paddingLg,
        child: Column(
          children: [
            // Net balance
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Net Balance',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
            Text(
              currencyFormat.format(netBalance.abs() / 100.0),
              style: AppTypography.displaySmall.copyWith(
                color: isPositive ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isPositive ? 'Others owe you' : 'You owe others',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            // Overdue count badge
            if (overdueCount > 0) ...[
              AppSpacing.gapSm,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$overdueCount overdue',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            AppSpacing.gapLg,
            // Credit and Debt breakdown
            Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    'Credit (Lent)',
                    currencyFormat.format(state.totalCredit / 100.0),
                    currencyFormat.format(state.unpaidCredit / 100.0),
                    AppColors.success,
                    Icons.arrow_upward,
                  ),
                ),
                Container(width: 1, height: 60, color: AppColors.glassBorder),
                Expanded(
                  child: _buildStatColumn(
                    'Debt (Borrowed)',
                    currencyFormat.format(state.totalDebt / 100.0),
                    currencyFormat.format(state.unpaidDebt / 100.0),
                    AppColors.error,
                    Icons.arrow_downward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String total,
    String unpaid,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        AppSpacing.gapXs,
        Text(
          total,
          style: AppTypography.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Pending: $unpaid',
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildTransactionList(
    List<Transaction> transactions, {
    bool? isCredit,
  }) {
    if (transactions.isEmpty) {
      return _buildEmptyState(isCredit);
    }

    // Sort: overdue unpaid first, then unpaid, then paid
    final sorted = List<Transaction>.from(transactions);
    final notifier = ref.read(creditDebtProvider.notifier);
    sorted.sort((a, b) {
      final aOverdue = notifier.isOverdue(a);
      final bOverdue = notifier.isOverdue(b);
      if (aOverdue != bOverdue) return aOverdue ? -1 : 1;
      if (a.isPaid != b.isPaid) return a.isPaid ? 1 : -1;
      return b.date.compareTo(a.date);
    });

    return RefreshIndicator(
      onRefresh: () => ref.read(creditDebtProvider.notifier).refresh(),
      child: ListView.builder(
        padding: AppSpacing.paddingScreen,
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final transaction = sorted[index];
          final transactionIsCredit =
              isCredit ??
              (transaction.specialType == TransactionSpecialType.credit);
          return _buildTransactionCard(transaction, transactionIsCredit);
        },
      ),
    );
  }

  Widget _buildEmptyState(bool? isCredit) {
    String message;
    IconData icon;

    if (isCredit == null) {
      message = 'No credit or debt transactions';
      icon = Icons.account_balance_wallet_outlined;
    } else if (isCredit) {
      message = 'No credit transactions';
      icon = Icons.arrow_upward;
    } else {
      message = 'No debt transactions';
      icon = Icons.arrow_downward;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.textMuted),
          AppSpacing.gapLg,
          Text(
            message,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            _showOnlyUnpaid
                ? 'All transactions are settled!'
                : 'Add credit or debt transactions to track who owes you and who you owe',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, bool isCredit) {
    final df = ref.watch(dateFormatSettingProvider);
    final walletCurrency = ref.watch(
      walletCurrencyProvider(transaction.walletId),
    );
    final currencyFormat = AppNumberFormatter.currency(
      CurrencyInfo.getSymbol(walletCurrency),
      ref.watch(numberFormatSettingProvider),
    );
    final isPaid = transaction.isPaid;
    final isOverdue = ref
        .read(creditDebtProvider.notifier)
        .isOverdue(transaction);
    final paidAmount = transaction.paidAmount;
    final totalAmount = transaction.amount;
    final paymentProgress = totalAmount > 0
        ? (paidAmount / totalAmount).clamp(0.0, 1.0)
        : 0.0;
    final hasPartialPayment = paidAmount > 0 && !isPaid;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: AppSpacing.paddingMd,
        variant: isCredit ? GlassCardVariant.success : GlassCardVariant.error,
        child: Column(
          children: [
            Row(
              children: [
                // Type indicator
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isCredit ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.2),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    isCredit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isCredit ? AppColors.success : AppColors.error,
                    size: 22,
                  ),
                ),
                AppSpacing.gapHMd,
                // Transaction info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transaction.title.isNotEmpty
                                  ? transaction.title
                                  : (isCredit
                                        ? 'Money Lent'
                                        : 'Money Borrowed'),
                              style: AppTypography.titleSmall.copyWith(
                                decoration: isPaid
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isPaid
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPaid)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.2),
                                borderRadius: AppSpacing.borderRadiusSm,
                              ),
                              child: Text(
                                'Settled',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else if (isOverdue)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.2),
                                borderRadius: AppSpacing.borderRadiusSm,
                              ),
                              child: Text(
                                'Overdue',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      AppSpacing.gapXs,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: isOverdue
                                ? AppColors.error
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppDateFormatter.formatDate(transaction.date, df),
                            style: AppTypography.labelSmall.copyWith(
                              color: isOverdue
                                  ? AppColors.error
                                  : AppColors.textMuted,
                            ),
                          ),
                          if (transaction.notes != null &&
                              transaction.notes!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.notes,
                              size: 12,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                transaction.notes!,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormat.format(transaction.amount / 100.0),
                      style: AppTypography.titleMedium.copyWith(
                        color: isPaid
                            ? AppColors.textMuted
                            : (isCredit ? AppColors.success : AppColors.error),
                        fontWeight: FontWeight.bold,
                        decoration: isPaid ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      isCredit ? 'They owe you' : 'You owe',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Payment progress bar
            if (!isPaid || hasPartialPayment) ...[
              AppSpacing.gapMd,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: paymentProgress,
                            backgroundColor:
                                (isCredit ? AppColors.success : AppColors.error)
                                    .withValues(alpha: 0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCredit
                                  ? AppColors.success
                                  : AppColors.primaryAccent,
                            ),
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Paid: ${currencyFormat.format(paidAmount / 100.0)} / ${currencyFormat.format(totalAmount / 100.0)}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (!isPaid) ...[
              AppSpacing.gapMd,
              // Action buttons row
              Row(
                children: [
                  // Record Payment button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showRecordPaymentDialog(transaction, isCredit);
                      },
                      icon: const Icon(Icons.payments_outlined, size: 16),
                      label: const Text('Record Payment'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isCredit
                            ? AppColors.success
                            : AppColors.primaryAccent,
                        side: BorderSide(
                          color:
                              (isCredit
                                      ? AppColors.success
                                      : AppColors.primaryAccent)
                                  .withValues(alpha: 0.4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Mark as Settled button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        _markAsSettled(transaction, isCredit);
                      },
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: Text(isCredit ? 'Collected' : 'Settled'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCredit
                            ? AppColors.success
                            : AppColors.primaryAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showRecordPaymentDialog(Transaction transaction, bool isCredit) {
    final paymentController = TextEditingController();
    final remaining = transaction.amount - transaction.paidAmount;
    final walletCurrency = ref.read(
      walletCurrencyProvider(transaction.walletId),
    );
    final symbol = CurrencyInfo.getSymbol(walletCurrency);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primarySurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isCredit ? AppColors.success : AppColors.primaryAccent)
                          .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payments_outlined,
                  color: isCredit ? AppColors.success : AppColors.primaryAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Record Payment',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title.isNotEmpty
                    ? transaction.title
                    : (isCredit ? 'Money Lent' : 'Money Borrowed'),
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Remaining: $symbol${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(remaining / 100.0)}',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: paymentController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autofocus: true,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '$symbol ',
                  prefixStyle: TextStyle(color: AppColors.textSecondary),
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isCredit
                          ? AppColors.success
                          : AppColors.primaryAccent,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.glassWhite,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(paymentController.text);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter a valid amount'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                if (amount > remaining / 100.0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Amount exceeds remaining balance'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop();
                _recordPayment(transaction, amount, isCredit);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCredit
                    ? AppColors.success
                    : AppColors.primaryAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Record',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _recordPayment(
    Transaction transaction,
    double amount,
    bool isCredit,
  ) async {
    await ref
        .read(creditDebtProvider.notifier)
        .recordPayment(
          transactionId: transaction.id,
          paymentAmount: (amount * 100).round(), // dollars -> integer cents
        );
    if (mounted) {
      final walletCurrency = ref.read(
        walletCurrencyProvider(transaction.walletId),
      );
      final symbol = CurrencyInfo.getSymbol(walletCurrency);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment of $symbol${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(amount)} recorded',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _markAsSettled(Transaction transaction, bool isCredit) async {
    await ref.read(creditDebtProvider.notifier).markAsSettled(transaction.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCredit
                ? 'Marked as collected from "${transaction.title}"'
                : 'Marked "${transaction.title}" as paid',
          ),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () {
              ref
                  .read(creditDebtProvider.notifier)
                  .markAsPending(transaction.id);
            },
          ),
        ),
      );
    }
  }
}
