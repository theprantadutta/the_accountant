import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/dashboard/domain/home_layout.dart';
import 'package:the_accountant/features/dashboard/providers/home_layout_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// Rearranging the home screen.
///
/// The home screen had eight blocks in a fixed order that nobody could touch,
/// which meant everyone got the same page whether or not they used budgets,
/// goals or the chart.
class HomeLayoutScreen extends ConsumerWidget {
  const HomeLayoutScreen({super.key});

  static String labelFor(HomeSection section, L10n l10n) => switch (section) {
    HomeSection.greeting => l10n.layoutSectionGreeting,
    HomeSection.accounts => l10n.layoutSectionAccounts,
    HomeSection.quickStats => l10n.layoutSectionQuickStats,
    HomeSection.quickLinks => l10n.layoutSectionQuickLinks,
    HomeSection.spendingChart => l10n.layoutSectionSpendingChart,
    HomeSection.recentTransactions => l10n.layoutSectionRecent,
    HomeSection.budgets => l10n.layoutSectionBudgets,
    HomeSection.goals => l10n.layoutSectionGoals,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final layout = ref.watch(homeLayoutProvider);
    final notifier = ref.read(homeLayoutProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.layoutTitle),
        actions: [
          if (!layout.isDefault)
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                notifier.resetToDefault();
              },
              child: Text(l10n.layoutReset),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text(
              l10n.layoutExplain,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          if (layout.visible.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _warning(l10n.layoutAllHidden),
            ),
          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: layout.order.length,
              onReorderItem: (from, to) {
                HapticFeedback.selectionClick();
                notifier.move(from, to);
              },
              itemBuilder: (context, index) {
                final section = layout.order[index];
                final shown = layout.isVisible(section);

                return Container(
                  // The key is the section's stable id rather than its position,
                  // or the list animates the wrong row after a reorder.
                  key: ValueKey(section.storedAs),
                  margin: EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: ListTile(
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.drag_handle,
                        color: AppColors.textMuted,
                      ),
                    ),
                    title: Text(
                      labelFor(section, l10n),
                      style: TextStyle(
                        color: shown
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: shown,
                      activeThumbColor: AppColors.primaryAccent,
                      onChanged: (_) {
                        HapticFeedback.selectionClick();
                        notifier.toggle(section);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _warning(String message) => Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.warning.withValues(alpha: 0.1),
      borderRadius: AppSpacing.borderRadiusLg,
      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        Icon(Icons.warning_amber, color: AppColors.warning),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
