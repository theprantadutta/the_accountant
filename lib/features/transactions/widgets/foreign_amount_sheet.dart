import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Wallet;
import 'package:the_accountant/features/transactions/services/foreign_amount_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/currency_picker_sheet.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// What the sheet closed with: a foreign amount, or null for "remove it".
/// The sheet itself returns null when dismissed without a choice.
class ForeignAmountChoice {
  const ForeignAmountChoice(this.value);
  final ForeignAmount? value;
}

/// Asks what an income or expense was in another currency, and what it cost.
///
/// The entry's own amount stays the money that reached (or left) the
/// account; this records what that was in the other currency, so a dollar
/// payment wired into a taka account keeps both figures and the rate.
Future<ForeignAmountChoice?> showForeignAmountSheet(
  BuildContext context, {
  required String walletId,
  required String walletCurrency,
  required List<Wallet> wallets,
  ForeignAmount? initial,
}) {
  return showSunriseSheet<ForeignAmountChoice>(
    context: context,
    builder: (_) => _ForeignAmountSheet(
      walletId: walletId,
      walletCurrency: walletCurrency,
      wallets: wallets,
      initial: initial,
    ),
  );
}

class _ForeignAmountSheet extends StatefulWidget {
  const _ForeignAmountSheet({
    required this.walletId,
    required this.walletCurrency,
    required this.wallets,
    this.initial,
  });

  final String walletId;
  final String walletCurrency;
  final List<Wallet> wallets;
  final ForeignAmount? initial;

  @override
  State<_ForeignAmountSheet> createState() => _ForeignAmountSheetState();
}

class _ForeignAmountSheetState extends State<_ForeignAmountSheet> {
  late String _currency;
  late String _feeWalletId;
  late final TextEditingController _amount;
  late final TextEditingController _fee;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _currency =
        initial?.currency ?? (widget.walletCurrency == 'USD' ? 'EUR' : 'USD');
    _feeWalletId = initial?.feeWalletId ?? widget.walletId;
    _amount = TextEditingController(
      text: initial == null ? '' : _plain(initial.amount),
    );
    _fee = TextEditingController(
      text: initial == null || initial.fee == 0 ? '' : _plain(initial.fee),
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    _fee.dispose();
    super.dispose();
  }

  static String _plain(int minor) {
    final value = minor / 100;
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  /// Minor units from what was typed, or null when it is not a number.
  static int? _minor(String text) {
    final value = double.tryParse(text.trim().replaceAll(',', ''));
    if (value == null) return null;
    return (value * 100).round();
  }

  int? get _amountMinor {
    final v = _minor(_amount.text);
    return v != null && v > 0 ? v : null;
  }

  Wallet? get _feeWallet =>
      widget.wallets.where((w) => w.id == _feeWalletId).firstOrNull;

  Future<void> _pickCurrency() async {
    final picked = await showCurrencyPickerSheet(
      context,
      selectedCurrency: _currency,
    );
    if (picked != null && mounted) setState(() => _currency = picked);
  }

  Future<void> _pickFeeWallet() async {
    final l10n = L10n.of(context);
    final picked = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.addForeignFeeAccount,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final w in widget.wallets)
              SheetAction(
                icon: Symbols.account_balance_wallet_rounded,
                label: '${w.name} (${w.currency})',
                selected: w.id == _feeWalletId,
                onTap: () => Navigator.of(sheet).pop(w.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _feeWalletId = picked);
  }

  void _done() {
    final amount = _amountMinor;
    if (amount == null) return;
    final fee = _minor(_fee.text) ?? 0;
    Navigator.of(context).pop(
      ForeignAmountChoice(
        ForeignAmount(
          currency: _currency,
          amount: amount,
          fee: fee > 0 ? fee : 0,
          feeWalletId: fee > 0 ? _feeWalletId : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final numeric = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    final feeWallet = _feeWallet;

    return SunriseBottomSheet(
      title: l10n.addForeign,
      subtitle: l10n.addForeignIntro,
      actions: [
        SunriseButton(
          label: l10n.actionSave,
          onPressed: _amountMinor == null ? null : _done,
        ),
        if (widget.initial != null) ...[
          const SizedBox(height: 8),
          SunriseButton.secondary(
            label: l10n.addForeignRemove,
            onPressed: () =>
                Navigator.of(context).pop(const ForeignAmountChoice(null)),
          ),
        ],
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsGroup(
            children: [
              SettingsRow(
                key: const Key('foreign_currency'),
                icon: Symbols.currency_exchange_rounded,
                iconColor: c.accent,
                title: l10n.addForeignCurrency,
                value:
                    '$_currency  ${CurrencyInfo.getSymbol(_currency)}'.trim(),
                onTap: _pickCurrency,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SunriseTextField(
            key: const Key('foreign_amount'),
            controller: _amount,
            label: l10n.addForeignAmount(_currency),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: numeric,
            autofocus: widget.initial == null,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          SunriseTextField(
            key: const Key('foreign_fee'),
            controller: _fee,
            label: l10n.addForeignFee,
            hint: feeWallet == null
                ? null
                : '${CurrencyInfo.getSymbol(feeWallet.currency)}0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: numeric,
            onChanged: (_) => setState(() {}),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
            child: Text(
              l10n.addForeignFeeHelp,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ),
          if ((_minor(_fee.text) ?? 0) > 0 && widget.wallets.length > 1) ...[
            const SizedBox(height: 12),
            SettingsGroup(
              children: [
                SettingsRow(
                  icon: Symbols.account_balance_wallet_rounded,
                  iconColor: c.accent,
                  title: l10n.addForeignFeeAccount,
                  value: feeWallet?.name ?? '',
                  onTap: _pickFeeWallet,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
