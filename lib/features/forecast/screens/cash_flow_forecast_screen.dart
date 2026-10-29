import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/privacy_provider.dart';
import 'package:the_accountant/features/forecast/providers/forecast_provider.dart';
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/features/forecast/widgets/forecast_labels.dart';
import 'package:the_accountant/features/plans/screens/plan_detail_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/wallets/screens/wallet_detail_screen.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sensitive.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Where cash and bank money is headed over the next 30, 60 or 90 days, from
/// everything already scheduled, and the first day it would run short.
class CashFlowForecastScreen extends ConsumerStatefulWidget {
  const CashFlowForecastScreen({super.key});

  @override
  ConsumerState<CashFlowForecastScreen> createState() =>
      _CashFlowForecastScreenState();
}

class _CashFlowForecastScreenState
    extends ConsumerState<CashFlowForecastScreen> {
  int _days = CashFlowForecastService.ranges.first;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final forecast = ref.watch(cashFlowForecastProvider(_days));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forecastTitle)),
      body: CappedBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            32,
          ),
          children: [
            SunriseSegmented<int>(
              key: const Key('forecast_range'),
              options: [
                for (final d in CashFlowForecastService.ranges)
                  SegmentOption(d, l10n.forecastRangeDays(d)),
              ],
              value: _days,
              onChanged: (d) => setState(() => _days = d),
            ),
            const SizedBox(height: 14),
            ...forecast.when(
              loading: () => const [
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (e, _) => [Center(child: Text('$e'))],
              data: (f) => _body(f),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _body(CashFlowForecast f) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return [
      _SummaryCard(forecast: f),
      const SizedBox(height: 12),
      f.hasShortfall ? _ShortfallCard(forecast: f) : _CoveredCard(forecast: f),
      const SizedBox(height: 12),
      _BalanceChart(forecast: f),
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
        child: Text(
          l10n.forecastScheduledOnly,
          style: SunriseType.caption.copyWith(color: c.subtle),
        ),
      ),
      const SizedBox(height: 20),
      SectionLabel(l10n.forecastEventsTitle),
      if (f.events.isEmpty)
        EmptyState(
          icon: Symbols.event_available_rounded,
          title: l10n.forecastEmptyTitle,
          message: l10n.forecastEmptyBody,
          compact: true,
        )
      else
        for (final group in f.byDay) ...[
          _DayGroup(forecast: f, date: group.date, events: group.events),
          const SizedBox(height: 12),
        ],
    ];
  }
}

/// Where the money starts, what comes and goes, and how low it gets.
class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.forecast});

  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final money = forecast.currency;
    final lowest = forecast.lowest;

    Widget stat(String label, String value, Color color, [String? caption]) =>
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: SunriseType.caption.copyWith(color: c.muted)),
              const SizedBox(height: 4),
              Sensitive(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              if (caption != null)
                Text(
                  caption,
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
            ],
          ),
        );

    return SunriseCard(
      key: const Key('forecast_summary'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.forecastNow,
            style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Sensitive(
            child: Text(
              f.money(forecast.startingBalance, money),
              style: SunriseType.section.copyWith(color: c.ink, fontSize: 28),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stat(
                l10n.forecastMoneyIn,
                f.money(forecast.moneyIn, money),
                c.positive,
              ),
              const SizedBox(width: 12),
              stat(
                l10n.forecastMoneyOut,
                f.money(forecast.moneyOut, money),
                c.negative,
              ),
              const SizedBox(width: 12),
              stat(
                l10n.forecastLowest,
                f.money(lowest.balance, money),
                lowest.balance < 0 ? c.negative : c.ink,
                l10n.forecastLowestOn(f.day(lowest.date)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The first day money would run out, and what goes out that day.
class _ShortfallCard extends ConsumerWidget {
  const _ShortfallCard({required this.forecast});

  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final day = forecast.shortfall!;
    final causes = forecast.shortfallEvents;
    final short = f.money(forecast.shortfallAmount, forecast.currency);

    return SunriseCard(
      key: const Key('forecast_shortfall'),
      color: c.tintRose,
      shadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(
                icon: Symbols.warning_rounded,
                color: c.negative,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SensitiveText(
                  l10n.forecastShortfallTitle(f.day(day.date), short),
                  amounts: [short],
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (causes.isEmpty)
            Text(
              l10n.forecastAlreadyShort,
              style: SunriseType.label.copyWith(color: c.body),
            )
          else ...[
            Text(
              l10n.forecastShortfallCause,
              style: SunriseType.label.copyWith(color: c.muted),
            ),
            const SizedBox(height: 6),
            for (final e in causes)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${e.title} · ${e.kind.label(l10n)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: SunriseType.label.copyWith(color: c.body),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f.money(e.amount, forecast.currency),
                      style: SunriseType.label.copyWith(
                        color: c.negative,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Said plainly when nothing runs short, so silence is not mistaken for an
/// answer still being worked out.
class _CoveredCard extends StatelessWidget {
  const _CoveredCard({required this.forecast});

  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      key: const Key('forecast_covered'),
      color: c.tintGreen,
      shadow: false,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconTile(
            icon: Symbols.check_circle_rounded,
            color: c.positive,
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.forecastAllCoveredTitle(forecast.days),
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.forecastAllCoveredBody,
                  style: SunriseType.label.copyWith(color: c.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The balance at the end of each day, with zero marked so a dip below it
/// stands out.
class _BalanceChart extends ConsumerWidget {
  const _BalanceChart({required this.forecast});

  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final hidden = ref.watch(amountsHiddenProvider);
    final spots = [
      for (var i = 0; i < forecast.daily.length; i++)
        FlSpot(i.toDouble(), forecast.daily[i].balance / 100),
    ];
    final high = math.max(0.0, spots.map((s) => s.y).reduce(math.max));
    final low = math.min(0.0, spots.map((s) => s.y).reduce(math.min));
    // Some room above and below, and never a flat zero-height range.
    final pad = math.max((high - low) * .12, 1.0);

    return SunriseCard(
      key: const Key('forecast_chart'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.forecastChartTitle,
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 16),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: spots.last.x,
                minY: low - pad,
                maxY: high + pad,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (high - low + 2 * pad) / 4,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: c.divider, strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: c.negative.withValues(alpha: .7),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                    ),
                  ],
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => c.surface,
                    getTooltipItems: (touched) => [
                      for (final t in touched)
                        LineTooltipItem(
                          '${f.day(forecast.daily[t.x.toInt()].date)}\n'
                          // A tooltip cannot blur, so it says the amount is
                          // hidden.
                          '${hidden ? l10n.amountHidden : f.money(forecast.daily[t.x.toInt()].balance, forecast.currency)}',
                          SunriseType.caption.copyWith(color: c.ink),
                        ),
                    ],
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    // Balances move in steps on the day something is paid,
                    // so the line steps too rather than sloping between days.
                    isStepLineChart: true,
                    gradient: c.gradientShort,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      applyCutOffY: true,
                      cutOffY: 0,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          c.gradientMid.withValues(alpha: .22),
                          c.gradientMid.withValues(alpha: 0),
                        ],
                      ),
                    ),
                    aboveBarData: BarAreaData(
                      show: true,
                      applyCutOffY: true,
                      cutOffY: 0,
                      color: c.negative.withValues(alpha: .14),
                    ),
                  ),
                ],
              ),
              duration: SunriseMotion.chart,
            ),
          ),
        ],
      ),
    );
  }
}

/// One day's events, with the balance once they have happened.
class _DayGroup extends ConsumerWidget {
  const _DayGroup({
    required this.forecast,
    required this.date,
    required this.events,
  });

  final CashFlowForecast forecast;
  final DateTime date;
  final List<ForecastEvent> events;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final balance = forecast.daily
        .firstWhere(
          (d) => !d.date.isBefore(date),
          orElse: () => forecast.daily.last,
        )
        .balance;
    final balanceText = f.money(balance, forecast.currency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  f.day(date),
                  style: SunriseType.label.copyWith(color: c.muted),
                ),
              ),
              SensitiveText(
                l10n.forecastDayBalance(balanceText),
                amounts: [balanceText],
                style: SunriseType.caption.copyWith(
                  color: balance < 0 ? c.negative : c.subtle,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        SunriseCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < events.length; i++) ...[
                if (i > 0) Divider(height: 1, color: c.divider),
                _EventRow(event: events[i], currency: forecast.currency),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EventRow extends ConsumerWidget {
  const _EventRow({required this.event, required this.currency});

  final ForecastEvent event;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final color = event.isIncome ? c.positive : c.negative;
    final notes = [
      event.kind.label(l10n),
      if (event.overdue) l10n.forecastOverdue,
      if (event.expected) l10n.forecastExpected,
    ];

    final open = _detailFor(event);
    return Pressable(
      onTap: open == null
          ? null
          : () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => open)),
      semanticLabel: event.title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            IconTile(icon: event.kind.icon, color: color, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.rowTitle.copyWith(color: c.ink),
                  ),
                  Text(
                    notes.join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${event.isIncome ? '+' : '-'}${f.money(event.amount, currency)}',
              style: SunriseType.amount.copyWith(
                color: color,
                fontSize: 15,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The screen a forecast row opens: the plan, the card, or the transaction
/// it comes from. Each row names one of them, and tapping did nothing.
Widget? _detailFor(ForecastEvent e) => switch (e.source) {
  ForecastSource.plan when e.refId != null => PlanDetailScreen(
    planId: e.refId!,
  ),
  ForecastSource.cardBill when e.walletId != null => WalletDetailScreen(
    walletId: e.walletId!,
  ),
  _ when e.refId != null => TransactionDetailScreen(transactionId: e.refId!),
  _ => null,
};
