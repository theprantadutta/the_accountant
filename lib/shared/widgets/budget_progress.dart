import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

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
    final l10n = L10n.of(context);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final fraction = progress.fraction.clamp(0.0, 1.0);
    final remaining = progress.remaining;
    final isOver = progress.isOver;

    // The bar fill. The warning token is a dark amber meant for text, which
    // reads as brown on a bar, so "getting there" uses the brand's amber.
    final accent = switch (fraction) {
      < 0.5 => AppColors.success,
      < 0.8 => const Color(0xFFF59E0B),
      _ => AppColors.error,
    };

    return Semantics(
      button: onTap != null,
      label: l10n.budgetCardSemantics(
        progress.budget.name,
        money(progress.spent),
        money(progress.limit),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: SunriseRadius.cardAll,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: context.sunrise.surface,
            borderRadius: SunriseRadius.cardAll,
            boxShadow: context.sunrise.cardShadow,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Large sums on a narrow phone shrink rather than push
                    // the row past the card.
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * .5,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          '${money(progress.spent)} / ${money(progress.limit)}',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
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
                            ? l10n.budgetAmountOver(money(remaining.abs()))
                            : l10n.budgetAmountLeft(money(remaining)),
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
                      _paceLabel(progress, l10n),
                      style: TextStyle(
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
  static String _paceLabel(BudgetProgress progress, L10n l10n) {
    final now = DateTime.now();
    if (progress.window.end.isBefore(now)) return l10n.budgetPeriodEnded;
    final perDay = progress.dailyAllowanceFrom(now);
    if (perDay == null) return progress.isOver ? l10n.budgetPaceOver : '';
    final days = progress.window.end.difference(now).inDays;
    return l10n.budgetDaysLeft(days);
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
                  width: width,
                  color: context.sunrise.toggleOff,
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
