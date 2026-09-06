import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/objectives/screens/objective_detail_screen.dart';
import 'package:the_accountant/features/objectives/screens/objectives_list_screen.dart';

/// Goals the user chose to keep in front of them.
///
/// Only pinned ones, and nothing at all when none are pinned: a goal is a
/// long, slow thing, and a dashboard that lists every one of them buries the
/// figures people open the app to check.
class PinnedGoalsSection extends ConsumerWidget {
  const PinnedGoalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = ref.watch(pinnedObjectivesProvider);
    final currency = ref.watch(defaultCurrencyProvider);

    final goals =
        pinned.asData?.value.where((o) => o.isGoal && !o.isArchived).toList() ??
        const [];

    if (goals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  L10n.of(context).settingsGoals,
                  style: AppTypography.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ObjectivesListScreen(),
                  ),
                ),
                child: Text(L10n.of(context).txAll),
              ),
            ],
          ),
        ),
        AppSpacing.gapSm,
        for (final goal in goals)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ObjectiveCard(
              objective: goal,
              currency: currency,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ObjectiveDetailScreen(objectiveId: goal.objective.id),
                  ),
                );
                ref.invalidate(pinnedObjectivesProvider);
              },
            ),
          ),
      ],
    );
  }
}
