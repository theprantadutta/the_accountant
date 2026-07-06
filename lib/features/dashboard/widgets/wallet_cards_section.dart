import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/dashboard/providers/balance_visibility_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart';
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
              Text('Your Accounts', style: AppTypography.titleMedium),
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
      MaterialPageRoute(builder: (context) => const WalletManagementScreen()),
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
    // Balances/limits are integer cents; display works in major-unit dollars.
    final balance = (walletBalances[wallet.id] ?? wallet.balance) / 100.0;
    final isCreditCard = wallet.walletType == WalletType.creditCard;
    final creditLimit = (wallet.creditLimit ?? 0) / 100.0;
    final outstanding = isCreditCard ? balance.abs() : 0.0;
    final available = isCreditCard ? (creditLimit - outstanding) : 0.0;
    final usageRatio = isCreditCard && creditLimit > 0
        ? (outstanding / creditLimit).clamp(0.0, 1.0)
        : 0.0;

    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showEditWalletSheet(context);
      },
      child: Container(
        width: isCreditCard ? 220 : 200,
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

                    // Credit card: Outstanding + progress bar + available
                    if (isCreditCard && creditLimit > 0) ...[
                      AnimatedBuilder(
                        animation: _balanceAnimation,
                        builder: (context, child) {
                          final animOutstanding =
                              outstanding * _balanceAnimation.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isVisible
                                    ? _formatCurrency(
                                        animOutstanding,
                                        wallet.currency,
                                        wallet.useDecimals,
                                      )
                                    : '${CurrencyInfo.getSymbol(wallet.currency)} ****',
                                style: AppTypography.monoMedium.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Usage progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: usageRatio * _balanceAnimation.value,
                                  backgroundColor: walletColor.withValues(
                                    alpha: 0.15,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    usageRatio > 0.8
                                        ? AppColors.error
                                        : walletColor,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (isVisible)
                                Text(
                                  'Available: ${_formatCurrency(available * _balanceAnimation.value, wallet.currency, wallet.useDecimals)}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                                )
                              else
                                Text(
                                  'Available: ****',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ] else ...[
                      // Standard balance display
                      AnimatedBuilder(
                        animation: _balanceAnimation,
                        builder: (context, child) {
                          final animatedBalance =
                              balance * _balanceAnimation.value;
                          return Text(
                            isVisible
                                ? _formatCurrency(
                                    animatedBalance,
                                    wallet.currency,
                                    wallet.useDecimals,
                                  )
                                : '${CurrencyInfo.getSymbol(wallet.currency)} ****',
                            style: AppTypography.monoMedium.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          );
                        },
                      ),
                    ],
                    AppSpacing.gapXs,

                    // Type badge + currency
                    Row(
                      children: [
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
                        if (wallet.walletType != WalletType.cash) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.glassWhite,
                              borderRadius: AppSpacing.borderRadiusSm,
                            ),
                            child: Text(
                              _walletTypeLabel(wallet.walletType),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ],
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

  void _showEditWalletSheet(BuildContext context) {
    final wallet = widget.wallet;
    final editNameController = TextEditingController(text: wallet.name);
    final editBalanceController = TextEditingController(
      text: (wallet.balance / 100.0).toStringAsFixed(2),
    );
    final editFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AddWalletForm(
                  formKey: editFormKey,
                  nameController: editNameController,
                  balanceController: editBalanceController,
                  initialCurrency: wallet.currency,
                  initialIcon: wallet.iconName,
                  initialColor: wallet.color,
                  initialIsDefault: wallet.isDefault,
                  initialUseDecimals: wallet.useDecimals,
                  initialWalletType: wallet.walletType,
                  initialCreditLimit: wallet.creditLimit == null
                      ? null
                      : wallet.creditLimit! / 100.0,
                  initialBillingCycleDay: wallet.billingCycleDay,
                  isEditing: true,
                  onSubmit:
                      ({
                        required String currency,
                        required String icon,
                        required String color,
                        required bool isDefault,
                        required bool useDecimals,
                        required WalletType walletType,
                        required double? creditLimit,
                        required int? billingCycleDay,
                      }) {
                        ref
                            .read(walletProvider.notifier)
                            .updateWallet(
                              id: wallet.id,
                              name: editNameController.text,
                              currency: currency,
                              balance: editBalanceController.text
                                  .toCentsOrNull(),
                              iconName: icon,
                              color: color,
                              isDefault: isDefault,
                              useDecimals: useDecimals,
                              creditLimit: creditLimit == null
                                  ? null
                                  : (creditLimit * 100).round(),
                              billingCycleDay: billingCycleDay,
                            );
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Account updated successfully'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                  onCancel: () => Navigator.pop(sheetContext),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _walletTypeLabel(WalletType type) {
    switch (type) {
      case WalletType.bankAccount:
        return 'Bank';
      case WalletType.creditCard:
        return 'Credit';
      case WalletType.subscription:
        return 'Subs';
      case WalletType.cash:
        return 'Cash';
    }
  }

  String _formatCurrency(double amount, String currencyCode, bool useDecimals) {
    final symbol = CurrencyInfo.getSymbol(currencyCode);
    final nf = ref.watch(numberFormatSettingProvider);
    final formatter = AppNumberFormatter.get(nf, useDecimals: useDecimals);
    final displayAmount = useDecimals ? amount.abs() : amount.abs().round();
    final formatted = formatter.format(displayAmount);
    final sign = amount < 0 ? '-' : '';
    return '$sign$symbol$formatted';
  }
}

/// Visibility toggle button
class _VisibilityToggle extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const _VisibilityToggle({required this.isVisible, required this.onTap});

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
          gradient: AppColors.accentCardGradient,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: AppColors.primaryAccent.withValues(alpha: 0.3),
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
