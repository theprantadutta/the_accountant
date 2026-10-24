import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart';
import 'package:the_accountant/features/networth/providers/net_worth_provider.dart';
import 'package:the_accountant/features/networth/screens/asset_form_screen.dart';
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/networth/services/net_worth_service.dart';
import 'package:the_accountant/features/networth/widgets/net_worth_labels.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Signed money, with a true minus sign.
String _signed(PlanFormat f, int cents, String currency, {bool plus = false}) {
  final sign = cents < 0 ? '−' : (plus && cents > 0 ? '+' : '');
  return '$sign${f.money(cents.abs(), currency)}';
}

/// What the user is worth, what it is made of, how it has moved, and the
/// things they own.
class NetWorthScreen extends ConsumerWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final summary = ref.watch(netWorthProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todayNetWorth),
        actions: [
          IconButton(
            key: const Key('net_worth_add_asset'),
            icon: const Icon(Icons.add),
            tooltip: l10n.assetNew,
            onPressed: () => _addAsset(context),
          ),
        ],
      ),
      body: CappedBody(
        child: summary.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (s) => ListView(
            padding: const EdgeInsets.fromLTRB(
              SunriseSpace.screenX,
              8,
              SunriseSpace.screenX,
              40,
            ),
            children: [
              _TotalCard(summary: s),
              const SizedBox(height: 14),
              _HistoryCard(currency: s.currency),
              const SizedBox(height: 18),
              SectionLabel(l10n.netWorthBreakdown),
              _BreakdownCard(summary: s),
              const SizedBox(height: 18),
              const _AssetsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _addAsset(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (_) => const AssetFormScreen()));

class _TotalCard extends ConsumerWidget {
  const _TotalCard({required this.summary});

  final NetWorthSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final history = ref.watch(netWorthHistoryProvider(6)).value ?? const [];
    final change = history.length < 2
        ? null
        : history.last.value - history[history.length - 2].value;
    return SunriseCard(
      glass: true,
      radius: SunriseRadius.heroBig,
      padding: const EdgeInsets.all(SunriseSpace.hero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.netWorthToday,
            style: SunriseType.label.copyWith(color: c.muted, fontSize: 15),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              _signed(f, summary.total, summary.currency),
              key: const Key('net_worth_total'),
              maxLines: 1,
              style: SunriseType.balance.copyWith(color: c.ink),
            ),
          ),
          if (change != null) ...[
            const SizedBox(height: 10),
            SunrisePill(
              label: l10n.netWorthSinceLastMonth(
                _signed(f, change, summary.currency, plus: true),
              ),
              color: change >= 0 ? c.accentText : c.negative,
              background: change >= 0 ? c.tintPeach : c.tintRose,
              fontSize: 13,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ],
        ],
      ),
    );
  }
}

class _BreakdownCard extends ConsumerWidget {
  const _BreakdownCard({required this.summary});

  final NetWorthSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    // Cash is always shown, as the line everything else is measured against;
    // the rest only when there is something in them.
    final parts = [
      for (final p in NetWorthPart.values)
        if (p == NetWorthPart.cash || summary[p] != 0) p,
    ];
    return SunriseCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in parts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  IconTile(icon: p.icon, color: p.color, size: 34),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p.label(l10n),
                      style: SunriseType.body.copyWith(
                        color: c.ink,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    _signed(f, summary[p], summary.currency),
                    key: Key('net_worth_part_${p.name}'),
                    style: SunriseType.label.copyWith(
                      color: summary[p] < 0 ? c.negative : c.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Divider(color: c.divider, height: 18),
          Text(
            [
              l10n.netWorthLoansNote,
              if (!summary.includesCards) l10n.netWorthCardsLeftOut,
            ].join(' '),
            style: SunriseType.caption.copyWith(color: c.subtle),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/// Month-end net worth as a line, over a span the user picks.
class _HistoryCard extends ConsumerStatefulWidget {
  const _HistoryCard({required this.currency});

  final String currency;

  @override
  ConsumerState<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends ConsumerState<_HistoryCard> {
  /// Months shown; null for all of them.
  int? _months = 6;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final locale = Localizations.localeOf(context).toString();
    final points = ref.watch(netWorthHistoryProvider(_months)).value;

    return SunriseCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.netWorthHistory,
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 16),
          ),
          const SizedBox(height: 12),
          SunriseSegmented<int?>(
            key: const Key('net_worth_span'),
            height: 38,
            options: [
              SegmentOption(6, l10n.netWorthSixMonths),
              SegmentOption(12, l10n.netWorthOneYear),
              SegmentOption(null, l10n.netWorthAllTime),
            ],
            value: _months,
            onChanged: (m) => setState(() => _months = m),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: points == null
                ? const Center(child: CircularProgressIndicator())
                : points.length < 2
                ? Center(
                    child: Text(
                      l10n.netWorthHistoryEmpty,
                      textAlign: TextAlign.center,
                      style: SunriseType.label.copyWith(color: c.subtle),
                    ),
                  )
                : _chart(context, points, f, locale),
          ),
        ],
      ),
    );
  }

  Widget _chart(
    BuildContext context,
    List<NetWorthPoint> points,
    PlanFormat f,
    String locale,
  ) {
    final c = context.sunrise;
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].value / 100),
    ];
    final lo = spots.map((s) => s.y).reduce(math.min);
    final hi = spots.map((s) => s.y).reduce(math.max);
    // Room above and below the line, and never a flat range to divide by.
    final pad = (hi - lo).abs() < 1
        ? math.max(hi.abs(), 1) * .1
        : (hi - lo) * .12;
    final minY = lo - pad;
    final maxY = hi + pad;
    final month = DateFormat(points.length > 12 ? 'MMM yy' : 'MMM', locale);
    // Four or so month labels along the bottom, always the last one.
    final every = math.max(1, (points.length / 4).ceil());

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: c.divider, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 1,
              getTitlesWidget: (x, meta) {
                final i = x.round();
                if (i < 0 || i >= points.length || x != i.toDouble()) {
                  return const SizedBox.shrink();
                }
                final last = i == points.length - 1;
                if (!last && (points.length - 1 - i) % every != 0) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    month.format(points[i].month),
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => c.surface,
            getTooltipItems: (touched) => [
              for (final t in touched)
                LineTooltipItem(
                  '${DateFormat.yMMM(locale).format(points[t.spotIndex].month)}\n'
                  '${_signed(f, points[t.spotIndex].value, widget.currency)}',
                  SunriseType.caption.copyWith(
                    color: c.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            gradient: c.gradientShort,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, _, index) => FlDotCirclePainter(
                radius: index == spots.length - 1 ? 4.5 : 0,
                color: c.gradientEnd,
                strokeWidth: 2.5,
                strokeColor: c.surface,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  c.gradientMid.withValues(alpha: .25),
                  c.gradientMid.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: SunriseMotion.chart,
    );
  }
}

/// Land, homes, cars, gold: added, revalued and sold from here.
class _AssetsSection extends ConsumerWidget {
  const _AssetsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final assets = ref.watch(assetsProvider).value ?? const [];
    final owned = assets.where((a) => !a.isClosed).toList();
    final closed = assets.where((a) => a.isClosed).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          l10n.netWorthAssets,
          actionLabel: l10n.assetNew,
          onAction: () => _addAsset(context),
        ),
        if (owned.isEmpty)
          SunriseCard(
            child: EmptyState(
              compact: true,
              icon: Symbols.home_work_rounded,
              title: l10n.assetsEmptyTitle,
              message: l10n.assetsEmptyBody,
            ),
          )
        else
          for (final a in owned) ...[
            _AssetCard(asset: a),
            const SizedBox(height: 10),
          ],
        if (closed.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
            child: SectionLabel(l10n.assetsSold),
          ),
          for (final a in closed) ...[
            Opacity(opacity: .6, child: _AssetCard(asset: a)),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _AssetCard extends ConsumerWidget {
  const _AssetCard({required this.asset});

  final AssetHolding asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final a = asset;
    final change = a.change;
    final percent = a.changePercent;
    final changeText =
        '${_signed(f, change, a.currency, plus: true)}'
        '${percent == null ? '' : ' (${percent >= 0 ? '+' : '−'}${percent.abs().toStringAsFixed(1)}%)'}';
    return SunriseCard(
      key: Key('asset_${a.id}'),
      padding: const EdgeInsets.all(14),
      onTap: () => _actions(context, ref),
      child: Row(
        children: [
          IconTile(icon: a.kind.icon, color: a.kind.color, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                Text(
                  a.kind.label(l10n),
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                f.money(a.value, a.currency),
                style: SunriseType.label.copyWith(
                  color: c.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (change != 0)
                Text(
                  changeText,
                  style: SunriseType.caption.copyWith(
                    color: change > 0 ? c.positive : c.negative,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _actions(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);
    final f = PlanFormat(ref, context);
    final a = asset;
    final choice = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: a.name,
        subtitle: l10n.assetCostLine(f.money(a.cost, a.currency)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!a.isClosed) ...[
              SheetAction(
                key: const Key('asset_update_value'),
                icon: Symbols.price_change_rounded,
                label: l10n.assetUpdateValue,
                onTap: () => Navigator.pop(sheet, 'value'),
              ),
              SheetAction(
                key: const Key('asset_sell'),
                icon: Symbols.sell_rounded,
                label: l10n.assetSell,
                onTap: () => Navigator.pop(sheet, 'sell'),
              ),
            ],
            if (a.value == 0 && !a.isClosed)
              SheetAction(
                key: const Key('asset_delete'),
                icon: Symbols.delete_rounded,
                label: l10n.assetDelete,
                destructive: true,
                onTap: () => Navigator.pop(sheet, 'delete'),
              ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case 'value':
        await _revalue(context, ref);
      case 'sell':
        await _sell(context, ref);
      case 'delete':
        await _delete(context, ref);
    }
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    String done,
    Future<void> Function(AssetService s) action,
  ) async {
    try {
      await action(ref.read(assetServiceProvider));
      reloadAllData(ref);
      ref.invalidate(assetsProvider);
      if (context.mounted) {
        showSunriseSnack(context, done, tone: SnackTone.success);
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  Future<void> _revalue(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);
    final v = await askAmount(
      context,
      initial: asset.value,
      currency: asset.currency,
    );
    if (v == null || !context.mounted) return;
    await _run(
      context,
      ref,
      l10n.assetValueUpdated,
      (s) => s.revalue(asset.id, v),
    );
  }

  Future<void> _sell(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);
    final amount = await askAmount(
      context,
      initial: asset.value,
      currency: asset.currency,
      isIncome: true,
    );
    if (amount == null || amount <= 0 || !context.mounted) return;
    final to = await pickTradeAccount(context, ref);
    if (to == null || !context.mounted) return;
    await _run(
      context,
      ref,
      l10n.assetSold,
      (s) => s.sell(asset.id, toWalletId: to, amount: amount),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);
    final ok = await showSunriseConfirm(
      context: context,
      title: l10n.assetDeleteTitle(asset.name),
      message: l10n.assetDeleteBody,
      confirmLabel: l10n.actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (!ok || !context.mounted) return;
    await _run(context, ref, l10n.assetDeleted, (s) => s.delete(asset.id));
  }
}
