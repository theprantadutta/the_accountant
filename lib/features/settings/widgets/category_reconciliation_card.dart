import 'package:flutter/material.dart';
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
    final items = async.asData?.value ?? const <PendingCategoryReconciliation>[];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: Text(
            'NEEDS YOUR CONFIRMATION',
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
                  'Is this your "${item.catalogName}" category?',
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
                ? 'Saved. This will be applied the next time you sync.'
                : 'Your account already has '
                      '${item.candidates.length == 1 ? "a category" : "${item.candidates.length} categories"} '
                      'called "${item.catalogName}". Tell us whether to use '
                      '${item.candidates.length == 1 ? "it" : "one of them"} as the '
                      'built-in category, or keep it separate. Nothing changes '
                      'until you choose.',
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
                    ? 'No — keep mine and add a separate one'
                    : 'None of these — add a separate one',
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
      title: 'Keep them separate?',
      body:
          'Your existing "${item.catalogName}" '
          '${item.candidates.length == 1 ? "category stays" : "categories stay"} '
          'exactly as ${item.candidates.length == 1 ? "it is" : "they are"}, '
          'with all its transactions. A new built-in "${item.catalogName}" will '
          'be added alongside.',
      action: 'Keep separate',
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
                  count == 0
                      ? 'No transactions'
                      : '$count transaction${count == 1 ? "" : "s"}',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _adopt(context, ref),
            child: const Text('Yes, use this'),
          ),
        ],
      ),
    );
  }

  Future<void> _adopt(BuildContext context, WidgetRef ref) async {
    final count = candidate.transactionCount;
    final confirmed = await _confirm(
      context,
      title: 'Use "${candidate.name}"?',
      body:
          'It becomes the built-in "${item.catalogName}" category and keeps '
          '${count == 0 ? "everything filed under it" : "all $count of its transactions"}, '
          'along with its subcategories. Nothing is deleted.',
      action: 'Use this one',
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
    final adopted = item.resolutionKind == CategoryReconciliationKinds.adoptLegacy;
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
                ? 'Will use "${chosen ?? item.catalogName}".'
                : 'Will add a separate "${item.catalogName}".',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        TextButton(
          onPressed: () => ref
              .read(categoryReconciliationServiceProvider)
              .undo(defaultKey: item.defaultKey),
          child: const Text('Change'),
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
          child: const Text('Cancel'),
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
