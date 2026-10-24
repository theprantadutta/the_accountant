import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/investments/providers/investments_provider.dart';
import 'package:the_accountant/features/investments/screens/investment_detail_screen.dart';
import 'package:the_accountant/features/investments/screens/investment_form_screen.dart';
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/investments/widgets/investment_labels.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Every fund, share and other holding, with what each is worth.
class InvestmentsScreen extends ConsumerWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final holdings = ref.watch(investmentsProvider);

    void add() => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InvestmentFormScreen()));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.investmentsTitle),
        actions: [
          IconButton(
            key: const Key('investments_new'),
            icon: const Icon(Icons.add),
            tooltip: l10n.investmentNew,
            onPressed: add,
          ),
        ],
      ),
      body: CappedBody(
        child: holdings.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            if (list.isEmpty) {
              return ListView(
                padding: const EdgeInsets.only(top: 40),
                children: [
                  EmptyState(
                    icon: Symbols.trending_up_rounded,
                    title: l10n.investmentsEmptyTitle,
                    message: l10n.investmentsEmptyBody,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SunriseSpace.screenX * 2,
                      vertical: 16,
                    ),
                    child: SunriseButton(
                      label: l10n.investmentNew,
                      onPressed: add,
                    ),
                  ),
                ],
              );
            }
            final held = list.where((h) => h.units > 0 || h.value != 0);
            final sold = list.where((h) => h.units <= 0 && h.value == 0);
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                SunriseSpace.screenX,
                8,
                SunriseSpace.screenX,
                32,
              ),
              children: [
                _PortfolioCard(holdings: held.toList()),
                const SizedBox(height: 14),
                for (final h in held) ...[
                  InvestmentCard(holding: h),
                  const SizedBox(height: 12),
                ],
                if (sold.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                    child: SectionLabel(l10n.investmentsSold),
                  ),
                  for (final h in sold) ...[
                    Opacity(opacity: .6, child: InvestmentCard(holding: h)),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// What everything held is worth, and the gain on it, per currency.
class _PortfolioCard extends ConsumerWidget {
  const _PortfolioCard({required this.holdings});

  final List<InvestmentHolding> holdings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final byCurrency = <String, (int, int, int)>{};
    for (final h in holdings) {
      final (value, gain, putIn) = byCurrency[h.currency] ?? (0, 0, 0);
      byCurrency[h.currency] = (
        value + h.value,
        gain + h.gain,
        putIn + h.putIn,
      );
    }
    return SunriseCard(
      key: const Key('investments_total'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.investmentsWorth,
            style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
          ),
          for (final MapEntry(key: currency, value: (value, gain, putIn))
              in byCurrency.entries) ...[
            const SizedBox(height: 6),
            Text(
              f.money(value, currency),
              style: SunriseType.section.copyWith(color: c.ink, fontSize: 28),
            ),
            GainLine(gain: gain, putIn: putIn, currency: currency),
          ],
        ],
      ),
    );
  }
}

/// One holding in the list.
class InvestmentCard extends ConsumerWidget {
  const InvestmentCard({super.key, required this.holding});

  final InvestmentHolding holding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final i = holding.investment;
    return SunriseCard(
      key: Key('investment_${i.id}'),
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InvestmentDetailScreen(investmentId: i.id),
        ),
      ),
      child: Row(
        children: [
          IconTile(icon: i.kind.icon, color: i.kind.color, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                Text(
                  [
                    i.kind.label(l10n),
                    if (i.symbol != null) i.symbol!,
                    l10n.investmentUnitsShort(formatUnits(holding.units)),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                f.money(holding.value, holding.currency),
                style: SunriseType.label.copyWith(
                  color: c.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GainLine(
                gain: holding.gain,
                putIn: holding.putIn,
                currency: holding.currency,
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
