import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

class BudgetProgress extends ConsumerWidget {
  final String budgetName;
  final String categoryId;
  final double limit;
  final DateTime startDate;
  final DateTime endDate;
  final String currency;

  const BudgetProgress({
    super.key,
    required this.budgetName,
    required this.categoryId,
    required this.limit,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionProvider);
    final settings = ref.watch(settingsProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);

    // Calculate spent amount for this budget's category and date range
    final spent = transactionState.transactions
        .where(
          (transaction) =>
              transaction.categoryId == categoryId &&
              transaction.type == 'expense' &&
              transaction.date.isAfter(startDate) &&
              transaction.date.isBefore(endDate),
        )
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    final percentage = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final remaining = limit - spent;

    final decimalDigits = useDecimals ? 2 : 0;
    final formattedLimit = NumberFormat.currency(
      symbol: CurrencyInfo.getSymbol(settings.currency),
      decimalDigits: decimalDigits,
    ).format(useDecimals ? limit : limit.round());

    final formattedSpent = NumberFormat.currency(
      symbol: CurrencyInfo.getSymbol(settings.currency),
      decimalDigits: decimalDigits,
    ).format(useDecimals ? spent : spent.round());

    final formattedRemaining = NumberFormat.currency(
      symbol: CurrencyInfo.getSymbol(settings.currency),
      decimalDigits: decimalDigits,
    ).format(useDecimals ? remaining.abs() : remaining.abs().round());

    Color getProgressColor() {
      if (percentage < 0.5) return AppColors.success;
      if (percentage < 0.8) return AppColors.warning;
      return AppColors.error;
    }

    Gradient getCardGradient() {
      if (percentage < 0.5) return AppColors.successCardGradient;
      if (percentage < 0.8) return AppColors.warningCardGradient;
      return AppColors.errorCardGradient;
    }

    Color getBorderColor() {
      if (percentage < 0.5) return AppColors.success.withValues(alpha: 0.3);
      if (percentage < 0.8) return AppColors.warning.withValues(alpha: 0.3);
      return AppColors.error.withValues(alpha: 0.3);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: getCardGradient(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getBorderColor(), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budgetName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$formattedSpent / $formattedLimit',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.divider,
                color: getProgressColor(),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  remaining >= 0 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  size: 16,
                  color: remaining >= 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  remaining >= 0
                      ? '$formattedRemaining remaining'
                      : '$formattedRemaining over budget',
                  style: TextStyle(
                    color: remaining >= 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
