import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// A dropdown-style wallet selector widget.
/// Shows wallet name, balance, and currency.
class WalletSelector extends ConsumerWidget {
  /// The currently selected wallet ID
  final String? selectedWalletId;

  /// Callback when a wallet is selected
  final ValueChanged<Wallet>? onWalletSelected;

  /// Whether to show the wallet balance
  final bool showBalance;

  /// Label to show above the selector
  final String? label;

  const WalletSelector({
    super.key,
    this.selectedWalletId,
    this.onWalletSelected,
    this.showBalance = true,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final walletState = ref.watch(walletProvider);
    final walletNotifier = ref.read(walletProvider.notifier);

    // Get selected wallet or default
    Wallet? selectedWallet;
    if (selectedWalletId != null) {
      selectedWallet = walletNotifier.getWalletById(selectedWalletId!);
    }
    selectedWallet ??= walletNotifier.getDefaultWallet();

    if (walletState.wallets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
        _buildSelector(context, theme, walletState, selectedWallet),
      ],
    );
  }

  Widget _buildSelector(
    BuildContext context,
    ThemeData theme,
    WalletState walletState,
    Wallet? selectedWallet,
  ) {
    return GestureDetector(
      onTap: () =>
          _showWalletPicker(context, walletState.wallets, selectedWallet),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Wallet Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _parseColor(selectedWallet?.color).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: _parseColor(selectedWallet?.color),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Wallet Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedWallet?.name ?? 'Select Wallet',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (showBalance && selectedWallet != null)
                    Text(
                      '${CurrencyInfo.getSymbol(selectedWallet.currency)}${selectedWallet.useDecimals ? (selectedWallet.balance / 100.0).toStringAsFixed(2) : (selectedWallet.balance / 100).round().toString()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),

            // Dropdown Arrow
            Icon(
              Icons.keyboard_arrow_down,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletPicker(
    BuildContext context,
    List<Wallet> wallets,
    Wallet? selectedWallet,
  ) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _WalletPickerSheet(
        wallets: wallets,
        selectedWalletId: selectedWallet?.id,
        onWalletSelected: (wallet) {
          onWalletSelected?.call(wallet);
          Navigator.pop(context);
        },
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.indigo;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.indigo;
    } catch (e) {
      return Colors.indigo;
    }
  }
}

class _WalletPickerSheet extends StatelessWidget {
  final List<Wallet> wallets;
  final String? selectedWalletId;
  final ValueChanged<Wallet> onWalletSelected;

  const _WalletPickerSheet({
    required this.wallets,
    this.selectedWalletId,
    required this.onWalletSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Select Wallet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Wallet List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: wallets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              final isSelected = wallet.id == selectedWalletId;

              return _buildWalletItem(context, theme, wallet, isSelected);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWalletItem(
    BuildContext context,
    ThemeData theme,
    Wallet wallet,
    bool isSelected,
  ) {
    final color = _parseColor(wallet.color);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onWalletSelected(wallet);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_wallet, color: color, size: 24),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        wallet.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (wallet.isDefault == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${CurrencyInfo.getSymbol(wallet.currency)}${wallet.useDecimals ? (wallet.balance / 100.0).toStringAsFixed(2) : (wallet.balance / 100).round().toString()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Selected Indicator
            if (isSelected) Icon(Icons.check_circle, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.indigo;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.indigo;
    } catch (e) {
      return Colors.indigo;
    }
  }
}

/// Compact horizontal wallet switcher for use in headers/toolbars
class WalletSelectorCompact extends ConsumerWidget {
  final String? selectedWalletId;
  final ValueChanged<Wallet>? onWalletSelected;

  const WalletSelectorCompact({
    super.key,
    this.selectedWalletId,
    this.onWalletSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final walletState = ref.watch(walletProvider);
    final walletNotifier = ref.read(walletProvider.notifier);

    Wallet? selectedWallet;
    if (selectedWalletId != null) {
      selectedWallet = walletNotifier.getWalletById(selectedWalletId!);
    }
    selectedWallet ??= walletNotifier.getDefaultWallet();

    if (walletState.wallets.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () =>
          _showWalletPicker(context, walletState.wallets, selectedWallet),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 16,
              color: _parseColor(selectedWallet?.color),
            ),
            const SizedBox(width: 8),
            Text(
              selectedWallet?.name ?? 'Select',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletPicker(
    BuildContext context,
    List<Wallet> wallets,
    Wallet? selectedWallet,
  ) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _WalletPickerSheet(
        wallets: wallets,
        selectedWalletId: selectedWallet?.id,
        onWalletSelected: (wallet) {
          onWalletSelected?.call(wallet);
          Navigator.pop(context);
        },
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.indigo;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.indigo;
    } catch (e) {
      return Colors.indigo;
    }
  }
}
