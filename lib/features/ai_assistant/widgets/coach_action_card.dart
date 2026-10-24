import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/features/ai_assistant/services/coach_tool_runner.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// What the coach is doing while the answer is not ready yet.
class CoachToolStatus extends StatelessWidget {
  const CoachToolStatus({super.key, required this.tool});

  /// The tool's name, as the coach called it.
  final String tool;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final (IconData icon, String label) = switch (tool) {
      'search_transactions' => (Symbols.search_rounded, l10n.aiToolSearching),
      'summarize' => (Symbols.bar_chart_rounded, l10n.aiToolSummarizing),
      'list_accounts' => (
        Symbols.account_balance_wallet_rounded,
        l10n.aiToolAccounts,
      ),
      'list_categories' => (Symbols.category_rounded, l10n.aiToolCategories),
      'card_bills' => (Symbols.credit_card_rounded, l10n.aiToolCards),
      'list_plans' => (Symbols.event_repeat_rounded, l10n.aiToolPlans),
      _ => (Symbols.edit_note_rounded, l10n.aiToolSaving),
    };

    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 16, height: 16, child: SunriseLoader()),
            const SizedBox(width: 10),
            Icon(icon, size: 18, color: c.muted),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: SunriseType.label.copyWith(color: c.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A change the coach wants to make, shown before anything happens.
///
/// Nothing is written until the user taps the confirm button; cancelling tells
/// the coach no, and it does not ask again.
class CoachActionCard extends StatelessWidget {
  const CoachActionCard({
    super.key,
    required this.action,
    required this.onConfirm,
    required this.onCancel,
  });

  final CoachActionPreview action;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final locale = Localizations.localeOf(context).toString();
    final isDelete = action.kind == CoachActionKind.delete;

    final heading = switch (action.kind) {
      CoachActionKind.add => l10n.aiActionAddTitle,
      CoachActionKind.update => l10n.aiActionUpdateTitle,
      CoachActionKind.delete => l10n.aiActionDeleteTitle,
      CoachActionKind.payCard => l10n.aiActionPayCardTitle,
      CoachActionKind.cardSettings => l10n.aiActionCardSettingsTitle,
      CoachActionKind.createPlan => l10n.aiActionCreatePlanTitle,
      CoachActionKind.payPlan => l10n.aiActionPayPlanTitle,
      CoachActionKind.closePlan => l10n.aiActionClosePlanTitle,
      CoachActionKind.updatePlan => l10n.aiActionUpdatePlanTitle,
      CoachActionKind.createInvestment => l10n.aiActionCreateInvestmentTitle,
      CoachActionKind.tradeInvestment => l10n.aiActionTradeInvestmentTitle,
      CoachActionKind.updateInvestment => l10n.aiActionUpdateInvestmentTitle,
    };
    final showsChanges =
        action.kind == CoachActionKind.update ||
        action.kind == CoachActionKind.cardSettings ||
        action.kind == CoachActionKind.updatePlan ||
        action.kind == CoachActionKind.updateInvestment;
    final amount = switch (action.kind) {
      CoachActionKind.cardSettings ||
      CoachActionKind.updatePlan ||
      CoachActionKind.updateInvestment => '',
      // Money moving between the user's own accounts has no sign.
      CoachActionKind.payCard ||
      CoachActionKind.createPlan ||
      CoachActionKind.payPlan ||
      CoachActionKind.createInvestment ||
      CoachActionKind.tradeInvestment ||
      CoachActionKind.closePlan => action.amount.formatCurrency(
        action.currency,
      ),
      _ =>
        '${action.isIncome ? '+' : '−'}${action.amount.formatCurrency(action.currency)}',
    };

    String field(String key) => switch (key) {
      'from' => l10n.aiActionFrom,
      'to' => l10n.aiActionTo,
      'bill' => l10n.aiActionBill,
      'left_after' => l10n.aiActionLeftAfter,
      'statement_day' => l10n.cardStatementDay,
      'due_day' => l10n.cardDueDay,
      'remind' => l10n.aiActionRemindDays,
      'installments' => l10n.planInstallment,
      'premiums' => l10n.planPremium,
      'buys' => l10n.planSipFund,
      'units' => l10n.investmentUnits,
      'per_unit' => l10n.investmentPrice,
      'fee' => l10n.investmentFee,
      'symbol' => l10n.investmentSymbol,
      'price' => l10n.investmentPrice,
      'value' => l10n.investmentWorthNow,
      'sum_assured' => l10n.planSumAssured,
      'payout_at_end' => l10n.planInsurancePayout,
      'surrender_value' => l10n.planSurrenderValueLabel,
      'tax' => l10n.planTax,
      'provider' => l10n.planProvider,
      'reference' => l10n.planReference,
      'total' => l10n.planTotal,
      'term' => l10n.planTerm,
      'principal' => l10n.planPrice,
      'borrowed' => l10n.planBorrowed,
      'rate' => l10n.planRate,
      'maturity' => l10n.planMaturity,
      'payout' => l10n.planPayout,
      'auto_collect' => l10n.planAutoCollect,
      'which' => l10n.planProgress,
      'due' => l10n.aiActionDate,
      'held' => l10n.planHolding,
      'profit' => l10n.planEventMaturity,
      'left' => l10n.planLeft,
      'amount' => l10n.aiActionAmount,
      'kind' => l10n.aiActionKind,
      'title' => l10n.aiActionTitle,
      'category' => l10n.aiActionCategory,
      'account' => l10n.aiActionAccount,
      'date' => l10n.aiActionDate,
      'notes' => l10n.aiActionNotes,
      _ => key,
    };

    final details = <(String, String)>[
      for (final (key, value) in action.lines) (field(key), value),
      if (action.category != null) (l10n.aiActionCategory, action.category!),
      if (action.account != null) (l10n.aiActionAccount, action.account!),
      (l10n.aiActionDate, DateFormat.yMMMd(locale).format(action.date)),
      if (action.notes != null) (l10n.aiActionNotes, action.notes!),
    ];

    return SunriseCard(
      padding: const EdgeInsets.all(SunriseSpace.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            heading,
            style: SunriseType.label.copyWith(
              color: isDelete ? c.negative : c.accent,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  action.title,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amount,
                style: SunriseType.rowTitle.copyWith(
                  color: action.isIncome ? c.positive : c.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (showsChanges)
            for (final e in action.changes.entries)
              _Line(
                label: field(e.key),
                value:
                    '${e.value.$1.isEmpty ? '—' : e.value.$1}  →  '
                    '${e.value.$2.isEmpty ? '—' : e.value.$2}',
                emphasise: true,
              )
          else
            for (final (label, value) in details)
              _Line(label: label, value: value),
          if (isDelete) ...[
            const SizedBox(height: 6),
            Text(
              l10n.aiActionDeleteNote,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
          ],
          const SizedBox(height: 14),
          if (isDelete)
            SunriseButton.destructive(
              label: l10n.aiActionDelete,
              onPressed: onConfirm,
            )
          else
            SunriseButton(
              label: switch (action.kind) {
                CoachActionKind.add => l10n.aiActionAdd,
                CoachActionKind.payCard ||
                CoachActionKind.payPlan => l10n.aiActionPay,
                CoachActionKind.createPlan => l10n.planStart,
                CoachActionKind.createInvestment => l10n.investmentSave,
                CoachActionKind.tradeInvestment => l10n.aiActionConfirm,
                CoachActionKind.updateInvestment => l10n.investmentUpdatePrice,
                CoachActionKind.closePlan => l10n.aiActionClosePlan,
                _ => l10n.aiActionSave,
              },
              onPressed: onConfirm,
            ),
          const SizedBox(height: 8),
          SunriseButton.secondary(
            label: l10n.aiActionCancel,
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: SunriseType.body.copyWith(
                color: emphasise ? c.ink : c.body,
                fontWeight: emphasise ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
