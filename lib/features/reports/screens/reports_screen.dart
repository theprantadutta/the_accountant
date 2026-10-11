import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/ai/screens/monthly_summary_screen.dart';
import 'package:the_accountant/features/ai_assistant/screens/ai_assistant_screen.dart'
    show AIAssistantScreenGated;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/reports/providers/heatmap_provider.dart';
import 'package:the_accountant/features/reports/providers/reports_provider.dart';
import 'package:the_accountant/features/reports/widgets/spending_heatmap.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Stats: period, chart, categories, summary, daily rhythm, budgets.
///
/// Week, month and year are all free. The mock locks month and year, but
/// they were made free on purpose (charging people to see their own history)
/// and this redesign changes no behaviour.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

enum _Mode { spending, income, categories }

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _timeFrame = 0; // 0: Week, 1: Month, 2: Year
  _Mode _mode = _Mode.spending;

  /// Bumped on every period change so the bars animate in again.
  int _chartGeneration = 0;

  void _push(Widget screen) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final loading =
        ref.watch(financialDataProvider).isLoading ||
        ref.watch(transactionProvider).isLoading ||
        ref.watch(budgetProvider).isLoading ||
        ref.watch(categoryProvider).isLoading ||
        ref.watch(reportsProvider).isLoading;

    final segmented = SunriseSegmented<int>(
      height: 46,
      value: _timeFrame,
      options: [
        SegmentOption(0, l10n.statsWeek),
        SegmentOption(1, l10n.statsMonth),
        SegmentOption(2, l10n.statsYear),
      ],
      onChanged: (v) {
        setState(() {
          _timeFrame = v;
          _chartGeneration++;
        });
        ref.read(reportsProvider.notifier).refreshForTimeframe(v);
      },
    );

    return SunriseTabPage(
      child: RefreshIndicator(
        color: c.accent,
        backgroundColor: c.surface,
        onRefresh: () =>
            ref.read(reportsProvider.notifier).refreshForTimeframe(_timeFrame),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: SunriseSpace.tabBarClearance),
          children: [
            LargeTitleHeader(title: l10n.statsTitle),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SunriseSpace.screenX,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  segmented,
                  const SizedBox(height: SunriseSpace.sectionTight),
                  if (loading) ...const [
                    ShimmerCard(height: 300),
                    SizedBox(height: 16),
                    ShimmerCard(height: 120),
                    SizedBox(height: 16),
                    ShimmerCard(height: 120),
                  ] else ...[
                    _modeChips(l10n),
                    const SizedBox(height: SunriseSpace.gap),
                    _mode == _Mode.categories
                        ? const _PieCard()
                        : _ChartCard(
                            key: ValueKey(_chartGeneration),
                            income: _mode == _Mode.income,
                          ),
                    const SizedBox(height: SunriseSpace.gap),
                    _InsightsCard(
                      onInsights: () {
                        final now = DateTime.now();
                        _push(
                          MonthlySummaryScreenGated(
                            month: DateTime(now.year, now.month),
                          ),
                        );
                      },
                      onCoach: () => _push(const AIAssistantScreenGated()),
                    ),
                    const SizedBox(height: 26),
                    const _CategoryGrid(),
                    const SizedBox(height: 26),
                    const _SummaryRow(),
                    const SizedBox(height: 26),
                    const _HeatmapCard(),
                    const SizedBox(height: 26),
                    const _BudgetComparison(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeChips(L10n l10n) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final (mode, label) in [
          (_Mode.spending, l10n.statsSpending),
          (_Mode.income, l10n.statsIncome),
          (_Mode.categories, l10n.statsCategories),
        ]) ...[
          SunriseChip(
            label: label,
            selected: _mode == mode,
            onTap: () => setState(() {
              _mode = mode;
              _chartGeneration++;
            }),
          ),
          const SizedBox(width: 8),
        ],
      ],
    ),
  );
}

String _money(WidgetRef ref, double major, {bool decimals = false}) {
  final cents = (major * 100).round();
  final text = cents.abs().formatCurrency(
    ref.watch(defaultCurrencyProvider),
    useDecimals: decimals,
    numberFormat: ref.watch(numberFormatSettingProvider),
  );
  return cents < 0 ? '−$text' : text;
}

/// Spent vs earned headline over the period's bars.
class _ChartCard extends ConsumerWidget {
  const _ChartCard({super.key, required this.income});

  final bool income;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final reports = ref.watch(reportsProvider);
    final days = reports.dailySpending;
    final values = days.map((d) => d.amount).toList();
    final peak = values.isEmpty ? 0.0 : values.reduce((a, b) => a > b ? a : b);
    final peakIndex = values.indexOf(peak);

    return SunriseCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Headline(
                  label: l10n.statsSpent,
                  value: _money(ref, reports.totalSpending),
                  color: c.ink,
                  emphasised: !income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Headline(
                  label: l10n.statsEarned,
                  value: _money(ref, reports.totalIncome),
                  color: c.positive,
                  end: true,
                  emphasised: income,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 190,
            child: days.isEmpty || peak <= 0
                ? Center(
                    child: Text(
                      l10n.reportNoSpendingDataForThis,
                      style: SunriseType.label.copyWith(color: c.subtle),
                    ),
                  )
                : _Bars(
                    values: values,
                    labels: days.map((d) => d.dayLabel).toList(),
                    peakIndex: peakIndex,
                    max: peak,
                  ),
          ),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({
    required this.label,
    required this.value,
    required this.color,
    this.end = false,
    this.emphasised = true,
  });

  final String label;
  final String value;
  final Color color;
  final bool end;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: SunriseType.label.copyWith(color: c.muted, fontSize: 14)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: end
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Text(
            value,
            maxLines: 1,
            style: SunriseType.heroTitle.copyWith(
              color: emphasised ? color : color.withValues(alpha: .55),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

/// Rounded bars: the peak in the gradient, the latest period softly
/// gradient, the rest idle. They grow in, 30ms apart.
class _Bars extends StatelessWidget {
  const _Bars({
    required this.values,
    required this.labels,
    required this.peakIndex,
    required this.max,
  });

  final List<double> values;
  final List<String> labels;
  final int peakIndex;
  final double max;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final n = values.length;
    final gap = n > 8 ? 6.0 : 10.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < n; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: values[i] / max),
                      duration:
                          SunriseMotion.chart + SunriseMotion.chartStagger * i,
                      curve: Interval(
                        (i * 30) / (400 + i * 30),
                        1,
                        curve: Curves.easeOutCubic,
                      ),
                      builder: (_, f, _) => FractionallySizedBox(
                        heightFactor: (f).clamp(.04, 1),
                        child: Tooltip(
                          message: labels[i],
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: i == peakIndex || i == n - 1
                                  ? null
                                  : c.barIdle,
                              gradient: i == peakIndex
                                  ? c.barHighlight
                                  : i == n - 1
                                  ? LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        c.gradientStart.withValues(alpha: .55),
                                        c.gradientEnd.withValues(alpha: .55),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _short(labels[i], n),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: SunriseType.caption.copyWith(
                    color: i == peakIndex ? c.ink : c.subtle,
                    fontWeight: i == peakIndex
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: n > 8 ? 10 : 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// One letter for weekdays, the label as-is otherwise.
  static String _short(String label, int n) =>
      n == 7 && label.isNotEmpty ? label.characters.first : label;
}

/// Category share as a donut, for the Categories mode.
class _PieCard extends ConsumerWidget {
  const _PieCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final data = ref.watch(reportsProvider).categorySpending;

    return SunriseCard(
      padding: const EdgeInsets.all(18),
      child: data.isEmpty
          ? SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  l10n.reportNoCategorySpendingData,
                  style: SunriseType.label.copyWith(color: c.subtle),
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 58,
                      borderData: FlBorderData(show: false),
                      sections: [
                        for (final d in data)
                          PieChartSectionData(
                            color: d.color,
                            value: d.percentage,
                            radius: 30,
                            showTitle: false,
                          ),
                      ],
                    ),
                    duration: SunriseMotion.chart,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final d in data)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: d.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${d.categoryName} ${d.percentage.toStringAsFixed(0)}%',
                            style: SunriseType.label.copyWith(color: c.body),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}

/// Spending insights and the AI coach.
class _InsightsCard extends StatelessWidget {
  const _InsightsCard({required this.onInsights, required this.onCoach});

  final VoidCallback onInsights;
  final VoidCallback onCoach;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SettingsGroup(
      children: [
        SettingsRow(
          icon: Symbols.insights_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.reportSpendingInsights,
          subtitle: l10n.statsInsightsSub,
          onTap: onInsights,
        ),
        SettingsRow(
          icon: Symbols.auto_awesome_rounded,
          iconColor: const Color(0xFF7C3AED),
          iconBackground: c.tintViolet,
          title: l10n.statsAskCoach,
          onTap: onCoach,
        ),
      ],
    );
  }
}

/// Categories as a two-column grid of cards.
class _CategoryGrid extends ConsumerWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final data = ref.watch(reportsProvider).categorySpending;
    final categories = ref.watch(categoryProvider).categories;

    IconData iconFor(String id) {
      for (final cat in categories) {
        if (cat.id == id) return IconRegistry.getIcon(cat.iconName);
      }
      return Symbols.category_rounded;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l10n.statsCategories),
        if (data.isEmpty)
          SunriseCard(
            child: EmptyState(
              compact: true,
              icon: Symbols.donut_small_rounded,
              title: l10n.reportNoSpendingDataAvailable,
            ),
          )
        else
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - SunriseSpace.gap) / 2;
              return Wrap(
                spacing: SunriseSpace.gap,
                runSpacing: SunriseSpace.gap,
                children: [
                  for (final d in data)
                    SizedBox(
                      width: w,
                      child: SunriseCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconTile(
                                  icon: iconFor(d.categoryId),
                                  color: d.color,
                                  size: 38,
                                ),
                                const Spacer(),
                                Text(
                                  '${d.percentage.toStringAsFixed(0)}%',
                                  style: SunriseType.label.copyWith(
                                    color: c.subtle,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              d.categoryName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: SunriseType.rowTitle.copyWith(
                                color: c.ink,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _money(ref, d.amount),
                                style: SunriseType.statValue.copyWith(
                                  color: c.ink,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

/// This month: spent, earned, net, with the change against last month.
class _SummaryRow extends ConsumerWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final data = ref.watch(financialDataProvider);
    final growth = data.monthlyGrowthPercentage;
    final net = data.monthlyIncome - data.monthlyExpenses;
    final change =
        '${growth >= 0 ? '+' : '−'}${growth.abs().toStringAsFixed(1)}%';

    Widget tile(String label, String value, Color color) => Expanded(
      child: SunriseCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                style: SunriseType.amount.copyWith(color: color, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          l10n.statsThisMonth,
          trailing: Text(
            l10n.statsVsLastMonth(change),
            style: SunriseType.caption.copyWith(color: c.subtle),
          ),
        ),
        Row(
          children: [
            tile(l10n.statsSpent, _money(ref, data.monthlyExpenses), c.ink),
            const SizedBox(width: 10),
            tile(l10n.statsEarned, _money(ref, data.monthlyIncome), c.positive),
            const SizedBox(width: 10),
            tile(
              l10n.statsNet,
              _money(ref, net),
              net < 0 ? c.negative : c.ink,
            ),
          ],
        ),
      ],
    );
  }
}

/// A year of days as coloured squares.
class _HeatmapCard extends ConsumerWidget {
  const _HeatmapCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final calendar = ref.watch(dailyNetCalendarProvider);
    final currency = ref.watch(defaultCurrencyProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);
    String money(int cents) {
      final text = cents.abs().formatCurrency(
        currency,
        numberFormat: numberFormat,
      );
      return cents < 0 ? '−$text' : text;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          l10n.heatmapTitle,
          trailing: switch (calendar) {
            AsyncData(:final value) when !value.isEmpty => Tooltip(
              message: l10n.heatmapNetForRange,
              child: Semantics(
                label: l10n.heatmapNetForRange,
                child: Text(
                  money(value.totalNetCents),
                  style: SunriseType.amount.copyWith(
                    color: value.totalNetCents < 0 ? c.negative : c.positive,
                  ),
                ),
              ),
            ),
            _ => null,
          },
        ),
        SunriseCard(
          child: switch (calendar) {
            AsyncData(:final value) when value.isEmpty => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.heatmapNothingYet,
                style: SunriseType.label.copyWith(color: c.subtle),
              ),
            ),
            AsyncData(:final value) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpendingHeatmap(
                  calendar: value,
                  money: money,
                  dateFormat: dateFormat,
                ),
                if (value.excluded > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.amountsLeftOutNoRate(value.excluded, value.currency),
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ],
            ),
            AsyncError() => Text(
              l10n.reportNoSpendingDataAvailable,
              style: SunriseType.label.copyWith(color: c.subtle),
            ),
            _ => const SizedBox(height: 120, child: SunriseLoader()),
          },
        ),
      ],
    );
  }
}

/// Budget vs actual for the period.
class _BudgetComparison extends ConsumerWidget {
  const _BudgetComparison();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final budgets = ref.watch(reportsProvider).budgetComparison;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l10n.reportBudgetVsActual),
        SunriseCard(
          child: budgets.isEmpty
              ? EmptyState(
                  compact: true,
                  icon: Symbols.donut_large_rounded,
                  title: l10n.reportNoActiveBudgets,
                  message: l10n.reportCreateABudgetToTrack,
                )
              : Column(
                  children: [
                    for (var i = 0; i < budgets.length; i++) ...[
                      if (i > 0) const SizedBox(height: 18),
                      _budgetRow(context, ref, budgets[i], l10n, c),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _budgetRow(
    BuildContext context,
    WidgetRef ref,
    BudgetComparisonData b,
    L10n l10n,
    SunriseColors c,
  ) {
    final pct = b.percentage.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                b.budgetName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.rowTitle.copyWith(color: c.ink),
              ),
            ),
            Text(
              '${_money(ref, b.spent)} / ${_money(ref, b.budgetLimit)}',
              style: SunriseType.label.copyWith(
                color: b.isOverBudget ? c.negative : c.subtle,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(height: 8, color: c.toggleOff),
              FractionallySizedBox(
                widthFactor: pct,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: b.isOverBudget ? c.negative : null,
                    gradient: b.isOverBudget ? null : c.gradientShort,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          b.isOverBudget
              ? l10n.statsOverBy(_money(ref, b.spent - b.budgetLimit))
              : l10n.statsRemaining(
                  ((1 - b.percentage) * 100).clamp(0, 100).toStringAsFixed(0),
                ),
          style: SunriseType.caption.copyWith(
            color: b.isOverBudget ? c.negative : c.subtle,
          ),
        ),
      ],
    );
  }
}
