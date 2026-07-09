import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/widgets/premium_gate.dart';

/// Gated sync settings screen that requires premium subscription
class SyncSettingsScreenGated extends ConsumerWidget {
  const SyncSettingsScreenGated({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumGate(
      featureId: PremiumFeatureIds.cloudSync,
      featureName: 'Cloud Sync',
      featureDescription:
          'Keep your financial data synchronized across all your devices. Never lose your data again.',
      featureIcon: Icons.sync,
      child: const SyncSettingsScreen(),
    );
  }
}

class SyncSettingsScreen extends ConsumerStatefulWidget {
  const SyncSettingsScreen({super.key});

  @override
  ConsumerState<SyncSettingsScreen> createState() => _SyncSettingsScreenState();
}

class _SyncSettingsScreenState extends ConsumerState<SyncSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncNotifierProvider);
    final isSyncing = ref.watch(isSyncingProvider);
    final lastResult = ref.read(syncNotifierProvider.notifier).lastResult;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cloud Sync'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          // SYNC STATUS
          _buildSyncStatusCard(syncState, lastResult),
          SizedBox(height: AppSpacing.lg),

          // ACTIONS
          _buildSectionHeader('ACTIONS'),
          SizedBox(height: AppSpacing.sm),
          _buildSettingsCard([_buildSyncNowTile(isSyncing)]),
          SizedBox(height: AppSpacing.lg),

          // INFO
          _buildSectionHeader('INFO'),
          SizedBox(height: AppSpacing.sm),
          _buildInfoCard(),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(
    SyncOperationState syncState,
    SyncResult? lastResult,
  ) {
    final statusInfo = _getSyncStatusInfo(syncState);

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'SYNC STATUS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // Status row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusInfo.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: syncState == SyncOperationState.syncing
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: statusInfo.color,
                        ),
                      )
                    : Icon(statusInfo.icon, color: statusInfo.color, size: 24),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusInfo.label,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (lastResult != null && lastResult.success) ...[
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        _formatLastSyncTime(lastResult.duration),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (lastResult != null &&
                        !lastResult.success &&
                        lastResult.error != null) ...[
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        lastResult.error!,
                        style: TextStyle(color: AppColors.error, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Last sync counts
          if (lastResult != null && lastResult.success) ...[
            SizedBox(height: AppSpacing.md),
            Divider(color: AppColors.divider, height: 1),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _buildCountChip(
                  Icons.cloud_upload_outlined,
                  'Pushed ${lastResult.pushedCount}',
                  AppColors.primaryAccent,
                ),
                SizedBox(width: AppSpacing.md),
                _buildCountChip(
                  Icons.cloud_download_outlined,
                  'Pulled ${lastResult.pulledCount}',
                  AppColors.neonCyan,
                ),
                if (lastResult.conflictCount > 0) ...[
                  SizedBox(width: AppSpacing.md),
                  _buildCountChip(
                    Icons.warning_amber_rounded,
                    '${lastResult.conflictCount} conflicts',
                    AppColors.warning,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncNowTile(bool isSyncing) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: isSyncing
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryAccent,
                ),
              )
            : Icon(Icons.sync, color: AppColors.primaryAccent, size: 22),
      ),
      title: Text(
        'Sync Now',
        style: TextStyle(
          color: isSyncing ? AppColors.textMuted : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isSyncing ? 'Syncing...' : 'Push and pull all changes',
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      onTap: isSyncing
          ? null
          : () async {
              HapticFeedback.mediumImpact();
              final result = await ref
                  .read(syncNotifierProvider.notifier)
                  .syncAll();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result.success
                        ? 'Sync complete — pushed ${result.pushedCount}, pulled ${result.pulledCount}'
                        : 'Sync failed: ${result.error}',
                  ),
                  backgroundColor: result.success
                      ? AppColors.success
                      : AppColors.error,
                ),
              );
            },
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.info, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Your data syncs automatically every 15 minutes and when you open the app. '
              'All synced data is encrypted in transit.',
              style: TextStyle(
                color: AppColors.info,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _SyncStatusInfo _getSyncStatusInfo(SyncOperationState state) {
    switch (state) {
      case SyncOperationState.syncing:
        return _SyncStatusInfo(
          icon: Icons.sync,
          label: 'Syncing...',
          color: AppColors.primaryAccent,
        );
      case SyncOperationState.success:
        return _SyncStatusInfo(
          icon: Icons.check_circle_outline,
          label: 'Synced',
          color: AppColors.success,
        );
      case SyncOperationState.error:
        return _SyncStatusInfo(
          icon: Icons.error_outline,
          label: 'Sync Error',
          color: AppColors.error,
        );
      case SyncOperationState.offline:
        return _SyncStatusInfo(
          icon: Icons.cloud_off_outlined,
          label: 'Offline',
          color: AppColors.warning,
        );
      case SyncOperationState.idle:
        return _SyncStatusInfo(
          icon: Icons.cloud_done_outlined,
          label: 'Ready',
          color: AppColors.textMuted,
        );
    }
  }

  String _formatLastSyncTime(Duration duration) {
    if (duration.inSeconds < 60) {
      return 'Completed in ${duration.inSeconds}s';
    }
    return 'Completed in ${duration.inMinutes}m ${duration.inSeconds % 60}s';
  }
}

class _SyncStatusInfo {
  final IconData icon;
  final String label;
  final Color color;

  _SyncStatusInfo({
    required this.icon,
    required this.label,
    required this.color,
  });
}
