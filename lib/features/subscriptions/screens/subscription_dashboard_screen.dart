import 'package:flutter/material.dart';
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
          title: Text('Recurring', style: AppTypography.headlineSmall),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
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
        body: state.isLoading
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
                onRefresh: () =>
                    ref.read(subscriptionDashboardProvider.notifier).refresh(),
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 80,
            color: AppColors.textMuted,
          ),
          AppSpacing.gapLg,
          Text(
            'No subscriptions or bills',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Add subscription or recurring bill transactions to track them here',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(SubscriptionDashboardState state, WidgetRef ref) {
    final monthlyFormat = AppNumberFormatter.currency(
      '\$',
      ref.watch(numberFormatSettingProvider),
    );

    return GlassCard(
      padding: AppSpacing.paddingLg,
      variant: GlassCardVariant.purple,
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
        variant: isPaused
            ? GlassCardVariant.standard
            : (isRepetitive
                  ? GlassCardVariant.standard
                  : GlassCardVariant.purple),
        onTap: () async {
          final result = await showEditSubscriptionBottomSheet(
            context,
            item: item,
          );
          if (result == true) {
            ref.read(subscriptionDashboardProvider.notifier).refresh();
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isPaused ? AppColors.textMuted : accentColor)
                        .withValues(alpha: 0.2),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    cardIcon,
                    color: isPaused ? AppColors.textMuted : accentColor,
                    size: 22,
                  ),
                ),
                AppSpacing.gapHMd,
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTypography.titleSmall.copyWith(
                                color: isPaused
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPaused)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textMuted.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: AppSpacing.borderRadiusSm,
                              ),
                              child: Text(
                                'Paused',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      AppSpacing.gapXs,
                      Row(
                        children: [
                          // Frequency
                          Text(
                            item.frequencyText,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Next payment
                          if (item.isActive) ...[
                            Icon(
                              Icons.calendar_today,
                              size: 10,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Next: ${AppDateFormatter.formatDate(item.nextPayment, df)}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$symbol${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(item.amount / 100.0)}',
                      style: AppTypography.titleMedium.copyWith(
                        color: isPaused
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.frequencyText,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Actions
            AppSpacing.gapMd,
            Row(
              children: [
                // Pause/Resume button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (isPaused) {
                        ref
                            .read(subscriptionDashboardProvider.notifier)
                            .resumeSubscription(item.id);
                      } else {
                        ref
                            .read(subscriptionDashboardProvider.notifier)
                            .pauseSubscription(item.id);
                      }
                    },
                    icon: Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                      size: 16,
                    ),
                    label: Text(isPaused ? 'Resume' : 'Pause'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Cancel button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showCancelConfirmation(context, ref);
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
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
        backgroundColor: AppColors.primarySurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              'Keep',
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
