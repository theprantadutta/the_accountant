import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

/// Placeholder shown while a legal document is read from assets.
///
/// Shaped like the document it stands in for — a heading, a paragraph, a gap,
/// another paragraph — so the layout does not jump when the real text arrives.
///
/// Lived twice, character for character, in the acceptance screen and the
/// document viewer.
class LegalLoadingPlaceholder extends StatelessWidget {
  const LegalLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerCard(height: 28, width: 200),
          AppSpacing.gapLg,
          const ShimmerCard(height: 14),
          AppSpacing.gapSm,
          const ShimmerCard(height: 14),
          AppSpacing.gapSm,
          const ShimmerCard(height: 14),
          AppSpacing.gapXxl,
          const ShimmerCard(height: 14),
          AppSpacing.gapSm,
          const ShimmerCard(height: 14),
        ],
      ),
    );
  }
}
