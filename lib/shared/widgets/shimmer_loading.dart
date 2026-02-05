import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';

/// A shimmer loading placeholder card.
/// Use this to show loading state for cards in the app.
class ShimmerCard extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const ShimmerCard({
    super.key,
    this.height = 100,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySurface,
      highlightColor: AppColors.primaryElevated,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusMd,
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder for transaction list items.
class ShimmerTransactionItem extends StatelessWidget {
  const ShimmerTransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySurface,
      highlightColor: AppColors.primaryElevated,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
            ),
            const SizedBox(width: 16),
            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            // Amount placeholder
            Container(
              height: 16,
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A shimmer loading list for transactions.
class ShimmerTransactionList extends StatelessWidget {
  final int itemCount;

  const ShimmerTransactionList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => const ShimmerTransactionItem(),
      ),
    );
  }
}

/// A shimmer placeholder for stat cards (income/expense cards).
class ShimmerStatCard extends StatelessWidget {
  const ShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySurface,
      highlightColor: AppColors.primaryElevated,
      child: Container(
        padding: AppSpacing.paddingCard,
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 12,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 24,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A shimmer placeholder for wallet cards.
class ShimmerWalletCard extends StatelessWidget {
  const ShimmerWalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySurface,
      highlightColor: AppColors.primaryElevated,
      child: Container(
        width: 160,
        height: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            Container(
              height: 18,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A horizontal row of shimmer wallet cards.
class ShimmerWalletList extends StatelessWidget {
  final int itemCount;

  const ShimmerWalletList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) => const ShimmerWalletCard(),
      ),
    );
  }
}

/// A shimmer placeholder for budget progress items.
class ShimmerBudgetItem extends StatelessWidget {
  const ShimmerBudgetItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySurface,
      highlightColor: AppColors.primaryElevated,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10,
                  width: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 10,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A shimmer loading state for the entire dashboard.
class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Greeting shimmer
          _buildGreetingShimmer(),

          const SizedBox(height: 24),

          // Wallet cards shimmer
          const ShimmerWalletList(),

          const SizedBox(height: 24),

          // Stat cards shimmer
          Row(
            children: [
              const Expanded(child: ShimmerStatCard()),
              const SizedBox(width: 16),
              const Expanded(child: ShimmerStatCard()),
            ],
          ),

          const SizedBox(height: 24),

          // Chart shimmer
          const ShimmerCard(height: 220),

          const SizedBox(height: 24),

          // Recent transactions shimmer
          const ShimmerCard(height: 250),

          const SizedBox(height: 24),

          // Budget progress shimmer
          const ShimmerCard(height: 180),
        ],
      ),
    );
  }

  Widget _buildGreetingShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySurface,
      highlightColor: AppColors.primaryElevated,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryElevated,
              borderRadius: AppSpacing.borderRadiusLg,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 140,
                decoration: BoxDecoration(
                  color: AppColors.primaryElevated,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.primaryElevated,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
