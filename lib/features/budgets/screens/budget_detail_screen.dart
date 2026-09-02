import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/budgets/screens/add_budget_screen.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

/// One budget in detail: this period, where the money went, and how it compares
/// with the periods before it.
///
/// The period arrows are the point. A budget is only meaningful against a
/// window, and until now nothing in the app could show any window but the
/// current one, so there was no way to ask whether this month is unusual.
class BudgetDetailScreen extends ConsumerStatefulWidget {
  final String budgetId;

  const BudgetDetailScreen({super.key, required this.budgetId});

  @override
  ConsumerState<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends ConsumerState<BudgetDetailScreen> {
  /// How many periods back from the current one we are looking. Never above 0.
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final budget = ref
        .watch(budgetProvider)
        .budgets
        .where((b) => b.id == widget.budgetId)
        .firstOrNull;

    if (budget == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Budget')),
        body: const Center(child: Text('This budget no longer exists.')),
      );
    }

    final engine = BudgetEngine(ref.watch(databaseProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text(budget.name),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddBudgetScreen(budget: budget),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<BudgetProgress>(
        future: engine.progressFor(budget, offset: _offset),
        builder: (context, snapshot) {
          final progress = snapshot.data;
          if (progress == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: AppSpacing.paddingLg,
            children: [
              _PeriodNavigator(
                budget: budget,
                progress: progress,
                offset: _offset,
                onChanged: (next) => setState(() => _offset = next),
              ),
              AppSpacing.gapLg,
              _Headline(progress: progress),
              AppSpacing.gapLg,
              _CategoryBreakdown(
                budget: budget,
                progress: progress,
                engine: engine,
              ),
              AppSpacing.gapLg,
              _PastPeriods(budget: budget, engine: engine),
              AppSpacing.gapXxl,
            ],
          );
        },
      ),
    );
  }
}

/// Arrows to step through periods, with the dates of the one being shown.
class _PeriodNavigator extends ConsumerWidget {
  final BudgetView budget;
  final BudgetProgress progress;
  final int offset;
  final ValueChanged<int> onChanged;

  const _PeriodNavigator({
    required this.budget,
    required this.progress,
    required this.offset,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = ref.watch(dateFormatSettingProvider);
    final repeating = budget.period != BudgetPeriod.custom;

    // Stepping back below the budget's own start returns the same window, so
    // there is nothing further to see.
    final atStart =
        !repeating || !progress.window.start.isAfter(budget.startDate);

    return Row(
      children: [
        IconButton(
          tooltip: 'Earlier',
          onPressed: atStart ? null : () => onChanged(offset - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                offset == 0 ? 'This period' : '${-offset} periods ago',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '${AppDateFormatter.formatShortDate(progress.window.start, format)}'
                ' to '
                '${AppDateFormatter.formatShortDate(progress.window.end.subtract(const Duration(days: 1)), format)}',
                style: AppTypography.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Later',
          onPressed: offset >= 0 ? null : () => onChanged(offset + 1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

/// Spent against limit, with the pace read out in words.
class _Headline extends ConsumerWidget {
  final BudgetProgress progress;

  const _Headline({required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final now = DateTime.now();
    final isCurrent = progress.window.contains(now);
    final perDay = isCurrent ? progress.dailyAllowanceFrom(now) : null;

    return GlassCard(
      padding: AppSpacing.paddingLg,
      variant: progress.isOver
          ? GlassCardVariant.error
          : GlassCardVariant.standard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            money(progress.spent),
            style: AppTypography.displaySmall,
          ),
          Text(
            'of ${money(progress.limit)}'
            '${progress.carriedIn > 0 ? ' including ${money(progress.carriedIn)} carried over' : ''}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapMd,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.fraction.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.divider,
              color: progress.isOver ? AppColors.error : AppColors.success,
            ),
          ),
          AppSpacing.gapMd,
          Text(
            switch ((progress.isOver, perDay)) {
              (true, _) =>
                '${money(progress.remaining.abs())} over the limit.',
              (false, final int p) when isCurrent =>
                '${money(progress.remaining)} left, about ${money(p)} a day.',
              _ => '${money(progress.remaining)} left.',
            },
            style: AppTypography.bodyMedium,
          ),
          if (isCurrent && progress.isAheadOfPace(now)) ...[
            AppSpacing.gapSm,
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 16,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Spending faster than the period is passing.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Where the money went, largest first.
class _CategoryBreakdown extends ConsumerWidget {
  final BudgetView budget;
  final BudgetProgress progress;
  final BudgetEngine engine;

  const _CategoryBreakdown({
    required this.budget,
    required this.progress,
    required this.engine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final categories = ref.watch(categoryProvider).categories;

    return FutureBuilder<Map<String, int>>(
      future: engine.byCategory(budget, progress.window),
      builder: (context, snapshot) {
        final totals = snapshot.data;
        if (totals == null) return const SizedBox.shrink();
        if (totals.isEmpty) {
          return GlassCard(
            padding: AppSpacing.paddingLg,
            child: Text(
              'Nothing recorded in this period.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          );
        }

        final biggest = totals.values.first;

        return GlassCard(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Where it went', style: AppTypography.titleSmall),
              AppSpacing.gapMd,
              for (final entry in totals.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              categories
                                      .where((c) => c.id == entry.key)
                                      .firstOrNull
                                      ?.name ??
                                  'Uncategorised',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                          Text(
                            entry.value.formatCurrency(
                              currency,
                              useDecimals: useDecimals,
                              numberFormat: numberFormat,
                            ),
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: biggest <= 0 ? 0 : entry.value / biggest,
                          minHeight: 4,
                          backgroundColor: AppColors.divider,
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The last few closed periods, so this one can be judged against them.
class _PastPeriods extends ConsumerWidget {
  final BudgetView budget;
  final BudgetEngine engine;

  const _PastPeriods({required this.budget, required this.engine});

  static const int _count = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (budget.period == BudgetPeriod.custom) return const SizedBox.shrink();

    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final format = ref.watch(dateFormatSettingProvider);

    return FutureBuilder<List<BudgetProgress>>(
      future: _history(),
      builder: (context, snapshot) {
        final history = snapshot.data;
        if (history == null || history.length < 2) {
          return const SizedBox.shrink();
        }

        final average =
            history.map((p) => p.spent).reduce((a, b) => a + b) ~/
            history.length;

        return GlassCard(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent periods', style: AppTypography.titleSmall),
              AppSpacing.gapSm,
              Text(
                'Averaging ${average.formatCurrency(currency, useDecimals: useDecimals, numberFormat: numberFormat)} a period.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.gapMd,
              for (final p in history.reversed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppDateFormatter.formatShortDate(
                            p.window.start,
                            format,
                          ),
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      Text(
                        p.spent.formatCurrency(
                          currency,
                          useDecimals: useDecimals,
                          numberFormat: numberFormat,
                        ),
                        style: AppTypography.bodySmall.copyWith(
                          color: p.isOver
                              ? AppColors.error
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<List<BudgetProgress>> _history() async {
    final out = <BudgetProgress>[];
    for (var i = 0; i < _count; i++) {
      final p = await engine.progressFor(budget, offset: -i);
      // Once stepping back stops moving we have reached the budget's start.
      if (out.isNotEmpty && p.window.start == out.last.window.start) break;
      out.add(p);
    }
    return out;
  }
}
