import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/features/investments/providers/investments_provider.dart';
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart';
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/investments/widgets/investment_labels.dart';
import 'package:the_accountant/features/plans/screens/plan_form_screen.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One holding: what it is worth, what it has gained, and every trade.
class InvestmentDetailScreen extends ConsumerWidget {
  const InvestmentDetailScreen({super.key, required this.investmentId});

  final String investmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final async = ref.watch(investmentHoldingProvider(investmentId));
    return Scaffold(
      appBar: AppBar(
        title: Text(async.value?.investment.name ?? l10n.investmentsTitle),
      ),
      body: CappedBody(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (h) => h == null
              ? Center(child: Text(l10n.investmentGone))
              : _Body(holding: h),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.holding});

  final InvestmentHolding holding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final i = holding.investment;
    String money(int v) => f.money(v, holding.currency);
    final trades = ref.watch(investmentTradesProvider(i.id)).value ?? const [];

    final facts = <(String, String)>[
      (l10n.investmentUnits, formatUnits(holding.units)),
      (
        l10n.investmentPrice,
        i.price == 0
            ? l10n.cardNotSet
            : '${money(i.price)}${i.priceDate == null ? '' : ' · ${f.day(i.priceDate!)}'}',
      ),
      (l10n.investmentPutIn, money(holding.putIn)),
      if (holding.takenOut > 0)
        (l10n.investmentTakenOut, money(holding.takenOut)),
    ];

    Future<void> trade(TradeMode mode) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvestmentTradeScreen(holding: holding, mode: mode),
      ),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        8,
        SunriseSpace.screenX,
        40,
      ),
      children: [
        SunriseCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconTile(icon: i.kind.icon, color: i.kind.color, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      [
                        i.kind.label(l10n),
                        if (i.symbol != null) i.symbol!,
                      ].join(' · '),
                      style: SunriseType.section.copyWith(color: c.ink),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l10n.investmentWorthNow,
                style: SunriseType.caption.copyWith(color: c.subtle),
              ),
              Text(
                money(holding.value),
                key: const Key('investment_value'),
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 30),
              ),
              GainLine(
                gain: holding.gain,
                putIn: holding.putIn,
                currency: holding.currency,
              ),
              const SizedBox(height: 12),
              for (final (label, value) in facts)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: SunriseType.body.copyWith(
                            color: c.muted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        value,
                        style: SunriseType.label.copyWith(
                          color: c.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: SunriseButton(
                key: const Key('investment_buy'),
                label: l10n.investmentBuy,
                onPressed: () => trade(TradeMode.buy),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SunriseButton.secondary(
                key: const Key('investment_sell'),
                label: l10n.investmentSell,
                onPressed: holding.units > 0
                    ? () => trade(TradeMode.sell)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SettingsGroup(
          children: [
            SettingsRow(
              key: const Key('investment_update_price'),
              icon: Symbols.price_change_rounded,
              title: l10n.investmentUpdatePrice,
              subtitle: l10n.investmentUpdatePriceHint,
              onTap: () => _updatePrice(context, ref),
            ),
            SettingsRow(
              key: const Key('investment_dividend'),
              icon: Symbols.redeem_rounded,
              title: l10n.investmentRecordDividend,
              onTap: () => trade(TradeMode.dividend),
            ),
            SettingsRow(
              key: const Key('investment_sip'),
              icon: Symbols.event_repeat_rounded,
              title: l10n.investmentStartSip,
              subtitle: l10n.investmentStartSipHint,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      PlanFormScreen(kind: PlanKind.sip, investmentId: i.id),
                ),
              ),
            ),
          ],
        ),
        if (trades.isNotEmpty) ...[
          const SizedBox(height: 18),
          SectionLabel(l10n.investmentHistory),
          const SizedBox(height: 6),
          SunriseCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Column(
              children: [
                for (final t in trades)
                  _TradeRow(
                    trade: t,
                    money: money,
                    day: f.day,
                    onTap: t.isRevaluation
                        ? null
                        : () => _correctUnits(context, ref, t),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        TextButton(
          key: const Key('investment_delete'),
          onPressed: () => _delete(context, ref),
          child: Text(
            l10n.investmentDelete,
            style: TextStyle(color: c.negative),
          ),
        ),
      ],
    );
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<String> Function() action,
  ) async {
    try {
      final message = await action();
      reloadAllData(ref);
      ref.invalidate(investmentsProvider);
      if (context.mounted) {
        showSunriseSnack(context, message, tone: SnackTone.success);
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  Future<void> _updatePrice(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);
    final price = await askAmount(
      context,
      initial: holding.investment.price,
      currency: holding.currency,
    );
    if (price == null || !context.mounted) return;
    await _run(context, ref, () async {
      await ref
          .read(investmentServiceProvider)
          .updatePrice(holding.investment.id, price);
      return l10n.investmentPriceUpdated;
    });
  }

  Future<void> _correctUnits(
    BuildContext context,
    WidgetRef ref,
    InvestmentTrade t,
  ) async {
    final l10n = L10n.of(context);
    final controller = TextEditingController(
      text: t.row.units == null
          ? ''
          : formatUnits(t.row.units!).replaceAll(',', ''),
    );
    final units = await showSunriseSheet<double>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.investmentCorrectUnits,
        subtitle: l10n.investmentCorrectUnitsHint,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheet).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SunriseTextField(
                key: const Key('correct_units'),
                controller: controller,
                label: l10n.investmentUnits,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
              const SizedBox(height: 14),
              SunriseButton(
                key: const Key('correct_units_save'),
                label: l10n.planSave,
                onPressed: () => Navigator.pop(
                  sheet,
                  double.tryParse(controller.text.trim()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
    if (units == null || !context.mounted) return;
    await _run(context, ref, () async {
      await ref.read(investmentServiceProvider).correctUnits(t.row.id, units);
      return l10n.investmentUnitsCorrected;
    });
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);
    final ok = await showSunriseConfirm(
      context: context,
      title: l10n.investmentDeleteTitle(holding.investment.name),
      message: l10n.investmentDeleteBody,
      confirmLabel: l10n.actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(investmentServiceProvider).delete(holding.investment.id);
      reloadAllData(ref);
      ref.invalidate(investmentsProvider);
      if (context.mounted) {
        Navigator.of(context).pop();
        showSunriseSnack(
          context,
          l10n.investmentDeleted,
          tone: SnackTone.success,
        );
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }
}

class _TradeRow extends StatelessWidget {
  const _TradeRow({
    required this.trade,
    required this.money,
    required this.day,
    this.onTap,
  });

  final InvestmentTrade trade;
  final String Function(int) money;
  final String Function(DateTime) day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final t = trade;
    final label = t.isRevaluation
        ? (t.isIn ? l10n.investmentPriceRose : l10n.investmentPriceFell)
        : t.isIn
        ? l10n.investmentBought(formatUnits(t.units.abs()))
        : l10n.investmentSold(formatUnits(t.units.abs()));
    final (IconData icon, Color color) = t.isRevaluation
        ? (Symbols.show_chart_rounded, c.subtle)
        : t.isIn
        ? (Symbols.add_circle_rounded, c.positive)
        : (Symbols.remove_circle_rounded, c.negative);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: SunriseType.body.copyWith(
                      color: c.ink,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    t.row.units == null && !t.isRevaluation
                        ? '${day(t.row.date)} · ${l10n.investmentUnitsUnknown}'
                        : day(t.row.date),
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ),
            ),
            Text(
              '${t.isIn ? '+' : '−'}${money(t.row.amount)}',
              style: SunriseType.label.copyWith(
                color: c.ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
