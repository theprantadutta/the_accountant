import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

class SubscriptionDashboardScreen extends ConsumerWidget {
  const SubscriptionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionDashboardProvider);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Subscriptions', style: AppTypography.headlineSmall),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(subscriptionDashboardProvider.notifier).refresh(),
                child: state.subscriptions.isEmpty
                    ? _buildEmptyState()
                    : ListView(
                        padding: AppSpacing.paddingScreen,
                        children: [
                          // Summary header
                          _buildSummaryCard(state),
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
            'No subscriptions',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Add subscription transactions with recurring configs to track them here',
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

  Widget _buildSummaryCard(SubscriptionDashboardState state) {
    final monthlyFormat = NumberFormat.currency(symbol: '\$');

    return GlassCard(
      padding: AppSpacing.paddingLg,
      variant: GlassCardVariant.purple,
      child: Column(
        children: [
          // Monthly cost
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.subscriptions_rounded,
                color: AppColors.primaryAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Monthly Cost',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          Text(
            monthlyFormat.format(state.totalMonthlyCost),
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapXs,
          Text(
            '${monthlyFormat.format(state.totalYearlyCost)} / year',
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
    final dateFormat = DateFormat('MMM d, yyyy');
    final walletCurrency = ref.watch(walletCurrencyProvider(item.walletId));
    final symbol = CurrencyInfo.getSymbol(walletCurrency);
    final isPaused = !item.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: AppSpacing.paddingMd,
        variant: isPaused ? GlassCardVariant.standard : GlassCardVariant.purple,
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        (isPaused
                                ? AppColors.textMuted
                                : AppColors.primaryAccent)
                            .withValues(alpha: 0.2),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    Icons.subscriptions_rounded,
                    color: isPaused
                        ? AppColors.textMuted
                        : AppColors.primaryAccent,
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
                              'Next: ${dateFormat.format(item.nextPayment)}',
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
                      '$symbol${NumberFormat('#,##0.00').format(item.amount)}',
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
              'Cancel Subscription',
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
            child: const Text(
              'Cancel Subscription',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
