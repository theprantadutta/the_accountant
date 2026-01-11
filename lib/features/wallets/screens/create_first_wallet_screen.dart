import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/currency_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Screen shown when user has no wallets - they must create one to continue
class CreateFirstWalletScreen extends ConsumerStatefulWidget {
  final VoidCallback onWalletCreated;

  const CreateFirstWalletScreen({
    super.key,
    required this.onWalletCreated,
  });

  @override
  ConsumerState<CreateFirstWalletScreen> createState() =>
      _CreateFirstWalletScreenState();
}

class _CreateFirstWalletScreenState
    extends ConsumerState<CreateFirstWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'My Wallet');
  final _balanceController = TextEditingController(text: '0');

  String _selectedCurrency = 'USD';
  String _selectedIcon = 'wallet';
  String _selectedColor = '#6366F1';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _createWallet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final walletNotifier = ref.read(walletProvider.notifier);

      await walletNotifier.addWallet(
        name: _nameController.text.trim(),
        currency: _selectedCurrency,
        balance: double.tryParse(_balanceController.text) ?? 0.0,
        iconName: _selectedIcon,
        color: _selectedColor,
        isDefault: true, // First wallet is always default
      );

      // Wait for wallets to reload
      await Future.delayed(const Duration(milliseconds: 100));

      // Get the created wallet and set it as default in SharedPreferences
      final walletState = ref.read(walletProvider);
      if (walletState.wallets.isNotEmpty) {
        final defaultWalletNotifier = ref.read(defaultWalletProvider.notifier);
        await defaultWalletNotifier.setDefaultWallet(walletState.wallets.first.id);
      }

      widget.onWalletCreated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create wallet: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Welcome header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: WalletColors.parseColor(_selectedColor)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          WalletIcons.getIcon(_selectedIcon),
                          color: WalletColors.parseColor(_selectedColor),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Create Your First Account',
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You need at least one account to start tracking your finances',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Wallet name
                Text('Account Name', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'e.g., Personal, Savings, Business',
                    filled: true,
                    fillColor: AppColors.primarySurface,
                    border: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      borderSide: BorderSide(
                        color: WalletColors.parseColor(_selectedColor),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an account name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Currency picker (show currency first, then balance)
                Text('Currency', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                CurrencyPicker(
                  selectedCurrency: _selectedCurrency,
                  onCurrencySelected: (currency) {
                    setState(() => _selectedCurrency = currency);
                  },
                ),

                const SizedBox(height: 24),

                // Initial balance
                Text('Initial Balance', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _balanceController,
                  style: AppTypography.bodyLarge,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '$_selectedCurrency ',
                    filled: true,
                    fillColor: AppColors.primarySurface,
                    border: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      borderSide: BorderSide(
                        color: WalletColors.parseColor(_selectedColor),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Icon and color row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Icon', style: AppTypography.labelLarge),
                          const SizedBox(height: 8),
                          IconPicker(
                            selectedIcon: _selectedIcon,
                            selectedColor: WalletColors.parseColor(_selectedColor),
                            onIconSelected: (icon) {
                              setState(() => _selectedIcon = icon);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Color', style: AppTypography.labelLarge),
                          const SizedBox(height: 8),
                          ColorPicker(
                            selectedColor: _selectedColor,
                            onColorSelected: (color) {
                              setState(() => _selectedColor = color);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Create button
                SizedBox(
                  width: double.infinity,
                  child: NeoButton(
                    label: 'Create Account',
                    onPressed: _isLoading ? null : _createWallet,
                    isLoading: _isLoading,
                    isExpanded: true,
                  ),
                ),

                const SizedBox(height: 16),

                // Info text
                Center(
                  child: Text(
                    'This will be your default account',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
