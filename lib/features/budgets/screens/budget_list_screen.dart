import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/budgets/screens/add_budget_screen.dart';
import 'package:the_accountant/features/budgets/screens/budget_detail_screen.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/shared/widgets/budget_progress.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

/// Every budget, with what each has consumed this period.
///
/// Budgets used to be create-only here: there was no way to edit, delete or
/// archive one from anywhere in the app, though the methods to do so existed.
class BudgetListScreen extends ConsumerStatefulWidget {
  const BudgetListScreen({super.key});

  @override
  ConsumerState<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends ConsumerState<BudgetListScreen> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetProvider);
    final currency = ref.watch(defaultCurrencyProvider);

    final visible = budgetState.budgets
        .where((b) => _showArchived ? b.isArchived : !b.isArchived)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_showArchived ? 'Archived budgets' : 'Budgets'),
        actions: [
          IconButton(
            tooltip: _showArchived ? 'Show active' : 'Show archived',
            icon: Icon(
              _showArchived ? Icons.inbox_outlined : Icons.archive_outlined,
            ),
            onPressed: () => setState(() => _showArchived = !_showArchived),
          ),
          IconButton(
            tooltip: L10n.of(context).budgetNew,
            icon: const Icon(Icons.add),
            onPressed: _createBudget,
          ),
        ],
      ),
      body: budgetState.isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ShimmerBudgetItem(),
                  ShimmerBudgetItem(),
                  ShimmerBudgetItem(),
                ],
              ),
            )
          : visible.isEmpty
          ? _EmptyBudgets(
              archived: _showArchived,
              onCreate: _showArchived ? null : _createBudget,
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(budgetProvider.notifier).loadBudgets(silent: true),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final budget = visible[index];
                  return _BudgetRow(
                    key: ValueKey(budget.id),
                    budget: budget,
                    currency: currency,
                    onOpen: () => _openBudget(budget),
                    onMenu: () => _showActions(budget),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _createBudget() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddBudgetScreen()),
    );
  }

  Future<void> _openBudget(BudgetView budget) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BudgetDetailScreen(budgetId: budget.id),
      ),
    );
  }

  Future<void> _editBudget(BudgetView budget) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddBudgetScreen(budget: budget)),
    );
  }

  Future<void> _showActions(BudgetView budget) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(L10n.of(context).actionEdit),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: Icon(
                budget.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              title: Text(budget.isPinned ? 'Unpin' : 'Pin to top'),
              onTap: () => Navigator.pop(context, 'pin'),
            ),
            ListTile(
              leading: Icon(
                budget.isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
              ),
              title: Text(budget.isArchived ? 'Restore' : 'Archive'),
              subtitle: Text(
                budget.isArchived
                    ? 'Start counting it again'
                    : 'Keep its history, stop counting it',
              ),
              onTap: () => Navigator.pop(context, 'archive'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                L10n.of(context).actionDelete,
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    final notifier = ref.read(budgetProvider.notifier);

    switch (action) {
      case 'edit':
        await _editBudget(budget);
      case 'pin':
        await notifier.setPinned(budget.id, !budget.isPinned);
      case 'archive':
        await notifier.setArchived(budget.id, !budget.isArchived);
      case 'delete':
        final confirmed = await showConfirmationDialog(
          context: context,
          title: L10n.of(context).budgetDeleteTitle(budget.name),
          message:
              'The budget goes, your transactions stay. Nothing you have '
              'recorded is removed.',
          confirmText: L10n.of(context).actionDelete,
          isDangerous: true,
        );
        if (confirmed == true) await notifier.deleteBudget(budget.id);
    }
  }
}

/// One row: the card, fed by the engine.
class _BudgetRow extends ConsumerWidget {
  final BudgetView budget;
  final String currency;
  final VoidCallback onOpen;
  final VoidCallback onMenu;

  const _BudgetRow({
    super.key,
    required this.budget,
    required this.currency,
    required this.onOpen,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = BudgetEngine(ref.watch(databaseProvider));

    return FutureBuilder<BudgetProgress>(
      future: engine.progressFor(budget),
      builder: (context, snapshot) {
        final progress = snapshot.data;
        if (progress == null) return const ShimmerBudgetItem();
        return BudgetProgressCard(
          progress: progress,
          currency: currency,
          onTap: onOpen,
          onLongPress: onMenu,
        );
      },
    );
  }
}

class _EmptyBudgets extends StatelessWidget {
  final bool archived;
  final VoidCallback? onCreate;

  const _EmptyBudgets({required this.archived, this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                shape: BoxShape.circle,
              ),
              child: Icon(
                archived ? Icons.archive_outlined : Icons.pie_chart_outline,
                size: 40,
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapXl,
            Text(
              archived ? 'Nothing archived' : 'No budgets yet',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              archived
                  ? 'Budgets you archive are kept here.'
                  : 'Set a limit for a category and see how the month is going.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            if (onCreate != null) ...[
              AppSpacing.gapXl,
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: Text(L10n.of(context).budgetCreate),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
