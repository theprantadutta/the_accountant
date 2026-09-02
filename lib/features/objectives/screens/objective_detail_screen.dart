import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/objectives/screens/add_objective_screen.dart';
import 'package:the_accountant/features/objectives/services/objectives_service.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

/// One goal: how far along, what is left, and everything counted toward it.
class ObjectiveDetailScreen extends ConsumerWidget {
  final String objectiveId;

  const ObjectiveDetailScreen({super.key, required this.objectiveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allObjectivesProvider);
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);

    final objective = all.asData?.value
        .where((o) => o.objective.id == objectiveId)
        .firstOrNull;

    if (objective == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Goal')),
        body: all.isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Center(child: Text('This goal no longer exists.')),
      );
    }

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final tint = ColorUtils.hexToColor(objective.objective.color);
    final fraction = (objective.progressPercent / 100).clamp(0.0, 1.0);
    final dailyTarget = objective.dailyTargetCents;

    return Scaffold(
      appBar: AppBar(
        title: Text(objective.name),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddObjectiveScreen(objective: objective),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref, objective),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Opens the ordinary add form; the goal is picked there, so there is
          // one place transactions are created rather than a second one here
          // that would have to keep up with it.
          await showAddTransactionScreen(context);
          ref.invalidate(allObjectivesProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add to goal'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          GlassCard(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: tint.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        IconRegistry.getIcon(objective.objective.iconName),
                        color: tint,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            money(objective.currentAmount),
                            style: AppTypography.displaySmall,
                          ),
                          Text(
                            'of ${money(objective.targetAmount)}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapLg,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 8,
                    backgroundColor: AppColors.divider,
                    color: objective.isComplete ? AppColors.success : tint,
                  ),
                ),
                AppSpacing.gapMd,
                Text(
                  objective.isComplete
                      ? 'Reached. Nicely done.'
                      : '${money(objective.remainingAmount)} still to go.',
                  style: AppTypography.bodyMedium,
                ),
                if (!objective.isComplete && dailyTarget != null) ...[
                  AppSpacing.gapSm,
                  Text(
                    '${money(dailyTarget)} a day to arrive on time.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (objective.timeRemainingText != null) ...[
                  AppSpacing.gapSm,
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        objective.timeRemainingText!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.gapLg,

          if (!objective.isComplete)
            _PlanCard(objective: objective, currency: currency),

          GlassCard(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Counted toward this goal',
                  style: AppTypography.titleSmall,
                ),
                AppSpacing.gapSm,
                if (objective.linkedTransactions.isEmpty)
                  Text(
                    'Nothing linked yet. Pick this goal on a transaction and '
                    'it will show up here.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  )
                else
                  for (final t in objective.linkedTransactions)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.title.isEmpty ? 'Transaction' : t.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodyMedium,
                                ),
                                Text(
                                  AppDateFormatter.formatShortDate(
                                    t.date,
                                    dateFormat,
                                  ),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            money(t.amount),
                            style: AppTypography.bodyMedium,
                          ),
                          IconButton(
                            tooltip: 'Unlink',
                            icon: const Icon(Icons.link_off, size: 18),
                            onPressed: () async {
                              await ref
                                  .read(objectivesProvider.notifier)
                                  .unlinkTransaction(objectiveId, t.id);
                              ref.invalidate(allObjectivesProvider);
                            },
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ObjectiveWithProgress objective,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete ${objective.name}?',
      message:
          'The goal goes, your transactions stay. They are simply no longer '
          'counted toward it.',
      confirmText: 'Delete',
      isDangerous: true,
    );
    if (confirmed != true || !context.mounted) return;

    await ref
        .read(objectivesProvider.notifier)
        .deleteObjective(objective.objective.id);
    ref.invalidate(allObjectivesProvider);
    if (context.mounted) Navigator.pop(context);
  }
}

/// What it takes to finish: so many payments of so much.
///
/// A target on its own says nothing about whether it is achievable, which is
/// the thing someone wants to know before starting. With a deadline the payment
/// is worked out from the date; without one the user picks a payment they can
/// manage and the card says when they arrive.
class _PlanCard extends ConsumerStatefulWidget {
  final ObjectiveWithProgress objective;
  final String currency;

  const _PlanCard({required this.objective, required this.currency});

  @override
  ConsumerState<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends ConsumerState<_PlanCard> {
  InstallmentCadence _cadence = InstallmentCadence.monthly;

  @override
  Widget build(BuildContext context) {
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      widget.currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final plan = widget.objective.planForDeadline(_cadence);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Getting there', style: AppTypography.titleSmall),
            AppSpacing.gapMd,
            Wrap(
              spacing: 8,
              children: [
                for (final c in InstallmentCadence.values)
                  ChoiceChip(
                    label: Text(c.label),
                    selected: _cadence == c,
                    onSelected: (_) => setState(() => _cadence = c),
                  ),
              ],
            ),
            AppSpacing.gapMd,
            if (plan == null)
              Text(
                'Set a target date and this works out what to put aside.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              )
            else ...[
              Text(
                '${plan.payments} payments of ${money(plan.amountCents)}',
                style: AppTypography.titleMedium,
              ),
              AppSpacing.gapSm,
              Text(
                'Finishing around '
                '${AppDateFormatter.formatShortDate(plan.finishesAround, dateFormat)}.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
