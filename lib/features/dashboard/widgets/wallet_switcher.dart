import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';

/// Provider for the currently selected wallet in dashboard
final selectedWalletIdProvider = StateProvider<String?>((ref) => null);

/// Wallet switcher widget for dashboard
class WalletSwitcher extends ConsumerWidget {
  const WalletSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);
    final selectedWalletId = ref.watch(selectedWalletIdProvider);
    final wallets = walletState.wallets;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wallets.length + 1, // +1 for "All Wallets" option
        itemBuilder: (context, index) {
          // First item is "All Wallets"
          if (index == 0) {
            final isSelected = selectedWalletId == null;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _WalletChip(
                label: 'All Wallets',
                icon: Icons.account_balance_wallet_outlined,
                isSelected: isSelected,
                onTap: () {
                  ref.read(selectedWalletIdProvider.notifier).state = null;
                },
              ),
            );
          }

          // Wallet items
          final wallet = wallets[index - 1];
          final isSelected = selectedWalletId == wallet.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _WalletChip(
              label: wallet.name,
              icon: WalletIcons.getIcon(wallet.iconName),
              color: WalletColors.parseColor(wallet.color),
              currencyCode: wallet.currency,
              isSelected: isSelected,
              onTap: () {
                ref.read(selectedWalletIdProvider.notifier).state = wallet.id;
              },
            ),
          );
        },
      ),
    );
  }
}

class _WalletChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final String? currencyCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _WalletChip({
    required this.label,
    required this.icon,
    this.color,
    this.currencyCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryAccent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveColor.withValues(alpha: 0.2)
              : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? effectiveColor : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? effectiveColor : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? effectiveColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (currencyCode != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  currencyCode!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Dropdown style wallet switcher for compact layouts
class WalletDropdownSwitcher extends ConsumerWidget {
  const WalletDropdownSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);
    final selectedWalletId = ref.watch(selectedWalletIdProvider);
    final wallets = walletState.wallets;

    // Find selected wallet
    final selectedWallet = selectedWalletId != null
        ? wallets.firstWhere(
            (w) => w.id == selectedWalletId,
            orElse: () => wallets.first,
          )
        : null;

    return PopupMenuButton<String?>(
      initialValue: selectedWalletId,
      onSelected: (walletId) {
        ref.read(selectedWalletIdProvider.notifier).state = walletId;
      },
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      color: AppColors.primarySurface,
      itemBuilder: (context) => [
        PopupMenuItem<String?>(
          value: null,
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 20,
                color: selectedWalletId == null
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                'All Wallets',
                style: TextStyle(
                  fontWeight: selectedWalletId == null ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        ...wallets.map((wallet) {
          final isSelected = selectedWalletId == wallet.id;
          final walletColor = WalletColors.parseColor(wallet.color);
          return PopupMenuItem<String?>(
            value: wallet.id,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: walletColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    WalletIcons.getIcon(wallet.iconName),
                    size: 14,
                    color: walletColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    wallet.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                ),
                Text(
                  wallet.currency,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedWallet != null) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: WalletColors.parseColor(
                    selectedWallet.color,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  WalletIcons.getIcon(selectedWallet.iconName),
                  size: 16,
                  color: WalletColors.parseColor(selectedWallet.color),
                ),
              ),
              const SizedBox(width: 10),
              Text(selectedWallet.name, style: AppTypography.bodyMedium),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  selectedWallet.currency,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryAccent,
                    fontSize: 10,
                  ),
                ),
              ),
            ] else ...[
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 20,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 10),
              Text('All Wallets', style: AppTypography.bodyMedium),
            ],
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension to filter data by selected wallet
extension WalletFilterExtension on WidgetRef {
  /// Get the currently selected wallet ID (null = all wallets)
  String? get selectedWalletId => watch(selectedWalletIdProvider);

  /// Check if "All Wallets" is selected
  bool get isAllWalletsSelected => selectedWalletId == null;
}
