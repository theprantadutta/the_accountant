import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Plan;
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/providers/plans_provider.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One plan: its terms, its whole schedule, and what can be done with it.
class PlanDetailScreen extends ConsumerWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final async = ref.watch(planProgressProvider(planId));

    return Scaffold(
      appBar: AppBar(title: Text(async.value?.plan.name ?? l10n.plansTitle)),
      body: CappedBody(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (p) => p == null
              ? Center(child: Text(l10n.planGone))
              : _Body(progress: p),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.progress});

  final PlanProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final plan = progress.plan;
    final wallets = ref.watch(walletProvider).wallets;
    final wallet = wallets.where((w) => w.id == plan.walletId).firstOrNull;
    final holding = wallets
        .where((w) => w.id == plan.holdingWalletId)
        .firstOrNull;
    final currency = wallet?.currency ?? '';
    final f = PlanFormat(ref, context);
    String money(int v) =>
        f.money(v, currency, useDecimals: wallet?.useDecimals ?? true);
    final next = progress.next;
    final active = plan.status == PlanStatus.active;
    final today = DateTime.now();
    final end = PlanDates.endOf(plan);

    final facts = <(String, String)>[
      (l10n.planAccount, wallet?.name ?? '—'),
      if (plan.kind == PlanKind.emi) (l10n.planPrice, money(plan.principal)),
      if (plan.kind == PlanKind.loan)
        (l10n.planBorrowed, money(plan.principal)),
      if (plan.kind == PlanKind.fdr)
        (l10n.planDeposited, money(plan.principal)),
      if (plan.kind != PlanKind.fdr) ...[
        (
          plan.kind == PlanKind.dps ? l10n.planDeposit : l10n.planInstallment,
          '${money(plan.installmentAmount)} · ${plan.frequency.label(l10n)}',
        ),
        (
          l10n.planProgress,
          l10n.planInstallmentsDone(
            progress.installmentsDone,
            plan.installmentCount,
          ),
        ),
        (
          plan.kind == PlanKind.dps ? l10n.planSavedSoFar : l10n.planPaidSoFar,
          money(progress.paidSoFar),
        ),
        (l10n.planLeft, money(progress.remaining)),
        (l10n.planTotal, money(progress.totalPayable)),
        if ((plan.kind == PlanKind.emi || plan.kind == PlanKind.loan) &&
            progress.totalPayable > plan.principal &&
            plan.principal > 0)
          (
            l10n.planInterestCharges,
            money(progress.totalPayable - plan.principal),
          ),
      ],
      if (plan.interestRate != null)
        (l10n.planRate, '${plan.interestRate!.toStringAsFixed(2)}%'),
      if (plan.kind == PlanKind.fdr)
        (
          l10n.planPayout,
          plan.payout == PlanPayout.monthly
              ? l10n.planPayoutMonthly
              : l10n.planPayoutAtMaturity,
        ),
      if (plan.kind.isSaving) ...[
        (l10n.planMaturesOn, f.day(end)),
        (
          l10n.planMaturity,
          money(
            plan.kind == PlanKind.fdr && plan.payout == PlanPayout.monthly
                ? plan.principal
                : (plan.maturityAmount ?? progress.events.last.amount),
          ),
        ),
        if (holding != null) (l10n.planHolding, money(holding.balance)),
      ] else
        (l10n.planEnds, f.day(end)),
    ];

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
                  IconTile(
                    icon: plan.kind.icon,
                    color: plan.kind.color,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      plan.kind.label(l10n),
                      style: SunriseType.section.copyWith(color: c.ink),
                    ),
                  ),
                ],
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
        if (active && next != null) ...[
          SunriseButton(
            key: const Key('plan_pay_next'),
            label: switch (next.type) {
              PlanEventType.maturity => l10n.planTakeMaturity(
                money(next.amount),
              ),
              PlanEventType.profit => l10n.planRecordProfit(money(next.amount)),
              PlanEventType.installment =>
                plan.kind == PlanKind.dps
                    ? l10n.planDepositNow(next.number, money(next.amount))
                    : l10n.planPayNow(next.number, money(next.amount)),
            },
            onPressed: () => _run(context, ref, () async {
              await ref.read(planServiceProvider).payNext(plan.id);
              return l10n.planRecorded;
            }),
          ),
          const SizedBox(height: 8),
        ],
        if (active)
          SunriseButton.secondary(
            key: const Key('plan_close'),
            label: plan.kind.isSaving ? l10n.planEncash : l10n.planPayOff,
            onPressed: () => _close(context, ref, plan, progress, money),
          ),
        const SizedBox(height: 18),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Symbols.bolt_rounded,
              title: l10n.planAutoCollect,
              subtitle: l10n.planAutoCollectHint,
              trailing: SettingsTrailing.none,
              trailingWidget: SunriseToggle(
                value: plan.autoCollect,
                onChanged: active
                    ? (v) => _run(context, ref, () async {
                        await ref
                            .read(planServiceProvider)
                            .update(plan.id, autoCollect: v);
                        return l10n.planSaved;
                      })
                    : null,
              ),
            ),
            SettingsRow(
              icon: Symbols.notifications_active_rounded,
              title: l10n.cardRemindTitle,
              value: plan.reminderDaysBefore == 0
                  ? l10n.cardRemindOff
                  : l10n.cardRemindDaysBefore(plan.reminderDaysBefore),
              onTap: () => _remind(context, ref, plan),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SectionLabel(l10n.planSchedule),
        const SizedBox(height: 6),
        SunriseCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            children: [
              for (final e in progress.events)
                _EventRow(
                  event: e,
                  plan: plan,
                  done: progress.recorded.contains(e.number),
                  today: today,
                  money: money,
                  day: f.day,
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          key: const Key('plan_delete'),
          onPressed: () => _delete(context, ref, plan),
          child: Text(l10n.planDelete, style: TextStyle(color: c.negative)),
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
      ref.invalidate(plansProvider);
      if (context.mounted) {
        showSunriseSnack(context, message, tone: SnackTone.success);
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  Future<void> _close(
    BuildContext context,
    WidgetRef ref,
    Plan plan,
    PlanProgress progress,
    String Function(int) money,
  ) async {
    final l10n = L10n.of(context);
    final saving = plan.kind.isSaving;
    // A DPS or FDR may pay some profit when it is broken; a lender may quote
    // a settlement figure that is not the sum of what is left.
    final other = await showSunriseSheet<bool>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: saving
            ? l10n.planEncashTitle(plan.name)
            : l10n.planPayOffTitle(plan.name),
        subtitle: saving ? l10n.planEncashBody : l10n.planPayOffHint,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetAction(
              key: const Key('plan_close_plain'),
              icon: saving ? Symbols.savings_rounded : Symbols.task_alt_rounded,
              label: saving
                  ? l10n.planEncashNoProfit
                  : l10n.planPayOffLeft(money(progress.remaining)),
              onTap: () => Navigator.pop(sheet, false),
            ),
            SheetAction(
              key: const Key('plan_close_other'),
              icon: Symbols.edit_rounded,
              label: saving ? l10n.planEncashWithProfit : l10n.planPayOffOther,
              onTap: () => Navigator.pop(sheet, true),
            ),
          ],
        ),
      ),
    );
    if (other == null || !context.mounted) return;

    int? amount;
    if (other) {
      final wallet = ref
          .read(walletProvider)
          .wallets
          .where((w) => w.id == plan.walletId)
          .firstOrNull;
      final entered = await showCalculatorBottomSheet(
        context: context,
        initialAmount: saving ? 0 : progress.remaining / 100.0,
        isIncome: saving,
        currencySymbol: CurrencyInfo.getSymbol(wallet?.currency ?? 'USD'),
      );
      if (entered == null || !context.mounted) return;
      amount = (entered * 100).round();
    }
    await _run(context, ref, () async {
      await ref.read(planServiceProvider).closeEarly(plan.id, amount: amount);
      return saving ? l10n.planEncashed : l10n.planPaidOff;
    });
  }

  Future<void> _remind(BuildContext context, WidgetRef ref, Plan plan) async {
    final l10n = L10n.of(context);
    final days = await showSunriseSheet<int>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.cardRemindTitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final d in const [0, 1, 3, 5, 7])
              SheetAction(
                icon: d == 0
                    ? Symbols.notifications_off_rounded
                    : Symbols.notifications_active_rounded,
                label: d == 0
                    ? l10n.cardRemindOff
                    : l10n.cardRemindDaysBefore(d),
                selected: d == plan.reminderDaysBefore,
                onTap: () => Navigator.pop(sheet, d),
              ),
          ],
        ),
      ),
    );
    if (days == null || !context.mounted) return;
    await _run(context, ref, () async {
      await ref
          .read(planServiceProvider)
          .update(plan.id, reminderDaysBefore: days);
      return l10n.planSaved;
    });
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Plan plan) async {
    final l10n = L10n.of(context);
    final ok = await showSunriseConfirm(
      context: context,
      title: l10n.planDeleteTitle(plan.name),
      message: l10n.planDeleteBody,
      confirmLabel: l10n.actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(planServiceProvider).delete(plan.id);
      reloadAllData(ref);
      ref.invalidate(plansProvider);
      if (context.mounted) {
        Navigator.of(context).pop();
        showSunriseSnack(context, l10n.planDeleted, tone: SnackTone.success);
      }
    } on ArgumentError catch (e) {
      if (context.mounted) {
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.event,
    required this.plan,
    required this.done,
    required this.today,
    required this.money,
    required this.day,
  });

  final PlanEvent event;
  final Plan plan;
  final bool done;
  final DateTime today;
  final String Function(int) money;
  final String Function(DateTime) day;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final start = DateTime(today.year, today.month, today.day);
    final late = !done && event.date.isBefore(start);
    final label = switch (event.type) {
      PlanEventType.maturity => l10n.planEventMaturity,
      PlanEventType.profit => l10n.planEventProfit(event.number),
      PlanEventType.installment => l10n.planEventInstallment(
        event.number,
        plan.installmentCount,
      ),
    };
    final (IconData icon, Color color, String state) = done
        ? (Symbols.check_circle_rounded, c.positive, l10n.planEventDone)
        : late && plan.status == PlanStatus.active
        ? (Symbols.error_rounded, c.negative, l10n.planEventLate)
        : (
            Symbols.radio_button_unchecked_rounded,
            c.faint,
            l10n.planEventUpcoming,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20, fill: done ? 1 : 0),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: SunriseType.body.copyWith(color: c.ink, fontSize: 14),
                ),
                Text(
                  '${day(event.date)} · $state',
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          Text(
            money(event.amount),
            style: SunriseType.label.copyWith(
              color: c.ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
