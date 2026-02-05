import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/currency_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Screen shown when user has no wallets - they must create one to continue
class CreateFirstWalletScreen extends ConsumerStatefulWidget {
  final VoidCallback onWalletCreated;

  const CreateFirstWalletScreen({super.key, required this.onWalletCreated});

  @override
  ConsumerState<CreateFirstWalletScreen> createState() =>
      _CreateFirstWalletScreenState();
}

class _CreateFirstWalletScreenState
    extends ConsumerState<CreateFirstWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'My Wallet');
  final _balanceController = TextEditingController(text: '0');
  final _creditLimitController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedIcon = 'wallet';
  String _selectedColor = '#6366F1';
  WalletType _walletType = WalletType.cash;
  int? _billingCycleDay;
  bool _isLoading = false;

  static const _defaultIcons = {
    WalletType.cash: 'wallet',
    WalletType.bankAccount: 'account_balance',
    WalletType.creditCard: 'credit_card',
    WalletType.subscription: 'subscriptions',
  };

  static const _defaultColors = {
    WalletType.cash: '#6366F1',
    WalletType.bankAccount: '#06B6D4',
    WalletType.creditCard: '#F59E0B',
    WalletType.subscription: '#8B5CF6',
  };

  void _onWalletTypeChanged(WalletType type) {
    setState(() {
      _walletType = type;
      _selectedIcon = _defaultIcons[type] ?? 'wallet';
      _selectedColor = _defaultColors[type] ?? '#6366F1';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
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
        walletType: _walletType,
        creditLimit: _walletType == WalletType.creditCard
            ? double.tryParse(_creditLimitController.text)
            : null,
        billingCycleDay: _walletType == WalletType.creditCard
            ? _billingCycleDay
            : null,
      );

      // Wait for wallets to reload
      await Future.delayed(const Duration(milliseconds: 100));

      // Get the created wallet and set it as default in SharedPreferences
      final walletState = ref.read(walletProvider);
      if (walletState.wallets.isNotEmpty) {
        final defaultWalletNotifier = ref.read(defaultWalletProvider.notifier);
        await defaultWalletNotifier.setDefaultWallet(
          walletState.wallets.first.id,
        );
      }

      widget.onWalletCreated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create wallet: $e')));
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
                          color: WalletColors.parseColor(
                            _selectedColor,
                          ).withValues(alpha: 0.2),
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

                // Account Type
                Text('Account Type', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: WalletType.values.map((type) {
                      final isSelected = _walletType == type;
                      final label = switch (type) {
                        WalletType.cash => 'Cash',
                        WalletType.bankAccount => 'Bank Account',
                        WalletType.creditCard => 'Credit Card',
                        WalletType.subscription => 'Subscription',
                      };
                      final icon = switch (type) {
                        WalletType.cash => Icons.wallet,
                        WalletType.bankAccount => Icons.account_balance,
                        WalletType.creditCard => Icons.credit_card,
                        WalletType.subscription => Icons.subscriptions,
                      };
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(label),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (_) => _onWalletTypeChanged(type),
                          selectedColor: AppColors.primaryAccent,
                          backgroundColor: AppColors.primarySurface,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryAccent
                                  : AppColors.glassBorder,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  'Account type cannot be changed later',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 24),

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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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

                // Credit Card specific fields
                if (_walletType == WalletType.creditCard) ...[
                  const SizedBox(height: 24),
                  Text('Credit Limit', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _creditLimitController,
                    style: AppTypography.bodyLarge,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter credit limit',
                      prefixText:
                          '${CurrencyInfo.getSymbol(_selectedCurrency)} ',
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
                      if (_walletType == WalletType.creditCard) {
                        if (value == null || value.isEmpty) {
                          return 'Credit limit is required';
                        }
                        final limit = double.tryParse(value);
                        if (limit == null || limit <= 0) {
                          return 'Please enter a valid credit limit';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Billing Cycle Day (optional)',
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _billingCycleDay,
                    decoration: InputDecoration(
                      hintText: 'Select billing day',
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
                    dropdownColor: AppColors.primarySurface,
                    style: AppTypography.bodyLarge,
                    items: List.generate(31, (i) => i + 1)
                        .map(
                          (day) => DropdownMenuItem(
                            value: day,
                            child: Text('Day $day'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _billingCycleDay = value),
                  ),
                ],

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
                            selectedColor: WalletColors.parseColor(
                              _selectedColor,
                            ),
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
