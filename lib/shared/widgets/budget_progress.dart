import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

/// One budget's card: name, spend against limit, a bar, and how it is pacing.
///
/// Purely presentational. It used to work out the spend itself, filtering on a
/// deprecated `type` column that nothing writes, so every card read zero spent
/// and a full limit remaining no matter what the user had recorded. Consumption
/// now arrives already calculated by [BudgetEngine], the one place that does it.
class BudgetProgressCard extends ConsumerWidget {
  final BudgetProgress progress;
  final String currency;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BudgetProgressCard({
    super.key,
    required this.progress,
    required this.currency,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final fraction = progress.fraction.clamp(0.0, 1.0);
    final remaining = progress.remaining;
    final isOver = progress.isOver;

    final (accent, gradient) = switch (fraction) {
      < 0.5 => (AppColors.success, AppColors.successCardGradient),
      < 0.8 => (AppColors.warning, AppColors.warningCardGradient),
      _ => (AppColors.error, AppColors.errorCardGradient),
    };

    return Semantics(
      button: onTap != null,
      label:
          '${progress.budget.name}, '
          '${money(progress.spent)} of ${money(progress.limit)} used',
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        progress.budget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${money(progress.spent)} / ${money(progress.limit)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PaceBar(
                  fraction: fraction,
                  accent: accent,
                  progress: progress,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      isOver
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      size: 16,
                      color: isOver ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isOver
                            ? '${money(remaining.abs())} over'
                            : '${money(remaining)} left',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isOver ? AppColors.error : AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      _paceLabel(progress),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// What is still available per day, or how the window is going.
  static String _paceLabel(BudgetProgress progress) {
    final now = DateTime.now();
    if (progress.window.end.isBefore(now)) return 'Period ended';
    final perDay = progress.dailyAllowanceFrom(now);
    if (perDay == null) return progress.isOver ? 'Over' : '';
    final days = progress.window.end.difference(now).inDays;
    return '$days ${days == 1 ? 'day' : 'days'} left';
  }
}

/// The spend bar, with a tick showing how far through the period we are.
///
/// The tick is what turns a bar into a judgement: half a budget spent is fine
/// halfway through the month and a problem on the third.
class _PaceBar extends StatelessWidget {
  final double fraction;
  final Color accent;
  final BudgetProgress progress;

  const _PaceBar({
    required this.fraction,
    required this.accent,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final pace = progress.paceAt(DateTime.now()).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: 8,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 8,
                  color: AppColors.divider,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: fraction,
                    child: Container(color: accent),
                  ),
                ),
              ),
              if (pace > 0 && pace < 1)
                Positioned(
                  left: (width * pace).clamp(0.0, width - 2),
                  child: Container(
                    width: 2,
                    height: 8,
                    color: AppColors.textPrimary.withValues(alpha: 0.55),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
