import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/currency_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Callback type for AddWalletForm submission
typedef WalletFormSubmitCallback = void Function({
  required String currency,
  required String icon,
  required String color,
  required bool isDefault,
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

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.initialCurrency ?? 'USD';
    _selectedIcon = widget.initialIcon ?? 'wallet';
    _selectedColor = widget.initialColor ?? '#6366F1';
    _isDefault = widget.initialIsDefault;
  }

  String get selectedCurrency => _selectedCurrency;
  String get selectedIcon => _selectedIcon;
  String get selectedColor => _selectedColor;
  bool get isDefault => _isDefault;

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
                      color: WalletColors.parseColor(_selectedColor)
                          .withValues(alpha: 0.2),
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
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

              // Icon and Color pickers in a row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: IconPicker(
                      label: 'Icon',
                      selectedIcon: _selectedIcon,
                      selectedColor: WalletColors.parseColor(_selectedColor),
                      onIconSelected: (icon) {
                        setState(() => _selectedIcon = icon);
                      },
                    ),
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: ColorPicker(
                      label: 'Color',
                      selectedColor: _selectedColor,
                      onColorSelected: (color) {
                        setState(() => _selectedColor = color);
                      },
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
                          Text('Set as Default', style: AppTypography.bodyLarge),
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
                      activeColor: AppColors.primaryAccent,
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
                      label: widget.isEditing ? 'Save Changes' : 'Create Wallet',
                      style: NeoButtonStyle.primary,
                      onPressed: () {
                        if (widget.formKey.currentState?.validate() ?? false) {
                          widget.onSubmit(
                            currency: _selectedCurrency,
                            icon: _selectedIcon,
                            color: _selectedColor,
                            isDefault: _isDefault,
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
  final Function(String name, String currency, String icon, String color,
      double balance, bool isDefault) onSubmit;

  const CompactWalletForm({
    super.key,
    this.initialName,
    this.initialCurrency,
    this.initialIcon,
    this.initialColor,
    this.initialBalance,
    this.initialIsDefault = false,
    required this.onSubmit,
  });

  @override
  ConsumerState<CompactWalletForm> createState() => _CompactWalletFormState();
}

class _CompactWalletFormState extends ConsumerState<CompactWalletForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late String _currency;
  late String _icon;
  late String _color;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _balanceController = TextEditingController(
      text: widget.initialBalance?.toString() ?? '',
    );
    _currency = widget.initialCurrency ?? 'USD';
    _icon = widget.initialIcon ?? 'wallet';
    _color = widget.initialColor ?? '#6366F1';
    _isDefault = widget.initialIsDefault;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
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
            validator: (v) =>
                v?.isEmpty ?? true ? 'Please enter a name' : null,
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
