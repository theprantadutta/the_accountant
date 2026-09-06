import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
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
        appBar: AppBar(title: Text(L10n.of(context).entityBudget)),
        body: Center(child: Text(L10n.of(context).budgetGone)),
      );
    }

    final engine = BudgetEngine(ref.watch(databaseProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text(budget.name),
        actions: [
          IconButton(
            tooltip: L10n.of(context).actionEdit,
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
              _Forecast(budget: budget, progress: progress, engine: engine),
              _CategoryCaps(
                budget: budget,
                progress: progress,
                engine: engine,
                onChanged: () => setState(() {}),
              ),
              AppSpacing.gapLg,
              _SpendGraph(
                budget: budget,
                progress: progress,
                engine: engine,
                offset: _offset,
              ),
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
          tooltip: L10n.of(context).budgetEarlier,
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
          tooltip: L10n.of(context).budgetLater,
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
          Text(money(progress.spent), style: AppTypography.displaySmall),
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
          Text(switch ((progress.isOver, perDay)) {
            (true, _) => '${money(progress.remaining.abs())} over the limit.',
            (false, final int p) when isCurrent =>
              '${money(progress.remaining)} left, about ${money(p)} a day.',
            _ => '${money(progress.remaining)} left.',
          }, style: AppTypography.bodyMedium),
          if (isCurrent && progress.isAheadOfPace(now)) ...[
            AppSpacing.gapSm,
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: AppColors.warning),
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
              Text(
                L10n.of(context).budgetWhereItWent,
                style: AppTypography.titleSmall,
              ),
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
              Text(
                L10n.of(context).budgetRecentPeriods,
                style: AppTypography.titleSmall,
              ),
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

/// Where this period is heading, when that is worth saying.
///
/// Silent unless the projection actually goes over: a forecast that agrees with
/// the bar is not information, and one shown every period stops being read.
class _Forecast extends ConsumerWidget {
  final BudgetView budget;
  final BudgetProgress progress;
  final BudgetEngine engine;

  const _Forecast({
    required this.budget,
    required this.progress,
    required this.engine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);

    return FutureBuilder<BudgetForecast?>(
      future: engine.forecast(budget, progress),
      builder: (context, snapshot) {
        final forecast = snapshot.data;
        if (forecast == null || !forecast.willExceed) {
          return const SizedBox.shrink();
        }

        String money(int cents) => cents.formatCurrency(
          currency,
          useDecimals: useDecimals,
          numberFormat: numberFormat,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            padding: AppSpacing.paddingLg,
            variant: GlassCardVariant.warning,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.query_stats, size: 20, color: AppColors.warning),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Heading for ${money(forecast.overBy)} over',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        forecast.scheduled > 0
                            ? 'At this rate, and counting '
                                  '${money(forecast.scheduled)} already '
                                  'scheduled before the period ends.'
                            : 'At this rate, by the end of the period.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A cap chosen in the dialog below.
typedef _CapChoice = ({String categoryId, int amount, bool isPercent});

/// Caps on individual categories inside the budget.
class _CategoryCaps extends ConsumerWidget {
  final BudgetView budget;
  final BudgetProgress progress;
  final BudgetEngine engine;
  final VoidCallback onChanged;

  const _CategoryCaps({
    required this.budget,
    required this.progress,
    required this.engine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final categories = ref.watch(categoryProvider).categories;

    String nameOf(String id) =>
        categories.where((c) => c.id == id).firstOrNull?.name ??
        L10n.of(context).entityCategory;

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    return FutureBuilder<List<CategoryLimitProgress>>(
      future: engine.categoryLimits(budget, progress),
      builder: (context, snapshot) {
        final limits = snapshot.data ?? const <CategoryLimitProgress>[];

        return GlassCard(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      L10n.of(context).budgetCaps,
                      style: AppTypography.titleSmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _addCap(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(L10n.of(context).actionAdd),
                  ),
                ],
              ),
              if (limits.isEmpty)
                Text(
                  'A budget says whether the period is overspent. A cap says '
                  'where: a food budget on track overall can still be mostly '
                  'takeaway.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                )
              else
                for (final limit in limits)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: InkWell(
                      onLongPress: () => _removeCap(ref, limit),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nameOf(limit.categoryId),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                              Text(
                                '${money(limit.spent)} / ${money(limit.limit)}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: limit.isOver
                                      ? AppColors.error
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: limit.fraction.clamp(0.0, 1.0),
                              minHeight: 4,
                              backgroundColor: AppColors.divider,
                              color: limit.isOver
                                  ? AppColors.error
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeCap(WidgetRef ref, CategoryLimitProgress limit) async {
    await ref.read(databaseProvider).removeCategoryLimit(limit.limitId);
    onChanged();
  }

  Future<void> _addCap(BuildContext context, WidgetRef ref) async {
    final categories = ref.read(categoryProvider).categories;
    // Only categories the budget actually watches; capping one it ignores
    // would draw a bar that can never move.
    final choices = budget.categoryIds.isEmpty
        ? categories
              .where((c) => (c.type == 'income') == budget.isIncome)
              .toList()
        : categories.where((c) => budget.categoryIds.contains(c.id)).toList();

    if (choices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).budgetNoCategoriesToCap)),
      );
      return;
    }

    final result = await showDialog<_CapChoice>(
      context: context,
      builder: (context) => _AddCapDialog(
        choices: [for (final c in choices) (id: c.id, name: c.name)],
      ),
    );
    if (result == null) return;

    await ref
        .read(databaseProvider)
        .setCategoryLimit(
          budgetId: budget.id,
          categoryId: result.categoryId,
          amount: result.amount,
          isPercent: result.isPercent,
        );
    onChanged();
  }
}

class _AddCapDialog extends StatefulWidget {
  final List<({String id, String name})> choices;

  const _AddCapDialog({required this.choices});

  @override
  State<_AddCapDialog> createState() => _AddCapDialogState();
}

class _AddCapDialogState extends State<_AddCapDialog> {
  late String _categoryId;
  final _amountController = TextEditingController();
  bool _isPercent = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.choices.first.id;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.of(context).budgetCapACategory),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _categoryId,
            decoration: InputDecoration(
              labelText: L10n.of(context).entityCategory,
            ),
            items: [
              for (final c in widget.choices)
                DropdownMenuItem(value: c.id, child: Text(c.name)),
            ],
            onChanged: (v) => setState(() => _categoryId = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _isPercent ? 'Percent of budget' : 'Amount',
              suffixText: _isPercent ? '%' : null,
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isPercent,
            onChanged: (v) => setState(() => _isPercent = v),
            title: Text(L10n.of(context).budgetAsShare),
            subtitle: Text(L10n.of(context).budgetAsShareHint),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(L10n.of(context).actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final text = _amountController.text.trim();
            final amount = _isPercent
                // Hundredths of a percent, so 25.5 becomes 2550.
                ? ((double.tryParse(text) ?? 0) * 100).round()
                : text.toCentsOrNull();
            if (amount == null || amount <= 0) return;
            Navigator.pop(context, (
              categoryId: _categoryId,
              amount: amount,
              isPercent: _isPercent,
            ));
          },
          child: Text(L10n.of(context).actionSet),
        ),
      ],
    );
  }
}

/// Spending across the period, with the previous one faded behind it.
///
/// Cumulative rather than per-day, because the question a budget raises is
/// whether the total will hold, and a bar chart of individual days answers a
/// different one. The straight line is where the limit would be reached if the
/// period were spent evenly, so the gap between the two lines is the whole
/// story: above it and the budget is running hot.
class _SpendGraph extends ConsumerWidget {
  final BudgetView budget;
  final BudgetProgress progress;
  final BudgetEngine engine;
  final int offset;

  const _SpendGraph({
    required this.budget,
    required this.progress,
    required this.engine,
    required this.offset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<List<int>>>(
      future: _series(),
      builder: (context, snapshot) {
        final series = snapshot.data;
        if (series == null || series.first.length < 2) {
          return const SizedBox.shrink();
        }

        final current = series[0];
        final previous = series[1];
        final days = current.length;

        // The scale has to cover the limit as well as the spending, or a budget
        // that stayed well under would draw a line that looks alarming.
        final peak = [
          progress.limit,
          ...current,
          ...previous,
        ].fold<int>(1, (a, b) => b > a ? b : a);

        return GlassCard(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.of(context).budgetAcrossPeriod,
                style: AppTypography.titleSmall,
              ),
              AppSpacing.gapMd,
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: peak.toDouble(),
                    minX: 0,
                    maxX: (days - 1).toDouble(),
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      // Even-pace reference: where the limit lands if spread out.
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 0),
                          FlSpot(
                            (days - 1).toDouble(),
                            progress.limit.toDouble(),
                          ),
                        ],
                        isCurved: false,
                        barWidth: 1,
                        dotData: const FlDotData(show: false),
                        color: AppColors.textMuted.withValues(alpha: 0.35),
                        dashArray: const [4, 4],
                      ),
                      if (previous.isNotEmpty)
                        LineChartBarData(
                          spots: [
                            for (
                              var i = 0;
                              i < previous.length && i < days;
                              i++
                            )
                              FlSpot(i.toDouble(), previous[i].toDouble()),
                          ],
                          isCurved: true,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          color: AppColors.textMuted.withValues(alpha: 0.4),
                        ),
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < days; i++)
                            FlSpot(i.toDouble(), current[i].toDouble()),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        color: progress.isOver
                            ? AppColors.error
                            : AppColors.success,
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              (progress.isOver
                                      ? AppColors.error
                                      : AppColors.success)
                                  .withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapSm,
              Row(
                children: [
                  _Key(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    label: L10n.of(context).budgetPreviousPeriod,
                  ),
                  const SizedBox(width: 16),
                  _Key(
                    color: AppColors.textMuted.withValues(alpha: 0.35),
                    label: L10n.of(context).budgetEvenPace,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// This period's running total, and the one before it for comparison.
  Future<List<List<int>>> _series() async {
    final current = await engine.dailyTotals(
      budget,
      progress.window,
      cumulative: true,
    );

    final earlier = await engine.progressFor(budget, offset: offset - 1);
    // Stepping back stops at the budget's start, so an unchanged window means
    // there is no previous period to draw.
    if (earlier.window.start == progress.window.start) {
      return [current, const []];
    }

    final previous = await engine.dailyTotals(
      budget,
      earlier.window,
      cumulative: true,
    );
    return [current, previous];
  }
}

class _Key extends StatelessWidget {
  final Color color;
  final String label;

  const _Key({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 12, height: 2, color: color),
      const SizedBox(width: 6),
      Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
      ),
    ],
  );
}
