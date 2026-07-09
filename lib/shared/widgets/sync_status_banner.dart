import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';

/// A subtle, non-blocking pill that floats at the top of the dashboard to show
/// background/periodic sync activity. Shows "Syncing…" while a sync runs and a
/// brief "Synced" confirmation on success. Stays silent on failure/offline so
/// background syncs never nag the user.
class SyncStatusBanner extends ConsumerStatefulWidget {
  const SyncStatusBanner({super.key});

  @override
  ConsumerState<SyncStatusBanner> createState() => _SyncStatusBannerState();
}

class _SyncStatusBannerState extends ConsumerState<SyncStatusBanner> {
  bool _showSynced = false;
  Timer? _syncedTimer;

  @override
  void dispose() {
    _syncedTimer?.cancel();
    super.dispose();
  }

  void _flashSynced() {
    _syncedTimer?.cancel();
    setState(() => _showSynced = true);
    _syncedTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _showSynced = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Briefly confirm "Synced" when a sync transitions from running -> success.
    ref.listen<SyncOperationState>(syncNotifierProvider, (previous, next) {
      if (previous == SyncOperationState.syncing &&
          next == SyncOperationState.success) {
        _flashSynced();
      }
    });

    final isSyncing =
        ref.watch(syncNotifierProvider) == SyncOperationState.syncing;
    final visible = isSyncing || _showSynced;

    return IgnorePointer(
      child: AnimatedSlide(
        duration: AppAnimations.normal,
        curve: AppAnimations.easeOut,
        offset: visible ? Offset.zero : const Offset(0, -1.5),
        child: AnimatedOpacity(
          duration: AppAnimations.normal,
          opacity: visible ? 1 : 0,
          child: _pill(isSyncing),
        ),
      ),
    );
  }

  Widget _pill(bool isSyncing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryElevated.withValues(alpha: 0.95),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSyncing)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryAccent,
                ),
              ),
            )
          else
            Icon(
              Icons.check_circle_rounded,
              size: 16,
              color: AppColors.success,
            ),
          AppSpacing.gapHSm,
          Text(
            isSyncing ? 'Syncing…' : 'Synced',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
