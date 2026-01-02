import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/dashboard/providers/balance_visibility_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';

/// Horizontal scrollable wallet cards section for dashboard
class WalletCardsSection extends ConsumerWidget {
  const WalletCardsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);
    final wallets = walletState.wallets;

    if (walletState.isLoading) {
      return SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryAccent,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Accounts',
                style: AppTypography.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletManagementScreen(),
                    ),
                  );
                },
                child: Text(
                  'Manage',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapMd,

        // Horizontal scrollable wallet cards
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wallets.length + 1, // +1 for add button
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            itemBuilder: (context, index) {
              if (index == wallets.length) {
                // Add Account card at the end
                return _AddAccountCard(
                  onTap: () => _showAddWalletDialog(context, ref),
                );
              }
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.md),
                child: _WalletCard(wallet: wallets[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WalletManagementScreen(),
      ),
    );
  }
}

/// Individual wallet card widget
class _WalletCard extends ConsumerStatefulWidget {
  final Wallet wallet;

  const _WalletCard({required this.wallet});

  @override
  ConsumerState<_WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends ConsumerState<_WalletCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _balanceAnimation;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _balanceAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_animationStarted) {
      _animationStarted = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.wallet;
    final walletColor = WalletColors.parseColor(wallet.color);
    final isVisible = ref.watch(walletBalanceVisibleProvider(wallet.id));
    final walletBalances = ref.watch(walletProvider).walletBalances;
    final balance = walletBalances[wallet.id] ?? wallet.balance;

    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Could navigate to wallet details
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              walletColor.withValues(alpha: 0.3),
              walletColor.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: walletColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: walletColor.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppSpacing.borderRadiusLg,
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -30,
                bottom: -30,
                child: Icon(
                  WalletIcons.getIcon(wallet.iconName),
                  size: 120,
                  color: walletColor.withValues(alpha: 0.1),
                ),
              ),

              // Content
              Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with icon and visibility toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: walletColor.withValues(alpha: 0.2),
                            borderRadius: AppSpacing.borderRadiusMd,
                          ),
                          child: Icon(
                            WalletIcons.getIcon(wallet.iconName),
                            color: walletColor,
                            size: 22,
                          ),
                        ),
                        _VisibilityToggle(
                          isVisible: isVisible,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(balanceVisibilityProvider.notifier)
                                .toggleVisibility(wallet.id);
                          },
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Wallet name
                    Text(
                      wallet.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,

                    // Balance
                    AnimatedBuilder(
                      animation: _balanceAnimation,
                      builder: (context, child) {
                        final animatedBalance =
                            balance * _balanceAnimation.value;
                        return Text(
                          isVisible
                              ? _formatCurrency(animatedBalance, wallet.currency)
                              : '${CurrencyInfo.getSymbol(wallet.currency)} ****',
                          style: AppTypography.monoMedium.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),
                    AppSpacing.gapXs,

                    // Currency badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: walletColor.withValues(alpha: 0.2),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Text(
                        wallet.currency,
                        style: AppTypography.labelSmall.copyWith(
                          color: walletColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Default badge
              if (wallet.isDefault)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm + 36, // Position before visibility icon
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.warning,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount, String currencyCode) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final formatted = NumberFormat('#,##0.00').format(amount.abs());
    final sign = amount < 0 ? '-' : '';
    return '$sign$symbol$formatted';
  }
}

/// Visibility toggle button
class _VisibilityToggle extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const _VisibilityToggle({
    required this.isVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        child: Icon(
          isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          color: AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

/// Add account card at the end of the list
class _AddAccountCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddAccountCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.15),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primaryAccent,
                size: 28,
              ),
            ),
            AppSpacing.gapMd,
            Text(
              'Add\nAccount',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
