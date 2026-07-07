import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/onboarding/providers/onboarding_provider.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/currency_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Post-signup onboarding screen for new users
class PostSignupOnboardingScreen extends ConsumerStatefulWidget {
  const PostSignupOnboardingScreen({super.key});

  @override
  ConsumerState<PostSignupOnboardingScreen> createState() =>
      _PostSignupOnboardingScreenState();
}

class _PostSignupOnboardingScreenState
    extends ConsumerState<PostSignupOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Currency selection
  String _selectedCurrency = 'USD';

  // Step 2: Wallet creation
  final TextEditingController _walletNameController = TextEditingController(
    text: 'Main Account',
  );
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  String _selectedIcon = 'wallet';
  String _selectedColor = '#6366F1';
  WalletType _walletType = WalletType.cash;
  int? _billingCycleDay;

  @override
  void dispose() {
    _pageController.dispose();
    _walletNameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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

  Future<void> _completeOnboarding() async {
    final balance = double.tryParse(_balanceController.text) ?? 0.0;

    await ref
        .read(onboardingProvider.notifier)
        .completeOnboarding(
          defaultCurrency: _selectedCurrency,
          walletName: _walletNameController.text.trim().isEmpty
              ? 'Main Account'
              : _walletNameController.text.trim(),
          walletIcon: _selectedIcon,
          walletColor: _selectedColor,
          initialBalance: balance,
          walletType: _walletType,
          creditLimit: _walletType == WalletType.creditCard
              ? double.tryParse(_creditLimitController.text)
              : null,
          billingCycleDay: _walletType == WalletType.creditCard
              ? _billingCycleDay
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: AppSpacing.paddingMd,
                child: Row(
                  children: [
                    for (int i = 0; i < 3; i++) ...[
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: i <= _currentStep
                                ? AppColors.primaryAccent
                                : AppColors.glassBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      if (i < 2) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCurrencyStep(),
                    _buildWalletStep(),
                    _buildCompleteStep(),
                  ],
                ),
              ),

              // Navigation buttons
              Padding(
                padding: AppSpacing.paddingLg,
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: NeoButton(
                          label: 'Back',
                          style: NeoButtonStyle.secondary,
                          onPressed: _previousStep,
                        ),
                      ),
                    if (_currentStep > 0) AppSpacing.gapHMd,
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 1,
                      child: _currentStep == 2
                          ? NeoButton(
                              label: 'Get Started',
                              style: NeoButtonStyle.primary,
                              isLoading: onboardingState.isCompleting,
                              onPressed: onboardingState.isCompleting
                                  ? null
                                  : _completeOnboarding,
                            )
                          : NeoButton(
                              label: 'Continue',
                              style: NeoButtonStyle.primary,
                              onPressed: _nextStep,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Step 1: Currency Selection
  Widget _buildCurrencyStep() {
    final currencyState = ref.watch(currencyProvider);

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.gapXl,
          // Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.language, size: 50, color: Colors.white),
            ),
          ),
          AppSpacing.gapXl,

          // Title
          Center(
            child: Text(
              'Welcome!',
              style: AppTypography.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.gapMd,
          Center(
            child: Text(
              'Select your default currency',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.gapXl,

          // Currency picker
          CurrencyPicker(
            label: 'Default Currency',
            selectedCurrency: _selectedCurrency,
            onCurrencySelected: (currency) {
              setState(() => _selectedCurrency = currency);
            },
          ),
          AppSpacing.gapMd,

          // Info text
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primaryAccent),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    'This will be used as your primary currency. You can add accounts with different currencies later.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading state for currencies
          if (currencyState.isLoading &&
              currencyState.availableCurrencies.isEmpty) ...[
            AppSpacing.gapMd,
            const Center(child: CircularProgressIndicator()),
            AppSpacing.gapSm,
            Center(
              child: Text(
                'Loading currencies...',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Step 2: Wallet Creation
  Widget _buildWalletStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.gapXl,
          // Preview icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: WalletColors.parseColor(
                  _selectedColor,
                ).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: WalletColors.parseColor(_selectedColor),
                  width: 2,
                ),
              ),
              child: Icon(
                WalletIcons.getIcon(_selectedIcon),
                size: 50,
                color: WalletColors.parseColor(_selectedColor),
              ),
            ),
          ),
          AppSpacing.gapXl,

          // Title
          Center(
            child: Text(
              'Create Your First Account',
              style: AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.gapMd,
          Center(
            child: Text(
              'Set up your primary wallet',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.gapXl,

          // Account Type
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
                    onSelected: (_) => _onWalletTypeChanged(type),
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
          const SizedBox(height: 6),
          Text(
            'Account type cannot be changed later',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapMd,

          // Wallet name
          Text('Account Name', style: AppTypography.labelMedium),
          AppSpacing.gapSm,
          TextFormField(
            controller: _walletNameController,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Main Account',
              filled: true,
              fillColor: AppColors.glassWhite,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMd,
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
            ),
          ),
          AppSpacing.gapMd,

          // Initial balance
          Text('Initial Balance (optional)', style: AppTypography.labelMedium),
          AppSpacing.gapSm,
          TextFormField(
            controller: _balanceController,
            style: AppTypography.bodyLarge,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '${_getCurrencySymbol()} ',
              filled: true,
              fillColor: AppColors.glassWhite,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMd,
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
            ),
          ),
          AppSpacing.gapMd,

          // Credit Card specific fields
          if (_walletType == WalletType.creditCard) ...[
            Text('Credit Limit', style: AppTypography.labelMedium),
            AppSpacing.gapSm,
            TextFormField(
              controller: _creditLimitController,
              style: AppTypography.bodyLarge,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter credit limit',
                prefixText: '${_getCurrencySymbol()} ',
                filled: true,
                fillColor: AppColors.glassWhite,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                  borderSide: BorderSide(color: AppColors.glassBorder),
                ),
              ),
            ),
            AppSpacing.gapMd,
            Text('Billing Cycle Day (optional)', style: AppTypography.labelMedium),
            AppSpacing.gapSm,
            DropdownButtonFormField<int>(
              initialValue: _billingCycleDay,
              decoration: InputDecoration(
                hintText: 'Select billing day',
                filled: true,
                fillColor: AppColors.glassWhite,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                  borderSide: BorderSide(color: AppColors.glassBorder),
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

          // Icon and color pickers
          Row(
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
        ],
      ),
    );
  }

  String _getCurrencySymbol() {
    return CurrencyInfo.getSymbol(_selectedCurrency);
  }

  /// Step 3: Complete
  Widget _buildCompleteStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.gapXl,
          AppSpacing.gapXl,

          // Success icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.successGradient,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Colors.white,
            ),
          ),
          AppSpacing.gapXl,

          // Title
          Text(
            "You're All Set!",
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapMd,
          Text(
            'Your account is ready to use',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXl,

          // Summary card
          Container(
            padding: AppSpacing.paddingLg,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              children: [
                // Wallet preview
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: WalletColors.parseColor(
                          _selectedColor,
                        ).withValues(alpha: 0.2),
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: Icon(
                        WalletIcons.getIcon(_selectedIcon),
                        size: 28,
                        color: WalletColors.parseColor(_selectedColor),
                      ),
                    ),
                    AppSpacing.gapHMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _walletNameController.text.isEmpty
                                ? 'Main Account'
                                : _walletNameController.text,
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            _selectedCurrency,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withValues(alpha: 0.2),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Text(
                        'Default',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                const Divider(),
                AppSpacing.gapMd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Initial Balance',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${_getCurrencySymbol()}${_balanceController.text.isEmpty ? "0.00" : _balanceController.text}',
                      style: AppTypography.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,

          // Tips
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.warning),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    'Tip: You can add more accounts with different currencies anytime from the Wallets section.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
