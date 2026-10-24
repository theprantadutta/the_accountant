import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/currency_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';

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
      required int? paymentDueDay,
      required int dueReminderDays,
      required int? balance,
    });

/// How many days ahead a card's bill can be reminded of; 0 is off.
const List<int> cardReminderChoices = [0, 1, 3, 5, 7];

/// What a positive balance meant on an account that is becoming a card.
///
/// Some people track a card as the credit they have left, counting down from
/// the limit; others track what they owe. The figure alone cannot say which,
/// and reading it the wrong way turns a debt into savings.
enum _CardBalanceMeaning { creditLeft, owed }

/// Form for adding/editing a wallet with enhanced features.
///
/// [balanceController] holds the balance as the account stands, signed the
/// way balances are stored: negative on a card means money owed. On a credit
/// card the field shows the amount owed instead, so it reads the way a
/// statement does, and the form turns it back into a signed balance on submit.
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
  final int? initialPaymentDueDay;
  final int initialDueReminderDays;
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
    this.initialPaymentDueDay,
    this.initialDueReminderDays = 3,
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
  int? _paymentDueDay;
  late int _dueReminderDays;

  /// The balance when the form opened, in cents.
  int? _openingBalance;
  _CardBalanceMeaning? _cardBalanceMeaning;
  bool _showMeaningError = false;

  static const _defaultIcons = {
    WalletType.cash: 'wallet',
    WalletType.bankAccount: 'account_balance',
    WalletType.creditCard: 'credit_card',
    WalletType.subscription: 'subscriptions',
  };

  static const _defaultColors = {
    WalletType.cash: '#F43F5E',
    WalletType.bankAccount: '#F97316',
    WalletType.creditCard: '#8B5CF6',
    WalletType.subscription: '#3B82F6',
  };

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.initialCurrency ?? 'USD';
    _selectedIcon = widget.initialIcon ?? 'wallet';
    _selectedColor =
        widget.initialColor ?? _defaultColors[widget.initialWalletType]!;
    _isDefault = widget.initialIsDefault;
    _useDecimals = widget.initialUseDecimals;
    _walletType = widget.initialWalletType;
    if (widget.initialCreditLimit != null) {
      _creditLimitController.text = widget.initialCreditLimit.toString();
    }
    _billingCycleDay = widget.initialBillingCycleDay;
    _paymentDueDay = widget.initialPaymentDueDay;
    _dueReminderDays = widget.initialDueReminderDays;
    _openingBalance = widget.balanceController.text.toCentsOrNull();
    if (widget.isEditing &&
        _walletType == WalletType.creditCard &&
        _openingBalance != null) {
      _setAmountField(-_openingBalance!);
    }
    _creditLimitController.addListener(_onLimitChanged);
  }

  @override
  void dispose() {
    _creditLimitController.removeListener(_onLimitChanged);
    _creditLimitController.dispose();
    super.dispose();
  }

  void _setAmountField(int cents) {
    widget.balanceController.text = (cents / 100).toStringAsFixed(2);
  }

  /// An existing account in credit, now being called a card, whose balance
  /// has to be read one way or the other before it can be saved.
  bool get _needsCardBalanceMeaning =>
      widget.isEditing &&
      widget.initialWalletType != WalletType.creditCard &&
      _walletType == WalletType.creditCard &&
      (_openingBalance ?? 0) > 0;

  void _onWalletTypeChanged(WalletType type) {
    if (type == _walletType) return;
    final crossesCard =
        (type == WalletType.creditCard) !=
        (_walletType == WalletType.creditCard);
    setState(() {
      // A new account takes the look of its type; an existing one keeps the
      // look its owner gave it.
      if (!widget.isEditing) {
        _selectedIcon = _defaultIcons[type] ?? 'wallet';
        _selectedColor = _defaultColors[type]!;
      }
      _walletType = type;
      _cardBalanceMeaning = null;
      _showMeaningError = false;
      // The field shows the amount owed on a card and the balance elsewhere,
      // so an existing balance flips sign when the account crosses over. A
      // balance in credit cannot be shown as owed until its owner says what
      // it was, so the field waits for that answer.
      final opening = _openingBalance;
      if (widget.isEditing && crossesCard && opening != null) {
        if (_needsCardBalanceMeaning) {
          widget.balanceController.clear();
        } else {
          _setAmountField(
            _walletType == WalletType.creditCard ? -opening : opening,
          );
        }
      }
    });
  }

  void _onCardBalanceMeaning(_CardBalanceMeaning meaning) {
    setState(() {
      _cardBalanceMeaning = meaning;
      _showMeaningError = false;
    });
    _applyCardBalanceMeaning();
  }

  void _onLimitChanged() {
    if (_cardBalanceMeaning == _CardBalanceMeaning.creditLeft) {
      _applyCardBalanceMeaning();
    }
  }

  /// Fill in what is owed from the old balance and how it was meant.
  void _applyCardBalanceMeaning() {
    final balance = _openingBalance ?? 0;
    switch (_cardBalanceMeaning) {
      case _CardBalanceMeaning.owed:
        _setAmountField(balance);
      case _CardBalanceMeaning.creditLeft:
        final limit = _creditLimitController.text.toCentsOrNull();
        if (limit != null) _setAmountField(limit - balance);
      case null:
        break;
    }
  }

  String get selectedCurrency => _selectedCurrency;
  String get selectedIcon => _selectedIcon;
  String get selectedColor => _selectedColor;
  bool get isDefault => _isDefault;
  bool get useDecimals => _useDecimals;

  void _showIconPicker(BuildContext context) {
    final color = WalletColors.parseColor(_selectedColor);
    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: L10n.of(context).walletSelectIcon,
        child: _IconGrid(
          selectedIcon: _selectedIcon,
          color: color,
          onSelected: (icon) {
            setState(() => _selectedIcon = icon);
            Navigator.pop(sheet);
          },
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: L10n.of(context).walletColor,
        child: _ColorGrid(
          selectedColor: _selectedColor,
          onSelected: (color) {
            setState(() => _selectedColor = color);
            Navigator.pop(sheet);
          },
        ),
      ),
    );
  }

  /// A day of the month, 1 to 31, from a grid. A day past the end of a
  /// short month means its last day.
  Future<int?> _pickDay(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int? current,
  }) {
    return showSunriseSheet<int>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: title,
        subtitle: subtitle,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var d = 1; d <= 31; d++)
              SunriseChip(
                key: Key('day_$d'),
                label: '$d',
                selected: d == current,
                onTap: () => Navigator.pop(sheet, d),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBillingDay(BuildContext context) async {
    final l10n = L10n.of(context);
    final day = await _pickDay(
      context,
      title: l10n.cardStatementDay,
      subtitle: l10n.cardStatementDayHint,
      current: _billingCycleDay,
    );
    if (day != null) setState(() => _billingCycleDay = day);
  }

  Future<void> _pickDueDay(BuildContext context) async {
    final l10n = L10n.of(context);
    final day = await _pickDay(
      context,
      title: l10n.cardDueDay,
      subtitle: l10n.cardDueDayHint,
      current: _paymentDueDay,
    );
    if (day != null) setState(() => _paymentDueDay = day);
  }

  Future<void> _pickReminder(BuildContext context) async {
    final l10n = L10n.of(context);
    final days = await showSunriseSheet<int>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.cardRemindTitle,
        subtitle: l10n.cardRemindHint,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final d in cardReminderChoices)
              SheetAction(
                key: Key('remind_$d'),
                icon: d == 0
                    ? Symbols.notifications_off_rounded
                    : Symbols.notifications_active_rounded,
                label: cardReminderLabel(l10n, d),
                selected: d == _dueReminderDays,
                onTap: () => Navigator.pop(sheet, d),
              ),
          ],
        ),
      ),
    );
    if (days != null) setState(() => _dueReminderDays = days);
  }

  void _submit() {
    final valid = widget.formKey.currentState?.validate() ?? false;
    if (_needsCardBalanceMeaning && _cardBalanceMeaning == null) {
      setState(() => _showMeaningError = true);
      return;
    }
    if (!valid) return;
    final entered = widget.balanceController.text.toCentsOrNull();
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
      billingCycleDay: _walletType == WalletType.creditCard
          ? _billingCycleDay
          : null,
      paymentDueDay: _walletType == WalletType.creditCard
          ? _paymentDueDay
          : null,
      dueReminderDays: _dueReminderDays,
      balance: entered == null
          ? null
          : _walletType == WalletType.creditCard
          ? -entered
          : entered,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final color = WalletColors.parseColor(_selectedColor);
    final symbol = CurrencyInfo.getSymbol(_selectedCurrency);

    String typeLabel(WalletType t) => switch (t) {
      WalletType.cash => 'Cash',
      WalletType.bankAccount => 'Bank Account',
      WalletType.creditCard => 'Credit Card',
      WalletType.subscription => 'Subscription',
      WalletType.deposit => 'Deposit',
      WalletType.investment => 'Investment',
    };
    IconData typeIcon(WalletType t) => switch (t) {
      WalletType.cash => Symbols.payments_rounded,
      WalletType.bankAccount => Symbols.account_balance_rounded,
      WalletType.creditCard => Symbols.credit_card_rounded,
      WalletType.subscription => Symbols.autorenew_rounded,
      WalletType.deposit => Symbols.savings_rounded,
      WalletType.investment => Symbols.trending_up_rounded,
    };

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isEditing ? 'Edit Wallet' : 'Add New Wallet',
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 20),
          ),
          const SizedBox(height: 16),

          // Live preview of the wallet as it will look.
          AnimatedBuilder(
            animation: widget.nameController,
            builder: (context, _) => _WalletPreview(
              name: widget.nameController.text.trim().isEmpty
                  ? l10n.walletEnterWalletName
                  : widget.nameController.text.trim(),
              subtitle: '${typeLabel(_walletType)} · $_selectedCurrency',
              icon: WalletIcons.getIcon(_selectedIcon),
              color: color,
              isDefault: _isDefault,
            ),
          ),
          const SizedBox(height: 20),

          SectionLabel(l10n.walletAccountType),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final type in WalletType.creatable) ...[
                  SunriseChip(
                    label: typeLabel(type),
                    icon: typeIcon(type),
                    selected: _walletType == type,
                    onTap: () => _onWalletTypeChanged(type),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),

          NeoTextField(
            controller: widget.nameController,
            label: l10n.walletWalletName,
            hint: l10n.walletEnterWalletName,
            prefixIcon: Symbols.badge_rounded,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a wallet name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CurrencyPicker(
            label: l10n.walletCurrency,
            selectedCurrency: _selectedCurrency,
            onCurrencySelected: (currency) {
              setState(() => _selectedCurrency = currency);
            },
          ),
          const SizedBox(height: 16),

          // The limit comes before what is owed: reading a balance as credit
          // left needs the limit to work out the debt.
          if (_walletType == WalletType.creditCard) ...[
            NeoTextField(
              controller: _creditLimitController,
              label: l10n.walletCreditLimit,
              hint: l10n.walletEnterCreditLimit,
              helperText: l10n.walletCreditLimitHelp,
              prefixIcon: Symbols.credit_score_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
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
            const SizedBox(height: 16),
          ],

          if (_needsCardBalanceMeaning) ...[
            Text(
              l10n.walletCardBalanceQuestion(
                _openingBalance!.formatCurrency(_selectedCurrency),
              ),
              style: SunriseType.rowTitle.copyWith(color: c.ink),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SunriseChip(
                  label: l10n.walletCardBalanceCreditLeft,
                  selected:
                      _cardBalanceMeaning == _CardBalanceMeaning.creditLeft,
                  onTap: () =>
                      _onCardBalanceMeaning(_CardBalanceMeaning.creditLeft),
                ),
                SunriseChip(
                  label: l10n.walletCardBalanceOwed,
                  selected: _cardBalanceMeaning == _CardBalanceMeaning.owed,
                  onTap: () => _onCardBalanceMeaning(_CardBalanceMeaning.owed),
                ),
              ],
            ),
            if (_showMeaningError) ...[
              const SizedBox(height: 6),
              Text(
                l10n.walletCardBalanceChoose,
                style: SunriseType.caption.copyWith(color: c.negative),
              ),
            ],
            const SizedBox(height: 16),
          ],

          NeoTextField(
            controller: widget.balanceController,
            label: _walletType == WalletType.creditCard
                ? l10n.walletAmountOwed
                : widget.isEditing
                ? l10n.walletCurrentBalance
                : l10n.walletInitialBalance,
            helperText: _walletType == WalletType.creditCard
                ? l10n.walletAmountOwedHelp
                : widget.isEditing
                ? l10n.walletCurrentBalanceHelp
                : null,
            hint: '0.00',
            prefixIcon: Symbols.account_balance_wallet_rounded,
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Center(
                widthFactor: 1,
                child: Text(
                  symbol,
                  style: SunriseType.rowTitle.copyWith(color: c.subtle),
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          SettingsGroup(
            children: [
              if (_walletType == WalletType.creditCard) ...[
                SettingsRow(
                  key: const Key('card_statement_day'),
                  icon: Symbols.event_repeat_rounded,
                  iconColor: c.accent,
                  iconBackground: c.tintOrange,
                  title: l10n.cardStatementDay,
                  value: _billingCycleDay == null
                      ? l10n.cardNotSet
                      : l10n.cardDayOfMonth(_billingCycleDay!),
                  onTap: () => _pickBillingDay(context),
                ),
                SettingsRow(
                  key: const Key('card_due_day'),
                  icon: Symbols.event_available_rounded,
                  iconColor: c.accent,
                  iconBackground: c.tintOrange,
                  title: l10n.cardDueDay,
                  value: _paymentDueDay == null
                      ? l10n.cardNotSet
                      : l10n.cardDayOfMonth(_paymentDueDay!),
                  onTap: () => _pickDueDay(context),
                ),
                SettingsRow(
                  key: const Key('card_reminder'),
                  icon: Symbols.notifications_active_rounded,
                  iconColor: c.accent,
                  iconBackground: c.tintOrange,
                  title: l10n.cardRemindTitle,
                  value: cardReminderLabel(l10n, _dueReminderDays),
                  onTap: () => _pickReminder(context),
                ),
              ],
              SettingsRow(
                icon: WalletIcons.getIcon(_selectedIcon),
                iconColor: color,
                title: l10n.walletIcon,
                onTap: () => _showIconPicker(context),
              ),
              SettingsRow(
                icon: Symbols.palette_rounded,
                iconColor: color,
                title: l10n.walletColor,
                trailingWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Symbols.chevron_right_rounded,
                      size: 20,
                      color: c.chevron,
                    ),
                  ],
                ),
                onTap: () => _showColorPicker(context),
              ),
              SettingsRow.toggle(
                icon: Symbols.star_rounded,
                iconColor: const Color(0xFFD97706),
                iconBackground: c.tintAmber,
                title: l10n.walletSetAsDefault,
                subtitle: l10n.walletUseThisWalletForNew,
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
              ),
              SettingsRow.toggle(
                icon: Symbols.decimal_increase_rounded,
                iconColor: const Color(0xFF0284C7),
                iconBackground: c.tintSky,
                title: l10n.walletUseDecimals,
                subtitle: _useDecimals
                    ? 'Show cents (e.g., \$1,234.56)'
                    : 'Whole numbers only (e.g., \$1,235)',
                value: _useDecimals,
                onChanged: (v) => setState(() => _useDecimals = v),
              ),
            ],
          ),
          const SizedBox(height: 22),

          SunriseButton(
            label: widget.isEditing ? 'Save Changes' : 'Create Wallet',
            onPressed: _submit,
          ),
          const SizedBox(height: 10),
          SunriseButton.secondary(
            label: l10n.actionCancel,
            onPressed: widget.onCancel,
          ),
        ],
      ),
    );
  }
}

/// The wallet as it will appear, on its own colour.
class _WalletPreview extends StatelessWidget {
  const _WalletPreview({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDefault,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final deep = Color.lerp(color, Colors.black, .35)!;
    return AnimatedContainer(
      duration: SunriseMotion.theme,
      height: 108,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, deep],
        ),
        borderRadius: BorderRadius.circular(SunriseRadius.hero),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 16),
            blurRadius: 30,
            spreadRadius: -16,
            color: color.withValues(alpha: .7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: c.onFill.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: c.onFill, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.section.copyWith(color: c.onFill),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.label.copyWith(
                    color: c.onFill.withValues(alpha: .85),
                  ),
                ),
              ],
            ),
          ),
          if (isDefault)
            Icon(Symbols.star_rounded, fill: 1, color: c.onFill, size: 22),
        ],
      ),
    );
  }
}

class _IconGrid extends StatelessWidget {
  const _IconGrid({
    required this.selectedIcon,
    required this.color,
    required this.onSelected,
  });

  final String selectedIcon;
  final Color color;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final entry in WalletIcons.allIcons.entries)
          Pressable(
            onTap: () => onSelected(entry.key),
            haptic: true,
            child: AnimatedContainer(
              duration: SunriseMotion.press,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: entry.key == selectedIcon
                    ? color
                    : color.withValues(alpha: c.isDark ? .16 : .10),
                borderRadius: BorderRadius.circular(SunriseRadius.category),
              ),
              child: Icon(
                entry.value,
                size: 26,
                color: entry.key == selectedIcon ? c.onFill : color,
              ),
            ),
          ),
      ],
    );
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({required this.selectedColor, required this.onSelected});

  final String selectedColor;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final hex in WalletColors.presetColors)
          Pressable(
            onTap: () => onSelected(hex),
            haptic: true,
            child: Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: hex.toUpperCase() == selectedColor.toUpperCase()
                      ? c.ink
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: WalletColors.parseColor(hex),
                  shape: BoxShape.circle,
                ),
                child: hex.toUpperCase() == selectedColor.toUpperCase()
                    ? Icon(Symbols.check_rounded, color: c.onFill, size: 20)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

/// "3 days before", "The day before", "Off".
String cardReminderLabel(L10n l10n, int days) =>
    days == 0 ? l10n.cardRemindOff : l10n.cardRemindDaysBefore(days);
