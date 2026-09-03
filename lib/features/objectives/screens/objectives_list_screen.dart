import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/objectives/screens/add_objective_screen.dart';
import 'package:the_accountant/features/objectives/screens/objective_detail_screen.dart';
import 'package:the_accountant/features/objectives/services/objectives_service.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

/// Every goal, with how far along it is.
class ObjectivesListScreen extends ConsumerStatefulWidget {
  const ObjectivesListScreen({super.key});

  @override
  ConsumerState<ObjectivesListScreen> createState() =>
      _ObjectivesListScreenState();
}

class _ObjectivesListScreenState extends ConsumerState<ObjectivesListScreen> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(allObjectivesProvider);
    final currency = ref.watch(defaultCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_showArchived ? 'Archived goals' : 'Goals'),
        actions: [
          IconButton(
            tooltip: _showArchived ? 'Show active' : 'Show archived',
            icon: Icon(
              _showArchived ? Icons.inbox_outlined : Icons.archive_outlined,
            ),
            onPressed: () => setState(() => _showArchived = !_showArchived),
          ),
        ],
      ),
      floatingActionButton: _showArchived
          ? null
          : FloatingActionButton.extended(
              onPressed: _create,
              icon: const Icon(Icons.add),
              label: const Text('New goal'),
            ),
      body: switch (all) {
        AsyncData(:final value) => _body(value, currency),
        AsyncError() => const Center(child: Text('Could not load your goals.')),
        _ => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [ShimmerCard(), ShimmerCard(), ShimmerCard()],
          ),
        ),
      },
    );
  }

  Widget _body(List<ObjectiveWithProgress> all, String currency) {
    // Loans are their own thing, tracked on the Credit and Debt screen; this
    // list is about goals, so showing them here would be two answers to the
    // same question.
    final visible = all
        .where((o) => o.isGoal && o.isArchived == _showArchived)
        .toList();

    if (visible.isEmpty) {
      return _Empty(archived: _showArchived, onCreate: _create);
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(allObjectivesProvider),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        itemCount: visible.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ObjectiveCard(
            objective: visible[index],
            currency: currency,
            onTap: () => _open(visible[index]),
            onLongPress: () => _showActions(visible[index]),
          ),
        ),
      ),
    );
  }

  Future<void> _create() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddObjectiveScreen()),
    );
    ref.invalidate(allObjectivesProvider);
  }

  Future<void> _open(ObjectiveWithProgress objective) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ObjectiveDetailScreen(objectiveId: objective.objective.id),
      ),
    );
    ref.invalidate(allObjectivesProvider);
  }

  Future<void> _showActions(ObjectiveWithProgress objective) async {
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
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: Icon(
                objective.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              title: Text(
                objective.isPinned ? 'Hide from home' : 'Show on home',
              ),
              onTap: () => Navigator.pop(context, 'pin'),
            ),
            ListTile(
              leading: Icon(
                objective.isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
              ),
              title: Text(objective.isArchived ? 'Restore' : 'Archive'),
              onTap: () => Navigator.pop(context, 'archive'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    final notifier = ref.read(objectivesProvider.notifier);
    final id = objective.objective.id;

    switch (action) {
      case 'edit':
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddObjectiveScreen(objective: objective),
          ),
        );
      case 'pin':
        await notifier.togglePinned(id);
      case 'archive':
        if (objective.isArchived) {
          await notifier.unarchiveObjective(id);
        } else {
          await notifier.archiveObjective(id);
        }
    }
    ref.invalidate(allObjectivesProvider);
  }
}

/// One goal: icon, name, a bar, and what is left to put in.
class ObjectiveCard extends ConsumerWidget {
  final ObjectiveWithProgress objective;
  final String currency;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ObjectiveCard({
    super.key,
    required this.objective,
    required this.currency,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final tint = ColorUtils.hexToColor(objective.objective.color);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final fraction = (objective.progressPercent / 100).clamp(0.0, 1.0);

    return GlassCard(
      onTap: onTap,
      onLongPress: onLongPress,
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  IconRegistry.getIcon(objective.objective.iconName),
                  size: 20,
                  color: tint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      objective.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleSmall,
                    ),
                    Text(
                      '${money(objective.currentAmount)} of '
                      '${money(objective.targetAmount)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (objective.isComplete)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 22,
                ),
            ],
          ),
          AppSpacing.gapMd,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              color: objective.isComplete ? AppColors.success : tint,
            ),
          ),
          AppSpacing.gapSm,
          Row(
            children: [
              Expanded(
                child: Text(
                  objective.isComplete
                      ? 'Reached'
                      : '${money(objective.remainingAmount)} to go',
                  style: AppTypography.bodySmall.copyWith(
                    color: objective.isComplete
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              if (objective.timeRemainingText != null)
                Text(
                  objective.timeRemainingText!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final bool archived;
  final VoidCallback onCreate;

  const _Empty({required this.archived, required this.onCreate});

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
              decoration: const BoxDecoration(
                color: AppColors.glassWhite,
                shape: BoxShape.circle,
              ),
              child: Icon(
                archived ? Icons.archive_outlined : Icons.flag_outlined,
                size: 40,
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapXl,
            Text(
              archived ? 'Nothing archived' : 'No goals yet',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              archived
                  ? 'Goals you archive are kept here.'
                  : 'Name something you are saving for, then link the '
                        'transactions that go toward it.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            if (!archived) ...[
              AppSpacing.gapXl,
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Create a goal'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
