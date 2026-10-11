import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

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
        offset: visible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: AppAnimations.normal,
          opacity: visible ? 1 : 0,
          child: _pill(isSyncing),
        ),
      ),
    );
  }

  Widget _pill(bool isSyncing) {
    final c = context.sunrise;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: c.chipActiveBg,
        borderRadius: BorderRadius.circular(SunriseRadius.chip),
        boxShadow: c.cardShadow,
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
                color: c.isDark ? c.accentText : c.gradientStart,
              ),
            )
          else
            Icon(
              Symbols.check_circle_rounded,
              size: 16,
              fill: 1,
              color: c.isDark ? const Color(0xFF16A34A) : const Color(0xFF4ADE80),
            ),
          const SizedBox(width: 8),
          Text(
            isSyncing ? 'Syncing…' : 'Synced',
            style: SunriseType.label.copyWith(color: c.chipActiveFg),
          ),
        ],
      ),
    );
  }
}
