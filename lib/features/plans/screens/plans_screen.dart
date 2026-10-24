import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/providers/plans_provider.dart';
import 'package:the_accountant/features/plans/screens/plan_detail_screen.dart';
import 'package:the_accountant/features/plans/screens/plan_form_screen.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Every EMI, loan, DPS and FDR, with how far along each is.
class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final plans = ref.watch(plansProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.plansTitle),
        actions: [
          IconButton(
            key: const Key('plans_new'),
            icon: const Icon(Icons.add),
            tooltip: l10n.planNew,
            onPressed: () => startNewPlan(context),
          ),
        ],
      ),
      body: CappedBody(
        child: plans.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            if (list.isEmpty) {
              return ListView(
                padding: const EdgeInsets.only(top: 40),
                children: [
                  EmptyState(
                    icon: Symbols.event_repeat_rounded,
                    title: l10n.plansEmptyTitle,
                    message: l10n.plansEmptyBody,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SunriseSpace.screenX * 2,
                      vertical: 16,
                    ),
                    child: SunriseButton(
                      label: l10n.planNew,
                      onPressed: () => startNewPlan(context),
                    ),
                  ),
                ],
              );
            }
            final active = list
                .where((p) => p.plan.status == PlanStatus.active)
                .toList();
            final ended = list
                .where((p) => p.plan.status != PlanStatus.active)
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                SunriseSpace.screenX,
                8,
                SunriseSpace.screenX,
                32,
              ),
              children: [
                for (final p in active) ...[
                  PlanCard(progress: p),
                  const SizedBox(height: 12),
                ],
                if (ended.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                    child: SectionLabel(l10n.plansEnded),
                  ),
                  for (final p in ended) ...[
                    Opacity(opacity: .6, child: PlanCard(progress: p)),
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

/// Ask which kind of plan, then open its form.
Future<void> startNewPlan(BuildContext context) async {
  final l10n = L10n.of(context);
  final kind = await showSunriseSheet<PlanKind>(
    context: context,
    builder: (sheet) => SunriseBottomSheet(
      title: l10n.planNewTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final k in [
            PlanKind.emi,
            PlanKind.loan,
            PlanKind.dps,
            PlanKind.fdr,
          ])
            SheetAction(
              key: Key('plan_kind_${k.name}'),
              icon: k.icon,
              label: k.label(l10n),
              subtitle: k.describe(l10n),
              onTap: () => Navigator.pop(sheet, k),
            ),
        ],
      ),
    ),
  );
  if (kind == null || !context.mounted) return;
  await Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => PlanFormScreen(kind: kind)));
}

/// One plan in the list.
class PlanCard extends ConsumerWidget {
  const PlanCard({super.key, required this.progress});

  final PlanProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final plan = progress.plan;
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == plan.walletId)
        .firstOrNull;
    final currency = wallet?.currency ?? '';
    final f = PlanFormat(ref, context);
    final next = progress.next;
    final now = DateTime.now();
    final overdue =
        plan.status == PlanStatus.active &&
        next != null &&
        next.type == PlanEventType.installment &&
        next.date.isBefore(DateTime(now.year, now.month, now.day));

    final (double done, String line) = switch (plan.kind) {
      PlanKind.fdr => (
        (now.difference(plan.startDate).inDays /
                PlanDates.endOf(plan).difference(plan.startDate).inDays)
            .clamp(0.0, 1.0),
        l10n.planFdrLine(
          f.money(plan.principal, currency),
          f.day(PlanDates.endOf(plan)),
        ),
      ),
      PlanKind.dps => (
        progress.installmentsDone / plan.installmentCount,
        l10n.planSavedLine(
          f.money(progress.paidSoFar, currency),
          f.money(progress.totalPayable, currency),
        ),
      ),
      _ => (
        progress.installmentsDone / plan.installmentCount,
        l10n.planPaidLine(
          f.money(progress.paidSoFar, currency),
          f.money(progress.totalPayable, currency),
        ),
      ),
    };

    final status = switch (plan.status) {
      PlanStatus.completed => (
        l10n.planStatusCompleted,
        c.positive,
        c.tintGreen,
      ),
      PlanStatus.closed => (l10n.planStatusClosed, c.muted, c.surface),
      PlanStatus.active when overdue => (
        l10n.planStatusOverdue,
        c.negative,
        c.tintRose,
      ),
      PlanStatus.active => (
        plan.kind == PlanKind.fdr
            ? l10n.planStatusRunning
            : l10n.planInstallmentsDone(
                progress.installmentsDone,
                plan.installmentCount,
              ),
        c.accentText,
        c.tintPeach,
      ),
    };

    return SunriseCard(
      key: Key('plan_${plan.id}'),
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PlanDetailScreen(planId: plan.id)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(icon: plan.kind.icon, color: plan.kind.color, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SunriseType.rowTitle.copyWith(color: c.ink),
                    ),
                    Text(
                      '${plan.kind.label(l10n)} · ${wallet?.name ?? ''}',
                      style: SunriseType.caption.copyWith(color: c.subtle),
                    ),
                  ],
                ),
              ),
              SunrisePill(
                label: status.$1,
                color: status.$2,
                background: status.$3,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: done.isNaN ? 0 : done,
              minHeight: 6,
              backgroundColor: c.barIdle,
              color: plan.kind.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(line, style: SunriseType.caption.copyWith(color: c.muted)),
          if (plan.status == PlanStatus.active &&
              next != null &&
              next.type == PlanEventType.installment)
            Text(
              l10n.planNextLine(
                f.money(next.amount, currency),
                f.day(next.date),
              ),
              style: SunriseType.caption.copyWith(
                color: overdue ? c.negative : c.subtle,
              ),
            ),
        ],
      ),
    );
  }
}
