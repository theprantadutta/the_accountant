import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/currency_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Callback type for AddWalletForm submission
typedef WalletFormSubmitCallback =
    void Function({
      required String currency,
      required String icon,
      required String color,
      required bool isDefault,
      required bool useDecimals,
      required WalletType walletType,
      required double? creditLimit,
      required int? billingCycleDay,
    });

/// Form for adding/editing a wallet with enhanced features
class AddWalletForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController balanceController;
  final String? initialCurrency;
  final String? initialIcon;
  final String? initialColor;
  final bool initialIsDefault;
  final bool initialUseDecimals;
  final WalletType initialWalletType;
  final double? initialCreditLimit;
  final int? initialBillingCycleDay;
  final WalletFormSubmitCallback onSubmit;
  final VoidCallback onCancel;
  final bool isEditing;

  const AddWalletForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.balanceController,
    this.initialCurrency,
    this.initialIcon,
    this.initialColor,
    this.initialIsDefault = false,
    this.initialUseDecimals = true,
    this.initialWalletType = WalletType.cash,
    this.initialCreditLimit,
    this.initialBillingCycleDay,
    required this.onSubmit,
    required this.onCancel,
    this.isEditing = false,
  });

  @override
  ConsumerState<AddWalletForm> createState() => _AddWalletFormState();
}

class _AddWalletFormState extends ConsumerState<AddWalletForm> {
  late String _selectedCurrency;
  late String _selectedIcon;
  late String _selectedColor;
  late bool _isDefault;
  late bool _useDecimals;
  late WalletType _walletType;
  final TextEditingController _creditLimitController = TextEditingController();
  int? _billingCycleDay;

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

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.initialCurrency ?? 'USD';
    _selectedIcon = widget.initialIcon ?? 'wallet';
    _selectedColor = widget.initialColor ?? '#6366F1';
    _isDefault = widget.initialIsDefault;
    _useDecimals = widget.initialUseDecimals;
    _walletType = widget.initialWalletType;
    if (widget.initialCreditLimit != null) {
      _creditLimitController.text = widget.initialCreditLimit.toString();
    }
    _billingCycleDay = widget.initialBillingCycleDay;
  }

  @override
  void dispose() {
    _creditLimitController.dispose();
    super.dispose();
  }

  void _onWalletTypeChanged(WalletType type) {
    if (widget.isEditing) return; // Type is immutable after creation
    setState(() {
      _walletType = type;
      // Set default icon and color for the type if user hasn't customized
      if (!widget.isEditing) {
        _selectedIcon = _defaultIcons[type] ?? 'wallet';
        _selectedColor = _defaultColors[type] ?? '#6366F1';
      }
    });
  }

  String get selectedCurrency => _selectedCurrency;
  String get selectedIcon => _selectedIcon;
  String get selectedColor => _selectedColor;
  bool get isDefault => _isDefault;
  bool get useDecimals => _useDecimals;

  void _showIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: _IconPickerSheet(
          selectedIcon: _selectedIcon,
          selectedColor: WalletColors.parseColor(_selectedColor),
          onIconSelected: (icon) {
            setState(() => _selectedIcon = icon);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: _ColorPickerSheet(
          selectedColor: _selectedColor,
          onColorSelected: (color) {
            setState(() => _selectedColor = color);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: WalletColors.parseColor(
                        _selectedColor,
                      ).withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      WalletIcons.getIcon(_selectedIcon),
                      color: WalletColors.parseColor(_selectedColor),
                      size: 28,
                    ),
                  ),
                  AppSpacing.gapHMd,
                  Text(
                    widget.isEditing ? 'Edit Wallet' : 'Add New Wallet',
                    style: AppTypography.titleLarge,
                  ),
                ],
              ),
              AppSpacing.gapLg,

              // Wallet Type Selector
              Text('Account Type', style: AppTypography.labelMedium),
              AppSpacing.gapSm,
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
                        onSelected: widget.isEditing
                            ? null
                            : (_) => _onWalletTypeChanged(type),
                        selectedColor: AppColors.primaryAccent,
                        backgroundColor: AppColors.glassWhite,
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
              if (!widget.isEditing) ...[
                const SizedBox(height: 6),
                Text(
                  'Account type cannot be changed later',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
              AppSpacing.gapMd,

              // Wallet Name
              Text('Wallet Name', style: AppTypography.labelMedium),
              AppSpacing.gapSm,
              TextFormField(
                controller: widget.nameController,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter wallet name',
                  filled: true,
                  fillColor: AppColors.glassWhite,
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
                    borderSide: BorderSide(color: AppColors.primaryAccent),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a wallet name';
                  }
                  return null;
                },
              ),
              AppSpacing.gapMd,

              // Currency Picker
              CurrencyPicker(
                label: 'Currency',
                selectedCurrency: _selectedCurrency,
                onCurrencySelected: (currency) {
                  setState(() => _selectedCurrency = currency);
                },
              ),
              AppSpacing.gapMd,

              // Initial Balance
              Text('Initial Balance', style: AppTypography.labelMedium),
              AppSpacing.gapSm,
              TextFormField(
                controller: widget.balanceController,
                style: AppTypography.bodyLarge,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '${CurrencyInfo.getSymbol(_selectedCurrency)} ',
                  filled: true,
                  fillColor: AppColors.glassWhite,
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
                    borderSide: BorderSide(color: AppColors.primaryAccent),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final balance = double.tryParse(value);
                    if (balance == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              AppSpacing.gapMd,

              // Credit Card specific fields
              if (_walletType == WalletType.creditCard) ...[
                Text('Credit Limit', style: AppTypography.labelMedium),
                AppSpacing.gapSm,
                TextFormField(
                  controller: _creditLimitController,
                  style: AppTypography.bodyLarge,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter credit limit',
                    prefixText: '${CurrencyInfo.getSymbol(_selectedCurrency)} ',
                    filled: true,
                    fillColor: AppColors.glassWhite,
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
                      borderSide: BorderSide(color: AppColors.primaryAccent),
                    ),
                  ),
                  validator: (value) {
                    if (_walletType == WalletType.creditCard) {
                      if (value == null || value.isEmpty) {
                        return 'Credit limit is required';
                      }
                      final limit = double.tryParse(value);
                      if (limit == null || limit <= 0) {
                        return 'Please enter a valid credit limit greater than 0';
                      }
                    }
                    return null;
                  },
                ),
                AppSpacing.gapMd,
                Text('Billing Cycle Day', style: AppTypography.labelMedium),
                AppSpacing.gapSm,
                DropdownButtonFormField<int>(
                  initialValue: _billingCycleDay,
                  decoration: InputDecoration(
                    hintText: 'Select billing day (optional)',
                    filled: true,
                    fillColor: AppColors.glassWhite,
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
                      borderSide: BorderSide(color: AppColors.primaryAccent),
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
                AppSpacing.gapMd,
              ],

              // Icon and Color pickers in a row
              Row(
                children: [
                  // Icon picker
                  Expanded(
                    child: _LabeledIconButton(
                      label: 'Icon',
                      icon: _selectedIcon,
                      color: WalletColors.parseColor(_selectedColor),
                      onTap: () => _showIconPicker(context),
                    ),
                  ),
                  AppSpacing.gapHMd,
                  // Color picker
                  Expanded(
                    child: _LabeledColorButton(
                      label: 'Color',
                      color: _selectedColor,
                      onTap: () => _showColorPicker(context),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapMd,

              // Default wallet toggle
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: _isDefault
                          ? AppColors.warning
                          : AppColors.textSecondary,
                    ),
                    AppSpacing.gapHMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set as Default',
                            style: AppTypography.bodyLarge,
                          ),
                          Text(
                            'Use this wallet for new transactions',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (value) => setState(() => _isDefault = value),
                      activeThumbColor: AppColors.primaryAccent,
                    ),
                  ],
                ),
              ),
              AppSpacing.gapMd,

              // Use decimals toggle
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.numbers,
                      color: _useDecimals
                          ? AppColors.primaryAccent
                          : AppColors.textSecondary,
                    ),
                    AppSpacing.gapHMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Use Decimals', style: AppTypography.bodyLarge),
                          Text(
                            _useDecimals
                                ? 'Show cents (e.g., \$1,234.56)'
                                : 'Whole numbers only (e.g., \$1,235)',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _useDecimals,
                      onChanged: (value) =>
                          setState(() => _useDecimals = value),
                      activeThumbColor: AppColors.primaryAccent,
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: NeoButton(
                      label: 'Cancel',
                      style: NeoButtonStyle.secondary,
                      onPressed: widget.onCancel,
                    ),
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: NeoButton(
                      label: widget.isEditing
                          ? 'Save Changes'
                          : 'Create Wallet',
                      style: NeoButtonStyle.primary,
                      onPressed: () {
                        if (widget.formKey.currentState?.validate() ?? false) {
                          widget.onSubmit(
                            currency: _selectedCurrency,
                            icon: _selectedIcon,
                            color: _selectedColor,
                            isDefault: _isDefault,
                            useDecimals: _useDecimals,
                            walletType: _walletType,
                            creditLimit: _walletType == WalletType.creditCard
                                ? double.tryParse(_creditLimitController.text)
                                : null,
                            billingCycleDay:
                                _walletType == WalletType.creditCard
                                ? _billingCycleDay
                                : null,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact wallet form for dialogs
class CompactWalletForm extends ConsumerStatefulWidget {
  final String? initialName;
  final String? initialCurrency;
  final String? initialIcon;
  final String? initialColor;
  final double? initialBalance;
  final bool initialIsDefault;
  final bool initialUseDecimals;
  final WalletType initialWalletType;
  final double? initialCreditLimit;
  final int? initialBillingCycleDay;
  final Function(
    String name,
    String currency,
    String icon,
    String color,
    double balance,
    bool isDefault,
    bool useDecimals,
    WalletType walletType,
    double? creditLimit,
    int? billingCycleDay,
  )
  onSubmit;

  const CompactWalletForm({
    super.key,
    this.initialName,
    this.initialCurrency,
    this.initialIcon,
    this.initialColor,
    this.initialBalance,
    this.initialIsDefault = false,
    this.initialUseDecimals = true,
    this.initialWalletType = WalletType.cash,
    this.initialCreditLimit,
    this.initialBillingCycleDay,
    required this.onSubmit,
  });

  @override
  ConsumerState<CompactWalletForm> createState() => _CompactWalletFormState();
}

class _CompactWalletFormState extends ConsumerState<CompactWalletForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _creditLimitController;
  late String _currency;
  late String _icon;
  late String _color;
  late bool _isDefault;
  late bool _useDecimals;
  late WalletType _walletType;
  int? _billingCycleDay;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _balanceController = TextEditingController(
      text: widget.initialBalance?.toString() ?? '',
    );
    _creditLimitController = TextEditingController(
      text: widget.initialCreditLimit?.toString() ?? '',
    );
    _currency = widget.initialCurrency ?? 'USD';
    _icon = widget.initialIcon ?? 'wallet';
    _color = widget.initialColor ?? '#6366F1';
    _isDefault = widget.initialIsDefault;
    _useDecimals = widget.initialUseDecimals;
    _walletType = widget.initialWalletType;
    _billingCycleDay = widget.initialBillingCycleDay;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Wallet Name',
              border: OutlineInputBorder(),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Please enter a name' : null,
          ),
          AppSpacing.gapMd,

          // Currency picker
          CurrencyPicker(
            label: 'Currency',
            selectedCurrency: _currency,
            onCurrencySelected: (c) => setState(() => _currency = c),
          ),
          AppSpacing.gapMd,

          // Balance
          TextFormField(
            controller: _balanceController,
            decoration: const InputDecoration(
              labelText: 'Initial Balance',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          AppSpacing.gapMd,

          // Icon and color in row
          Row(
            children: [
              Expanded(
                child: IconPicker(
                  label: 'Icon',
                  selectedIcon: _icon,
                  selectedColor: WalletColors.parseColor(_color),
                  onIconSelected: (i) => setState(() => _icon = i),
                ),
              ),
              AppSpacing.gapHMd,
              Expanded(
                child: ColorPicker(
                  label: 'Color',
                  selectedColor: _color,
                  onColorSelected: (c) => setState(() => _color = c),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,

          // Default toggle
          SwitchListTile(
            title: const Text('Set as Default'),
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
          ),

          // Use decimals toggle
          SwitchListTile(
            title: const Text('Use Decimals'),
            subtitle: Text(
              _useDecimals
                  ? 'Show cents (e.g., \$1,234.56)'
                  : 'Whole numbers only (e.g., \$1,235)',
            ),
            value: _useDecimals,
            onChanged: (v) => setState(() => _useDecimals = v),
          ),
          AppSpacing.gapLg,

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final balance =
                      double.tryParse(_balanceController.text) ?? 0.0;
                  widget.onSubmit(
                    _nameController.text,
                    _currency,
                    _icon,
                    _color,
                    balance,
                    _isDefault,
                    _useDecimals,
                    _walletType,
                    _walletType == WalletType.creditCard
                        ? double.tryParse(_creditLimitController.text)
                        : null,
                    _walletType == WalletType.creditCard
                        ? _billingCycleDay
                        : null,
                  );
                }
              },
              child: const Text('Save Wallet'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Labeled icon button styled like an input field
class _LabeledIconButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const _LabeledIconButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        AppSpacing.gapSm,
        InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    WalletIcons.getIcon(icon),
                    color: color,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Labeled color button styled like an input field
class _LabeledColorButton extends StatelessWidget {
  final String label;
  final String color;
  final VoidCallback onTap;

  const _LabeledColorButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final parsedColor = WalletColors.parseColor(color);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        AppSpacing.gapSm,
        InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: parsedColor,
                    borderRadius: AppSpacing.borderRadiusSm,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Icon picker bottom sheet
class _IconPickerSheet extends StatelessWidget {
  final String? selectedIcon;
  final Color selectedColor;
  final ValueChanged<String> onIconSelected;

  const _IconPickerSheet({
    this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icons = WalletIcons.allIcons;

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: AppSpacing.horizontalPadding(AppSpacing.md),
            child: Row(
              children: [
                Text('Select Icon', style: AppTypography.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Icon grid
          Expanded(
            child: GridView.builder(
              padding: AppSpacing.paddingMd,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final entry = icons.entries.elementAt(index);
                final isSelected = selectedIcon == entry.key;

                return InkWell(
                  onTap: () => onIconSelected(entry.key),
                  borderRadius: AppSpacing.borderRadiusMd,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withValues(alpha: 0.2)
                          : AppColors.glassWhite,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(
                        color: isSelected
                            ? selectedColor
                            : AppColors.glassBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      entry.value,
                      color: isSelected ? selectedColor : AppColors.textPrimary,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Color picker bottom sheet
class _ColorPickerSheet extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const _ColorPickerSheet({this.selectedColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: AppSpacing.horizontalPadding(AppSpacing.md),
            child: Row(
              children: [
                Text('Select Color', style: AppTypography.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Color grid
          Expanded(
            child: GridView.builder(
              padding: AppSpacing.paddingMd,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: WalletColors.presetColors.length,
              itemBuilder: (context, index) {
                final color = WalletColors.presetColors[index];
                final isSelected =
                    selectedColor?.toUpperCase() == color.toUpperCase();

                return InkWell(
                  onTap: () => onColorSelected(color),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: WalletColors.parseColor(color),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.2),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: WalletColors.parseColor(
                                  color,
                                ).withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
