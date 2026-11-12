import 'package:material_ui/material_ui.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/category_reconciliation_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';

/// Asks the user about categories that might already be built-ins.
///
/// This exists because the app genuinely cannot tell. An account created before
/// built-in categories had stable identities has a cloud category called
/// "Groceries" with no identity attached — and there is no way to know from the
/// data whether the app created it or the user did. Guessing wrong would either
/// leave the account with two "Groceries", or quietly absorb a category the user
/// made themselves, taking its transactions with it.
///
/// So the app asks once, plainly, and shows how much history is attached to each
/// candidate — which is the fact that actually makes the answer obvious to the
/// person looking at it.
class CategoryReconciliationCard extends ConsumerWidget {
  const CategoryReconciliationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoryReconciliationsProvider);
    final items =
        async.asData?.value ?? const <PendingCategoryReconciliation>[];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: Text(
            L10n.of(context).settingsNeedsYourConfirmation,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        for (final item in items) ...[
          _ReconciliationTile(item: item),
          SizedBox(height: AppSpacing.sm),
        ],
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _ReconciliationTile extends ConsumerWidget {
  final PendingCategoryReconciliation item;

  const _ReconciliationTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.warning, size: 20),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  L10n.of(context).settingsReconcileQuestion(item.catalogName),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            item.isAwaitingSync
                ? L10n.of(context).settingsReconcileSavedPending
                : L10n.of(context).settingsReconcileBody(
                    item.candidates.length,
                    item.catalogName,
                  ),
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          SizedBox(height: AppSpacing.md),
          if (item.isAwaitingSync)
            _PendingDecision(item: item)
          else ...[
            for (final candidate in item.candidates)
              _CandidateRow(item: item, candidate: candidate),
            SizedBox(height: AppSpacing.xs),
            TextButton.icon(
              onPressed: () => _keepSeparate(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                item.candidates.length == 1
                    ? L10n.of(context).settingsReconcileKeepMine
                    : L10n.of(context).settingsReconcileNoneOfThese,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _keepSeparate(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      title: L10n.of(context).settingsKeepThemSeparate,
      body: L10n.of(context).settingsReconcileKeepSeparateBody(
        item.candidates.length,
        item.catalogName,
      ),
      action: L10n.of(context).settingsReconcileKeepSeparate,
    );
    if (!confirmed) return;
    await ref
        .read(categoryReconciliationServiceProvider)
        .keepSeparate(defaultKey: item.defaultKey);
  }
}

class _CandidateRow extends ConsumerWidget {
  final PendingCategoryReconciliation item;
  final LegacyCategoryCandidate candidate;

  const _CandidateRow({required this.item, required this.candidate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = candidate.transactionCount;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  L10n.of(context).settingsReconcileTransactionCount(count),
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _adopt(context, ref),
            child: Text(L10n.of(context).settingsYesUseThis),
          ),
        ],
      ),
    );
  }

  Future<void> _adopt(BuildContext context, WidgetRef ref) async {
    final count = candidate.transactionCount;
    final confirmed = await _confirm(
      context,
      title: L10n.of(context).settingsReconcileUseTitle(candidate.name),
      body: L10n.of(context).settingsReconcileUseBody(count, item.catalogName),
      action: L10n.of(context).settingsReconcileUseThisOne,
    );
    if (!confirmed) return;
    await ref
        .read(categoryReconciliationServiceProvider)
        .adoptExisting(defaultKey: item.defaultKey, candidateId: candidate.id);
  }
}

class _PendingDecision extends ConsumerWidget {
  final PendingCategoryReconciliation item;

  const _PendingDecision({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adopted =
        item.resolutionKind == CategoryReconciliationKinds.adoptLegacy;
    final chosen = adopted
        ? item.candidates
              .where((c) => c.id == item.resolutionCandidateId)
              .map((c) => c.name)
              .firstOrNull
        : null;

    return Row(
      children: [
        Icon(Icons.schedule, size: 16, color: AppColors.textMuted),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            adopted
                ? L10n.of(
                    context,
                  ).settingsReconcileWillUse(chosen ?? item.catalogName)
                : L10n.of(context).settingsReconcileWillAdd(item.catalogName),
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        TextButton(
          onPressed: () => ref
              .read(categoryReconciliationServiceProvider)
              .undo(defaultKey: item.defaultKey),
          child: Text(L10n.of(context).importChange),
        ),
      ],
    );
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(L10n.of(context).actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );
  return result ?? false;
}
