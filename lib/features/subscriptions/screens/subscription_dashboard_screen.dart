import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/features/subscriptions/widgets/edit_subscription_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

class SubscriptionDashboardScreen extends ConsumerWidget {
  const SubscriptionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionDashboardProvider);

    return Container(
      decoration: const BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            L10n.of(context).subRecurring,
            style: AppTypography.headlineSmall,
          ),
          leading: IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const BackButtonIcon(),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showAddTransactionScreen(context);
            if (result == true) {
              ref.read(subscriptionDashboardProvider.notifier).refresh();
            }
          },
          backgroundColor: AppColors.primaryAccent,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: CappedBody(
          child: state.isLoading
              ? const SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ShimmerCard(height: 100),
                      SizedBox(height: 12),
                      ShimmerCard(height: 100),
                      SizedBox(height: 12),
                      ShimmerCard(height: 100),
                      SizedBox(height: 12),
                      ShimmerCard(height: 100),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref
                      .read(subscriptionDashboardProvider.notifier)
                      .refresh(),
                  child: state.subscriptions.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          padding: AppSpacing.paddingScreen,
                          children: [
                            // Summary header
                            _buildSummaryCard(state, ref),
                            AppSpacing.gapLg,

                            // Active subscriptions
                            if (state.activeSubscriptions.isNotEmpty) ...[
                              Text(
                                'Active (${state.activeCount})',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.gapSm,
                              ...state.activeSubscriptions.map(
                                (s) => _SubscriptionCard(
                                  item: s,
                                  key: ValueKey(s.id),
                                ),
                              ),
                            ],

                            // Paused subscriptions
                            if (state.pausedSubscriptions.isNotEmpty) ...[
                              AppSpacing.gapLg,
                              Text(
                                'Paused (${state.pausedSubscriptions.length})',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              AppSpacing.gapSm,
                              ...state.pausedSubscriptions.map(
                                (s) => _SubscriptionCard(
                                  item: s,
                                  key: ValueKey(s.id),
                                ),
                              ),
                            ],

                            // Bottom spacing
                            const SizedBox(height: 32),
                          ],
                        ),
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() => const Center(
    child: EmptyState(
      icon: Symbols.autorenew_rounded,
      title: 'No subscriptions or bills',
      message:
          'Add subscription or recurring bill transactions to track them here',
    ),
  );

  Widget _buildSummaryCard(SubscriptionDashboardState state, WidgetRef ref) {
    final monthlyFormat = AppNumberFormatter.currency(
      CurrencyInfo.getSymbol(state.currency),
      ref.watch(numberFormatSettingProvider),
    );

    return GlassCard(
      padding: AppSpacing.paddingLg,
      variant: GlassCardVariant.standard,
      child: Column(
        children: [
          // Monthly cost
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.autorenew, color: AppColors.primaryAccent, size: 24),
              const SizedBox(width: 8),
              Text(
                'Recurring Cost',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          Text(
            monthlyFormat.format(state.totalMonthlyCost / 100.0),
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapXs,
          Text(
            '${monthlyFormat.format(state.totalYearlyCost / 100.0)} / year',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapLg,
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Active',
                '${state.activeCount}',
                AppColors.success,
              ),
              Container(width: 1, height: 30, color: AppColors.glassBorder),
              _buildStatItem(
                'Paused',
                '${state.pausedSubscriptions.length}',
                AppColors.textMuted,
              ),
              Container(width: 1, height: 30, color: AppColors.glassBorder),
              _buildStatItem(
                'Total',
                '${state.subscriptions.length}',
                AppColors.primaryAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _SubscriptionCard extends ConsumerWidget {
  final SubscriptionItem item;

  const _SubscriptionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = ref.watch(dateFormatSettingProvider);
    final walletCurrency = ref.watch(walletCurrencyProvider(item.walletId));
    final symbol = CurrencyInfo.getSymbol(walletCurrency);
    final isPaused = !item.isActive;
    final isRepetitive = item.specialType == TransactionSpecialType.repetitive;
    final accentColor = isRepetitive
        ? AppColors.neonBlue
        : AppColors.primaryAccent;
    final cardIcon = isRepetitive ? Icons.repeat : Icons.subscriptions_rounded;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: AppSpacing.paddingMd,
        variant: GlassCardVariant.standard,
        onTap: () async {
          final result = await showEditSubscriptionBottomSheet(
            context,
            item: item,
          );
          if (result == true) {
            ref.read(subscriptionDashboardProvider.notifier).refresh();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isPaused ? AppColors.textMuted : accentColor)
                    .withValues(alpha: 0.2),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                cardIcon,
                color: isPaused ? AppColors.textMuted : accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // The name gets the width and may take two lines. It used to be
            // one line between a fixed icon and the amount, so on a 360dp
            // phone most names ended in "…".
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: AppTypography.titleSmall.copyWith(
                            color: isPaused
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * .34,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topRight,
                          child: Text(
                            '$symbol${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(item.amount / 100.0)}',
                            style: AppTypography.titleMedium.copyWith(
                              color: isPaused
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      item.frequencyText,
                      if (isPaused)
                        L10n.of(context).subPaused
                      else
                        'Next ${AppDateFormatter.formatDate(item.nextPayment, df)}',
                      if (!item.autoPay) L10n.of(context).subAsksFirst,
                    ].join(' · '),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Pause and cancel are occasional, so they live in a menu rather
            // than as two full-width buttons on every card.
            PopupMenuButton<String>(
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, color: AppColors.textMuted),
              onSelected: (action) {
                final notifier = ref.read(
                  subscriptionDashboardProvider.notifier,
                );
                switch (action) {
                  case 'pause':
                    HapticFeedback.lightImpact();
                    isPaused
                        ? notifier.resumeSubscription(item.id)
                        : notifier.pauseSubscription(item.id);
                  case 'cancel':
                    HapticFeedback.mediumImpact();
                    _showCancelConfirmation(context, ref);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'pause',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                    title: Text(isPaused ? 'Resume' : 'Pause'),
                  ),
                ),
                PopupMenuItem(
                  value: 'cancel',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.cancel_outlined,
                      color: AppColors.error,
                    ),
                    title: Text(
                      L10n.of(context).actionCancel,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.cancel_outlined,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              item.specialType == TransactionSpecialType.repetitive
                  ? 'Cancel Recurring Bill'
                  : 'Cancel Subscription',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel "${item.name}"? This will stop all future recurring payments.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              L10n.of(context).backupKeep,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(subscriptionDashboardProvider.notifier)
                  .cancelSubscription(item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${item.name}" cancelled'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              item.specialType == TransactionSpecialType.repetitive
                  ? 'Cancel Recurring Bill'
                  : 'Cancel Subscription',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
