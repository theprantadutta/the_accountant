import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/features/investments/providers/investments_provider.dart';
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart';
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/investments/widgets/investment_labels.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Start tracking a fund, share or other holding, with what was first bought.
class InvestmentFormScreen extends ConsumerStatefulWidget {
  const InvestmentFormScreen({super.key});

  @override
  ConsumerState<InvestmentFormScreen> createState() =>
      _InvestmentFormScreenState();
}

class _InvestmentFormScreenState extends ConsumerState<InvestmentFormScreen> {
  final _name = TextEditingController();
  final _symbol = TextEditingController();
  final _units = TextEditingController();
  InvestmentKind _kind = InvestmentKind.fund;
  String? _walletId;
  int _amount = 0;
  int _fee = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _walletId = ref.read(selectableWalletsProvider).firstOrNull?.id;
    _units.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _symbol.dispose();
    _units.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    final wallet = ref
        .read(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    if (wallet == null) {
      showSunriseSnack(context, l10n.planNeedAccount, tone: SnackTone.error);
      return;
    }
    final units = double.tryParse(_units.text.trim());
    if (_amount > 0 && (units == null || units <= 0)) {
      showSunriseSnack(
        context,
        l10n.investmentNeedUnits,
        tone: SnackTone.error,
      );
      return;
    }
    setState(() => _saving = true);
    final service = ref.read(investmentServiceProvider);
    try {
      final id = await service.create(
        InvestmentDraft(
          name: _name.text,
          kind: _kind,
          symbol: _symbol.text,
          currency: wallet.currency,
          useDecimals: wallet.useDecimals,
        ),
      );
      if (_amount > 0) {
        await service.buy(
          id,
          fromWalletId: wallet.id,
          amount: _amount,
          units: units,
          fee: _fee,
        );
      }
      reloadAllData(ref);
      ref.invalidate(investmentsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(id);
      showSunriseSnack(context, l10n.investmentAdded, tone: SnackTone.success);
    } on ArgumentError catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    final currency = wallet?.currency ?? 'USD';
    final units = double.tryParse(_units.text.trim());
    final perUnit = _amount > 0 && (units ?? 0) > 0
        ? (_amount / units!).round()
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.investmentNew)),
      body: CappedBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            40,
          ),
          children: [
            Text(
              l10n.investmentNewHint,
              style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
            ),
            const SizedBox(height: 14),
            SunriseSegmented<InvestmentKind>(
              key: const Key('investment_kind'),
              options: [
                for (final k in InvestmentKind.values)
                  SegmentOption(k, k.label(l10n)),
              ],
              value: _kind,
              onChanged: (k) => setState(() => _kind = k),
            ),
            const SizedBox(height: 14),
            SunriseTextField(
              key: const Key('investment_name'),
              controller: _name,
              label: l10n.planName,
              hint: switch (_kind) {
                InvestmentKind.fund => l10n.investmentNameHintFund,
                InvestmentKind.stock => l10n.investmentNameHintStock,
                InvestmentKind.other => l10n.investmentNameHintOther,
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 10),
            SunriseTextField(
              key: const Key('investment_symbol'),
              controller: _symbol,
              label: l10n.investmentSymbol,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 18),
            SectionLabel(l10n.investmentFirstBuy),
            const SizedBox(height: 6),
            Text(
              l10n.investmentFirstBuyHint,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
            const SizedBox(height: 10),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('investment_account'),
                  icon: Symbols.account_balance_wallet_rounded,
                  title: l10n.planAccountEmi,
                  value: wallet?.name ?? l10n.cardNotSet,
                  onTap: () async {
                    final id = await pickTradeAccount(
                      context,
                      ref,
                      selected: _walletId,
                    );
                    if (id != null) setState(() => _walletId = id);
                  },
                ),
                SettingsRow(
                  key: const Key('investment_amount'),
                  icon: Symbols.payments_rounded,
                  title: l10n.investmentPaid,
                  value: _amount == 0
                      ? l10n.cardNotSet
                      : formatMoney(ref, context, _amount, currency),
                  onTap: () async {
                    final v = await askAmount(
                      context,
                      initial: _amount,
                      currency: currency,
                    );
                    if (v != null) setState(() => _amount = v);
                  },
                ),
                SettingsRow(
                  key: const Key('investment_fee'),
                  icon: Symbols.receipt_rounded,
                  title: l10n.investmentFee,
                  value: _fee == 0
                      ? l10n.planNone
                      : formatMoney(ref, context, _fee, currency),
                  onTap: () async {
                    final v = await askAmount(
                      context,
                      initial: _fee,
                      currency: currency,
                    );
                    if (v != null) setState(() => _fee = v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            SunriseTextField(
              key: const Key('investment_units'),
              controller: _units,
              label: l10n.investmentUnits,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            if (perUnit != null) ...[
              const SizedBox(height: 10),
              Text(
                l10n.investmentPerUnit(
                  formatMoney(ref, context, perUnit, currency),
                ),
                style: SunriseType.caption.copyWith(color: c.muted),
              ),
            ],
            const SizedBox(height: 20),
            SunriseButton(
              key: const Key('investment_save'),
              label: l10n.investmentSave,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
